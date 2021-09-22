" Install plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Install vim plugins
call plug#begin()

" vimtex
Plug 'lervag/vimtex'
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0

" tex-conceal
Plug 'KeitaNakamura/tex-conceal.vim'
set conceallevel=2
let g:tex_conceal='abdmg'

" ultisnips
Plug 'SirVer/ultisnips'
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

call plug#end()

" Enable syntax higlighting
syntax on

" Speed up scrolling
set ttyfast

" Use the system clipboard for copy and paste
set clipboard=unnamedplus

" Show line numbers
set number

" Color scheme (AZUL 33, ROJO=196, NARANJA=208, VERDE=82, MAGENTA=201)
highlight Comment ctermfg=196
highlight Constant ctermfg=white
highlight Identifier ctermfg=201
highlight LineNr ctermfg=82
highlight PreProc ctermfg=33
highlight Special ctermfg=208
highlight Statement ctermfg=82
highlight Type ctermfg=231

" Show UTF-8 characters
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
set encoding=utf-8

" Mapping jf,fj, JF and FJ to Esc
inoremap fj <Esc>
inoremap jf <Esc>
inoremap FJ <Esc>
inoremap JF <Esc>

" Mapping Ctrl+F to inkscape-figures commands
inoremap <C-f> <Esc>: silent exec '.!inkscape-figures create "'.getline('.').'" "'.b:vimtex.root.'/figures/"'<CR><CR>:w<CR>
nnoremap <C-f> : silent exec '!inkscape-figures edit "'.b:vimtex.root.'/figures/" > /dev/null 2>&1 &'<CR><CR>:redraw!<CR>

" This makes vim turn paste mode on/off automatically when you paste
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

function! XTermPasteBegin()
    set pastetoggle=<Esc>[201~
    set paste
    return ""
endfunction

" To get all UTF-8 characters to appear correctly in vim, make sure
" you've uncommented the line 'en_US.UTF-8 UTF-8' in /etc/locale.gen
" and run 'locale gen' and 'localectl set-locale LANG=en_US.UTF-8'
