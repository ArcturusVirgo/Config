vim.pack.add({
    -- 文件树
    { src = "https://github.com/nvim-tree/nvim-tree.lua"},
})


-- 文件树配置
require("nvim-tree").setup({
    view = {
        width = 35 -- 文件树宽度
    },
    filters = {
        dotfiles = false -- 显示隐藏文件
    },
    renderer = {
        group_empty = false -- 不合并空文件夹
    }
})

vim.keymap.set("n", "<leader>e",
               function() require("nvim-tree.api").tree.toggle() end,
               {desc = "开关文件树"})

