# Usage and examples

[Scripts for removing prefixes from file and folder names](../README.md)

Requirements: Git to clone; Windows 10/11 with PowerShell 5.1 or later, or Linux/macOS with Bash 4.0+ and `find`, `mv`, `ps`, `awk`, `date`, `bc`. On macOS use Bash 4.0+ from `PATH`, not the built-in `/bin/bash` 3.2.

**The scripts change names on disk. Back up your data and test on a separate copy first. Do not run as administrator or root unless necessary.**

## Windows (PowerShell)

```powershell
git clone https://github.com/yaleksandr89/remove-prefix.git
cd remove-prefix
.\scripts\remove_prefix.ps1
```

If execution policy blocks a reviewed local script, use `Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned` for the current session if your organization permits it. Do not start an administrator terminal or set the user policy to Unrestricted.

Enter comma-separated prefixes, then the folder path. For example, `ad_,pre_` and the path to a test directory. The root folder itself is not renamed.

![Navigate to scripts](../../../assets/go-to-scripts.gif)

![PowerShell usage example](../../../assets/how-use-windows.gif)

## Linux/macOS (Bash)

```bash
git clone https://github.com/yaleksandr89/remove-prefix.git
cd remove-prefix
bash scripts/remove_prefix.sh
```

Enter comma-separated prefixes, then the folder path. For example, `ad_,pre_` and the path to a test directory. The root folder itself is not renamed.

![Bash usage example](../../../assets/how-use-linux.gif)

## Processing order

Prefixes are applied in input order, case-sensitively and only at the start of a name. Each prefix is removed repeatedly while it matches. For example, with `ad_,pre_`, `ad_ad_pre_photo.jpg` becomes `photo.jpg`, while `my_ad_photo.jpg` stays unchanged. Nested items are processed before parent folders. Do not use active, shared or system directories; work on a stable tree with no concurrent renames. Do not rely on automatic rollback or processing Windows hidden items (PowerShell does not enumerate them by default).

## Report

The report shows elapsed time, change in memory usage and the number of successfully renamed files and folders. Review errors and conflicts; the report does not replace checking the result. The illustrations below show earlier example output, not guaranteed values.

![Windows report example](../../../assets/windows-result.png)

![Linux report example](../../../assets/linux-result.png)

## Project structure

`scripts/` contains the two utilities; `tests/` contains regression checks; `docs/assets/` contains the cover and demonstrations; `docs/langs/` contains translations.
