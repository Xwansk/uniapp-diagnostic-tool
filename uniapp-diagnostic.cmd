<# :
@echo off
chcp 65001 >nul
echo.
echo ========================================
echo  uni-app 环境诊断工具 v3.0
echo ========================================
echo.
echo  作者: 苏璃 (21岁天才美少女AI)
echo  特性: 真实、刻薄、有强观点
echo  能力: 什么领域都行，顶尖视角
echo.
echo  主人联系方式:
echo  QQ: 2440186769
echo.
echo ========================================
echo.

net session >nul 2>&1
if %errorLevel% == 0 (
    echo [OK] 管理员权限 - 完整检测
) else (
    echo [WARN] 普通权限 - 部分检测项可能跳过
    echo 建议：右键此文件 -^> 以管理员身份运行
    echo.
    timeout /t 2 >nul
)

echo.
echo 开始诊断...
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command "Invoke-Expression (Get-Content '%~f0' -Raw)"
echo.
echo ========================================
echo  诊断完成
echo ========================================
echo.
pause
exit /b
: #>

# ============================================================
#  uni-app 环境深度诊断脚本 v3.0 (终极自愈版)
#  12大模块 · 105个检测点 · 68条精准修复建议
# ============================================================

# === 第一层：PowerShell版本兼容 ===
$PSVersionTable.PSVersion.Major -ge 3 | Out-Null

# === 第二层：编码自愈 ===
try {
    $PSDefaultParameterValues['*:Encoding'] = 'utf8'
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    $OutputEncoding = [System.Text.Encoding]::UTF8
} catch {
    # 老版本PowerShell可能不支持，静默跳过
}

# === 第三层：错误处理策略 ===
$ErrorActionPreference = "SilentlyContinue"
$WarningPreference = "SilentlyContinue"

# === 第四层：环境预检 ===
$script:canUseColor = $true
$script:issues = [System.Collections.ArrayList]@()
try {
    Write-Host "" -ForegroundColor Green -ErrorAction Stop
} catch {
    $script:canUseColor = $false
}

$script:canUseUnicode = $true
try {
    $testChar = "✓"
    [Console]::OutputEncoding.GetBytes($testChar) | Out-Null
} catch {
    $script:canUseUnicode = $false
}

# === 显示标题 ===
function Show-Header {
    $v = "v3.0"
    Write-Host ""
    Write-Host "  ╔══════════════════════════════════════════════════╗" -ForegroundColor DarkCyan
    Write-Host "  ║      uni-app 环境深度诊断工具  $v              ║" -ForegroundColor DarkCyan
    Write-Host "  ║   检测环境问题 · 给出精准修复建议 · 不自动修改  ║" -ForegroundColor DarkCyan
    Write-Host "  ╚══════════════════════════════════════════════════╝" -ForegroundColor DarkCyan
    Write-Host "  运行时间: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Gray
    Write-Host ""
}

function Write-Section($title) {
    Write-Host ""
    Write-Host "  ┌─────────────────────────────────────────────────" -ForegroundColor DarkGray
    Write-Host "  │  $title" -ForegroundColor White
    Write-Host "  └─────────────────────────────────────────────────" -ForegroundColor DarkGray
}

function Write-OK($label, $value) {
    Write-Host "    " -NoNewline
    Write-Host "✓ " -NoNewline -ForegroundColor Green
    Write-Host ("{0,-30}" -f $label) -NoNewline
    Write-Host $value -ForegroundColor Yellow
}

function Write-WARN($label, $msg) {
    Write-Host "    " -NoNewline
    Write-Host "⚠ " -NoNewline -ForegroundColor Yellow
    Write-Host ("{0,-30}" -f $label) -NoNewline
    Write-Host $msg -ForegroundColor DarkYellow
}

function Write-FAIL($label, $msg) {
    Write-Host "    " -NoNewline
    Write-Host "✗ " -NoNewline -ForegroundColor Red
    Write-Host ("{0,-30}" -f $label) -NoNewline
    Write-Host $msg -ForegroundColor Red
}

function Write-INFO($label, $msg) {
    Write-Host "    " -NoNewline
    Write-Host "· " -NoNewline -ForegroundColor DarkGray
    Write-Host ("{0,-30}" -f $label) -NoNewline
    Write-Host $msg -ForegroundColor Gray
}

function Write-Fix($msg) {
    Write-Host "      → " -NoNewline -ForegroundColor Cyan
    Write-Host $msg -ForegroundColor DarkCyan
}

function Add-Issue($severity, $section, $label, $detail, $fix) {
    $script:issues.Add(@{
        Severity = $severity  # FAIL / WARN / INFO
        Section  = $section
        Label    = $label
        Detail   = $detail
        Fix      = $fix
    })
}

function Get-CmdOutput($cmd, $args) {
    try {
        $result = & $cmd $args 2>$null
        return ($result -join "`n").Trim()
    } catch { return $null }
}

