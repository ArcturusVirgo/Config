vim.pack.add({
    -- 行后诊断信息显示
    { src = "https://www.github.com/rachartier/tiny-inline-diagnostic.nvim" }
})

require("tiny-inline-diagnostic").setup({})

vim.diagnostic.config({virtual_text = false}) -- Disable Neovim's default virtual text diagnostics
