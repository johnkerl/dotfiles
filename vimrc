" John Kerl's vimrc, 2003-2013 and onward ...
" See vim online help for more information.

source $HOME/.vimrc-site

behave xterm

"set compatible
set nobackup
set nohlsearch
set noincsearch
set noshowmode
"set notagrelative
set tagrelative
set cpoptions=aABcdeFs
set exrc
set modeline
set modelines=5
set tw=100

set encoding=utf-8
"set encoding=latin1

set autoindent
set nocindent " Nice feature; doesn't match my preferences.

"I'll break lines when I want them broken:
set formatoptions=ql " This one is needed for vim without filename
" ?!?! >:[
" :autocmd FileType * set formatoptions=ql
" ?!?! >:[
" map \0 :se formatoptions=ql<C-m>
" ?!?! >:[
" http://stackoverflow.com/questions/6076592/vim-set-formatoptions-being-lost
autocmd BufNewFile,BufRead * setlocal formatoptions=ql

autocmd BufEnter reg_test/run :syntax sync fromstart

set vb t_vb= "Turn the beeping off

set noignorecase
set nonovice
set nowrapscan

" Flag trailing whitespace in red.
let c_space_errors=1
let ruby_space_errors=1
let java_space_errors=1
let groovy_space_errors=1
let scala_space_errors=1

set background=dark
"set background=light
"map ,z :set background=light<C-m>

set tagstack
set tags=./tags,../tags,../../tags,../../../tags,../../../../tags,../../../../../tags
" Include '-' (ASCII 45) and ':' (ASCII 58) as part of word for tag searches; '_'=95
"set iskeyword=@,45,48-57,58,95,192-255,#


" Enable language-specific syntax highlighting.
syntax on

"au BufNewFile,BufRead *.g,*.groovy set filetype=groovy

" ----------------------------------------------------------------
" Trying this 2008-02-12 ...
" Once I start vim and type 'set comments', it does *not* have this
" value, if the mode (C, .vimrc, etc.) has been detected.  If I type vim with
" no arguments, this comments=... does apply.  However, autoindent with gqip
" now breaks; //'s flow into the paragraph. :(
" set comments=f:-
"map \f :set comments=f:-<C-m>

" ================================================================
" Keymaps

"Leader for two-key sequences
map , \

map \, :tnext<C-m>

