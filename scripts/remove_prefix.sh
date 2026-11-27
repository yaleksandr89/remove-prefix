#!/bin/bash
set -o pipefail

get_current_memory() {
    ps -o rss= -p "$$" | LC_ALL=C awk '
        NF { printf "%.2f", $1/1024; found = 1 }
        END { if (!found) exit 1 }
    '
}

get_timestamp() {
    local timestamp
    # На BSD date дробный формат может содержать буквальное N.
    # On BSD date the fractional format may contain a literal N.
    if timestamp=$(date '+%s.%N' 2>/dev/null) && [[ $timestamp =~ ^[0-9]+\.[0-9]+$ ]]; then
        printf '%s\n' "$timestamp"
    elif timestamp=$(date '+%s') && [[ $timestamp =~ ^[0-9]+$ ]]; then
        printf '%s\n' "$timestamp"
    else
        return 1
    fi
}

if ! IFS= read -r -p "Введите префиксы, которые нужно удалить (через запятую): " prefixes_input; then
    printf 'Ошибка: Не удалось прочитать префиксы!\n' >&2
    exit 1
fi
IFS=',' read -ra raw_prefixes <<< "$prefixes_input"

prefixes=()
for prefix in "${raw_prefixes[@]}"; do
    prefix=${prefix#"${prefix%%[![:space:]]*}"}
    prefix=${prefix%"${prefix##*[![:space:]]}"}
    [[ -n $prefix ]] && prefixes+=("$prefix")
done

if (( ${#prefixes[@]} == 0 )); then
    printf 'Ошибка: Не указаны префиксы!\n' >&2
    exit 1
fi

if ! IFS= read -r -p "Введите путь к папке: " folder_path; then
    printf 'Ошибка: Не удалось прочитать путь к папке!\n' >&2
    exit 1
fi
if [[ ! -d $folder_path ]]; then
    printf 'Ошибка: Папка не существует!\n' >&2
    exit 1
fi
[[ $folder_path == /* ]] || folder_path=./$folder_path

for utility in find mv ps awk date bc; do
    if ! command -v "$utility" >/dev/null; then
        printf 'Ошибка: Не найдена необходимая команда %s!\n' "$utility" >&2
        exit 1
    fi
done

if ! start_time=$(get_timestamp) || ! start_memory=$(get_current_memory); then
    printf 'Ошибка: Не удалось получить начальные данные для отчёта!\n' >&2
    exit 1
fi
printf '\nЗапуск процесса переименования...\n'
processed_files=0
processed_folders=0
scan_complete=0
failed=0

while IFS= read -r -d '' path; do
    if [[ -z $path ]]; then
        scan_complete=1
        break
    fi

    name=${path##*/}
    dir=${path%/*}
    new_name=$name
    for prefix in "${prefixes[@]}"; do
        prefix_length=${#prefix}
        while [ "${new_name:0:prefix_length}" = "$prefix" ]; do
            new_name=${new_name:prefix_length}
        done
    done
    [[ $new_name != "$name" ]] || continue

    new_path=$dir/$new_name
    if [[ -z $new_name || $new_name == . || $new_name == .. ]]; then
        printf 'Ошибка: Недопустимое имя для %s\n' "$path" >&2
    elif [[ ! -e $path && ! -L $path ]]; then
        printf 'Не найден: %s\n' "$path" >&2
    elif [[ -e $new_path || -L $new_path ]]; then
        printf 'Конфликт: %s существует!\n' "$new_path" >&2
    elif mv -n -- "$path" "$new_path" && [[ ! -e $path && ! -L $path ]]; then
        if [[ ! -L $new_path && -d $new_path ]]; then
            ((processed_folders++))
            printf '[Папка] %s -> %s\n' "$path" "$new_path"
        else
            ((processed_files++))
            printf '[Файл]  %s -> %s\n' "$path" "$new_path"
        fi
        continue
    else
        printf 'Ошибка переименования: %s -> %s\n' "$path" "$new_path" >&2
    fi
    failed=1
# Пустая запись подтверждает завершение find без ошибок.
# An empty record confirms find finished successfully.
done < <(find "$folder_path" -depth -mindepth 1 -print0 && printf '\0')

if (( ! scan_complete )); then
    printf 'Ошибка: Не удалось полностью просканировать папку %s\n' "$folder_path" >&2
    failed=1
fi

printf '\nОтчёт:\n-----------------\n'
if end_time=$(get_timestamp) && end_memory=$(get_current_memory) &&
    time_diff=$(printf '%s - %s\n' "$end_time" "$start_time" | bc -l | LC_ALL=C awk '{printf "%.3f", $1}') &&
    memory_diff=$(printf '%s - %s\n' "$end_memory" "$start_memory" | bc -l | LC_ALL=C awk '{printf "%.2f", $1}') &&
    [[ -n $time_diff && -n $memory_diff ]]; then
    printf 'Время выполнения: %s сек.\nИспользовано памяти: %s МБ\n' "$time_diff" "$memory_diff"
else
    printf 'Ошибка: Не удалось вычислить время выполнения или использование памяти!\n' >&2
    failed=1
fi
printf 'Обработано папок: %s\nОбработано файлов: %s\n' "$processed_folders" "$processed_files"

if (( failed )); then
    printf '\nОбработка завершена с ошибками.\n' >&2
    exit 1
fi
printf '\nГотово! Префиксы удалены.\n\n'
