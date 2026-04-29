vim.pack.add({
    -- 主题
    { src = "https://github.com/Ferouk/bearded-nvim"},
})


require("bearded").setup({flavor = "arc"})

vim.cmd.colorscheme("bearded")

