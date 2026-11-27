#!/usr/bin/env bash
set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../scripts" && pwd)
script="$script_dir/remove_prefix.sh"
if (( BASH_VERSINFO[0] < 4 )); then
    printf '%s\n' 'Bash 4.0+ is required.' >&2
    exit 1
fi
command -v bc >/dev/null

# RU: Все операции выполняются только в уникальном временном каталоге.
# EN: All operations are confined to a unique temporary directory.
scratch=$(mktemp -d)
trap 'rm -rf -- "$scratch"' EXIT
log="$scratch/output.log"

fail() {
    printf 'FAIL: %s\n' "$1" >&2
    exit 1
}

run_case() {
    local prefixes=$1 folder=$2 expected=$3 status=0
    printf '%s\n%s\n' "$prefixes" "$folder" | "$BASH" "$script" > "$log" 2>&1 || status=$?
    cat "$log"
    if [[ $expected == success ]]; then
        (( status == 0 )) || fail "unexpected exit: $status"
    else
        (( status != 0 )) || fail 'failure was reported as success'
    fi
}

check_bytes() {
    local path=$1 expected=$2
    [[ -f $path && ! -L $path ]] || fail "missing regular file: $path"
    cmp -s "$path" <(printf '%s' "$expected") || fail "changed content: $path"
}

mkdir -p "$scratch/ad_root/ad_folder/ad_nested"
printf A > "$scratch/ad_root/ad_folder/ad_nested/ad_ad_pre_photo.jpg"
printf B > "$scratch/ad_root/my_ad_photo.jpg"
printf C > "$scratch/ad_root/AD_upper"
printf D > "$scratch/ad_root/pre_ad_order"
printf E > "$scratch/ad_root/"$'ad_line\n'
run_case ' ad_ , ,pre_ ' "$scratch/ad_root" success
check_bytes "$scratch/ad_root/folder/nested/photo.jpg" A
check_bytes "$scratch/ad_root/my_ad_photo.jpg" B
check_bytes "$scratch/ad_root/AD_upper" C
check_bytes "$scratch/ad_root/ad_order" D
check_bytes "$scratch/ad_root/"$'line\n' E
[[ ! -e "$scratch/ad_root/ad_folder" ]] || fail 'old directory still present'
grep -Fx 'Обработано папок: 2' "$log" >/dev/null
grep -Fx 'Обработано файлов: 3' "$log" >/dev/null
grep -E 'Время выполнения: [0-9]+([.,][0-9]+)? сек\.' "$log" >/dev/null

relative_root='-root [literal]\path  '
mkdir "$scratch/$relative_root"
printf F > "$scratch/$relative_root/quo'te_file"
printf G > "$scratch/$relative_root/back\slash_other"
(cd -- "$scratch" && run_case "quo'te_,back\\slash_" "$relative_root" success)
check_bytes "$scratch/$relative_root/file" F
check_bytes "$scratch/$relative_root/other" G

mkdir -p "$scratch/conflicts/name-dir" "$scratch/conflicts/ad_name-dir"
printf original > "$scratch/conflicts/name"
printf source > "$scratch/conflicts/ad_name"
printf nested > "$scratch/conflicts/ad_name-dir/keep"
printf link-source > "$scratch/conflicts/ad_dangling"
ln -s absent "$scratch/conflicts/dangling"
ln -s name-dir "$scratch/conflicts/dir-link"
printf link-target > "$scratch/conflicts/ad_dir-link"
printf empty > "$scratch/conflicts/ad_"
printf dot > "$scratch/conflicts/ad_."
printf good > "$scratch/conflicts/ad_good"
run_case 'ad_' "$scratch/conflicts" failure
check_bytes "$scratch/conflicts/name" original
check_bytes "$scratch/conflicts/ad_name" source
check_bytes "$scratch/conflicts/ad_name-dir/keep" nested
[[ ! -e "$scratch/conflicts/name-dir/ad_name-dir" ]] || fail 'source moved into destination directory'
[[ -L "$scratch/conflicts/dangling" && $(readlink "$scratch/conflicts/dangling") == absent ]] || fail 'dangling destination replaced'
check_bytes "$scratch/conflicts/ad_dangling" link-source
[[ -L "$scratch/conflicts/dir-link" && $(readlink "$scratch/conflicts/dir-link") == name-dir ]] || fail 'directory symlink replaced'
check_bytes "$scratch/conflicts/ad_dir-link" link-target
[[ ! -e "$scratch/conflicts/name-dir/ad_dir-link" ]] || fail 'source moved through destination symlink'
check_bytes "$scratch/conflicts/ad_" empty
check_bytes "$scratch/conflicts/ad_." dot
check_bytes "$scratch/conflicts/good" good
grep -Fx 'Обработано файлов: 1' "$log" >/dev/null
grep -Fx 'Обработано папок: 0' "$log" >/dev/null

mkdir "$scratch/links" "$scratch/outside"
printf untouched > "$scratch/outside/ad_external"
ln -s "$scratch/outside" "$scratch/links/ad_link"
ln -s missing "$scratch/links/ad_broken"
run_case 'ad_' "$scratch/links" success
[[ -L "$scratch/links/link" && -L "$scratch/links/broken" ]] || fail 'source symlink not renamed'
check_bytes "$scratch/outside/ad_external" untouched
[[ ! -e "$scratch/outside/external" ]] || fail 'traversed a symlink'

if (( EUID != 0 )); then
    mkdir -p "$scratch/permissions/unreadable" "$scratch/permissions/read-only"
    printf scan > "$scratch/permissions/unreadable/ad_scan"
    printf rename > "$scratch/permissions/read-only/ad_rename"
    printf good > "$scratch/permissions/ad_keep-going"
    (
        # Возвращаем права только двум каталогам этого теста перед общей очисткой.
        # Restore permissions only on these two fixture directories before cleanup.
        trap 'chmod u+rwx "$scratch/permissions/unreadable" "$scratch/permissions/read-only"' EXIT
        chmod u-rwx "$scratch/permissions/unreadable"
        chmod u-w "$scratch/permissions/read-only"
        run_case 'ad_' "$scratch/permissions" failure
        grep -F 'Не удалось полностью просканировать папку' "$log" >/dev/null
        grep -F 'Ошибка переименования:' "$log" >/dev/null
        grep -Fx 'Обработано файлов: 1' "$log" >/dev/null
        grep -Fx 'Обработано папок: 0' "$log" >/dev/null
    )
    check_bytes "$scratch/permissions/unreadable/ad_scan" scan
    check_bytes "$scratch/permissions/read-only/ad_rename" rename
    check_bytes "$scratch/permissions/keep-going" good
    [[ ! -e "$scratch/permissions/read-only/rename" && ! -e "$scratch/permissions/unreadable/scan" ]] ||
        fail 'renamed an entry in a protected directory'
else
    printf 'NOT RUN: permission failures require an unprivileged user.\n'
fi

mkdir "$scratch/empty"
run_case 'ad_' "$scratch/empty" success
run_case ' , ' "$scratch/empty" failure
run_case 'ad_' "$scratch/not-found" failure
printf 'Bash regression tests passed.\n'
