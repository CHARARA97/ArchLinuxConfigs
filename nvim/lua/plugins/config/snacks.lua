---- snacks.nvim 配置 -------------------------------------------------------------------------------
---- 按需启用各模块，避免与现有插件冲突 ------------------------------------------------------------

local ok, snacks = pcall( require, 'snacks' )
if not ok then
        vim.notify( "snacks.nvim 未安装，运行 :Syu 下载", vim.log.levels.WARN )
        return
end

snacks.setup(
        {
                ---- 图片渲染（核心功能：在 Markdown 中内联显示图片） -------------------------------
                ---- 需要 Kitty / ghostty 等支持 graphics protocol 的终端 ----------------------------
                image = {
                        enabled = true,
                        doc = {
                                -- 在 Markdown、LaTeX、HTML 文件里自动渲染图片
                                enabled = true,
                                -- 可用的浮窗类型
                                float = false,
                            },
                },

                ---- 大文件优化 --------------------------------------------------------------------
                bigfile = {
                        enabled = true,
                },

                ---- 更快的文件加载 ---------------------------------------------------------------
                quickfile = {
                        enabled = true,
                },

                ---- 美观的通知系统（替换默认 vim.notify） -------------------------------------------
                notifier = {
                        enabled = true,
                        style = "compact",
                },

                ---- 输入增强 --------------------------------------------------------------------
                input = {
                        enabled = true,
                },

                ---- 缩进指示线 ------------------------------------------------------------------
                indent = {
                        enabled = true,
                        indent = { only_current = true },
                        chunk = { only_current = true },
                },
        }
)

---- 可选：图片粘贴增强，自动将粘贴的图片放入附件目录 ----------------------------------------------
vim.api.nvim_create_user_command( 'SnacksPaste', function()
        vim.cmd( 'Snacks image.paste' )
end, { desc = 'Paste image using snacks' } )
