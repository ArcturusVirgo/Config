local wezterm = require('wezterm')

-- 使用官方推荐的配置构建器，能提供更好的错误提示
local config = wezterm.config_builder()

-- ==========================================
-- 1. 核心与系统设置 (Core & System)
-- ==========================================
config.default_prog = { 'pwsh.exe' }

-- 解决 SSH 远程连接时报 "terminal is not fully functional" 的警告，以及 Neovim 颜色/排版异常。
config.term = 'xterm-256color'

-- 设置初始窗口大小（单位是字符数，不是像素）
config.initial_cols = 120  -- 默认宽度：120 列字符
config.initial_rows = 22   -- 默认高度：30 行字符

-- ==========================================
-- 2. 字体与外观 (Font & Appearance)
-- ==========================================
config.font = wezterm.font_with_fallback({
    'CodeNewRoman Nerd Font Mono',
    '思源黑体',
})
config.font_size = 18
config.line_height = 1.2

config.color_scheme = 'Catppuccin Mocha'

config.default_cursor_style = 'BlinkingBlock'
config.cursor_blink_rate = 500

-- ==========================================
-- 3. 窗口与标签页 UI (Window & Tabs)
-- ==========================================
-- 保留融合按钮和标签栏，以此作为鼠标拖拽的“把手”
config.window_decorations = 'INTEGRATED_BUTTONS | RESIZE'
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = false

-- 隐藏所有不必要的标签栏 UI 元素，让它看起来像是一条纯色的细边框
config.tab_bar_at_bottom = false
config.show_tab_index_in_tab_bar = false
config.show_new_tab_button_in_tab_bar = false

-- 统一个颜色，让顶部的拖拽区和终端背景融为一体
config.colors = {
    tab_bar = {
        background = '#1e1e2e', -- 替换为你 Catppuccin Mocha 主题的背景色
        active_tab = { bg_color = '#1e1e2e', fg_color = '#cdd6f4' },
        inactive_tab = { bg_color = '#1e1e2e', fg_color = '#a6adc8' },
    }
}

config.window_padding = {
    left = 20,
    right = 5,
    top = 5,
    bottom = 5,
}
-- ==========================================
-- 4. Neovim 兼容与交互强化 (Neovim & Terminal)
-- ==========================================
-- 启用 Kitty 键盘协议：让 Neovim 能精准识别 Ctrl+Shift+字母 等复杂组合键
config.enable_kitty_keyboard = true

-- 禁用输入法：防止 Windows 拦截 Ctrl+Space 等关键快捷键
-- (如果你偶尔需要在终端里打中文，推荐使用快捷键开关它，或者在 Neovim 里配置输入法切换插件)
config.use_ime = false

-- 向子进程注入环境变量
config.set_environment_variables = {
    -- 欺骗 Neovim，让它以为自己跑在 Windows Terminal 中
    -- 从而触发 Neovim 对现代终端光标控制的完全支持
    WT_SESSION = "1",
}

-- ==========================================
-- 5. 自定义标签页标题事件 (纯净模式)
-- ==========================================
wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
    -- 返回几个空格作为占位符，文字完全消失
    return {
        { Text = ' Hello Virgo ' },
    }
end)

return config
