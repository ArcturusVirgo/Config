local opt = vim.opt

-----------------------------------------------------------
-- 1. 基础与文件编码
-----------------------------------------------------------
opt.fileencoding = "utf-8"     -- 设置文件默认编码为 utf-8，避免中文乱码
opt.encoding = "utf-8"
opt.fileencodings = "utf-8,gb18030,gbk,cp936,latin1"
opt.updatetime = 250           -- 降低交换文件的写入延迟 (默认 4000ms)，让插件响应更快
opt.timeoutlen = 300           -- 按键序列等待时间 (毫秒)，缩短以提升快捷键响应感

-----------------------------------------------------------
-- 2. 外观与界面 (UI)
-----------------------------------------------------------
opt.termguicolors = true       -- 启用真彩色支持
opt.number = true              -- 显示绝对行号
opt.relativenumber = true      -- 显示相对行号，非常有利于配合 j/k 进行多行跳转
opt.cursorline = true          -- 高亮当前光标所在行
opt.signcolumn = "yes"         -- 始终显示左侧的标志列 (防止 LSP 诊断信息出现时屏幕左右抖动)
opt.scrolloff = 10             -- 光标上下两侧始终保留至少 10 行的上下文可视区域
opt.sidescrolloff = 10         -- 左右滚动时保留的列数
opt.wrap = false               -- 禁止长行自动折行显示

-----------------------------------------------------------
-- 3. 缩进与空格 (适合 Python / Fortran 等严格对齐的语言)
-----------------------------------------------------------
opt.tabstop = 4                -- 1 个 Tab 键等于 4 个空格的宽度
opt.shiftwidth = 4             -- 每次自动缩进的宽度为 4 个空格
opt.expandtab = true           -- 将输入的 Tab 自动展开为空格 (极其重要，防止在不同机器上排版错乱)
opt.smartindent = true         -- 开启智能缩进 (在输入新行时自动匹配上一行的缩进级别)
opt.autoindent = true          -- 保持与上一行相同的缩进

-----------------------------------------------------------
-- 4. 搜索与匹配
-----------------------------------------------------------
opt.ignorecase = true          -- 搜索时默认忽略大小写
opt.smartcase = true           -- 智能大小写：如果搜索词中包含大写字母，则转为精确匹配大小写
opt.hlsearch = true           -- 搜索完成后取消所有匹配项的高亮 (避免屏幕看起来太乱)
opt.incsearch = true           -- 增量搜索：在输入搜索词的过程中实时高亮匹配结果

-----------------------------------------------------------
-- 5. 窗口分割行为
-----------------------------------------------------------
opt.splitright = true          -- 垂直分屏时 (vsplit)，新窗口默认在右侧
opt.splitbelow = true          -- 水平分屏时 (split)，新窗口默认在下方

-----------------------------------------------------------
-- 6. 其他实用配置
-----------------------------------------------------------
opt.mouse = ''                 -- 允许在所有模式下使用鼠标 (点击跳转光标、调整窗口大小等)
opt.undofile = false            -- 开启持久化撤销历史 (即使关闭文件再打开，依然可以撤销之前的修改)
opt.swapfile = false           -- 禁用 swap 文件 (现代编辑器通常不需要，搭配 undofile 更好)
-- 关闭自动切换到当前文件目录
opt.autochdir = false

-----------------------------------------------------------
-- 7. Fortran 语法高亮增强 (High Precision Mode)
-----------------------------------------------------------
vim.g.fortran_more_precise = 1 -- 开启更精确的关键字、函数匹配
vim.g.fortran_fixed_source = 1 -- 强制启用固定格式(F77)特有规则
vim.g.fortran_have_tabs = 1    -- 允许解析旧代码中不规范的 Tab
vim.g.fortran_do_enddo = 1     -- 强制区分并高亮 DO 和 ENDDO 块

