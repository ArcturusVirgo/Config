local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- ==================================================
-- 参数
-- ==================================================
-- windows
local target_shell = "pwsh"
local ubuntu_font_name = "Ubuntu Mono"
local char_with = 120
local char_height = 22
local font_size = 18
-- linux
if  wezterm.target_triple:find('linux') then
    target_shell = "bash"
    ubuntu_font_name = "UbuntuMono Nerd Font Mono"
    char_with = 110
    char_height = 25
    font_size = 20
end

-- ==================================================
-- 基础配置
-- ==================================================
-- 启用Kitty键盘协议
config.enable_kitty_keyboard = true
-- 自动设置正确的终端类型
config.term = 'wezterm'
-- 禁用输入法
config.use_ime = false
-- 解决 SSH 远程连接时报 "terminal is not fully functional" 的警告，以及 Neovim 颜色/排版异常。
config.term = 'xterm-256color'
-- 默认终端
config.default_prog = { target_shell }

-- ==================================================
-- 外观配置
-- ==================================================
-- 主题
config.color_scheme = 'Catppuccin Mocha'
-- 字体
config.font_size = font_size
config.line_height = 1.2
config.font = wezterm.font_with_fallback {ubuntu_font_name, 'CodeNewRoman Nerd Font Mono', '思源黑体'}
-- 光标设置
config.cursor_blink_rate = 500

-- ==================================================
-- 窗口设置
-- ==================================================
-- 行列数作为基础确定窗口大小
config.initial_cols = char_with
config.initial_rows = char_height
-- 保留融合按钮和标签栏，以此作为鼠标拖拽的“把手”
config.window_decorations = 'INTEGRATED_BUTTONS | RESIZE'
config.integrated_title_buttons = { 'Hide', 'Maximize', 'Close' }
-- 标签页设置
config.hide_tab_bar_if_only_one_tab = false -- 只有一个标签时隐藏标签栏
config.use_fancy_tab_bar = false -- 简洁标签栏
config.tab_bar_at_bottom = false -- 标签栏放在底部
config.show_new_tab_button_in_tab_bar = false
config.show_tab_index_in_tab_bar = false
-- 统一个颜色，让顶部的拖拽区和终端背景融为一体
config.colors = {
    tab_bar = {
        background = '#1e1e2e', -- 替换为你 Catppuccin Mocha 主题的背景色
        active_tab = { bg_color = '#1e1e2e', fg_color = '#cdd6f4' },
        inactive_tab = { bg_color = '#1e1e2e', fg_color = '#a6adc8' },
    }
}
-- 边距设置
config.window_padding = {left = 20, right = 5, top = 5, bottom = 5}
-- 自定义标签页标题事件
wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
    -- 返回几个空格作为占位符，文字完全消失
    return {
        { Text = ' Hello Virgo ' },
    }
end)

-- ==========================================
-- Neovim 兼容与交互强化
-- ==========================================
-- 向子进程注入环境变量
config.set_environment_variables = {
    -- 欺骗 Neovim，让它以为自己跑在 Windows Terminal 中
    -- 从而触发 Neovim 对现代终端光标控制的完全支持
    WT_SESSION = "1",
}




return config
