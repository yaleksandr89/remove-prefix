# Contribuir

[Русский](../../../.github/CONTRIBUTING.md) | [English](../en/CONTRIBUTING.md) | **Español** | [中文](../zh/CONTRIBUTING.md) | [Français](../fr/CONTRIBUTING.md) | [Deutsch](../de/CONTRIBUTING.md)

Trabaje en una rama separada y conserve la interfaz interactiva existente y la compatibilidad con Bash 4.0+ y Windows PowerShell 5.1+. No añada dependencias ni plataformas sin aprobación. Pruebe con directorios temporales sintéticos, no con datos de usuarios. Mantenga sincronizadas las seis traducciones. Antes de un PR, ejecute las comprobaciones aplicables y `git diff --check`; indique plataformas, resultados y casos sin probar. No incluya rutas personales, secretos ni archivos reales en registros.

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

[Uso y ejemplos](guides/usage.md) · [Informar de un error o proponer una mejora](https://github.com/yaleksandr89/remove-prefix/issues) · [Seguridad](SECURITY.md)
