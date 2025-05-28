call plug#begin('~/.vim/plugged')

" Code Completion
Plug 'leafgarland/typescript-vim'
Plug 'leafOfTree/vim-svelte-plugin'
" latest tag on branch
Plug 'neoclide/coc.nvim' , { 'tag': '*', 'branch' : 'release' }

" Search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" File Viewer
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'

" Lex
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'preservim/tagbar'
" Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" If you don't have nodejs and yarn
" use pre build, add 'vim-plug' to the filetype list so vim-plug can update this plugin
" see: https://github.com/iamcco/markdown-preview.nvim/issues/50
" Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

" If you have nodejs and yarn
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
" Plug 'nolleh/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
Plug 'airblade/vim-gitgutter'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }

Plug 'vimwiki/vimwiki'

Plug 'NLKNguyen/pipe.vim' "required
"Plug 'NLKNguyen/pipe-mysql.vim'
Plug 'nolleh/pipe-mysql.vim'
Plug 'chrisbra/Colorizer'

Plug 'ap/vim-css-color'
Plug 'thinca/vim-quickrun'

call plug#end()
