# Участие в разработке

**Русский** | [English](https://github.com/yaleksandr89/remove-prefix/blob/master/docs/langs/en/CONTRIBUTING.md) | [Español](https://github.com/yaleksandr89/remove-prefix/blob/master/docs/langs/es/CONTRIBUTING.md) | [中文](https://github.com/yaleksandr89/remove-prefix/blob/master/docs/langs/zh/CONTRIBUTING.md) | [Français](https://github.com/yaleksandr89/remove-prefix/blob/master/docs/langs/fr/CONTRIBUTING.md) | [Deutsch](https://github.com/yaleksandr89/remove-prefix/blob/master/docs/langs/de/CONTRIBUTING.md)

Работайте с отдельной веткой, сохраняйте существующий интерактивный интерфейс и совместимость Bash 4.0+ / Windows PowerShell 5.1+. Не добавляйте зависимости или новые платформы без согласования. Проверяйте изменения на синтетических временных каталогах, не на пользовательских данных. Синхронизируйте все шесть локализаций. Перед PR запустите соответствующие проверки, проверьте `git diff --check` и укажите платформы, результаты и непроверенные сценарии. Не включайте личные пути, секреты и реальные файлы в логи.

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

[Использование и примеры](https://github.com/yaleksandr89/remove-prefix/blob/master/docs/langs/ru/guides/usage.md) · [Сообщить об ошибке или предложить улучшение](https://github.com/yaleksandr89/remove-prefix/issues) · [Безопасность](https://github.com/yaleksandr89/remove-prefix/blob/master/.github/SECURITY.md)
