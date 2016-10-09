set nocompatible              " required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
" Add all your plugins here (note older versions of Vundle used Bundle instead of luginlloric/YouCompleteMe')
" Git interface
Plugin 'tpope/vim-fugitive'
" File system
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'kien/ctrlp.vim'
" Syntax checker
Plugin 'vim-scripts/indentpython.vim'
Plugin 'scrooloose/syntastic'
Plugin 'bitc/vim-bad-whitespace'
Plugin 'nathanaelkane/vim-indent-guides'
" Code folding
Plugin 'tmhedberg/SimpylFold'
" Auto-complete stuff
Bundle 'Valloric/YouCompleteMe'
" Color themes
Plugin 'jnurmine/Zenburn'
Plugin 'altercation/vim-colors-solarized'
" Status bar
Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
" Code indexing
Plugin 'majutsushi/tagbar'
" Golang supporting
Plugin 'fatih/vim-go'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Set window spliting
set splitbelow
set splitright

" Split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" I can type :help on my own, thanks.  Protect your fat fingers from the evils of <F1>
noremap <F1> <Esc>
nnoremap <F2> :set nonumber! number?<CR>
nnoremap <F3> :set wrap! wrap?<CR>
nmap <silent> <F4> :TagbarToggle<CR> " I use YouCompleteMe instead of other taggers
call togglebg#map("<F5>") " Theme's default map
nnoremap <F6> :exec exists('syntax_on') ? 'syn off' : 'syn on'<CR>
set pastetoggle=<F7>             "when in insert mode, press <F7> to go to
                                "paste mode, where you can paste mass data
                                "that won't be autoindented
au InsertLeave * set nopaste

" Enable folding
set foldmethod=indent
set foldlevel=99

" For SimplyFold
let g:SimpylFold_docstring_preview=1

" Highlight abundant spaces
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/
set encoding=utf-8

" For YCM
let g:ycm_autoclose_preview_window_after_completion=1
let g:ycm_error_symbol = '>>'
let g:ycm_warning_symbol = '>*'
nnoremap <leader>gl :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>gf :YcmCompleter GoToDefinition<CR>
nnoremap <leader>gg :YcmCompleter GoToDefinitionElseDeclaration<CR>
nmap <F8> :YcmDiags<CR>

" Python with virtualenv support
python << EOF
import sys, vim, os

ve_dir = vim.eval('$VIRTUAL_ENV')
if not ve_dir == "":
    print("You are working in virtual environment now. The current direction is {}".format(ve_dir))
    ve_dir in sys.path or sys.path.insert(0, ve_dir)
    activate_this = os.path.join(os.path.join(ve_dir, 'bin'), 'activate_this.py')

    # Fix for windows
    if not os.path.exists(activate_this):
        activate_this = os.path.join(os.path.join(ve_dir, 'Scripts'), 'activate_this.py')

    execfile(activate_this, dict(__file__=activate_this))
EOF

" Set VIM theme
if has('gui_running')
  set background=dark
  colorscheme solarized
else
  colors zenburn
endif

" For NERDTree-tabs
let NERDTreeIgnore=['\.pyc$', '\~$', '\.swp$'] "ignore files in NERDTree
let g:nerdtree_tabs_open_on_console_startup=1
" Automatically open a NERDTree if no files where specified
autocmd vimenter * if !argc() | NERDTree | endif
" Close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
" Open a NERDTree
map <Leader>n <plug>NERDTreeTabsToggle<CR>

" Highlight current line
au WinLeave * set nocursorline nocursorcolumn
au WinEnter * set cursorline cursorcolumn
set cursorline cursorcolumn

" Display line number, with the 80th column highlighted once VIM started.
set nu
set cc=80

" A function for highlight a column manually
map ,ch :call SetColorColumn()<CR>
function! SetColorColumn()
  let col_num = virtcol(".")
  let cc_list = split(&cc, ',')
  if count(cc_list, string(col_num)) <= 0
    execute "set cc+=".col_num
  else
    execute "set cc-=".col_num
  endif
endfunction

" Set indent guide line width
let g:indent_guides_guide_size=1

" For ctrlp
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.png,*.jpg,*.jpeg,*.gif " MacOSX/Linux
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor
  " Use ag in CtrlP for listing files.
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  " Ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" For powerline
set laststatus=2 " Always display the status line
set statusline+=%{fugitive#statusline()} "  Git Hotness
let g:Powerline_symbols='unicode'

" For Tagbar
let g:tagbar_width=35
let g:tagbar_autofocus=1

" For syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_error_symbol='✘✘'
let g:syntastic_warning_symbol='➤➤'
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 1
let g:syntastic_python_checkers=['pyflakes']
" let g:syntastic_python_checkers=['pep8', 'pyflakes']
let g:syntastic_python_pep8_args='--ignore=E501,E225,W293,W291,E265,E303'

"------------Start Python PEP 8 stuff----------------
"" Number of spaces that a pre-existing tab is equal to.
au BufRead,BufNewFile *py,*pyw,*.c,*.h set tabstop=4

"spaces for indents
au BufRead,BufNewFile *.py,*pyw set shiftwidth=4
au BufRead,BufNewFile *.py,*.pyw set expandtab
au BufRead,BufNewFile *.py set softtabstop=4

" Use the below highlight group when displaying bad whitespace is desired.
highlight BadWhitespace ctermbg=red guibg=red

" Display tabs at the beginning of a line in Python mode as bad.
au BufRead,BufNewFile *.py,*.pyw match BadWhitespace /^\t\+/
" Make trailing whitespace be flagged as bad.
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" Wrap text after a certain number of characters
au BufRead,BufNewFile *.py,*.pyw, set textwidth=100

" Use UNIX (\n) line endings.
au BufNewFile *.py,*.pyw,*.c,*.h set fileformat=unix

" Set the default file encoding to UTF-8:
set encoding=utf-8

" For full syntax highlighting:
let python_highlight_all=1
syntax on

" Keep indentation level from previous line:
autocmd FileType python set autoindent

" make backspaces more powerfull
set backspace=indent,eol,start

"Folding based on indentation:
autocmd FileType python set foldmethod=indent
"use space to open folds
nnoremap <space> za
"----------Stop python PEP 8 stuff--------------

" For other language stuff
au BufNewFile,BufRead *.js, *.html, *.css :
\ set tabstop=2
\ set softtabstop=2
\ set shiftwidth=2
