vim.pack.add({
    { src = "https://github.com/folke/flash.nvim"}
})

-- 1. 加载并设置 Flash
require("flash").setup({
  -- 大部分情况下保持默认即可，这里开启对原生搜索的增强
  modes = {
    search = {
      enabled = true, -- 将 Neovim 原生的 `/` 和 `?` 搜索无缝升级为 Flash 搜索
    },
  },
})

-- 2. 设置核心快捷键
local flash = require("flash")

-- 【s】常规跳转：在 Normal、Visual 和 Operator-pending 模式下可用
vim.keymap.set({ "n", "x", "o" }, "s", function() flash.jump() end, { desc = "Flash 跳转" })

-- 【S】Treesitter 智能选择：基于语法树选中代码块（函数、类、括号块等）
vim.keymap.set({ "n", "x", "o" }, "S", function() flash.treesitter() end, { desc = "Flash Treesitter 选中" })

-- 【r】远程操作 (Remote)：在 Operator-pending 模式下使用
vim.keymap.set("o", "r", function() flash.remote() end, { desc = "Flash 远程操作" })

-- 【R】Treesitter 远程搜索：结合了 Treesitter 和远程操作
vim.keymap.set({ "o", "x" }, "R", function() flash.treesitter_search() end, { desc = "Flash Treesitter 搜索" })

-- 【Ctrl-s】在搜索模式 (/) 中临时切换 Flash
vim.keymap.set({ "c" }, "<c-s>", function() flash.toggle() end, { desc = "Toggle Flash Search" })
