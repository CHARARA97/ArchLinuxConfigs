vim.keymap.set('n', '<F5>', function()
    -- 1. 获取当前文件名（不带扩展名）
    local filename = vim.fn.expand('%:t:r')
    -- 2. 获取当前文件所在目录，作为工作空间
    local workspace = vim.fn.expand('%:p:h')
    -- 3. 定义输出路径（在当前文件所在目录的 bin 文件夹下，不带 .exe 后缀）
    local output_path = workspace .. '/bin/' .. filename

    -- 4. 创建 bin 目录（如果不存在）
    vim.fn.mkdir(workspace .. '/bin', 'p')

    -- 5. 执行编译命令
    -- 注意：在 Linux 下去掉了 .exe 后缀
    local compile_command = 'g++ -g "' .. vim.fn.expand('%') .. '" -o "' .. output_path .. '"'
    print('正在编译: ' .. compile_command)
    
    -- 使用 vim.fn.system 执行编译并获取结果
    local compile_result = vim.fn.system(compile_command)
    
    -- 6. 检查编译是否成功 (返回值为0表示成功)
    if vim.v.shell_error == 0 then
        print('编译成功！正在运行程序...')
        -- 7. 在新分屏的终端中运行程序
        vim.cmd('split | terminal "' .. output_path .. '"')
        -- 进入终端模式，方便直接与程序交互
        vim.cmd('startinsert')
    else
        -- 8. 如果编译失败，显示错误信息
        print('编译失败！错误信息:')
        print(compile_result)
        -- 可以打开 quickfix 列表查看详细错误（如果你配置了的话）
        -- vim.cmd('copen')
    end
end, { desc = 'Compile & Run Current C++ File' })
