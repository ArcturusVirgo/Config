vim.g.mapleader = " " -- 设置主快捷键为空格
vim.g.maplocalleader = " " -- 设置局部快捷键为空格

local keymap = vim.keymap.set

-- ==========================================
-- 移动代码块 / 当前行
-- ==========================================
-- 在 Visual 模式下，J 和 K 负责上下移动选中的代码块
keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "向下移动选中代码块" })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "向上移动选中代码块" })

-- ==========================================
-- 代码缩进
-- ==========================================
-- < 连按两次表示向左缩进，> 连按两次表示向右缩进
keymap("n", "<", "<<", { desc = "向左缩进当前行" })
keymap("n", ">", ">>", { desc = "向右缩进当前行" })
-- Visual 模式：选中代码块缩进
-- 强烈建议保留 "x" 模式，而不是 "v"，以防止在代码片段(Snippets)占位符中误触
-- gv 用于在缩进操作完成后，自动重新选中之前的代码块，实现极其流畅的连续缩进
keymap("x", "<", "<gv", { desc = "向左缩进并保持选中" })
keymap("x", ">", ">gv", { desc = "向右缩进并保持选中" })

-- ==========================================
-- 窗口切换
-- ==========================================
keymap("n", "<A-h>", "<C-w>h", { desc = "切换到左侧窗口" })
keymap("n", "<A-j>", "<C-w>j", { desc = "切换到下方窗口" })
keymap("n", "<A-k>", "<C-w>k", { desc = "切换到上方窗口" })
keymap("n", "<A-l>", "<C-w>l", { desc = "切换到右侧窗口" })

-- ==========================================
-- 高亮相关
-- ==========================================
-- 按下 Esc 时，不仅执行 Esc 原有的功能，还会顺便清除搜索高亮
keymap("n", "<Esc>", "<CMD>nohlsearch<CR><Esc>", { desc = "清除搜索高亮" })
keymap("n", "<leader>nh", "<CMD>nohlsearch<CR>", { desc = "清除搜索高亮" })

-- ==========================================
-- 复制当前行或选中内容
-- ==========================================
keymap("n", "<C-d>", "yyp", { desc = "Ctrl+D 复制当前行" })
keymap("v", "<C-d>", "y`>p", { desc = "Ctrl+D 复制选中内容" })

-- ==========================================
-- 翻页或跳转
-- ==========================================
keymap("n", "n", "nzzzv", { desc = "跳到下一个搜索结果并居中" })
keymap("n", "N", "Nzzzv", { desc = "跳到上一个搜索结果并居中" })
keymap("n", "<C-j>", "<C-d>zz", { desc = "向下翻半页并居中" })
keymap("n", "<C-k>", "<C-u>zz", { desc = "向上翻半页并居中" })

-- ==========================================
-- 列编辑
-- ==========================================
keymap("n", "<C-q>", "<C-v>", { desc = "列编辑" })

-- ==========================================
-- 跳转错误/诊断信息
-- ==========================================
-- 跳转到 下一个/上一个 诊断（错误+警告）
keymap("n", "]d", vim.diagnostic.goto_next, { desc = "下一个诊断（错误/警告）" })
keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "上一个诊断（错误/警告）" })
-- 只跳 下一个/上一个 错误（忽略警告）
keymap("n", "]e", function()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "下一个错误" })
keymap("n", "[e", function()
  vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "上一个错误" })

-- ==========================================
-- 切换注释
-- ==========================================
local function toggle_comment_insert()
    -- 获取当前行内容
    local line = vim.api.nvim_get_current_line()

    -- 匹配空行（包含全空格的行）
    if line:match("^%s*$") then
        local cs = vim.bo.commentstring
        if cs and cs ~= "" then
            -- 将 commentstring (例如 "-- %s") 中的 %s 替换为空，插入到当前行
            local leader = cs:gsub("%%s", "")
            vim.api.nvim_set_current_line(line .. leader)
            -- 将光标移动到行尾，保持插入模式
            vim.cmd("startinsert!")
        end
    else
        -- 如果不是空行，使用原本的逻辑：退回 Normal -> 注释 -> 在行尾继续插入
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>gcca", true, false, true), "m", false)
    end
end
local function toggle_comment_normal()
    local line = vim.api.nvim_get_current_line()
    if line:match("^%s*$") then
        local cs = vim.bo.commentstring
        if cs and cs ~= "" then
            local leader = cs:gsub("%%s", "")
            vim.api.nvim_set_current_line(line .. leader)
            -- 普通模式下注释空行后，自动进入插入模式会更顺手
            vim.cmd("startinsert!")
        end
    else
        -- 触发 gcc 
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("gcc", true, false, true), "m", false)
    end
end
-- 设置快捷键
keymap("n", "<C-_>", toggle_comment_normal, { desc = "Ctrl+/ 注释当前行(智能空行)" })
keymap("v", "<C-_>", "gc",  { remap = true, desc = "Ctrl+/ 注释选中块" })
keymap("i", "<C-_>", toggle_comment_insert, { desc = "插入模式切换行注释(智能空行)" })
-- 兼容部分终端识别为 <C-/>
keymap("n", "<C-/>", toggle_comment_normal, { desc = "Ctrl+/ 注释当前行(智能空行)" })
keymap("v", "<C-/>", "gc",  { remap = true, desc = "Ctrl+/ 注释选中块" })
keymap("i", "<C-/>", toggle_comment_insert, { desc = "插入模式切换行注释(智能空行)" })

-- ==========================================
-- 重启 nvim
-- ==========================================
keymap("n", "<leader>re", ":restart<CR>", { desc = "重启 nvim"})

-- ==========================================
-- 剪切板相关 noremap
-- ==========================================
-- 将普通模式 (n) 和可视模式 (v) 下的 d 映射为 "_d
keymap({'n', 'v'}, 'd', '"_d', { noremap = true })
-- 如果你希望大写的 D (删除到行尾) 也同样不污染剪贴板：
keymap({'n', 'v'}, 'D', '"_D', { noremap = true })

-- ==========================================
-- 跳转行首行尾 noremap
-- ==========================================
keymap({'n', 'v', 'o'}, 'H', '^', { noremap = true, desc = 'Go to start of line' })
keymap({'n', 'v', 'o'}, 'L', '$', { noremap = true, desc = 'Go to end of line' })

-- ==========================================
-- 取消绑定 noremap
-- ==========================================
-- 禁用 J 键的默认功能（向下合并行），以防止误触导致排版混乱
keymap("n", "J", "<Nop>", { noremap = true, silent = true })
-- 禁用 q 键的默认功能（录制宏），以防止误触导致意外录制和性能问题
keymap("n", "q", "<Nop>", { noremap = true, silent = true })
-- 禁用 Q 键的默认功能（进入 Ex 模式），以防止误触导致编辑中断
keymap("n", "Q", "<Nop>", { noremap = true, silent = true })
-- 禁用帮助跳转
keymap('n', 'K', '<Nop>', { noremap = true, silent = true })




