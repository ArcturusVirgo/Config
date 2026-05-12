vim.pack.add({
    { src = 'https://github.com/nvim-mini/mini.icons'},
    { src = 'https://github.com/stevearc/oil.nvim'},
})

require("oil").setup({
    default_file_explorer = true,
    -- See :help oil-columns
    columns = {
    "icon",
    -- "permissions",
    -- "size",
    -- "mtime",
    },
  keymaps = {
    -- 使用 Backspace 返回上一级目录
    ["<BS>"] = "actions.parent",

    -- 可选：Oil 默认使用 "-" 返回上一级，如果你想完全禁用默认的 "-"，可以取消下面这行的注释
    ["-"] = "actions.close", 
  },
})

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "打开文件管理器 (Oil)" })

