local wezterm = require 'wezterm'
local config = {}

-- 启用Kitty键盘协议（核心中的核心！解决所有快捷键歧义问题）
config.enable_kitty_keyboard = true

-- 禁用输入法（Windows必加！防止输入法拦截Ctrl+Space等快捷键）
-- Linux/macOS如果需要中文输入，可以注释掉这行
config.use_ime = false

-- 自动设置正确的终端类型（远程会自动识别WezTerm）
config.term = 'wezterm'

-- Windows字体
config.font = wezterm.font_with_fallback {'Ubuntu Mono', 'CodeNewRoman Nerd Font Mono', '思源黑体'}

config.font_size = 18
config.line_height = 1.2

-- 主题（推荐使用内置的Dracula主题，护眼且对比度好）
config.color_scheme = 'Catppuccin Mocha'

-- 窗口设置
config.window_decorations = 'TITLE | RESIZE' -- 只保留边框，去掉标题栏
config.window_padding = {left = 5, right = 5, top = 5, bottom = 5}
config.integrated_title_buttons = { 'Hide', 'Maximize', 'Close' }

-- 标签页设置
config.hide_tab_bar_if_only_one_tab = true -- 只有一个标签时隐藏标签栏
config.tab_bar_at_bottom = true -- 标签栏放在底部
config.use_fancy_tab_bar = false -- 简洁标签栏

-- 光标设置
config.cursor_blink_rate = 500
config.default_cursor_style = 'BlinkingBlock'

config.default_prog = { 'pwsh.exe' }

return config
