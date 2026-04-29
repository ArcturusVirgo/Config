-- ========================================================
-- 高亮 1-6 73 列，模拟 Fortran 77 固定格式的视觉效果
-- ========================================================
-- [底色] 1-6 列无字符时的深邃沟渠 (使用最暗的 Crust)
vim.api.nvim_set_hl(0, "FortranVoidBlock", { bg = "#1A212F" })
-- [覆盖色] 第1列 (注释区)：次暗的 Mantle 背景 + 标志性的 Macchiato 蓝
vim.api.nvim_set_hl(0, "FortranCol1", { bg = "#1E273A", fg = "#5094C9" })
-- [覆盖色] 第2-5列 (标号区)：保持最暗背景 + 柔和的暖黄
vim.api.nvim_set_hl(0, "FortranCol2to5", { bg = "#1C2433", fg = "#B59E54" })
-- [覆盖色] 第6列 (续行区)：稍微凸显的 Surface0 背景 + 柔和的樱桃红
vim.api.nvim_set_hl(0, "FortranCol6", { bg = "#2D1E26", fg = "#C46A7C", bold = false })


local fortran_augroup = vim.api.nvim_create_augroup("FortranSpecialConfig", { clear = true })

-- 擦除当前窗口的高亮 (Teardown)
local function clear_f77_matches(win)
    local ok1, m1 = pcall(vim.api.nvim_win_get_var, win, "f77_match_1")
    if ok1 then pcall(vim.fn.matchdelete, m1, win) end

    local ok2, m2 = pcall(vim.api.nvim_win_get_var, win, "f77_match_2")
    if ok2 then pcall(vim.fn.matchdelete, m2, win) end

    local ok6, m6 = pcall(vim.api.nvim_win_get_var, win, "f77_match_6")
    if ok6 then pcall(vim.fn.matchdelete, m6, win) end

    pcall(vim.api.nvim_win_del_var, win, "f77_match_1")
    pcall(vim.api.nvim_win_del_var, win, "f77_match_2")
    pcall(vim.api.nvim_win_del_var, win, "f77_match_6")
end

-- 绘制当前窗口的高亮 (Setup)
local function apply_f77_matches(win)
    clear_f77_matches(win) -- 绘制前先清理，防止叠加
    
    -- 使用优先级 10 强制覆盖语法引擎，并绑定到特定 window
    local m1 = vim.fn.matchadd("FortranCol1", "\\%1v.", 10, -1, {window = win})
    local m2 = vim.fn.matchadd("FortranCol2to5", "\\%>1v\\%<7v.", 10, -1, {window = win})
    local m6 = vim.fn.matchadd("FortranCol6", "\\%6v.", 10, -1, {window = win})
    
    -- 将返回的 ID 存入窗口变量中，方便离开时删除
    vim.api.nvim_win_set_var(win, "f77_match_1", m1)
    vim.api.nvim_win_set_var(win, "f77_match_2", m2)
    vim.api.nvim_win_set_var(win, "f77_match_6", m6)
end

-- A. 当打开文件时处理基础属性
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    group = fortran_augroup,
    pattern = {"*.for", "*.f", "*.f77"},
    callback = function(args)
        vim.bo[args.buf].filetype = "fortran"
        vim.bo[args.buf].tabstop = 3
        vim.bo[args.buf].shiftwidth = 3
        vim.bo[args.buf].expandtab = true
    end,
})

vim.api.nvim_create_autocmd({"BufEnter", "WinEnter"}, {
    group = fortran_augroup,
    pattern = {"*.for", "*.f", "*.f77"},
    callback = function()
        local win = vim.api.nvim_get_current_win()
        
        -- 画出 1-6 列的基础深色背景和 73 列的参考线
        -- vim.api.nvim_set_option_value("colorcolumn", "1,2,3,4,5,6", { win = win })
        vim.api.nvim_set_option_value("colorcolumn", "1,2,3,4,5,6,73", { win = win })
        vim.api.nvim_set_option_value("winhl", "ColorColumn:FortranVoidBlock", { win = win })
        
        -- 画上精准的字符高亮
        apply_f77_matches(win)
    end,
})

vim.api.nvim_create_autocmd({"BufLeave", "WinLeave"}, {
    group = fortran_augroup,
    pattern = {"*.for", "*.f", "*.f77"},
    callback = function()
        local win = vim.api.nvim_get_current_win()
        
        -- 取消 1-6 列和 73 列的底色背景
        vim.api.nvim_set_option_value("colorcolumn", "", { win = win })
        vim.api.nvim_set_option_value("winhl", "", { win = win })
        
        -- 删掉 matchadd 的正则匹配
        clear_f77_matches(win)
    end,
})

-- ========================================================
-- 取消 Neovim 0.12 原生的 Treesitter 解析器对 Fortran 的支持，强行启用传统正则语法引擎
-- ========================================================
vim.api.nvim_create_autocmd({"BufEnter", "FileType"}, {
    group = fortran_augroup,
    -- 同时监听后缀和文件类型事件，确保绝对不会漏网
    pattern = {"*.for", "*.f", "*.f77", "fortran"}, 
    callback = function(args)
        local filename = vim.api.nvim_buf_get_name(args.buf)
        local ext = vim.fn.fnamemodify(filename, ":e")
        
        if ext == "f" or ext == "for" or ext == "f77" then
            -- 1. 强行停止 Neovim 0.12 原生的 Treesitter 解析器
            pcall(vim.treesitter.stop, args.buf)
            
            -- 2. 强行卸载 nvim-treesitter 插件的高亮模块
            pcall(vim.cmd, "TSBufDisable highlight")
            
            -- 3. 重新唤醒传统正则语法引擎，接管阵地
            vim.bo[args.buf].syntax = "fortran"
        end
    end,
})

