vim.pack.add({
    -- LSP
    { src = "https://github.com/mason-org/mason.nvim"},
    { src = "https://github.com/neovim/nvim-lspconfig"},
})


require('mason').setup({})

-- 各语言LSP单独配置
vim.lsp.config("lua_ls", {})
vim.lsp.config("pyright", {})
vim.lsp.config("fortls", {
    single_file_support = true,
    cmd = {
        "fortls", "--notify_init", "--hover_signature", "--use_signature_help",
        "--lowercase_intrinsics",
        -- 确保 LSP 能够处理并返回所有的符号信息
        "--enable_code_actions"
    },
    -- 确保当 fortls 连接成功后，Neovim 的语义高亮引擎接管文本颜色
    on_attach = function(client, bufnr)
        -- Neovim 0.12 默认开启语义高亮，但为了保险起见，我们可以在这里显式声明
        if client.server_capabilities.semanticTokensProvider then
            -- 很多老代码的语义令牌返回较慢，这能确保它覆盖原生正则高亮
            vim.b[bufnr].semantic_tokens_ready = true
        end
    end
})

-- 启用LSP
vim.lsp.enable({'lua_ls', 'fortls', 'pyright'})
