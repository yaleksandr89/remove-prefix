# Contribuer

[Русский](../../../.github/CONTRIBUTING.md) | [English](../en/CONTRIBUTING.md) | [Español](../es/CONTRIBUTING.md) | [中文](../zh/CONTRIBUTING.md) | **Français** | [Deutsch](../de/CONTRIBUTING.md)

Travaillez sur une branche séparée et préservez l’interface interactive existante et la compatibilité Bash 4.0+ / Windows PowerShell 5.1+. N’ajoutez aucune dépendance ni plateforme sans accord. Testez sur des répertoires temporaires synthétiques, jamais sur des données utilisateur. Synchronisez les six traductions. Avant une PR, exécutez les vérifications applicables et `git diff --check` ; indiquez les plateformes, les résultats et les cas non testés. N’incluez pas de chemins personnels, de secrets ni de fichiers réels dans les journaux.

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

[Utilisation et exemples](guides/usage.md) · [Signaler un problème ou proposer une amélioration](https://github.com/yaleksandr89/remove-prefix/issues) · [Sécurité](SECURITY.md)
