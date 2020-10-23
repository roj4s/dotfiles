" Set compatibility to Vim only.
set nocompatible

" Helps force plug-ins to load correctly when it is turned back on below.
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'jiangmiao/auto-pairs'
Plugin 'tmhedberg/SimpylFold'
Plugin 'Vimjas/vim-python-pep8-indent'
Plugin 'vim-syntastic/syntastic'
Plugin 'jnurmine/Zenburn'
Plugin 'altercation/vim-colors-solarized'
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'kien/ctrlp.vim'
Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
Bundle 'Valloric/YouCompleteMe'

" add all your plugins here (note older versions of Vundle
" used Bundle instead of Plugin)

" ...

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype indent on    " required

" Properly indent python multiline strings
let g:python_pep8_indent_multiline_string = -2

" Tabs bindings
map <C-t><up> :tabr<cr>
map <C-t><down> :tabl<cr>
map <C-t><left> :tabp<cr>
map <C-t><right> :tabn<cr>

" Turn on syntax highlighting.
syntax on

" Turn off modelines
set modelines=0

" Automatically wrap text that extends beyond the screen length.
set wrap

" Vim's auto indentation feature does not work properly with text copied from outisde of Vim. Press the <F2> key to toggle paste mode on/off.
nnoremap <F2> :set invpaste paste?<CR>
imap <F2> <C-O>:set invpaste paste?<CR>
set pastetoggle=<F2>

set formatoptions=tcqrn1
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set noshiftround
set autoindent
set textwidth=80

" Display 5 lines above/below the cursor when scrolling with a mouse.
set scrolloff=5

" Fixes common backspace problems
set backspace=indent,eol,start

" Speed up scrolling in Vim
set ttyfast

" Display options
set showmode
set showcmd

" Highlight matching pairs of brackets. Use the '%' character to jump between them.
set matchpairs+=<:>

" Display different types of white spaces.
set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:.

" Show line numbers
set number

" Set status line display
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ [BUFFER=%n]\ %{strftime('%c')}

" Encoding
set encoding=utf-8

" Highlight matching search patterns
set hlsearch

" ctrl+c to toggle highlight.
let hlstate=0
nnoremap <c-c> :if (hlstate%2 == 0) \| nohlsearch \| else \| set hlsearch \| endif \| let hlstate=hlstate+1<cr>

" Enable incremental search
set incsearch

" Include matching uppercase words with lowercase search term
set ignorecase

" Include only uppercase words with uppercase search term
set smartcase

" Store info from no more than 100 files at a time, 9999 lines of text, 100kb of data. Useful for copying large amounts of data between files.
set viminfo='100,<9999,s100

" Map the <Space> key to toggle a selected fold opened/closed.
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf

" Automatically save and load folds
autocmd BufWinLeave *.* mkview
autocmd BufWinEnter *.* silent loadview"

"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
noremap tt :tab split<CR>

set splitbelow
set splitright

" Enable folding
set foldmethod=syntax
set foldlevel=99

" Enable folding with the spacebar
nnoremap <space> za

" See the docstrings for folded code:
let g:SimpylFold_docstring_preview=1

au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set foldmethod=syntax |
    \ set fileformat=unix |
    \ syntax on

au BufNewFile,BufRead *.js,*.html,*.css
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2

let g:ycm_autoclose_preview_window_after_completion=1
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>
map <leader>r  :YcmCompleter GoToReferences<CR>

if has('gui_running')
  set background=dark
  colorscheme solarized
else
  colorscheme zenburn
endif

call togglebg#map("<F5>")

let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree

" Always show statusline
set laststatus=2

" Use 256 colours (Use this setting only if your terminal supports 256 colours)
set t_Co=256

let g:ycm_server_python_interpreter = '/usr/local/bin/python3.6'
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

"System clipboard

noremap <Leader>y ""*y
noremap <Leader>p ""*p
noremap <Leader>Y ""+y
noremap <Leader>P ""+p

function ReformatMultiLines()
  let brx = '^\s*"'
  let erx = '"\s*$'
  let fullrx = brx . '\(.\+\)' . erx
  let startLine = line(".")
  let endLine   = line(".")
  while getline(startLine) =~ fullrx
    let startLine -= 1
  endwhile
  if getline(endLine) =~ erx
    let endLine += 1
  endif
  while getline(endLine) =~ fullrx
    let endLine += 1
  endwhile
  if startLine != endLine
    exec endLine . ' s/' . brx . '//'
    exec startLine . ' s/' . erx . '//'
    exec startLine . ',' . endLine . ' s/' . fullrx . '/\1/'
    exec startLine . ',' . endLine . ' join'
  endif
  exec startLine
  let orig_tw = &tw
  if &tw == 0
    let &tw = &columns
    if &tw > 79
      let &tw = 79
    endif
  endif
  let &tw -= 3 " Adjust for missing quotes and space characters
  exec "normal A%-%\<Esc>gqq"
  let &tw = orig_tw
  let endLine = search("%-%$")
  exec endLine . ' s/%-%$//'
  if startLine == endLine
    return
  endif
  exec endLine
  exec 'normal I"'
  exec startLine
  exec 'normal A "'
  if endLine - startLine == 1
    return
  endif
  let startLine += 1
  while startLine != endLine
    exec startLine
    exec 'normal I"'
    exec 'normal A "'
    let startLine += 1
  endwhile
  return 1
endfunction

function! BreakMultlineString(quote)
let c = 100
while c == 100
    normal 100|
    let c = virtcol('.')
    if c == 100
        execute "normal ," . a:quote
    endif
endwhile
endfunction

function! JoinMultilineString()
    let c = "'"
    while c == "'" || c == '"'
        normal gj^
        let c = matchstr(getline('.'), '\%' . col('.') . 'c.')
        normal k
        if c == "'" || c == '"'
            normal ,j
        endif
    endwhile
endfunction

" break lines
nnoremap <Leader>" 100\|Bi"<CR>"<Esc>
nnoremap <Leader><Leader>" :call BreakMultlineString('"')<CR>
nnoremap <Leader>' 100\|Bi'<CR>'<Esc>
nnoremap <Leader><Leader>' :call BreakMultlineString("'")<CR>

" join lines
nmap <Leader>j Jds'ds"x
nnoremap <Leader>J :call JoinMultilineString()<CR>

" xml folding
let g:xml_syntax_folding=1
au FileType xml setlocal foldmethod=syntax

filetype plugin on

let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git'

nmap <F6> :NERDTreeToggle<CR>

let g:syntastic_java_checkers = []
