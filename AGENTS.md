# Remove Prefix — repository instructions

## Contract and implementation

- This is an existing, released interactive utility for recursively removing leading prefixes from file and directory names. Keep `scripts/remove_prefix.sh` (Linux/macOS, Bash 4.0+) and `scripts/remove_prefix.ps1` (Windows 10/11, PowerShell 5.1+) and their Russian prompts and reports. No framework, new language, native helper, compiler, dependency, CLI option or platform without owner approval.
- Prefixes are comma-separated, trimmed, nonempty, literal and case-sensitive; apply in input order, repeatedly for each prefix. Preserve internal matches and the selected root. Process descendants before parents. Rename within the same parent; do not replace existing destinations or report failed renames as successes. Keep the existing PowerShell hidden-item selection. Do not imply transactionality, rollback or arbitrary concurrency protection.
- Keep identifiers English and meaningful comments in Russian then English where changed. Bash uses LF; PowerShell uses UTF-8 BOM for non-ASCII text and CRLF in the working tree (LF in Git). Keep Windows PowerShell 5.1 syntax; do not assume GNU-only tools on macOS. Existing Bash utilities are ordinary system commands and `bc`; do not introduce new installation requirements.
- Filesystem inputs are local user input, not a sandbox. Use literal paths, preserve names/contents, avoid traversing outside the selected tree, detect actual conflicts and failures. Run write-producing tests only in uniquely owned synthetic temporary directories with ordinary user rights. No production/shared data, secrets, broad chmod/chown/delete or speculative concurrency controls.

## Checks and support

- Run `bash -n scripts/remove_prefix.sh`, `bash -n tests/remove_prefix.Tests.sh`, `bash tests/remove_prefix.Tests.sh` on Linux/macOS with Bash 4.0+ and the existing utilities. Run `powershell.exe -NoProfile -File tests/remove_prefix.Tests.ps1` on Windows PowerShell 5.1. Keep regression assertions meaningful; report unavailable platforms as NOT RUN. Consume full command output before assertions under pipefail.
- Keep CI job names and established checks; PR and master push plus manual dispatch, read-only permissions, pinned actions. Do not add external coverage uploads or public coverage badges. Test real supported behavior; no fake green checks.
- Maintain root Russian README, `.github/CONTRIBUTING.md` and `.github/SECURITY.md`, five translated equivalents and thematic guides in `docs/langs/`. Keep the existing license, support files, examples, localized links and approved assets. README: badges, light cover, language navigation, quick start, documentation/support links, centered star CTA with 🤘 as the only decorative emoji exception. Dark Social preview is owner-managed metadata. Do not silently alter published contracts; obtain owner decision for breaking changes.

## Git and scope

- GIT-FIRST. Read actual root, HEAD/index, remote and applicable files before changes. Work within the approved scope; preserve unrelated owner edits and staged state. No speculative architecture or dependencies. If an in-scope risk requires a new product decision, stop only the dependent part and complete independent changes.
- Remote READ_ONLY_FOR_AI. No commit, push, PR creation, merge, tag, release, production action, `gh`, reset, restore, clean, stash, rebase, force or destructive Git operation without explicit authorization where applicable. Owner performs Git publication and GitHub settings changes.
- Review the whole batch, full diff and `git diff --check` (including staged changes), tests and final state. Report actual evidence, failures and unverified platforms; never claim a check ran if it did not. Use one consolidated correction, not repeated file-by-file patches. Owner reviews before signed commit, push and PR; verify exact merged SHA and CI before signed tag/release.