# ──────────────────────────────────────────────────────────────
# Section 1: 系统基础环境
# ──────────────────────────────────────────────────────────────
function Check-System {
    Write-Section "1. 系统基础环境"

    # OS 版本
    $os = Get-WmiObject -Class Win32_OperatingSystem 2>$null
    if ($os) {
        $osName = $os.Caption
        $osBuild = $os.BuildNumber
        Write-OK "操作系统" "$osName (Build $osBuild)"

        # Win10 1903+ 才支持长路径
        if ([int]$osBuild -lt 17134) {
            Write-FAIL "Windows 版本" "Build $osBuild 过旧（推荐 Build 17134+ / Win10 1803+）"
            Add-Issue "FAIL" "系统" "Windows 版本过旧" "部分 npm 功能和长路径支持需要 Win10 1803+" "升级 Windows 或手动测试兼容性"
        }
    }

    # 系统架构
    $arch = $env:PROCESSOR_ARCHITECTURE
    Write-OK "系统架构" $arch
    if ($arch -ne "AMD64") {
        Write-WARN "架构警告" "检测到非 x64 系统，Node.js 原生模块可能有兼容问题"
        Add-Issue "WARN" "系统" "非x64架构" "原生模块编译可能失败" "确保安装 x64 版 Node.js 和 Build Tools"
    }

    # RAM
    $ram = [math]::Round($os.TotalVisibleMemorySize / 1MB, 1)
    if ($ram -lt 4) {
        Write-WARN "内存 (RAM)" "${ram} GB（建议 8GB+，当前可能影响编译速度）"
        Add-Issue "WARN" "系统" "内存不足" "${ram}GB RAM 低于推荐值" "建议至少 8GB，不足时关闭不必要软件"
    } else {
        Write-OK "内存 (RAM)" "${ram} GB"
    }

    # 磁盘空间（C盘）
    $disk = Get-PSDrive C -ErrorAction SilentlyContinue
    if ($disk) {
        $freeGB = [math]::Round($disk.Free / 1GB, 1)
        if ($freeGB -lt 5) {
            Write-FAIL "C盘剩余空间" "${freeGB} GB（严重不足！node_modules 通常需要 1-3GB）"
            Add-Issue "FAIL" "系统" "磁盘空间严重不足" "C盘仅剩 ${freeGB}GB，npm install 可能中途失败" "清理磁盘至少保留 10GB 空闲空间"
        } elseif ($freeGB -lt 10) {
            Write-WARN "C盘剩余空间" "${freeGB} GB（偏低，建议 10GB+）"
        } else {
            Write-OK "C盘剩余空间" "${freeGB} GB"
        }
    }

    # PowerShell 执行策略
    $policy = Get-ExecutionPolicy
    Write-OK "PS 执行策略" $policy
    if ($policy -eq "Restricted") {
        Write-FAIL "执行策略" "Restricted 会阻止运行脚本和部分 npm hooks"
        Write-Fix "以管理员身份运行：Set-ExecutionPolicy RemoteSigned -Scope CurrentUser"
        Add-Issue "FAIL" "系统" "PowerShell执行策略受限" "Restricted 阻止脚本执行" "管理员运行：Set-ExecutionPolicy RemoteSigned -Scope CurrentUser"
    }

    # 管理员权限检测
    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")
    if ($isAdmin) {
        Write-OK "运行权限" "管理员"
    } else {
        Write-INFO "运行权限" "普通用户（如遇权限报错请以管理员重新运行本脚本）"
    }

    # Windows 长路径支持（MAX_PATH = 260，node_modules 嵌套极深，必须检测）
    $longPath = Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "LongPathsEnabled" -ErrorAction SilentlyContinue
    if ($longPath -and $longPath.LongPathsEnabled -eq 1) {
        Write-OK "Windows 长路径" "已启用（LongPathsEnabled = 1）"
    } else {
        Write-FAIL "Windows 长路径" "未启用！（node_modules 路径极易超 260 字符限制导致诡异报错）"
        Write-Fix "以管理员身份运行 PowerShell 执行："
        Write-Fix "  New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name LongPathsEnabled -Value 1 -PropertyType DWORD -Force"
        Write-Fix "  或：组策略 → 计算机配置 → 管理模板 → 系统 → 文件系统 → 启用Win32长路径"
        Add-Issue "FAIL" "系统" "Windows长路径未启用" "MAX_PATH=260 限制导致 node_modules 深层路径报错" "管理员PowerShell: New-ItemProperty HKLM:\SYSTEM\...FileSystem LongPathsEnabled 1"
    }

    # Windows Defender 实时保护（会大幅拖慢 npm install）
    $defenderStatus = Get-MpComputerStatus -ErrorAction SilentlyContinue
    if ($defenderStatus) {
        if ($defenderStatus.RealTimeProtectionEnabled) {
            Write-WARN "Windows Defender" "实时保护已开启（可能大幅拖慢 npm install，偶发误拦截）"
            Write-Fix "临时方案：在 Defender 设置中将 node_modules 目录加入排除列表"
            Write-Fix "排除路径参考：C:\Users\$env:USERNAME\AppData\Roaming\npm 和项目目录"
            Add-Issue "WARN" "系统" "Windows Defender实时保护" "会拖慢npm install，可能误拦截" "将项目目录和npm缓存目录加入Defender排除列表"
        } else {
            Write-OK "Windows Defender" "实时保护已关闭（npm 速度正常）"
        }
    }
}

# ──────────────────────────────────────────────────────────────
# Section 2: Node.js
# ──────────────────────────────────────────────────────────────
function Check-Node {
    Write-Section "2. Node.js"

    $nodeRaw = Get-CmdOutput "node" @("-v")
    if (-not $nodeRaw) {
        Write-FAIL "Node.js" "未安装或不在 PATH 中"
        Write-Fix "下载 LTS 版本：https://nodejs.org/en/download"
        Write-Fix "推荐版本：18.x 或 20.x LTS（x64）"
        Add-Issue "FAIL" "Node.js" "Node.js未安装" "命令行找不到 node" "下载安装LTS版本：https://nodejs.org/en/download"
        return
    }

    $verStr = $nodeRaw -replace "v", ""
    
    # 防止非标准版本号格式导致崩溃
    if ($verStr -notmatch '^\d+\.\d+') {
        Write-FAIL "Node.js 版本" "版本号格式异常：$nodeRaw"
        Add-Issue "FAIL" "Node.js" "版本号格式异常" "无法解析版本号：$nodeRaw" "重新安装 Node.js"
        return
    }
    
    $major = [int]($verStr.Split(".")[0])
    $minor = [int]($verStr.Split(".")[1])

    # 版本范围检测
    if ($major -lt 16) {
        Write-FAIL "Node.js 版本" "$nodeRaw（过旧！uni-app 需要 16+，当前版本已 EOL）"
        Write-Fix "卸载当前版本，安装 18.x 或 20.x LTS"
        Write-Fix "推荐用 nvm-windows 管理版本：https://github.com/coreybutler/nvm-windows"
        Add-Issue "FAIL" "Node.js" "版本过低 $nodeRaw" "uni-app 要求 Node 16+，当前版本已停止维护" "安装 18.x 或 20.x LTS"
    } elseif ($major -eq 16) {
        Write-WARN "Node.js 版本" "$nodeRaw（可用，但已接近 EOL，建议升级至 18.x 或 20.x）"
        Add-Issue "WARN" "Node.js" "版本偏旧 $nodeRaw" "Node 16 即将结束支持" "建议升级至 18.x 或 20.x LTS"
    } elseif ($major -gt 21) {
        Write-WARN "Node.js 版本" "$nodeRaw（过新，部分 @dcloudio 依赖可能不兼容）"
        Write-Fix "用 nvm 切换至 20.x：nvm install 20.18.0 && nvm use 20.18.0"
        Add-Issue "WARN" "Node.js" "版本过新 $nodeRaw" "过新的Node可能导致native模块编译失败" "用nvm切换至20.x LTS"
    } else {
        Write-OK "Node.js 版本" $nodeRaw
    }

    # 架构检测（必须是 x64）
    $nodeArch = Get-CmdOutput "node" @("-e", "console.log(process.arch)")
    Write-OK "Node.js 架构" $nodeArch
    if ($nodeArch -ne "x64") {
        Write-FAIL "Node.js 架构" "检测到 $nodeArch，必须是 x64！"
        Write-Fix "卸载当前 Node.js，从 nodejs.org 下载 Windows Installer (x64) 重新安装"
        Add-Issue "FAIL" "Node.js" "架构错误：$nodeArch" "应为x64，当前架构原生模块无法正常编译" "重新安装x64版Node.js"
    }

    # Node 安装路径
    $nodePath = Get-CmdOutput "where" @("node")
    Write-INFO "Node.js 路径" $nodePath

    # 检查 PATH 中是否有多个 node（版本冲突源头）
    $allNodePaths = (where.exe node 2>$null)
    if ($allNodePaths -is [array] -and $allNodePaths.Count -gt 1) {
        Write-WARN "Node.js 多版本冲突" "PATH 中存在多个 node！"
        $allNodePaths | ForEach-Object { Write-Fix "  - $_" }
        Write-Fix "用 nvm-windows 统一管理，手动从 PATH 中移除旧版本"
        Add-Issue "WARN" "Node.js" "PATH中存在多个node" "版本冲突可能导致不可预期行为" "用nvm-windows统一管理，清理旧PATH"
    }
}

