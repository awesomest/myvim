"------------------
" basic
"------------------

" indent
set expandtab    " change tabs to spaces
set tabstop=2    " 画面上でタブ文字が占める幅
set shiftwidth=2 " 自動インデントでずれる幅
set autoindent   " 改行時に前の行のインデントを継続する
set smartindent  " 改行時に入力された行の末尾に合わせて次の行のインデントを決定する

" display the number of line
set number
" show the line and column number
set ruler
" display the title
set title
" syntax highlight
syntax on
" cursorline highlight
set cursorline

" encoding
set encoding=utf-8
" auto encoding in opening
set fileencodings=ucs-boms,utf-8,euc-jp,cp932

" display bracket when another side bracket has typed
set showmatch
" extend brackets jump
source $VIMRUNTIME/macros/matchit.vim

" complement for command mode
set wildmenu
" the number of commands history
set history=5000

if &term =~ "xterm"
  let &t_SI .= "\e[?2004h"
  let &t_EI .= "\e[?2004l"
  let &pastetoggle = "\e[201~"

  function XTermPasteBegin(ret)
    set paste
    return a:ret
  endfunction

  inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
endif

" about search
set hlsearch " highlight
set nowrapscan
set incsearch " search immediately after typing
set ignorecase " ignore capital or lower letter
set smartcase " distinct if capital letter is used
set grepprg=grep\ -rnIH\ --exclude-dir=.svn\ --exclude-dir=.git
autocmd QuickfixCmdPost vimgrep copen
autocmd QuickfixCmdPost grep copen

" rectangle selection
set virtualedit=block

" display tabs and spapes at the last of line
set list
set listchars=tab:>~,trail:_

" allow to delete the beginning of line
set backspace=indent,eol,start

" delete end of line
"set binary noeol

" no back up
set backupcopy=yes

" format besides comments
autocmd FileType * setlocal formatoptions-=ro

" format of new line
set fileformats=unix,dos,mac

" key maping
nnoremap Q <Nop>
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>
nnoremap [ :cprevious<CR>
nnoremap ] :cnext<CR>
nnoremap { <C-w><
nnoremap } <C-w>>
nnoremap + <C-w>+
nnoremap - <C-w>-
nnoremap _ <C-w>_
nnoremap <SPACE>= <C-w>=
nnoremap <SPACE>0 <C-w>_
nnoremap <LEFT> <C-w>h
nnoremap <RIGHT> <C-w>l
" movable to right above and right below if multi-line
nnoremap j gj
nnoremap k gk
nnoremap <down> gj
nnoremap <up> gk

" background of completeopt
highlight Pmenu ctermbg=8
highlight PmenuSel ctermbg=Green
highlight PmenuSbar ctermbg=Green

" width of em characters
set ambiwidth=double

" display an em space as highlight
function! ZenkakuSpace()
  highlight ZenkakuSpace cterm=reverse ctermfg=DarkMagenta gui=reverse guifg=DarkMagenta
endfunction

if has('syntax')
    augroup ZenkakuSpace
    autocmd!
    autocmd ColorScheme * call ZenkakuSpace()
    autocmd VimEnter,WinEnter * match ZenkakuSpace /　/
    augroup END
    call ZenkakuSpace()
endif

" display statusline
set laststatus=2
" file number
set statusline=[%n]
" file name
set statusline+=%<%f
" check edition
set statusline+=%m
" right justification
set statusline+=%=
" line, column
set statusline+=%l,%c
" percentage
set statusline+=%11p%%
set showcmd

" auto Binary mode
augroup BinaryXXD
    autocmd!
    autocmd BufReadPre  *.bin let &binary =1
    autocmd BufReadPost * if &binary | silent %!xxd -g 1
    autocmd BufReadPost * set ft=xxd | endif
    autocmd BufWritePre * if &binary | %!xxd -r | endif
    autocmd BufWritePost * if &binary | silent %!xxd -g 1
    autocmd BufWritePost * set nomod | endif
augroup END

"------------------
" templates
"------------------
autocmd BufNewFile *.cpp 0r ~/.vim/templates/skel.cpp
autocmd BufNewFile *.html 0r ~/.vim/templates/skel.html

"------------------
" NeoBundle
"------------------
if has('vim_starting')
    " set NeoBundle path at the first time
    set runtimepath+=~/.vim/bundle/neobundle.vim/

    " git clone if NeoBundle has not installed
    if !isdirectory(expand("~/.vim/bundle/neobundle.vim/"))
        echo "install NeoBundle..."
        :call system("git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim")
    endif
endif

