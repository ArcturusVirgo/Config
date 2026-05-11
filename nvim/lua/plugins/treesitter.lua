vim.pack.add({
    -- 语法解析
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", branch = "main", build = ":TSUpdate" },
})


local setup_treesitter = function()
    local treesitter = require("nvim-treesitter")
    treesitter.setup({
        fold = { enable = true }, -- 启用 Tree-sitter 折叠
    })
    -- 预设需要安装的语法解析器
    local ensure_installed = {
        "vim", "vimdoc", "rust", "c", "cpp", "go", "html", "css", "javascript",
        "json", "lua", "markdown", "python", "typescript", "vue", "svelte",
        "bash", "fortran"
    }

    local config = require("nvim-treesitter.config")

    local already_installed = config.get_installed()
    local parsers_to_install = {}

    -- 筛选未安装的解析器并自动安装
    for _, parser in ipairs(ensure_installed) do
        if not vim.tbl_contains(already_installed, parser) then
            table.insert(parsers_to_install, parser)
        end
    end

    if #parsers_to_install > 0 then
        require("nvim-treesitter.install").install(parsers_to_install)
    end

    -- 识别文件类型自动启用treesitter
    local group = vim.api
                      .nvim_create_augroup("TreeSitterConfig", {clear = true})
    vim.api.nvim_create_autocmd("FileType", {
        group = group,
        callback = function(args)
            if vim.list_contains(treesitter.get_installed(),
                                 vim.treesitter.language.get_lang(args.match)) then
                vim.treesitter.start(args.buf)
            end
        end
    })
end

setup_treesitter() -- 初始化treesitter

