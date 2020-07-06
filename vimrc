if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

autocmd vimenter * NERDTree

" Function to build YCM if it hasn't been built yet
function! BuildYCM(info)
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  if a:info.status == 'installed' || a:info.force
    !./install.py --clang-completer --cs-completer
  endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim-plug plugins

call plug#begin()

" Side pane file tree
Plug 'preservim/nerdtree'

" Emacs orgmode clone
Plug 'jceb/vim-orgmode'

" Status bar
Plug 'vim-airline/vim-airline'

" Browse functions and classes easily
Plug 'majutsushi/tagbar'

" Tag & fuzzy search tool
Plug 'kien/ctrlp.vim'

" TOO SLOW: Jedi autocomplete for python
" Plug 'davidhalter/jedi-vim'

" Faster autocomplete (Needs compiled, https://github.com/ycm-core/YouCompleteMe#linux-64-bit)
Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }

" Python cold folding
Plug 'tmhedberg/simpylfold'

" Python static syntax and PEP8 style checker
Plug 'nvie/vim-flake8'

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
Plug 'OmniSharp/omnisharp-vim'

call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Omnisharp

" stdio
let g:OmniSharp_server_stdio = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Airline
" let g:airline_powerline_fonts = 1

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
" Tagbar

" Enable tagbar with F8
nmap <F8> :TagbarToggle<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General vim stuffs

let python_highlight_all=1
syntax on

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
set clipboard=unnamed

" Color column (for PEP8) for python
autocmd FileType python set colorcolumn=80

" Line numbers - turn on
set nu

