# -----------------------| 导包 |-----------------------
# Import-Module PSReadLine
# Import-Module posh-git
# Import-Module Terminal-Icons

# -----------------------| 设置主题 |-----------------------
$themePath = Join-Path -Path $PSScriptRoot -ChildPath "pwsh_theme.json"
oh-my-posh init pwsh --config $themePath | Invoke-Expression

# -----------------------| 基本设置 |-----------------------
# 设置预测文本来源为历史记录
# Set-PSReadLineOption -PredictionSource History

# 每次回溯输入历史，光标定位于输入内容末尾
Set-PSReadLineOption -HistorySearchCursorMovesToEnd

# 设置 Tab 为菜单补全和 Intellisense
Set-PSReadLineKeyHandler -Key "Tab" -Function MenuComplete

# 设置向上键为后向搜索历史记录
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward

# 设置向下键为前向搜索历史纪录
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

# -----------------------| 链接 |-----------------------
Set-Alias -Name c -Value clear

# -----------------------| 编码格式 |-----------------------
# 设置输出编码为 UTF-8
$OutputEncoding = [System.Text.Encoding]::UTF8
# 设置输入编码为 UTF-8
$InputEncoding = [System.Text.Encoding]::UTF8
# 设置控制台输出编码为 UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# -----------------------| 函数 |-----------------------
function IntelOneapiVars {
    cmd.exe "/K" '"D:\Intel\oneAPI\setvars.bat" && pwsh --NoLogo'
}

function open {
    explorer.exe .
}

function ProxyGitSet {
    git config --global http.proxy http://127.0.0.1:20172
    git config --global https.proxy https://127.0.0.1:20172
}

function ProxyGitUnset {
    git config --global --unset http.proxy
    git config --global --unset https.proxy
}

function ProxyScoopSet {
    scoop config proxy 127.0.0.1:20172
}

function ProxyScoopUnset {
    scoop config rm proxy
}
