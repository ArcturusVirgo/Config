vim.pack.add({
    -- 自动补全
    { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
})

-- blink.cmp 自动补全配置
require("blink.cmp").setup({
    keymap = {
        preset = "none",
        ["<C-Space>"] = {"show", "hide"},
        ["<CR>"] = {"accept", "fallback"},
        ["<C-j>"] = {"select_next", "fallback"},
        ["<C-k>"] = {"select_prev", "fallback"},
        ["<Tab>"] = {"snippet_forward", "fallback"},
        ["<S-Tab>"] = {"snippet_backward", "fallback"}
    },
    -- appearance = { nerd_font_variant = "mono" },
    completion = {menu = {auto_show = true}},
    sources = {default = {"lsp", "path", "buffer", "snippets"}},
    snippets = {
        expand = function(snippet) require("luasnip").lsp_expand(snippet) end
    },

    fuzzy = {
        implementation = "prefer_rust",
        prebuilt_binaries = {download = true}
    }
})

-- 全局LSP能力适配blink补全
vim.lsp.config["*"] = {
    capabilities = require("blink.cmp").get_lsp_capabilities()
}
