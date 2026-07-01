" ============================================================
" CHARARA97 的 Vim 配置
" 从 nvim-test 迁移合并 (ArchLinuxConfigs/nvim-test/)
" 生成日期: 2026-06-13
" ============================================================

" -------------------- 基础显示 --------------------
set number                  " 显示绝对行号
set relativenumber          " 显示相对行号（方便跳转）
set cursorline              " 高亮当前行
set cursorcolumn            " 高亮当前列         (nvim-test)
set signcolumn=yes          " 始终显示标记栏     (nvim-test)
set colorcolumn=80,100      " 第 80/100 列提示线 (nvim-test)
syntax on                   " 语法高亮
set termguicolors           " 真彩色

" -------------------- 缩进 --------------------
set tabstop=8               " Tab 宽度 (nvim-test 风格)
set shiftwidth=8            " 自动缩进宽度
set expandtab               " Tab → 空格
set autoindent              " 继承上一行缩进
set shiftround              " 缩进对齐到 shiftwidth 倍数 (nvim-test)
filetype plugin indent on

" -------------------- 搜索 --------------------
set incsearch               " 增量搜索
set hlsearch                " 高亮所有结果
set ignorecase              " 忽略大小写
set smartcase               " 含大写自动区分

" -------------------- 外观 / 行为 --------------------
set nowrap                  " 禁用软换行 (nvim-test)
set scrolloff=8             " 光标上下保留 8 行 (nvim-test)
set splitright              " 垂直分窗在右侧 (nvim-test)
set splitbelow              " 水平分窗在下方 (nvim-test)
set clipboard=unnamedplus   " 系统剪贴板共享 (nvim-test)

" -------------------- 撤销 --------------------
set undofile
silent !mkdir -p ~/.vim/undo
set undodir=~/.vim/undo


" ============================================================
" 插件路径 (手动安装)
" ============================================================
set rtp+=~/.vim/plugged/tokyonight-vim
set rtp+=~/.vim/plugged/nerdtree


" ============================================================
" 键位映射 (Leader = 空格, 来自 nvim-test)
" ============================================================
let mapleader = ' '
let maplocalleader = ' '

" 保存 / 退出
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>

" 快速行首 / 行尾
nnoremap <leader>h 0
nnoremap <leader>l $

" 快速上下移动
nnoremap <leader>j 20j
nnoremap <leader>k 20k

" 取消搜索高亮
nnoremap <leader>nh :nohl<CR>

" 分屏
nnoremap <leader>sv :vsplit<CR>
nnoremap <leader>sh :split<CR>
nnoremap <leader>se <C-w>=
nnoremap <leader>sx :close<CR>

" 标签页
nnoremap <leader>gn :tabnew<CR>
nnoremap <leader>gq :tabclose<CR>
nnoremap <leader>gh gT
nnoremap <leader>gl gt

" 移动行 (Alt+j / Alt+k)
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" 窗口导航
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" 调整窗口大小
nnoremap <A-S-k> :resize +5<CR>
nnoremap <A-S-j> :resize -5<CR>
nnoremap <A-S-h> :vertical resize -5<CR>
nnoremap <A-S-l> :vertical resize +5<CR>


" ============================================================
" 颜色方案: tokyonight-night (对应 nvim-test)
" ============================================================
let g:tokyonight_style = 'night'
let g:tokyonight_enable_italic = 1
colorscheme tokyonight


" ============================================================
" 文件浏览
"   NERDTree  → 侧边栏文件树 (对应 nvim-test 的 Neo-tree)
"   netrw     → 目录可编辑列表 (对应 nvim-test 的 Oil)
" ============================================================

" --- NERDTree ---
nnoremap <leader>e :NERDTreeToggle<CR>
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | q | endif
let NERDTreeMinimalUI = 1
let NERDTreeShowHidden = 1
let NERDTreeIgnore = ['\.pyc$', '__pycache__', '\.o$', '\.class$']

" --- netrw (Oil 风格) ---
nnoremap - :Explore<CR>
let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_winsize = 25
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_preview = 1
let g:netrw_sort_sequence = '[\/]$,*'
let g:netrw_list_hide = '.*\.pyc$,__pycache__,$\.o$,$\.class$'


" ============================================================
" 函数: 括号内加空格 (从 nvim-test bracket_pad.lua 迁移)
function! PadBrackets()
    let cur = getpos('.')
    let cline = cur[1]
    let ccol = cur[2]
    let lines = getline(1, '$')
    " 向后扫描找最近的未闭合 (
    let open_line = 0
    let open_col = 0
    let depth = 0
    for line in range(cline, 1, -1)
        let txt = lines[line]
        let start = (line == cline) ? ccol : strlen(txt)
        let pos = start
        while pos >= 1
            let ch = txt[pos - 1]
            if ch == ')'
                let depth = depth + 1
            elseif ch == '('
                if depth == 0
                    let open_line = line
                    let open_col = pos
                    break
                endif
                let depth = depth - 1
            endif
            let pos = pos - 1
        endwhile
        if open_line > 0 | break | endif
    endfor
    if open_line == 0 | return | endif
    " 向前扫描匹配的 )
    let close_line = 0
    let close_col = 0
    let depth = 0
    for line in range(open_line, len(lines))
        let txt = lines[line]
        let start = (line == open_line) ? (open_col + 1) : 1
        " Vimscript 字符串索引从 0 开始
        let pos = start - 1
        while pos < strlen(txt)
            let ch = txt[pos]
            if ch == '('
                let depth = depth + 1
            elseif ch == ')'
                if depth == 0
                    let close_line = line
                    let close_col = pos + 1
                    break
                endif
                let depth = depth - 1
            endif
            let pos = pos + 1
        endwhile
        if close_line > 0 | break | endif
    endfor
    if close_line == 0 | return | endif
    " 确认光标在括号内
    if cline < open_line || cline > close_line | return | endif
    if cline == open_line && ccol <= open_col | return | endif
    if cline == close_line && ccol >= close_col | return | endif
    " 插入空格
    if open_line == close_line
        let l = getline(open_line)
        let l = l[:open_col-1] . ' ' . l[open_col:close_col-2] . ' ' . l[close_col-1:]
        call setline(open_line, l)
    else
        let ol = getline(open_line)
        let cl = getline(close_line)
        call setline(open_line,  ol[:open_col-1] . ' ' . ol[open_col:])
        call setline(close_line, cl[:close_col-2] . ' ' . cl[close_col-1:])
    endif
endfunction
nnoremap S :call PadBrackets()<CR>
vnoremap S :<C-u>call PadBrackets()<CR>

" 函数: 切换 Quickfix 窗口 (从 nvim-test 迁移)
" ============================================================
function! ToggleQF()
    for w in range(1, winnr('$'))
        let l:buf = winbufnr(w)
        if getbufvar(l:buf, '&filetype') ==# 'qf'
            execute w . 'close'
            return
        endif
    endfor
    copen
endfunction
nnoremap <leader>fq :call ToggleQF()<CR>