-----------------------------------------------------------
-- 7. 代码折叠
-----------------------------------------------------------
-- 启用折叠
vim.opt.foldenable = true
vim.opt.foldlevel = 99          -- 默认展开所有（0=全折叠）
vim.opt.foldlevelstart = 99 
vim.opt.foldcolumn = "1"        -- 左侧显示折叠标记列
-- 折叠方法（三选一）
-- vim.opt.foldmethod = "indent"   -- 按缩进折叠（通用）
-- vim.opt.foldmethod = "syntax"  -- 按语法折叠（需文件类型支持）
-- vim.opt.foldmethod = "manual"  -- 手动创建折叠
-- 优先 Tree-sitter，否则 indent
local status, _ = pcall(require, "nvim-treesitter")
if status then
  vim.opt.foldmethod = "expr"
  vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
else
  vim.opt.foldmethod = "indent"
end

-----------------------------------------------------------
-- 剪切板 (支持本地与 SSH 环境智能切换)
-----------------------------------------------------------
-- 判断当前是否处于 SSH 环境
local is_ssh = vim.env.SSH_CLIENT ~= nil or vim.env.SSH_TTY ~= nil

if is_ssh then
    -- ==========================================
    -- [ SSH 环境策略 ]
    -- ==========================================
    -- 1. 保持 Neovim 内部寄存器独立，确保 'p' 秒贴，防止向 WezTerm 索要数据卡死
    -- 注意：这里不设置 opt.clipboard

    -- 2. 监听文本 Yank 事件，主动将内容发送到本地 Windows 剪贴板
    vim.api.nvim_create_autocmd("TextYankPost", {
        group = vim.api.nvim_create_augroup("OSC52Yank", { clear = true }),
        callback = function()
            -- 仅当操作是 'y' (复制) 时才同步到本地剪贴板
            -- 避免按 'd' 或 'x' 删除文本时污染 Windows 剪贴板
            if vim.v.event.operator == 'y' then
                require('vim.ui.clipboard.osc52').copy('+')(vim.v.event.regcontents)
            end
        end,
    })
else
    -- ==========================================
    -- [ 本地环境策略 ]
    -- ==========================================
    -- 直接将 Neovim 的默认寄存器绑定到系统剪贴板
    -- 因为在本地，系统剪贴板工具（如 win32yank 或 wl-copy）是可以直接调用的
    vim.opt.clipboard = "unnamedplus"
end

-----------------------------------------------------------
-- 设置高亮行样式
-----------------------------------------------------------
local augroup = vim.api.nvim_create_augroup("CustomCursorLine", { clear = true })
-- 3. 监听 ColorScheme 事件，确保在主题加载后强制覆盖样式
vim.api.nvim_create_autocmd("ColorScheme", {
    group = augroup,
    pattern = "*",
    callback = function()
        -- 覆盖 CursorLine 高亮组：只开启下划线，不设置背景色
        vim.api.nvim_set_hl(0, "CursorLine", {
            underline = true,
            -- bg = "NONE" -- 默认省略 bg 就会清除背景色，如果你用的主题比较固执，可以取消注释这行强制清除
        })
    end,
})
-- 4. 如果你当前没有显式加载任何第三方主题，手动触发一次以确保配置在启动时生效
vim.cmd("doautocmd ColorScheme")

-----------------------------------------------------------
-- 启动时一次性设置工作目录（永不自动切换）
-----------------------------------------------------------
vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*",
  once = true, -- 关键：只执行一次
  callback = function()
    -- 获取命令行参数
    local args = vim.v.argv
    if #args < 2 then return end -- 没有参数，保持当前目录

    -- 找到第一个非选项参数（跳过 -c、-u 等选项）
    local target = nil
    for i = 2, #args do
      local arg = args[i]
      if not arg:match("^%-") then
        target = arg
        break
      end
    end

    if not target then return end

    -- 解析绝对路径
    local abs_path = vim.fn.fnamemodify(target, ":p")
    local stat = vim.loop.fs_stat(abs_path)
    if not stat then return end

    local cwd
    if stat.type == "directory" then
      -- 打开的是目录：工作目录设为该目录
      cwd = abs_path
    else
      -- 打开的是文件：工作目录设为文件所在目录
      cwd = vim.fn.fnamemodify(abs_path, ":h")
    end

    -- 设置工作目录（全局生效，所有标签页/分屏共享）
    vim.cmd.cd(cwd)
    vim.notify("Working directory has been fixed: " .. cwd, vim.log.levels.INFO)
  end,
})

