# Skripte zum Entfernen von Praefixen aus Dateinamen und Ordnernamen

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

## Sprache wählen:

| Русский | English                   | Español | 中文 | Français | **Deutsch** |
|---------|---------------------------|---------|---------|----------|---------|
| [Русский](../README.md) | [English](./README_en.md) | [Español](./README_es.md) | [中文](./README_zh.md) | [Français](./README_fr.md) | **Ausgewählt** |

## Beschreibung

Diese Skripte ermöglichen das massenhafte Entfernen bestimmter Präfixe aus Dateinamen und Ordnernamen. Sie verarbeiten rekursiv alle Elemente im gewählten Verzeichnis, einschließlich Unterordner. Unterstützte Funktionen:
- Entfernung mehrerer Präfixe in einem Durchlauf.
- Kompatibilität mit `Linux/macOS` (Bash) und `Windows` (PowerShell).
- Erstellung eines Berichts mit Laufzeit, Speichernutzung und Statistik.

## Zweck und Anwendung

Die Skripte sind für folgende Zwecke gedacht:

- Bereinigung von Dateinamen nach dem Herunterladen (z. B. Entfernen von Werbetags).
- Vereinfachung der Projektstruktur.
- Automatisierung wiederkehrender Aufgaben.

## Projektstruktur

```text
.
├── assets/                 # Beispiele für die Nutzung und Ergebnisse der Skripte
├── langs/                  # Lokalisierung der README.md in andere Sprachen
├── scripts/
│   ├── remove_prefix.sh    # Skript für Linux/macOS
│   └── remove_prefix.ps1   # Skript für Windows
├── LICENSE.md
└── README.md
```
## Verwendung

### Windows (PowerShell)

- Repository klonen: `git clone git@github.com:yaleksandr89/remove-prefix.git`
- Terminal öffnen und in das `scripts/`-Verzeichnis wechseln

![go-to-scripts.gif](../assets/go-to-scripts.gif)

- Skriptausführung erlauben (falls erforderlich). Starten Sie das Terminal als Administrator (die Sicherheitseinstellung kann danach zurückgesetzt werden: `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`):
```powershell
Set-ExecutionPolicy Unrestricted -Scope CurrentUser
```
- Skript starten:
```powershell
.\remove_prefix.ps1
```
- Anweisungen auf dem Bildschirm folgen:
    - Liste der Präfixe eingeben (getrennt durch Kommas).
    - Pfad zum Verzeichnis angeben.
- Auf Abschluss der Skriptausführung warten.

![how-use-windows.gif](../assets/how-use-windows.gif)

### Linux/macOS (Bash)

- Repository klonen: `git clone git@github.com:yaleksandr89/remove-prefix.git`
- Terminal öffnen und ins Skriptverzeichnis wechseln:

- Skript ausführbar machen:
```bash
chmod +x remove_prefix.sh
```
- Skript starten:
```bash
./remove_prefix.sh
```
- Anweisungen auf dem Bildschirm folgen:
    - Liste der Präfixe eingeben (getrennt durch Kommas).
    - Pfad zum Verzeichnis angeben.
- Auf Abschluss der Skriptausführung warten.

![how-use-linux.gif](../assets/how-use-linux.gif)

## Bericht

Nach Abschluss zeigt das Skript folgende Informationen:

- Laufzeit.
- Speicherverbrauch.
- Anzahl der verarbeiteten Dateien und Ordner.

Für Windows:

![windows-result.png](../assets/windows-result.png)

Für Linux:

![linux-result.png](../assets/linux-result.png)

## Kompatibilität

- Windows 10/11 (PowerShell 5.1 oder höher)
- Linux (bash 4.0+)
- macOS (bash 4.0+)