require('im_select').setup({
    -- 默认输入法（普通模式下的输入法）
    -- 对于 fcitx5，可以用 `fcitx5-remote -n` 查看你的英文输入法名称
    default_im_select = "keyboard-us",

    -- 用于切换输入法的命令
    default_command = "fcitx5-remote",

    -- 哪些事件触发切换到默认输入法
    set_default_events = { "InsertLeave", "CmdlineLeave" },

    -- 哪些事件触发恢复到上一次输入法
    set_previous_events = { "InsertEnter" },

    -- 异步切换（避免卡顿）
    async_switch_im = true,

    -- 如果找不到命令，不弹出烦人的通知
    keep_quiet_on_no_binary = false,
})
