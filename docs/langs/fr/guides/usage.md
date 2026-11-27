# Utilisation et exemples

[Scripts pour supprimer les préfixes des noms de fichiers et dossiers](../README.md)

Prérequis : Git pour cloner ; Windows 10/11 avec PowerShell 5.1 ou ultérieur, ou Linux/macOS avec Bash 4.0+ et `find`, `mv`, `ps`, `awk`, `date`, `bc`. Sur macOS, utilisez Bash 4.0+ depuis `PATH`, pas le `/bin/bash` 3.2 intégré.

**Les scripts modifient les noms sur le disque. Sauvegardez les données et testez d’abord sur une copie séparée. Ne les exécutez pas en tant qu’administrateur ou root sauf nécessité.**

## Windows (PowerShell)

```powershell
git clone https://github.com/yaleksandr89/remove-prefix.git
cd remove-prefix
.\scripts\remove_prefix.ps1
```

Si la stratégie d’exécution bloque un script local vérifié, utilisez `Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned` pour la session en cours si votre organisation l’autorise. N’ouvrez pas de terminal administrateur et ne définissez pas la stratégie utilisateur sur Unrestricted.

Saisissez les préfixes séparés par des virgules, puis le chemin du dossier. Par exemple, `ad_,pre_` et le chemin d’un répertoire de test. Le dossier racine n’est pas renommé.

![Accès au dossier scripts](../../../assets/go-to-scripts.gif)

![Exemple d’utilisation de PowerShell](../../../assets/how-use-windows.gif)

## Linux/macOS (Bash)

```bash
git clone https://github.com/yaleksandr89/remove-prefix.git
cd remove-prefix
bash scripts/remove_prefix.sh
```

Saisissez les préfixes séparés par des virgules, puis le chemin du dossier. Par exemple, `ad_,pre_` et le chemin d’un répertoire de test. Le dossier racine n’est pas renommé.

![Exemple d’utilisation de Bash](../../../assets/how-use-linux.gif)

## Ordre de traitement

Les préfixes sont appliqués dans l’ordre de saisie, en respectant la casse, uniquement au début du nom. Chaque préfixe est supprimé tant qu’il correspond. Avec `ad_,pre_`, `ad_ad_pre_photo.jpg` devient `photo.jpg`, tandis que `my_ad_photo.jpg` reste inchangé. Les éléments imbriqués sont traités avant les dossiers parents. N’utilisez pas de répertoires actifs, partagés ou système ; travaillez sur une arborescence stable sans renommages concurrents. Ne comptez pas sur un retour arrière automatique ni sur le traitement des éléments cachés sous Windows (PowerShell ne les énumère pas par défaut).

## Rapport

Le rapport présente la durée, la variation de l’utilisation mémoire et le nombre de fichiers et dossiers renommés avec succès. Examinez les erreurs et les conflits ; le rapport ne remplace pas la vérification du résultat. Les illustrations montrent des exemples de sorties antérieures, pas des valeurs garanties.

![Exemple de rapport Windows](../../../assets/windows-result.png)

![Exemple de rapport Linux](../../../assets/linux-result.png)

## Structure du projet

`scripts/` contient les deux utilitaires ; `tests/` les vérifications de régression ; `docs/assets/` la couverture et les démonstrations ; `docs/langs/` les traductions.
