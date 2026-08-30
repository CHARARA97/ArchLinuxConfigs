require('toggleterm').setup({
    size = 20,                      -- 终端窗口大小（水平分割时是行数）
    open_mapping = [[<C-\\>]],      -- 手动开/关终端的快捷键（\ 是反斜杠）
    hide_numbers = true,            -- 隐藏终端窗口的行号
    shade_filetypes = {},           -- 不禁用任何文件类型的着色
    shade_terminals = true,         -- 当前非聚焦终端变暗
    shading_factor = 2,             -- 变暗程度
    start_in_insert = true,         -- 打开终端后自动进入插入模式
    persist_size = true,            -- 记住窗口大小
    direction = "float",            -- 水平分割（也可用 "vertical" 或 "float"）
})

