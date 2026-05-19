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
    end,

    filetypes = { "fortran" },
})

-- 启用LSP
vim.lsp.enable({'lua_ls', 'fortls', 'pyright'})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        -- 针对 fortls 的特定处理 (语义高亮)
        if client and client.name == "fortls" then
            if client.server_capabilities.semanticTokensProvider then
                vim.b[args.buf].semantic_tokens_ready = true
            end
        end

        -- 2. 🌟 绑定快捷键：将 gd 映射为 LSP 的跳转定义
        -- 注意：必须加 { buffer = args.buf }，这样这个快捷键才只在这个文件里生效，不会干扰非代码文件
        local opts = { buffer = args.buf, desc = "LSP: Go to definition" }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)

        -- 你还可以顺便把其他常用 LSP 功能也绑上，比如：
        -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = args.buf, desc = "LSP: Hover Documentation" }) -- 悬浮查看注释
        -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = args.buf, desc = "LSP: Go to references" }) -- 查找引用
    end,
})

