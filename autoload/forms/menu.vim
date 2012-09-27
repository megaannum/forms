
"source $HOME/.vim/forms.vim

" ============================================================================
" menu.vim
"
" File:          menu.vim
" Summary:       Vim Menu and Popup using Form Library
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 06/30/2012
" Version:       1.0
" Modifications:
"  1.0 : initial public release.
"
" Tested on vim 7.3 on Linux
"
" Depends upon: self.vim forms.vim
"
" ============================================================================
" Intro: {{{1
" This code is basically a demonstration of the capabilities of the Forms
"   library. GVim has both a menubar and a popup menu. This code uses
"   the Forms library to recreate them or, at least, the vast majority 
"   of their capabilities. Certainly, the GUI menus look better than
"   text-base menus. But, what the heck, the Forms library is for building
"   TUIs (Text User Interfaces) not GUIs.
" It is also true, that the act of generating the TUI menus uncovered 
"   weaknesses and additional requirements for the Forms library ... which 
"   is a good thing.
" The source for the Vim GUI menus are found in $VIM_RUNTIME/menu.vim
"   Some of the supporting Vim script in that file is reproduced and
"   used here ... Steal the best, code the rest.
" ============================================================================

" Load Once: {{{1
if &cp || ( exists("g:loaded_menu") && ! g:self#IN_DEVELOPMENT_MODE )
  finish
endif
let g:loaded_menu = 'v1.0'
let s:keepcpo = &cpo
set cpo&vim

"-------------------------------------------------------------------------------
" Configuration Options: {{{1
"   These help control of the menu library.
"-------------------------------------------------------------------------------

" Maps for Menu and PopUp
" Users can define their own mappings and, of course, then
" define g:menu_map_keys
if !exists("g:menu_map_keys")
  nmap <Leader>m :call forms#menu#MakeMenu('n')<CR>
  vmap <Leader>m :call forms#menu#MakeMenu('v')<CR>
  nmap <Leader>p :call forms#menu#MakePopUp('n')<CR>
  vmap <Leader>p :call forms#menu#MakePopUp('v')<CR>
  let g:menu_map_keys = 1
endif

"-------------------------------------------------------------------------------
"-------------------------------------------------------------------------------
" Support Forms: {{{1
"-------------------------------------------------------------------------------
"-------------------------------------------------------------------------------


" ------------------------------------------------------------ 
" s:FnameEscape: {{{2
"  Escape string for use as file name 
"  parameters:
"     fname : file name to be escaped
" ------------------------------------------------------------ 
function! s:FnameEscape(fname)
  if exists('*fnameescape')
  return fnameescape(a:fname)
  endif
  return escape(a:fname, " \t\n*?[{`$\\%#'\"|!<")
endfunc



"---------------------------------------------------------------------------
" HelpFind: {{{2
"   Presentation:
"     Lauches forms#dialog#input#Make
"     Executes ":help input"
"   Parameters: NONE
"---------------------------------------------------------------------------
function! g:HelpFind()
"call forms#log("HelpFind")
  let help_lines = [
       \ "Enter a command or word to find help on:",
       \ "",
       \ "Prepend i_ for Input mode commands (e.g.: i_CTRL-X)",
       \ "Prepend c_ for command-line editing commands (e.g.: c_<Del>)",
       \ "Prepend ' for an option name (e.g.: 'shiftwidth')" 
       \ ]

  let h = forms#dialog#input#Make(help_lines)
  if h != ""
    let v:errmsg = ""
    silent! execute "help " . h
    if v:errmsg != ""
      echo v:errmsg
    endif
  endif
endfunction

"-------------------------------------------------------------------------------
"-------------------------------------------------------------------------------
" Menus: {{{1
"-------------------------------------------------------------------------------
"-------------------------------------------------------------------------------

"-------------------------------------------------------------------------------
" File Menu: {{{2
"-------------------------------------------------------------------------------
if exists("s:fileMenu")
  unlet s:fileMenu
endif

"---------------------------------------------------------------------------
" forms#menu#MakeFileMenu: {{{3
"   Create File menu
"    Example:
"        Open...  :e           
"        Split-Open... :sp     
"        Open Tab... :tabnew   
"        New :enew             
"        Close :close          
"       ────────────────────── 
"        Save :w               
"        Save As... :sav       
"       ────────────────────── 
"        Split Diff with...    
"        Split Patched By...   
"       ────────────────────── 
"        Print :hardcopy       
"        Save-Exit :wqa        
"        Exit :qa              
"
"  parameters: None
"---------------------------------------------------------------------------
function! forms#menu#MakeFileMenu() 
" call forms#log("forms#menu#MakeFileMenu TOP")

  function! BrowserAction(title, cmd) 
    let dict = { 'title' : a:title }
    let f = forms#dialog#filebrowser#Make(dict) 
    call forms#log("forms#menu#MakeFileMenu.BrowserAction f=".f)
    if f != ''
      let f = substitute(f, ' ', '\\ ', "g")
      execute ':'.a:cmd.f
    endif
  endfunction

  if ! exists("s:fileMenu")
    let items = []
    call add(items, { 
        \  'type': 'button',
        \   'label': '&Open...',
        \   'hint': ':e',
        \   'command': ":call BrowserAction('Edit File', 'e')"
        \ })
    call add(items, { 
        \  'type': 'button',
        \   'label': 'Sp&lit-Open...',
        \   'hint': ':sp',
        \   'command': ":call BrowserAction('Edit File in new Window', 'sp')"
        \ })
    call add(items, { 
        \  'type': 'button',
        \   'label': 'Open &Tab...',
        \   'hint': ':tabnew',
        \   'command': ":call BrowserAction('Edit File in new Tab', 'sp')"
        \ })
    call add(items, { 
        \  'type': 'button',
        \   'label': '&New',
        \   'hint': ':enew',
        \   'command': ':enew'
        \ })
    call add(items, { 
        \  'type': 'button',
        \   'label': '&Close',
        \   'hint': ':close',
        \   'command': ":if winheight(2) < 0 | :execute ':enew' | else | :execute ':close' | endif"
     \ })

    call add(items, {'type': 'separator'})

    call add(items, { 
        \  'type': 'button',
        \   'label': '&Save',
        \   'hint': ':w',
        \   'command': ":if expand('%') == ''| :call BrowserAction('Save', 'w') | else | :execute ':w' | endif"
        \ })
    call add(items, { 
        \  'type': 'button',
        \   'label': 'Save &As...',
        \   'hint': ':sav',
        \   'command': ":call BrowserAction('Save As', 'saveas')"
        \ })


    if has("diff")
      call add(items, {'type': 'separator'})
    
      call add(items, { 
          \  'type': 'button',
          \   'label': 'Split &Diff with...',
          \   'command': ":call BrowserAction('Diff Split', 'vert diffsplit')"
          \ })
      call add(items, { 
          \  'type': 'button',
          \   'label': 'Split Patched &By...',
          \   'command': ":call BrowserAction('Diff Patch', 'vert diffpatch')"
          \ })
    endif

    if has("printer")
      call add(items, {'type': 'separator'})

      call add(items, { 
          \  'type': 'button',
          \   'label': '&Print',
          \   'hint': ':hardcopy',
          \   'command': ':hardcopy'
          \ })

    elseif has("unix")
      call add(items, {'type': 'separator'})

      call add(items, { 
          \  'type': 'button',
          \   'label': '&Print',
          \   'hint': ':w !lpr',
          \   'command': ':w !lpr'
          \ })

    else
      call add(items, {'type': 'separator'})
    endif

    call add(items, { 
        \  'type': 'button',
        \   'label': 'Sa&ve-Exit',
        \   'hint': ':wqa',
        \   'command': ':wqa'
        \ })
    call add(items, { 
        \  'type': 'button',
        \   'label': 'E&xit',
        \   'hint': ':qa',
        \   'command': ':qa'
        \ })


    let attrs = { 'items': items }
    let s:fileMenu = forms#newMenu(attrs)
  endif

  return s:fileMenu
endfunction

"-------------------------------------------------------------------------------
" Edit Menu: {{{2
"-------------------------------------------------------------------------------
if exists("s:editMenu")
  unlet s:editMenu
endif

"---------------------------------------------------------------------------
" GetSelectedText: {{{3
"   Returns visually selected text
"  parameters: None
"---------------------------------------------------------------------------
function! GetSelectedText()
  if exists("s:firstcol")
    let text = ''
    let fl =s:firstline
    let ll =s:lastline
    let fc =s:firstcol
    let lc =s:lastcol
    if fl == ll 
      let text = getline(fl)[fc : lc]
    else
      let text = getline(fl)[fc :]
      let cnt = fl+1
      while cnt < ll
        let text += getline(cnt)
        let cnt += 1
      endwhile
      let text += getline(cnt)[: lc]
    endif
    return text
  else
    return ''
  endif
endfunction

"---------------------------------------------------------------------------
" forms#menu#MakeEditGlobalSettingsContextMenu: {{{3
"   Returns menu
"    Example:
"        1 :set so=1      
"        2 :set so=2      
"        3 :set so=3      
"        4 :set so=4      
"        5 :set so=5      
"        7 :set so=7      
"        10 :set so=10    
"        100 :set so=100  
"
"  parameters: None
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("s:editGlobalSettingsContextMenu")
    unlet s:editGlobalSettingsContextMenu
  endif
endif
function! forms#menu#MakeEditGlobalSettingsContextMenu() 

  if ! exists("s:editGlobalSettingsContextMenu")
    let items = []

    call add(items, { 
        \  'type': 'button',
        \  'label': '&1',
        \  'hint': ':set so=1',
        \  'command': ':set so=1'
        \ })
    call add(items, { 
        \  'type': 'button',
        \  'label': '&2',
        \  'hint': ':set so=2',
        \  'command': ':set so=2'
        \ })
    call add(items, { 
        \  'type': 'button',
        \  'label': '&3',
        \  'hint': ':set so=3',
        \  'command': ':set so=3'
        \ })
    call add(items, { 
        \  'type': 'button',
        \  'label': '&4',
        \  'hint': ':set so=4',
        \  'command': ':set so=4'
        \ })
    call add(items, { 
        \  'type': 'button',
        \  'label': '&5',
        \  'hint': ':set so=5',
        \  'command': ':set so=5'
        \ })
    call add(items, { 
        \  'type': 'button',
        \  'label': '&7',
        \  'hint': ':set so=7',
        \  'command': ':set so=7'
        \ })
    call add(items, { 
        \  'type': 'button',
        \  'label': '&10',
        \  'hint': ':set so=10',
        \  'command': ':set so=10'
        \ })
    call add(items, { 
        \  'type': 'button',
        \  'label': '&100',
        \  'hint': ':set so=100',
        \  'command': ':set so=100'
        \ })

    let attrs = { 'items': items }
    let s:editGlobalSettingsContextMenu = forms#newMenu(attrs)
  endif

  return s:editGlobalSettingsContextMenu
endfunction

"---------------------------------------------------------------------------
" forms#menu#MakeEditGlobalSettingsVEditMenu: {{{3
"   Returns menu
"    Example:
"        Never :set ve=                         
"        Block Selection  :set ve=block         
"        Insert mode  :set ve=insert            
"        Block and Insert :set ve=block,insert  
"        Always    set ve=all                   
"
"  parameters: None
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("s:editGlobalSettingsVEditMenu")
    unlet s:editGlobalSettingsVEditMenu
  endif
endif
function! forms#menu#MakeEditGlobalSettingsVEditMenu() 

  if ! exists("s:editGlobalSettingsVEditMenu")
    let items = []

    call add(items, { 
        \  'type': 'button',
        \  'label': '&Never',
        \  'hint': ':set ve=',
        \  'command': ':set ve='
        \ })
    call add(items, { 
        \  'type': 'button',
        \  'label': '&Block Selection',
        \  'hint': ':set ve=block',
        \  'command': ':set ve=block'
        \ })
    call add(items, { 
        \  'type': 'button',
        \  'label': '&Insert mode',
        \  'hint': ':set ve=insert',
        \  'command': ':set ve=insert'
        \ })
    call add(items, { 
        \  'type': 'button',
        \  'label': 'Block &and Insert',
        \  'hint': ':set ve=block,insert',
        \  'command': ':set ve=block,insert'
        \ })
    call add(items, { 
        \  'type': 'button',
        \  'label': '&Always',
        \  'hint': ':set ve=all',
        \  'command': ':set ve=all'
        \ })


    let attrs = { 'items': items }
    let s:editGlobalSettingsVEditMenu = forms#newMenu(attrs)
  endif

  return s:editGlobalSettingsVEditMenu
endfunction

"---------------------------------------------------------------------------
" forms#menu#MakeEditGlobalSettingsMenu: {{{3
"   Returns menu
"    Example:
"        Toggle Pattern Highlight :set hls!  
"        Toggle Ignore-case  :set ic!        
"        Toggle Showmatch  :set sm!          
"        Context lines                       
"        Virtual Edit                        
"        Toggle Insert Mode  :set im!        
"        Toggle Vi Compatible  :set cp!      
"        Search Path...                      
"        Tag Files...                        
"
"  parameters: None
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("s:editGlobalSettingsMenu")
    unlet s:editGlobalSettingsMenu
  endif
endif
function! forms#menu#MakeEditGlobalSettingsMenu() 

  if ! exists("s:editGlobalSettingsMenu")
    let items = []

    " Toggle
    call add(items, { 
        \  'type': 'button',
        \  'label': 'Toggle Pattern &Highlight',
        \  'hint': ':set hls!',
        \  'command': ':set hls! hls?'
        \ })
    call add(items, { 
        \  'type': 'button',
        \  'label': 'Toggle &Ignore-case',
        \  'hint': ':set ic!',
        \  'command': ':set ic! ic?'
        \ })
    call add(items, { 
        \  'type': 'button',
        \  'label': 'Toggle &Showmatch',
        \  'hint': ':set sm!',
        \  'command': ':set sm! sm?'
        \ })

    " Context lines ->
    let MakeEditGlobalSettingsContextMenuFN = function("forms#menu#MakeEditGlobalSettingsContextMenu")
    call add(items, { 
          \ 'type': 'menu',
          \ 'label': '&Context lines',
          \ 'menuFN': MakeEditGlobalSettingsContextMenuFN
          \ })

    " Virtual Edit ->
    let MakeEditGlobalSettingsVEditMenuFN = function("forms#menu#MakeEditGlobalSettingsVEditMenu")
    call add(items, { 
          \ 'type': 'menu',
          \ 'label': '&Virtual Edit',
          \ 'menuFN': MakeEditGlobalSettingsVEditMenuFN
          \ })

    " Toggle Insert Mode
    call add(items, { 
        \  'type': 'button',
        \  'label': 'Toggle Insert &Mode',
        \  'hint': ':set im!',
        \  'command': ':set im!'
        \ })
    " Toggle Vi Compatible
    call add(items, { 
        \  'type': 'button',
        \  'label': 'Toggle Vi C&ompatible',
        \  'hint': ':set cp!',
        \  'command': ':set cp!'
        \ })


    " Search Path
    function! SearchP()
      if !exists("g:menutrans_path_dialog")
        let g:menutrans_path_dialog = "Enter search path for files.\nSeparate directory names with a comma."
      endif

      let n = forms#dialog#input#Make(g:menutrans_path_dialog, substitute(&path, '\\ ', ' ', 'g'))
      if n != ""
        let &path = substitute(n, ' ', '\\ ', 'g')
      endif
    endfunction
    call add(items, { 
        \  'type': 'button',
        \  'label': 'Search &Path...',
        \  'command': ':call SearchP()'
        \ })

    " Tag Files...
    function! TagFiles()
      if !exists("g:menutrans_tags_dialog")
        let g:menutrans_tags_dialog = "Enter names of tag files.\nSeparate the names with a comma."
      endif
      let n = forms#dialog#input#Make(g:menutrans_tags_dialog, substitute(&tags, '\\ ', ' ', 'g'))
      if n != ""
        let &tags = substitute(n, ' ', '\\ ', 'g')
      endif
    endfunction
    call add(items, { 
        \  'type': 'button',
        \  'label': 'Ta&g Files...',
        \  'command': ':call TagFiles()'
        \ })

    " Not supported yet
    " Toggle Toolbar
    " Toggle Bottom Scrollbar
    " Toggle Left Scrollbar
    " Toggle Right Scrollbar

    let attrs = { 'items': items }
    let s:editGlobalSettingsMenu = forms#newMenu(attrs)
  endif

  return s:editGlobalSettingsMenu
endfunction

"---------------------------------------------------------------------------
" forms#menu#MakeEditFileSettingsShiftwidthMenu: {{{3
"   Returns menu
"    Example:
"        2  :set sw=2  
"        3  :set sw=3  
"        4  :set sw=4  
"        5  :set sw=5  
"        6  :set sw=6  
"        8  :set sw=8  
"
"  parameters: None
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("s:editFileSettingsShiftwidthMenu")
    unlet s:editFileSettingsShiftwidthMenu
  endif
endif
function! forms#menu#MakeEditFileSettingsShiftwidthMenu() 

  if ! exists("s:editFileSettingsShiftwidthMenu")
    let items = []

    " Toggle
    call add(items, { 
        \  'type': 'button',
        \  'label': '&2',
        \  'hint': ':set sw=2',
        \  'command': ':set sw=2 sw?'
        \ })
    call add(items, { 
        \  'type': 'button',
        \  'label': '&3',
        \  'hint': ':set sw=3',
        \  'command': ':set sw=3 sw?'
        \ })
    call add(items, { 
        \  'type': 'button',
        \  'label': '&4',
        \  'hint': ':set sw=4',
        \  'command': ':set sw=4 sw?'
        \ })
    call add(items, { 
        \  'type': 'button',
        \  'label': '&5',
        \  'hint': ':set sw=5',
        \  'command': ':set sw=5 sw?'
        \ })
    call add(items, { 
        \  'type': 'button',
        \  'label': '&6',
        \  'hint': ':set sw=6',
        \  'command': ':set sw=6 sw?'
        \ })
    call add(items, { 
        \  'type': 'button',
        \  'label': '&8',
        \  'hint': ':set sw=8',
        \  'command': ':set sw=8 sw?'
        \ })

    let attrs = { 'items': items }
    let s:editFileSettingsShiftwidthMenu = forms#newMenu(attrs)
  endif

  return s:editFileSettingsShiftwidthMenu
endfunction

"---------------------------------------------------------------------------
" forms#menu#MakeEditFileSettingsSoftTabstopMenu: {{{3
"   Returns menu
"    Example:
"        2  :set sts=2  
"        3  :set sts=3  
"        4  :set sts=4  
"        5  :set sts=5  
"        6  :set sts=6  
"        8  :set sts=8  
"
"  parameters: None
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("s:editFileSettingsSoftTabstopMenu")
    unlet s:editFileSettingsSoftTabstopMenu
  endif
endif
function! forms#menu#MakeEditFileSettingsSoftTabstopMenu() 

  if ! exists("s:editFileSettingsSoftTabstopMenu")
    let items = []

    " Toggle
    call add(items, { 
        \  'type': 'button',
        \  'label': '&2',
        \  'hint': 'set sts=2',
        \  'command': ':set sts=2 sts?'
        \ })
    call add(items, { 
        \  'type': 'button',
        \  'label': '&3',
        \  'hint': 'set sts=3',
        \  'command': ':set sts=3 sts?'
        \ })
    call add(items, { 
        \  'type': 'button',
        \  'label': '&4',
        \  'hint': ':set sts=4',
        \  'command': ':set sts=4 sts?'
        \ })
    call add(items, { 
        \  'type': 'button',
        \  'label': '&5',
        \  'hint': ':set sts=5',
        \  'command': ':set sts=5 sts?'
        \ })
    call add(items, { 
        \  'type': 'button',
        \  'label': '&6',
        \  'hint': ':set sts=6',
        \  'command': ':set sts=6 sts?'
        \ })
    call add(items, { 
        \  'type': 'button',
        \  'label': '&8',
        \  'hint': ':set sts=8',
        \  'command': ':set sts=8 sts?'
        \ })

    let attrs = { 'items': items }
    let s:editFileSettingsSoftTabstopMenu = forms#newMenu(attrs)
  endif

  return s:editFileSettingsSoftTabstopMenu
endfunction

"---------------------------------------------------------------------------
" forms#menu#MakeEditFileSettingsMenu: {{{3
"   Returns menu
"    Example:
"        Toggle relative Lint Numbering :set rnu!  
"        Toggle Line Numbering :set nu!            
"        Toggle List Mode   :set list!             
"        Toggle Line Wrap   :set wrap!             
"        Toggle Wrap at word  :set lbr!            
"        Toggle expand-tab   :set et!              
"        Toggle auto-indent   :set ai!             
"        Toggle C-indenting   :set cin!            
"        ────────────────────────────────────────── 
"        Shiftwidth                                
"        Soft Tabstop                              
"        Text Width...                             
"        File Format...                            
"
"  parameters: None
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("s:editFileSettingsMenu")
    unlet s:editFileSettingsMenu
  endif
endif
function! forms#menu#MakeEditFileSettingsMenu() 

  if ! exists("s:editFileSettingsMenu")
    let items = []

    " Toggle
    call add(items, { 
        \  'type': 'button',
        \  'label': 'Toggle relati&ve Lint Numbering',
        \  'hint': ':set rnu!',
        \  'command': ':set nu! nu?'
        \ })
    call add(items, { 
        \  'type': 'button',
        \  'label': 'Toggle Line &Numbering',
        \  'hint': ':set nu!',
        \  'command': ':set rnu! rnu?'
        \ })
    call add(items, { 
        \  'type': 'button',
        \  'label': 'Toggle &List Mode',
        \  'hint': ':set list!',
        \  'command': ':set list! list?'
        \ })
    call add(items, { 
        \  'type': 'button',
        \  'label': 'Toggle Line &Wrap',
        \  'hini': ':set wrap!',
        \  'command': ':set wrap! wrap?'
        \ })
    call add(items, { 
        \  'type': 'button',
        \  'label': 'Toggle W&rap at word',
        \  'hint': ':set lbr!',
        \  'command': ':set lbr! lbr?'
        \ })
    call add(items, { 
        \  'type': 'button',
        \  'label': 'Toggle &expand-tab',
        \  'hint': ':set et!',
        \  'command': ':set et! et?'
        \ })
    call add(items, { 
        \  'type': 'button',
        \  'label': 'Toggle &auto-indent',
        \  'hint': ':set ai!',
        \  'command': ':set ai! ai?'
        \ })
    call add(items, { 
        \  'type': 'button',
        \  'label': 'Toggle &C-indenting',
        \  'hint': ':set cin!',
        \  'command': ':set cin! cin?'
        \ })

    call add(items, { 'type': 'separator' })

    let MakeEditFileSettingsShiftwidthMenuFN = function("forms#menu#MakeEditFileSettingsShiftwidthMenu")
    call add(items, { 
          \ 'type': 'menu',
          \ 'label': '&Shiftwidth',
          \ 'menuFN': MakeEditFileSettingsShiftwidthMenuFN
          \ })

    let MakeEditFileSettingsSoftTabstopMenuFN = function("forms#menu#MakeEditFileSettingsSoftTabstopMenu")
    call add(items, { 
          \ 'type': 'menu',
          \ 'label': 'Soft &Tabstop',
          \ 'menuFN': MakeEditFileSettingsSoftTabstopMenuFN
          \ })

    function! TextWidth()
      if !exists("g:menutrans_textwidth_dialog")
        let g:menutrans_textwidth_dialog = "Enter new text width (0 to disable formatting): "
      endif
      let n = forms#dialog#input#Make(g:menutrans_textwidth_dialog, &tw)
      if n != ""
        " remove leading zeros to avoid it being used as an octal number
        let &tw = substitute(n, "^0*", "", "")
      endif
    endfunction

    call add(items, { 
        \  'type': 'button',
        \  'label': 'Te&xt Width...',
        \  'command': ':call  TextWidth()'
        \ })

    function! FileFormat()
      if !exists("g:menutrans_fileformat_dialog")
        let g:menutrans_fileformat_dialog = "Select format for writing the file"
      endif
      if !exists("g:menutrans_fileformat_choices")
        let g:menutrans_fileformat_choices = "Unix\nDos\nMac"
      endif
      if &ff == "dos"
        let def = 2
      elseif &ff == "mac"
        let def = 3
      else
        let def = 1
      endif
      let n = forms#dialog#confirm#Make(g:menutrans_fileformat_dialog, g:menutrans_fileformat_choices, def)
      if n == 1
        set ff=unix
      elseif n == 2
        set ff=dos
      elseif n == 3
        set ff=mac
      endif
    endfunction

    call add(items, { 
        \  'type': 'button',
        \  'label': '&File Format...',
        \  'command': ':call  FileFormat()'
        \ })


    let attrs = { 'items': items }
    let s:editFileSettingsMenu = forms#newMenu(attrs)
  endif

  return s:editFileSettingsMenu
endfunction


"---------------------------------------------------------------------------
" forms#menu#MakeEditColorSchemeMenu: {{{3
"   Returns menu
"    Example:
"       adam               
"       adaryn             
"       adrian             
"       .....
"       xemacs             
"       xian               
"       zellner            
"       zenburn            
"
"  parameters: None
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("s:editColorSchemeMenu")
    unlet s:editColorSchemeMenu
  endif
endif
function! forms#menu#MakeEditColorSchemeMenu() 

  if ! exists("s:editColorSchemeMenu")
    redraw
    :echo "NOTE: Loading Color menu takes time"

    " get NL separated string with file names
    let s:n = globpath(&runtimepath, "colors/*.vim")

    " split at NL, Ignore case for VMS and windows, sort on name
    let s:names = sort(map(split(s:n, "\n"), 'substitute(v:val, "\\c.*[/\\\\:\\]]\\([^/\\\\:]*\\)\\.vim", "\\1", "")'), 1)

    let items = []

    " define all the submenu entries
    for s:name in s:names
"        exe "an 20.450." . s:idx . ' &Edit.C&olor\ Scheme.' . s:name . " :colors " . s:name . "<CR>"
      call add(items, { 
          \  'type': 'button',
          \  'label': s:name,
          \  'command': ':colors '.s:name
          \ })
    endfor
    unlet s:name s:names s:n

    let attrs = { 'items': items }
    let s:editColorSchemeMenu = forms#newMenu(attrs)
  endif

  return s:editColorSchemeMenu
endfunction

"---------------------------------------------------------------------------
" forms#menu#MakeEditKeymapMenu: {{{3
"   Returns menu
"    Example:
"       None  set keymap=   
"       accents             
"       arabic              
"       ....
"       thaana              
"       ukrainian-dvorak    
"       ukrainian-jcuken    
"       vietnamese-viqr     
"
"  parameters: None
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("s:editKeymapMenu")
    unlet s:editKeymapMenu
  endif
endif
function! forms#menu#MakeEditKeymapMenu() 

  if ! exists("s:editKeymapMenu")
    let items = []

    call add(items, { 
        \  'type': 'button',
        \  'label': 'None',
        \  'hint': 'set keymap=',
        \  'command': ':set keymap='
        \ })

    let s:n = globpath(&runtimepath, "keymap/*.vim")
    if s:n != ""
      let d = {}
      while strlen(s:n) > 0
        let s:i = stridx(s:n, "\n")
        if s:i < 0
          let s:name = s:n
          let s:n = ""
        else
          let s:name = strpart(s:n, 0, s:i)
          let s:n = strpart(s:n, s:i + 1, 19999)
        endif
        " Ignore case for VMS and windows
        let s:name = substitute(s:name, '\c.*[/\\:\]]\([^/\\:_]*\)\(_[0-9a-zA-Z-]*\)\=\.vim', '\1', '')

        if ! has_key(d, s:name)
          call add(items, { 
              \  'type': 'button',
              \  'label': s:name,
              \  'command': ':set keymap='.s:name
              \ })
          let d[s:name] = 1
        endif
        unlet s:name
        unlet s:i
      endwhile
      unlet d
    endif
    unlet s:n


    let attrs = { 'items': items }
    let s:editKeymapMenu = forms#newMenu(attrs)
  endif

  return s:editKeymapMenu
endfunction

"---------------------------------------------------------------------------
" forms#menu#MakeEditMenu: {{{3
"   Returns menu
"    Example:
"        Undo
"        Redo                
"        Repeat              
"       ──────────────────── 
"        Cut                 
"        Copy                
"        Paste               
"        Put Before [p       
"        Put After ]p        
"        Select All          
"       ──────────────────── 
"        Find  /             
"        Find and Replace /  
"       ──────────────────── 
"        Window  :options    
"        Settings            
"        Global Settings     
"        File Settings
"        Color Scheme
"        Keymap 
"        Font... 
"
"  parameters: None
"---------------------------------------------------------------------------
function! forms#menu#MakeEditMenu()
" call forms#log("forms#menu#MakeEditMenu TOP")
  if ! exists("s:editMenu")
    let items = []

    call add(items, { 
          \ 'type': 'button',
          \ 'label': '&Undo',
          \ 'hint': 'u',
          \ 'command': 'u'
          \ })
    call add(items, { 
          \ 'type': 'button',
          \ 'label': '&Redo',
          \ 'hint': '^R',
          \ 'command': ':red'
          \ })
    call add(items, { 
          \ 'type': 'button',
          \ 'label': 'Rep&eat',
          \ 'hint': '.',
          \ 'command': '.'
          \ })

    call add(items, { 'type': 'separator' })

    call add(items, { 
          \ 'type': 'button',
          \ 'label': 'Cu&t',
          \ 'hint': '+x',
          \ 'command': ':call g:CutCopyRange("x")'
          \ })
    call add(items, { 
          \ 'type': 'button',
          \ 'label': '&Copy',
          \ 'hint': '+y',
          \ 'command': ':call g:CutCopyRange("y")'
          \ })
    call add(items, { 
          \ 'type': 'button',
          \ 'label': '&Paste',
          \ 'hint': '+gP',
          \ 'command': '"'.g:yank_register_char.'gP'
          \ })
    call add(items, { 
          \ 'type': 'button',
          \ 'label': 'Put &Before',
          \ 'hint': '[p',
          \ 'command': '[p'
          \ })
    call add(items, { 
          \ 'type': 'button',
          \ 'label': 'Put &After',
          \ 'hint': ']p',
          \ 'command': ']p'
          \ })
    call add(items, { 
          \ 'type': 'button',
          \ 'label': 'Select &All',
          \ 'hint': 'ggVG',
          \ 'command': ':call menu#SelectAll()'
          \ })

    call add(items, { 'type': 'separator' })

" :call FindOnly("xxx", '/', 1)
    function! FindOnly(title, cmd, findonly) 
" call forms#log("forms#menu#MakeEditMenu.FindOnly TOP")
      let text = GetSelectedText()
" call forms#log("forms#menu#MakeEditMenu.FindOnly text=".text)
      let f = forms#dialog#textsearch#Make(a:title, a:findonly, text) 
" call forms#log("forms#menu#MakeEditMenu.FindOnly b return f=".f)
      if a:findonly
        if f != ''
           try
             execute f
           catch /.*/
             " do nothing
           endtry
        endif
        return @/
      else
        if f != ''
           try
             execute f
           catch /.*/
             " do nothing
           endtry
        endif
        return @/
      endif
    endfunction

    call add(items, { 
          \ 'type': 'button',
          \ 'label': '&Find',
          \ 'hint': '/',
          \ 'command': ':let @/ = FindOnly("Find", "/", 1)'
          \ })
    call add(items, { 
          \ 'type': 'button',
          \ 'label': 'Find and Rep&lace',
          \ 'hint': '/',
          \ 'command': ':call FindOnly("Find", "/", 0)'
          \ })

 
    call add(items, { 'type': 'separator' })

    call add(items, { 
          \ 'type': 'button',
          \ 'label': '&Window',
          \ 'hint': ':options',
          \ 'command': ':options'
          \ })

    function! EditVimrc()
      if $MYVIMRC != ''
        let fname = $MYVIMRC
      elseif has("win32") || has("dos32") || has("dos16") || has("os2")
        if $HOME != '' 
          let fname = $HOME . "/_vimrc"
        else
          let fname = $VIM . "/_vimrc"
        endif
      elseif has("amiga")
        let fname = "s:.vimrc"
      else
        let fname = $HOME . "/.vimrc"
      endif

      let fname = s:FnameEscape(fname)
      if &mod
        execute "split " . fname
      else
        execute "edit " . fname
      endif
    endfunction

    call add(items, { 
          \ 'type': 'button',
          \ 'label': '&Settings',
          \ 'command': ':call EditVimrc()'
          \ })

    let MakeEditGlobalSettingsMenuFN = function("forms#menu#MakeEditGlobalSettingsMenu")
    call add(items, { 
          \ 'type': 'menu',
          \ 'label': '&Global Settings',
          \ 'menuFN': MakeEditGlobalSettingsMenuFN
          \ })

    let MakeEditFileSettingsMenuFN = function("forms#menu#MakeEditFileSettingsMenu")
    call add(items, { 
          \ 'type': 'menu',
          \ 'label': 'F&ile Settings',
          \ 'menuFN': MakeEditFileSettingsMenuFN
          \ })

    " Setup the Edit.Color Scheme submenu
    let MakeEditColorSchemeMenuFN = function("forms#menu#MakeEditColorSchemeMenu")
    call add(items, { 
          \ 'type': 'menu',
          \ 'label': 'C&olor Scheme',
          \ 'menuFN': MakeEditColorSchemeMenuFN
          \ })

    " Setup the Edit.Keymap submenu
    if has("keymap")
      let MakeEditKeymapMenuFN = function("forms#menu#MakeEditKeymapMenu")
      call add(items, { 
            \ 'type': 'menu',
            \ 'label': '&Keymap',
            \ 'menuFN': MakeEditKeymapMenuFN
            \ })
    endif

    function! FontInfoDialogAction(textlines) dict
        call forms#dialog#info#Make("Changing Fonts not supported")
    endfunction
    let fontaction = forms#newAction({ 'execute': function("FontInfoDialogAction")})
    call add(items, { 
          \ 'type': 'button',
          \ 'label': 'Fo&nt...',
          \ 'action': fontaction
          \ })

    let attrs = { 'items' : items }
    let s:editMenu = forms#newMenu(attrs)
  endif

  return s:editMenu
endfunction

"-------------------------------------------------------------------------------
" Tools Menu: {{{2
"-------------------------------------------------------------------------------
if exists("s:toolsMenu")
  unlet s:toolsMenu
endif

if !exists("g:ctags_command")
  let g:ctags_command = has("vms") ? "mc vim:ctags *.*" : "ctags -R ."
endif

"---------------------------------------------------------------------------
" s:XxdConv: {{{3
"  Use a function to do the conversion, so that it also works 
"   with 'insertmode' set.
"  parameters: None
"---------------------------------------------------------------------------
function! s:XxdConv()
  let mod = &mod
  if has("vms")
    %!mc vim:xxd
  else
    call s:XxdFind()
    execute '%!"' . g:xxdprogram . '"'
  endif
  if getline(1) =~ "^0000000:"    " only if it worked
    set ft=xxd
  endif
  let &mod = mod
endfunction

"---------------------------------------------------------------------------
" s:XxdBack: {{{3
"  parameters: None
"---------------------------------------------------------------------------
function! s:XxdBack()
  let mod = &mod
  if has("vms")
    %!mc vim:xxd -r
  else
    call s:XxdFind()
    execute '%!"' . g:xxdprogram . '" -r'
  endif
  set ft=
  doautocmd filetypedetect BufReadPost
  let &mod = mod
endfunction

"---------------------------------------------------------------------------
" s:XxdFind: {{{3
"  parameters: None
"---------------------------------------------------------------------------
function! s:XxdFind()
  if !exists("g:xxdprogram")
    " On the PC xxd may not be in the path but in the install directory
    if (has("win32") || has("dos32")) && !executable("xxd")
      let g:xxdprogram = $VIMRUNTIME . (&shellslash ? '/' : '\') . "xxd.exe"
    else
      let g:xxdprogram = "xxd"
    endif
  endif
endfunction

if exists("s:toolsSpellingMenu")
  unlet s:toolsSpellingMenu
endif

"---------------------------------------------------------------------------
" forms#menu#MakeToolsSpellingMenu: {{{3
"   Returns menu
"    Example:
"        Spell Check On                  
"        Spell Check Off                 
"        To Next error ]s                
"        To Previous error [s            
"        Suggest Corrections z=          
"        Repeat correction :spellrepall  
"       ──────────────────────────────── 
"        Set language to "en"            
"        Set language to "en_au"         
"        Set language to "en_ca"         
"        Set language to "en_gb"         
"        Set language to "en_nz"         
"        SeT Compiler            Set language to "en_us"         
"
"  parameters: None
"---------------------------------------------------------------------------
function! forms#menu#MakeToolsSpellingMenu() 
"call forms#log("forms#menu#MakeToolsSpellingMenu TOP")
  if ! exists("s:toolsSpellingMenu")
    let spellingitems = []

    call add(spellingitems, { 
        \  'type': 'button',
        \  'label': '&Spell Check On',
        \  'command': ':set spell'
        \ })
    call add(spellingitems, { 
        \  'type': 'button',
        \  'label': 'Spell Check &Off',
        \  'command': ':set nospell'
        \ })
    call add(spellingitems, { 
        \  'type': 'button',
        \  'label': 'To &Next error',
        \  'hint': ']s',
        \  'command': ':normal ]s'
        \ })
    call add(spellingitems, { 
        \  'type': 'button',
        \  'label': 'To &Previous error',
        \  'hint': '[s',
        \  'command': ':normal [s'
        \ })
    call add(spellingitems, { 
        \  'type': 'button',
        \  'label': 'Suggest &Corrections',
        \  'hint': 'z=',
        \  'command': ':normal z='
        \ })
    call add(spellingitems, { 
        \  'type': 'button',
        \  'label': '&Repeat correction',
        \  'hint': ':spellrepall',
        \  'command': ':spellrepall'
        \ })

    call add(spellingitems, { 'type': 'separator' })

    call add(spellingitems, { 
        \  'type': 'button',
        \  'label': 'Set language to "&en"',
        \  'command': ':set spl=en spell'
        \ })
    call add(spellingitems, { 
        \  'type': 'button',
        \  'label': 'Set language to "en_&au"',
        \  'command': ':set spl=en_au spell'
        \ })
    call add(spellingitems, { 
        \  'type': 'button',
        \  'label': 'Set language to "en_&ca"',
        \  'command': ':set spl=en_ca spell'
        \ })
    call add(spellingitems, { 
        \  'type': 'button',
        \  'label': 'Set language to "en_&gb"',
        \  'command': ':set spl=en_gb spell'
        \ })
    call add(spellingitems, { 
        \  'type': 'button',
        \  'label': 'Set language to "en_&nz"',
        \  'command': ':set spl=en_nz spell'
        \ })
    call add(spellingitems, { 
        \  'type': 'button',
        \  'label': 'Set language to "en_&us"',
        \  'command': ':set spl=en_us spell'
        \ })

    " TODO &Find More Languages additional menu items
    let spellingsubattrs = { 'items': spellingitems }
    let s:toolsSpellingMenu = forms#newMenu(spellingsubattrs)
  endif

  return s:toolsSpellingMenu
endfunction

if exists("s:toolsFoldingMenu")
  unlet s:toolsFoldingMenu
endif

"---------------------------------------------------------------------------
" forms#menu#MakeToolsFoldingMenu: {{{3
"   Returns menu
"    Example:
"        Enable/Disable folds  zi     
"        View Cursor Line zv          
"        View Cursor Line only  zMzx  
"        Close more folds zm          
"        Close all folds  zM          
"        Open more folds  zr          
"        Open all folds  zR           
"       ───────────────────────────── 
"        Folding Method               
"        Delete Fold  zd              
"        Delete All Folds  zD         
"       ───────────────────────────── 
"        Fold column width            
"
"  parameters: None
"---------------------------------------------------------------------------
function! forms#menu#MakeToolsFoldingMenu() 
"call forms#log("forms#menu#MakeToolsFoldingMenu TOP")
  if ! exists("s:toolsFoldingMenu")
    let foldingitems = []

    " open close folds
    call add(foldingitems, { 
        \  'type': 'button',
        \  'label': '&Enable/Disable folds',
        \  'hint': 'zi',
        \  'command': ':normal zi'
        \ })
    call add(foldingitems, { 
        \  'type': 'button',
        \  'label': '&View Cursor Line',
        \  'hint': 'zv',
        \  'command': ':normal zv'
        \ })
    call add(foldingitems, { 
        \  'type': 'button',
        \  'label': 'Vie&w Cursor Line only',
        \  'hint': 'zMzx',
        \  'command': ':normal zMzx'
        \ })
    call add(foldingitems, { 
        \  'type': 'button',
        \  'label': 'C&lose more folds',
        \  'hint': 'zm',
        \  'command': ':normal zm'
        \ })
    call add(foldingitems, { 
        \  'type': 'button',
        \  'label': '&Close all folds',
        \  'hint': 'zM',
        \  'command': ':normal zM'
        \ })
    call add(foldingitems, { 
        \  'type': 'button',
        \  'label': 'O&pen more folds',
        \  'hint': 'zr',
        \  'command': ':normal zr'
        \ })
    call add(foldingitems, { 
        \  'type': 'button',
        \  'label': '&Open all folds',
        \  'hint': 'zR',
        \  'command': ':normal zR'
        \ })

    " fold method
    call add(foldingitems, { 'type': 'separator' })

    " TODO make lazy
    let foldingmethoditems = []
    call add(foldingmethoditems, { 
        \  'type': 'button',
        \  'label': 'M&anual',
        \  'command': ':set fdm=manual'
        \ })
    call add(foldingmethoditems, { 
        \  'type': 'button',
        \  'label': 'I&ndent',
        \  'command': ':set fdm=indent'
        \ })
    call add(foldingmethoditems, { 
        \  'type': 'button',
        \  'label': 'E&xpression',
        \  'command': ':set fdm=expr'
        \ })
    call add(foldingmethoditems, { 
        \  'type': 'button',
        \  'label': 'S&yntax',
        \  'command': ':set fdm=syntax'
        \ })
    call add(foldingmethoditems, { 
        \  'type': 'button',
        \  'label': '&Diff',
        \  'command': ':set fdm=diff'
        \ })
    call add(foldingmethoditems, { 
        \  'type': 'button',
        \  'label': 'Ma&rker',
        \  'command': ':set fdm=marker'
        \ })

    let foldingmethodsubattrs = { 'items': foldingmethoditems }
    let foldingmethodsubmenu = forms#newMenu(foldingmethodsubattrs)
    call add(foldingitems, { 
          \ 'type': 'menu',
          \ 'label': 'Folding Met&hod',
          \ 'menu': foldingmethodsubmenu
          \ })

    " create and delete folds

    " TODO 
    " vnoremenu 40.340.220 &Tools.&Folding.Create\ &Fold<Tab>zf zf
    call add(foldingitems, { 
        \  'type': 'button',
        \  'label': '&Delete Fold',
        \  'hint': 'zd',
        \  'command': ':normal zd'
        \ })
    call add(foldingitems, { 
        \  'type': 'button',
        \  'label': 'Delete &All Folds',
        \  'hint': 'zD',
        \  'command': ':normal zD'
        \ })

    " moving around in folds
    
    call add(foldingitems, { 'type': 'separator' })

    " TODO make lazy
    let foldingcolwidthitems = []

    call add(foldingcolwidthitems, { 
        \  'type': 'button',
        \  'label': ' &0',
        \  'command': ':set fdc=0'
        \ })
    call add(foldingcolwidthitems, { 
        \  'type': 'button',
        \  'label': ' &2',
        \  'command': ':set fdc=2'
        \ })
    call add(foldingcolwidthitems, { 
        \  'type': 'button',
        \  'label': ' &3',
        \  'command': ':set fdc=3'
        \ })
    call add(foldingcolwidthitems, { 
        \  'type': 'button',
        \  'label': ' &4',
        \  'command': ':set fdc=4'
        \ })
    call add(foldingcolwidthitems, { 
        \  'type': 'button',
        \  'label': ' &5',
        \  'command': ':set fdc=5'
        \ })
    call add(foldingcolwidthitems, { 
        \  'type': 'button',
        \  'label': ' &6',
        \  'command': ':set fdc=6'
        \ })
    call add(foldingcolwidthitems, { 
        \  'type': 'button',
        \  'label': ' &7',
        \  'command': ':set fdc=7'
        \ })
    call add(foldingcolwidthitems, { 
        \  'type': 'button',
        \  'label': ' &8',
        \  'command': ':set fdc=8'
        \ })


    let foldingcolwidthsubattrs = { 'items': foldingcolwidthitems }
    let foldingcolwidthsubmenu = forms#newMenu(foldingcolwidthsubattrs)

    call add(foldingitems, { 
          \ 'type': 'menu',
          \ 'label': 'Fold col&umn width',
          \ 'menu': foldingcolwidthsubmenu
          \ })

    let foldingsubattrs = { 'items': foldingitems }
    let s:toolsFoldingMenu = forms#newMenu(foldingsubattrs)

  endif

  return s:toolsFoldingMenu
endfunction

if exists("s:toolsDiffMenu")
  unlet s:toolsDiffMenu
endif

"---------------------------------------------------------------------------
" forms#menu#MakeToolsDiffMenu: {{{3
"   Returns menu
"    Example:
"        Update    
"        Get       
"        Put Back  
"
"  parameters: None
"---------------------------------------------------------------------------
function! forms#menu#MakeToolsDiffMenu() 
"call forms#log("forms#menu#MakeToolsDiffMenu TOP")
  if ! exists("s:toolsDiffMenu")
    " TODO visual mode menu options
    " TODO make lazy
    let diffitems = []

    call add(diffitems, { 
        \  'type': 'button',
        \  'label': ' &Update',
        \  'command': ':diffupdate'
        \ })
    call add(diffitems, { 
        \  'type': 'button',
        \  'label': ' &Get',
        \  'command': ':diffget'
        \ })
    call add(diffitems, { 
        \  'type': 'button',
        \  'label': ' &Put Back',
        \  'command': ':diffput'
        \ })

    let diffsubattrs = { 'items': diffitems }
    let s:toolsDiffMenu = forms#newMenu(diffsubattrs)
  endif

  return s:toolsDiffMenu
endfunction

if exists("s:toolsErrorWindowMenu")
  unlet s:toolsErrorWindowMenu
endif

"---------------------------------------------------------------------------
" forms#menu#MakeToolsErrorWindowMenu: {{{3
"   Returns menu
"    Example:
"        Update :cwin   
"        Open :copen    
"        Close :cclose  
"
"  parameters: None
"---------------------------------------------------------------------------
function! forms#menu#MakeToolsErrorWindowMenu() 
"call forms#log("forms#menu#MakeToolsErrorWindowMenu TOP")
  if ! exists("s:toolsErrorWindowMenu")
    let errorwinitems = []

    call add(errorwinitems, { 
          \ 'type': 'button',
          \ 'label': '&Update',
          \ 'hint': ':cwin',
          \ 'command': ':cwin'
          \ })
    call add(errorwinitems, { 
          \ 'type': 'button',
          \ 'label': '&Open',
          \ 'hint': ':copen',
          \ 'command': ':copen'
          \ })
    call add(errorwinitems, { 
          \ 'type': 'button',
          \ 'label': '&Close',
          \ 'hint': ':cclose',
          \ 'command': ':cclose'
          \ })

    let errorwinsubattrs = { 'items': errorwinitems }
    let s:toolsErrorWindowMenu = forms#newMenu(errorwinsubattrs)
  endif

  return s:toolsErrorWindowMenu
endfunction

"---------------------------------------------------------------------------
" forms#menu#MakeToolsCompilerMenu: {{{3
"   Returns menu
"    Example:
"        ant            
"        bcc            
"        bdf            
"        checkstyle     
"        ....
"        tex            
"        tidy           
"        xmllint        
"        xmlwf          
"
"  parameters: None
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("s:toolsCompilerMenu")
    unlet s:toolsCompilerMenu
  endif
endif
function! forms#menu#MakeToolsCompilerMenu() 

  if ! exists("s:toolsCompilerMenu")
    let items = []
    redraw
    :echo "NOTE: Loading Compiler menu takes time"

    let s:n = globpath(&runtimepath, "compiler/*.vim")
    while strlen(s:n) > 0
      let s:i = stridx(s:n, "\n")
      if s:i < 0
        let s:name = s:n
        let s:n = ""
      else
        let s:name = strpart(s:n, 0, s:i)
        let s:n = strpart(s:n, s:i + 1, 19999)
      endif
      " Ignore case for VMS and windows
      let s:name = substitute(s:name, '\c.*[/\\:\]]\([^/\\:]*\)\.vim', '\1', '')

      call add(items, { 
          \  'type': 'button',
          \  'label': s:name,
          \  'command': ':compiler '.s:name
          \ })

      unlet s:name
      unlet s:i
    endwhile
    unlet s:n


    let attrs = { 'items': items }
    let s:toolsCompilerMenu = forms#newMenu(attrs)
  endif

  return s:toolsCompilerMenu
endfunction

"---------------------------------------------------------------------------
" forms#menu#MakeToolsMenu: {{{3
"   Returns menu
"    Example:
"        Jump to this tag g^     
"        Jump back ^T            
"        Build Tags File         
"       ──────────────────────── 
"        Spelling                
"        Folding                 
"        Diff                    
"       ──────────────────────── 
"        Make :make              
"        List Errors :cl         
"        List Messages :cl!      
"        Next Error :cn          
"        Previous Error :cp      
"        Older List :cold        
"        Newer List :cnew        
"        Error Window            
"        SeT Compiler            
"        ──────────────────────── 
"        Convert to HEX  :%!xxd  
"        Convert back  %!xxd -r  
"
"  parameters: None
"---------------------------------------------------------------------------
function! forms#menu#MakeToolsMenu() 
"call forms#log("forms#menu#MakeToolsMenu TOP")
  if ! exists("s:toolsMenu")
    let items = []

    call add(items, { 
          \ 'type': 'button',
          \ 'label': '&Jump to this tag',
          \ 'hint': 'g^',
          \ 'command': ':normal g'
          \ })
    " TODO Jump to for vunmenu
    " TODO Jump to for vnoremenu
    
    call add(items, { 
          \ 'type': 'button',
          \ 'label': 'Jump &back',
          \ 'hint': '^T',
          \ 'command': ':normal '
          \ })
    call add(items, { 
          \ 'type': 'button',
          \ 'label': 'Build &Tags File',
          \ 'command': ':execute ! g:ctags_command'
          \ })
    
    if has("folding") || has("spell")
      call add(items, { 'type': 'separator' })
    endif

    if has("spell")
      let MakeToolsSpellingMenuFN = function("forms#menu#MakeToolsSpellingMenu")
      call add(items, { 
            \ 'type': 'menu',
            \ 'label': '&Spelling',
            \ 'menuFN': MakeToolsSpellingMenuFN
            \ })

    endif

    if has("folding")
      let MakeToolsFoldingMenuFN = function("forms#menu#MakeToolsFoldingMenu")
      call add(items, { 
            \ 'type': 'menu',
            \ 'label': '&Folding',
            \ 'menuFN': MakeToolsFoldingMenuFN
            \ })
    endif

    if has("diff")
      let MakeToolsDiffMenuFN = function("forms#menu#MakeToolsDiffMenu")
      call add(items, { 
            \ 'type': 'menu',
            \ 'label': '&Diff',
            \ 'menuFN': MakeToolsDiffMenuFN
            \ })
    endif

    call add(items, { 'type': 'separator' })

    call add(items, { 
          \ 'type': 'button',
          \ 'label': '&Make',
          \ 'hint': ':make',
          \ 'command': ':make'
          \ })
    call add(items, { 
          \ 'type': 'button',
          \ 'label': '&List Errors',
          \ 'hint': ':cl',
          \ 'command': ':cl'
          \ })
    call add(items, { 
          \ 'type': 'button',
          \ 'label': 'L&ist Messages',
          \ 'hint': ':cl!',
          \ 'command': ':cl!'
          \ })
    call add(items, { 
          \ 'type': 'button',
          \ 'label': '&Next Error',
          \ 'hint': ':cn',
          \ 'command': ':cn'
          \ })
    call add(items, { 
          \ 'type': 'button',
          \ 'label': '&Previous Error',
          \ 'hint': ':cp',
          \ 'command': ':cp'
          \ })
    call add(items, { 
          \ 'type': 'button',
          \ 'label': '&Older List',
          \ 'hint': ':cold',
          \ 'command': ':colder'
          \ })
    call add(items, { 
          \ 'type': 'button',
          \ 'label': 'N&ewer List',
          \ 'hint': ':cnew',
          \ 'command': ':cnewer'
          \ })


    let MakeToolsErrorWindowMenuFN = function("forms#menu#MakeToolsErrorWindowMenu")
    call add(items, { 
          \ 'type': 'menu',
          \ 'label': 'Error &Window',
          \ 'menuFN': MakeToolsErrorWindowMenuFN
          \ })


    let MakeToolsCompilerMenuFN = function("forms#menu#MakeToolsCompilerMenu")
    call add(items, { 
          \ 'type': 'menu',
          \ 'label': 'Se&T Compiler',
          \ 'menuFN': MakeToolsCompilerMenuFN
          \ })

   call add(items, { 'type': 'separator' })

    call add(items, { 
          \ 'type': 'button',
          \ 'label': '&Convert to HEX',
          \ 'hint': ':%!xxd',
          \ 'command': ':call s:XxdConv()'
          \ })
    call add(items, { 
          \ 'type': 'button',
          \ 'label': 'Conve&rt back',
          \ 'hint': '%!xxd -r',
          \ 'command': ':call s:XxdBack()'
          \ })


    let attrs = { 'items' : items }
    let s:toolsMenu = forms#newMenu(attrs)
  endif

  return s:toolsMenu
endfunction

"-------------------------------------------------------------------------------
" Syntax Menu: {{{2
"-------------------------------------------------------------------------------
if exists("s:syntaxMenu")
  unlet s:syntaxMenu
  unlet did_install_syntax_menu
endif

let s:syntax_on = exists('syntax_on')

"---------------------------------------------------------------------------
" g:SynOnOff: {{{3
"   Toggle syntax on/off
"  parameters: None
"---------------------------------------------------------------------------
function! g:SynOnOff() 
  if has("syntax_items")
    syn clear
  else
    if !exists("g:syntax_on")
      syn manual
    endif
    set syn=ON
  endif
endfunction

"---------------------------------------------------------------------------
" forms#menu#MakeSyntaxMenu: {{{3
"   Returns menu
"    Example:
"        Show filetypes in menu  
"       ──────────────────────── 
"        Off                     
"        Manual                  
"        Automatic               
"        on/off for This file    
"       ──────────────────────── 
"        Color test              
"        Highlight test          
"        Convert to HTML         
"
"  parameters: None
"---------------------------------------------------------------------------
function! forms#menu#MakeSyntaxMenu() 
"call forms#log("forms#menu#MakeSyntaxMenu TOP")
  if ! exists("s:syntaxMenu")
    let items = []

    let flag = (exists("did_load_filetypes") || exists("s:syntax_on"))
          \ && !exists("did_install_syntax_menu")


" call forms#log("forms#menu#MakeSyntaxMenu exists(s:syntax_on)=" .  exists("s:syntax_on"))
" call forms#log("forms#menu#MakeSyntaxMenu exists(did_install_syntax_menu)=" .  exists("did_install_syntax_menu"))
" call forms#log("forms#menu#MakeSyntaxMenu flag=" . flag)
    if flag
      call add(items, { 
            \ 'type': 'button',
            \ 'label': '&Show filetypes in menu',
            \ 'command': ':echo "NOT IMPLEMENTED"'
            \ })

      call add(items, { 'type': 'separator' })

      call add(items, { 
            \ 'type': 'button',
            \ 'label': '&Off',
            \ 'command': ':syn off'
            \ })
    endif

    if !exists("did_install_syntax_menu")
      call add(items, { 
            \ 'type': 'button',
            \ 'label': '&Manual',
            \ 'command': ':syn manual'
            \ })
      call add(items, { 
            \ 'type': 'button',
            \ 'label': 'A&utomatic',
            \ 'command': ':syn on'
            \ })
      call add(items, { 
            \ 'type': 'button',
            \ 'label': 'on/off for &This file',
            \ 'command': ':call g:SynOnOff()'
            \ })
    endif

    if flag
      let did_install_syntax_menu = 1

      call add(items, { 'type': 'separator' })
      call add(items, { 
            \ 'type': 'button',
            \ 'label': 'Co&lor test',
            \ 'command': ':sp $VIMRUNTIME/syntax/colortest.vim|so %'
            \ })
      call add(items, { 
            \ 'type': 'button',
            \ 'label': '&Highlight test',
            \ 'command': ':runtime syntax/hitest.vim'
            \ })
      call add(items, { 
            \ 'type': 'button',
            \ 'label': '&Convert to HTML',
            \ 'command': ':runtime syntax/2html.vim'
            \ })
    endif


    let attrs = { 'items' : items }
    let s:syntaxMenu = forms#newMenu(attrs)
  endif

  return s:syntaxMenu
endfunction
 
"-------------------------------------------------------------------------------
" Buffers Menu: {{{2
"-------------------------------------------------------------------------------
if exists("s:buffersMenu")
  unlet s:buffersMenu
endif

"---------------------------------------------------------------------------
" g:ReLoadBuffersMenu: {{{3
"   Reloads the load buffers menu
"  parameters: None
"---------------------------------------------------------------------------
function! g:ReLoadBuffersMenu() 
  if exists("s:menubarform")
"call forms#log("ReLoadBuffersMenu TOP")
    " This force menubar button's action associated with Buffers to 
    " unlet action.menu
    " which will force the regeneration of the dropdown menu

    " NOTE
    " This is fragile code, it assumes that the menubarform's
    " body is a menubar which has children one of which has as a tag
    " the label "Buffers" (without the '&').
    for child in s:menubarform.__body.__children
      let tag = child.getTag()
" call forms#log("ReLoadBuffersMenu tag=" . tag)
      if tag == "Buffers"
        " Only works if the menu create function is (still) defined
        if exists("child.__action.menuFN")
          unlet child.__action.menu
        endif
        break
      endif
    endfor
  endif
endfunction


"---------------------------------------------------------------------------
" s:AddBuffer: {{{3
"   Insert a buffer name into the buffer menu items list
"  parameters: 
"   name  : name of buffer
"   num   : number associated with menu item
"   items : menu item List to add new item to
"---------------------------------------------------------------------------
function! s:AddBuffer(name, num, items)
  let foo = 1
  let label = a:name . '&' . a:num
  call add(a:items, { 
        \ 'type': 'button',
        \ 'label': label,
        \ 'command': ':b!'.a:num
        \ })
endfunction

"---------------------------------------------------------------------------
" forms#menu#MakeBuffersMenu: {{{3
"   Returns menu
"    Example:
"        Refresh menu  
"        Delete        
"        Alternate     
"        Next          
"        Previous      
"       ────────────── 
"        SCREEN1       
"
"  parameters: None
"---------------------------------------------------------------------------
function! forms#menu#MakeBuffersMenu() 
"call forms#log("forms#menu#MakeBuffersMenu TOP")
  if ! exists("s:buffersMenu")
    let items = []

    call add(items, { 
          \ 'type': 'button',
          \ 'label': '&Refresh menu',
          \ 'command': ':call g:ReLoadBuffersMenu()'
          \ })
    call add(items, { 
          \ 'type': 'button',
          \ 'label': '&Delete',
          \ 'command': ':bd!'
          \ })
    call add(items, { 
          \ 'type': 'button',
          \ 'label': '&Alternate',
          \ 'command': ':b! #'
          \ })
    call add(items, { 
          \ 'type': 'button',
          \ 'label': '&Next',
          \ 'command': ':bnext!'
          \ })
    call add(items, { 
          \ 'type': 'button',
          \ 'label': '&Previous',
          \ 'command': ':bprev!'
          \ })

    call add(items, { 'type': 'separator' })

    " figure out how many buffers there are
    let cnt = 1
    while cnt <= bufnr('$')
      if bufexists(cnt) && !isdirectory(bufname(cnt)) && buflisted(cnt)
        call <SID>AddBuffer(bufname(cnt), cnt, items)
      endif

      let cnt += 1
    endwhile
  
    let attrs = { 'items' : items }
    let s:buffersMenu = forms#newMenu(attrs)
  endif

  return s:buffersMenu
endfunction

"-------------------------------------------------------------------------------
" Window Menu: {{{2
"-------------------------------------------------------------------------------
if exists("s:windowMenu")
  unlet s:windowMenu
endif

"---------------------------------------------------------------------------
" forms#menu#MakeWindowMenu: {{{3
"   Returns menu
"    Example:
"        New ^Wn               
"        Split ^Ws             
"        Split To # ^W^^       
"        Split Vertically ^Wv  
"        Split File Explorer   
"       ────────────────────── 
"        Close ^Wc             
"        Close Others ^Wo      
"       ────────────────────── 
"        Move To               
"        Rotate Up ^WR         
"        Rotate Down ^Wr       
"       ────────────────────── 
"        Equal Size ^W=        
"        Max Height ^W_        
"        Min Height ^W1_       
"        Max Width ^W|         
"        Min Width ^W1|        
"
"  parameters: None
"---------------------------------------------------------------------------
function! forms#menu#MakeWindowMenu() 
"call forms#log("forms#menu#MakeWindowMenu TOP")
  if ! exists("s:windowMenu")
    let items = []

    call add(items, { 
          \ 'type': 'button',
          \ 'label': '&New',
          \ 'hint': '^Wn',
          \ 'command': ':new'
          \ })
    call add(items, { 
          \ 'type': 'button',
          \ 'label': 'S&plit',
          \ 'hint': '^Ws',
          \ 'command': ':split'
          \ })
    call add(items, { 
          \ 'type': 'button',
          \ 'label': 'Sp&lit To #',
          \ 'hint': '^W^^',
          \ 'command': ':split #'
          \ })
    call add(items, { 
          \ 'type': 'button',
          \ 'label': 'Split &Vertically',
          \ 'hint': '^Wv',
          \ 'command': ':vsplit'
          \ })

    if has("vertsplit") 
      " TODO since our menu is per buffer, can we evaluate the
      " function right now.
      if !exists("*MenuExplOpen")
        function MenuExplOpen()
          if @% == ""
            20vsp .                                       
          else
            execute "20vsp " . s:FnameEscape(expand("%:p:h"))
          endif     
        endfunction      
      endif
      call add(items, { 
            \ 'type': 'button',
            \ 'label': 'Split File E&xplorer',
            \ 'command': ':call MenuExplOpen()'
            \ })
    endif

    call add(items, { 'type': 'separator' })

    call add(items, { 
          \ 'type': 'button',
          \ 'label': '&Close',
          \ 'hint': '^Wc',
          \ 'command': ':confirm close'
          \ })
    call add(items, { 
          \ 'type': 'button',
          \ 'label': 'Close &Others',
          \ 'hint': '^Wo',
          \ 'command': ':confirm only'
          \ })

    call add(items, { 'type': 'separator' })

    let movetosubattrs = {
        \ 'items' : [
        \ { 'type': 'button',
        \   'label': '&Top',
        \   'hint': '^WK',
        \   'command': ':normal K'
        \ },
        \ { 'type': 'button',
        \   'label': '&Bottom',
        \   'hint': '^WJ',
        \   'command': ':normal J'
        \ },
        \ { 'type': 'button',
        \   'label': '&Left side',
        \   'hint': '^WH',
        \   'command': ':normal H'
        \ },
        \ { 'type': 'button',
        \   'label': '&Right sideL',
        \   'hint': '^WL',
        \   'command': ':normal L'
        \ }
        \ ]
        \ }
    let movetosubmenu = forms#newMenu(movetosubattrs)
    call add(items, { 
          \ 'type': 'menu',
          \ 'label': 'Move &To',
          \ 'menu': movetosubmenu
          \ })

    call add(items, { 
          \ 'type': 'button',
          \ 'label': 'Rotate &Up',
          \ 'hint': '^WR',
          \ 'command': ':normal R'
          \ })
    call add(items, { 
          \ 'type': 'button',
          \ 'label': 'Rotate &Down',
          \ 'hint': '^Wr',
          \ 'command': ':normal r'
          \ })

    call add(items, { 'type': 'separator' })

    call add(items, { 
          \ 'type': 'button',
          \ 'label': '&Equal Size',
          \ 'hint': '^W=',
          \ 'command': ':normal ='
          \ })
    call add(items, { 
          \ 'type': 'button',
          \ 'label': '&Max Height',
          \ 'hint': '^W_',
          \ 'command': ':normal _'
          \ })
    call add(items, { 
          \ 'type': 'button',
          \ 'label': 'M&in Height',
          \ 'hint': '^W1_',
          \ 'command': ':normal 1_'
          \ })
    call add(items, { 
          \ 'type': 'button',
          \ 'label': 'Max &Width',
          \ 'hint': '^W|',
          \ 'command': ':normal \|'
          \ })
    call add(items, { 
          \ 'type': 'button',
          \ 'label': 'Min Widt&h',
          \ 'hint': '^W1|',
          \ 'command': ':normal 1\|'
          \ })

    let attrs = { 'items' : items }
    let s:windowMenu = forms#newMenu(attrs)
  endif

  return s:windowMenu
endfunction

"-------------------------------------------------------------------------------
" Help Menu: {{{2
"-------------------------------------------------------------------------------
if exists("s:helpMenu")
  unlet s:helpMenu
endif

"---------------------------------------------------------------------------
" forms#menu#MakeHelpMenu: {{{3
"   Returns menu
"    Example:
"        Overview          
"        User Manual       
"        How-to links      
"        Find...           
"       ────────────────── 
"        Credits           
"        Copying           
"        Sponsor/Register  
"        Orphans           
"       ────────────────── 
"        Version           
"        About             
"
"  parameters: None
"---------------------------------------------------------------------------
function! forms#menu#MakeHelpMenu() 
"call forms#log("forms#menu#MakeHelpMenu TOP")
  if ! exists("s:helpMenu")
    let attrsHelp = {
          \ 'items' : [
          \ { 'type': 'button',
          \   'label': '&Overview',
          \   'command': ':help'
          \ },
          \ { 'type': 'button',
          \   'label': '&User Manual',
          \   'command': ':help usr_toc'
          \ },
          \ { 'type': 'button',
          \   'label': '&How-to links',
          \   'command': ':help how-to'
          \ },
          \ { 'type': 'button',
          \   'label': '&Find...',
          \   'command': ':call g:HelpFind()'
          \ },
          \ { 'type': 'separator' },
          \ { 'type': 'button',
          \   'label': '&Credits',
          \   'command': ':help credits'
          \ },
          \ { 'type': 'button',
          \   'label': 'Co&pying',
          \   'command': ':help copying'
          \ },
          \ { 'type': 'button',
          \   'label': '&Sponsor/Register',
          \   'command': ':help sponsor'
          \ },
          \ { 'type': 'button',
          \   'label': 'O&rphans',
          \   'command': ':help kcc'
          \ },
          \ { 'type': 'separator' },
          \ { 'type': 'button',
          \   'label': '&Version',
          \   'command': ':version'
          \ },
          \ { 'type': 'button',
          \   'label': '&About',
          \   'command': ':intro'
          \ }
          \ ]
          \ }

    let s:helpMenu = forms#newMenu(attrsHelp)
  endif

  return s:helpMenu
endfunction


"-------------------------------------------------------------------------------
"-------------------------------------------------------------------------------
" MenuBar: {{{2
"-------------------------------------------------------------------------------
"-------------------------------------------------------------------------------


if exists("s:menubarform")
  unlet s:menubarform
endif
 
"---------------------------------------------------------------------------
" forms#menu#MakeMenu: {{{3
"   Returns menu bar
"    Example:
"        File Edit Tools Syntax Buffers Window Help 
"
"  parameters: 
"    mode: either 'v' (visual) or 'n' (normal)
"---------------------------------------------------------------------------
function! forms#menu#MakeMenu(mode) range
"call forms#log("forms#menu#MakeMenu TOP " . a:mode)

  if a:mode == 'n'
    if exists("s:firstline")
      unlet s:firstline
      unlet s:firstcol
      unlet s:lastline
      unlet s:lastcol
      unlet s:visualmode
    endif
  elseif a:mode == 'v'
    let s:firstline = a:firstline
    let s:firstcol = col("'<")
    let s:lastline = a:lastline
    let s:lastcol = col("'>")
    let s:visualmode = visualmode()
  else
    call forms#log("forms#menu#MakeMenu: unknown mode argument: ". a:mode)
  endif

  if ! exists("s:menubarform")

    let MenuFileFN = function("forms#menu#MakeFileMenu")
    let MenuEditFN = function("forms#menu#MakeEditMenu")
    let MenuToolsFN = function("forms#menu#MakeToolsMenu")
    let MenuSyntaxFN = function("forms#menu#MakeSyntaxMenu")
    let MenuBuffersFN = function("forms#menu#MakeBuffersMenu")
    let MenuWindowFN = function("forms#menu#MakeWindowMenu")
    let MenuHelpFN = function("forms#menu#MakeHelpMenu")

    let menus = []
    call add(menus, { 'label': '&File', 'menuFN': MenuFileFN })
    call add(menus, { 'label': '&Edit', 'menuFN': MenuEditFN })
    call add(menus, { 'label': '&Tools', 'menuFN': MenuToolsFN })
    call add(menus, { 'label': '&Syntax', 'menuFN': MenuSyntaxFN })
    if !exists("no_buffers_menu")
      call add(menus, { 'label': '&Buffers', 'menuFN': MenuBuffersFN })
    endif
    call add(menus, { 'label': '&Window', 'menuFN': MenuWindowFN })
    call add(menus, { 'label': '&Help', 'menuFN': MenuHelpFN })

    let attrsMenuBar = { 'menus' : menus }
    let menubar = forms#newMenuBar(attrsMenuBar)
    function! menubar.purpose() dict
      return [
           \ "This is a Forms-based version of the GVim menubar.",
           \ "  Nearly all of the capabilities of the GVim version are",
           \ "  duplicated here.",
           \ "  This serves both as a demonstration of the flexibility",
           \ "  of the Forms library as well as a usable extension to a",
           \ "  console-based Vim environment."
           \ ]
    endfunction

    let attrsForm = {
          \ 'delete': '0',
          \ 'halignment': 'L',
          \ 'valignment': 'T',
          \ 'body': menubar
          \ }
    let s:menubarform = forms#newForm(attrsForm)
  endif

  call s:menubarform.run()
endfunction

" forms#menu#MakeMenuTest: {{{3
function! forms#menu#MakeMenuTest() range
  call forms#AppendInput({'type': 'Sleep', 'time': 5})
  call forms#AppendInput({'type': 'Exit'})
  call forms#menu#MakeMenu('n')
endfunction

"-------------------------------------------------------------------------------
"-------------------------------------------------------------------------------
" PopUp: {{{1
"-------------------------------------------------------------------------------
"-------------------------------------------------------------------------------

if exists("s:popupform")
  unlet s:popupform
endif


if exists("s:firstline")
  unlet s:firstline
endif
if exists("s:firstcol")
  unlet s:firstcol
endif
if exists("s:lastline")
  unlet s:lastline
endif
if exists("s:lastcol")
  unlet s:lastcol
endif
if exists("s:visualmode")
  unlet s:visualmode
endif

if !exists("g:yank_register_char")
  let g:yank_register_char = 'a'
endif

"---------------------------------------------------------------------------
" SpellReplace: {{{2
"   Replace word with nth spelling suggestion
"  parameters: 
"    n : nth spelling suggestion
"---------------------------------------------------------------------------
function! SpellReplace(n) 
"call forms#log("SpellReplace TOP n=".a:n)
  let l = getline('.')
  " Move the cursor to the start of the word.
  call spellbadword()
  call setline('.', strpart(l, 0, col('.') - 1) .  s:suglist[a:n - 1]
    \ . strpart(l, col('.') + len(s:fromword) - 1))
endfunction

"---------------------------------------------------------------------------
" forms#menu#MakePopUpMenuSpelling: {{{2
"   Returns menu 
"    Example:
"        1 acids  
"        2 acid   
"        3 and    
"        4 ask    
"        5 add    
"        6 as     
"        7 adv    
"        8 asst   
"        9 aside  
"        10 sad   
"
"  parameters: None
"---------------------------------------------------------------------------
function! forms#menu#MakePopUpMenuSpelling() 
"call forms#log("forms#menu#MakePopUpMenuSpelling TOP")
  let curcol = col('.')
  let [w, a] = [s:spellingword, s:spellingattribute]
  if col('.') > curcol    " don't use word after the cursor
    let w = ''
  endif

  let items = []

"call forms#log("forms#menu#MakePopUpMenuSpelling w=".w)

  if w == ''
    call add(items, { 'type': 'separator', 'status': g:IS_INVISIBLE })
  else
    let s:suglist = (a == 'caps') 
        \ ? [substitute(w, '.*', '\u&', '')] : spellsuggest(w, 10)
"call forms#log("forms#menu#MakePopUpMenuSpelling s:suglist=".string(s:suglist))
    if len(s:suglist) > 0
      " let s:changeitem = 'change\ "' . escape(w, ' .'). '"\ to'
      let s:fromword = w
      let cnt = 1
      for sug in s:suglist
        let s = escape(sug, ' .')
"call forms#log("forms#menu#MakePopUpMenuSpelling s=".s)
        call add(items, { 
              \ 'type': 'button',
              \ 'label': '&'.cnt.' '.s ,
              \ 'command': ':call SpellReplace('. cnt . ')'
              \ })

        let cnt += 1
      endfor
    else
      call add(items, { 'type': 'separator', 'status': g:IS_INVISIBLE })
    endif
  endif

  call cursor(0, curcol)  " put the cursor back where it was

  let attrs = { 'items': items }
  let submenu = forms#newMenu(attrs)
  return submenu
endfunction

"---------------------------------------------------------------------------
" g:CutCopyRange: {{{2
"   Cut or Copy a visual range
"  parameters: 
"    op : 'x' (cut) or 'y' (copy)
"---------------------------------------------------------------------------
function! g:CutCopyRange(op)
"call forms#log("CutCopyRange TOP")
  if exists("s:firstline")
"call forms#log("CutCopyRange vmode=" . s:visualmode)
    let reg = g:yank_register_char
    if s:visualmode == 'v'
      " delete from start char/line to end char/line
      if s:firstline == s:lastline
        execute s:firstline
        if s:firstcol <= 1
          execute 'norm! v0'.s:lastcol.'l"'.reg.a:op
        else
          execute 'norm! 0'.(s:firstcol-1).'lv'.(s:lastcol-s:firstcol).'l"'.reg.a:op
        endif
      else
        execute s:firstline
        if s:firstcol <= 1
          execute 'norm! v0'.(s:lastline-s:firstline).'j's:lastcol.'l"'.reg.a:op
        elseif s:firstcol < s:lastcol
          execute 'norm! 0'.(s:firstcol-1).'lv'.(s:lastline-s:firstline).'j'.(s:lastcol-s:firstcol).'l"'.reg.a:op
        elseif s:firstcol == s:lastcol
          execute 'norm! 0'.(s:firstcol-1).'lv'.(s:lastline-s:firstline).'j"'.reg.a:op
        else
          execute 'norm! 0'.(s:firstcol-1).'lv'.(s:lastline-s:firstline).'j'.(s:firstcol-s:lastcol).'h"'.reg.a:op
        endif
      endif

    elseif s:visualmode == 'V'
      " delete lines
      if s:firstline == s:lastline
        execute s:firstline
        execute 'norm! V$"'.reg.a:op
      else
        execute s:firstline
        execute ':normal V'.(s:lastline-s:firstline).'j"'.reg.a:op
      endif
    elseif s:visualmode == ''
      " delete block
      if s:firstline == s:lastline
        execute s:firstline
        if s:firstcol <= 1
          execute 'norm! v0'.s:lastcol.'l"'.reg.a:op
        else
          execute 'norm! 0'.(s:firstcol-1).'lv'.(s:lastcol-s:firstcol).'l"'.reg.a:op
        endif
      else
        execute s:firstline
        if s:firstcol <= 1
          if s:lastcol <= 1
            execute 'norm! 0'.(s:lastline-s:firstline).'j"'.reg.a:op
          else
            execute 'norm! 0'.(s:lastline-s:firstline).'j'.(s:lastcol-1).'l"'.reg.a:op
          endif
        elseif s:firstcol < s:lastcol
          execute 'norm! 0'.(s:firstcol-1).'l'.(s:lastline-s:firstline).'j'.(s:lastcol-s:firstcol).'l"'.reg.a:op
        elseif s:firstcol == s:lastcol
          execute 'norm! 0'.(s:firstcol-1).'l'.(s:lastline-s:firstline).'j"'.reg.a:op
        else
          execute 'norm! 0'.(s:firstcol-1).'l'.(s:lastline-s:firstline).'j'.(s:firstcol-s:lastcol).'h"'.reg.a:op
        endif
      endif

    else
      throw "CutCopyRange: bad visual mode: " . string(s:visualmode)
    endif

  endif
endfunction

"---------------------------------------------------------------------------
" g:SelectItem: {{{2
"   Select based upon operation parameter
"  parameters: 
"    op : 'w' (word), 's' (sentence), 'p' (paragraph), 'l' (line), or 
"         'b' (block)
"---------------------------------------------------------------------------
function! g:SelectItem(op)
"call forms#log("SelectItem TOP")
  if exists("s:firstline")
    execute s:lastline
    if s:lastcol <= 1
      execute 'norm! v'.s:lastcol
    else
      execute 'norm! 0'.s:lastcol.'lv'
    endif
    if a:op == 'w'
      execute ":normal \<C-C>vaw"
    elseif a:op == 's'
      execute ":normal \<C-C>vas"
    elseif a:op == 'p'
      execute ":normal \<C-C>vap"
    elseif a:op == 'l'
      execute ":normal \<C-C>V"
    elseif a:op == 'b'
      execute ":normal \<C-C>\<C-V>"
    else
      throw "SelectItem: bad operation: " . string(a:op)
    endif
  else
    if a:op == 'w'
      execute ":normal vaw"
    elseif a:op == 's'
      execute ":normal vas"
    elseif a:op == 'p'
      execute ":normal vap"
    elseif a:op == 'l'
      execute ":normal V"
    elseif a:op == 'b'
      execute ":normal "
    else
      throw "SelectItem: bad operation: " . string(a:op)
    endif
  endif
endfunction

"---------------------------------------------------------------------------
" menu#SelectAll: {{{2
"   Select allbased upon operation parameter
"  parameters: None
"---------------------------------------------------------------------------
function! menu#SelectAll()
  silent execute "normal! gg" . (&slm == "" ? "VG" : "gH\<C-O>G")
endfunction

"---------------------------------------------------------------------------
" forms#menu#MakePopUp: {{{2
"   Returns menu
"    Example:
"        change "asdf" to         
"        add "asdf" to word list  
"        ignore "asdf"            
"       ───────────────────────── 
"        Undo                   
"       ─────────────────────── 
"        Paste                  
"        Delete                 
"       ─────────────────────── 
"        Select Word            
"        Select Sentence        
"        Select Paragraph       
"        Select Line            
"        Select Block           
"        Select All             
"
"  parameters: 
"    mode : 'n' (normal) or 'v' (visual)
"---------------------------------------------------------------------------
function! forms#menu#MakePopUp(mode) range
"call forms#log("forms#menu#MakePopUp TOP " . a:mode)
" call forms#log("forms#menu#MakePopUp: visualmode<".visualmode()."> range[".a:firstline.",".a:lastline."] visrange[".line("'<").",".line("'>")."]")
"call forms#log("forms#menu#MakePopUp: mode<".mode().">")
"call forms#log("forms#menu#MakePopUp: visualmode<".visualmode()."> range[".a:firstline.",".a:lastline."] visrange[".col("'<").",".col("'>")."]")

  if a:mode == 'n'
    if exists("s:firstline")
      unlet s:firstline
      unlet s:firstcol
      unlet s:lastline
      unlet s:lastcol
      unlet s:visualmode
    endif
  elseif a:mode == 'v'
    let s:firstline = a:firstline
    let s:firstcol = col("'<")
    let s:lastline = a:lastline
    let s:lastcol = col("'>")
    let s:visualmode = visualmode()
" call forms#log("forms#menu#MakePopUp s:firstline=" . s:firstline)
" call forms#log("forms#menu#MakePopUp s:lastline=" . s:lastline)
" call forms#log("forms#menu#MakePopUp s:firstcol=" . s:firstcol)
" call forms#log("forms#menu#MakePopUp s:lastcol=" . s:lastcol)
  else
    call forms#log("forms#menu#MakePopUp: unknown mode argument: ". a:mode)
  endif

  if ! exists("s:popupform")
"call forms#log("forms#menu#MakePopUp: make s:popupform")
    let popupitems = []

    " TODO command mode
" call forms#log("forms#menu#MakePopUp: spell=". has("spell"))

    if has("spell")
" call forms#log("forms#menu#MakePopUp: do spell")

      let PopUpMenuSpellingFN = function("forms#menu#MakePopUpMenuSpelling")

      let s:spellchangelabel = forms#newLabel({'text': '&change word to'})
      call add(popupitems, { 
            \ 'type': 'menu',
            \ 'label': s:spellchangelabel,
            \ 'menuFN': PopUpMenuSpellingFN
            \ })

      let s:spelladdlabel = forms#newLabel({'text': '&add word to word list'})
      call add(popupitems, { 
            \ 'type': 'button',
            \ 'label': s:spelladdlabel,
            \ 'command': ':spellgood word'
            \ })

      let s:spellignorelabel = forms#newLabel({'text': '&ignore  word'})
      call add(popupitems, { 
            \ 'type': 'button',
            \ 'label': s:spellignorelabel,
            \ 'command': ':spellgood! word'
            \ })
      call add(popupitems, { 'type': 'separator', 'status': g:IS_INVISIBLE })
    endif

    " menu item 0
    call add(popupitems, { 
          \ 'type': 'button',
          \ 'label': '&Undo',
          \ 'command': 'u'
          \ })

    " menu item 1
    call add(popupitems, { 'type': 'separator' })

    " menu item 2
    let s:popup_menu_item_cnt_pos = has("spell") ? 6 : 2
    call add(popupitems, { 
          \ 'type': 'button',
          \ 'label': 'Cu&t',
          \ 'command': ':call g:CutCopyRange("x")'
          \ })
    " menu item 3
    call add(popupitems, { 
          \ 'type': 'button',
          \ 'label': '&Copy',
          \ 'command': ':call g:CutCopyRange("y")'
          \ })
    call add(popupitems, { 
          \ 'type': 'button',
          \ 'label': '&Paste',
          \ 'command': '"'.g:yank_register_char.'gP'
          \ })
    call add(popupitems, { 
          \ 'type': 'button',
          \ 'label': '&Delete',
          \ 'command': 'x'
          \ })

    call add(popupitems, { 'type': 'separator' })

    call add(popupitems, { 
          \ 'type': 'button',
          \ 'label': 'Select &Word',
          \ 'command': ':call g:SelectItem("w")'
          \ })
    call add(popupitems, { 
          \ 'type': 'button',
          \ 'label': 'Select &Sentence',
          \ 'command': ':call g:SelectItem("s")'
          \ })
    call add(popupitems, { 
          \ 'type': 'button',
          \ 'label': 'Select Pa&ragraph',
          \ 'command': ':call g:SelectItem("p")'
          \ })
    call add(popupitems, { 
          \ 'type': 'button',
          \ 'label': 'Select &Line',
          \ 'command': ':call g:SelectItem("l")'
          \ })
    call add(popupitems, { 
          \ 'type': 'button',
          \ 'label': 'Select &Block',
          \ 'command': ':call g:SelectItem("b")'
          \ })
    call add(popupitems, { 
          \ 'type': 'button',
          \ 'label': 'Select &All',
          \ 'command': ':call menu#SelectAll()'
          \ })

    let attrsPopUp = { 'items': popupitems }
    let s:popupmenu = forms#newMenu(attrsPopUp)
    function! s:popupmenu.purpose() dict
      return [
           \ "This is a Forms-based version of the GVim popup menu.",
           \ "  Nearly all of the capabilities of the GVim version are",
           \ "  duplicated here.",
           \ "  This serves both as a demonstration of the flexibility",
           \ "  of the Forms library as well as a usable extension to a",
           \ "  console-based Vim environment."
           \ ]
    endfunction

    let attrsForm = {
          \ 'delete': '0',
          \ 'body': s:popupmenu
          \ }
    let s:popupform = forms#newForm(attrsForm)
  endif

  if has("spell")
" call forms#log("forms#menu#MakePopUp: &spell=" . string(&spell))
" call forms#log("forms#menu#MakePopUp: &spelllang=" . string(&spelllang))

    if !&spell || &spelllang == ''
" call forms#log("forms#menu#MakePopUp: spell IS_INVISIBLE")
      call s:popupmenu.setChildStatus(0, g:IS_INVISIBLE)
      call s:popupmenu.setChildStatus(1, g:IS_INVISIBLE)
      call s:popupmenu.setChildStatus(2, g:IS_INVISIBLE)
      call s:popupmenu.setChildStatus(3, g:IS_INVISIBLE)
    else
" call forms#log("forms#menu#MakePopUp: spell INVISIBLE")

      if a:mode == 'n'
        let curcol = col('.')
        let [w, a] = spellbadword()
        call cursor(0, curcol)
      elseif a:mode == 'v'
        call cursor(s:firstline, s:firstcol)
        let [w, a] = spellbadword()
        call cursor(s:firstline, s:firstcol)
      endif
" call forms#log("forms#menu#MakePopUp: [w,a]=".string([w,a]))

      if w == ''
        call s:popupmenu.setChildStatus(0, g:IS_INVISIBLE)
        call s:popupmenu.setChildStatus(1, g:IS_INVISIBLE)
        call s:popupmenu.setChildStatus(2, g:IS_INVISIBLE)
        call s:popupmenu.setChildStatus(3, g:IS_INVISIBLE)
      else
        let s:spellingword = w
        let s:spellingattribute = a

        call s:popupmenu.setChildStatus(0, g:IS_ENABLED)
        call s:popupmenu.setChildStatus(1, g:IS_ENABLED)
        call s:popupmenu.setChildStatus(2, g:IS_ENABLED)
        call s:popupmenu.setChildStatus(3, g:IS_ENABLED)

        let s:spellchangelabel.__text = 'change "'.w.'" to'
        let s:spelladdlabel.__text = 'add "'.w.'" to word list'
        let s:spellignorelabel.__text = 'ignore "'.w.'"'

        " remove previously created submenu if it exists
        let changeToChild = s:popupmenu.__children[0]

        if exists("changeToChild.__children")
  call forms#log("forms#menu#MakePopUp: changeToChild.__children EXISTS")
          for c in changeToChild.__children
            if exists("c.__action.submenu")
  call forms#log("forms#menu#MakePopUp: c.__action.submenu FOUND")
              unlet c.__action.submenu
              break
            endif
          endfor
        else
  call forms#log("forms#menu#MakePopUp: changeToChild.__children NOT EXISTS")
          if exists("changeToChild.__action.submenu")
  call forms#log("forms#menu#MakePopUp: changeToChild.__action.submenu EXISTS")
            unlet changeToChild.__action.submenu
          else
  call forms#log("forms#menu#MakePopUp: changeToChild.__action.submenu NOT EXISTS")
          endif
        endif
      endif

    endif
  endif

  let p = s:popup_menu_item_cnt_pos
  if a:mode == 'n'
    call s:popupmenu.setChildStatus(p, g:IS_INVISIBLE)
    call s:popupmenu.setChildStatus(p+1, g:IS_INVISIBLE)
  elseif a:mode == 'v'
    call s:popupmenu.setChildStatus(p, g:IS_ENABLED)
    call s:popupmenu.setChildStatus(p+1, g:IS_ENABLED)
  endif

  call s:popupform.run()
endfunction

" forms#menu#MakePopUpTest: {{{2
function! forms#menu#MakePopUpTest() range
  call forms#AppendInput({'type': 'Sleep', 'time': 5})
  call forms#AppendInput({'type': 'Exit'})
  call forms#menu#MakePopUp('n')
endfunction

"---------------------------------------------------------------------------
" test stuff: {{{2
"---------------------------------------------------------------------------

nmap <Leader>x :call TEST('n')<CR>
vmap <Leader>x :call TEST('v')<CR>
function! TEST(mode) range
"call forms#log("TEST TOP " . a:mode)
  if a:mode == 'v'
    let s:firstline = a:firstline
    let s:firstcol = col("'<")
    let s:lastline = a:lastline
    let s:lastcol = col("'>")
  endif

  execute s:firstline
  execute 'norm! v0'.s:firstcol.'lv'.(s:lastcol-s:firstcol)."l"
  execute ":normal \<C-C>vaw"
endfunction

" :let @/ = XXXX()
function! XXXX() 
  execute '/is '
  return @/
endfunction

" ==============
"  Restore: {{{1
" ==============
if exists("s:keepcpo")
  let &cpo= s:keepcpo
  unlet s:keepcpo
endif

" ================
"  Modelines: {{{1
" ================
" vim: ts=4 fdm=marker
