" .obsidian.vimrc —— 放到 Obsidian vault 根目录
" 需安装社区插件 "Vimrc Support"

let mapleader = " "

nnoremap <leader>w  :w<CR>
nnoremap <leader>h  0
nnoremap <leader>l  $
nnoremap <leader>j  20j
nnoremap <leader>k  20k
nnoremap <leader>nh :nohl<CR>

nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" ---- 括号内加空格 S ------------------------------------------
function! PadBrackets()
    let cur  = getpos('.')
    let cline = cur[1]
    let ccol  = cur[2]
    let lines = getline(1, '$')
    let open_line = 0
    let open_col  = 0
    let depth = 0
    for line in range(cline, 1, -1)
        let txt = lines[line]
        let start = line == cline ? ccol : strlen(txt)
        let pos = start
        while pos >= 1
            let ch = txt[pos - 1]
            if ch == ')' | let depth = depth + 1
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
    let close_line = 0
    let close_col  = 0
    let depth = 0
    for line in range(open_line, len(lines))
        let txt = lines[line]
        let start = line == open_line ? open_col + 1 : 1
        let pos = start - 1
        while pos < strlen(txt)
            let ch = txt[pos]
            if ch == '(' | let depth = depth + 1
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
    if cline < open_line || cline > close_line | return | endif
    if cline == open_line && ccol <= open_col | return | endif
    if cline == close_line && ccol >= close_col | return | endif
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