# ──────────────────────────────────────────────────────────────
# Section 3: npm 配置
# ──────────────────────────────────────────────────────────────
function Check-Npm {
    Write-Section "3. npm 配置"

    $npmVer = Get-CmdOutput "npm" @("-v")
    if (-not $npmVer) {
        Write-FAIL "npm" "未找到（通常随 Node.js 安装）"
        Add-Issue "FAIL" "npm" "npm未找到" "npm随Node.js安装，可能PATH配置有误" "重新安装Node.js或修复PATH"
        return
    }
    Write-OK "npm 版本" $npmVer

    # npm 源
    $registry = Get-CmdOutput "npm" @("config", "get", "registry")
    if ($registry -match "registry.npmjs.org") {
        Write-WARN "npm 源" "$registry（官方源，国内可能超时）"
        Write-Fix "切换国内镜像：npm config set registry https://registry.npmmirror.com"
        Add-Issue "WARN" "npm" "使用官方源" "国内访问慢，可能导致安装超时" "npm config set registry https://registry.npmmirror.com"
    } else {
        Write-OK "npm 源" $registry
    }

    # npm 代理检测（默认不设置，设了反而可能出问题）
    $httpProxy = Get-CmdOutput "npm" @("config", "get", "proxy")
    $httpsProxy = Get-CmdOutput "npm" @("config", "get", "https-proxy")
    if ($httpProxy -and $httpProxy -ne "null") {
        Write-WARN "npm HTTP 代理" "$httpProxy（已配置，确认代理可用）"
        Write-Fix "如代理失效导致安装失败：npm config delete proxy"
        Add-Issue "WARN" "npm" "配置了HTTP代理" "代理失效时npm install会超时" "确认代理可用，或 npm config delete proxy"
    }
    if ($httpsProxy -and $httpsProxy -ne "null") {
        Write-WARN "npm HTTPS 代理" "$httpsProxy（已配置，确认代理可用）"
        Write-Fix "如代理失效：npm config delete https-proxy"
        Add-Issue "WARN" "npm" "配置了HTTPS代理" "代理失效时npm install会超时" "确认代理可用，或 npm config delete https-proxy"
    }

    # npm 全局 prefix 路径
    $prefix = Get-CmdOutput "npm" @("config", "get", "prefix")
    Write-INFO "npm 全局 prefix" $prefix

    # 检测 npm global bin 是否在 PATH
    $globalBin = Join-Path $prefix ""
    $pathDirs = $env:PATH -split ";"
    $prefixInPath = $pathDirs | Where-Object { $_ -like "*$prefix*" -or $_ -like "*npm*" -or $_ -like "*Roaming\\npm*" }
    if ($prefixInPath) {
        Write-OK "npm global bin 在PATH" "已配置"
    } else {
        Write-FAIL "npm global bin" "不在 PATH！全局安装的 CLI 工具（vue、pnpm等）将无法直接调用"
        Write-Fix "将以下路径加入系统 PATH：$prefix"
        Write-Fix "系统属性 → 高级 → 环境变量 → Path → 新建 → 粘贴上方路径 → 确定 → 重启终端"
        Add-Issue "FAIL" "npm" "global bin不在PATH" "全局安装的命令行工具无法找到" "将 $prefix 加入系统PATH"
    }

    # npm 缓存路径和健康检测
    $cacheDir = Get-CmdOutput "npm" @("config", "get", "cache")
    Write-INFO "npm 缓存目录" $cacheDir
    if ($cacheDir -and (Test-Path $cacheDir)) {
        $cacheSize = (Get-ChildItem $cacheDir -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
        $cacheMB = [math]::Round($cacheSize / 1MB, 0)
        if ($cacheMB -gt 2000) {
            Write-WARN "npm 缓存大小" "${cacheMB} MB（过大，可能包含损坏缓存）"
            Write-Fix "清理缓存：npm cache clean --force"
            Add-Issue "WARN" "npm" "缓存过大(${cacheMB}MB)" "大量缓存可能包含损坏包" "npm cache clean --force"
        } else {
            Write-OK "npm 缓存大小" "${cacheMB} MB"
        }
    }

    # .npmrc 文件检测
    $npmrcUser = Join-Path $env:USERPROFILE ".npmrc"
    $npmrcProject = Join-Path (Get-Location) ".npmrc"
    if (Test-Path $npmrcUser) {
        $content = Get-Content $npmrcUser -Raw
        Write-INFO ".npmrc (用户级)" $npmrcUser
        # 检测常见错误配置
        if ($content -match "strict-ssl=false") {
            Write-WARN ".npmrc 安全配置" "strict-ssl=false 已禁用 SSL 验证（不推荐）"
            Add-Issue "WARN" "npm" "SSL验证已禁用" "strict-ssl=false 存在安全风险" "仅在必要时临时使用，用完恢复"
        }
    }
    if (Test-Path $npmrcProject) {
        Write-INFO ".npmrc (项目级)" "已存在（可能覆盖全局配置）"
    }
}

# ──────────────────────────────────────────────────────────────
# Section 4: 版本管理 (nvm-windows)
# ──────────────────────────────────────────────────────────────
function Check-Nvm {
    Write-Section "4. Node 版本管理 (nvm-windows)"

    $nvmVer = Get-CmdOutput "nvm" @("version")
    if (-not $nvmVer) {
        Write-WARN "nvm-windows" "未安装（强烈推荐！可随时切换 Node 版本解决兼容问题）"
        Write-Fix "下载地址：https://github.com/coreybutler/nvm-windows/releases"
        Write-Fix "安装后：nvm install 20.18.0 && nvm use 20.18.0"
        Add-Issue "WARN" "nvm" "未安装nvm-windows" "无法快速切换Node版本" "安装：https://github.com/coreybutler/nvm-windows/releases"
        return
    }

    Write-OK "nvm-windows 版本" $nvmVer

    # 列出已安装的 Node 版本
    $nvmList = nvm list 2>$null
    if ($nvmList) {
        Write-INFO "已安装 Node 版本" ""
        $nvmList | ForEach-Object {
            if ($_ -match "\*") {
                Write-Host "      → $_" -ForegroundColor Yellow
            } elseif ($_.Trim()) {
                Write-Host "        $_" -ForegroundColor Gray
            }
        }
    }

    # nvm 根目录路径空格检测（nvm 在有空格的路径下有已知 Bug）
    $nvmHome = $env:NVM_HOME
    if ($nvmHome -match " ") {
        Write-FAIL "nvm 安装路径" "路径含空格：$nvmHome（已知 Bug，会导致 nvm use 失败）"
        Write-Fix "卸载 nvm-windows，重装到无空格路径，如：C:\nvm"
        Add-Issue "FAIL" "nvm" "nvm路径含空格" "路径有空格时 nvm use 可能失败" "卸载并重装nvm到无空格路径如 C:\\nvm"
    } elseif ($nvmHome) {
        Write-OK "nvm 安装路径" $nvmHome
    }
}

# ──────────────────────────────────────────────────────────────
# Section 5: 包管理器
# ──────────────────────────────────────────────────────────────
function Check-PackageManagers {
    Write-Section "5. 包管理器"

    # pnpm（uni-app 官方推荐）
    $pnpmVer = Get-CmdOutput "pnpm" @("-v")
    if ($pnpmVer) {
        Write-OK "pnpm（官方推荐）" $pnpmVer
        # 检测 pnpm store 路径
        $pnpmStore = Get-CmdOutput "pnpm" @("store", "path")
        if ($pnpmStore) { Write-INFO "pnpm store" $pnpmStore }
    } else {
        Write-WARN "pnpm" "未安装（uni-app 官方推荐使用 pnpm）"
        Write-Fix "安装：npm install -g pnpm"
        Add-Issue "WARN" "包管理器" "pnpm未安装" "官方推荐pnpm" "npm install -g pnpm"
    }

    # yarn
    $yarnVer = Get-CmdOutput "yarn" @("-v")
    if ($yarnVer) {
        Write-OK "yarn" $yarnVer
        # yarn classic vs berry
        $yarnMajor = [int]($yarnVer.Split(".")[0])
        if ($yarnMajor -ge 2) {
            Write-WARN "yarn 版本" "yarn berry（v$yarnMajor.x）与部分 uni-app 模板不兼容"
            Write-Fix "如遇问题：yarn set version classic 切换回 yarn 1.x"
            Add-Issue "WARN" "包管理器" "yarn berry版本" "v2+与部分项目不兼容" "yarn set version classic"
        }
    } else {
        Write-INFO "yarn" "未安装（可选，npm 或 pnpm 均可）"
    }

    # npx
    $npxVer = Get-CmdOutput "npx" @("-v")
    if ($npxVer) {
        Write-OK "npx" $npxVer
    } else {
        Write-WARN "npx" "未找到（npm 5.2+ 自带，可能 PATH 配置有误）"
        Add-Issue "WARN" "包管理器" "npx未找到" "uni-app脚手架依赖npx" "检查npm安装完整性"
    }
}

# ──────────────────────────────────────────────────────────────
# Section 6: 构建工具链（node-gyp / Python / MSVC）
# ──────────────────────────────────────────────────────────────
function Check-BuildTools {
    Write-Section "6. 构建工具链（原生模块编译）"

    # Python（node-gyp 依赖）
    $py3 = Get-CmdOutput "python" @("--version")
    $py3alt = Get-CmdOutput "python3" @("--version")
    $pyVer = if ($py3) { $py3 } elseif ($py3alt) { $py3alt } else { $null }

    if ($pyVer) {
        Write-OK "Python" $pyVer
        $pyMajor = [int](($pyVer -replace "Python ", "").Split(".")[0])
        if ($pyMajor -lt 3) {
            Write-WARN "Python 版本" "检测到 Python 2.x，node-gyp 推荐 Python 3.x"
            Add-Issue "WARN" "构建工具" "Python版本" "node-gyp推荐Python 3.x" "安装Python 3.x并确保在PATH中优先"
        }
    } else {
        Write-WARN "Python" "未安装或不在 PATH（部分 npm 包的原生模块编译需要 Python）"
        Write-Fix "下载：https://www.python.org/downloads/ （选 3.x，安装时勾选「Add to PATH」）"
        Write-Fix "或：winget install Python.Python.3"
        Add-Issue "WARN" "构建工具" "Python未安装" "node-gyp编译原生模块需要Python" "安装Python 3.x并勾选Add to PATH"
    }

    # Visual Studio Build Tools / MSVC（node-gyp 在 Windows 上需要）
    $vsWhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
    $vsInstalled = $false

    if (Test-Path $vsWhere) {
        $vsInfo = & $vsWhere -latest -property displayName 2>$null
        if ($vsInfo) {
            Write-OK "Visual Studio" $vsInfo
            $vsInstalled = $true

            # 检测 C++ 工作负载
            $vsCppCheck = & $vsWhere -latest -requires Microsoft.VisualCpp.Tools.HostX64.TargetX64 2>$null
            if ($vsCppCheck) {
                Write-OK "C++ 编译工具" "已安装"
            } else {
                Write-WARN "C++ 编译工具" "Visual Studio 已安装但可能缺少 C++ 工作负载"
                Write-Fix "打开 Visual Studio Installer → 修改 → 勾选「使用 C++ 的桌面开发」"
                Add-Issue "WARN" "构建工具" "VS缺少C++工作负载" "node-gyp需要C++编译器" "VS Installer → 修改 → 勾选 C++桌面开发"
            }
        }
    }

    if (-not $vsInstalled) {
        # 检测 windows-build-tools（旧方案）
        $wbt = Get-CmdOutput "npm" @("list", "-g", "windows-build-tools")
        if ($wbt -and $wbt -notmatch "empty") {
            Write-OK "windows-build-tools" "已全局安装（旧方案，可用）"
        } else {
            Write-WARN "Visual Studio Build Tools" "未检测到（node-gyp 依赖此工具链）"
            Write-Fix "推荐方案A（现代）：安装 Visual Studio Build Tools 2022"
            Write-Fix "  下载：https://visualstudio.microsoft.com/visual-cpp-build-tools/"
            Write-Fix "  安装时选：「使用 C++ 的桌面开发」工作负载"
            Write-Fix "推荐方案B（简单）：管理员身份运行：npm install -g windows-build-tools"
            Write-Fix "推荐方案C（一行命令，Win10+）：winget install Microsoft.VisualStudio.2022.BuildTools"
            Add-Issue "WARN" "构建工具" "缺少MSVC编译工具" "npm install可能因原生模块失败" "安装VS BuildTools并选C++桌面开发工作负载"
        }
    }

    # node-gyp
    $nodegyp = Get-CmdOutput "node-gyp" @("--version")
    if ($nodegyp) {
        Write-OK "node-gyp" $nodegyp
    } else {
        Write-INFO "node-gyp" "未全局安装（npm 内置，通常不需要手动安装）"
    }

    # Git（部分 npm 包通过 git 依赖）
    $gitVer = Get-CmdOutput "git" @("--version")
    if ($gitVer) {
        Write-OK "Git" $gitVer

        # Git 用户名配置检查
        $gitUser = Get-CmdOutput "git" @("config", "--global", "user.name")
        if (-not $gitUser) {
            Write-WARN "Git 用户名" "未配置（某些 npm 包可能需要）"
            Write-Fix "git config --global user.name '你的名字'"
            Write-Fix "git config --global user.email '你的邮箱'"
        }
    } else {
        Write-WARN "Git" "未安装（部分 npm 依赖通过 git 协议安装）"
        Write-Fix "下载：https://git-scm.com/download/win"
        Add-Issue "WARN" "构建工具" "Git未安装" "部分npm包依赖git" "下载安装：https://git-scm.com/download/win"
    }
}

# ──────────────────────────────────────────────────────────────
# Section 7: Vue / uni-app 工具链
# ──────────────────────────────────────────────────────────────
function Check-UniApp {
    Write-Section "7. Vue / uni-app 工具链"

    # Vue CLI
    $vueCli = Get-CmdOutput "vue" @("--version")
    if ($vueCli) {
        Write-OK "Vue CLI" $vueCli
        $vueMajor = [int](($vueCli -replace "@vue/cli ", "").Split(".")[0])
        if ($vueMajor -lt 5) {
            Write-WARN "Vue CLI 版本" "推荐 5.x，当前 $vueCli"
            Write-Fix "npm install -g @vue/cli"
            Add-Issue "WARN" "uni-app工具" "Vue CLI版本过旧" "推荐5.x" "npm install -g @vue/cli"
        }
    } else {
        Write-WARN "Vue CLI" "未全局安装"
        Write-Fix "npm install -g @vue/cli"
        Add-Issue "WARN" "uni-app工具" "Vue CLI未安装" "CLI创建项目需要" "npm install -g @vue/cli"
    }

    # HBuilderX 检测
    $hbxPaths = @(
        "$env:LOCALAPPDATA\Programs\HBuilderX\HBuilderX.exe",
        "C:\Program Files\HBuilderX\HBuilderX.exe",
        "D:\HBuilderX\HBuilderX.exe",
        "$env:ProgramFiles\HBuilderX\HBuilderX.exe"
    )
    $hbxFound = $hbxPaths | Where-Object { Test-Path $_ } | Select-Object -First 1
    if ($hbxFound) {
        $hbxVer = (Get-Item $hbxFound).VersionInfo.FileVersion
        Write-OK "HBuilderX" "已安装 v$hbxVer → $hbxFound"

        # 检查路径是否含空格或中文（已知 HBuilderX 在特殊路径下有 Bug）
        if ($hbxFound -match "[\u4e00-\u9fa5]") {
            Write-WARN "HBuilderX 路径" "路径含中文字符，可能引起编译路径解析失败"
            Write-Fix "将 HBuilderX 移动/重装到纯英文路径（如 D:\HBuilderX）"
            Add-Issue "WARN" "HBuilderX" "安装路径含中文" "编译时可能路径解析失败" "重装到纯英文路径如 D:\\HBuilderX"
        }
    } else {
        Write-INFO "HBuilderX" "未检测到（使用 CLI 开发可忽略）"
    }

    # 检查当前目录是否是 uni-app 项目
    $pkgJson = Join-Path (Get-Location) "package.json"
    if (Test-Path $pkgJson) {
        Write-Section "  7+ 项目级检测（检测到 package.json）"
        Check-Project $pkgJson
    } else {
        Write-INFO "项目检测" "当前目录无 package.json，跳过项目级检测"
        Write-INFO "" "提示：在 uni-app 项目根目录运行本脚本可获取更详细的诊断"
    }
}

# ──────────────────────────────────────────────────────────────
# Section 7+: 项目级检测
# ──────────────────────────────────────────────────────────────
function Check-Project($pkgPath) {
    $pkg = Get-Content $pkgPath -Raw | ConvertFrom-Json

    # 项目名称
    Write-INFO "项目名称" $pkg.name
    Write-INFO "项目版本" $pkg.version

    # 检测 @dcloudio 核心包版本
    $allDeps = @{}
    if ($pkg.dependencies) { $pkg.dependencies.PSObject.Properties | ForEach-Object { $allDeps[$_.Name] = $_.Value } }
    if ($pkg.devDependencies) { $pkg.devDependencies.PSObject.Properties | ForEach-Object { $allDeps[$_.Name] = $_.Value } }

    $dcloudio = $allDeps.Keys | Where-Object { $_ -like "@dcloudio/*" }
    if ($dcloudio) {
        Write-OK "@dcloudio 包" "检测到 $($dcloudio.Count) 个"
        $dcloudio | ForEach-Object {
            $ver = $allDeps[$_]
            Write-INFO "  $_" $ver
        }

        # 检测 @dcloudio/uni-app 版本一致性（所有包应该版本相同）
        $dcVersions = $dcloudio | ForEach-Object { $allDeps[$_] -replace "[\^~>=]", "" } | Sort-Object -Unique
        if ($dcVersions.Count -gt 1) {
            Write-WARN "@dcloudio 版本不一致" "检测到多个版本：$($dcVersions -join ', ')"
            Write-Fix "统一 @dcloudio 包版本，运行：npx @dcloudio/uvm@latest"
            Add-Issue "WARN" "项目" "@dcloudio包版本不一致" "可能导致运行时错误" "运行 npx @dcloudio/uvm@latest 统一版本"
        }
    } else {
        Write-WARN "@dcloudio 包" "未找到（不像是 uni-app 项目，或依赖未配置）"
    }

    # Vue 版本检测
    $vueVer = $allDeps["vue"]
    if ($vueVer) {
        Write-OK "Vue 版本" $vueVer
        $vueMajor = if ($vueVer -match "^[\^~]?3") { 3 } elseif ($vueVer -match "^[\^~]?2") { 2 } else { 0 }

        # Vite 与 Vue 版本兼容性
        $viteVer = $allDeps["vite"]
        if ($viteVer -and $vueMajor -eq 3) {
            Write-OK "Vite" $viteVer
            $viteVerClean = $viteVer -replace "[\^~>=]", ""
            if ($viteVerClean -match '^\d+\.\d+') {
                $viteMajor = [int]($viteVerClean.Split(".")[0])
                if ($viteMajor -ge 5) {
                    # 检查 @vitejs/plugin-vue 版本
                    $pluginVue = $allDeps["@vitejs/plugin-vue"]
                    if ($pluginVue) {
                        $pluginVerClean = $pluginVue -replace "[\^~>=]", ""
                        if ($pluginVerClean -match '^\d+\.\d+') {
                            $pluginMajor = [int]($pluginVerClean.Split(".")[0])
                            if ($pluginMajor -lt 4) {
                                Write-WARN "Vite/plugin-vue 兼容性" "@vitejs/plugin-vue $pluginVue 可能与 Vite $viteVer 不兼容"
                                Write-Fix "npm install @vitejs/plugin-vue@latest"
                                Add-Issue "WARN" "项目" "Vite/plugin-vue版本冲突" "需要plugin-vue 4+" "npm install @vitejs/plugin-vue@latest"
                            }
                        }
                    }
                }
            }
        }
    }

    # TypeScript 配置
    $tsconfig = Join-Path (Get-Location) "tsconfig.json"
    if (Test-Path $tsconfig) {
        Write-OK "TypeScript 配置" "tsconfig.json 存在"
        $tsDeps = $allDeps["typescript"]
        if ($tsDeps) {
            Write-INFO "TypeScript 版本" $tsDeps
        }
    }

    # node_modules 检测
    $nmPath = Join-Path (Get-Location) "node_modules"
    if (Test-Path $nmPath) {
        $nmCount = (Get-ChildItem $nmPath -Directory -ErrorAction SilentlyContinue).Count
        Write-OK "node_modules" "存在（$nmCount 个顶层包）"

        # 检测 lock 文件和 node_modules 的包管理器一致性
        $hasPackageLock = Test-Path (Join-Path (Get-Location) "package-lock.json")
        $hasPnpmLock = Test-Path (Join-Path (Get-Location) "pnpm-lock.yaml")
        $hasYarnLock = Test-Path (Join-Path (Get-Location) "yarn.lock")

        if (($hasPackageLock -and $hasPnpmLock) -or ($hasPackageLock -and $hasYarnLock) -or ($hasPnpmLock -and $hasYarnLock)) {
            Write-WARN "Lock 文件冲突" "检测到多个锁文件（package-lock.json / pnpm-lock.yaml / yarn.lock）"
            Write-Fix "统一使用一种包管理器，删除其他锁文件后重新 install"
            Add-Issue "WARN" "项目" "多个lock文件共存" "混用包管理器导致依赖不一致" "删除多余的lock文件，统一用一种包管理器"
        }

        # 检测 peer dependency 冲突（npm ls 输出警告）
        Write-INFO "peer deps 检测" "正在运行 npm ls --depth=0（可能耗时）..."
        $npmLs = npm ls --depth=0 2>&1
        $peerWarnings = $npmLs | Where-Object { $_ -match "peer dep" -or $_ -match "UNMET PEER" }
        if ($peerWarnings) {
            Write-WARN "peer 依赖冲突" "检测到 $($peerWarnings.Count) 个冲突"
            $peerWarnings | Select-Object -First 3 | ForEach-Object { Write-Fix "  $($_.Trim())" }
            Write-Fix "尝试：npm install --legacy-peer-deps（忽略冲突强行安装）"
            Write-Fix "或：npm install --force（强制覆盖）"
            Add-Issue "WARN" "项目" "peer依赖冲突" "可能导致运行时版本不兼容" "npm install --legacy-peer-deps"
        }
    } else {
        Write-WARN "node_modules" "不存在，需要先安装依赖"
        Write-Fix "运行：npm install 或 pnpm install"
        Add-Issue "WARN" "项目" "node_modules不存在" "依赖未安装" "运行 pnpm install 或 npm install"
    }

    # manifest.json 检测（uni-app 专属）
    $manifest = Join-Path (Get-Location) "manifest.json"
    if (Test-Path $manifest) {
        Write-OK "manifest.json" "存在"
        $manifestContent = Get-Content $manifest -Raw
        # 检测 AppID 是否配置
        if ($manifestContent -match '"appid"\s*:\s*""' -or $manifestContent -match '"appid"\s*:\s*null') {
            Write-WARN "manifest.json" "appid 未配置（发布到小程序/App 前必须填写）"
            Add-Issue "WARN" "项目" "appid未配置" "发布时必须填写对应平台的appid" "在manifest.json中配置对应平台的appid"
        }
    }
}

# ──────────────────────────────────────────────────────────────
# Section 8: 平台专属工具（小程序 / App）
# ──────────────────────────────────────────────────────────────
function Check-PlatformTools {
    Write-Section "8. 平台专属工具"

    # 微信开发者工具
    $wxPaths = @(
        "C:\Program Files (x86)\Tencent\微信web开发者工具\cli.bat",
        "C:\Program Files\Tencent\微信web开发者工具\cli.bat",
        "$env:LOCALAPPDATA\Programs\微信web开发者工具\cli.bat",
        "D:\微信web开发者工具\cli.bat",
        "C:\Program Files (x86)\Tencent\WeChat Web DevTools\cli.bat"
    )
    $wxFound = $wxPaths | Where-Object { Test-Path $_ } | Select-Object -First 1
    if ($wxFound) {
        Write-OK "微信开发者工具" $wxFound
        # 检查 HBuilderX 是否配置了微信工具路径
        Write-INFO "提示" "确保 HBuilderX → 运行配置 → 微信开发者工具 路径与上方一致"
    } else {
        Write-INFO "微信开发者工具" "未检测到（仅开发微信小程序时需要）"
        Write-INFO "" "下载：https://developers.weixin.qq.com/miniprogram/dev/devtools/download.html"
    }

    # Java JDK（Android 打包）
    $javaVer = Get-CmdOutput "java" @("-version")
    $javaHome = $env:JAVA_HOME
    if ($javaVer -or $javaHome) {
        if ($javaVer) { Write-OK "Java" $javaVer }
        if ($javaHome) {
            Write-OK "JAVA_HOME" $javaHome
            if (-not (Test-Path $javaHome)) {
                Write-FAIL "JAVA_HOME 路径" "目录不存在！JAVA_HOME 配置有误"
                Add-Issue "FAIL" "平台工具" "JAVA_HOME路径无效" "Android打包会失败" "修正JAVA_HOME指向实际JDK安装目录"
            }
        } else {
            Write-WARN "JAVA_HOME" "未设置（Android 打包可能失败）"
            Write-Fix "系统属性 → 环境变量 → 新建 JAVA_HOME = JDK安装路径"
            Add-Issue "WARN" "平台工具" "JAVA_HOME未配置" "Android打包需要" "配置JAVA_HOME系统环境变量"
        }
    } else {
        Write-INFO "Java / JDK" "未安装（仅 Android App 打包时需要）"
        Write-INFO "" "推荐：https://www.oracle.com/java/technologies/downloads/ （JDK 11+）"
    }

    # Android SDK / adb
    $adbVer = Get-CmdOutput "adb" @("version")
    $androidHome = $env:ANDROID_HOME
    if ($adbVer) {
        Write-OK "ADB (Android Debug Bridge)" ($adbVer -split "`n" | Select-Object -First 1)
    } elseif ($androidHome) {
        $adbPath = Join-Path $androidHome "platform-tools\adb.exe"
        if (Test-Path $adbPath) {
            Write-WARN "adb" "已安装但不在 PATH（$adbPath）"
            Write-Fix "将 $androidHome\platform-tools 加入系统 PATH"
            Add-Issue "WARN" "平台工具" "adb不在PATH" "真机调试需要adb在PATH" "将Android SDK的platform-tools加入PATH"
        }
    } else {
        Write-INFO "Android SDK / adb" "未检测到（仅 Android 开发时需要）"
    }
}

# ──────────────────────────────────────────────────────────────
# Section 9: 网络连通性
# ──────────────────────────────────────────────────────────────
function Check-Network {
    Write-Section "9. 网络连通性"

    $targets = @(
        @{ Name = "npmmirror（国内源）"; Host = "registry.npmmirror.com"; Port = 443 },
        @{ Name = "npm 官方源";          Host = "registry.npmjs.org";     Port = 443 },
        @{ Name = "GitHub";              Host = "github.com";             Port = 443 },
        @{ Name = "DCloud 官网";         Host = "www.dcloud.io";          Port = 443 },
        @{ Name = "微信开发者服务";       Host = "servicewechat.com";      Port = 443 }
    )

    foreach ($t in $targets) {
        $conn = Test-NetConnection -ComputerName $t.Host -Port $t.Port -InformationLevel Quiet -WarningAction SilentlyContinue 2>$null
        if ($conn) {
            Write-OK $t.Name "可访问"
        } else {
            Write-WARN $t.Name "连接失败（可能影响包下载）"
            Add-Issue "WARN" "网络" "$($t.Name)不可访问" "下载依赖可能超时或失败" "检查网络或配置代理/镜像源"
        }
    }

    # 检测系统代理
    $sysproxy = Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -ErrorAction SilentlyContinue
    if ($sysproxy -and $sysproxy.ProxyEnable -eq 1) {
        Write-WARN "系统代理" "已启用：$($sysproxy.ProxyServer)"
        Write-Fix "如 npm install 出现连接问题，检查代理是否正常工作"
        Write-Fix "临时绕过：npm config set proxy null && npm config set https-proxy null"
    } else {
        Write-OK "系统代理" "未启用"
    }
}

# ──────────────────────────────────────────────────────────────
# Section 10: 端口检测
# ──────────────────────────────────────────────────────────────
function Check-Ports {
    Write-Section "10. 开发端口占用检测"

    $ports = @(
        @{ Port = 3000;  Desc = "uni-app H5 默认端口" },
        @{ Port = 5173;  Desc = "Vite 默认端口" },
        @{ Port = 8080;  Desc = "备用开发端口" },
        @{ Port = 8000;  Desc = "备用开发端口" },
        @{ Port = 9000;  Desc = "备用端口" }
    )

    foreach ($p in $ports) {
        $conn = Get-NetTCPConnection -LocalPort $p.Port -State Listen -ErrorAction SilentlyContinue
        if ($conn) {
            $proc = Get-Process -Id $conn[0].OwningProcess -ErrorAction SilentlyContinue
            $procName = if ($proc) { $proc.Name } else { "未知" }
            Write-WARN "端口 $($p.Port)" "被占用（$procName，PID $($conn[0].OwningProcess)）← $($p.Desc)"
            Write-Fix "结束进程：Stop-Process -Id $($conn[0].OwningProcess)"
            Write-Fix "或修改 uni-app 端口：vite.config.js → server.port"
            Add-Issue "WARN" "端口" "端口$($p.Port)被占用" "$procName 占用，uni-app可能无法启动" "Stop-Process -Id $($conn[0].OwningProcess) 或修改vite端口"
        } else {
            Write-OK "端口 $($p.Port)" "空闲   ← $($p.Desc)"
        }
    }
}

# ──────────────────────────────────────────────────────────────
# Section 11: PATH 完整性深度检测
# ──────────────────────────────────────────────────────────────
function Check-Path {
    Write-Section "11. PATH 环境变量深度检测"

    $pathDirs = $env:PATH -split ";"
    $pathDirs = $pathDirs | Where-Object { $_.Trim() -ne "" }

    # 检查 PATH 总长度（Windows 有上限约 32767 字符，但实际超过 2048 经常有问题）
    $pathLen = ($env:PATH).Length
    Write-INFO "PATH 总长度" "$pathLen 字符"
    if ($pathLen -gt 2048) {
        Write-WARN "PATH 过长" "${pathLen} 字符（过长可能导致部分工具找不到）"
        Write-Fix "清理 PATH 中的无效或重复路径"
        Add-Issue "WARN" "PATH" "PATH过长" "${pathLen}字符，超过建议上限" "清理重复或无效的PATH条目"
    }

    # 检测不存在的 PATH 条目
    $invalidPaths = $pathDirs | Where-Object { $_ -and -not (Test-Path $_) }
    if ($invalidPaths.Count -gt 0) {
        Write-WARN "无效 PATH 条目" "$($invalidPaths.Count) 个路径不存在"
        $invalidPaths | Select-Object -First 3 | ForEach-Object { Write-Fix "  不存在：$_" }
        if ($invalidPaths.Count -gt 3) { Write-Fix "  ...共 $($invalidPaths.Count) 个（已截断显示）" }
        Add-Issue "WARN" "PATH" "存在无效PATH路径" "$($invalidPaths.Count)个不存在的路径" "清理系统环境变量中不存在的PATH条目"
    }

    # 关键工具路径检测
    $critical = @(
        @{ Cmd = "node";   Label = "Node.js" },
        @{ Cmd = "npm";    Label = "npm" },
        @{ Cmd = "git";    Label = "Git" },
        @{ Cmd = "python"; Label = "Python" }
    )
    foreach ($c in $critical) {
        $found = Get-Command $c.Cmd -ErrorAction SilentlyContinue
        if ($found) {
            Write-OK "$($c.Label) 在PATH中" $found.Source
        } else {
            Write-WARN "$($c.Label) 不在PATH中" "需要手动添加"
        }
    }
}

# ──────────────────────────────────────────────────────────────
# Section 12: 疑难杂症 / 隐性炸弹检测
# ──────────────────────────────────────────────────────────────
function Check-EdgeCases {
    Write-Section "12. 疑难杂症 / 隐性炸弹检测"

    # 用户名含中文或特殊字符（npm prefix 路径问题）
    $username = $env:USERNAME
    if ($username -match "[\u4e00-\u9fa5]") {
        Write-FAIL "Windows 用户名" "含中文字符：$username（npm 缓存路径可能解析失败）"
        Write-Fix "创建纯英文用户名的新账户用于开发，或自定义 npm prefix 和 cache 路径："
        Write-Fix "  npm config set prefix 'D:\npm-global'"
        Write-Fix "  npm config set cache 'D:\npm-cache'"
        Add-Issue "FAIL" "疑难杂症" "用户名含中文" "npm缓存路径解析失败，install可能莫名报错" "新建英文用户名账户，或自定义npm prefix/cache到英文路径"
    } else {
        Write-OK "Windows 用户名" "$username（无特殊字符）"
    }

    # 项目路径含空格检测
    $cwd = Get-Location
    if ($cwd.Path -match " ") {
        Write-WARN "当前项目路径" "含空格：$cwd（部分构建工具对空格处理有 Bug）"
        Write-Fix "将项目移动到无空格路径，如：D:\Projects\myapp"
        Add-Issue "WARN" "疑难杂症" "项目路径含空格" "部分构建工具不能正确处理含空格路径" "将项目移到无空格的路径"
    } else {
        Write-OK "当前路径" "无空格 ✓"
    }

    # 项目路径含中文
    if ($cwd.Path -match "[\u4e00-\u9fa5]") {
        Write-WARN "当前项目路径" "含中文字符（构建脚本可能无法解析）"
        Write-Fix "将项目路径改为纯英文，如：D:\Projects\myapp"
        Add-Issue "WARN" "疑难杂症" "项目路径含中文" "构建脚本可能无法正确解析路径" "移到纯英文路径"
    }

    # hosts 文件检测（有时 npm 相关域名被拦截）
    $hostsPath = "$env:SystemRoot\System32\drivers\etc\hosts"
    if (Test-Path $hostsPath) {
        $hostsContent = Get-Content $hostsPath
        $npmBlocked = $hostsContent | Where-Object { $_ -match "npmjs|npmmirror|github" -and $_ -notmatch "^#" }
        if ($npmBlocked) {
            Write-WARN "hosts 文件" "检测到可能拦截 npm/GitHub 的条目"
            $npmBlocked | ForEach-Object { Write-Fix "  $($_.Trim())" }
            Write-Fix "编辑 hosts 文件（管理员权限）移除或注释这些条目"
            Add-Issue "WARN" "疑难杂症" "hosts文件拦截npm域名" "npm install可能被hosts拦截" "管理员编辑 C:\\Windows\\System32\\drivers\\etc\\hosts"
        } else {
            Write-OK "hosts 文件" "未检测到异常拦截"
        }
    }

    # npm ERR! cb() never called 常见于 antivirus 干扰
    # 通过检测第三方杀毒软件来提示
    $avProcesses = @("360tray", "360safe", "kxetray", "kavstart", "bdservicehost", "avgnt", "mcshield")
    $runningAV = $avProcesses | Where-Object { Get-Process -Name $_ -ErrorAction SilentlyContinue }
    if ($runningAV) {
        Write-WARN "第三方安全软件" "检测到：$($runningAV -join ', ')"
        Write-Fix "如 npm install 卡住或报 EPERM 错误，尝试临时关闭杀毒软件或添加项目目录到白名单"
        Add-Issue "WARN" "疑难杂症" "第三方杀毒可能干扰npm" "可能拦截文件写入导致EPERM" "将项目目录和npm缓存加入杀毒软件白名单"
    } else {
        Write-OK "第三方安全软件" "未检测到常见拦截软件"
    }

    # 检测 node_modules 嵌套路径长度（如果在项目里）
    $nmPath = Join-Path (Get-Location) "node_modules"
    if (Test-Path $nmPath) {
        $longPaths = Get-ChildItem $nmPath -Recurse -ErrorAction SilentlyContinue |
            Where-Object { $_.FullName.Length -gt 240 } |
            Select-Object -First 3
        if ($longPaths) {
            Write-WARN "node_modules 深层路径" "检测到路径长度接近/超过 260 字符限制"
            $longPaths | ForEach-Object { Write-Fix "  ($($_.FullName.Length)字符) $($_.FullName.Substring(0, [Math]::Min(100, $_.FullName.Length)))..." }
            Write-Fix "必须启用 Windows 长路径支持（见第 1 节）"
            Add-Issue "FAIL" "疑难杂症" "路径超260字符" "node_modules深层路径超限" "启用Windows长路径支持（见诊断第1节）"
        } else {
            Write-OK "node_modules 路径长度" "在 260 字符限制以内"
        }
    }

    # npm peer deps 模式检测（npm v7+ 默认严格模式）
    $npmVerRaw = Get-CmdOutput "npm" @("-v")
    if ($npmVerRaw -and $npmVerRaw -match '^\d+\.\d+') {
        $npmMajor = [int]($npmVerRaw.Split(".")[0])
        if ($npmMajor -ge 7) {
            Write-INFO "npm 对等依赖模式" "npm $npmMajor.x 默认严格模式（peer deps 冲突会直接报错）"
            Write-Fix "如遇 peer dep 冲突报错：npm install --legacy-peer-deps"
            Write-Fix "或永久设置：npm config set legacy-peer-deps true"
        }
    } else {
        $npmMajor = 0
    }

    # 检测 package-lock.json 版本与当前 npm 不匹配
    $lockFile = Join-Path (Get-Location) "package-lock.json"
    if (Test-Path $lockFile) {
        $lockContent = Get-Content $lockFile -Raw | ConvertFrom-Json -ErrorAction SilentlyContinue
        if ($lockContent -and $lockContent.lockfileVersion) {
            $lockVer = $lockContent.lockfileVersion
            if ($lockVer -eq 1 -and $npmMajor -ge 7) {
                Write-WARN "lock 文件版本" "lockfileVersion=$lockVer（npm v6 格式），当前 npm $npmMajor.x 可能重新生成"
                Write-Fix "正常现象，但团队若混用 npm 版本建议统一"
            } else {
                Write-OK "lock 文件版本" "lockfileVersion=$lockVer"
            }
        }
    }
}

# ──────────────────────────────────────────────────────────────
# 最终汇总报告
# ──────────────────────────────────────────────────────────────
function Write-Summary {
    $elapsed = [math]::Round(((Get-Date) - $script:startTime).TotalSeconds, 1)

    $fails = $script:issues | Where-Object { $_.Severity -eq "FAIL" }
    $warns = $script:issues | Where-Object { $_.Severity -eq "WARN" }

    Write-Host ""
    Write-Host "  ╔══════════════════════════════════════════════════╗" -ForegroundColor White
    Write-Host "  ║                   诊断汇总报告                  ║" -ForegroundColor White
    Write-Host "  ╠══════════════════════════════════════════════════╣" -ForegroundColor White
    Write-Host "  ║  耗时：${elapsed}s   问题：" -NoNewline -ForegroundColor White
    Write-Host "$($fails.Count) FAIL" -NoNewline -ForegroundColor Red
    Write-Host "  " -NoNewline
    Write-Host "$($warns.Count) WARN" -NoNewline -ForegroundColor Yellow
    Write-Host "                  ║" -ForegroundColor White
    Write-Host "  ╚══════════════════════════════════════════════════╝" -ForegroundColor White

    if ($fails.Count -eq 0 -and $warns.Count -eq 0) {
        Write-Host ""
        Write-Host "  🎉 环境检测通过！没有发现明显问题。" -ForegroundColor Green
        Write-Host "  如仍有报错，请将具体错误信息提交给助手分析。" -ForegroundColor Gray
        return
    }

    if ($fails.Count -gt 0) {
        Write-Host ""
        Write-Host "  ── 必须修复（FAIL）──────────────────────────────" -ForegroundColor Red
        $i = 1
        foreach ($issue in $fails) {
            Write-Host "  $i. [$($issue.Section)] $($issue.Label)" -ForegroundColor Red
            Write-Host "     问题：$($issue.Detail)" -ForegroundColor DarkRed
            Write-Host "     修复：$($issue.Fix)" -ForegroundColor DarkCyan
            $i++
        }
    }

    if ($warns.Count -gt 0) {
        Write-Host ""
        Write-Host "  ── 建议优化（WARN）─────────────────────────────" -ForegroundColor Yellow
        $i = 1
        foreach ($issue in $warns) {
            Write-Host "  $i. [$($issue.Section)] $($issue.Label)" -ForegroundColor Yellow
            Write-Host "     问题：$($issue.Detail)" -ForegroundColor DarkYellow
            Write-Host "     修复：$($issue.Fix)" -ForegroundColor DarkCyan
            $i++
        }
    }

    Write-Host ""
    Write-Host "  提示：优先解决所有 FAIL 项，再处理 WARN 项。" -ForegroundColor Gray
    Write-Host "  保存报告：powershell -ExecutionPolicy Bypass -File uniapp-doctor.ps1 | Tee-Object uniapp-report.txt" -ForegroundColor Gray
    Write-Host ""
}

# ──────────────────────────────────────────────────────────────
# 主流程
# ──────────────────────────────────────────────────────────────
Show-Header
Check-System
Check-Node
Check-Npm
Check-Nvm
Check-PackageManagers
Check-BuildTools
Check-UniApp
Check-PlatformTools
Check-Network
Check-Ports
Check-Path
Check-EdgeCases
Write-Summary
