-- 判断当前操作系统
local sysname = vim.loop.os_uname().sysname
local is_windows = sysname:match("Windows")

-- 定义回到普通模式切换为英文，和进入插入模式恢复原状态的自动命令
local fcitx5_cmd_close = "fcitx5-remote -c"  -- 切换到英文 (非激活状态)
local fcitx5_cmd_open = "fcitx5-remote -o"   -- 切换到中文 (激活状态)

-- 针对 Windows 需要记住进入 Normal 前的输入法代号（默认英文为 1033）
local win_im_status = "1033"

vim.api.nvim_create_autocmd("InsertLeave", {
    pattern = "*",
    callback = function()
        if is_windows then
            -- 记录离开插入模式时的输入法状态
            win_im_status = vim.fn.system("im-select.exe"):gsub("\n", "")
            -- 强制切换到英文 (1033)
            vim.fn.system("im-select.exe 1033")
        else
            -- Linux 强制关闭 Fcitx5
            vim.fn.system(fcitx5_cmd_close)
        end
    end
})

vim.api.nvim_create_autocmd("InsertEnter", {
    pattern = "*",
    callback = function()
        if is_windows then
            -- 恢复原本的输入法状态
            vim.fn.system("im-select.exe " .. win_im_status)
        else
            -- Linux 下如果你希望进入插入模式默认开启中文，取消注释下面这行即可：
            -- vim.fn.system(fcitx5_cmd_open)
        end
    end
})

