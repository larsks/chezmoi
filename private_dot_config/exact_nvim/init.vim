" the kitty terminal does not support background color erase properly
" let &t_ut=''

filetype on
filetype plugin on
filetype indent on

" Make
map MM :make<cr>
map MK :make clean<cr>
map ]l :lnext<cr>
map [l :lprev<cr>

nnoremap <Down> gj
nnoremap <Up> gk
vnoremap <Down> gj
vnoremap <Up> gk

function MarkdownForBrowser()
	setlocal ft=markdown tw=0
endfunction

au BufRead *.toot,/tmp/tut* setlocal ft=text tw=0 wrap linebreak
au BufRead *.ksy setlocal ft=yaml
au BufRead *.md setlocal ft=markdown
au BufRead *.ldg setlocal ft=ledger
au BufRead /tmp/firenvim_* call MarkdownForBrowser()
au BufRead .stgit*.patch,*/COMMIT_EDITMSG setlocal ft=markdown tw=75
au! BufRead,BufNewFile *.bu setlocal ft=yaml
au! BufRead,BufNewFile *.pp setfiletype puppet
au! BufRead,BufNewFile Puppetfile setfiletype ruby
au! BufRead,BufNewFile *.s setlocal ft=asm_ca65
au FileType go autocmd BufWritePre <buffer> GoFmt
au FileType python autocmd BufWritePre <buffer> if get(b:, 'black_enabled', 1) | call black#Black() | endif

" Stop shellcheck from whining about *.env files
au! BufRead,BufNewFile *.env lua vim.diagnostic.disable(0)

function ClangFormatBuffer()
  if &modified && get(b:, 'clang_format_enabled', 1) == 1 && !empty(findfile('.clang-format', expand('%:p:h') . ';'))
    let cursor_pos = getpos('.')
    :%!clang-format
    call setpos('.', cursor_pos)
  else
    echom "clang-format is disabled"
  endif
endfunction

function! ClangFormatToggle()
    if get(b:, 'clang_format_enabled', 1) == 1
        let b:clang_format_enabled = 0
        echom "clang-format disabled"
    else
        let b:clang_format_enabled = 1
        echom "clang-format enabled"
    endif
endfunction

command! ClangFormatDisable :let b:clang_format_enabled=0
command! ClangFormatEnable :let b:clang_format_enabled=1
command! ClangFormatToggle :call ClangFormatToggle()
command! CT :call ClangFormatToggle()

let b:clang_format_enabled = 1

autocmd BufWritePre *.h,*.hpp,*.c,*.cpp,*.ino :call ClangFormatBuffer()

function! BlackToggle()
    if get(b:, 'black_enabled', 1) == 1
        let b:black_enabled = 0
        echom "Black disabled"
    else
        let b:black_enabled = 1
        echom "Black enabled"
    endif
endfunction

command! BlackDisable :let b:black_enabled=0
command! BlackEnable :let b:black_enabled=1
command! BlackToggle :call BlackToggle()
command! BT :call BlackToggle()

let b:black_enabled=0

runtime! abbrevations.vim

silent! helptags ALL

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

colorscheme base16-helios

" Kitty terminal doesn't seem to like undercurl
" hi SpellBad term=underline cterm=underline

if &term =~ '^tmux' || &term =~ '^screen' || &term =~ '^xterm'
  let &t_BE="\<Esc>[?2004h"
  let &t_BD="\<Esc>[?2004l"
  let &t_PS="\<Esc>[200~"
  let &t_PE="\<Esc>[201~"
endif

lua require('init')

if exists('g:started_by_firenvim')
    function! AdjustMinimumLines(timer)
            if &lines < 10
                set lines=10
            endif
    endfunction

    function! OnUIEnter(event) abort
        if 'Firenvim' ==# get(get(nvim_get_chan_info(a:event.chan), 'client', {}), 'name', '')
            set laststatus=0
            set guifont=monospace:h10

            call timer_start(500, function("AdjustMinimumLines"))
        endif
    endfunction

    autocmd UIEnter * call OnUIEnter(deepcopy(v:event))
endif
