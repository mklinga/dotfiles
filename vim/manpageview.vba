" Vimball Archiver by Charles E. Campbell, Jr., Ph.D.
UseVimball
finish
plugin/manpageviewPlugin.vim	[[[1
36
" manpageviewPlugin.vim
"   Author: Charles E. Campbell, Jr.
"   Date:   Aug 06, 2012
"   Version:	25b
" ---------------------------------------------------------------------
"  Load Once: {{{1
if &cp || exists("g:loaded_manpageviewPlugin")
 finish
endif
let s:keepcpo= &cpo
set cpo&vim

" ---------------------------------------------------------------------
" Public Interface: {{{1
if !hasmapto('<Plug>ManPageView') && &kp =~ '^man\>'
 nmap <unique> K <Plug>ManPageView
endif
nno <silent> <script> <Plug>ManPageView		:call manpageview#KMap(expand("<cword>"))<cr>

com! -nargs=* -count=0	Man		call manpageview#ManPageView(0,<count>,<f-args>)
com! -nargs=* -count=0	HMan	let g:manpageview_winopen="hsplit" |call manpageview#ManPageView(0,<count>,<f-args>)
com! -nargs=* -count=0	HEMan	let g:manpageview_winopen="hsplit="|call manpageview#ManPageView(0,<count>,<f-args>)
com! -nargs=* -count=0	OMan	let g:manpageview_winopen="only"   |call manpageview#ManPageView(0,<count>,<f-args>)
com! -nargs=* -count=0	RMan	let g:manpageview_winopen="reuse"  |call manpageview#ManPageView(0,<count>,<f-args>)
com! -nargs=* -count=0	VEMan	let g:manpageview_winopen="vsplit="|call manpageview#ManPageView(0,<count>,<f-args>)
com! -nargs=* -count=0	VMan	let g:manpageview_winopen="vsplit" |call manpageview#ManPageView(0,<count>,<f-args>)
com! -nargs=* -count=0	TMan	let g:manpageview_winopen="tab"    |call manpageview#ManPageView(0,<count>,<f-args>)
com! -nargs=? -count=0	KMan	call manpageview#KMan(<q-args>)
com! -nargs=* -count=1	Manprv	call manpageview#History(-<count>)
com! -nargs=* -count=1	Mannxt	call manpageview#History(<count>)

" ---------------------------------------------------------------------
"  Restore: {{{1
let &cpo= s:keepcpo
unlet s:keepcpo
" vim: ts=4 fdm=marker
autoload/manpageview.vim	[[[1
1475
" manpagevim : extra commands for manual-handling
" Author:	Charles E. Campbell
" Date:		Apr 08, 2013
" Version:	25l	 ASTRO-ONLY
"
" Please read :help manpageview for usage, options, etc
"
" GetLatestVimScripts: 489 1 :AutoInstall: manpageview.vim
"redraw!|call DechoSep()|call inputsave()|call input("Press <cr> to continue")|call inputrestore()
"let mesg= "(ManPageView) C-MBAK#1".s:WinReport() | Dech-WF mesg

" ---------------------------------------------------------------------
" Load Once: {{{1
if &cp || exists("g:loaded_manpageview")
 finish
endif
let g:loaded_manpageview = "v25l"
if v:version < 702
 echohl WarningMsg
 echo "***warning*** this version of manpageview needs vim 7.2 or later"
 echohl Normal
 finish
endif
let s:keepcpo= &cpo
set cpo&vim
"DechoTabOn

" ---------------------------------------------------------------------
" Set up default manual-window opening option: {{{1
if !exists("g:manpageview_winopen")
 let g:manpageview_winopen= "hsplit"
elseif g:manpageview_winopen == "only" && !has("mksession")
 echomsg "***g:manpageview_winopen<".g:manpageview_winopen."> not supported w/o +mksession"
 let g:manpageview_winopen= "hsplit"
endif

" ---------------------------------------------------------------------
" Sanity Check: {{{1
if !exists("*shellescape")
 fun! manpageview#ManPageView(bknum,...) range
   echohl ERROR
   echo "You need to upgrade your vim to v7.1 or later (manpageview uses the shellescape() function)"
 endfun
 finish
endif

" ---------------------------------------------------------------------
" Default Variable Values: {{{1
"DechoWF "Set up default variable values:"
if has("unix") || has("win32unix")
 let s:nostderr= " 2>/dev/null"
else
 let s:nostderr= ""
endif
if !exists("g:manpageview_iconv")
 if executable("iconv")
  let s:iconv= "iconv -c"
 else
  let s:iconv= ""
 endif
else
 let s:iconv= g:manpageview_iconv
endif
if s:iconv != ""
 let s:iconv= s:nostderr."| ".s:iconv
endif
if !exists("g:manpageview_pgm") && executable("man")
 let g:manpageview_pgm= "man"
endif
if !exists("g:manpageview_multimanpage")
 let g:manpageview_multimanpage= 1
endif
if !exists("g:manpageview_options")
 let g:manpageview_options= ""
endif
if !exists("g:manpageview_pgm_i") && executable("info")
" DechoWF "installed info help support via manpageview"
 let g:manpageview_pgm_i     = "info"
 let g:manpageview_options_i = "--output=-"
 let g:manpageview_syntax_i  = "info"
 let g:manpageview_K_i       = "<sid>MPVInfo(0)"
 let g:manpageview_init_i    = "call MPVInfoInit()"

 let s:linkpat1 = '\*[Nn]ote \([^():]*\)\(::\|$\)' " note
 let s:linkpat2 = '^\* [^:]*: \(([^)]*)\)'         " filename
 let s:linkpat3 = '^\* \([^:]*\)::'                " menu
 let s:linkpat4 = '^\* [^:]*:\s*\([^.]*\)\.$'      " index
endif
if !exists("g:manpageview_pgm_pl") && executable("perldoc")
" DechoWF "installed perl help support via manpageview"
 let g:manpageview_pgm_pl     = "perldoc"
 let g:manpageview_options_pl = "-f"
endif
if !exists("g:manpageview_pgm_pm") && executable("perldoc")
" DechoWF "installed perl help support via manpageview"
 let g:manpageview_pgm_pm     = "perldoc"
 let g:manpageview_options_pm = "-f"
endif
if !exists("g:manpageview_php_url")
 let g:manpageview_php_url     = "http://www.php.net/"
endif
if !exists("g:manpageview_pgm_php") && (executable("links") || executable("elinks"))
"  DechoWF "installed php help support via manpageview"
 let g:manpageview_pgm_php     = (executable("links")? "links" : "elinks")." -dump ".g:manpageview_php_url
 let g:manpageview_syntax_php  = "manphp"
 let g:manpageview_nospace_php = 1
 let g:manpageview_K_php       = "manpageview#ManPagePhp()"
endif
if !exists("g:manpageview_gl_url")
 let g:manpageview_gl_url= "http://www.opengl.org/sdk/docs/man/xhtml/"
endif
if !exists("g:manpageview_pgm_gl") && (executable("links") || executable("elinks"))
 let g:manpageview_pgm_gl     = (executable("links")? "links" : "elinks")." -dump ".g:manpageview_gl_url
 let g:manpageview_syntax_gl  = "mangl"
 let g:manpageview_nospace_gl = 1
 let g:manpageview_K_gl       = "manpageview#ManPagePhp()"
 let g:manpageview_sfx_gl     = ".xml"
endif
if !exists("g:manpageview_pgm_py") && executable("pydoc")
" DechoWF "installed python help support via manpageview"
 let g:manpageview_pgm_py     = "pydoc"
 let g:manpageview_K_py       = "manpageview#ManPagePython()"
endif
if exists("g:manpageview_hypertext_tex") && !exists("g:manpageview_pgm_tex") && (executable("links") || executable("elinks"))
" DechoWF "installed tex help support via manpageview"
 let g:manpageview_pgm_tex    = (executable("links")? "links" : "elinks")." ".g:manpageview_hypertext_tex
 let g:manpageview_lookup_tex = "manpageview#ManPageTexLookup"
 let g:manpageview_K_tex      = "manpageview#ManPageTex()"
endif
if has("win32") && !exists("g:manpageview_rsh")
" DechoWF "installed rsh help support via manpageview"
 let g:manpageview_rsh= "rsh"
endif
if !exists("g:manpageview_K_http")
 if executable("lynx")
  let g:manpageview_K_http     = "lynx -dump"
 elseif executable("links")
  let g:manpageview_K_http     = "links -dump"
 elseif executable("elinks")
  let g:manpageview_K_http     = "elinks -dump"
 elseif executable("wget")
  let g:manpageview_K_http     = "wget -O -"
 elseif executable("curl")
  let g:manpageview_K_http     = "curl"
 endif
endif

" =====================================================================
"  Functions: {{{1

" ---------------------------------------------------------------------
" manpageview#ManPageView: view a manual-page, accepts three formats: {{{2
"    :call manpageview#ManPageView("topic")
"    :call manpageview#ManPageView(booknumber,"topic")
"    :call manpageview#ManPageView("topic(booknumber)")
"
"    bknum   : the book number of the manpage (default=0)
"
"    Returns  0 : usually, except when
"            -1 : manpage does not exist
fun! manpageview#ManPageView(...) range
"  call Dfunc("manpageview#ManPageView(...) a:0=".a:0. " version=".g:loaded_manpageview)
"  DechoWF "(ManPageView) a:1<".((a:0 >= 1)? a:1 : 'n/a').">"
"  DechoWF "(ManPageView) a:2<".((a:0 >= 2)? a:2 : 'n/a').">"
"  DechoWF "(ManPageView) a:3<".((a:0 >= 3)? a:3 : 'n/a').">"
  set lz
  let manpageview_fname = expand("%")
  call s:MPVSaveSettings()

  " ---------------------------------------------------------------------
  " parse arguments for topic and booknumber {{{3
  "   merge quoted arguments :  ie.  handle  :Man "some topic here"
"  DechoWF "(ManPageView) parse input arguments for topic and booknumber"
  let i= 1
  while i <= a:0
   if a:{i} =~ '^"' 
	" start extracting quoted argument(s)
	let topic= substitute(a:{i},'^"','','')
	if topic =~ '"$'
	 " handling :Man "topic"
	 let topic= substitute(topic,'"$','','')
	else
	 " handling :Man "some topic"
	 let i= i + 1
	 while i <= a:0
	  let topic= topic.a:{i}
	  if a:{i} =~ '"$'
	   let topic= substitute(topic,'"$','','')
	   break
	  endif
"	  DechoWF '(ManPageView) ‣‣a:{i='.i.'}<'.a:{i}.'>: topic<'.(exists("topic")? topic : 'n/a').'> bknum<'.(exists("bknum")? bknum : 'n/a').">"
	  let i= i + 1
	 endwhile
	endif

   elseif type(a:{i}) == 0 " Number
	let bknum= string(a:{i})

   elseif a:{i} =~ '^\d\+'   " Handling booknumbers that start with digit(s) (ie. 3p)
	let bknum= a:{i}

   elseif a:{i} =~ '('
	" Handling :Man topic(book)
	let bknum= substitute(a:{i},'^.*(\(.\{-}\)).*$','\1','')
	let topic= substitute(a:{i},"(.*$","","")

   elseif a:{i} == "-k"
    let dokeysrch= 1

   else
    " Handling :call manpageview#ManPageView("topic")
	let topic= a:{i}
   endif
"   DechoWF '(ManPageView) ‣a:{i='.i.'}<'.a:{i}.'>: topic<'.(exists("topic")? topic : 'n/a').'> bknum#'.(exists("bknum")? bknum : 'n/a')
   let i= i + 1
  endwhile

  " sanity check
  if !exists("topic") || topic == ""
   echohl WarningMsg
   echo "***warning*** missing topic"
   echohl None
   sleep 2
"   call Dret("manpageview#ManPageView 0 : missing topic")
   return 0
  endif

  " default book number
  if !exists("bknum")
   let bknum= 0
  endif
"  DechoWF "(ManPageView) after parsing: topic<".topic."> bknum#".bknum

  " ---------------------------------------------------------------------
  " for the benefit of associated routines (such as InfoIndexLink()) {{{3
  let s:manpagetopic = topic
  let s:manpagebook  = bknum

  " ---------------------------------------------------------------------
  " default program g:manpageview_pgm=="man" may be overridden {{{3
  " if an extension is matched
  if exists("g:manpageview_pgm")
   let pgm = g:manpageview_pgm
  else
   let pgm = ""
  endif
  let ext = ""
  if topic =~ '\.'
   let ext = substitute(topic,'^.*\.','','e')
  endif
  if exists("g:manpageview_pgm_gl") && topic =~ '^gl'
   let ext = "gl"
  endif

  " ---------------------------------------------------------------------
  " infer the appropriate extension based on the filetype {{{3
  if ext == ""
"   DechoWF "(ManPageView) attempt to infer on filetype<".&ft.">"

   " filetype: vim
   if &ft == "vim"
"	DechoWF "(ManPageView) special vim handler"
	let retval= manpageview#ManPageVim(topic)
"	call Dret("manpageview#ManPageView ".retval)
	return retval

   " filetype: perl
   elseif &ft == "perl" || &ft == "perldoc"
"	DechoWF "(ManPageView) special perl handler"
   	let ext = "pl"

   " filetype:  php
   elseif &ft == "php" || &ft == "manphp"
"	DechoWF "(ManPageView) special php handler"
   	let ext = "php"

	" filetype:  python
   elseif &ft == "python" || &ft == "pydoc"
"	DechoWF "(ManPageView) special python handler"
   	let ext = "py"

   " filetype: info
   elseif &ft == "info"
"	DechoWF "(ManPageView) special info handler"
	let ext= "i"

   " filetype: tex
   elseif &ft == "tex"
"	DechoWF "(ManPageView) special tex handler"
    let ext= "tex"
    let retval= manpageview#ManPageTexLookup(0,topic)
"    call Dret("manpageview#ManPageView ".retval)
    return retval
   endif

  elseif ext == "vim"
"   DechoWF "(ManPageView) special vim handler"
   let retval= manpageview#ManPageVim(substitute(topic,'\.vim$','',''))
"   call Dret("manpageview#ManPageView ".retval)
   return retval

  elseif ext == "tex"
   let retval= manpageview#ManPageTexLookup(0,substitute(topic,'\.tex$',"",""))
"   call Dret("manpageview#ManPageView ".retval)
   return retval
  endif
"  DechoWF "(ManPageView) ext<".ext.">"

  " ---------------------------------------------------------------------
  " elide extension from topic {{{3
  if exists("g:manpageview_pgm_{ext}") || ext == "."
   let pgm   = g:manpageview_pgm_{ext}
   let topic = substitute(topic,'.'.ext.'$','','')
  elseif topic =~ '\.man$'
   let ext   = 'man'
  endif
  let nospace= exists("g:manpageview_nospace_{ext}")? g:manpageview_nospace_{ext} : 0
"  DechoWF "(ManPageView) pgm<".pgm."> topic<".topic."> bknum#".bknum."  (after elision of extension)"

  " ---------------------------------------------------------------------
  " special extension-based exceptions: {{{3
  if ext == 'man'
   " for man: allow ".man" extension to mean we want regular manpages even while in a supported filetype
   let pgm   = ext
   let topic = substitute(topic,'\.'.ext.'$','','')
   let ext   = ""
   if bknum == 0
	let bknum = ""
	let mpb   = ""
   endif
"   DechoWF "(ManPageView) special exception for .man: pgm<".pgm."> topic<".topic."> ext<".ext.">"

  elseif ext == "i"
  " special exception for info
   if exists("s:manpageview_pfx_i")
    unlet s:manpageview_pfx_i
   endif
   let bknum = ""
"   DechoWF "(ManPageView) special exception for .i: pgm<".(exists("pgm")? pgm : 'n/a')."> topic<".(exists("topic")? topic : 'n/a')."> ext<".(exists("ext")? ext : 'n/a').">"
   if topic == "Top"
	let g:mpvcmd = ""
   endif

  elseif bknum == 0
   let bknum = ""
  endif
"  DechoWF "(ManPageView) topic<".topic."> bknum#".bknum

  if exists("s:manpageview_pfx_{ext}") && s:manpageview_pfx_{ext} != ""
   let topic= s:manpageview_pfx_{ext}.topic
"   DechoWF "(ManPageView) modified topic<".topic."> #1"
  elseif exists("g:manpageview_pfx_{ext}") && g:manpageview_pfx_{ext} != ""
   " prepend any extension-specified prefix to topic
   let topic= g:manpageview_pfx_{ext}.topic
"   DechoWF "(ManPageView) modified topic<".topic."> #2"
  endif

  if exists("g:manpageview_sfx_{ext}") && g:manpageview_sfx_{ext} != ""
   " append any extension-specified suffix to topic
   let topic= topic.g:manpageview_sfx_{ext}
"   DechoWF "(ManPageView) modified topic<".topic."> #3"
  endif

  if exists("g:manpageview_K_{ext}") && g:manpageview_K_{ext} != ""
   " override usual K map
"   DechoWF "(ManPageView) change K map to call ".g:manpageview_K_{ext}
   exe "nmap <silent> K :\<c-u>call ".g:manpageview_K_{ext}."\<cr>"
  endif

  if exists("g:manpageview_syntax_{ext}") && g:manpageview_syntax_{ext} != ""
   " allow special-suffix extensions to optionally control syntax highlighting
   let manpageview_syntax= g:manpageview_syntax_{ext}
  else
   let manpageview_syntax= "man"
  endif
"  DechoWF "(ManPageView) manpageview_syntax<".manpageview_syntax."> topic<".topic."> bknum#".bknum

  " ---------------------------------------------------------------------
  " support for searching for options from conf pages {{{3
  if bknum == "" && manpageview_fname =~ '\.conf$'
   let manpagesrch = '^\s\+'.topic
   let topic       = manpageview_fname
  endif
"  DechoWF "(ManPageView) topic<".topic."> bknum#".bknum

  " ---------------------------------------------------------------------
  " it was reported to me that some systems change display sizes when a {{{3
  " filtering command is used such as :r! .  I record the height&width
  " here and restore it afterwards.  To make use of it, put
  "   let g:manpageview_dispresize= 1
  " into your <.vimrc>
  let dwidth  = &cwh
  let dheight = &co
"  DechoWF "(ManPageView) dwidth=".dwidth." dheight=".dheight

  " ---------------------------------------------------------------------
  " Set up the window for the manpage display (only hsplit split etc) {{{3
"  DechoWF "(ManPageView) set up window for manpage display (g:manpageview_winopen<".g:manpageview_winopen."> ft<".&ft."> manpageview_syntax<".manpageview_syntax.">)"
"  DechoWF "(ManPageView) winnr($)=".winnr("$")." ft=".&ft
  if     g:manpageview_winopen == "only"
   " OMan
   sil! noautocmd windo w
   if !exists("g:ManCurPosn") && has("mksession")
    call s:MPVSavePosn()
   endif
   " Record current file/position/screen-position
   if &ft != manpageview_syntax
    sil! only!
"	let mesg= "(ManPageView) [only]".s:WinReport() | DechoWF mesg
   endif
   sil! enew!

  elseif g:manpageview_winopen == "hsplit"
   " HMan
   if &ft != manpageview_syntax
    wincmd s
	sil! enew!
    wincmd _
    3wincmd -
   else
	sil! enew!
   endif
"   let mesg= "(ManPageView) [hsplit]".s:WinReport() | DechoWF mesg

  elseif g:manpageview_winopen == "hsplit="
   " HEMan
   if &ft != manpageview_syntax
    wincmd s
   endif
   sil! enew!
"   let mesg= "(ManPageView) [hsplit=]".s:WinReport() | DechoWF mesg

  elseif g:manpageview_winopen == "vsplit"
   " VMan
   if &ft != manpageview_syntax
    wincmd v
	sil! enew!
    wincmd |
    20wincmd <
   else
	sil! enew!
   endif
"   let mesg= "(ManPageView) [vsplit]".s:WinReport() | DechoWF mesg

  elseif g:manpageview_winopen == "vsplit="
   " VEMan
   if &ft != "man"
    wincmd v
   endif
   enew!
"   let mesg="(ManPageView) [vsplit=]".s:WinReport() | DechoWF mesg

  elseif g:manpageview_winopen == "tab"
   " TMan
   if &ft != "man"
    tabnew
   endif
"   let mesg= "(ManPageView) [tab]".s:WinReport() | DechoWF mesg

  elseif g:manpageview_winopen == "reuse"
   " RMan
   " determine if a Manpageview window already exists
   if exists("s:booksearching")
	let g:manpageview_manwin= s:booksearching
   else
    let g:manpageview_manwin= -1
    exe "noautocmd windo if &ft == '".fnameescape(manpageview_syntax)."'|let g:manpageview_manwin= winnr()|endif"
   endif
   if g:manpageview_manwin != -1
    " found a pre-existing Manpageview window, re-using it
"	DechoWF "(ManPageView) found pre-existing manpageview window (win#".g:manpageview_manwin."), re-using it"
    exe g:manpageview_manwin."wincmd w"
	sil! enew!
"	DechoWF "(ManPageView) re-using win#".g:manpageview_manwin." (note that win($)=".winnr("$").")"
   elseif &l:mod == 1
    " file has been modified, would be lost if we re-used window.  Use hsplit instead.
"    DechoWF "file<".expand("%")."> has been modified, would be lost if re-used.  Using hsplit instead"
    wincmd s
	sil! enew!
    wincmd _
    3wincmd -
   elseif &ft != manpageview_syntax
    " re-using current window (but hiding it first)
"    DechoWF "re-using current window#".winnr()." (hiding it first)"
    setlocal bh=hide
	sil! enew!
   else
	sil! enew!
   endif
"   let mesg= "(ManPageView) [reuse]".s:WinReport() | DechoWF mesg

  else
   echohl ErrorMsg
   echo "***sorry*** g:manpageview_winopen<".g:manpageview_winopen."> not supported"
   echohl None
   sleep 2
   call s:MPVRestoreSettings()
"   call Dret("manpageview#ManPageView 0 : manpageview_winopen<".g:manpageview_winopen."> not supported")
   return 0
  endif

  " ---------------------------------------------------------------------
  " let manpages format themselves to specified window width {{{3
  " this setting probably only affects the linux "man" command.
  if exists("$MANWIDTH")
   let $MANWIDTH = winwidth(0)
  endif

  " ---------------------------------------------------------------------
  " add some maps for multiple manpage handling {{{3
  " (some manpages on some systems have multiple NAME... topics provided on a single manpage)
  " The code here has PageUp/Down typically do a ctrl-f, ctrl-b; however, if there are multiple
  " topics on the manpage, then PageUp/Down will go to the previous/succeeding topic, instead.
  if g:manpageview_multimanpage
   let swp       = SaveWinPosn(0)
   let nameline1 = search("^NAME$",'Ww')
   let nameline2 = search("^NAME$",'Ww')
   sil! call RestoreWinPosn(swp)
   if nameline1 != nameline2 && nameline1 >= 1 && nameline2 >= 1
"	DechoWF "(ManPageView) multimanpage: mapping PageUp/Down to go to preceding/succeeding topic"
	nno <silent> <script> <buffer> <PageUp>			:call search("^NAME$",'bW')<cr>z<cr>5<c-y>
	nno <silent> <script> <buffer> <PageDown>		:call search("^NAME$",'W')<cr>z<cr>5<c-y>
   else
"	DechoWF "(ManPageView) multimanpage: mapping PageUp/Down to go to ctrl-f, ctrl-b"
    nno <silent> <script> <buffer> <PageDown>	<c-f>
	nno <silent> <script> <buffer> <PageUp>		<c-b>
   endif
  else
"   DechoWF "(ManPageView) not-multimanpage: mapping PageUp/Down to do ctrl-f, ctrl-b"
   nno <silent> <script> <buffer> <PageDown>	<c-f>
   nno <silent> <script> <buffer> <PageUp>		<c-b>
  endif

  " ---------------------------------------------------------------------
  " allow K to use <cWORD> when in man pages {{{3
  if manpageview_syntax == "man"
   nmap <silent> <script> <buffer>	K   :<c-u>call manpageview#KMap(1)<cr>
  endif

  " ---------------------------------------------------------------------
  " allow user to specify file encoding {{{3
  if exists("g:manpageview_fenc")
   exe "setlocal fenc=".fnameescape(g:manpageview_fenc)
  endif

  " ---------------------------------------------------------------------
  " when this buffer is exited it will be wiped out {{{3
  if v:version >= 602
   setlocal bh=wipe
  endif
  let b:did_ftplugin= 2
  let $COLUMNS=winwidth(0)

  " ---------------------------------------------------------------------
  " special manpageview buffer maps {{{3
  nnoremap <silent> <buffer> <space>     <c-f>
  nnoremap <silent> <buffer> <c-]>       :call manpageview#ManPageView(v:count1,expand("<cWORD>"))<cr>

  " -----------------------------------------
  " Invoke the man command to get the manpage {{{3
  " -----------------------------------------

  " the buffer must be modifiable for the manpage to be loaded via :r! {{{4
  setlocal ma

  let cmdmod= ""
  if v:version >= 603
   let cmdmod= "sil! keepj "
"   call Decho("(ManPageView) setting cmdmod<".cmdmod.">")
  endif

  " ---------------------------------------------------------------------
  " extension-based initialization (expected: buffer-specific maps) {{{4
  if exists("g:manpageview_init_{ext}")
   if !exists("b:manpageview_init_{ext}")
"	DechoWF "(ManPageView) exe manpageview_init_".ext."<".g:manpageview_init_{ext}.">"
	exe g:manpageview_init_{ext}
	let b:manpageview_init_{ext}= 1
   endif
  elseif ext == ""
"   DechoWF "(ManPageView) change K map to support empty extension"
   sil! unmap K
"   DechoWF "(ManPageView) nmap <silent> <unique> K manpageview#KMap(0)"
   nmap <silent> <unique> K :<c-u>call manpageview#KMap(0)<cr>
  endif

  " ---------------------------------------------------------------------
  " default program g:manpageview_options (empty string) may be overridden {{{4
  " if an extension is matched
  let opt= g:manpageview_options
  if exists("g:manpageview_options_{ext}")
   let opt= g:manpageview_options_{ext}
  endif

  let cnt= 0
  while cnt < 3 && (strlen(opt) > 0 || cnt == 0)
"   DechoWF "(ManPageView) ‣while [cnt=".cnt."]<3 AND (strlen(opt<".opt.">) > 0 || cnt==0)"
   let cnt   = cnt + 1
   let iopt  = substitute(opt,';.*$','','e')
   let opt   = substitute(opt,'^.\{-};\(.*\)$','\1','e')
"   DechoWF "(ManPageView) ‣cnt=".cnt." iopt<".iopt."> opt<".opt."> s:iconv<".(exists("s:iconv")? s:iconv : "").">"
   if exists("dokeysrch")
	let iopt= iopt." -k"
   endif

  " ---------------------------------------------------------------------
   " use pgm to read/find/etc the manpage (but only if pgm is not the empty string)
   " by default, pgm is "man"
   if pgm != ""

	" ---------------------------
	" use manpage_lookup function {{{4
	" ---------------------------
   	if exists("g:manpageview_lookup_{ext}")
"	 DechoWF "(ManPageView) ‣lookup: exe call ".g:manpageview_lookup_{ext}."('".bknum."','".topic."')"
"	 DechoWF "(ManPageView) ‣lookup: g:manpageview_lookup_".ext."<".g:manpageview_lookup_{ext}.">"
"	 DechoWF "(ManPageView) ‣lookup: bknum<".bknum.">"
"	 DechoWF "(ManPageView) ‣lookup: topic<".topic.">"
	 exe "call ".g:manpageview_lookup_{ext}."('".bknum."','".topic."')"

    elseif has("win32") && exists("g:manpageview_server") && exists("g:manpageview_user")
"	 DechoWF "(ManPageView) ‣win32: bknum<".bknum."> topic<".topic.">"
     exe cmdmod."r!".g:manpageview_rsh." ".g:manpageview_server." -l ".g:manpageview_user." ".pgm." ".iopt." ".shellescape(bknum,1)." ".shellescape(topic,1)
     exe cmdmod.'sil!  %s/.\b//ge'

	"--------------------------
	" use pgm to obtain manpage {{{4
	"--------------------------
    else
	 if bknum != ""
	  let mpb= shellescape(bknum,1)
	 else
	  let mpb= ""
	 endif
"	 DechoWF "(ManPageView) ‣pgm    <".(exists("pgm")?     pgm     : 'n/a').">"
"	 DechoWF "(ManPageView) ‣iopt   <".(exists("iopt")?    iopt    : 'n/a').">"
"	 DechoWF "(ManPageView) ‣mpb    <".(exists("mpb")?     mpb     : 'n/a').">"
"	 DechoWF "(ManPageView) ‣topic  <".(exists("topic")?   topic   : 'n/a').">"
"	 DechoWF "(ManPageView) ‣s:iconv<".(exists("s:iconv")? s:iconv : 'n/a').">"
"	 call Decho('(ManPageView) ‣s:nostderr="'.s:nostderr.'"')
	 if exists("g:mpvcmd")
"	  DechoWF "(ManPageView) ‣mpvcmd: exe ".cmdmod."r!".pgm." ".iopt." ".mpb." ".g:mpvcmd.s:nostderr
      exe cmdmod."r!".pgm." ".iopt." ".mpb." ".g:mpvcmd.s:nostderr
	  unlet g:mpvcmd
	 elseif nospace
"	  DechoWF "(ManPageView) ‣nospace=".nospace.":  exe sil! ".cmdmod."r!".pgm.iopt.mpb.topic.(exists("s:iconv")? s:iconv : "").s:nostderr
	  exe cmdmod."r!".pgm.iopt.mpb.shellescape(topic,1).(exists("s:iconv")? s:iconv : "").s:nostderr
     elseif has("win32")
"	  DechoWF "(ManPageView) ‣win32: exe ".cmdmod."r!".pgm." ".iopt." ".mpb." \"".topic."\" ".(exists("s:iconv")? s:iconv : "").s:nostderr
	  exe cmdmod."r!".pgm." ".iopt." ".mpb." ".shellescape(topic,1).(exists("s:iconv")? " ".s:iconv : "").s:nostderr
	 else
"	  call Decho("(ManPageView) ‣normal: exe ".cmdmod."r!".pgm." ".iopt." ".mpb." '".topic."' ".(exists("s:iconv")? s:iconv : "").s:nostderr)
	  exe cmdmod."r!".pgm." ".iopt." ".mpb." ".shellescape(topic,1).(exists("s:iconv")? " ".s:iconv : "").s:nostderr
	endif
     exe cmdmod.'sil!  %s/.\b//ge'
    endif
	setlocal ro nomod noswf
   endif

  " ---------------------------------------------------------------------
   " check if manpage actually found {{{3
   if line("$") != 1 || col("$") != 1
"	DechoWF "(ManPageView) ‣manpage found"
    break
   endif
"   DechoWF "(ManPageView) ‣cnt=".cnt.": manpage not found"
   if cnt == 3 && !exists("g:manpageview_iconv") && s:iconv != ""
	let s:iconv= ""
"	DechoWF "(ManPageView) ‣trying with no iconv"
   elseif cnt == 1
	break
   endif
  endwhile

  " ---------------------------------------------------------------------
  " here comes the vim display size restoration {{{3
  if exists("g:manpageview_dispresize")
   if g:manpageview_dispresize == 1
"	DechoWF "(ManPageView) restore display size to ".dheight."x".dwidth
    exe "let &co=".dwidth
    exe "let &cwh=".dheight
   endif
  endif

  " ---------------------------------------------------------------------
  " clean up (ie. remove) any ansi escape sequences {{{3
  if line("$") != 1 || col("$") != 1
"   DechoWF "(ManPageView) remove any ansi escape sequences"
   sil! %s/\e\[[0-9;]\{-}m//ge
   sil! %s/\%xe2\%x80\%x90/-/ge
   sil! %s/\%xe2\%x88\%x92/-/ge
   sil! %s/\%xe2\%x80\%x99/'/ge
   sil! %s/\%xe2\%x94\%x82/ /ge

  " ---------------------------------------------------------------------
  " set up options and put cursor at top-left of manpage {{{3
"  DechoWF "(ManPageView) set up options and put cursor at top-left of manpage"
   if bknum == "-k"
    setlocal ft=mankey
   else
    exe cmdmod."setlocal ft=".fnameescape(manpageview_syntax)
   endif
   exe cmdmod."setlocal ro"
   exe cmdmod."setlocal noma"
   exe cmdmod."setlocal nomod"
   exe cmdmod."setlocal nolist"
   exe cmdmod."setlocal nonu"
   exe cmdmod."setlocal fdc=0"
"   exe cmdmod."setlocal isk+=-,.,(,)"
   exe cmdmod."setlocal nowrap"
   set nolz
   exe cmdmod."1"
   exe cmdmod."norm! 0"
  endif

  " ---------------------------------------------------------------------
  "  check if help was not found  {{{3
  if line("$") == 1 && col("$") == 1
"   DechoWF "(ManPageView) no help found: ft=".&ft." manpageview_syntax<".(exists("manpageview_syntax")? manpageview_syntax : 'n/a').">"

   if &ft == manpageview_syntax
	if exists("s:manpageview_curtopic")
"	 DechoWF "(ManPageView) no help found: s:manpageview_curtopic<".s:manpageview_curtopic.">"
	 call manpageview#ManPageView(v:count,s:manpageview_curtopic)
	endif
   elseif winnr("$") > 1 && !exists("s:booksearching")
"    DechoWF "(ManPageView) no help found, quitting help window"
    sil! q!
   endif

"   DechoWF "(ManPageView) save winposn"
   call SaveWinPosn()
"   DechoWF "***warning*** no manpage exists for <".topic."> book<".bknum.">"
   if !exists("s:mpv_booksearch")
    echohl ErrorMsg
    echo "***warning*** sorry, no manpage exists for <".topic.">"
    echohl None
    sleep 2
   endif
"   DechoWF "(ManPageView) winnr($)=".winnr("$")." ft=".&ft

   if exists("s:mpv_before_k_posn")
"	DechoWF "(ManPageView) restoring winposn"
	sil! call RestoreWinPosn(s:mpv_before_k_posn)
	unlet s:mpv_before_k_posn
   endif

   " attempt to recover from a no-manpage-found condition
   if exists("s:onerr_bknum")
	call manpageview#ManPageView(s:onerr_bknum,s:onerr_topic)
	call RestoreWinPosn(s:onerr_winpos)
	unlet s:onerr_bknum s:onerr_topic s:onerr_winpos
   endif

"   DechoWF "(ManPageView) restoring settings"
   call s:MPVRestoreSettings()
"   call Dret("manpageview#ManPageView -1 : no manpage exists for <".topic.">")
   return -1

  elseif bknum == ""
"   DechoWF '(ManPageView) exe file '.fnameescape('Manpageview['.topic.']')
   exe 'sil! file '.fnameescape('Manpageview['.topic.']')
   let s:manpageview_curtopic= topic

  else
"   DechoWF '(ManPageView) exe file '.fnameescape('Manpageview['.topic.'('.fnameescape(bknum).')]')
   exe 'sil! file '.fnameescape('Manpageview['.topic.'('.fnameescape(bknum).')]')
   let s:manpageview_curtopic= topic."(".bknum.")"
  endif

  " ---------------------------------------------------------------------
  " Enter booknumber and topic into history
  if !exists("s:history") || s:ihist == len(s:history)-1
"   DechoWF "(ManPageView) Saving history: bknum#".bknum." topic<".topic.">"
   call manpageview#History(0,bknum,topic)
  endif

  " ---------------------------------------------------------------------
  " Install search book maps
  nno <silent> <buffer> <s-left>	:call manpageview#BookSearch(-v:count1)<cr>
  nno <silent> <buffer> <s-right>	:call manpageview#BookSearch( v:count1)<cr>

  " ---------------------------------------------------------------------
  " if there's a search pattern, use it {{{3
  if exists("manpagesrch")
   if search(manpagesrch,'w') != 0
    exe "norm! z\<cr>"
   endif
  endif

  " ---------------------------------------------------------------------
  " restore settings {{{3
  call s:MPVRestoreSettings()
"  call Dret("manpageview#ManPageView 0")
  return 0
endfun

" ---------------------------------------------------------------------
" manpageview#KMap: handles the K map {{{2
fun! manpageview#KMap(usecWORD)
"  call Dfunc("manpageview#KMap(usecWORD=".a:usecWORD.")")
  if a:usecWORD =~ '^http:'
   if exists("g:manpageview_K_http")
	let url= substitute(a:usecWORD,")$","","")
"	call Decho("url<".url.">")
    tabnew
	exec 'sil! r! '.g:manpageview_K_http." ".fnameescape(url)
	exe "file ".fnameescape(url)
	setl nomod noma
   else
    echohl WarningMsg
	echo "***warning*** (manpageview#KMap) needs one of (lynx|links|elinks|wget|curl) to handle urls"
	echohl None
   endif
  elseif &ft == "info"
   if getline(".") =~ '^\s*\*\s*.*::'
    call s:MPVInfo(5)
   else
	call manpageview#ManPageView(0,expand("<cword>"))
   endif
  else
   let book= v:count
   if book == 0
	if getline(".") =~ '\<'.expand("<cword>").'\s\+(\d\+)'
	 let book= substitute(getline("."),'\<'.expand("<cword>").'\s\+(\(\d\+\)).*$','\1','') + 0
	else
     let book= "0"
	endif
   elseif book > 0
    let book= string(book)
   else
    let book= ""
   endif
   if a:usecWORD
    let topic               = expand("<cWORD>")
   else
    let topic               = expand("<cword>")
   endif
   let s:mpv_before_k_posn = SaveWinPosn(0)
"   DechoWF "(KMap) book#".(exists("book")? book : 'n/a')."  topic<".(exists("topic")? topic : 'n/a').">"
   call manpageview#ManPageView(book,topic)
  endif
"  call Dret("manpageview#KMap")
endfun

" ---------------------------------------------------------------------
" s:MPVSavePosn: saves current file, line, column, and screen position {{{2
fun! s:MPVSavePosn()
"  call Dfunc("s:MPVSavePosn()")

  let g:ManCurPosn= tempname()
  let keep_ssop   = &ssop
  let &ssop       = 'winpos,buffers,slash,globals,resize,blank,folds,help,options,winsize'
  if v:version >= 603
   exe 'keepj sil! mksession! '.fnameescape(g:ManCurPosn)
  else
   exe 'sil! mksession! '.fnameescape(g:ManCurPosn)
  endif
  let &ssop       = keep_ssop
  cnoremap <silent> q call <SID>MPVRestorePosn()<CR>

"  call Dret("s:MPVSavePosn")
endfun

" ---------------------------------------------------------------------
" s:MPVRestorePosn: restores file/position/screen-position {{{2
"                 (uses g:ManCurPosn)
fun! s:MPVRestorePosn()
"  call Dfunc("s:MPVRestorePosn()")

  if exists("g:ManCurPosn")
"   DechoWF "g:ManCurPosn<".g:ManCurPosn.">"
   if v:version >= 603
	exe 'keepj sil! source '.fnameescape(g:ManCurPosn)
   else
	exe 'sil! source '.fnameescape(g:ManCurPosn)
   endif
   unlet g:ManCurPosn
   sil! cunmap q
  endif

"  call Dret("s:MPVRestorePosn")
endfun

" ---------------------------------------------------------------------
" s:MPVSaveSettings: save and standardize certain user settings {{{2
fun! s:MPVSaveSettings()

  if !exists("s:sxqkeep")
"   call Dfunc("s:MPVSaveSettings()")
   let s:manwidth          = expand("$MANWIDTH")
   let s:sxqkeep           = &sxq
   let s:srrkeep           = &srr
   let s:repkeep           = &report
   let s:gdkeep            = &gd
   let s:cwhkeep           = &cwh
   let s:magickeep         = &l:magic
   setlocal srr=> report=10000 nogd magic
   if &cwh < 2
    " avoid hit-enter prompts
    setlocal cwh=2
   endif
  if has("win32") || has("win95") || has("win64") || has("win16")
   let &sxq= '"'
  else
   let &sxq= ""
  endif

  if $MANWIDTH == ""
   let $MANWIDTH = winwidth(0)
  endif
  let s:curmanwidth = $MANWIDTH
"  call Dret("s:MPVSaveSettings")
 endif
 if &ft == "man" && exists("s:history") && exists("s:ihist")
  let s:onerr_bknum  = s:history[s:ihist][0]
  let s:onerr_topic  = s:history[s:ihist][1]
  let s:onerr_winpos = SaveWinPosn()
 endif

endfun

" ---------------------------------------------------------------------
" s:MPVRestoreSettings: {{{2
fun! s:MPVRestoreSettings()
  if exists("s:sxqkeep")
"   call Dfunc("s:MPVRestoreSettings()")
   let &sxq      = s:sxqkeep     | unlet s:sxqkeep
   let &srr      = s:srrkeep     | unlet s:srrkeep
   let &report   = s:repkeep     | unlet s:repkeep
   let &gd       = s:gdkeep      | unlet s:gdkeep
   let &cwh      = s:cwhkeep     | unlet s:cwhkeep
   let &l:magic  = s:magickeep   | unlet s:magickeep
   let $MANWIDTH = s:curmanwidth | unlet s:curmanwidth
"   call Dret("s:MPVRestoreSettings")
  endif
endfun

" ---------------------------------------------------------------------
" s:MPVInfo: {{{2
fun! s:MPVInfo(type)
"  call Dfunc("s:MPVInfo(type=".a:type.")")
  let s:before_K_posn = SaveWinPosn(0)

  if &ft != "info"
   " restore K and do a manpage lookup for word under cursor
"   DechoWF "ft<".&ft."> ≠ info: restore K and do a manpage lookup of word under cursor"
   setlocal kp=manpageview#ManPageView
   if exists("s:manpageview_pfx_i")
    unlet s:manpageview_pfx_i
   endif
   call manpageview#ManPageView(0,expand("<cWORD>"))
"   call Dret("s:MPVInfo : restored K")
   return
  endif

  if !exists("s:manpageview_pfx_i") && exists("g:manpageview_pfx_i")
   let s:manpageview_pfx_i= g:manpageview_pfx_i
  endif

  " -----------
  " Follow Link
  " -----------
  if a:type == 0
   " extract link
   let curline  = getline(".")
"   DechoWF "type==0: curline<".curline.">"
   let ipat     = 1
   while ipat <= 4
    let link= matchstr(curline,s:linkpat{ipat})
"	DechoWF '..attempting s:linkpat'.ipat.":<".s:linkpat{ipat}.">"
    if link != ""
     if ipat == 2
      let s:manpageview_pfx_i = substitute(link,s:linkpat{ipat},'\1','')
      let node                = "Top"
     else
      let node                = substitute(link,s:linkpat{ipat},'\1','')
 	 endif
"   	 DechoWF "ipat=".ipat."link<".link."> node<".node."> pfx<".s:manpageview_pfx_i.">"
 	 break
    endif
    let ipat= ipat + 1
   endwhile

  " -------------------
  " Go to next node "]"
  " -------------------
  elseif a:type == 1
   let infofile = matchstr(getline(2),'File: \zs[^,]\+\ze,')
   let nxtnode  = matchstr(getline(2),'Next: \zs[^,]\+\ze,')
   let node     = ""
   let g:mpvcmd = ' --node="'.nxtnode.'" -f "'.infofile.'"'
"   DechoWF "type==1: goto next node<".node."> with infofile<".infofile.">"

  " -----------------------
  " Go to previous node "["
  " -----------------------
  elseif a:type == 2
   let infofile = matchstr(getline(2),'File: \zs[^,]\+\ze,')
   let prvnode  = matchstr(getline(2),'Prev: \zs[^,]\+\ze,')
   let node     = ""
   let g:mpvcmd = ' --node="'.prvnode.'" -f "'.infofile.'"'
"   DechoWF "type==2: goto previous node<".node."> with infofile<".infofile.">"

  " --------------
  " Go up node "u"
  " --------------
  elseif a:type == 3
   let infofile = matchstr(getline(2),'File: \zs[^,]\+\ze,')
   let upnode   = matchstr(getline(2),'Up: \zs.\+$')
   let node     = ""
   let g:mpvcmd = ' --node="'.upnode.'" -f "'.infofile.'"'
"   DechoWF "type==3: go up one node<".upnode."> with infofile<".infofile.">"
   if node == "(dir)"
	echo "***sorry*** can't go up from this node"
"    call Dret("s:MPVInfo : can't go up a node")
    return
   endif

  " ------------------
  " Go to top node "t"
  " ------------------
  elseif a:type == 4
"   DechoWF "type==4: go to top node"
   let node= ""

  " -----------------------
  " Select Menu Node "<cr>"
  " -----------------------
  elseif a:type == 5
   let infofile = matchstr(getline(2),'File: \zs[^,\t]\+\ze[,\t]')
   let node     = matchstr(getline(2),'^.*Node: \zs[^,\t]\+\ze[,\t]')
   let selnode  = matchstr(getline("."),'^\s*\*\s*\zs[^:]\+\ze:')
   let infofile2= matchstr(getline("."),'^\s*\*\s*[^:]\+:\s*(\zs[^)]\+\ze)')
   let node2    = matchstr(getline("."),'^\s*\*\s*[^:]\+:\s*([^)]\+)\zs[^.]*\ze\.')
"   DechoWF "type==5:  infofile<".infofile.">"
"   DechoWF "type==5: infofile2<".infofile2.">"
"   DechoWF "type==5:   selnode<".selnode.">"
"   DechoWF "type==5:      node<".node.">"
"   DechoWF "type==5:      node2<".node2.">"
   if infofile2 != "" && node2 != ""
	let infofile= infofile2
"	DechoWF "type==5: infofile <".infofile."> (overridden with infofile2)"
   endif
   if node2 != ""
	let srchpat= selnode
	let selnode= node2
"	DechoWF "type==5: selnode <".selnode."> (overridden with node2)"
   endif
   if line('.') == 2
"    DechoWF "cword<".expand("<cword>").">"
	if     expand("<cword>") == "Next"
	 call s:MPVInfo(1)
"     call Dret("s:MPVInfo")
	 return
	elseif expand("<cword>") == "Prev" 
	 call s:MPVInfo(2)
"     call Dret("s:MPVInfo")
	 return
	elseif expand("<cword>") == "Up" 
	 call s:MPVInfo(3)
"     call Dret("s:MPVInfo")
	 return
	else
	 let marka = SaveMark("a")
	 let markb = SaveMark("b")
	 let keepa = @a
	 norm! mbF:lmaf,"ay`a`b
	 let selnode= @a
	 call RestoreMark("b")
	 call RestoreMark("a")
	 let @a       = keepa
     let g:mpvcmd = ' --node="'.selnode.'" -f "'.infofile.'"'
"	 DechoWF "type==5: selnode<".selnode.">"
	endif
   elseif selnode == "Menu" || selnode == ""
"	call Dret("s:MPVInfo : skip Menu")
    return
   elseif node == "Top" && infofile == "dir"
	let g:mpvcmd = ' -f '.selnode
	let node     = ""
"	DechoWF "type==5: goto selected node<".selnode."> (special: infofile is dir)"
   else
	let node     = ""
    let g:mpvcmd = ' --node="'.selnode.'" -f "'.infofile.'"'
"    DechoWF "type==5: goto selected node<".selnode."> with infofile<".infofile.">"
   endif
"   DechoWF "type==5: g:mpvcmd<".(exists("g:mpvcmd")? g:mpvcmd : 'n/a').">"
  endif
"  DechoWF "node<".(exists("node")? node : '--n/a--').">"

  " use ManPageView() to view selected node
  if !exists("node")
   echohl ErrorMsg
   echo "***sorry*** unable to view selection"
   echohl None
   sleep 2
  else
   call manpageview#ManPageView(0,node.".i")
   if exists("srchpat")
"	DechoWF "applying srchpat<".srchpat.">"
	call search('\<'.srchpat.'\>')
   endif
  endif

"  call Dret("s:MPVInfo")
endfun

" ---------------------------------------------------------------------
" MPVInfoInit: initialize maps for info pages {{{2
fun! MPVInfoInit()
"  call Dfunc("MPVInfoInit()")

  " some mappings to imitate the default info reader
  nmap    <buffer> <silent> K			:<c-u>call manpageview#KMap(0)<cr>
  noremap <buffer> <silent>	]			:call <SID>MPVInfo(1)<cr>
  noremap <buffer> <silent>	n			:call <SID>MPVInfo(1)<cr>
  noremap <buffer> <silent>	[			:call <SID>MPVInfo(2)<cr>
  noremap <buffer> <silent>	p			:call <SID>MPVInfo(2)<cr>
  noremap <buffer> <silent>	u			:call <SID>MPVInfo(3)<cr>
  noremap <buffer> <silent>	t			:call <SID>MPVInfo(4)<cr>
  noremap <buffer> <silent>	<cr>		:call <SID>MPVInfo(5)<CR>
  noremap <buffer> <silent>	<leftmouse>	<leftmouse>:call <SID>MPVInfo(5)<CR>
  noremap <buffer> <silent>	?			:he manpageview-info<cr>
  noremap <buffer> <silent>	d			:call manpageview#ManPageView(0,"dir.i")<cr>
  noremap <buffer> <silent>	H			:help manpageview-info<cr>
  noremap <buffer> <silent>	<Tab>		:call <SID>NextInfoLink()<CR>
  noremap <buffer> <silent>	i			:call <SID>InfoIndexLink('i')<CR>
  noremap <buffer> <silent>	>			:call <SID>InfoIndexLink('>')<CR>
  noremap <buffer> <silent>	<			:call <SID>InfoIndexLink('<')<CR>
  noremap <buffer> <silent>	,			:call <SID>InfoIndexLink('>')<CR>
  noremap <buffer> <silent>	;			:call <SID>InfoIndexLink('<')<CR>
  noremap <buffer> <silent> <F1>		:echo "] goto nxt node   [ goto prv node   d goto toplvl   u go up   i indx srch   > nxt indx srch   < prv indx srch   \<tab\> next hyperlink"<cr> 
"  call Dret("MPVInfoInit")
endfun

" ---------------------------------------------------------------------
" s:NextInfoLink: {{{2
fun! s:NextInfoLink()
    let ln = search('\%('.s:linkpat1.'\|'.s:linkpat2.'\|'.s:linkpat3.'\|'.s:linkpat4.'\)', 'w')
    if ln == 0
		echohl ErrorMsg
	   	echo '***sorry*** no links found' 
	   	echohl None
		sleep 2
    endif
endfun

" ---------------------------------------------------------------------
" s:InfoIndexLink: supports info's  i  for index-search-for-topic {{{2
"                                 > ,  for next occurrence of index searched topic
"                                 < ;  for prev occurrence of index searched topic
fun! s:InfoIndexLink(cmd)
"  call Dfunc("s:InfoIndexLink(cmd<".a:cmd.">)")

  if a:cmd == 'i'
   call inputsave()
   let g:mpv_infolink= input("Index entry: ","","shellcmd")
   call inputrestore()
"   DechoWF "(InfoIndexLink) g:mpv_infolink<".g:mpv_infolink.">"
   call manpageview#ManPageView(0,g:mpv_infolink.".i")
   call search('\<'.g:mpv_infolink.'\>','W')
"   call Dret("s:InfoIndexLink")
   return

  elseif a:cmd == '>'
   let g:mpv_infolink= matchstr(getline(2),'^.*Next: \zs[^,\t]\+\ze[,\t]')
   call search('\<'.g:mpv_infolink.'\>','W')

  elseif a:cmd == '<'
   let g:mpv_infolink= matchstr(getline(2),'^.*Prev: \zs[^,\t]\+\ze[,\t]')
   call search('\<'.g:mpv_infolink.'\>','bW')

  else
   echohl WarningMsg
   echo "***warning*** (s:InfoIndexLink) unsupported command ".a:cmd
   echohl Normal
  endif

"  call Dret("s:InfoIndexLink")
endfun

" ---------------------------------------------------------------------
" manpageview#:ManPagePhp: {{{2
fun! manpageview#ManPagePhp()
  let s:before_K_posn = SaveWinPosn(0)
  let topic           = substitute(expand("<cWORD>"),'()\=.*$','.php','')
"  call Dfunc("manpageview#ManPagePhp() topic<".topic.">")
  call manpageview#ManPageView(0,topic)
"  call Dret("manpageview#ManPagePhp")
endfun

" ---------------------------------------------------------------------
" manpageview#:ManPagePython: {{{2
fun! manpageview#ManPagePython()
  let s:before_K_posn = SaveWinPosn(0)
  let topic           = substitute(expand("<cWORD>"),'()\=.*$','.py','')
"  call Dfunc("manpageview#ManPagePython() topic<".topic.">")
  call manpageview#ManPageView(0,topic)
"  call Dret("manpageview#ManPagePython")
endfun

" ---------------------------------------------------------------------
" manpageview#ManPageVim: {{{2
fun! manpageview#ManPageVim(topic)
"  call Dfunc("manpageview#ManPageVim(topic<".a:topic.">)")
  if g:manpageview_winopen == "only"
   " OMan
   exe "help ".fnameescape(a:topic)
   only
  elseif g:manpageview_winopen == "vsplit"
   " VMan
   exe "vert help ".fnameescape(a:topic)
  elseif g:manpageview_winopen == "vsplit="
   " VEMan
   exe "vert help ".fnameescape(a:topic)
   wincmd =
  elseif g:manpageview_winopen == "hsplit="
   " HEMan
   exe "help ".fnameescape(a:topic)
   wincmd =
  elseif g:manpageview_winopen == "tab"
   " TMan
   tabnew
   exe "help ".fnameescape(a:topic)
   only
  elseif g:manpageview_winopen == "reuse"
   " RMan
   let g:manpageview_manwin = -1
   exe "noautocmd windo if &ft == 'help'|let g:manpageview_manwin= winnr()|endif"
   if g:manpageview_manwin != -1
	" found a pre-existing help window, re-using it
"	DechoWF "found pre-exiting help window, re-using it"
	exe g:manpageview_manwin."wincmd w"
    exe "help ".fnameescape(a:topic)
   elseif &l:mod == 1
	" file has been modified, would be lost if we re-used window.  Use regular help instead if its the only window on the buffer
	let g:manpageview_bufcnt  = 0
	let g:manpageview_bufname = bufname("%")
	noautocmd windo if bufname("%") == g:manpageview_bufname|let g:manpageview_bufcnt= g:manpageview_bufcnt + 1 | endif
    if g:manpageview_bufcnt > 1
     exe "help ".fnameescape(a:topic)
	 wincmd j
	 q
	else
"	 DechoWF "file<".expand("%")."> has been modified and would be lost if re-used.  Using regular help"
     exe "help ".fnameescape(a:topic)
	endif
   elseif &ft != "help"
	" re-using current window (but hiding it first)
"	DechoWF "re-using current window#".winnr()." (hiding it first)"
   	setlocal bh=hide
    exe "help ".fnameescape(a:topic)
	wincmd j
	q
   else
	" already a help window
    exe "help ".fnameescape(a:topic)
   endif
  else
   " Man
   exe "help ".fnameescape(a:topic)
  endif

"  call Dret("manpageview#ManPageVim")
endfun

" ---------------------------------------------------------------------
" manpageview#ManPageTex: {{{2
fun! manpageview#ManPageTex()
  let s:before_K_posn = SaveWinPosn(0)
  let topic           = '\'.expand("<cWORD>")
"  call Dfunc("manpageview#ManPageTex() topic<".topic.">")
  call manpageview#ManPageView(0,topic)
"  call Dret("manpageview#ManPageTex")
endfun

" ---------------------------------------------------------------------
" manpageview#ManPageTexLookup: {{{2
fun! manpageview#ManPageTexLookup(book,topic)
"  call Dfunc("manpageview#ManPageTexLookup(book<".a:book."> topic<".a:topic.">)")
  let userdoc= substitute(&rtp,',.*','','')
  if filereadable(userdoc."/doc/latexhelp.txt")
   call manpageview#ManPageVim(a:topic)
  else
   echomsg "May I suggest getting Mikolaj Michowski's latexhelp.txt"
   echomsg "http://www.vim.org/scripts/script.php?script_id=206"
  endif
"  call Dret("manpageview#ManPageTexLookup")
endfun

" ---------------------------------------------------------------------
" Function: {{{2
fun! Function()
"  call Dfunc("Function()")
"  call Dret("Function")
endfun

" ---------------------------------------------------------------------
" manpageview#KMan: set default extension for K map {{{2
fun! manpageview#KMan(ext)
"  call Dfunc("manpageview#KMan(ext<".a:ext.">)")

  let s:before_K_posn = SaveWinPosn(0)
  if a:ext == "perl"
   let ext= "pl"
  elseif a:ext == "gvim"
   let ext= "vim"
  elseif a:ext == "info" || a:ext == "i"
   let ext    = "i"
   set ft=info
  elseif a:ext == "man"
   let ext= ""
  else
   let ext= a:ext
  endif
"  DechoWF "ext<".ext.">"

  " change the K map
"  DechoWF "change the K map"
  sil! nummap K
  sil! nunmap <buffer> K
  if exists("g:manpageview_K_{ext}") && g:manpageview_K_{ext} != ""
   exe "nmap <silent> <buffer> K :call ".g:manpageview_K_{ext}."\<cr>"
"   DechoWF "nmap <silent> K :call ".g:manpageview_K_{ext}
  else
"   DechoWF "change K map (KMan)"
   nmap <unique> K <Plug>ManPageView
"   DechoWF "nmap <unique> K <Plug>ManPageView"
  endif

"  call Dret("manpageview#KMan ")
endfun

" ---------------------------------------------------------------------
" s:WinReport: {{{2
fun! s:WinReport()
  let winreport = ""
  let curwin    = winnr()
  sil! noautocmd windo let winreport= winreport." win#".winnr()."<".bufname("%").">"
  exe "noautocmd ".curwin."wincmd w"
  return winreport
endfun

" ---------------------------------------------------------------------
" manpageview#History: save and apply history {{{2
"   mode=0 : save
"   mode>0 : move up history
"   move<0 : move down history
fun! manpageview#History(mode,...)
"  call Dfunc("manpageview#History(mode=".a:mode.") a:0=".a:0)
  if !exists("s:history")
"   DechoWF "initializing history"
   let s:history= []
   let s:ihist  = 0
  endif
"  call Decho("s:history=".string(s:history))
"  call Decho("s:ihist  =".s:ihist)
"  call Decho("a:mode=".a:mode)
"  call Decho("a:0   =".a:0)
"  if a:0 >= 1|call Decho("a:1<".a:1.">")|endif
"  if a:0 >= 2|call Decho("a:2<".a:2.">")|endif
"  if exists("s:history[s:ihist]")|call Decho("s:history[s:ihist] exists")|endif
"  if exists("s:history[s:ihist]")|call Decho("s:history[".s:ihist."]<".string(s:history[s:ihist]).">")|endif

  " Enter current manpage into history
  if a:mode == 0
   if a:0 >= 2
	if len(s:history) == 0 || (exists("s:history[s:ihist]") && !(s:history[s:ihist][0] == a:1 && s:history[s:ihist][1] == a:2))
     let s:history+= [[a:1,a:2]]
	 let s:ihist   = len(s:history)-1
"	 call Decho("(new) s:history[".s:ihist."]=".string(s:history))
    endif
   endif

  " Return to subsequent history
  elseif a:mode > 0
   if s:ihist >= len(s:history)-1
	" already showing end of history
    let s:ihist= len(s:history)
   else
	let s:ihist= s:ihist + a:mode
	if s:ihist > len(s:history)
	 let s:ihist= len(s:history) - 1
	endif
"	call Decho("(next) history[".s:ihist."]=".string(s:history[s:ihist]))
	call manpageview#ManPageView(s:history[s:ihist][0],s:history[s:ihist][1])
   endif

  " Return to prior history
  elseif a:mode < 0
   if s:ihist <= 0
	" already showing beginning of history
    let s:ihist= 0
   else
	let s:ihist= s:ihist + a:mode
	if s:ihist < 0
	 let s:ihist= 0
	endif
"	call Decho("(prev) history[".s:ihist."]=".string(s:history[s:ihist]))
	call manpageview#ManPageView(s:history[s:ihist][0],s:history[s:ihist][1])
   endif
  endif

  " install history maps
  nno <silent> <buffer> <s-down>	:call manpageview#History(-v:count1)<cr>
  nno <silent> <buffer> <s-up>		:call manpageview#History( v:count1)<cr>
"  call Dret("manpageview#History")
endfun

" ---------------------------------------------------------------------
" manpageview#BookSearch: search for another manpagepage on the given topic {{{2
"   direction= +1 : search larger  book numbers
"            = -1 : search smaller book numbers
fun! manpageview#BookSearch(direction)
"  call Dfunc("manpageview#BookSearch(direction=".a:direction.")")
  let bknum    = s:history[s:ihist][0]
  let curbknum = bknum
  if bknum == ""
   if getline(2) =~ '(\d\+[px]\=)'
	let bknum= substitute(getline(2),'^.\{-}(\(\d\+[px]\=\)).*$','\1','')
   elseif getline(1) =~ '(\d\+[px]\=)'
	let bknum= substitute(getline(1),'^.\{-}(\(\d\+[px]\=\)).*$','\1','')
   else
	let bknum= "1"
   endif
"   call Decho("booksearch: setting bknum=".bknum." (was empty string)")
  elseif type(bknum) != 1
   let bknum= string(bknum)
  endif
  let s:mpv_booksearch      = 1
  let retval                = -1
  let topic                 = s:history[s:ihist][1]
  let curtopic              = topic
  let keep_mpv_winopen      = g:manpageview_winopen
  let keeplz                = &lz
  set lz
  let g:manpageview_winopen = "reuse"
  let bknumlist             = ["0p","1","1p","1x","2","2x","3","3p","3x","4","4x","5","5x","5p","6","6x","6p","7","7x","8","8x","9","9x"]
  let ibk                   = index(bknumlist,bknum)
"  call Decho("booksearch: current bknum#".bknum." (type ".type(bknum).")   topic<".topic."> ibk=".ibk. "(reuse)")
  if ibk != -1
   let s:booksearching= winnr()
   while retval < 0
    let ibk  += a:direction
	if ibk < 0 || len(bknumlist) <= ibk
	 break
	endif
    let bknum = bknumlist[ibk]
"    call Decho("‣booksearch: trying bknum#".bknum."   topic<".topic.">")
    let retval = manpageview#ManPageView(bknum,topic)
   endwhile
   unlet s:booksearching
  endif
  unlet s:mpv_booksearch
  let &lz= keeplz
  if retval < 0
   call manpageview#ManPageView(curbknum,curtopic)
   echohl WarningMsg
   echomsg "***warning*** unable to find man page on <".topic."> with a ".((a:direction > 0)? "larger" : "smaller")." book number"
   echohl None
   sleep 2
  endif
  let g:manpageview_winopen = keep_mpv_winopen
"  call Dret("manpageview#BookSearch")
endfun

" =====================================================================
"  Restore: {{{1
let &cpo= s:keepcpo
unlet s:keepcpo

" =====================================================================
" Modeline: {{{1
" vim: ts=4 fdm=marker
syntax/man.vim	[[[1
106
" Vim syntax file
"  Language:	Manpageview
"  Maintainer:	Charles E. Campbell, Jr.
"  Last Change:	Apr 05, 2013
"  Version:    	7	ASTRO-ONLY
"
"  History:
"    2: * Now has conceal support
"       * complete substitute for distributed <man.vim>
" ---------------------------------------------------------------------
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif
if !has("conceal")
 " hide control characters, especially backspaces
 if version >= 600
  run! syntax/ctrlh.vim
 else
  so <sfile>:p:h/ctrlh.vim
 endif
endif

syn case ignore
" following four lines taken from Vim's <man.vim>:
syn match  manReference		"\f\+([1-9]\l\=)"
syn match  manSectionTitle	'^\u\{2,}\(\s\+\u\{2,}\)*'
syn match  manSubSectionTitle	'^\s+\zs\u\{2,}\(\s\+\u\{2,}\)*'
syn match  manTitle		"^\f\+([0-9]\+\a\=).*"
syn match  manSectionHeading	"^\(\u[a-z]* \)\+$"
syn match  manOptionDesc	"^\s*\zs[+-]\{1,2}\w\S*"

syn match  manSectionHeading	"^\s\+\d\+\.[0-9.]*\s\+\u.*$"		contains=manSectionNumber
syn match  manSectionNumber	"^\s\+\d\+\.\d*"			contained
syn region manDQString		start='[^a-zA-Z"]"[^", )]'lc=1		end='"'		end='^$' contains=manSQString
syn region manSQString		start="[ \t]'[^', )]"lc=1		end="'"		end='^$'
syn region manSQString		start="^'[^', )]"lc=1			end="'"		end='^$'
syn region manBQString		start="[^a-zA-Z`]`[^`, )]"lc=1		end="[`']"	end='^$'
syn region manBQString		start="^`[^`, )]"			end="[`']"	end='^$'
syn region manBQSQString	start="``[^),']"			end="[`']['`]"	end='^$'
syn match  manBulletZone	"^\s\+o\s"				transparent contains=manBullet
syn case match

syn keyword manBullet		o					contained
syn match   manBullet		"\[+*]"					contained
syn match   manSubSectionStart	"^\*"					skipwhite nextgroup=manSubSection
syn match   manSubSection	".*$"					contained
syn match   manOptionWord	"\s[+-]\a\+\>"

if has("conceal")
 setlocal cole=3
 syn match manSubTitle		/\(.\b.\)\+/	contains=manSubTitleHide
 syn match manUnderline		/\(_\b.\)\+/	contains=manSubTitleHide
 syn match manSubTitleHide	/.\b/		conceal contained
endif

" my RH8 linux's man page puts some pretty oddball characters into its
" manpages...
silent! %s/’/'/ge
silent! %s/−/-/ge
silent! %s/‐$/-/e
silent! %s/‘/`/ge
silent! %s/‐/-/ge
norm! 1G

set ts=8

com! -nargs=+ HiLink hi def link <args>

HiLink manTitle		Title
"  HiLink manSubTitle		Statement
HiLink manUnderline		Type
HiLink manSectionHeading	Statement
HiLink manOptionDesc		Constant

HiLink manReference		PreProc
HiLink manSectionTitle	Function
HiLink manSectionNumber	Number
HiLink manDQString		String
HiLink manSQString		String
HiLink manBQString		String
HiLink manBQSQString		String
HiLink manBullet		Special
if has("win32") || has("win95") || has("win64") || has("win16")
 if &shell == "bash"
  hi manSubSectionStart	term=NONE      cterm=NONE      gui=NONE      ctermfg=black ctermbg=black guifg=navyblue guibg=navyblue
  hi manSubSection		term=underline cterm=underline gui=underline ctermfg=green guifg=green
  hi manSubTitle		term=NONE      cterm=NONE      gui=NONE      ctermfg=cyan  ctermbg=blue  guifg=cyan     guibg=blue
 else
  hi manSubSectionStart	term=NONE      cterm=NONE      gui=NONE      ctermfg=black ctermbg=black guifg=black    guibg=black
  hi manSubSection		term=underline cterm=underline gui=underline ctermfg=green guifg=green
  hi manSubTitle		term=NONE      cterm=NONE      gui=NONE      ctermfg=cyan  ctermbg=blue  guifg=cyan     guibg=blue
 endif
else
 hi manSubSectionStart	term=NONE      cterm=NONE      gui=NONE      ctermfg=black ctermbg=black guifg=navyblue guibg=navyblue
 hi manSubSection		term=underline cterm=underline gui=underline ctermfg=green guifg=green
 hi manSubTitle		term=NONE      cterm=NONE      gui=NONE      ctermfg=cyan  ctermbg=blue  guifg=cyan     guibg=blue
endif
"  hi link manSubSectionTitle	manSubTitle

delcommand HiLink

let b:current_syntax = "man"

" vim:ts=8
syntax/mangl.vim	[[[1
34
" mangl.vim : a vim syntax highlighting file for man pages on GL
"   Author: Charles E. Campbell, Jr.
"   Date:   Nov 23, 2010
"   Version: 1a	NOT RELEASED
" ---------------------------------------------------------------------
syn clear
let b:current_syntax = "mangl"

syn keyword manglGLType		GLbyte GLenum GLshort GLint GLdouble GLubyte GLuint GLfloat GLushort
syn keyword manglCType		const void char short int long double unsigned
syn match	manglCType		'\s\*\s'
syn match	manglGLKeyword	'\<[A-Z_]\{2,}\>'
syn keyword	manglNormal		GL

syn match	manglTitle		'^\s*\%(Name\|C Specification\|Parameters\|Description\|Notes\|Associated Gets\|See Also\|Copyright\|Errors\|References\)\s*$'
syn match	manglNmbr		'\<\d\+\%(\.\d*\)\=\>'
syn match	manglDelim		'[()]'

hi def link manglGLType		Type
hi def link manglCType		Type
hi def link manglTitle		Title
hi def link manglNmbr		Number
hi def link manglDelim		Delimiter
hi def link manglGLKeyword	Keyword

" cleanup
if !exists("g:mangl_nocleanup")
 setlocal mod ma noro
 %s/ ? /   /ge
 %s/\[\d\+]//ge
 %s/\(\d\+\)\s\+\*\s\+/\1*/ge
 %s@\<N\> \(\d\)@N/\1@ge
 setlocal nomod noma ro
endif
syntax/mankey.vim	[[[1
39
" Vim syntax file
"  Language:	Man keywords page
"  Maintainer:	Charles E. Campbell, Jr.
"  Last Change:	Aug 12, 2008
"  Version:    	2
"    (used by plugin/manpageview.vim)
"
"  History:
"    2: hi default link -> hi default link
"    1:	The Beginning
" ---------------------------------------------------------------------
"  Initialization:
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif
syn clear

" ---------------------------------------------------------------------
"  Highlighting Groups: matches, ranges, and keywords
syn match mankeyTopic	'^\S\+'		skipwhite nextgroup=mankeyType,mankeyBook
syn match mankeyType	'\[\S\+\]'	contained skipwhite nextgroup=mankeySep,mankeyBook contains=mankeyTypeDelim
syn match mankeyTypeDelim	'[[\]]'	contained
syn region mankeyBook	matchgroup=Delimiter start='(' end=')'	contained skipwhite nextgroup=mankeySep
syn match mankeySep		'\s\+-\s\+'	

" ---------------------------------------------------------------------
"  Highlighting Colorizing Links:
command! -nargs=+ HiLink hi default link <args>

HiLink mankeyTopic		Statement
HiLink mankeyType		Type
HiLink mankeyBook		Special
HiLink mankeyTypeDelim	Delimiter
HiLink mankeySep		Delimiter

delc HiLink
let b:current_syntax = "mankey"
syntax/info.vim	[[[1
32
" Info.vim : syntax highlighting for info
"  Language:	info
"  Maintainer:	Charles E. Campbell, Jr.
"  Last Change:	Aug 09, 2007
"  Version:		2b	ASTRO-ONLY
" syntax highlighting based on Slavik Gorbanyov's work
let g:loaded_syntax_info= "v1"

syn clear
syn case match
syn match  infoMenuTitle	/^\* Menu:/hs=s+2
syn match  infoTitle		/^[A-Z][0-9A-Za-z `',/&]\{,43}\([a-z']\|[A-Z]\{2}\)$/
syn match  infoTitle		/^[-=*]\{,45}$/
syn match  infoString		/`[^`]*'/
syn region infoLink			start=/\*[Nn]ote/ end=/::/
syn match  infoLink			/\*[Nn]ote \([^():]*\)\(::\|$\)/
syn match  infoLink			/^\* \([^:]*\)::/hs=s+2
syn match  infoLink			/^\* [^:]*: \(([^)]*)\)/hs=s+2
syn match  infoLink			/^\* [^:]*:\s\+[^(]/hs=s+2,he=e-2
syn region infoHeader		start=/^File:/ end="$" contains=infoHeaderLabel
syn match  infoHeaderLabel	/\<\%(File\|Node\|Next\|Prev\|Up\):\s/ contained

if !exists("g:did_info_syntax_inits")
  let g:did_info_syntax_inits = 1
  hi def link infoMenuTitle		Title
  hi def link infoTitle			Comment
  hi def link infoLink			Directory
  hi def link infoString		String
  hi def link infoHeader		infoLink
  hi def link infoHeaderLabel	Statement
endif
" vim: ts=4
syntax/manphp.vim	[[[1
74
" Vim syntax file
"  Language:	Man page syntax for php
"  Maintainer:	Charles E. Campbell, Jr.
"  Last Change:	Aug 12, 2008
"  Version:    	3
" ---------------------------------------------------------------------
syn clear
let b:current_syntax = "manphp"

syn keyword manphpKey			Description Returns
syn match   manphpFunction			"\<\S\+\ze\s*--"	skipwhite nextgroup=manphpDelimiter
syn match   manphpSkip				"^\s\+\*\s*\S\+\s*"
syn match   manphpSeeAlso			"\<See also\>"		skipwhite skipnl nextgroup=manphpSeeAlsoList
syn match   manphpSeeAlsoSep	contained	",\%( and\)\="		skipwhite skipnl nextgroup=manphpSeeAlsoList,manphpSeeAlsoSkip
syn match   manphpSeeAlsoList	contained	"\s*\zs[^,]\+\ze\%(,\%( and \)\=\)"	skipwhite skipnl nextgroup=manphpSeeAlsoSep
syn match   manphpSeeAlsoList	contained  	"\s*\zs[^,.]\+\ze\."
syn match   manphpSeeAlsoSkip	contained	"^\s\+\*\s*\S\+\s*"     skipwhite skipnl nextgroup=manphpSeeAlsoList
syn match   manphpDelimiter	contained	"\s\zs--\ze\s"		skipwhite nextgroup=manphpDesc
syn match   manphpDesc		contained	".*$"
syn match   manphpUserNote			"User Contributed Notes"
syn match   manphpEditor			"\[Editor's Note:.\{-}]"
syn match   manphpUser				"\a\+ at \a\+ dot .*$"
syn match   manphpFuncList			"PHP Function List"

hi default link manphpKey		Title
hi default link manphpFunction		Function
hi default link manphpDelimiter		Delimiter
hi default link manphpDesc		manphpFunction
hi default link manphpSeeAlso		Title
hi default link manphpSeeAlsoList	PreProc
hi default link manphpUserNote		Title
hi default link manphpEditor		Special
hi default link manphpUser		Search
hi default link manphpSeeAlsoSkip	Ignore
hi default link manphpSkip		Ignore
hi default link manphpFuncList		Title

" cleanup
if !exists("g:manphp_nocleanup")
 setlocal mod ma noro
 %s/\[\d\+]//ge
 %s/_\{2,}/__/ge
 %s/\<\%(add a note\)\+\>//ge
 1
 if search('(PHP','W')
  norm! k
  1,.d
 endif
 if search('\<References\>','W')
  /\<References\>/,$d
 endif
 if search('\<Description\>','w')
  exe '%s/^.*\%'.virtcol(".").'v//e'
  g/^\s\s\*\s/s/^.*$//
 endif
 %s/^\s*\(User Contributed Notes\)/\1/e
 %s/^\s*\(Returns\|See also\)\>/\1/e
 $
 if search('\S','bW')
  norm! j
  if line(".") != line("$")
   silent! .,$d
  endif
 endif
 if search('PHP Function List')
  if line(".") != 1
   1,.-1d
  endif
 endif
 setlocal nomod noma ro
endif

" ---------------------------------------------------------------------
" vim:ts=8
doc/manpageview.txt	[[[1
563
*manpageview.txt*	Man Page Viewer			Apr 05, 2013

Author:  Charles E. Campbell  <NdrchipO@ScampbellPfamily.AbizM>
	 (remove NOSPAM from Campbell's email first)
Copyright: (c) 2004-2013 by Charles E. Campbell		*manpageview-copyright*
	 The VIM LICENSE applies to ManPageView.vim and ManPageView.txt
	 (see |copyright|) except use "ManPageView" instead of "Vim"
	 no warranty, express or implied.  use at-your-own-risk.

==============================================================================
1. Contents			*manpageview* *manpageview-contents* {{{1

	1. Contents.................................: |manpageview-contents|
	2. ManPageView Usage........................: |manpageview-usage|
	     General Format.........................: |manpageview-format|
	     Man....................................: |manpageview-man|
	     Opening Style..........................: |manpageview-open|
	     K Map..................................: |manpageview-K|
	     Perl...................................: |manpageview-perl|
	     Info...................................: |manpageview-info|
	     Php....................................: |manpageview-php|
	     Extending ManPageView..................: |manpageview-extend|
	     Manpageview Suggestion.................: |manpageview-suggest|
	     From the Shell.........................: |manpageview-shell|
	     Manpageview History....................: |manpageview-history|
	     Manpageview Search.....................: |manpageview-search|
	3. ManPageView Options......................: |manpageview-options|
	4. ManPageView Update History...............: |manpageview-updates|

==============================================================================
2. ManPageView Usage				*manpageview-usage* {{{1

        GENERAL FORMAT				*manpageview-format* {{{2

		(command) :[count][HORV]Man [topic] [booknumber]
		(map)     [count]K

	MAN						*manpageview-man* {{{2
>
	:[count]Man topic
	:Man topic booknumber
	:Man booknumber topic
	:Man topic(booknumber)
	:Man      -- will restore position prior to use of :Man
	             (only for g:manpageview_winopen == "only")
<
	Put cursor on topic, press "K" while in normal mode.
	(This works if (a) you've not mapped some other key
	to <Plug>ManPageView, and (b) if |'keywordprg'| is "man",
	which it is by default)

	If a count is present (ie. 7K), the count will be used
	as the booknumber.

	If your "man" command requires options, you may specify them
	with the g:manpageview_options variable in your <.vimrc>.


	OPENING STYLE				*manpageview-open* {{{2

	In addition, one may specify open help and specify an
	opening style (see g:manpageview_winopen below): >

		:[count]HMan topic     -- g:manpageview_winopen= "hsplit"
		:[count]HEMan topic    -- g:manpageview_winopen= "hsplit="
		:[count]VMan topic     -- g:manpageview_winopen= "vsplit"
		:[count]VEMan topic    -- g:manpageview_winopen= "vsplit="
		:[count]OMan topic     -- g:manpageview_winopen= "osplit"
		:[count]RMan topic     -- g:manpageview_winopen= "reuse"
		:[count]TMan topic     -- g:manpageview_winopen= "tab"
<
	To support perl, manpageview now can switch to using perldoc
	instead of man.  In fact, the facility is generalized to
	allow multiple help viewing systems.

	INFO					*manpageview-info* {{{2

	Info pages are supported by appending a ".i" suffix: >
		:Man info.i
<	A number of maps are provided: >
		MAP	EFFECT
		] n	go to next node
		[ p	go to previous node
		d       go to the top-level directory
		u	go to up node
		t	go to top node
		H	give help
		i	ask for "index" help
<
	The "index" help isn't currently using index information; instead,
	its doing some searching in the various info files.  The "," and ";"
	operators are provided to go to the next and previous matches,
	respectively.

	K MAP					*manpageview-K* {{{2
>
		[count]K
<
	ManPageView also supports the use of "K", as a map, to
	invoke ManPageView.  The topic is taken from the word
	currently under the cursor.  If a [count] is present, it
	will be used as the booknumber.

	In the case of an url (http://...), the K map will invoke
	the program given in |g:manpageview_K_http|  on the url in
	an attempt to show the site in a new tab.


	MAN					*manpageview-.man*

	When in a file supporting special manpage handling such
	as perl or python files, but one wants a regular manpage
	anyway, use the ".man" extension. Example: >

		:Man syslog.man
<
	PERL		*manpageview-perl* 	 *manpageview-.pl* {{{2

	For perl, the following command, >
		:Man sprintf.pl
<	will bring up the perldoc version of sprintf.  The perl
	support includes a "path" of options to use with perldoc: >
		g:manpageview_options_pl= ";-f;-q"
<	Thus just the one suffix (.pl) with manpageview handles
	embedded perl documentation, perl builtin functions, and
	perl FAQ keywords.

	If the filetype is "perl", which is determined by vim
	for syntax highlighting, the ".pl" suffix may be dropped.
	For example, when editing a "abc.pl" file, >
		:Man sprintf
<	will return the perl help for sprintf.

	PHP		*manpageview-php*	 *manpageview-.php* {{{2

	For php help, Manpageview uses links to get help from
	http://www.php.net (by default).  The filetype as determined
	for syntax highlighting is used to signal manpageview to use
	php help.  As an example, >
		:Man bzopen.php
<	will get help for php's bzopen command.  When one is editing
	a php file, then man will default to getting help for php
	(ie. when the filetype is php, :Man bzopen will get the help
	for php's bzopen).

	Manpageview uses "links -dump http://www.php.net/TOPIC" by
	default; hence, to obtain help for php you need to have a
	copy of the links WWW browser.  The homepage for Elinks is
	http://elinks.cz/.

	If you want to override just the url used to obtain php help: >
		let g:manpageview_php_url="..."
<

	PYTHON		*manpageview-python*	*manpageview-.py* {{{2

	For python help, Manpageview depends upon pydoc.  As an
	example, try >
		:Man pprint.py
<

	EXTENDING MANPAGEVIEW			*manpageview-extend* {{{2

	To extend manpageview to handle other documentation systems,
	manpageview uses some special variables with a common extension: >

		g:manpageview_pgm_{ext}
		g:manpageview_options_{ext}
		g:manpageview_sfx_{ext}
<
	For perl, the {ext} is ".pl", and the variables are set to: >

	     let g:manpageview_pgm_pl     = "perldoc"
	     let g:manpageview_options_pl = "-f"
<
	For info, that {ext} is ".i", and the extension variables are
	set to: >

	     let g:manpageview_pgm_i     = "info"
	     let g:manpageview_options_i = "--output=-"
	     let g:manpageview_syntax_i  = "info"
	     let g:manpageview_K_i       = "<sid>ManPageInfo(0)"
	     let g:manpageview_init_i    = "call ManPageInfoInit()"
<
	The help on |manpageview_extend| covers these variables in more
	detail.

	MULTIPLE MAN PAGES		*manpageview-pageup* *manpageview-pagedown*

        With >
		man -a topic
<	one may get multiple man pages in a single buffer.  Manpageview
	provides two maps to facilitate moving amongst these pages: >

		PageUp  : move to preceding  manpage
		PageDown: move to succeeding manpage
<
	MANPAGEVIEW SUGGESTION		*manpageview-suggest*

	As an example, for C: put in .vim/ftplugin/c/c.vim: >
		nno <buffer> K  :<c-u>exe v:count."Man ".expand("<cword>")<cr>
<	This map allows K to immediately use manpageview with functions in a
	C program.  One may make similar maps for other languages, of course,
	or simply put the map in one's <.vimrc>.

	FROM THE SHELL				*manpageview-shell*

	There are a lot of ways to get manpageview to work from the shell.
	I typically use: >

		function man
		{
		gvim -c "Man $*" -c "silent! only"
		}
<
	With this function (and with Korn shell or bash), one may use "man"
	from the shell's command line and have it bring up gvim with
	manpageview instead.


				*manpageview-history* *mpv-history*
	MANPAGEVIEW HISTORY     		*:Manprv* *:Mannxt*

	Manpageview keeps track of successful (ie. not empty) pages; you may
	use >
		:[count]Mannxt
		:[count]Manprv

<	to go forwards and backwards in the history.  In addition, while in
	a manpageview help buffer, one also has two maps available: >

		<s-up>
		<s-down>

<	which you may likewise use to go forwards and backwards in the
	history, respectively.  One may precede these two maps with a count,
	too.


	MANPAGEVIEW SEARCH		*manpageview-search*  *mpv-search*

	Sometimes the man page one gets isn't in the right book.  Use
	the following two maps to search for manpages with the same topic: >

		<s-left>	in smaller book numbers
		<s-right>	in larger book numbers

<	These maps are only available when in a manpageview generated buffer.


==============================================================================
3. ManPageView Options				*manpageview-options* {{{1

						*g:manpageview_iconv*
	g:manpageview_iconv   : some systems seem to include unwanted
		    characters. The iconv program can be used to filter out
		    such characters; by default, manpageview will use >
			iconv -c
<		    You may avoid manpageview's use of iconv by putting: >
			let g:manpageview_iconv= ""
<		    in your <.vimrc> file; you may also specify any other
		    filter you wish with this variable.  Also, if iconv
		    happens to not be |executable()|, then no filtering
		    will be done.  (Thanks to Matthew Wozniski).

		    As an example, Hong Xu reports that he has found that >
		      let g:manpageview_iconv= "iconv -c UTF-8 -t UTF-8"
<		    useful when using NetBSD.

	g:manpageview_K_http :			*g:manpageview_K_http*
		    This option is set to one of the following strings: >
		    	lynx -dump
			links -dump
			elinks -dump
			wget -O -
			curl
<		    depending on which of the associated programs is
		    executable, by default.  You may override this
		    selection by setting g:manpageview_K_http in his/her
		    .vimrc .  See |manpageview-K| for more.

						*g:manpageview_multimanpage*
	g:manpageview_multimanpage (=1 by default)
		    This option means that the PageUp and PageDown keys
		    will be mapped to move to the next and previous manpage
		    in a multi-man-page buffer.  Such buffers result with
		    the "man -a" option.  As an example: >
		    	:Man -a printf
<
						*g:manpageview_options*
	g:manpageview_options : extra options that will be passed on when
	                        invoking the man command
	  examples: >
	            let g:manpageview_options= "-P 'cat -'"
	            let g:manpageview_options= "-c"
	            let g:manpageview_options= "-Tascii"
<
						*g:manpageview_pgm*
	g:manpageview_pgm : by default, its "man", but it may be changed
		     by the user.  This program is what is called to actually
		     extract the manpage.

						*g:manpageview_winopen*
	g:manpageview_winopen : may take on one of seven values:

	   *OMan*  "only"	man page will become sole window.
				Side effect: All windows' contents will be saved first!
				(windo w) Use :q to terminate the manpage and restore the
				window setup.  Note that mksession is used for this
				option, hence the +mksession configure-option is required.
	   *HMan*  "hsplit"	man page will appear in a horizontally          split window (default)
	   *VMan*  "vsplit"	man page will appear in a vertically            split window
	   *HEMan* "hsplit="	man page will appear in a horizontally & evenly split window
	   *VEMan* "vsplit="	man page will appear in a vertically   & evenly split window
	   *RMan*  "reuse"	man page will re-use current window.  Use <ctrl-o> to return.
				(for the reuse option, thanks go to Alan Schmitt)
	   *TMan*  "tab"	man page will be on a separate tab


				*g:manpageview_server* *g:manpgeview_user*

	g:manpageview_server : for WinNT; uses rsh to read manpage remotely
	g:manpageview_user   : use given server (host) and username
	  examples:
	            let g:manpageview_server= "somehostname"
	            let g:manpageview_user  = "username"


			    *g:manpageview_init_EXT*    *g:manpageview_K_EXT*
			    *g:manpageview_options_EXT* *g:manpageview_pfx_EXT*
			    *g:manpageview_pgm_EXT*     *g:manpageview_sfx_EXT*
			    *g:manpageview_syntax_EXT*
	g:manpageview_init_{ext}:			*manpageview_extend*
	g:manpageview_K_{ext}:
	g:manpageview_options_{ext}:
	g:manpageview_pfx_{ext}:
	g:manpageview_pgm_{ext}:
	g:manpageview_sfx_{ext}:
	g:manpageview_syntax_{ext}:

		With these options, one may specify an extension on a topic
		and have a special program and customized options for that
		program used instead of man itself.  As an example, consider
		perl: >

			let g:manpageview_pgm_pl = "perldoc"
			let g:manpageview_options= "-f"
<
		The g:manpageview_init_{ext} specifies a function to be called
		for initialization.  The info handler, for example, uses this
		function to specify buffer-local maps.

		The g:manpageview_K_{ext} specifies a function to be invoked
		when the "K" key is tapped.  By default, it calls
		s:ManPageView().

		The g:manpageview_options_{ext} specifies what options are
		needed.

		The g:manpageview_pfx_{ext} specifies a prefix to prepend to
		the nominal manpage name.

		The g:manpageview_pgm_{ext} specifies which program to run for
		help.

		The g:manpageview_sfx_{ext} specifies a suffix to append to
		the nominal manpage name.  Without this last option, the
		provided suffix (ie. Man sprintf.pl 's  ".pl") will be elided.
		With this option, the g:manpageview_sfx_{ext} will be
		appended.

		The g:manpageview_syntax_{ext} specifies a highlighting file
		to be used for this particular extension type.

	You may map some key other than "K" to invoke ManPageView; as an
	example: >
		nmap V <Plug>ManPageView
<	Put this in your <.vimrc>.


==============================================================================
4. ManPageView History				*manpageview-updates* {{{1

	Thanks go to the various people who have contributed changes,
	pointed out problems, and made suggestions!

	v25:	Apr 03, 2013	* (Gary Johnson) suggested changing some of
				  the default book numbers to zero for more
				  general searching.
		Apr 04, 2013	* eliminated some "noise" while searching
				  for other books containing the topic
				  (see |mpv-search|)
				* search now uses an internal |List|, and so
				  it also searches manpage books such as 3p,
				  5x, etc.
		Apr 05, 2013	* found why manpageview's |mpv-search| was
				  noisy (had to do with |g:manpageview_iconv|).
				  Fixed.
	v24:	Jan 03, 2011	* some extra protection against trying to use
				  a program that is not executable
		Mar 30, 2012	* TMan command included
		May 25, 2012	* When in a specially supported filetype, such
				  as perl, allow ".man" as a topic extension to
				  get regular manpage support.  (ex. :Man paps.man)
		Aug 07, 2012	* (Gary Johnson) the K map wasn't working correctly
				  inside C functions.
		Jan 17, 2013	* (Zilvinas Valinskas) provided a patch to
				  make use of $MANWIDTH.
		Jan 30, 2013	* worked on :RMan to get it to work right with
				  vim and tex files
		Feb 07, 2013	* added history
				* added -k based keyword search support
		Feb 08, 2013	* (Michael Henry) provided a patch fixing the
				  PageUp/PageDown map directions.  He also
				  pointed out that the K map didn't work on
				  some info pages properly.  Fixed.
	v23:	May 18, 2009	* on the third attempt to get a manpage, if
				  the user provided no explicit
				  |g:manpageview_iconv| setting, then the
				  an attempt is made with iconv off.
				* Fixed K mapping for php, tex, etc.
				* (in progress) KMan [ext] to set default
				  extension for the K map
		Oct 21, 2010	* added python help via pydoc (suffix: .py)
		Oct 25, 2010	* Version 23 released
	v22:	Nov 10, 2008	* if g:manpageview_K_{ext} (ext is some
				  extension) exists, previously that would
				  be enough to institute a K map.  Now, if
				  that string is "", then the K map will not
				  be generated.
		Nov 17, 2008	* handles non-existing manpage requests better
	v21:	Sep 11, 2008	* when at a top node with info help, the up
				  directory shows as "(dir)".  A "u" issued a
				  warning and closes the window.  It now issues
				  a warning but leaves the window unchanged.
				* improved shellescape() use
				* new option: g:manpageview_multimanpage
		Sep 27, 2008	* The K map now uses <cword> expansion except when
				  used inside a manpage (where it uses <cWORD>).
	v19:	Jun 06, 2008	* uses the shellescape() function for better
				  security.  Thus vim 7.1 is required.
				* when shellescape() isn't available, manpageview
				  will only issue a warning message when invoked
				  instead of every time vim is invoked.
				* syntax/manphp.vim was using "set" instead of
				  "setlocal" and so new buffers were inadvertently
				  being prevented from being modifiable.
		Aug 05, 2008	* fixed a problem with using K multiple times with
				  php files
	v18:	Jun 06, 2008	* <PageUp> and <PageDown> support added to jump
				  between multiple man pages loaded into one buffer
				  such as may occur with :Man -a printf
				* links -dump used instead of links for php
	v17:	Apr 18, 2007	* changed the topic cleanup to use 'g' instead
				  of '' in the substitute().
				* Fixed bug with info pages - wasn't able to
				  use the > and < maps to go to pages named
				  with spaces.
				* Included the g:manpageview_iconv option
		Sep 07, 2007	* viewing window now is read-only and swapfile
				  is turned off
		Sep 07, 2007	* The "::" in some help pages (ex. File::stat)
				  was being parsed out, leaving only the left
				  hand side word.  Manpageview now accepts them.
		Nov 12, 2007	* At the request of F. Mehner, with
				  g:manpageview_winopen is "reuse", manpageview
				  will re-use any man-page windows that are still
				  open.
				* (F.Mehner) in "reuse" mode, a K on a blank
				  character terminated vim.  Fixed!
		May 09, 2008	* Added <PageUp> and <PageDown> maps
	v16:	Jun 28, 2006	* bypasses sxq with '"' for windows internally
		Sep 26, 2006	* implemented <count>K to look up a topic
				  under the cursor but in the <count>-th book
		Nov 21, 2006	* removed s:mank related code; man -k being
				  handled without it.
		Dec 04, 2006	* added fdc=0 to manpageview settings bypass
		Feb 21, 2007	* removed modifications to isk; instead,
				  manpageview attempts to fix the topic and
				  uses expand("<cWORD>") instead:w
	v15:	Jan 23, 2006	* works around nomagic option
				* works around cwh=1 to avoid Hit-Enter prompts
		Feb 13, 2006	* the test for keywordprg was for "man"; now its
				  for a regular expression "^man\>" (so its
				  immune to the use of options)
		Apr 11, 2006	* HMan, OMan, VMan, Rman commands implemented
		Jun 27, 2006	* escaped any spaces coming from tempname()
	v14:	Nov 23, 2005	* "only" was occasionally issuing an "Already one
				  window" message, which is now prevented
		Nov 29, 2005	* Aaron Griffin found that setting gdefault
				  gave manpageview problems with ctrl-hs.  Fixed.
		Dec 16, 2005	* Suresh Govindachar asked about letting
				  manpageview also handle perldoc -q manpages.
				  IMHO this was getting cumbersome, so I extended
				  opt to allow a semi-colon separated "path" of
				  up to three options to try.
		Dec 20, 2005	* In consultation with Gareth Oakes, manpageview
				  needed some quoting and backslash-fixes to work
				  properly with windows and perldoc.
		Dec 29, 2005	* added links-based help for php functions
	v13:	Jul 19, 2005	* included niebie's changes to manpageview -
				  <bs>, <del> to scroll one page up,
				  <tab> to go to the next hyperlink
				  d     to go to the top-level directory
				  and some bugfixes ([] to \[ \], and redirecting
				  stderr to /dev/null by default)
		Aug 17, 2005	* report option workaround
		Sep 26, 2005	* :Man -k  now uses "man -k" to generate a keyword
				  listing
				* included syntax/man.vim and syntax/mankey.vim
	v12:	Jul 11, 2005	* unmap K was causing "noise" when it was first
			   used.  Fixed.
	v11:			* K now <buffer>-mapped to call ManPageView()
	v10:			* support for perl/perldoc:
				  g:manpageview_{ pgm | options | sfx }_{ extension }
				* support for info: g:manpageview_{ K | pfx | syntax }
				* configuration option drilling -- if you're in a
				*.conf file, pressing "K" atop an option will go
				  to the associated help page and option, if there's
				  help for that configuration file
	v9:			* for vim versions >= 6.3, keepjumps is used to reduce the
				  impact on the jumplist
				* manpageview now turns off linewrap for the manpage, since
				  re-formatting doesn't seem to work usually.
				* apparently some systems resize the [g]vim display when
				  any filter is used, including manpageview's :r!... .
				  Setting g:manpageview_dispresize=1 will force retention
				  of display size.
				* before mapping K to use manpageview, a check that
				  keywordprg is "man" is also made. (tnx to Suresh Govindachar)
	v8:			* apparently bh=wipe is "new", so I've put a version
				  test around that setting to allow older vim's to avoid
				  an error message
				* manpageview now turns numbering off in the manpage buffer (nonu)
	v7:			* when a manpageview window is exit'd, it will be wiped out
				  so that it doesn't clutter the buffer list
				* when g:manpageview_winopen was "reuse", the manpage would
				  reuse the window, even when it wasn't a manpage window.
				  Manpageview will now use hsplit if the window was marked
				  "modified"; otherwise, the associated buffer will be marked
				  as "hidden" (so that its still available via the buffer list)
	v6:			* Erik Remmelzwal provided a fix to the g:manpageview_server
				  support for NT
				* implemented Erik's suggestion to re-use manpage windows
				* Nathan Huizinga pointed out, <cWORD> was picking up too much for
				  the K map. <cword> is now used
				* Denilson F de Sa suggested that the man-page window be set as
				  readonly and nonmodifiable
	v5:			* includes g:manpageview_winmethod option (only, hsplit, vsplit)
	v4:			* Erik Remmelzwaal suggested including, for the benefit of NT users,
				  a command to use rsh to read the manpage remotely.  Set
				  g:manpageview_server to hostname  (in your <.vimrc>)
				  g:manpageview_user   to username
	v3:			* ignores (...) if it contains commas or double quotes.  elides
				  any commas, colons, and semi-colons at end
				* g:manpageview_options supported
	v2:			* saves current session prior to invoking man pages :Man  will
				  restore session.  Requires +mksession for this new command to
				  work.
	v1: the epoch

==============================================================================
vim:tw=78:ts=8:ft=help:fdm=marker
plugin/cecutil.vim	[[[1
536
" cecutil.vim : save/restore window position
"               save/restore mark position
"               save/restore selected user maps
"  Author:	Charles E. Campbell
"  Version:	18h	ASTRO-ONLY
"  Date:	Oct 16, 2012
"
"  Saving Restoring Destroying Marks: {{{1
"       call SaveMark(markname)       let savemark= SaveMark(markname)
"       call RestoreMark(markname)    call RestoreMark(savemark)
"       call DestroyMark(markname)
"       commands: SM RM DM
"
"  Saving Restoring Destroying Window Position: {{{1
"       call SaveWinPosn()        let winposn= SaveWinPosn()
"       call RestoreWinPosn()     call RestoreWinPosn(winposn)
"		\swp : save current window/buffer's position
"		\rwp : restore current window/buffer's previous position
"       commands: SWP RWP
"
"  Saving And Restoring User Maps: {{{1
"       call SaveUserMaps(mapmode,maplead,mapchx,suffix)
"       call RestoreUserMaps(suffix)
"
" GetLatestVimScripts: 1066 1 :AutoInstall: cecutil.vim
"
" You believe that God is one. You do well. The demons also {{{1
" believe, and shudder. But do you want to know, vain man, that
" faith apart from works is dead?  (James 2:19,20 WEB)
"redraw!|call inputsave()|call input("Press <cr> to continue")|call inputrestore()

" ---------------------------------------------------------------------
" Load Once: {{{1
if &cp || exists("g:loaded_cecutil")
 finish
endif
let g:loaded_cecutil = "v18h"
let s:keepcpo        = &cpo
set cpo&vim
"DechoRemOn

" =======================
"  Public Interface: {{{1
" =======================

" ---------------------------------------------------------------------
"  Map Interface: {{{2
if !hasmapto('<Plug>SaveWinPosn')
 map <unique> <Leader>swp <Plug>SaveWinPosn
endif
if !hasmapto('<Plug>RestoreWinPosn')
 map <unique> <Leader>rwp <Plug>RestoreWinPosn
endif
nmap <silent> <Plug>SaveWinPosn		:call SaveWinPosn()<CR>
nmap <silent> <Plug>RestoreWinPosn	:call RestoreWinPosn()<CR>

" ---------------------------------------------------------------------
" Command Interface: {{{2
com! -bar -nargs=0 SWP	call SaveWinPosn()
com! -bar -nargs=? RWP	call RestoreWinPosn(<args>)
com! -bar -nargs=1 SM	call SaveMark(<q-args>)
com! -bar -nargs=1 RM	call RestoreMark(<q-args>)
com! -bar -nargs=1 DM	call DestroyMark(<q-args>)

com! -bar -nargs=1 WLR	call s:WinLineRestore(<q-args>)

if v:version < 630
 let s:modifier= "sil! "
else
 let s:modifier= "sil! keepj "
endif

" ===============
" Functions: {{{1
" ===============

" ---------------------------------------------------------------------
" SaveWinPosn: {{{2
"    let winposn= SaveWinPosn()  will save window position in winposn variable
"    call SaveWinPosn()          will save window position in b:cecutil_winposn{b:cecutil_iwinposn}
"    let winposn= SaveWinPosn(0) will *only* save window position in winposn variable (no stacking done)
fun! SaveWinPosn(...)
"  echomsg "Decho: SaveWinPosn() a:0=".a:0
  if line("$") == 1 && getline(1) == ""
"   echomsg "Decho: SaveWinPosn : empty buffer"
   return ""
  endif
  let so_keep   = &l:so
  let siso_keep = &siso
  let ss_keep   = &l:ss
  setlocal so=0 siso=0 ss=0

  let swline = line(".")                           " save-window line in file
  let swcol  = col(".")                            " save-window column in file
  if swcol >= col("$")
   let swcol= swcol + virtcol(".") - virtcol("$")  " adjust for virtual edit (cursor past end-of-line)
  endif
  let swwline   = winline() - 1                    " save-window window line
  let swwcol    = virtcol(".") - wincol()          " save-window window column
  let savedposn = ""
"  echomsg "Decho: sw[".swline.",".swcol."] sww[".swwline.",".swwcol."]"
  let savedposn = "call GoWinbufnr(".winbufnr(0).")"
  let savedposn = savedposn."|".s:modifier.swline
  let savedposn = savedposn."|".s:modifier."norm! 0z\<cr>"
  if swwline > 0
   let savedposn= savedposn.":".s:modifier."call s:WinLineRestore(".(swwline+1).")\<cr>"
  endif
  if swwcol > 0
   let savedposn= savedposn.":".s:modifier."norm! 0".swwcol."zl\<cr>"
  endif
  let savedposn = savedposn.":".s:modifier."call cursor(".swline.",".swcol.")\<cr>"

  " save window position in
  " b:cecutil_winposn_{iwinposn} (stack)
  " only when SaveWinPosn() is used
  if a:0 == 0
   if !exists("b:cecutil_iwinposn")
	let b:cecutil_iwinposn= 1
   else
	let b:cecutil_iwinposn= b:cecutil_iwinposn + 1
   endif
"   echomsg "Decho: saving posn to SWP stack"
   let b:cecutil_winposn{b:cecutil_iwinposn}= savedposn
  endif

  let &l:so = so_keep
  let &siso = siso_keep
  let &l:ss = ss_keep

"  if exists("b:cecutil_iwinposn")                                                                  " Decho
"   echomsg "Decho: b:cecutil_winpos{".b:cecutil_iwinposn."}[".b:cecutil_winposn{b:cecutil_iwinposn}."]"
"  else                                                                                             " Decho
"   echomsg "Decho: b:cecutil_iwinposn doesn't exist"
"  endif                                                                                            " Decho
"  echomsg "Decho: SaveWinPosn [".savedposn."]"
  return savedposn
endfun

" ---------------------------------------------------------------------
" RestoreWinPosn: {{{2
"      call RestoreWinPosn()
"      call RestoreWinPosn(winposn)
fun! RestoreWinPosn(...)
"  echomsg "Decho: RestoreWinPosn() a:0=".a:0
"  echomsg "Decho: getline(1)<".getline(1).">"
"  echomsg "Decho: line(.)=".line(".")
  if line("$") == 1 && getline(1) == ""
"   echomsg "Decho: RestoreWinPosn : empty buffer"
   return ""
  endif
  let so_keep   = &l:so
  let siso_keep = &l:siso
  let ss_keep   = &l:ss
  setlocal so=0 siso=0 ss=0

  if a:0 == 0 || a:1 == ""
   " use saved window position in b:cecutil_winposn{b:cecutil_iwinposn} if it exists
   if exists("b:cecutil_iwinposn") && exists("b:cecutil_winposn{b:cecutil_iwinposn}")
"    echomsg "Decho: using stack b:cecutil_winposn{".b:cecutil_iwinposn."}<".b:cecutil_winposn{b:cecutil_iwinposn}.">"
	try
	 exe s:modifier.b:cecutil_winposn{b:cecutil_iwinposn}
	catch /^Vim\%((\a\+)\)\=:E749/
	 " ignore empty buffer error messages
	endtry
	" normally drop top-of-stack by one
	" but while new top-of-stack doesn't exist
	" drop top-of-stack index by one again
	if b:cecutil_iwinposn >= 1
	 unlet b:cecutil_winposn{b:cecutil_iwinposn}
	 let b:cecutil_iwinposn= b:cecutil_iwinposn - 1
	 while b:cecutil_iwinposn >= 1 && !exists("b:cecutil_winposn{b:cecutil_iwinposn}")
	  let b:cecutil_iwinposn= b:cecutil_iwinposn - 1
	 endwhile
	 if b:cecutil_iwinposn < 1
	  unlet b:cecutil_iwinposn
	 endif
	endif
   else
	echohl WarningMsg
	echomsg "***warning*** need to SaveWinPosn first!"
	echohl None
   endif

  else	 " handle input argument
"   echomsg "Decho: using input a:1<".a:1.">"
   " use window position passed to this function
   exe a:1
   " remove a:1 pattern from b:cecutil_winposn{b:cecutil_iwinposn} stack
   if exists("b:cecutil_iwinposn")
	let jwinposn= b:cecutil_iwinposn
	while jwinposn >= 1                     " search for a:1 in iwinposn..1
	 if exists("b:cecutil_winposn{jwinposn}")    " if it exists
	  if a:1 == b:cecutil_winposn{jwinposn}      " and the pattern matches
	   unlet b:cecutil_winposn{jwinposn}            " unlet it
	   if jwinposn == b:cecutil_iwinposn            " if at top-of-stack
		let b:cecutil_iwinposn= b:cecutil_iwinposn - 1      " drop stacktop by one
	   endif
	  endif
	 endif
	 let jwinposn= jwinposn - 1
	endwhile
   endif
  endif

  " Seems to be something odd: vertical motions after RWP
  " cause jump to first column.  The following fixes that.
  " Note: was using wincol()>1, but with signs, a cursor
  " at column 1 yields wincol()==3.  Beeping ensued.
  let vekeep= &ve
  set ve=all
  if virtcol('.') > 1
   exe s:modifier."norm! hl"
  elseif virtcol(".") < virtcol("$")
   exe s:modifier."norm! lh"
  endif
  let &ve= vekeep

  let &l:so   = so_keep
  let &l:siso = siso_keep
  let &l:ss   = ss_keep

"  echomsg "Decho: RestoreWinPosn"
endfun

" ---------------------------------------------------------------------
" s:WinLineRestore: {{{2
fun! s:WinLineRestore(swwline)
"  echomsg "Decho: s:WinLineRestore(swwline=".a:swwline.")"
  while winline() < a:swwline
   let curwinline= winline()
   exe s:modifier."norm! \<c-y>"
   if curwinline == winline()
	break
   endif
  endwhile
"  echomsg "Decho: s:WinLineRestore"
endfun

" ---------------------------------------------------------------------
" GoWinbufnr: go to window holding given buffer (by number) {{{2
"   Prefers current window; if its buffer number doesn't match,
"   then will try from topleft to bottom right
fun! GoWinbufnr(bufnum)
"  call Dfunc("GoWinbufnr(".a:bufnum.")")
  if winbufnr(0) == a:bufnum
"   call Dret("GoWinbufnr : winbufnr(0)==a:bufnum")
   return
  endif
  winc t
  let first=1
  while winbufnr(0) != a:bufnum && (first || winnr() != 1)
  	winc w
	let first= 0
   endwhile
"  call Dret("GoWinbufnr")
endfun

" ---------------------------------------------------------------------
" SaveMark: sets up a string saving a mark position. {{{2
"           For example, SaveMark("a")
"           Also sets up a global variable, g:savemark_{markname}
fun! SaveMark(markname)
"  call Dfunc("SaveMark(markname<".a:markname.">)")
  let markname= a:markname
  if strpart(markname,0,1) !~ '\a'
   let markname= strpart(markname,1,1)
  endif
"  call Decho("markname=".markname)

  let lzkeep  = &lz
  set lz

  if 1 <= line("'".markname) && line("'".markname) <= line("$")
   let winposn               = SaveWinPosn(0)
   exe s:modifier."norm! `".markname
   let savemark              = SaveWinPosn(0)
   let g:savemark_{markname} = savemark
   let savemark              = markname.savemark
   call RestoreWinPosn(winposn)
  else
   let g:savemark_{markname} = ""
   let savemark              = ""
  endif

  let &lz= lzkeep

"  call Dret("SaveMark : savemark<".savemark.">")
  return savemark
endfun

" ---------------------------------------------------------------------
" RestoreMark: {{{2
"   call RestoreMark("a")  -or- call RestoreMark(savemark)
fun! RestoreMark(markname)
"  call Dfunc("RestoreMark(markname<".a:markname.">)")

  if strlen(a:markname) <= 0
"   call Dret("RestoreMark : no such mark")
   return
  endif
  let markname= strpart(a:markname,0,1)
  if markname !~ '\a'
   " handles 'a -> a styles
   let markname= strpart(a:markname,1,1)
  endif
"  call Decho("markname=".markname." strlen(a:markname)=".strlen(a:markname))

  let lzkeep  = &lz
  set lz
  let winposn = SaveWinPosn(0)

  if strlen(a:markname) <= 2
   if exists("g:savemark_{markname}") && strlen(g:savemark_{markname}) != 0
	" use global variable g:savemark_{markname}
"	call Decho("use savemark list")
	call RestoreWinPosn(g:savemark_{markname})
	exe "norm! m".markname
   endif
  else
   " markname is a savemark command (string)
"	call Decho("use savemark command")
   let markcmd= strpart(a:markname,1)
   call RestoreWinPosn(markcmd)
   exe "norm! m".markname
  endif

  call RestoreWinPosn(winposn)
  let &lz       = lzkeep

"  call Dret("RestoreMark")
endfun

" ---------------------------------------------------------------------
" DestroyMark: {{{2
"   call DestroyMark("a")  -- destroys mark
fun! DestroyMark(markname)
"  call Dfunc("DestroyMark(markname<".a:markname.">)")

  " save options and set to standard values
  let reportkeep= &report
  let lzkeep    = &lz
  set lz report=10000

  let markname= strpart(a:markname,0,1)
  if markname !~ '\a'
   " handles 'a -> a styles
   let markname= strpart(a:markname,1,1)
  endif
"  call Decho("markname=".markname)

  let curmod  = &mod
  let winposn = SaveWinPosn(0)
  1
  let lineone = getline(".")
  exe "k".markname
  d
  put! =lineone
  let &mod    = curmod
  call RestoreWinPosn(winposn)

  " restore options to user settings
  let &report = reportkeep
  let &lz     = lzkeep

"  call Dret("DestroyMark")
endfun

" ---------------------------------------------------------------------
" QArgSplitter: to avoid \ processing by <f-args>, <q-args> is needed. {{{2
" However, <q-args> doesn't split at all, so this one returns a list
" with splits at all whitespace (only!), plus a leading length-of-list.
" The resulting list:  qarglist[0] corresponds to a:0
"                      qarglist[i] corresponds to a:{i}
fun! QArgSplitter(qarg)
"  call Dfunc("QArgSplitter(qarg<".a:qarg.">)")
  let qarglist    = split(a:qarg)
  let qarglistlen = len(qarglist)
  let qarglist    = insert(qarglist,qarglistlen)
"  call Dret("QArgSplitter ".string(qarglist))
  return qarglist
endfun

" ---------------------------------------------------------------------
" ListWinPosn: {{{2
"fun! ListWinPosn()                                                        " Decho 
"  if !exists("b:cecutil_iwinposn") || b:cecutil_iwinposn == 0             " Decho 
"   call Decho("nothing on SWP stack")                                     " Decho
"  else                                                                    " Decho
"   let jwinposn= b:cecutil_iwinposn                                       " Decho 
"   while jwinposn >= 1                                                    " Decho 
"    if exists("b:cecutil_winposn{jwinposn}")                              " Decho 
"     call Decho("winposn{".jwinposn."}<".b:cecutil_winposn{jwinposn}.">") " Decho 
"    else                                                                  " Decho 
"     call Decho("winposn{".jwinposn."} -- doesn't exist")                 " Decho 
"    endif                                                                 " Decho 
"    let jwinposn= jwinposn - 1                                            " Decho 
"   endwhile                                                               " Decho 
"  endif                                                                   " Decho
"endfun                                                                    " Decho 
"com! -nargs=0 LWP	call ListWinPosn()                                    " Decho 

" ---------------------------------------------------------------------
" SaveUserMaps: this function sets up a script-variable (s:restoremap) {{{2
"          which can be used to restore user maps later with
"          call RestoreUserMaps()
"
"          mapmode - see :help maparg for details (n v o i c l "")
"                    ex. "n" = Normal
"                    The letters "b" and "u" are optional prefixes;
"                    The "u" means that the map will also be unmapped
"                    The "b" means that the map has a <buffer> qualifier
"                    ex. "un"  = Normal + unmapping
"                    ex. "bn"  = Normal + <buffer>
"                    ex. "bun" = Normal + <buffer> + unmapping
"                    ex. "ubn" = Normal + <buffer> + unmapping
"          maplead - see mapchx
"          mapchx  - "<something>" handled as a single map item.
"                    ex. "<left>"
"                  - "string" a string of single letters which are actually
"                    multiple two-letter maps (using the maplead:
"                    maplead . each_character_in_string)
"                    ex. maplead="\" and mapchx="abc" saves user mappings for
"                        \a, \b, and \c
"                    Of course, if maplead is "", then for mapchx="abc",
"                    mappings for a, b, and c are saved.
"                  - :something  handled as a single map item, w/o the ":"
"                    ex.  mapchx= ":abc" will save a mapping for "abc"
"          suffix  - a string unique to your plugin
"                    ex.  suffix= "DrawIt"
fun! SaveUserMaps(mapmode,maplead,mapchx,suffix)
"  call Dfunc("SaveUserMaps(mapmode<".a:mapmode."> maplead<".a:maplead."> mapchx<".a:mapchx."> suffix<".a:suffix.">)")

  if !exists("s:restoremap_{a:suffix}")
   " initialize restoremap_suffix to null string
   let s:restoremap_{a:suffix}= ""
  endif

  " set up dounmap: if 1, then save and unmap  (a:mapmode leads with a "u")
  "                 if 0, save only
  let mapmode  = a:mapmode
  let dounmap  = 0
  let dobuffer = ""
  while mapmode =~ '^[bu]'
   if     mapmode =~ '^u'
    let dounmap = 1
    let mapmode = strpart(a:mapmode,1)
   elseif mapmode =~ '^b'
    let dobuffer = "<buffer> "
    let mapmode  = strpart(a:mapmode,1)
   endif
  endwhile
"  call Decho("dounmap=".dounmap."  dobuffer<".dobuffer.">")
 
  " save single map :...something...
  if strpart(a:mapchx,0,1) == ':'
"   call Decho("save single map :...something...")
   let amap= strpart(a:mapchx,1)
   if amap == "|" || amap == "\<c-v>"
    let amap= "\<c-v>".amap
   endif
   let amap                    = a:maplead.amap
   let s:restoremap_{a:suffix} = s:restoremap_{a:suffix}."|:sil! ".mapmode."unmap ".dobuffer.amap
   if maparg(amap,mapmode) != ""
    let maprhs                  = substitute(maparg(amap,mapmode),'|','<bar>','ge')
	let s:restoremap_{a:suffix} = s:restoremap_{a:suffix}."|:".mapmode."map ".dobuffer.amap." ".maprhs
   endif
   if dounmap
	exe "sil! ".mapmode."unmap ".dobuffer.amap
   endif
 
  " save single map <something>
  elseif strpart(a:mapchx,0,1) == '<'
"   call Decho("save single map <something>")
   let amap       = a:mapchx
   if amap == "|" || amap == "\<c-v>"
    let amap= "\<c-v>".amap
"	call Decho("amap[[".amap."]]")
   endif
   let s:restoremap_{a:suffix} = s:restoremap_{a:suffix}."|sil! ".mapmode."unmap ".dobuffer.amap
   if maparg(a:mapchx,mapmode) != ""
    let maprhs                  = substitute(maparg(amap,mapmode),'|','<bar>','ge')
	let s:restoremap_{a:suffix} = s:restoremap_{a:suffix}."|".mapmode."map ".dobuffer.amap." ".maprhs
   endif
   if dounmap
	exe "sil! ".mapmode."unmap ".dobuffer.amap
   endif
 
  " save multiple maps
  else
"   call Decho("save multiple maps")
   let i= 1
   while i <= strlen(a:mapchx)
    let amap= a:maplead.strpart(a:mapchx,i-1,1)
	if amap == "|" || amap == "\<c-v>"
	 let amap= "\<c-v>".amap
	endif
	let s:restoremap_{a:suffix} = s:restoremap_{a:suffix}."|sil! ".mapmode."unmap ".dobuffer.amap
    if maparg(amap,mapmode) != ""
     let maprhs                  = substitute(maparg(amap,mapmode),'|','<bar>','ge')
	 let s:restoremap_{a:suffix} = s:restoremap_{a:suffix}."|".mapmode."map ".dobuffer.amap." ".maprhs
    endif
	if dounmap
	 exe "sil! ".mapmode."unmap ".dobuffer.amap
	endif
    let i= i + 1
   endwhile
  endif
"  call Dret("SaveUserMaps : restoremap_".a:suffix.": ".s:restoremap_{a:suffix})
endfun

" ---------------------------------------------------------------------
" RestoreUserMaps: {{{2
"   Used to restore user maps saved by SaveUserMaps()
fun! RestoreUserMaps(suffix)
"  call Dfunc("RestoreUserMaps(suffix<".a:suffix.">)")
  if exists("s:restoremap_{a:suffix}")
   let s:restoremap_{a:suffix}= substitute(s:restoremap_{a:suffix},'|\s*$','','e')
   if s:restoremap_{a:suffix} != ""
"   	call Decho("exe ".s:restoremap_{a:suffix})
    exe "sil! ".s:restoremap_{a:suffix}
   endif
   unlet s:restoremap_{a:suffix}
  endif
"  call Dret("RestoreUserMaps")
endfun

" ==============
"  Restore: {{{1
" ==============
let &cpo= s:keepcpo
unlet s:keepcpo

" ================
"  Modelines: {{{1
" ================
" vim: ts=4 fdm=marker
