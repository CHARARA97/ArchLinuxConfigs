require('lualine').setup({
        options = {
                theme = 'tokyonight', -- 替换为你使用的主题，如 'auto' 可自动匹配
                component_separators = { left = '|', right = '|' },
                section_separators = { left = '', right = '' },
        },
        sections = {
                lualine_a = {'mode'},
                lualine_b = {'branch', 'diff', 'diagnostics'},
                lualine_c = {'filename'},
                lualine_x = {'encoding', 'fileformat', 'filetype'},
                lualine_y = {'progress'},
                lualine_z = {'location'}
        },
})