call neobundle#begin(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle self
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" My Bundles here:
" Refer to |:NeoBundle-examples|.
" Note: You don't set neobundle setting in .gvimrc!
NeoBundle 'bundle/typescript-vim'
NeoBundle 'vim-jp/vim-go-extra'
NeoBundle 'Yggdroot/indentLine'
NeoBundle 'bronson/vim-trailing-whitespace'
NeoBundle 'pmsorhaindo/syntastic-local-eslint.vim'

"----------------------------------------------------------
" neocomplete・neosnippet
"----------------------------------------------------------
if has('lua') " lua機能が有効になっている場合・・・・・・①
    " コードの自動補完
    NeoBundle 'Shougo/neocomplete.vim'
    " スニペットの補完機能
    NeoBundle "Shougo/neosnippet"
    " スニペット集
    NeoBundle 'Shougo/neosnippet-snippets'
endif

if neobundle#is_installed('neocomplete.vim')
    " Vim起動時にneocompleteを有効にする
    let g:neocomplete#enable_at_startup = 1
    " smartcase有効化. 大文字が入力されるまで大文字小文字の区別を無視する
    let g:neocomplete#enable_smart_case = 1
    " 3文字以上の単語に対して補完を有効にする
    let g:neocomplete#min_keyword_length = 3
    " 区切り文字まで補完する
    let g:neocomplete#enable_auto_delimiter = 1
    " 1文字目の入力から補完のポップアップを表示
    let g:neocomplete#auto_completion_start_length = 1
    " バックスペースで補完のポップアップを閉じる
    inoremap <expr><BS> neocomplete#smart_close_popup()."<C-h>"

    " エンターキーで補完候補の確定. スニペットの展開もエンターキーで確定・・・・・・②
    imap <expr><CR> neosnippet#expandable() ? "<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "<C-y>" : "<CR>"
    " タブキーで補完候補の選択. スニペット内のジャンプもタブキーでジャンプ・・・・・・③
    imap <expr><TAB> pumvisible() ? "<C-n>" : neosnippet#jumpable() ? "<Plug>(neosnippet_expand_or_jump)" : "<TAB>"
endif

"----------------------------------------------------------
" ag.vim
"----------------------------------------------------------
NeoBundle 'rking/ag.vim'

if executable('ag') " agが使える環境の場合
  let g:ctrlp_use_caching=0 " CtrlPのキャッシュを使わない
  let g:ctrlp_user_command='ag %s -i --hidden -g ""' " 「ag」の検索設定
endif

"----------------------------------------------------------
" Syntastic
"----------------------------------------------------------
NeoBundle 'scrooloose/syntastic'

let g:syntastic_enable_signs = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 2
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_save = 1
let g:syntastic_check_on_wq = 1
"let g:syntastic_mode_map = {'mode': 'passive'}
"augroup AutoSyntastic
"    autocmd!
"    autocmd InsertLeave,TextChanged * call s:syntastic()
"augroup END
"function! s:syntastic()
"    w
"    SyntasticCheck
"endfunction

"----------------------------------------------------------
" CtrlP
"----------------------------------------------------------
" 多機能セレクタ
NeoBundle 'ctrlpvim/ctrlp.vim'
"" CtrlPの拡張プラグイン. 関数検索
"NeoBundle 'tacahiroy/ctrlp-funky'
"" CtrlPの拡張プラグイン. コマンド履歴検索
"NeoBundle 'suy/vim-ctrlp-commandline'

let g:ctrlp_match_window = 'order:ttb,min:20,max:20,results:100' " マッチウインドウの設定. 「下部に表示, 大きさ20行で固定, 検索結果100件」
let g:ctrlp_show_hidden = 1 " .(ドット)から始まるファイルも検索対象にする
let g:ctrlp_types = ['fil'] "ファイル検索のみ使用
"let g:ctrlp_extensions = ['funky', 'commandline'] " CtrlPの拡張として「funky」と「commandline」を使用

"" CtrlPCommandLineの有効化
"command! CtrlPCommandLine call ctrlp#init(ctrlp#commandline#id())

"" CtrlPFunkyの有効化
"let g:ctrlp_funky_matchtype = 'path'


"----------------------------------------------------------
" status line
"----------------------------------------------------------
NeoBundle 'itchyny/lightline.vim'
let g:lightline = {
      \ 'colorscheme': 'jellybeans',
      \ }
let g:lightline.component = {
      \ 'lineinfo': '%3l[%L]:%-2v',
      \ }


call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck

"------------------
" other
"------------------

" for Golang
set path+=$GOPATH/src/**
let g:gofmt_command = 'goimports'
au BufWritePre *.go Fmt
au BufNewFile,BufRead *.go set sw=4 noexpandtab ts=4 completeopt=menu,preview
au FileType go compiler go
