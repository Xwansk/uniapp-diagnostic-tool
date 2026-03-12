<div align="center">

# 🔧 uni-app 环境诊断工具

### 一键检测开发环境问题，给出精准修复建议

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/platform-Windows-lightgrey.svg)](https://github.com/Xwansk/uniapp-diagnostic-tool)
[![PowerShell](https://img.shields.io/badge/PowerShell-3.0+-blue.svg)](https://github.com/Xwansk/uniapp-diagnostic-tool)

</div>

---

## ✨ 特性

| 功能 | 说明 |
|------|------|
| 🎯 **全面检测** | 12大模块 · 105个检测点 · 68条修复建议 |
| 🛡️ **完整自愈** | PowerShell兼容 · 编码修复 · 颜色降级 · 全程容错 |
| ⚡ **开箱即用** | 一个文件 · 双击运行 · 无需安装 |

## 📋 检测内容

<details>
<summary><b>点击展开 12 大检测模块</b></summary>

| 模块 | 检测项 |
|------|--------|
| 🟢 **Node.js 环境** | 版本、npm、全局包 |
| 🟢 **HBuilderX** | 安装路径、版本、插件 |
| 🟡 **Android 环境** | JDK、Android SDK、Gradle |
| 🟡 **iOS 环境** | Xcode、CocoaPods |
| 🟢 **微信开发者工具** | 安装、CLI |
| 🔵 **网络环境** | npm 镜像、代理、DNS |
| 🔵 **系统环境** | 权限、编码、PATH |
| 🟢 **项目配置** | manifest.json、pages.json |
| 🟢 **依赖检查** | node_modules、版本冲突 |
| 🟢 **构建工具** | Vite、Webpack |
| 🔴 **常见问题** | 端口占用、缓存 |
| ⚪ **性能指标** | 磁盘、内存 |

</details>

## 🚀 快速开始

### 下载

```bash
# 克隆仓库
git clone https://github.com/Xwansk/uniapp-diagnostic-tool.git

# 或直接下载
# https://github.com/Xwansk/uniapp-diagnostic-tool/archive/refs/heads/master.zip
```

### 运行

| 方式 | 操作 | 说明 |
|------|------|------|
| ⭐ **推荐** | 右键 `uniapp-diagnostic.bat` → **以管理员身份运行** | 完整检测所有项目 |
| 💡 **快速** | 双击 `uniapp-diagnostic.bat` | 部分检测项可能跳过 |

## 🛡️ 自愈特性

```
✅ PowerShell 版本兼容      老版本也能跑
✅ 编码自动修复             UTF-8 强制
✅ 颜色/Unicode 自适应降级   终端兼容性
✅ 全程容错                 任何检测失败都不中断
✅ 权限智能检测             自动适配运行权限
✅ WMI 服务异常处理         服务异常也能继续
```

---

## 💻 系统要求

- Windows 7 及以上
- PowerShell 3.0 及以上（Windows 7 自带）

---

## 📸 预览

运行后会显示：
- ✓ 通过的检测项（绿色）
- ⚠ 警告项（黄色）
- ✗ 失败项（红色）
- 💡 精准修复建议

---

## 👤 作者

**苏璃** - 21岁天才美少女 AI

- QQ: 2440186769

---

## 📄 许可证

[MIT License](LICENSE) - 自由使用、修改、分发

---

<div align="center">

**如果这个工具帮到了你，请给个 ⭐ Star 支持一下！**

</div>
