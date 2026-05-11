-- 终端插件
vim.pack.add({
    {src = "https://github.com/akinsho/toggleterm.nvim", }
})

require("toggleterm").setup({
    shell = 'pwsh',
    -- 默认打开的快捷键 (这里设置为 Ctrl + \，你也可以换成 Ctrl + t 等)
    open_mapping = [[<c-\>]],

    -- 根据终端打开的方向设定大小
    size = function(term)
    if term.direction == "horizontal" then
      return 15
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
    end,

    -- 终端变暗（让终端背景比主编辑器稍暗一点，更有层次感）
    shade_terminals = true,
    shading_factor = 2,

    -- 终端启动方向："horizontal" | "vertical" | "window" | "float"
    -- 强烈推荐平时默认用 float（浮动），最不干扰写代码
    direction = "float",

    -- 浮动窗口的特定设置
    float_opts = {
    border = "curved", -- 边框样式："single" | "double" | "shadow" | "curved"
    winblend = 0,      -- 透明度
    title_pos = "center",
    },

    -- 终端内的各种行为
    hide_numbers = true, -- 隐藏终端里的行号
    start_in_insert = true, -- 打开终端时自动进入插入模式
    insert_mappings = true, -- 允许在插入模式下使用 open_mapping 快捷键开关
    terminal_mappings = true, -- 允许在终端模式下使用 open_mapping 快捷键开关
    close_on_exit = true, -- 运行结束的进程自动关闭终端窗口
})
