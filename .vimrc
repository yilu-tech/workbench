color dracula
syntax on
set guicursor=

set tabstop=4
set shiftwidth=4
set expandtab
set number
set relativenumber
set ruler
set cursorline
set encoding=utf-8
set fileencoding=utf-8
set nocompatible
set splitright
set splitbelow
set foldmethod=indent   
set foldnestmax=10
set nofoldenable
set foldlevel=2

let mapleader="\<Space>"
nnoremap <leader>` :split term://zsh<CR>a
nnoremap <slient> <A-k> :m .-2<CR>
nnoremap <slient> <A-j> :m .+1<CR>

call plug#begin()


call plug#end()
