require( 'im_select' ).setup(
        {
                default_im_select   = "keyboard-us",
                default_command     = "fcitx5-remote",
                set_default_events  = { "InsertLeave", "CmdlineLeave" },
                set_previous_events = { "InsertEnter" },
                async_switch_im     = true,
                keep_quiet_on_no_binary = false,
        }
)
