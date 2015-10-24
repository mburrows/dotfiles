set nocompatible         " turn on all the bells and whistles
set nowrap               " turn off line wrapping, turn it back on with :Wrap
set backspace=indent,eol,start
set nobackup             " don't create backup files (everything I edit is in version control)
set noswapfile
set nowb
set ruler                " show line and column number
set showcmd              " show partial commands
set hidden               " allow modified buffers to be hidden
set history=1000         " remember more commands and search history
set undolevels=1000      " use many muchos levels of undo
set title                " change the terminal's title
set visualbell           " don't beep
set noerrorbells         " no honestly, don't beep
set wildmenu             " make tab completion for files/buffers act like bash
set wildmode=list:full   " show a list when pressing tab and complete
set wildignore=*.swp,*.bak,*.pyc,*.class,*.o
set spelllang=en_gb
set dictionary=~/.ispell_british,/usr/share/dict/words
set virtualedit=all      " allow movement through virtual whitespace
set autowrite            " auto write file contents when switching buffers
set showmode
set nocursorline
set viewdir=$HOME/.vim/views
set lazyredraw           " dont redraw whilst executing macros
set mousehide
set confirm

" Use pathogen for plugins
call pathogen#infect()

" Change the mapleader from \ to ,
let mapleader=","

" Turn on doxygen syntax highlighting (for C++ comments)
let g:load_doxygen_syntax=1

" Set completion (C-N/C-P) to scan current file, visible windows, hidden
" buffers and then tags
set complete=.,w,b,t
                                              
" Make searching sane
set ignorecase
set smartcase
set gdefault " turn on global searching by default
set incsearch
set showmatch
set nohlsearch

" Tabs are evil, always use spaces
set tabstop=8
set softtabstop=4
set shiftwidth=4
set expandtab
set shiftround " use multiple of shiftwidth when indenting with '<' and '>'

" Setup search path for gf and :find
set path+=~/cpp/**

" Use Q for formatting the current paragraph (or selection)
vnoremap Q gq
nnoremap Q gqap

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
    set mouse=a
    set relativenumber
endif

" Switch syntax highlighting on, when the terminal has colors
if &t_Co >= 8 || has("gui_running")
    syntax on
    set t_Co=256
    set background=dark
    let base16colorspace=256
    colorscheme base16-tomorrow
    " tabs, grey out inactive menus, menu bar, console dialogs, no scrollbars,
    " no toolbars
    set guioptions=egmc
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

    " Enable file type detection, plugins and indentation
    filetype on
    filetype plugin on
    filetype indent on

    " Put these in an autocmd group, so that we can delete them easily and
    " they don't get sourced twice when we reload our .vimrc
    augroup vimrcEx
        au!

        " For all text files set 'textwidth' to 80 characters.
        autocmd FileType text setlocal textwidth=80

        " When editing a file, always jump to the last known cursor position.
        autocmd BufReadPost *
                    \ if line("'\"") > 1 && line("'\"") <= line("$") |
                    \   exe "normal! g`\"" |
                    \ endif

        " Autoload .vimrc when I save it
        autocmd BufWritePost .vimrc source $MYVIMRC

        " Avoid polluting buffer list with fugitive buffers
        autocmd BufReadPost fugitive://* set bufhidden=delete

        " Use WAF for ECN builds
        autocmd BufRead,BufNewFile **/ecn/**/*.cpp setlocal makeprg=~/cpp/waf tags+=~/cpp/tags
        autocmd BufRead,BufNewFile **/ecn/**/*.h setlocal makeprg=~/cpp/waf tags+=~/cpp/tags
        autocmd BufRead,BufNewFile **/ecn/**/*.py setlocal tags+=~/python/tags
        
        " Prefer // for C++ comments
        autocmd FileType cpp setlocal commentstring=//\ %s

        " Treat .sqli files as SQL
        autocmd BufNewFile,BufRead *.sqli setfiletype sql
                            
        " Treat .md files as Markdown rather than Modula-2
        autocmd BufNewFile,BufReadPost *.md setfiletype markdown

        if has('statusline')
            set laststatus=2                         " always display the status line
            set statusline=%<%f\                     " filename
            set statusline+=%w%h%m%r                 " options
            set statusline+=%{fugitive#statusline()} " git hotness
            set statusline+=\ [%{&ff}/%Y]            " filetype
            set statusline+=\ [%{getcwd()}]          " current dir
            "set statusline+=\ [A=\%03.3b/H=\%02.2B] " ASCII / hexadecimal value of char
            set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " right aligned file nav info
        endif

    augroup END

else

    set autoindent		" always set autoindenting on

endif " has("autocmd")

" Remap esc key for fast switching and ipad keyboards
inoremap jj <Esc>

" Snippet related settings
let g:snips_author = 'Matt Burrows'
nnoremap <leader>sr :call ReloadAllSnippets()<CR>
nnoremap <leader>st :tabe ~/.vim/bundle/snipmate-snippets/snippets<CR>

" Quick compile
noremap <F1> :make debug -j48<CR>
noremap <leader>1 :make debug -j48<CR>

" Fast switching between .h and .cpp files
noremap <F2> :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>
noremap <leader>2 :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>
nnoremap <leader>h :vsp %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>

" Use to turn off autoindenting when pasting from the clipboard
set pastetoggle=<F5>

" Rapidly switch between quicklist entries
noremap <F8>  :cwin<CR>
noremap <F9>  :cprev<CR>
noremap <F10> :cnext<CR>
noremap <F11> :cpf<CR>
noremap <F12> :cnf<CR>

" Easy closing of quicklist/preview windows
nnoremap <leader>c :cclose<CR>:pclose<CR>

" Shortcut to search for current word under cursor using git grep
nnoremap ,8 :exe ":Ggrep " . expand("<cword>")<CR>

" Quickly edit the vimrc file
nnoremap <leader>v :tabedit $MYVIMRC<CR>

" Easy window navigation
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" Write out as sudo with w!!
cmap w!! w !sudo tee % >/dev/null

" Pull word under cursor into LHS of a substitute (for quick search and replace)
nnoremap <leader>5 :%s/\<<C-r>=expand("<cword>")<CR>\>/

" Cleanup trailing whitespace with ,w
nnoremap <leader>w :%s/\s\+$//e<CR>

" Shortcut to rapidly toggle `set list`
nnoremap <leader>l :set list!<CR>
set listchars=tab:>.,trail:.,extends:#,nbsp:.

" Make opening of files in the same directory easier, and use %% in command
" mode to expand the directory of the current file.
cnoremap %% <C-R>=expand('%:h').'/'<cr>

" cd to the directory containing the file in the buffer
noremap <leader>cd :lcd %:h

" Turn on all the options to wrap text properly
command! -nargs=* Wrap set wrap linebreak nolist

" Bubble single lines
nnoremap <C-Up> ddkP
nnoremap <C-Down> ddp

" Bubble multiple lines
vnoremap <C-Up> xkP`[V`]
vnoremap <C-Down> xp`[V`]

