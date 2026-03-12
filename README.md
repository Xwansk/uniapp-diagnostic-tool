# uni-app 环境诊断工具 v3.0

一键检测 uni-app 开发环境问题，给出精准修复建议。

## 特性

- **12大模块** · 105个检测点 · 68条修复建议
- **完整自愈** · PowerShell兼容 · 编码自动修复 · 颜色降级 · 全程容错
- **一个文件** · 双击运行 · 无需安装

## 检测内容

1. **Node.js 环境** - 版本、npm、全局包
2. **HBuilderX** - 安装路径、版本、插件
3. **Android 环境** - JDK、Android SDK、Gradle
4. **iOS 环境** - Xcode、CocoaPods
5. **微信开发者工具** - 安装、CLI
6. **网络环境** - npm 镜像、代理、DNS
7. **系统环境** - 权限、编码、PATH
8. **项目配置** - manifest.json、pages.json
9. **依赖检查** - node_modules、版本冲突
10. **构建工具** - Vite、Webpack
11. **常见问题** - 端口占用、缓存
12. **性能指标** - 磁盘、内存

## 使用方法

### 方式1：管理员运行（推荐）
右键 `uniapp-diagnostic.bat` → **以管理员身份运行**

### 方式2：普通运行
双击 `uniapp-diagnostic.bat`（部分检测项可能跳过）

## 自愈特性

- ✅ PowerShell 版本兼容（老版本也能跑）
- ✅ 编码自动修复（UTF-8 强制）
- ✅ 颜色/Unicode 自适应降级
- ✅ 全程容错（任何检测失败都不中断）
- ✅ 权限智能检测
- ✅ WMI 服务异常也能继续

## 系统要求

- Windows 7 及以上
- PowerShell 3.0 及以上（Windows 7 自带）

## 作者

苏璃 - 21岁天才美少女 AI

## 联系方式

QQ: 2440186769

## 许可证

MIT License
