# Mitwirken

[Русский](../../../.github/CONTRIBUTING.md) | [English](../en/CONTRIBUTING.md) | [Español](../es/CONTRIBUTING.md) | [中文](../zh/CONTRIBUTING.md) | [Français](../fr/CONTRIBUTING.md) | **Deutsch**

Arbeiten Sie in einem separaten Branch und erhalten Sie die bestehende interaktive Schnittstelle und Kompatibilität mit Bash 4.0+ / Windows PowerShell 5.1+. Fügen Sie keine Abhängigkeiten oder Plattformen ohne Zustimmung hinzu. Testen Sie mit synthetischen temporären Verzeichnissen, nicht mit Nutzerdaten. Halten Sie alle sechs Übersetzungen synchron. Führen Sie vor einem PR die relevanten Prüfungen und `git diff --check` aus; nennen Sie Plattformen, Ergebnisse und ungeprüfte Fälle. Geben Sie keine persönlichen Pfade, Geheimnisse oder echten Dateien in Protokollen an.

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

[Verwendung und Beispiele](guides/usage.md) · [Fehler melden oder Verbesserung vorschlagen](https://github.com/yaleksandr89/remove-prefix/issues) · [Sicherheit](SECURITY.md)
