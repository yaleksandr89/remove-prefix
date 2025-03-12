# Scripts pour supprimer les préfixes des noms de fichiers et dossiers

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

## Choisissez la Langue :

| Русский  | English                              | Español                              | 中文                              | Français                              | Deutsch                              |
|----------|--------------------------------------|--------------------------------------|---------------------------------|---------------------------------------|--------------------------------------|
| [Русский](../../README.md) | [English](./README_en.md) | [Español](./README_es.md) | [中文](./README_zh.md) | **Sélectionné** | [Deutsch](./README_de.md) |

## Description

Ces scripts permettent de supprimer en masse des préfixes spécifiques des noms de fichiers et dossiers. Ils traitent récursivement tous les éléments dans le répertoire sélectionné, y compris les sous-dossiers. Compatibilité :
- Suppression de plusieurs préfixes en une seule exécution.
- Fonctionne sous `Linux/macOS` (via `Bash`) et `Windows` (via `PowerShell`).
- Génère un rapport sur la durée d'exécution, la mémoire utilisée et les statistiques.

## Objectifs et utilisations

Les scripts sont conçus pour :

- Nettoyer les noms de fichiers téléchargés (par ex. suppression de tags publicitaires).
- Simplifier la structure des projets.
- Automatiser les tâches répétitives.

## Structure du projet

```text
.
├── assets/                 # Exemples d'utilisation et résultats des scripts
├── langs/                  # Traductions de README.md
├── scripts/
│   ├── remove_prefix.sh    # Script pour Linux/macOS
│   └── remove_prefix.ps1   # Script pour Windows
├── LICENSE.md
└── README.md
```

## Instructions d'utilisation

### Windows (PowerShell)

- Cloner le dépôt : `git clone git@github.com:yaleksandr89/remove-prefix.git`.
- Ouvrir le terminal et naviguer dans le dossier `scripts/`.

![go-to-scripts.gif](../assets/go-to-scripts.gif)

- Autoriser l'exécution des scripts (si nécessaire). Lancer le terminal en mode administrateur, puis exécuter (après exécution, vous pouvez rétablir la politique avec `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`) :
```shell
Set-ExecutionPolicy Unrestricted -Scope CurrentUser
```
- Exécuter le script :
```shell
.\remove_prefix.ps1
```
- Suivre les instructions :
    - Saisir la liste des préfixes à supprimer (séparés par des virgules).
    - Indiquer le chemin du dossier.
- Attendre la fin du traitement.

![how-use-windows.gif](../assets/how-use-windows.gif)

### Linux/macOS (Bash)

- Cloner le dépôt : `git clone git@github.com:yaleksandr89/remove-prefix.git`.
- Ouvrir le terminal et aller dans le dossier des scripts.
- Donner les permissions d'exécution au script :
```bash
chmod +x remove_prefix.sh
```
- Exécuter le script :
```bash
./remove_prefix.sh
```
- Suivre les instructions :
    - Saisir la liste des préfixes à supprimer.
    - Indiquer le chemin du dossier.
- Attendre la fin du traitement.

![how-use-linux.gif](../assets/how-use-linux.gif)

## Rapport

Une fois le script terminé, il affichera :

- Le temps d'exécution.
- La mémoire utilisée.
- Le nombre de fichiers et dossiers traités.

Sous Windows :

![windows-result.png](../assets/windows-result.png)

Sous Linux :

![linux-result.png](../assets/linux-result.png)

## Compatibilité

- Windows 10/11 (PowerShell 5.1 ou version ultérieure)
- Linux (bash 4.0+)
- macOS (bash 4.0+)