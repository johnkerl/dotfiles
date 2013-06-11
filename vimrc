" John Kerl's vimrc, 2003-2013 and onward ...
" See vim online help for more information.

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

set encoding=utf-8
"set encoding=latin1

set autoindent
set nocindent " Nice feature; doesn't match my preferences.

set ts=4
"set ts=8

"Turn that beeping off!
set vb t_vb=

set noignorecase
set nonovice
set nowrapscan

" Flag trailing whitespace in red.
let c_space_errors=1
let ruby_space_errors=1
let scala_space_errors=1

set background=dark

set tagstack
set tags=./tags,../tags,../../tags,../../../tags,../../../../tags

set formatoptions=ql

" Enable language-specific syntax highlighting.
syntax on

" ----------------------------------------------------------------
" Trying this 2008-02-12 ...
" Once I start vim and type 'set comments', it does *not* have this
" value, if the mode (C, .vimrc, etc.) has been detected.  If I type vim with
" no arguments, this comments=... does apply.  However, autoindent with gqip
" now breaks; //'s flow into the paragraph. :(
" set comments=f:-
map \f :set comments=f:-

" Leader for two-key sequences:
map , \

map \, :tnext

" 2010-08-08
"map # :w:e#
map \x l
map \w :w:!latex %

map \i :set ic
map \I :set noic
map \a :set ai
map \A :set noai

map \n :se nu
map \N :se nonu
map \l :se list
map \L :se nolist

map \2 :se ts=2
map \3 :se ts=3
map \4 :se ts=4
map \8 :se ts=8

map \b i\begin{eqnarray*}	&=& \\\end{eqnarray*}

map e 

map ; :
"map v ~
" Show current line number:
map - :.=
" Show last line number:
map _ :$=
" Insert a space & keep the cursor position still:
map  i 
" Indent the current line by a tab:
map  I	
" Unindent the current line by its leading character (e.g. a tab):
map  0x

"map  :rewind
" Next file
map  :n
" Reflow the current paragraph
map  gqip}}{j
" Reflow the current line and the one below.  Nice with auto-repeat.
map  gqj
" Replace current character with space and move right.  Nice with auto-repeat.
map  r l
" Move to next file, with save.
map  :w:n

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

"map \a O; 64A-
"map \A O; 64A=
" C-style:
"map \c O/* 64A-A*/
"map \C O/* 64A=A*/
map \c 0i(*A*)
map \m O(* 64A-A*)
map \M O(* 64A=A*)
" C++-style
" Remove for clash with VimClojure ...
map \p O// 64A-
map \P O// 64A=
" - - - instead of -----:
map \q O// 32A -
map \Q O// 32A =
map \= O// 32A -
" Shell-style (Python, Ruby, ...)
" Remove for clash with VimClojure ...
map \s O# 64A-
map \S O# 64A=
" LaTeX-style
map \t O%% 64A-
map \T O%% 64A=
map \f Oi 64A-
map \F Oi 64A=
map \j O64A-
map \J O64A=
" Centered stars:
"                               * * *
map \r O* * *32I 
" HTML monospace smiley:
map \G A <tt>:)</tt>

map \g :%w:%!go run %

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
" b. *AND*, In my modeline, set filetype=sh.

augroup my_bash_init_files
  au BufNewFile,BufRead .envrc* .aliases .vars :call SetFileTypeSH("bash")
augroup END

"---------------------------------------------------------------
" 2012-12-22: Clojure

" http://blog.darevay.com/2010/10/how-i-tamed-vimclojure/

let vimclojure#FuzzyIndent = 1

let vimclojure#WantNailgun = 1

let classpath = join(
   \[".",
   \ "./src", "./src/main/clojure", "./src/main/resources",
   \ "./test", "./src/test/clojure", "./src/test/resources",
   \ "./classes", "./target/classes",
   \ "./lib/*", "lib/dev/*",
   \ "./bin",
   \ "/home/kerl/.vim/lib/*",
   \ "/usr/share/java/clojure-1.2.1.jar"
   \],
   \ ":")

" Settings for VimClojure
let vimclojureRoot = "/home/kerl/.vim/bundle/vimclojure-2.3.6"
let vimclojure#HighlightBuiltins=1
let vimclojure#HighlightContrib=1
let vimclojure#DynamicHighlighting=1
let vimclojure#ParenRainbow=1
let vimclojure#SplitSize=10
let vimclojure#WantNailgun = 1
"let vimclojure#NailgunClient = vimclojureRoot."/lib/nailgun/ng"
let vimclojure#NailgunClient = "/home/kerl/.vim/bundle/vimclojure-nailgun-client-2.2.0/vimclojure-nailgun-client/ng"

" Start vimclojure nailgun server (uses screen.vim to manage lifetime)

nmap <silent> <Leader>sc :execute "ScreenShell java -cp \"" . classpath . ":" . vimclojureRoot . "/lib/*" . "\" vimclojure.nailgun.NGServer 127.0.0.1" <cr>
" Start a generic Clojure repl (uses screen.vim)
nmap <silent> <Leader>sC :execute "ScreenShell java -cp \"" . classpath . "\" clojure.main" <cr>

"""au BufRead,BufNewFile *.clj nmap xyz <Plug>ClojureEvalToplevel

" David's stuff ...
" filetype off
let maplocalleader = ","
" syntax enable

" This jacks with non-Clojure code in a way that I don't like:
"filetype plugin indent on

let vimclojure#ParenRainbow = 1
let vimclojure#HighlightBuiltins = 1
let vimclojure#DynamicHighlighting = 1
" let vimclojure#FuzzyIndent = 1
" let vimclojure#WantNailgun = 1
" let vimclojure#NailgunClient = "/u/dgrnbrg/bin/ng"
let vimclojure#SplitPos = "right"
" let vimclojure#FuzzyIndentPatterns .= ",rowclosure"
" imap <silent> <C-e> <Plug>ClojureReplEvaluate.
"
" ,ef – Evaluate the entire File
" ,et – Evaluate the Toplevel form that the cursor is in
" ,eb – Evaulate the visual Block selected
" ,lw – Lookup the docs of the Word under the cursor
" ,li – Lookup the docs of the Interactively entered word (the prompt appears
"       at the bottom; press enter to search)
" ,sw – show the Source of the Word under the cursor
" ,si – show the Source Interactively (same as ,li)
" ,gw – Goto source of the Word under the cursor
" ,gi – it's like ,si and ,li
" ,rt – Run Tests in the current namespace (assuming you're in a file which defines unit tests)
" ,sr – Start a Repl in the 'user namespace
" ,sR – Start a Repl in the namespace of the file you're currently in
" :ClojureJackIn – an ex mode command to start a JVM for the current project if one doesn't exist, otherwise reconnect to the existing JVM. The connection to the JVM is necessary to use any of the interactive features/documentation.
" :ClojureJackIn new – forces a new JVM to be created, then connect to it. Useful to refresh dependencies if you change things in project.clj

""" Misc: for horizontal window resizing.
map < :res -5
map > :res +5
