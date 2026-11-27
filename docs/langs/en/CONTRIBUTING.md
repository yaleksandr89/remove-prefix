# Contributing

[Русский](../../../.github/CONTRIBUTING.md) | **English** | [Español](../es/CONTRIBUTING.md) | [中文](../zh/CONTRIBUTING.md) | [Français](../fr/CONTRIBUTING.md) | [Deutsch](../de/CONTRIBUTING.md)

Work on a separate branch and preserve the existing interactive interface and Bash 4.0+ / Windows PowerShell 5.1+ compatibility. Do not add dependencies or platforms without approval. Test with synthetic temporary directories, never user data. Keep all six translations in sync. Before a PR, run the applicable checks and `git diff --check`; report platforms, results and untested cases. Do not include personal paths, secrets or real files in logs.

## Linux/macOS (Bash)

```bash
bash -n scripts/remove_prefix.sh
bash -n tests/remove_prefix.Tests.sh
bash tests/remove_prefix.Tests.sh
```

## Windows (PowerShell)

```powershell
powershell.exe -NoProfile -File tests/remove_prefix.Tests.ps1
```

[Usage and examples](guides/usage.md) · [Report a bug or suggest an improvement](https://github.com/yaleksandr89/remove-prefix/issues) · [Security](SECURITY.md)