" Shortcuts for tabular alignment
noremap <leader>z= :Tabularize /=<CR>
noremap <leader>z: :Tabularize /:\zs<CR>
noremap <leader>z, :Tabularize /,\zs/l0r1<CR>

" Fast delete a buffer
noremap <leader>x :bd<CR>

" Browse old files
noremap <leader>o :browse oldfiles<CR>

" Select just pasted text
nnoremap gp `[v`]

" Git shortcuts
nnoremap <leader>gg :Ggrep 
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>ge :Gedit<CR>
nnoremap <leader>go :Git diff origin

" Toggle relative line numbers (useful for terminal copying)
nnoremap <leader>n :ToggleMouse<CR>

" Quick setting of textwidth for paragraph wrapping
map <leader>q :set textwidth=<C-R>=col(".")<CR><CR>

" Quicker clipboard copy and paste
nnoremap <leader>p "*p
nnoremap <leader>y "*y

" Toggle folds with the spacebar
nnoremap <Space> za
vnoremap <Space> za

" Fast opening of files in current directory
map <leader>e  :e %%
map <leader>es :sp %%
map <leader>ev :vsp %%
map <leader>et :tabe %%

" Filter previous/next ex commands with C-p and C-n
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$

"let g:ycm_global_ycm_extra_conf = 0
"nnoremap <F6> :YcmForceCompileAndDiagnostics<CR>
"nnoremap <leader>d :YcmCompleter GoTo<CR> 

" Only show H1 headers. The other option is 'stacked' which shows all headers.
let g:markdown_fold_style = 'nested'

" Perty fonts for airline status bar (will probably need a patched font file
" e.g. Droid Sans Mono for Powerline)
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme="base16"

map <leader>j :CtrlPMixed<CR>

"let g:EclimCompletionMethod='omnifunc'
"noremap <leader>s :JavaSearchContext<CR>

