vim.pack.add({
    -- 自动补全
    { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
})

-- blink.cmp 自动补全配置
require("blink.cmp").setup({
    keymap = {
        -- 建议保留默认预设（它包含了一些基础的比如上下箭头等），然后用下面的键位覆盖它
        preset = 'default',

        -- 【Ctrl + j / k】: 仅在补全窗口打开时切换项目；否则执行原生 Ctrl+j/k
        ['<C-j>'] = { 'select_next', 'fallback' },
        ['<C-k>'] = { 'select_prev', 'fallback' },

        -- 【Esc】: 优先关闭补全窗口 ('cancel')；若窗口没开，则执行原生 Esc（退出到 Normal 模式，这同时也会打断代码片段的跳转逻辑）
        ['<Esc>'] = { 'cancel', 'fallback' },

        -- 【Enter】: 仅用于确认补全；否则执行原生换行
        ['<CR>']  = { 'accept', 'fallback' },

        -- 【Tab】: 这是整个配置的精髓！
        -- 第一顺位：如果有补全窗口，确认补全 ('accept')
        -- 第二顺位：如果没有补全窗口，但在代码片段中，跳到下一个位置 ('snippet_forward')
        -- 第三顺位：如果啥都没有，输入一个真实的 Tab 制表符 ('fallback')
        ['<Tab>'] = { 'accept', 'snippet_forward', 'fallback' },

        -- 【Shift + Tab】: 在代码片段中跳到上一个位置；否则原生 Shift+Tab
        ['<S-Tab>'] = { 'snippet_backward', 'fallback' },

        -- preset = "none",
        -- ["<C-Space>"] = {'show', 'show_documentation', 'hide_documentation'},
        -- ["<CR>"] = {"accept", "fallback"},
        -- ['<C-e>'] = { 'hide', 'fallback' },
        -- ["<C-j>"] = {"select_next", "fallback"},
        -- ["<C-k>"] = {"select_prev", "fallback"},
        -- -- 代码片段前后跳转
        -- ['<Tab>'] = { 'snippet_forward', 'fallback' },
        -- ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
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
