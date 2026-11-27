# Scripts para eliminar prefijos de nombres de archivos y carpetas

[![Source Code](https://img.shields.io/badge/source-yaleksandr89%2Fremove--prefix-blue.svg?style=flat-square)](https://github.com/yaleksandr89/remove-prefix)
[![Bash 4.0+](https://img.shields.io/badge/Bash-4.0%2B-4EAA25.svg?style=flat-square)](guides/usage.md)
[![PowerShell 5.1+](https://img.shields.io/badge/PowerShell-5.1%2B-5391FE.svg?style=flat-square)](guides/usage.md)
[![CI](https://github.com/yaleksandr89/remove-prefix/actions/workflows/ci.yml/badge.svg)](https://github.com/yaleksandr89/remove-prefix/actions/workflows/ci.yml)
[![MIT](https://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat-square)](../../../LICENSE.md)

![Remove Prefix: eliminación masiva de prefijos con Bash y PowerShell](../../assets/remove-prefix-readme-cover.png)

[Русский](../../../README.md) | [English](../en/README.md) | **Español** | [中文](../zh/README.md) | [Français](../fr/README.md) | [Deutsch](../de/README.md)

## Descripción

Remove Prefix elimina recursivamente los prefijos iniciales indicados de los nombres de archivos y carpetas de un directorio seleccionado. Sirve para limpiar nombres de archivos descargados, simplificar estructuras de proyectos y automatizar cambios de nombre repetitivos.

- Varios prefijos por ejecución; los prefijos iniciales repetidos se eliminan en secuencia.
- Bash para Linux y macOS, PowerShell para Windows.
- Informe con tiempo de ejecución, uso de memoria y cantidad de archivos y carpetas renombrados.

## Cómo funciona

```mermaid
flowchart TD
    A["Prefijos y carpeta"]
    B["Recorrido de abajo<br/>hacia arriba"]
    C["Eliminar prefijos iniciales<br/>y renombrar"]
    D["Informe: éxitos y errores"]

    A --> B --> C --> D
```

## Inicio rápido

Requisitos: Git para clonar; Windows 10/11 con PowerShell 5.1 o posterior, o Linux/macOS con Bash 4.0+ y `find`, `mv`, `ps`, `awk`, `date`, `bc`. En macOS utilice Bash 4.0+ desde `PATH`, no el `/bin/bash` 3.2 integrado.

**Los scripts cambian nombres en el disco. Haga una copia de seguridad y pruebe primero en una copia separada. No los ejecute como administrador o root salvo que sea necesario.**

### Windows (PowerShell)

```powershell
git clone https://github.com/yaleksandr89/remove-prefix.git
cd remove-prefix
.\scripts\remove_prefix.ps1
```

### Linux/macOS (Bash)

```bash
git clone https://github.com/yaleksandr89/remove-prefix.git
cd remove-prefix
bash scripts/remove_prefix.sh
```

Introduzca los prefijos separados por comas y después la ruta de la carpeta. Por ejemplo, `ad_,pre_` y la ruta de un directorio de prueba. La carpeta raíz no se renombra.

## Documentación

- [Uso y ejemplos](guides/usage.md)
- [Contribuir](CONTRIBUTING.md)
- [Seguridad](SECURITY.md)

## Comentarios y ayuda

- [Informar de un error o proponer una mejora](https://github.com/yaleksandr89/remove-prefix/issues)
- [Debates y preguntas](https://github.com/yaleksandr89/remove-prefix/discussions)
- [Informar de una vulnerabilidad](SECURITY.md)

<p align="center">Si el proyecto le resultó útil, dele una estrella en GitHub para que otros desarrolladores puedan encontrarlo. 🤘</p>
