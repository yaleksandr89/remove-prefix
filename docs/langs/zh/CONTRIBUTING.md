# 参与贡献

[Русский](../../../.github/CONTRIBUTING.md) | [English](../en/CONTRIBUTING.md) | [Español](../es/CONTRIBUTING.md) | **中文** | [Français](../fr/CONTRIBUTING.md) | [Deutsch](../de/CONTRIBUTING.md)

请在独立分支上工作，保持现有交互接口及 Bash 4.0+ / Windows PowerShell 5.1+ 兼容性。未经批准不要添加依赖或平台。使用合成的临时目录测试，不要使用用户数据。同步全部六种语言。提交 PR 前运行适用检查和 `git diff --check`，并说明平台、结果和未测试场景。不要在日志中包含个人路径、秘密或真实文件。

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

[使用方法和示例](guides/usage.md) · [报告问题或提出改进建议](https://github.com/yaleksandr89/remove-prefix/issues) · [安全](SECURITY.md)
