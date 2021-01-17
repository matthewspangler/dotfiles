
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" YCM setup

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Function to build YCM if it hasn't been built yet
function! BuildYCM(info)
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  if a:info.status == 'installed' || a:info.force
    !./install.py --clang-completer
  endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim-plug plugins

call plug#begin()

" Session automation / management
Plug 'thaerkh/vim-workspace'

" Side pane file tree
Plug 'preservim/nerdtree'

" Emacs orgmode clone
Plug 'jceb/vim-orgmode'

" Speeddating (required by vim-orgmode)
Plug 'tpope/vim-speeddating'

" Status bar
Plug 'vim-airline/vim-airline'

" Browse functions and classes easily
Plug 'majutsushi/tagbar'

" Tag & fuzzy search tool
Plug 'kien/ctrlp.vim'

" TOO SLOW: Jedi autocomplete for python
" Plug 'davidhalter/jedi-vim'

" Faster autocomplete (Needs compiled, https://github.com/ycm-core/YouCompleteMe#linux-64-bit)
" Latest version, will work on debian bullseye:
" Plug 'valloric/youcompleteme', { 'do': function('BuildYCM') }
" Older version, for debian buster:
Plug 'Valloric/YouCompleteMe', { 'commit': 'd98f896', 'do': function('BuildYCM') }

" Gruvbox theme
" Plug 'morhetz/gruvbox'

" Python cold folding
Plug 'tmhedberg/simpylfold'

" Python static syntax and PEP8 style checker (using syntastic instead)
" Plug 'nvie/vim-flake8'

" Check syntax
Plug 'vim-syntastic/syntastic'

" Git integration
Plug 'tpope/vim-fugitive'

" PEP8 indentation
Plug 'Vimjas/vim-python-pep8-indent'

" VirtualEnv support
Plug 'jmcantrell/vim-virtualenv'

" Tags tool
Plug 'vim-scripts/taglist.vim'

" Snippets - OMG this is so useful!
Plug 'sirver/ultisnips'
Plug 'honza/vim-snippets'

" Python docs 
Plug 'fs111/pydoc.vim'

" Debugger
Plug 'joonty/vdebug'

" Vim colorscheme for use with pywal
Plug 'dylanaraps/wal.vim'

" Plugin for Ansible & Yaml
Plug 'pearofducks/ansible-vim'

" C# IDE
" Plug 'OmniSharp/omnisharp-vim'

call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERDTree

" NERDTree shortcut
map <C-n> :NERDTreeToggle<CR>

" Session detection
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") && v:this_session == "" | NERDTree | endif

" Automatically open NERDTree
" autocmd VimEnter * NERDTree

" Prevent other files opening on Nerdtree window
" autocmd BufEnter * if bufname('#') =~# "^NERD_tree_" && winnr('$') > 1 | b# | endif

" Prevent Nerdtree crashes
" let g:plug_window = 'noautocmd vertical topleft new'

" Auto change working directory with NERDTree
" let g:NERDTreeChDirMode = 2

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim-Workspace

" Prevent nerdtree & tagbar opening
set sessionoptions-=blank

" Workspace session directory and filename
" let g:workspace_session_directory = $HOME . '/.vim/sessions/'
" let g:workspace_session_name = 'Session.vim'

" Autosave
" let g:workspace_autosave_always = 1

" Don't create new tabs
" let g:workspace_create_new_tabs = 0  " enabled = 1 (default), disabled = 0

" Don't load session if starting vim with arguments
" let g:workspace_session_disable_on_args = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Omnisharp

" stdio
" let g:OmniSharp_server_stdio = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Airline
let g:airline_powerline_fonts = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Wal
silent! colorscheme wal

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pydoc

" Per pydoc documentation:
filetype plugin on

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" UltiSnips

" Trigger configuration
let g:UltiSnipsExpandTrigger="<c-g>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Taglist key - F3
nnoremap <F3> :TlistToggle<CR>

" Put taglist pane on right side
let Tlist_Use_Right_Window = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VirtualEnv

" VirtualEnv directory
let g:virtualenv_directory = '~/Programming/virtualenvs'

" Auto activate virtualenv
let g:virtualenv_auto_activate = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" YouCompleteMe

" Close completion window when it's done being used
let g:ycm_autoclose_preview_window_after_completion=1
" shortcut for goto definition
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-python-pep8-indent

" Indent multiline strings 
let g:python_pep8_indent_multiline_string = -1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Python Flake8

" PEP8 errors at bottom of screen
" autocmd BufWritePost *.py call Flake8()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tagbar

" Enable tagbar with F8
nmap <F8> :TagbarToggle<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Gruvbox
" :colorscheme gruvbox

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General vim stuffs

let python_highlight_all=1
syntax on

" Python formatting
set textwidth=79  " lines longer than 79 columns will be broken
set shiftwidth=4  " operation >> indents 4 columns; << unindents 4 columns
set tabstop=4     " a hard TAB displays as 4 columns
set expandtab     " insert spaces when hitting TABs
set softtabstop=4 " insert/delete 4 spaces when hitting a TAB/BACKSPACE
set shiftround    " round indent to multiple of 'shiftwidth'
set autoindent    " align the new line indent with the previous line

" Kill vi compatibility
set nocompatible

" Focus via mouse click
set mouse=a

" Disables swap files:
" set noswapfile

" Set leader key to spacebar
let mapleader      = ' '

" UTF-8 (Good for python 3)
set encoding=utf-8

" Allow access to system clipboard
set clipboard=unnamedplus
"set clipboard=unnamed

" Color column (for PEP8) for python
autocmd FileType python set colorcolumn=80

" Line numbers - turn on
set nu

" Changes working directory to opened file
set autochdir

