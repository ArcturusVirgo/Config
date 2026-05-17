vim.pack.add({
    {src = "https://github.com/folke/which-key.nvim"},
})

-- 加载并配置 which-key.nvim
local wk = require("which-key")

wk.setup({
    keys = {
        scroll_down = "<c-f>", -- 将向下翻页改为 Ctrl+f
        scroll_up = "<c-b>",   -- 将向上翻页改为 Ctrl+b
  },
  -- 使用现代风格预设（可选："classic" | "modern" | "helix"）
  preset = "modern",
  -- 基本设置
  delay = 300, -- 显示提示的延迟时间（毫秒）
  timeoutlen = 300, -- 按键超时时间
  -- 插件功能开关
  plugins = {
    marks = true, -- 显示标记
    registers = true, -- 显示寄存器
    spelling = {
      enabled = true, -- 拼写检查建议
      suggestions = 20,
    },
    presets = {
      operators = true, -- 操作符提示（d, y, c 等）
      motions = true, -- 移动命令提示
      text_objects = true, -- 文本对象提示
      windows = true, -- 窗口操作提示（<C-w>）
      nav = true, -- 导航提示
      z = true, -- z 系列命令提示
      g = true, -- g 系列命令提示
    },
  },
  -- 窗口样式
  win = {
    border = "rounded", -- 圆角边框
    padding = { 1, 2 }, -- 内边距
  },
})

-- 注册快捷键分组（可选但推荐）
wk.add({
})
