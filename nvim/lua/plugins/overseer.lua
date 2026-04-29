vim.pack.add({
    -- 任务管理
    {src = "https://github.com/stevearc/overseer.nvim"}
})

local custom_utils = require("common.utils")
require("overseer").setup({
    -- 核心配置：告诉 overseer 去寻找并解析 .vscode/tasks.json
    templates = {"builtin", "vscode"},

    -- 可选配置：让任务界面看起来更现代
    strategy = "terminal",
    dap = false -- 交给 nvim-dap 处理 dap 逻辑
})

-- keymaps
vim.keymap.set("n", "<leader>tr", "<cmd>OverseerRun<CR>", { desc = "Run Task" })
vim.keymap.set("n", "<F3>", "<cmd>OverseerRun<CR>", { desc = "Run Task" })
vim.keymap.set("n", "<leader>tt", "<cmd>OverseerToggle<CR>", { desc = "Toggle Task Panel" })
vim.keymap.set("n", "<F2>", "<cmd>OverseerToggle<CR>", { desc = "Toggle Task Panel" })
-- vim.keymap.set('n', '<Leader>rl', '<cmd>OverseerRun<cr>', {desc = 'Overseer run templates'})
-- vim.keymap.set('n', '<F3>', '<cmd>OverseerRun<cr>', {desc = 'Overseer run templates'})
-- local toggle_overseer = function()
--     vim.cmd 'OverseerToggle'
--     custom_utils.func_on_window('dapui_stacks', function()
--         require('dapui').open {reset = true}
--     end)
-- end
-- vim.keymap.set('n', '<Leader>ro', toggle_overseer, {desc = 'Overseer toggle task list'})
-- vim.keymap.set('n', '<C-\\>', toggle_overseer, {desc = 'Overseer toggle task list'})
-- vim.keymap.set('n', '<F2>', toggle_overseer, {desc = 'Overseer toggle task list'})
-- vim.keymap.set('n', '<Leader>ra', '<cmd>OverseerQuickAction<cr>', {desc = 'Overseer quick action list'})

-- -- autocmds
-- vim.api.nvim_create_autocmd('FileType', {
--     pattern = 'OverseerList',
--     callback = function() vim.opt_local.winfixbuf = true end
-- })