" 2010-08-08
"map # :w<C-m>:e#
map \x l
"""""map \w :w<C-m>:!latex %<C-m>

map \e :set hlsearch<CR>
map \E :set nohlsearch<CR>

map \i :set ic<C-m>
map \I :set noic<C-m>
map \a :set ai<C-m>
map \A :set noai<C-m>
map \t :set paste<C-m>
map \T :set nopaste<C-m>
map \D :set ft=diff<C-m>

map \n :se nu<C-m>
map \N :se nonu<C-m>
map \l :se list<C-m>
map \L :se nolist<C-m>

" This highlight git merge lines
map \m :se hlsearch<C-m>/^[<=\|>][<=\|>][<=\|>][<=\|>][<=\|>][<=\|>][<=\|>]<C-m>

map <C-h> :.!bash<CR>j
map \h !}echorun<CR>}}
"map \h yyp:.!sh<CR>
"map \H yyp!}head -n 1 \| sh<CR>k

"map \b i\begin{eqnarray*}<C-m><TAB>&=& \\<C-m><C-d>\end{eqnarray*}<C-m><ESC>
map <C-q> I* <ESC>j
map \b :.!ind -1b<C-m>j
map \B :.!uind -1b<C-m>

map e <C-e>

map ; :
"map v ~
" Show current line number:
map - :.=<C-m>
" Show last line number:
map _ :$=<C-m>
" Insert a space & keep the cursor position still:
map <C-k> i <ESC>

" Put current line at middle of screen
map <SPACE> zz

" ----------------------------------------------------------------
" https://vi.stackexchange.com/questions/15505/highlight-whole-todo-comment-line
syntax match myTodo /\v.<(TODO|FIXME|XXX|xxx).*/hs=s+1 containedin=.*Comment
highlight link myTodo Todo
highlight Search ctermbg=LightGrey
highlight Todo ctermbg=DarkGrey
"syn list Todo
"syn list myTodo

au BufNewFile,BufRead * syntax match myTodo /\v.<(TODO|FIXME|XXX|xxx).*/hs=s+1 containedin=.*Comment

" ----------------------------------------------------------------
" Tabs/whitespaces, and indent/unindent keymaps

"set noexpandtab
set expandtab

" TWO:
map <C-b> I  <ESC>
map <C-S-B> I  <ESC>j
map <C-u> 0xx
map <C-S-U> 0xxj
set ts=2

" THREE:
"map <C-b> I   <ESC>
"map <C-S-B> I   <ESC>j
"map <C-u> 0xxx
"map <C-S-U> 0xxxj
"set ts=3

" FOUR:
"#map <C-b> I    <ESC>
"#map <C-S-B> I    <ESC>j
"map <C-u> 0xxxx
"map <C-S-U> 0xxxxj
"set ts=4

" TAB:
"""""map <C-b> I<TAB><ESC>
"""""map <C-S-B> I<TAB><ESC>j
"""""map <C-u> 0x
"""""map <C-S-U> 0xj
"set ts=8

map \2 :se ts=2<C-m>
map \3 :se ts=3<C-m>
map \4 :se ts=4<C-m>
map \8 :se ts=8<C-m>
"map \0 :se ts=80<C-m>
map \0 :set colorcolumn=120<CR>
map \o :set colorcolumn=88<CR>
map \c :set colorcolumn=80<C-m>                                                
map \O :set colorcolumn=0<CR>
map \C :set colorcolumn=<C-m>                                                  

" ----------------------------------------------------------------
"au BufNewFile,BufRead *.java map <C-b> I    <ESC>
"au BufNewFile,BufRead *.java map <C-S-B> I    <ESC>j
"au BufNewFile,BufRead *.java map <C-u> 0xxxx
"au BufNewFile,BufRead *.java map <C-S-U> 0xxxxj

"au BufNewFile,BufRead *.g map <C-b> I    <ESC>
"au BufNewFile,BufRead *.g map <C-S-B> I    <ESC>j
"au BufNewFile,BufRead *.g map <C-u> 0xxxx
"au BufNewFile,BufRead *.g map <C-S-U> 0xxxxj

"au BufNewFile,BufRead *.groovy map <C-b> I    <ESC>
"au BufNewFile,BufRead *.groovy map <C-S-B> I    <ESC>j
"au BufNewFile,BufRead *.groovy map <C-u> 0xxxx
"au BufNewFile,BufRead *.groovy map <C-S-U> 0xxxxj

au BufNewFile,BufRead Makefile* set ts=8
au BufNewFile,BufRead Makefile* set noexpandtab
au BufNewFile,BufRead Makefile* map <C-b> I<TAB><ESC>
au BufNewFile,BufRead Makefile* map <C-S-B> I<TAB><ESC>j
au BufNewFile,BufRead Makefile* map <C-u> 0x
au BufNewFile,BufRead Makefile* map <C-S-U> 0xj

au BufNewFile,BufRead Makevars* set ts=8
au BufNewFile,BufRead Makevars* set noexpandtab
au BufNewFile,BufRead Makevars* map <C-b> I<TAB><ESC>
au BufNewFile,BufRead Makevars* map <C-S-B> I<TAB><ESC>j
au BufNewFile,BufRead Makevars* map <C-u> 0x
au BufNewFile,BufRead Makevars* map <C-S-U> 0xj

au BufNewFile,BufRead configure.ac set ts=8
au BufNewFile,BufRead configure.ac set noexpandtab
au BufNewFile,BufRead configure.ac map <C-b> I<TAB><ESC>
au BufNewFile,BufRead configure.ac map <C-S-B> I<TAB><ESC>j
au BufNewFile,BufRead configure.ac map <C-u> 0x
au BufNewFile,BufRead configure.ac map <C-S-U> 0xj

"au BufNewFile,BufRead *.[ch] set ts=4
"au BufNewFile,BufRead *.[ch] set noexpandtab
"au BufNewFile,BufRead *.[ch] map <C-b> I<TAB><ESC>
"au BufNewFile,BufRead *.[ch] map <C-S-B> I<TAB><ESC>j
"au BufNewFile,BufRead *.[ch] map <C-u> 0x
"au BufNewFile,BufRead *.[ch] map <C-S-U> 0xj

au BufNewFile,BufRead *.[ch] set ts=2
au BufNewFile,BufRead *.[ch] set expandtab
au BufNewFile,BufRead *.[ch] map <C-b> I  <ESC>
au BufNewFile,BufRead *.[ch] map <C-S-B> I  <ESC>j
au BufNewFile,BufRead *.[ch] map <C-u> 0xx
au BufNewFile,BufRead *.[ch] map <C-S-U> 0xxj

au BufNewFile,BufRead *.cc set ts=2
au BufNewFile,BufRead *.cc set expandtab
au BufNewFile,BufRead *.cc map <C-b> I  <ESC>
au BufNewFile,BufRead *.cc map <C-S-B> I  <ESC>j
au BufNewFile,BufRead *.cc map <C-u> 0xx
au BufNewFile,BufRead *.cc map <C-S-U> 0xxj

au BufNewFile,BufRead *.cpp set ts=2
au BufNewFile,BufRead *.cpp set expandtab
au BufNewFile,BufRead *.cpp map <C-b> I  <ESC>
au BufNewFile,BufRead *.cpp map <C-S-B> I  <ESC>j
au BufNewFile,BufRead *.cpp map <C-u> 0xx
au BufNewFile,BufRead *.cpp map <C-S-U> 0xxj

au BufNewFile,BufRead CMakeLists.txt set ts=2
au BufNewFile,BufRead CMakeLists.txt set expandtab
au BufNewFile,BufRead CMakeLists.txt map <C-b> I  <ESC>j
au BufNewFile,BufRead CMakeLists.txt map <C-u> 0xx
au BufNewFile,BufRead CMakeLists.txt map <C-S-U> 0xxj

au BufNewFile,BufRead *.[ly] set ts=4
au BufNewFile,BufRead *.[ly] set noexpandtab
au BufNewFile,BufRead *.[ly] map <C-b> I<TAB><ESC>
au BufNewFile,BufRead *.[ly] map <C-S-B> I<TAB><ESC>j
au BufNewFile,BufRead *.[ly] map <C-u> 0x
au BufNewFile,BufRead *.[ly] map <C-S-U> 0xj

au BufNewFile,BufRead *.[d] set ts=4
au BufNewFile,BufRead *.[d] set noexpandtab
au BufNewFile,BufRead *.[d] map <C-b> I<TAB><ESC>
au BufNewFile,BufRead *.[d] map <C-S-B> I<TAB><ESC>j
au BufNewFile,BufRead *.[d] map <C-u> 0x
au BufNewFile,BufRead *.[d] map <C-S-U> 0xj

au BufNewFile,BufRead *.go set ts=4
au BufNewFile,BufRead *.go set noexpandtab
au BufNewFile,BufRead *.go map <C-b> I<TAB><ESC>
au BufNewFile,BufRead *.go map <C-S-B> I<TAB><ESC>j
au BufNewFile,BufRead *.go map <C-u> 0x
au BufNewFile,BufRead *.go map <C-S-U> 0xj

"au BufNewFile,BufRead *.py set ts=4
"au BufNewFile,BufRead *.py set noexpandtab
"au BufNewFile,BufRead *.py map <C-b> I<TAB><ESC>
"au BufNewFile,BufRead *.py map <C-S-B> I<TAB><ESC>j
"au BufNewFile,BufRead *.py map <C-u> 0x
"au BufNewFile,BufRead *.py map <C-S-U> 0xj

"au BufNewFile,BufRead py* set ts=4
"au BufNewFile,BufRead py* set noexpandtab
"au BufNewFile,BufRead py* map <C-b> I<TAB><ESC>
"au BufNewFile,BufRead py* map <C-S-B> I<TAB><ESC>j
"au BufNewFile,BufRead py* map <C-u> 0x
"au BufNewFile,BufRead py* map <C-S-U> 0xj

"au BufNewFile,BufRead pgr set ts=4
"au BufNewFile,BufRead pgr set noexpandtab
"au BufNewFile,BufRead pgr map <C-b> I<TAB><ESC>
"au BufNewFile,BufRead pgr map <C-S-B> I<TAB><ESC>j
"au BufNewFile,BufRead pgr map <C-u> 0x
"au BufNewFile,BufRead pgr map <C-S-U> 0xj

au BufNewFile,BufRead *.py set ts=4
au BufNewFile,BufRead *.py set expandtab
au BufNewFile,BufRead *.py map <C-b> I    <ESC>
au BufNewFile,BufRead *.py map <C-S-B> I    <ESC>j
au BufNewFile,BufRead *.py map <C-u> 0xxxx
au BufNewFile,BufRead *.py map <C-S-U> 0xxxxj

au BufNewFile,BufRead py* set ts=4
au BufNewFile,BufRead py* set expandtab
au BufNewFile,BufRead py* map <C-b> I    <ESC>
au BufNewFile,BufRead py* map <C-S-B> I    <ESC>j
au BufNewFile,BufRead py* map <C-u> 0xxxx
au BufNewFile,BufRead py* map <C-S-U> 0xxxxj

au BufNewFile,BufRead pgr set ts=4
au BufNewFile,BufRead pgr set expandtab
au BufNewFile,BufRead pgr map <C-b> I    <ESC>
au BufNewFile,BufRead pgr map <C-S-B> I    <ESC>j
au BufNewFile,BufRead pgr map <C-u> 0xxxx
au BufNewFile,BufRead pgr map <C-S-U> 0xxxxj

:autocmd FileType python set ts=4
:autocmd FileType python set expandtab
:autocmd FileType python map <C-b> I    <ESC>
:autocmd FileType python map <C-S-B> I    <ESC>j
:autocmd FileType python map <C-u> 0xxxx
:autocmd FileType python map <C-S-U> 0xxxxj

au BufNewFile,BufRead *.[rR] set ts=2
au BufNewFile,BufRead *.[rR] set expandtab
au BufNewFile,BufRead *.[rR] map <C-b> I  <ESC>
au BufNewFile,BufRead *.[rR] map <C-S-B> I  <ESC>j
au BufNewFile,BufRead *.[rR] map <C-u> 0xx
au BufNewFile,BufRead *.[rR] map <C-S-U> 0xxj

au BufNewFile,BufRead *.md set ts=2
au BufNewFile,BufRead *.md set expandtab
au BufNewFile,BufRead *.md map <C-b> I  <ESC>
au BufNewFile,BufRead *.md map <C-S-B> I  <ESC>j
au BufNewFile,BufRead *.md map <C-u> 0xx
au BufNewFile,BufRead *.md map <C-S-U> 0xxj

function Yestabs()
  set ts=4
  set noexpandtab
  map <C-b> I<TAB><ESC>
  map <C-S-B> I<TAB><ESC>j
  map <C-u> 0x
  map <C-S-U> 0xj
endfunction

function Notabs()
  set ts=4
  set expandtab
  map <C-b> I    <ESC>
  map <C-S-B> I    <ESC>j
  map <C-u> 0xxxx
  map <C-S-U> 0xxxxj
endfunction

map ,Z :call Yestabs()<CR>
map ,z :call Notabs()<CR>

" ----------------------------------------------------------------

"map <C-r> :rewind
" Next file
map <C-n> :n<C-m>
" Reflow the current paragraph
map <C-p> gqip}}{j
" Reflow the current line and the one below.  Nice with auto-repeat.
map <C-x> gqj
" Replace current character with space and move right.  Nice with auto-repeat.
map <C-d> r l
" Move to next file, with save.
map <C-o> :w<C-m>:n<C-m>

" ================================================================
" Language-specific separators.  Uppercase is equal signs; lowercase is dashes.
" ,S and ,s for shell:
" # ================================================================
" # ----------------------------------------------------------------
"
" ,P and ,p for C++-style comments:
" // ================================================================
" // ----------------------------------------------------------------
"
" ,J and ,j for just the separator:
" ================================================================
" ----------------------------------------------------------------
"
" etc.

" /* comment */
"map \c O/* <ESC>64A-<ESC>A*/<ESC>
"map \C O/* <ESC>64A=<ESC>A*/<ESC>
" (* comment *)
"map \c 0i(*<ESC>A*)<ESC>
"map \m O(* <ESC>64A-<ESC>A*)<ESC>
"map \M O(* <ESC>64A=<ESC>A*)<ESC>
" // comment
map \p O// <ESC>64A-<ESC>
map \P O// <ESC>64A=<ESC>
" - - - instead of -----
map \q O// <ESC>32A -<ESC>
map \Q O// <ESC>32A =<ESC>
map \= O// <ESC>32A -<ESC>
" # comment
map \s O# <ESC>64A-<ESC>
map \S O# <ESC>64A=<ESC>
" % comment
" map \t O%% <ESC>64A-<ESC>
" map \T O%% <ESC>64A=<ESC>
" Just the line, no comment character
map \j O<ESC>64A-<ESC>
map \J O<ESC>64A=<ESC>
" Centered stars:
"                               * * *
map \r O* * *<ESC>32I <ESC>
" HTML monospace smiley:
map \v :se ft=java<C-m>

" fleurons:
map \f O𐡷𐡷 ❦ 𐡸 𐫱 𐡷 ❦ 𐡸 𐫱 𐡷 ❦ 𐡸 𐫱 𐡷 ❦ 𐡸 𐫱 𐡷 ❦ 𐡸 𐫱 𐡷 ❦ 𐡸 𐫱 𐡷 ❦ 𐡸 𐫱 𐡷 ❦ 𐡸𐡸<ESC>

" Set mark, format, return to mark. Without the mark, the cursor would be at
" the top of the file after the %!...
map \g mz:%!gofmt<CR>'z

"au BufNewFile,BufRead *.go set filetype=go

map \y :.!xget<CR>

map \t :w<C-m>:!clear;go run %<C-m>

"---------------------------------------------------------------
" 2011-04-22
"
" Results of attempts to get bash (not sh but bash) syntax
" highlighting for files not ending in .bash and not having
" a #!/bin/bash line.
"
" 1. set modeline; set modelines=5.  Use a per-file modeline.
"    * On the modeline in the file, put vim: set filetype=bash. Does nothing
"      good.
"    * On the modeline in the file, put vim: set filetype=sh. Gets sh syntax
"      but flags bashisms as if they were invalid.
"    * On the modeline in the file, put vim: call SetFileTypeSH("bash").
"      'Error detected while processing modelines: Unknown option: call'
"      Although once I'm in the file and type :call SetFileTypeSH("bash"), it
"      does what I want.
"
" 2. Use entries like the following here in my ~/.vimrc:
"    * au BufNewFile,BufRead baz set filetype=bash.
"      Same results as with modeline.
"    * au BufNewFile,BufRead baz set filetype=sh
"      Same results as with modeline.
"    * au BufNewFile,BufRead baz call SetFileTypeSH("bash")
"      'set verbose=9' and/or 'au baz BufRead' shows it being there.
"      Likewise 'au ... echo "WTF"' results in WTF being echoed.
"      Also if once in the file I type "do baz BufRead", I get what I want.
"      Maybe the function *is* being called but then clobbered?  set verbose=9
"      isn't showing it ...
"
" 3. Put a shebang line even in files that don't need them (e.g. my
"    ~/.aliases file) just to make vim use bash syntax.
"
" Solution:  For Vim 7.2 patchlevel 330, anyhow, filetype.vim has the following:
"
" " Generic configuration file (check this last, it's just guessing!)
" au BufNewFile,BufRead,StdinReadPost *
"       \ if !did_filetype() && expand("<amatch>") !~ g:ft_ignore_pat
"       \    && (getline(1) =~ '^#' || getline(2) =~ '^#' || getline(3) =~ '^#'
"       \       || getline(4) =~ '^#' || getline(5) =~ '^#') |
"       \   setf conf |
"       \ endif
"
" It sets filetype to conf.  So SetFileTypeSH *is* getting called, and then
" this stanza *afterward* sets filetype back to conf.  This is annoying.
" Now, I can replace filetype.vim at runtime.  But the following is easier:
"
" a. Here in .vimrc, add an autocommand to call SetFileTypeSH("bash").
" b. *AND*, in my modeline, for each target file:
"    # vim: set filetype.sh

"augroup my_bash_init_files
"  au BufNewFile,BufRead .aliases,.colorrc,.vars,.vars-personal,.vars-site :call SetFileTypeSH("bash")
"augroup END
