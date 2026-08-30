require( 'lualine' ).setup(
        {
                options =
                {
                        theme = 'tokyonight',
                        component_separators = { left = '|', right = '|' },
                        section_separators = { left = '', right = '' },
                },
                sections =
                {
                        lualine_a = { 'mode' },
                        lualine_b = { 'branch', 'diff', 'diagnostics' },
                        lualine_c = { { 'filename', path=3 } },
                        lualine_x = { 'encoding', 'fileformat', 'filetype', 'ctime' },
                        lualine_y = { 'progress' },
                        lualine_z = { 'location' }
                },
        }
)
