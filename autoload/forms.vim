
" ============================================================================
" forms.vim
"
" File:          forms.vim
" Summary:       Vim Form Library
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" Last Modified: 06/30/2012
" Version:       1.3
" Modifications:
"  1.0 : initial public release.
"
" Tested on vim 7.3 on Linux
"
" Depends upon: self.vim
"
" ============================================================================
" Intro: {{{1
" The text-based, console Vim Forms library allows developers to embed 
"   forms in their scripts. Thats right, these forms all run in a normal
"   Vim console window - no need for GVim.
"
" When Vim 7.0 came out, I thought about building a Vim forms library but
"   never got around to it. Recently I started using Envim, a Vim binding
"   to ENSIME for Scala. While, ENSIME supports a couple of refactoring
"   options, none of them were available in Envim. Further, exactly how
"   one might go about entering a couple of parameters required by any
"   one of the refactoring options was not clear. A solution, of course,
"   was to have some sort of forms capability so that each refactoring
"   option, when invoked, would allow the user to enter the necessary
"   parameters for the implied refactoring operation. So.,,, Here is
"   that forms capability.
"
" Many of the layout and structural elements of this forms system are based
"   upon Mark Linton's C++ InterViews and Java Biscotti libraries. 
"   You might think they are from Sun's, now Oracle's, Java Swing library 
"   but for some of that library, Sun stole code from Fujitsu/Stanford so
"   I go back to acknowledge the earlier sources.
"
" While an attempt was made to make this a general forms capability, certainly
"   many capabilities of a general GUI form library are missing. 
"
" Well, so what. 
"
" It is envisioned that this library might have three uses:
"   During plugin initialization the user could be presented with a form
"     allowing for the entry of necessary tailoring option values.
"   Some scripts might require the entry of values prior to their execution,
"     like the Envim Scala code refactoring options.
"   Lastly, as proof of completeness, along with this forms library are
"     two forms. The first mirrors the capability of the GVim menu bar
"     while the second mirrors the GVim popup menu.
"     For advanced user, the menu bar and popup menu is not really needed,
"     but for beginners they might prove useful.

" ============================================================================

" Load Once: {{{1
if &cp || ( exists("g:loaded_forms") && ! g:self#IN_DEVELOPMENT_MODE )
  finish
endif
let g:loaded_forms = 'v1.0'
let s:keepcpo = &cpo
set cpo&vim

" ++++++++++++++++++++++++++++++++++++++++++++
" Reload : {{{1
" ++++++++++++++++++++++++++++++++++++++++++++
" ------------------------------------------------------------ 
" forms#reload: {{{2
"  Cals self#reload to force reloading of both forms and self
"    libraries:
"    call self#reload('forms#')
"    call self#reload('self#')
"  This function is only available in development mode, i.e.,
"    g:self#IN_DEVELOPMENT_MODE == self#IS_TRUE
"  To make reloading of autoloaded forms functions simple, one might
"    want to define a mapping:
"      map <Leader>fr :call forms#reload()
"  parameters: None
" ------------------------------------------------------------ 
if !exists("*forms#reload")
  if g:self#IN_DEVELOPMENT_MODE
    function forms#reload() 
      call self#reload('forms#')
      call self#reload('self#')
    endfunction
  endif
endif

" ++++++++++++++++++++++++++++++++++++++++++++
" Configuration Options: {{{1
"   These help control of the forms library.
" ++++++++++++++++++++++++++++++++++++++++++++

" If window dump is enabled, the file to be used
if ! exists("g:forms_window_dump_file") || g:self#IN_DEVELOPMENT_MODE
  let g:forms_window_dump_file = "VIM_WINDOW"
endif
" Enable/Disable screen dump. 
" A window dump occurs when <C-W> is entered.
if ! exists("g:forms_window_dump_enabled") || g:self#IN_DEVELOPMENT_MODE
  let g:forms_window_dump_enabled = g:self#IS_TRUE
endif

" ++++++++++++++++++++++++++++++++++++++++++++
" Forms Logging: {{{1
" ++++++++++++++++++++++++++++++++++++++++++++
if ! exists("g:forms_log_file") || g:self#IN_DEVELOPMENT_MODE
  let g:forms_log_file = "FORMS_LOG"
endif
if ! exists("g:forms_log_enabled") || g:self#IN_DEVELOPMENT_MODE
  let g:forms_log_enabled = g:self#IS_FALSE
endif

function! forms#log(msg) 
  if g:forms_log_enabled
    execute "redir >> " . g:forms_log_file
    silent echo a:msg
    execute "redir END"
  endif
endfunction

" ++++++++++++++++++++++++++++++++++++++++++++
" Gui Font: {{{1
" ++++++++++++++++++++++++++++++++++++++++++++
" Set the font to use if using GVim. 
" This font must be fixed width and support the utf-8 box drawing and
" block characters.
if ! exists("g:forms_gui_font")
  let g:forms_gui_font="Fixed 20"
endif

"-------------------------------------------------------------------------------
"-------------------------------------------------------------------------------
" HightLight: {{{1
"-------------------------------------------------------------------------------
"-------------------------------------------------------------------------------
" Definitions: {{{2
" ------------------------------------------------------------ 

function! s:ColorSchemeEvent() 
  call s:LoadeHighlights() 
endfunction

augroup forms
  autocmd ColorScheme * call s:ColorSchemeEvent()
augroup END

function! s:LoadeHighlights() 

if &background == 'light' 

if has("gui_running")

  " ReverseHi must use same background color, ctermbg, as BackgroundHi
  :hi ReverseHi           gui=reverse guibg=#dadada
  :hi HotSpotHi           gui=NONE guibg=#00ff00
  :hi ReverseHotSpotHi    gui=reverse guibg=#00ff00
  :hi FlashHi             gui=NONE guibg=#ffff87

  :hi ToggleSelectionHi   gui=NONE guibg=#5fffff

  :hi SelectedHi          gui=bold guibg=#5fffff

  :hi ButtonHi            gui=NONE guibg=#bcbcbc
  :hi ButtonFlashHi       gui=NONE guibg=#767676

  :hi BackgroundHi        gui=NONE guibg=#dadada

  " TODO derive FrameHi values from BackgroundHi values
  :hi FrameHi             gui=NONE guifg=#e4e4e4 guibg=#d0d0d0

  " TODO derive DropShadowHi values from BackgroundHi values
  :hi DropShadowHi        gui=NONE guibg=#dadada guifg=#bcbcbc

  :hi DisableHi           gui=NONE guibg=#ffaf00

  :hi MenuHi              gui=NONE guibg=#dadada
  :hi MenuMnemonicHi      gui=underline guibg=#dadada

  :hi MenuHotSpotHi       gui=NONE guibg=#ff00d7
  :hi MenuMnemonicHotSpotHi  gui=underline guibg=#ff00d7

elseif &t_Co == 256 

  :hi ReverseHi           cterm=reverse ctermbg=253 
  :hi HotSpotHi           cterm=NONE ctermbg=46 
  :hi ReverseHotSpotHi    cterm=reverse ctermbg=46 
  :hi FlashHi             cterm=NONE ctermbg=228 

  :hi ToggleSelectionHi   cterm=bold ctermbg=87 

  :hi SelectedHi          cterm=bold ctermbg=87 

  :hi ButtonHi            cterm=NONE ctermbg=250 
  :hi ButtonFlashHi       cterm=NONE ctermbg=243 

  :hi BackgroundHi        cterm=NONE ctermbg=253 

  :hi FrameHi             cterm=NONE ctermfg=254 ctermbg=252 

  :hi DropShadowHi        cterm=NONE ctermbg=253 ctermfg=250 

  :hi DisableHi           cterm=NONE ctermbg=214 

  :hi MenuHi              cterm=None ctermbg=253 
  :hi MenuMnemonicHi      cterm=underline ctermbg=253 

  :hi MenuHotSpotHi       cterm=None ctermbg=200 
  :hi MenuMnemonicHotSpotHi  cterm=underline ctermbg=200 

else " t_Co < 256

  " TODO: I have no idea if these values look ok
  :hi ReverseHi           cterm=reverse ctermbg=LightGrey
  :hi HotSpotHi           ctermbg=Green 
  :hi ReverseHotSpotHi    cterm=reverse ctermbg=Green
  :hi FlashHi             ctermbg=LightYellow

  :hi ToggleSelectionHi   cterm=bold ctermbg=LightBlue

  :hi SelectedHi          cterm=bold ctermbg=LightBlue

  :hi ButtonHi            cterm=NONE ctermbg=Grey
  :hi ButtonFlashHi       cterm=NONE ctermbg=DarkGrey

  :hi BackgroundHi        cterm=NONE ctermbg=LightGrey
  :hi DisableHi           cterm=NONE ctermbg=LightRed

  :hi MenuHi              cterm=None ctermbg=LightGrey
  :hi MenuMnemonicHi      cterm=underline ctermbg=LightGrey 
  :hi MenuHotSpotHi       cterm=None ctermbg=LightGrey
  :hi MenuMnemonicHotSpotHi  cterm=underline ctermbg=LightMagenta

endif

else " &background == 'dark'

if has("gui_running")

  :hi ReverseHi           gui=reverse guibg=#303030 
  :hi HotSpotHi           gui=NONE guibg=#00ff00
  :hi ReverseHotSpotHi    gui=reverse guibg=#00ff00
  :hi FlashHi             gui=NONE guibg=#ffff87

  :hi ToggleSelectionHi   gui=bold guibg=#5fffff

  :hi SelectedHi          gui=bold guibg=#5fffff

  :hi ButtonHi            gui=NONE guibg=#585858
  :hi ButtonFlashHi       gui=NONE guibg=#9e9e9e

  :hi BackgroundHi        gui=NONE guibg=#303030

  :hi FrameHi             gui=NONE guifg=#3a3a3a guibg=#262626

  :hi DropShadowHi        gui=NONE guibg=#303030 guifg=#080808

  :hi DisableHi           gui=NONE guibg=#ffaf00

  :hi MenuHi              gui=None guibg=#303030 
  :hi MenuMnemonicHi      gui=underline guibg=#303030 

  :hi MenuHotSpotHi       gui=None guibg=#ff00d7
  :hi MenuMnemonicHotSpotHi  gui=underline guibg=#ff00d7

elseif &t_Co == 256 

  :hi ReverseHi           cterm=reverse ctermbg=236 
  :hi HotSpotHi           cterm=NONE ctermbg=46 
  :hi ReverseHotSpotHi    cterm=reverse ctermbg=46 
  :hi FlashHi             cterm=NONE ctermbg=228 

  :hi ToggleSelectionHi   cterm=bold ctermbg=87 

  :hi SelectedHi          cterm=bold ctermbg=87 

  :hi ButtonHi            cterm=NONE ctermbg=240 
  :hi ButtonFlashHi       cterm=NONE ctermbg=247 

  " :hi BackgroundHi        cterm=NONE ctermbg=253 
  :hi BackgroundHi        cterm=NONE ctermbg=236

  :hi FrameHi             cterm=NONE ctermfg=237 ctermbg=235

  :hi DropShadowHi        cterm=NONE ctermbg=236 ctermfg=232

  :hi DisableHi           cterm=NONE ctermbg=214 

  :hi MenuHi              cterm=None ctermbg=236 
  :hi MenuMnemonicHi      cterm=underline ctermbg=236 

  :hi MenuHotSpotHi       cterm=None ctermbg=200 
  :hi MenuMnemonicHotSpotHi  cterm=underline ctermbg=200 

else " t_Co < 256

  " TODO: I have no idea if these values look ok
  :hi ReverseHi           cterm=reverse ctermbg=DarkGrey
  :hi HotSpotHi           ctermbg=Green 
  :hi ReverseHotSpotHi    cterm=reverse ctermbg=Green
  :hi FlashHi             ctermbg=LightYellow

  :hi ToggleSelectionHi   cterm=bold ctermbg=LightBlue

  :hi SelectedHi          cterm=bold ctermbg=LightBlue

  :hi ButtonHi            cterm=NONE ctermbg=Grey
  :hi ButtonFlashHi       cterm=NONE ctermbg=LightGrey

  :hi BackgroundHi        cterm=NONE ctermbg=DarkGrey
  :hi DisableHi           cterm=NONE ctermbg=DarkGrey

  :hi MenuHi              cterm=None ctermbg=DarkGrey
  :hi MenuMnemonicHi      cterm=underline ctermbg=DarkGrey
  :hi MenuHotSpotHi       cterm=None ctermbg=DarkGrey
  :hi MenuMnemonicHotSpotHi  cterm=underline ctermbg=LightMagenta

endif

endif " background

endfunction

call s:LoadeHighlights() 

" ------------------------------------------------------------ 
" CleanupHighlights: {{{2
" TODO not used
" ------------------------------------------------------------ 
function! CleanupHighlights()
  if exists("s:hotSpotId")
    call matchdelete(s:hotSpotId)
    unlet s:hotSpotId
  endif
  if exists("s:buttonId")
    call matchdelete(s:buttonId)
    unlet s:buttonId
  endif

  " if exists("s:toggleSectionId")
  "   call matchdelete(s:toggleSectionId)
  "   unlet s:toggleSectionId
  " endif
endfunction

" ------------------------------------------------------------ 
" Reverse: {{{2
"  Reverse background point of active focus
"  parameters:
"    glyph  : glyph getting reverse background for point
"    line   : line of hotspot
"    col    : column of hotspot
" ------------------------------------------------------------ 
function! Reverse(glyph, line, col)
" call forms#log("Reverse: TOP")
  if exists("a:glyph.__reverseId")
    try 
      call matchdelete(a:glyph.__reverseId)
    catch /.*/
      " do nothing
    endtry
  endif

  let lcstr = "\\%" . a:line . "l\\%" . a:col . "v"
  let a:glyph.__reverseId = matchadd("ReverseHi", lcstr . ".*" . lcstr)
" call forms#log("Reverse: BOTTOM")
endfunction

" ------------------------------------------------------------ 
" ReverseClear: {{{2
"  Clear reverse background 
"  parameters: 
"    glyph  : glyph clearing reverse background for point
" ------------------------------------------------------------ 
function! ReverseClear(glyph)
" call forms#log("ReverseClear: TOP")
  if exists("a:glyph.__reverseId")
    try 
      call matchdelete(a:glyph.__reverseId)
    catch /.*/
      " do nothing
    endtry
    unlet a:glyph.__reverseId
  endif
" call forms#log("ReverseClear: BOTTOM")
endfunction

" ------------------------------------------------------------ 
" ReverseHotSpot: {{{2
"  Reverse background point of active focus
"  parameters:
"    line   : line of hotspot
"    col    : column of hotspot
" ------------------------------------------------------------ 
function! ReverseHotSpot(line, col)
" call forms#log("ReverseHotSpot: TOP")
  if exists("s:reverseHotSpotId")
    try 
      call matchdelete(s:reverseHotSpotId)
    catch /.*/
      " do nothing
    endtry
  endif

  let lcstr = "\\%" . a:line . "l\\%" . a:col . "v"
  let s:reverseHotSpotId = matchadd("ReverseHotSpotHi", lcstr . ".*" . lcstr)
" call forms#log("ReverseHotSpot: BOTTOM")
endfunction

" ------------------------------------------------------------ 
" ReverseHotSpotClear: {{{2
"  Clear reverse background 
"  parameters: NONE
" ------------------------------------------------------------ 
function! ReverseHotSpotClear()
" call forms#log("ReverseHotSpotClear: TOP")
  if exists("s:reverseHotSpotId")
    try 
      call matchdelete(s:reverseHotSpotId)
    catch /.*/
      " do nothing
    endtry
    unlet s:reverseHotSpotId
  endif
" call forms#log("ReverseHotSpotClear: BOTTOM")
endfunction


" ------------------------------------------------------------ 
" HotSpot: {{{2
"  Highlight background point of active focus
"  parameters:
"    line   : line of hotspot
"    col    : column of hotspot
" ------------------------------------------------------------ 
function! HotSpot(line, col)
" call forms#log("HotSpot: TOP")
  if exists("s:hotSpotId")
    try 
      call matchdelete(s:hotSpotId)
    catch /.*/
      " do nothing
    endtry
  endif

  let lcstr = "\\%" . a:line . "l\\%" . a:col . "v"
  let s:hotSpotId = matchadd("HotSpotHi", lcstr . ".*" . lcstr)
" call forms#log("HotSpot: BOTTOM")
endfunction

" ------------------------------------------------------------ 
" HotRegion: {{{2
"  Highlight foreground of active focus
"  parameters:
"    a      : allocation
" ------------------------------------------------------------ 
function! HotRegion(allocation)
" call forms#log("HotRegion: TOP")
  if exists("s:hotSpotId")
    try 
      call matchdelete(s:hotSpotId)
    catch /.*/
      " do nothing
    endtry
  endif

  let pattern = GetMatchRange(a:allocation)
  let s:hotSpotId = matchadd("HotSpotHi", pattern)
" call forms#log("HotRegion: BOTTOM")
endfunction

" ------------------------------------------------------------ 
" Flash: {{{2
"  Highlight error condition for part of a line
"  parameters:
"    line   : line of flash
"    start  : start column of flash
"    end    : end column of flash
" ------------------------------------------------------------ 
function! Flash(line, start, end)
  " let startstr = "\\%" . a:line . "l\\%" . a:start . "c"
  " let endstr = "\\%" . a:line . "l\\%" . a:end . "c"

  let startstr = "\\%" . a:line . "l\\%" . a:start . "v"
  let endstr = "\\%" . a:line . "l\\%" . a:end . "v"
  let l:flashId = matchadd("FlashHi", startstr . ".*" . endstr)
  redraw
  sleep 200m
  call matchdelete(l:flashId)
  unlet l:flashId
endfunction

" ------------------------------------------------------------ 
" FlashRegion: {{{2
"  Highlight error condition for a region
"  parameters:
"    allocation : allocation of flash
" ------------------------------------------------------------ 
function! FlashRegion(allocation)
  let pattern = GetMatchRange(a:allocation)
  let l:flashId = matchadd("FlashHi", pattern)
  redraw
  sleep 200m
  call matchdelete(l:flashId)
  unlet l:flashId
endfunction

" ------------------------------------------------------------ 
" GlyphHilight: {{{2
"  Highlight a region and associate with a glyph. 
"    If the glyph already has a highlight, delete it.
"  parameters:
"    glyph      : glyph to be associated with highlight
"    highlight  : name of highlight
"    allocation : allocation of highlight
" ------------------------------------------------------------ 
function! GlyphHilight(glyph, highlight, allocation)
" call forms#log("GlyphHilight: TOP")
  call GlyphDeleteHi(a:glyph)

  let pattern = GetMatchRange(a:allocation)
"call forms#log("GlyphHilight: pattern=" . pattern)
  let a:glyph.__matchId = matchadd(a:highlight, pattern)
" call forms#log("GlyphHilight: BOTTOM")
endfunction

function! AugmentGlyphHilight(glyph, highlight, allocation)
" call forms#log("AugmentGlyphHilight: TOP")

  let pattern = GetMatchRange(a:allocation)
"call forms#log("AugmentGlyphHilight: pattern=" . pattern)

  if ! has_key(a:glyph, '__matchId')
    let a:glyph.__matchId = matchadd(a:highlight, pattern)
  elseif type(a:glyph.__matchId) == g:self#LIST_TYPE
    call add(a:glyph.__matchId, matchadd(a:highlight, pattern))
  else
    let matchId = a:glyph.__matchId
    unlet a:glyph.__matchId
    let a:glyph.__matchId = [matchId, matchadd(a:highlight, pattern)]
  endif
" call forms#log("GlyphHilight: BOTTOM")
endfunction

" ------------------------------------------------------------ 
" GlyphDeleteHi: {{{2
"  Delete a highlight or list of highlights associate with a 
"   glyph
"  parameters:
"    glyph      : glyph associated with zero or more highlights
" ------------------------------------------------------------ 
function! GlyphDeleteHi(glyph)
"call forms#log("GlyphDeleteHi: TOP")
  if has_key(a:glyph, '__matchId')
    let matchId = a:glyph.__matchId
    if type(matchId) == g:self#LIST_TYPE
      for m in matchId
        call MatchDeleteHi(m)
      endfor
    else
      call MatchDeleteHi(matchId)
    endif
    unlet a:glyph.__matchId
  endif
" call forms#log("GlyphDeleteHi: BOTTOM")
endfunction

" ------------------------------------------------------------ 
" MatchDeleteHi: {{{2
"  Delete a highlight given its id and in case there is no 
"   highlight associated with the id, do not produce an error.
"  parameters:
"    matchid  : id of a highlight
" ------------------------------------------------------------ 
function! MatchDeleteHi(matchId)
  try
    call matchdelete(a:matchId)
  catch /.*/
  endtry
endfunction


" ------------------------------------------------------------ 
" GetSelectionId: {{{2
"  Create a highlight and return its id.
"  parameters:
"    allocation  : allocation associated with highlight
" ------------------------------------------------------------ 
function! GetSelectionId(allocation)
  let pattern = GetMatchRange(a:allocation)
  return matchadd("SelectedHi", pattern)
endfunction

" ------------------------------------------------------------ 
" ClearSelectionId: {{{2
"  Delete a highlight given its id and in case there is no 
"   highlight associated with the id, do not produce an error.
"  parameters:
"    sid  : id of a highlight
" ------------------------------------------------------------ 
function! ClearSelectionId(sid)
  try
    call matchdelete(a:sid)
  catch /.*/
  endtry
endfunction


" ------------------------------------------------------------ 
" ButtonFlashHi: {{{2
"  Create a highlight flash
"  parameters:
"    allocation  : allocation associated with highlight
" ------------------------------------------------------------ 
function! ButtonFlashHi(allocation)
" call forms#log("ButtonFlashHi: TOP")
  let pattern = GetMatchRange(a:allocation)
  let l:buttonflashId = matchadd("ButtonFlashHi", pattern)
  redraw
  sleep 200m
  call matchdelete(l:buttonflashId)
" call forms#log("ButtonFlashHi: BOTTOM")
endfunction

" ------------------------------------------------------------ 
" ButtonGroupAddHi: {{{2
"  Create a highlight and associate it with a button group.
"    If the buttongroup already has a highlight, delete it.
"  parameters:
"    buttongroup : buttongroup to be associated with highlight
"    allocation  : allocation associated with highlight
" ------------------------------------------------------------ 
function! ButtonGroupAddHi(buttongroup, allocation)
" call forms#log("ButtonGroupAddHi")
  call ButtonGroupDeleteHi(a:buttongroup)

  let pattern = GetMatchRange(a:allocation)
  let a:buttongroup.__selectId = matchadd("ToggleSelectionHi", pattern)
endfunction

" ------------------------------------------------------------ 
" ButtonGroupDeleteHi: {{{2
"  Delete a highlight associated it with a button group if it 
"    exists.
"  parameters:
"    buttongroup : buttongroup associated with a highlight
" ------------------------------------------------------------ 
function! ButtonGroupDeleteHi(buttongroup)
" call forms#log("ButtonGroupDeleteHi")
  if has_key(a:buttongroup, '__selectId')
    call matchdelete(a:buttongroup.__selectId)
    unlet a:buttongroup.__selectId
  endif
endfunction

" ------------------------------------------------------------ 
" GetMatchRange: {{{2
"  Create a match pattern given an allocation. The allocation
"    can be on a single line or a region.
"  parameters:
"    allocation : allocation from which pattern is generated
" ------------------------------------------------------------ 
function! GetMatchRange(allocation)
  let line = a:allocation.line
  let column = a:allocation.column
  let width = a:allocation.width
  let height = a:allocation.height

  let lnum1 = line
  let lnum2 = line+height-1
  let col1 = column
  let col2 = column+width-1

  if lnum1 == lnum2
    let range = '\%'.lnum1.'l\%>'.(col1-1).'v.*\%<'.(col2+1).'v'
  else
    let range=
             \'\%>'.(col1-1).'v'.
             \'\%<'.(col2+1).'v'.
             \'\%>'.(lnum1-1).'l'.
             \'\%<'.(lnum2+1).'l'.
             \'.'
  endif
  return range
endfunction

"-------------------------------------------------------------------------------
"-------------------------------------------------------------------------------
" Forms Input Character Stream management: {{{1
"-------------------------------------------------------------------------------
"-------------------------------------------------------------------------------

" Input characters and Events
" Character: 
"   A value returned by calling getchar()
" Event: 
"   A command (often results from mapping a character to command) 
"   An event is used for both giving commands to glyphs to be executed
"   both as input and as return values for some methods and, additionally,
"   an event is used to wrap Form results.
"   All Events are a Dictionary with a 'type' key indicating the
"   command type and, possibly, additional data.
" Event Types
"   Exit
"     Action: exit current viewer, if top viewer, no results data
"     Also used as top-of-stack return value for Viewer
"     The character <Esc> is mapped to Exit
"   Cancel 
"     Action: exit form, no results data
"     Also used as top-of-stack return value for Viewer
"   Command
"     Action: exit form, no result data, and execute command
"   Context 
"     Action: generate context help Form with application specific help/info
"        and developer tools
"     Data: optional Point [line, column]
"     The character <RightMouse> is mapped to Context
"   Drag
"     Action: none
"     The character <LeftDrag> is mapped to Drag
"   Release
"     Action: none
"     The character <LeftRelease> is mapped to Release
"   NewFocus
"     Action: find new focus based upon mouse coordinates
"     The character <LeftMouse> is mapped to NewFocus
"     Also, if a Viewer is the target of a Select Event, it is mapped
"       to NewFocus
"   NextFocus
"     Action: go to next focus
"     The characters <Tab>, <C-n> and <Down> is mapped to NextFocus
"     The mouse <ScrollWheelDown> event is mapped to NextFocus
"   PrevFocus
"     Action: go to previous focus
"     The characters <S-Tab>, <C-p> and <Up> is mapped to PrevFocus
"     The mouse <ScrollWheelUp> event is mapped to PrevFocus
"   FirstFocus
"     Action: go to first focus glyph
"     The character <Home> is mapped to FirstFocus
"   LastFocus
"     Action: go to last focus glyph
"     The character <End> is mapped to LastFocus
"   ReDraw
"     Action: redraw Form in window
"   ReDrawAll
"     Action: redraw complete form 
"   ReFocus
"     Action: View creates a list of glyphs that can get focus
"       this event tells viewer to regenerate that list
"   ReSize
"     Action: Form does a requestedSize call on its body because a child has
"       changed size or gone from invisible to visible
"   Select 
"     Action: change focus and possibly glyph specific sub-selection
"     Data: Point [line, column]
"   SelectDouble
"     Action: a left mouse double click occured
"     Data: Point [line, column]
"     The mouse <2-LeftMouse> event is mapped to SelectDouble
"   Sleep
"     Action: Viewer Event handling sleeps for given time.
"     Data: time: Number (e.g., 10) or String (Number+'m' e.g., 200m)
"     Used for visual testing
"   Submit
"     Action: exit form with result data
"     Data: results from form
"     Also used as top-of-stack return value for Viewer
" Special Key Types
"   Down
"     Produced by down key and viewer maps ScrollWheelDown to Down
"   Up
"     Produced by up key and viewer maps ScrollWheelUp to Up
"   Left  S-Left  C-Left
"   Right S-Right C-Right 
"   ScrollWheelDown S-ScrollWheelDown C-ScrollWheelDown 
"   ScrollWheelUp S-ScrollWheelUp C-ScrollWheelUp 
"   Space: mapped to Select
"   CR: mapped to Select
"   Del: generally, erase character in editor
"   BS: generally, move over character in editor


" ------------------------------------------------------------ 
" forms#CheckInput: {{{2
"  Makes sure that an object injected into the input stream
"    is either an event (Dictionary with type attribute) or
"    is a String or Number.
"    Exceptions are thrown if it a illegal input object.
"  parameters:
"    input : object to be tested
" ------------------------------------------------------------ 
function! forms#CheckInput(input) 
  let type = type(a:input)
  if type == g:self#DICTIONARY_TYPE
    if ! exists("a:input.type")
      throw "CheckEvent: No 'type' key for event: " . string(a:input)
    endif
  elseif type != g:self#STRING_TYPE && type != g:self#NUMBER_TYPE
    throw "CheckEvent: Bad type, not DICTIONARY, STRING or NUMBER: " . string(a:input)
  endif
endfunction

" ------------------------------------------------------------ 
" forms#InputsSame: {{{2
"  Makes sure that two input objects are the same.
"    Should only be called if both input1 and input2 have 
"    passed CheckEvent.
"    For inputs of type event, then this only tests event.type 
"    equality
"  parameters:
"    input1 : object to be tested
"    input2 : object to be tested
" ------------------------------------------------------------ 
function! forms#InputsSame(input1, input2) 
  let type1 = type(a:input1)
  let type2 = type(a:input2)

  if type1 != type2
    return g:self#IS_FALSE
  elseif type1 == g:self#DICTIONARY_TYPE
    return input1.type == input2.type
  elseif type1 == g:self#NUMBER_TYPE
    return input1 == input2
  else " type1 == g:self#STRING_TYPE
    return input1 == input2
  endif
endfunction

" ------------------------------------------------------------ 
" s:inputlist: {{{2
"  Input queue holds input objects which will be processed
"    before characters are read from Vim's getchar()
" ------------------------------------------------------------ 
let s:inputlist = []

" ------------------------------------------------------------ 
" forms#PrependInput: {{{2
"  Add input to front of input queue
"  parameters:
"    input : object to be prepended
" ------------------------------------------------------------ 
function! forms#PrependInput(input) 
  call forms#CheckInput(a:input)
  call insert(s:inputlist, a:input)
endfunction

" ------------------------------------------------------------ 
" forms#PrependUniqueInput: {{{2
"  Add input to front of input queue but only if it does not
"    equals the current front of queue.
"  parameters:
"    input : object to be prepended
" ------------------------------------------------------------ 
function! forms#PrependUniqueInput(input) 
  call forms#CheckInput(a:input)
  if len(s:inputlist) == 0 || ! forms#InputsSame(a:input, s:inputlist[0])
    call insert(s:inputlist, a:input)
  endif
endfunction

" ------------------------------------------------------------ 
" forms#AppendInput: {{{2
"  Add input to back of input queue
"  parameters:
"    input : object to be appended
" ------------------------------------------------------------ 
function! forms#AppendInput(input) 
  call forms#CheckInput(a:input)
  call add(s:inputlist, a:input)
endfunction

" ------------------------------------------------------------ 
" forms#AppendUniqueInput: {{{2
"  Add input to back of input queue but only if it does not
"    equals the current back of queue.
"  parameters:
"    input : object to be appended
" ------------------------------------------------------------ 
function! forms#AppendUniqueInput(input) 
  call forms#CheckInput(a:input)
  if len(s:inputlist) == 0 || ! forms#InputsSame(a:input, s:inputlist[len(s:inputlist)-1])
    call add(s:inputlist, a:input)
  endif
endfunction

" ------------------------------------------------------------ 
" forms#ClearVimInputStream: {{{2
"  Clears the Vim character input stream but NOT the inputlist
"  parameters: NONE
" ------------------------------------------------------------ 
function! forms#ClearVimInputStream() 
  while 1
    if getchar(0) == 0 | break | endif
  endwhile
endfunction

" ------------------------------------------------------------ 
" forms#ClearInputList: {{{2
"  Clears the input list (inputlist)
"  parameters: NONE
" ------------------------------------------------------------ 
function! forms#ClearInputList() 
  let s:inputlist = []
endfunction

" ------------------------------------------------------------ 
" forms#GetInput: {{{2
"  Get the next input. If the inputlist is not empty remove
"    and return its first entry, otherwise return Vim input
"    from the getchar() call.
"  parameters: NONE
" ------------------------------------------------------------ 
function! forms#GetInput() 
  return empty(s:inputlist) ? getchar() : remove(s:inputlist, 0)
if 0
  if ! empty(s:inputlist) 
    return remove(s:inputlist, 0)
  else
    let c = getchar()
" call forms#log("GetInput: c=" .  c)
    let next = getchar(0)
" call forms#log("GetInput: o next=" .  next)
    while next != 0 && c == next
      let next = getchar(0)
" call forms#log("GetInput: i next=" .  next)
    endwhile
    if next != 0
      call insert(s:inputlist, next)
    endif
    return c
  endif
endif
endfunction

"-------------------------------------------------------------------------------
" Forms Utilities: {{{1
"  Gets Utility object that has numerous support methods
"  parameters: NONE
"-------------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms_Util")
    unlet g:forms_Util
  endif
endif
if !exists("g:forms_Util")
  let g:forms_Util = { }
  " ------------------------------------------------------------ 
  " g:forms_Util.nullGlyph {{{2
  "  Gets a null glyph; no actions, size or rendering.
  "  parameters: NONE
  " ------------------------------------------------------------ 
  function! FORMS_UTIL_nullGlyph() dict
    if ! exists("g:forms_Util.__nullGlyph")
      let g:forms_Util.__nullGlyph = forms#newNullGlyph({})
    endif
    return g:forms_Util.__nullGlyph
  endfunction
  let g:forms_Util.nullGlyph = function("FORMS_UTIL_nullGlyph")

  " ------------------------------------------------------------ 
  " g:forms_Util.emptyAction {{{2
  "  Gets action that does nothing
  "  parameters: NONE
  " ------------------------------------------------------------ 
  function! FORMS_UTIL_emptyAction() dict
    if ! exists("g:forms_Util.__emptyAction")
      let g:forms_Util.__emptyAction = forms#newAction({})
    endif
    return g:forms_Util.__emptyAction
  endfunction
  let g:forms_Util.emptyAction = function("FORMS_UTIL_emptyAction")

  " ------------------------------------------------------------ 
  " g:forms_Util.checkHAlignment {{{2
  "   Checks if halignment parameter is a valid horizontal
  "     alignment value.  Either 
  "       float: 0 <= halignment <= 1.0
  "       character: 'L' 'C' or 'R'
  "     If the parameter is not valid, and exception is thrown.
  "  parameters:
  "   halignment : attribute value being checked
  "   name       : name of component requesting check
  " ------------------------------------------------------------ 
  function! FORMS_UTIL_checkHAlignment(halignment, name) dict
    if type(a:halignment) == g:self#FLOAT_TYPE
      if a:halignment < 0.0
        throw "" . a:name . ": alignment float value < 0.0: " . a:halignment
      elseif  a:halignment > 1.0
        throw "" . a:name . ": alignment float value > 1.0: " . a:halignment
      endif
    elseif type(a:halignment) == g:self#STRING_TYPE
      if a:halignment != "L" && a:halignment != "C" && a:halignment != "R" 
        throw "" . a:name . ": halignment string value != L or C or R: " . a:halignment
      endif
    else
      throw "" . a:name . ": bad halignment type: " . a:halignment
    endif
  endfunction
  let g:forms_Util.checkHAlignment = function("FORMS_UTIL_checkHAlignment")

  " ------------------------------------------------------------ 
  " g:forms_Util.checkVAlignment {{{2
  "   Checks if valignment parameter is a valid vertical
  "     alignment value.  Either 
  "       float: 0 <= valignment <= 1.0
  "       character: 'T' 'C' or 'B'
  "     If the parameter is not valid, and exception is thrown.
  "  parameters:
  "   valignment : attribute value being checked
  "   name       : name of component requesting check
  " ------------------------------------------------------------ 
  function! FORMS_UTIL_checkVAlignment(valignment, name) dict
    if type(a:valignment) == g:self#FLOAT_TYPE
      if a:valignment < 0.0
        throw "" . a:name . ": alignment float value < 0.0: " . a:valignment
      elseif  a:valignment > 1.0
        throw "" . a:name . ": alignment float value > 1.0: " . a:valignment
      endif
    elseif type(a:valignment) == g:self#STRING_TYPE
      if a:valignment != "T" && a:valignment != "C" && a:valignment != "B" 
        throw "" . a:name . ": valignment string value != T or C or B: " . a:valignment
      endif
    else
      throw "" . a:name . ": bad valignment type: " . a:valignment
    endif
  endfunction
  let g:forms_Util.checkVAlignment = function("FORMS_UTIL_checkVAlignment")

  " ------------------------------------------------------------ 
  " g:forms_Util.drawHLine {{{2
  "   Draw a horizontal line
  "  parameters:
  "   rect       : list of [line, column, size]
  "   char       : character used to draw line 
  " ------------------------------------------------------------ 
  function! FORMS_UTIL_drawHLine(rect, char) dict
"call forms#log("Util.drawHLine " .  string(a:rect) . ", char=" . a:char)
    let [line, column, size] = a:rect
    if size == 1
      call forms#SetCharAt(a:char, line, column)
    else
      let str = repeat(a:char, size)
      call forms#SetStringAt(str, line, column)
    endif
  endfunction
  let g:forms_Util.drawHLine = function("FORMS_UTIL_drawHLine")

  " ------------------------------------------------------------ 
  " g:forms_Util.drawVLine {{{2
  "   Draw a vertical line
  "  parameters:
  "   rect       : list of [line, column, size]
  "   char       : character used to draw line 
  " ------------------------------------------------------------ 
  function! FORMS_UTIL_drawVLine(rect, char) dict
"call forms#log("Util.drawVLine " .  string(a:rect) . ", char=" . a:char)
    let [line, column, size] = a:rect
    if size == 1
      call forms#SetCharAt(a:char, line, column)
    else
      let cnt = 0
      while cnt < size
        call forms#SetCharAt(a:char, line+cnt, column)

        let cnt += 1
      endwhile
    endif
  endfunction
  let g:forms_Util.drawVLine = function("FORMS_UTIL_drawVLine")

  " ------------------------------------------------------------ 
  " g:forms_Util.drawRect {{{2
  "   Draw a rectangular region
  "     This is called bye drawHVAlign to draw the potentially
  "     eight different alignment regions:
  "       tl  tc  tr
  "       cl      cr
  "       bl  bc  br
  "  parameters:
  "   rect       : list of [line, column, width, height]
  "   char       : character used to draw line 
  " ------------------------------------------------------------ 
  function! FORMS_UTIL_drawRect(rect, char) dict
" call forms#log("Util.drawRect " .  string(a:rect) . ", char=" . a:char)
    if a:char != ''
      let [line, column, width, height] = a:rect
      if line != -1 && column != -1 && width != -1 && height != -1

        if height == 1
          if width == 1
            call forms#SetCharAt(a:char, line, column)
          else
            call forms#SetHCharsAt(a:char, width, line, column)
          endif
        else
          if width == 1
            " TODO use forms#SetVCharsAt
            let cnt = 0
            while cnt < height
              call forms#SetCharAt(a:char, line+cnt, column)

              let cnt += 1
            endwhile
          else
            " TODO use forms#SetVCharsAt
            let cnt = 0
            while cnt < height
              call forms#SetHCharsAt(a:char, width, line+cnt, column)

              let cnt += 1
            endwhile
          endif
        endif
      endif
    endif
  endfunction
  let g:forms_Util.drawRect = function("FORMS_UTIL_drawRect")

  " ------------------------------------------------------------ 
  " g:forms_Util.vAlign {{{2
  "   Return the vertical alignment offset from line for child 
  "  parameters:
  "   vinfo       : list of [line, height, childheight]
  "   alignment   : 0 <= float <= 1 or 'T', 'C' or 'B'
  " ------------------------------------------------------------ 
  function! FORMS_UTIL_vAlign(vinfo, alignment) dict
" call forms#log("Util.vAlign " .  string(a:vinfo) . ", " . a:alignment)
    let line = a:vinfo.line
    let height = a:vinfo.height
    let childheight = a:vinfo.childheight

    if height <= childheight
      return line
    else 
      let m = height - childheight
      if type(a:alignment) == g:self#FLOAT_TYPE
        let f = float2nr(m * a:alignment)
        return line+f
      elseif a:alignment == "T"
        return line
      elseif a:alignment == "C"
        let f = (m+1)/2
        return line+f
      elseif a:alignment == "B"
        return line+m
      else
        throw "Util.vAlign: bad alignment: " . a:alignment
      endif
    endif
  endfunction
  let g:forms_Util.vAlign = function("FORMS_UTIL_vAlign")

  " ------------------------------------------------------------ 
  " g:forms_Util.hAlign {{{2
  "   Return the horizontal alignment offset from column for child 
  "  parameters:
  "   vinfo       : list of [column, width, childwidth]
  "   alignment   : 0 <= float <= 1 or 'L', 'C' or 'R'
  " ------------------------------------------------------------ 
  function! FORMS_UTIL_hAlign(hinfo, alignment) dict
" call forms#log("Util.hAlign " .  string(a:hinfo) . ", " . a:alignment)
    let column = a:hinfo.column
    let width = a:hinfo.width
    let childwidth = a:hinfo.childwidth

    if width <= childwidth
      return column
    else 
      let m = width - childwidth
      if type(a:alignment) == g:self#FLOAT_TYPE
        let f = float2nr(m * a:alignment)
        return column+f
      elseif a:alignment == "L"
        return column
      elseif a:alignment == "C"
        let f = (m+1)/2
        return column+f
      elseif a:alignment == "R"
        return column+m
      else
        throw "Util.hAlign: bad alignment: " . a:alignment
      endif
    endif
  endfunction
  let g:forms_Util.hAlign = function("FORMS_UTIL_hAlign")


  " ------------------------------------------------------------ 
  " g:forms_Util.drawVAlign {{{2
  "   Draw a glyph vertically aligned 
  "  parameters:
  "   glyph       : glyph to be aligned and drawn
  "   allocation  : dictionary of { 'line', 'column', 'height', 'childwidth', 'childheight' }
  "   alignment   : 0 <= float <= 1 or 'T', 'C' or 'B'
  "   char        : character to fill alignment spaces
  " ------------------------------------------------------------ 
  function! FORMS_UTIL_drawVAlign(glyph, allocation, alignment, char) dict
" call forms#log("Util.drawVAlign " .  string(a:allocation) . ", " . a:alignment)
    let line = a:allocation.line
    let column = a:allocation.column
    let height = a:allocation.height
    let childwidth = a:allocation.childwidth
    let childheight = a:allocation.childheight

    let char = a:char

    if height <= childheight
      " draw body as is
      call a:glyph.draw({
                        \ 'line': line,
                        \ 'column': column,
                        \ 'width': childwidth,
                        \ 'height': childheight
                        \ })

    elseif childwidth == 1
      let m = height - childheight
      if type(a:alignment) == g:self#FLOAT_TYPE
        let f = float2nr(m * a:alignment)
        if char != '' 
          let b = m - f
          if f > 0
            let cnt = 0
            while cnt < f
              " TODO not utf8
              " call cursor(a:line+cnt, a:col)
              " execute "normal " . "r" . char . ""
              call forms#SetCharAt(char, a:line+cnt, a:col)

              let cnt += 1
            endwhile
          endif
          if b > 0
            let cnt = 0
            while cnt < b
              " TODO not utf8
              " call cursor(a:line+childheight+f+cnt, a:col)
              " execute "normal " . "r" . char . ""
              call forms#SetCharAt(char, a:line+childheight+f+cnt, a:col)

              let cnt += 1
            endwhile
          endif
        endif

        call a:glyph.draw({
                            \ 'line': line+f,
                            \ 'column': column,
                            \ 'width': childwidth,
                            \ 'height': childheight
                            \ })

      elseif a:alignment == "T"
        if char != '' 
          let cnt = 0
          while cnt < m
            " TODO not utf8
            " call cursor(a:line+childheight+cnt, a:col)
            " execute "normal " . "r" . char . ""
            call forms#SetCharAt(char, a:line+childheight+cnt, a:col)

            let cnt += 1
          endwhile
        endif

        call a:glyph.draw({
                          \ 'line': line,
                          \ 'column': column,
                          \ 'width': childwidth,
                          \ 'height': childheight
                          \ })

      elseif a:alignment == "C"
        let f = (m+1)/2
        if char != '' 
          let b = m - f
          if f > 0
            let cnt = 0
            while cnt < f
              " TODO not utf8
              " call cursor(a:line+cnt, a:col)
              " execute "normal " . "r" . char . ""
              call forms#SetCharAt(char, a:line+cnt, a:col)

              let cnt += 1
            endwhile
          endif
          if b > 0
            let cnt = 0
            while cnt < b
              " TODO not utf8
              "call cursor(a:line+childheight+f+cnt, a:colf)
              "execute "normal " . "r" . char . ""
              call forms#SetCharAt(char, a:line+childheight+f+cnt, a:col)

              let cnt += 1
            endwhile
          endif
        endif

        call a:glyph.draw({
                            \ 'line': line+f,
                            \ 'column': column,
                            \ 'width': childwidth,
                            \ 'height': childheight
                            \ })

      elseif a:alignment == "B"
        if char != '' 
          let cnt = 0
          while cnt < m
            " TODO not utf8
            " call cursor(a:line_cnt, a:col)
            " execute "normal " . "r" . char . ""
            call forms#SetCharAt(char, a:line+cnt, a:col)

            let cnt += 1
          endwhile
        endif

        call a:glyph.draw({
                            \ 'line': line+m,
                            \ 'column': column,
                            \ 'width': childwidth,
                            \ 'height': childheight
                            \ })

      else
        throw "VAlign.draw: bad alignment: " . a:alignment
      endif

    else " childwidth > 1
      let m = height - childheight
      if type(a:alignment) == g:self#FLOAT_TYPE
        let f = float2nr(m * a:alignment)
        if char != '' 
          let b = m - f
          if f > 0
            let cnt = 0
            while cnt < f
              " TODO use forms#SetVCharsAt
              call forms#SetHCharsAt(char, childwidth, a:line+cnt, a:col)

              let cnt += 1
            endwhile
          endif
          if b > 0
            let cnt = 0
            while cnt < b
              " TODO use forms#SetVCharsAt
              call forms#SetHCharsAt(char, childwidth, a:line+childheight+f+cnt, a:col)

              let cnt += 1
            endwhile
          endif
        endif

        call a:glyph.draw({
                            \ 'line': line+f,
                            \ 'column': column,
                            \ 'width': childwidth,
                            \ 'height': childheight
                            \ })

      elseif a:alignment == "T"
        if char != '' 
          " also do visual method
          let cnt = 0
          while cnt < m
            " TODO use forms#SetVCharsAt
            call forms#SetHCharsAt(char, childwidth, a:line+childheight+cnt, a:col)

            let cnt += 1
          endwhile
        endif

        call a:glyph.draw({
                          \ 'line': line,
                          \ 'column': column,
                          \ 'width': childwidth,
                          \ 'height': childheight
                          \ })

      elseif a:alignment == "C"
        let f = (m+1)/2
        if char != '' 
          let b = m - f
          if f > 0
            " also do visual method
            let cnt = 0
            while cnt < f
              " TODO use forms#SetVCharsAt
              call forms#SetHCharsAt(char, childwidth, a:line+cnt, a:col)

              let cnt += 1
            endwhile
          endif
          if b > 0
            " also do visual method
            let cnt = 0
            while cnt < b
              " TODO use forms#SetVCharsAt
              call forms#SetHCharsAt(char, childwidth, a:line+childheight+f+cnt, a:col)

              let cnt += 1
            endwhile
          endif
        endif
        
        call a:glyph.draw({
                            \ 'line': line+f,
                            \ 'column': column,
                            \ 'width': childwidth,
                            \ 'height': childheight
                            \ })

      elseif a:alignment == "B"
        if char != '' 
          " also do visual method
          let cnt = 0
          while cnt < m
            " TODO use forms#SetVCharsAt
            call forms#SetHCharsAt(char, childwidth, a:line++cnt, a:col)

            let cnt += 1
          endwhile
        endif
        
        call a:glyph.draw({
                            \ 'line': line+m,
                            \ 'column': column,
                            \ 'width': childwidth,
                            \ 'height': childheight
                            \ })

      else
        throw "Util.drawVAlign: bad alignment: " . a:alignment
      endif
    endif
  endfunction
  let g:forms_Util.drawVAlign = function("FORMS_UTIL_drawVAlign")

  " ------------------------------------------------------------ 
  " g:forms_Util.drawVAlign {{{2
  "   Draw a glyph horizontally aligned 
  "  parameters:
  "   glyph       : glyph to be aligned and drawn
  "   allocation  : dictionary of { 'line', 'column', 'width', 'childwidth', 'childheight' }
  "   alignment   : 0 <= float <= 1 or 'L', 'C' or 'R'
  "   char        : character to fill alignment spaces
  " ------------------------------------------------------------ 
  function! FORMS_UTIL_drawHAlign(glyph, allocation, alignment, char) dict
" call forms#log("Util.drawHAlign " .  string(a:allocation) . ", " . a:alignment)
    let line = a:allocation.line
    let column = a:allocation.column
    let width = a:allocation.width
    let childwidth = a:allocation.childwidth
    let childheight = a:allocation.childheight

    let char = a:char

    if width <= childwidth
      " draw glyph as is
      call a:glyph.draw({
                        \ 'line': line,
                        \ 'column': column,
                        \ 'width': childwidth,
                        \ 'height': childheight
                        \ })

    elseif childheight == 1
      let m = width - childwidth
      if type(a:alignment) == g:self#FLOAT_TYPE
        let f = float2nr(m * a:alignment)
        if char != '' 
          let b = m - f
          if f > 0
            call forms#SetHCharsAt(char, f, line, column)
          endif
          if b > 0
            call forms#SetHCharsAt(char, b, line, column+childwidth+f)
          endif
        endif

        call a:glyph.draw({
                            \ 'line': line,
                            \ 'column': column + f,
                            \ 'width': childwidth,
                            \ 'height': childheight
                            \ })

      elseif a:alignment == "L"
        if char != '' 
          call forms#SetHCharsAt(char, m, line, column+childwidth)
        endif

        call a:glyph.draw({
                        \ 'line': line,
                        \ 'column': column,
                        \ 'width': childwidth,
                        \ 'height': childheight
                        \ })

      elseif a:alignment == "C"
        let f = (m+1)/2
        if char != '' 
          let b = m - f
          if f > 0
            call forms#SetHCharsAt(char, f, line, column)
          endif
          if b > 0
            call forms#SetHCharsAt(char, b, line, column+childwidth+f)
          endif
        endif

        call a:glyph.draw({
                            \ 'line': line,
                            \ 'column': column + f,
                            \ 'width': childwidth,
                            \ 'height': childheight
                            \ })

      elseif a:alignment == "R"
        if char != '' 
          call forms#SetHCharsAt(char, m, line, column)
        endif

        call a:glyph.draw({
                            \ 'line': line,
                            \ 'column': column + m,
                            \ 'width': childwidth,
                            \ 'height': childheight
                            \ })

      else
        throw "HAlign.draw: bad alignment: " . a:alignment
      endif

    else " childheight > 1
      let m = width - childwidth
      if type(a:alignment) == g:self#FLOAT_TYPE
        let f = float2nr(m * a:alignment)
        if char != '' 
          let b = m - f
          if f > 0
            let cnt = 0
            while cnt < childheight
              " TODO use forms#SetVCharsAt
              call forms#SetHCharsAt(char, f, line+cnt, column)

              let cnt += 1
            endwhile
          endif
          if b > 0
            let cnt = 0
            while cnt < childheight
              " TODO use forms#SetVCharsAt
              call forms#SetHCharsAt(char, b, line+cnt, column+childwidth+f)

              let cnt += 1
            endwhile
          endif
        endif

        call a:glyph.draw({
                            \ 'line': line,
                            \ 'column': column + f,
                            \ 'width': childwidth,
                            \ 'height': childheight
                            \ })

      elseif a:alignment == "L"
        if char != '' 
          " also do visual method
          let cnt = 0
          while cnt < childheight
            " TODO use forms#SetVCharsAt
            call forms#SetHCharsAt(char, m, line+cnt, column+childwidth)

            let cnt += 1
          endwhile
        endif

        call a:glyph.draw({
                        \ 'line': line,
                        \ 'column': column,
                        \ 'width': childwidth,
                        \ 'height': childheight
                        \ })

      elseif a:alignment == "C"
        let f = (m+1)/2
        if char != '' 
          let b = m - f
          if f > 0
            " also do visual method
            let cnt = 0
            while cnt < childheight
              " TODO use forms#SetVCharsAt
              call forms#SetHCharsAt(char, f, line+cnt, column)

              let cnt += 1
            endwhile
          endif
          if b > 0
            " also do visual method
            let cnt = 0
            while cnt < childheight
              " TODO use forms#SetVCharsAt
              call forms#SetHCharsAt(char, b, line+cnt, column+childwidth+f)

              let cnt += 1
            endwhile
          endif
        endif

        call a:glyph.draw({
                            \ 'line': line,
                            \ 'column': column + f,
                            \ 'width': childwidth,
                            \ 'height': childheight
                            \ })

      elseif a:alignment == "R"
        if char != '' 
          " also do visual method
          let cnt = 0
          while cnt < childheight
            " TODO use forms#SetVCharsAt
            call forms#SetHCharsAt(char, m, line+cnt, column)

            let cnt += 1
          endwhile
        endif

        call a:glyph.draw({
                            \ 'line': line,
                            \ 'column': column + m,
                            \ 'width': childwidth,
                            \ 'height': childheight
                            \ })

      else
        throw "drawHAlign: bad alignment: " . a:alignment
      endif
    endif
  endfunction
  let g:forms_Util.drawHAlign = function("FORMS_UTIL_drawHAlign")

  " ------------------------------------------------------------ 
  " g:forms_Util.drawHVAlign {{{2
  "   Draw a glyph both vertically and horizontally aligned 
  "  parameters:
  "   glyph       : glyph to be aligned and drawn
  "   allocation  : dictionary of { 'line', 'column', 'width', 'height', 'childwidth', 'childheight' }
  "   halignment   : 0 <= float <= 1 or 'L', 'C' or 'R'
  "   valignment   : 0 <= float <= 1 or 'T', 'C' or 'B'
  "   char        : character to fill alignment spaces
  " ------------------------------------------------------------ 
  function! FORMS_UTIL_drawHVAlign(glyph, allocation, halignment, valignment, char) dict
" call forms#log("Util.drawHVAlign " .  string(a:allocation) . ", ha=" . a:halignment . ", va=" . a:valignment)
    let line = a:allocation.line
    let column = a:allocation.column
    let width = a:allocation.width
    let height = a:allocation.height
    let childwidth = a:allocation.childwidth
    let childheight = a:allocation.childheight

    let halignment = a:halignment
    let valignment = a:valignment
    let char = a:char

    if height <= childheight && width <= childwidth
      " currently do not clip to size, so draw body as is
      call a:glyph.draw({
                          \ 'line': line,
                          \ 'column': column,
                          \ 'width': childwidth,
                          \ 'height': childheight
                          \ })

    else

        if char != ''
          " [line, col, width, height]
          let l:tl = [-1, -1, -1, -1]
          let l:tc = [-1, -1, -1, -1]
          let l:tr = [-1, -1, -1, -1]
          let l:cl = [-1, -1, -1, -1]
          " cc is the body glyph
          let l:cr = [-1, -1, -1, -1]
          let l:bl = [-1, -1, -1, -1]
          let l:bc = [-1, -1, -1, -1]
          let l:br = [-1, -1, -1, -1]
        endif

        if height <= childheight 
          " width > childwidth
          let wdiff = width - childwidth
          let line_child = 0

          if type(halignment) == g:self#FLOAT_TYPE
            let l = float2nr(wdiff * halignment)
            let column_child = l
            if char != ''
              let r = wdiff - l
              let l:cl = [line, column, l, childheight]
              let l:cr = [line, column+childwidth+l, r, childheight]
            endif

          elseif halignment == "L"
            let column_child = 0
            let l:cr = [line, column+childwidth, wdiff, childheight]

          elseif halignment == "C"
            let l = (wdiff+1)/2
            let column_child = l
            if char != ''
              let r = wdiff - l
              let l:cl = [line, column, l, childheight]
              let l:cr = [line, column+childwidth+l, r, childheight]
            endif

          elseif halignment == "R"
            let column_child = wdiff
            if char != ''
              let l:cl = [line, column, wdiff, childheight]
            endif

          else
            throw "drawHVAlign: bad halignment: " . halignment
          endif

        elseif width <= childwidth
          " height > childheight
          let hdiff = height - childheight
          let column_child = 0

          if type(valignment) == g:self#FLOAT_TYPE
" call forms#log("drawHVAlign .valignment")
            let t = float2nr(hdiff * valignment)
            let line_child = t
            if char != ''
              let b = hdiff - l
              let l:tc = [line, column, childwidth, t]
              let l:bc = [line+childheight+t, column, childwidth, b]
            endif

          elseif valignment == "T"
" call forms#log("drawHVAlign .T")
            let line_child = 0
            if char != ''
              let l:bc = [line+childheight, column, childwidth, hdiff]
            endif

          elseif valignment == "C"
" call forms#log("drawHVAlign .C")
            let t = (hdiff+1)/2
            let line_child = t
            if char != ''
              let b = hdiff - t
              let l:tc = [line, column, childwidth, t]
              let l:bc = [line+childheight+t, column, childwidth, b]
            endif

          elseif valignment == "B"
" call forms#log("drawHVAlign .B")
            let line_child = hdiff
            if char != ''
              let l:tc = [line, column, childwidth, hdiff]
            endif

          else
            throw "drawHVAlign: bad valignment: " . valignment
          endif

        else
          " height > childheight
          " width > childwidth

          let wdiff = width - childwidth
          let hdiff = height - childheight
          if type(valignment) == g:self#FLOAT_TYPE
            if valignment == 0
              let vp = 'T'
            elseif valignment == 1
              let vp = 'B'
            else
              let vp = 'C'
              let t = float2nr(wdiff * valignment)
            endif
          else
            let vp = valignment
            if vp == 'C'
              let t = (hdiff+1)/2
            endif
          endif
          if type(halignment) == g:self#FLOAT_TYPE
            if halignment == 0
              let hp = 'L'
            elseif halignment == 1
              let hp = 'R'
            else
              let hp = 'C'
              let l = float2nr(hdiff * halignment)
            endif
          else
            let hp = halignment
            if hp == 'C'
              let l = (wdiff+1)/2
            endif
          endif

          if vp == 'T'
            let line_child = 0
            if hp == 'L'
              let column_child = 0
              if char != ''
                let l:cr = [line, column+childwidth, wdiff, childheight]
                let l:bc = [line+childheight, column, childwidth, hdiff]
                let l:br = [line+childheight, column+childwidth, wdiff, hdiff]
              endif

            elseif hp == 'C'
              let r = wdiff - l
              let column_child = l
              if char != ''
                let l:cl = [line, column, l, childheight]
                let l:bl = [line+childheight, column, l, hdiff]
                let l:bc = [line+childheight, column+l, childwidth, hdiff]
                let l:br = [line+childheight, column+childwidth+l, r, hdiff]
                let l:cr = [line, column+childwidth+l, r, childheight]
              endif

            elseif hp == 'R'
              let column_child = wdiff
              if char != ''
                let l:cl = [line, column, wdiff, childheight]
                let l:bl = [line+childheight, column, wdiff, hdiff]
                let l:bc = [line+childheight, column+wdiff, childwidth, hdiff]
              endif

            else
              throw "drawHVAlign: bad halignment: " . hp
            endif

          elseif vp == 'C'
            let b = hdiff - t
            let line_child = t
            if hp == 'L'
              let column_child = 0
              if char != ''
                let l:tc = [line, column, childwidth, t]
                let l:tr = [line, column+childwidth, wdiff, t]
                let l:cr = [line+t, column+childwidth, wdiff, childheight]
                let l:br = [line+childheight+t, column+childwidth, wdiff, b]
                let l:bc = [line+childheight+t, column, childwidth, b]
              endif

            elseif hp == 'C'
              let column_child = l
              if char != ''
                let r = wdiff - l
                let l:tl = [line, column, l, t]
                let l:tc = [line, column+l, childwidth, t]
                let l:tr = [line, column+l+childwidth, r, t]
                let l:cr = [line+t, column+l+childwidth, r, childheight]
                let l:br = [line+childheight+t, column+childwidth+l, r, b]
                let l:bc = [line+childheight+t, column+l, childwidth, b]
                let l:bl = [line+childheight+t, column, l, b]
                let l:cl = [line+t, column, l, childheight]
              endif

            elseif hp == 'R'
              let column_child = wdiff
              if char != ''
                let l:tl = [line, column, wdiff, t]
                let l:cl = [line+t, column, wdiff, childheight]
                let l:bl = [line+childheight+t, column, wdiff, b]
                let l:tc = [line, column+wdiff, childwidth, t]
                let l:bc = [line+childheight+t, column+wdiff, childwidth, b]
              endif

            else
              throw "drawHVAlign: bad halignment: " . hp
            endif

          elseif vp == 'B'
            let line_child = hdiff
            if hp == 'L'
              let column_child = 0
              if char != ''
                let l:tc = [line, column, childwidth, hdiff]
                let l:tr = [line, column+childwidth, wdiff, hdiff]
                let l:cr = [line+hdiff, column+childwidth, wdiff, childheight]
              endif

            elseif hp == 'C'
              let column_child = l
              if char != ''
                let r = wdiff - l
                let l:tl = [line, column, l, hdiff]
                let l:tc = [line, column+l, childwidth, hdiff]
                let l:tr = [line, column+l+childwidth, r, hdiff]
                let l:cl = [line+hdiff, column, l, childheight]
                let l:cr = [line+hdiff, column+l+childwidth, r, childheight]
              endif

            elseif hp == 'R'
              let column_child = wdiff
              if char != ''
                let l:tl = [line, column, wdiff, hdiff]
                let l:tc = [line, column+wdiff, childwidth, hdiff]
                let l:cl = [line+hdiff, column, wdiff, childheight]
              endif

            else
              throw "drawHVAlign: bad halignment: " . hp
            endif

          else
            throw "drawHVAlign: bad valignment: " . vp
          endif
          
        endif
"  call forms#log("drawHVAlign line_child=". line_child . ", column_child=" . column_child)

      if char != '' 
        " [line, column, width, height]
        call g:forms_Util.drawRect(l:tl, char)
        call g:forms_Util.drawRect(l:tc, char)
        call g:forms_Util.drawRect(l:tr, char)
        call g:forms_Util.drawRect(l:cl, char)
        call g:forms_Util.drawRect(l:cr, char)
        call g:forms_Util.drawRect(l:bl, char)
        call g:forms_Util.drawRect(l:bc, char)
        call g:forms_Util.drawRect(l:br, char)
      endif

      call a:glyph.draw({
                       \ 'line': line+line_child,
                       \ 'column': column+column_child,
                       \ 'width': childwidth,
                       \ 'height': childheight
                       \ })
    endif
" call forms#log("drawHVAlign BOTTOM ")
  endfunction
  let g:forms_Util.drawHVAlign = function("FORMS_UTIL_drawHVAlign")

endif


"-------------------------------------------------------------------------------
" Forms Color Utilities: {{{1
"  Gets Color Utility object that has numerous support methods
"    This utility deals with rgb and xterm 256 color values.
"  parameters: NONE
"-------------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:FCU")
    unlet g:FCU
  endif
endif
function! g:ColorUtil()
  if !exists("g:FCU")
    let g:FCU = { }

    " ------------------------------------------------------------ 
    " Define Int2RGB Dictionary: {{{2
    " ------------------------------------------------------------ 
    let g:FCU.Int2RGB = {
        \ '0': '000000',
        \ '1': '800000',
        \ '2': '008000',
        \ '3': '808000',
        \ '4': '000080',
        \ '5': '800080',
        \ '6': '008080',
        \ '7': 'c0c0c0',
        \ '8': '808080',
        \ '9': 'ff0000',
        \ '10': '00ff00',
        \ '11': 'ffff00',
        \ '12': '0000ff',
        \ '13': 'ff00ff',
        \ '14': '00ffff',
        \ '15': 'ffffff',
        \ '16': '000000',
        \ '17': '00005f',
        \ '18': '000087',
        \ '19': '0000af',
        \ '20': '0000d7',
        \ '21': '0000ff',
        \ '22': '005f00',
        \ '23': '005f5f',
        \ '24': '005f87',
        \ '25': '005faf',
        \ '26': '005fd7',
        \ '27': '005fff',
        \ '28': '008700',
        \ '29': '00875f',
        \ '30': '008787',
        \ '31': '0087af',
        \ '32': '0087d7',
        \ '33': '0087ff',
        \ '34': '00af00',
        \ '35': '00af5f',
        \ '36': '00af87',
        \ '37': '00afaf',
        \ '38': '00afd7',
        \ '39': '00afff',
        \ '40': '00d700',
        \ '41': '00d75f',
        \ '42': '00d787',
        \ '43': '00d7af',
        \ '44': '00d7d7',
        \ '45': '00d7ff',
        \ '46': '00ff00',
        \ '47': '00ff5f',
        \ '48': '00ff87',
        \ '49': '00ffaf',
        \ '50': '00ffd7',
        \ '51': '00ffff',
        \ '52': '5f0000',
        \ '53': '5f005f',
        \ '54': '5f0087',
        \ '55': '5f00af',
        \ '56': '5f00d7',
        \ '57': '5f00ff',
        \ '58': '5f5f00',
        \ '59': '5f5f5f',
        \ '60': '5f5f87',
        \ '61': '5f5faf',
        \ '62': '5f5fd7',
        \ '63': '5f5fff',
        \ '64': '5f8700',
        \ '65': '5f875f',
        \ '66': '5f8787',
        \ '67': '5f87af',
        \ '68': '5f87d7',
        \ '69': '5f87ff',
        \ '70': '5faf00',
        \ '71': '5faf5f',
        \ '72': '5faf87',
        \ '73': '5fafaf',
        \ '74': '5fafd7',
        \ '75': '5fafff',
        \ '76': '5fd700',
        \ '77': '5fd75f',
        \ '78': '5fd787',
        \ '79': '5fd7af',
        \ '80': '5fd7d7',
        \ '81': '5fd7ff',
        \ '82': '5fff00',
        \ '83': '5fff5f',
        \ '84': '5fff87',
        \ '85': '5fffaf',
        \ '86': '5fffd7',
        \ '87': '5fffff',
        \ '88': '870000',
        \ '89': '87005f',
        \ '90': '870087',
        \ '91': '8700af',
        \ '92': '8700d7',
        \ '93': '8700ff',
        \ '94': '875f00',
        \ '95': '875f5f',
        \ '96': '875f87',
        \ '97': '875faf',
        \ '98': '875fd7',
        \ '99': '875fff',
        \ '100': '878700',
        \ '101': '87875f',
        \ '102': '878787',
        \ '103': '8787af',
        \ '104': '8787d7',
        \ '105': '8787ff',
        \ '106': '87af00',
        \ '107': '87af5f',
        \ '108': '87af87',
        \ '109': '87afaf',
        \ '110': '87afd7',
        \ '111': '87afff',
        \ '112': '87d700',
        \ '113': '87d75f',
        \ '114': '87d787',
        \ '115': '87d7af',
        \ '116': '87d7d7',
        \ '117': '87d7ff',
        \ '118': '87ff00',
        \ '119': '87ff5f',
        \ '120': '87ff87',
        \ '121': '87ffaf',
        \ '122': '87ffd7',
        \ '123': '87ffff',
        \ '124': 'af0000',
        \ '125': 'af005f',
        \ '126': 'af0087',
        \ '127': 'af00af',
        \ '128': 'af00d7',
        \ '129': 'af00ff',
        \ '130': 'af5f00',
        \ '131': 'af5f5f',
        \ '132': 'af5f87',
        \ '133': 'af5faf',
        \ '134': 'af5fd7',
        \ '135': 'af5fff',
        \ '136': 'af8700',
        \ '137': 'af875f',
        \ '138': 'af8787',
        \ '139': 'af87af',
        \ '140': 'af87d7',
        \ '141': 'af87ff',
        \ '142': 'afaf00',
        \ '143': 'afaf5f',
        \ '144': 'afaf87',
        \ '145': 'afafaf',
        \ '146': 'afafd7',
        \ '147': 'afafff',
        \ '148': 'afd700',
        \ '149': 'afd75f',
        \ '150': 'afd787',
        \ '151': 'afd7af',
        \ '152': 'afd7d7',
        \ '153': 'afd7ff',
        \ '154': 'afff00',
        \ '155': 'afff5f',
        \ '156': 'afff87',
        \ '157': 'afffaf',
        \ '158': 'afffd7',
        \ '159': 'afffff',
        \ '160': 'd70000',
        \ '161': 'd7005f',
        \ '162': 'd70087',
        \ '163': 'd700af',
        \ '164': 'd700d7',
        \ '165': 'd700ff',
        \ '166': 'd75f00',
        \ '167': 'd75f5f',
        \ '168': 'd75f87',
        \ '169': 'd75faf',
        \ '170': 'd75fd7',
        \ '171': 'd75fff',
        \ '172': 'd78700',
        \ '173': 'd7875f',
        \ '174': 'd78787',
        \ '175': 'd787af',
        \ '176': 'd787d7',
        \ '177': 'd787ff',
        \ '178': 'd7af00',
        \ '179': 'd7af5f',
        \ '180': 'd7af87',
        \ '181': 'd7afaf',
        \ '182': 'd7afd7',
        \ '183': 'd7afff',
        \ '184': 'd7d700',
        \ '185': 'd7d75f',
        \ '186': 'd7d787',
        \ '187': 'd7d7af',
        \ '188': 'd7d7d7',
        \ '189': 'd7d7ff',
        \ '190': 'd7ff00',
        \ '191': 'd7ff5f',
        \ '192': 'd7ff87',
        \ '193': 'd7ffaf',
        \ '194': 'd7ffd7',
        \ '195': 'd7ffff',
        \ '196': 'ff0000',
        \ '197': 'ff005f',
        \ '198': 'ff0087',
        \ '199': 'ff00af',
        \ '200': 'ff00d7',
        \ '201': 'ff00ff',
        \ '202': 'ff5f00',
        \ '203': 'ff5f5f',
        \ '204': 'ff5f87',
        \ '205': 'ff5faf',
        \ '206': 'ff5fd7',
        \ '207': 'ff5fff',
        \ '208': 'ff8700',
        \ '209': 'ff875f',
        \ '210': 'ff8787',
        \ '211': 'ff87af',
        \ '212': 'ff87d7',
        \ '213': 'ff87ff',
        \ '214': 'ffaf00',
        \ '215': 'ffaf5f',
        \ '216': 'ffaf87',
        \ '217': 'ffafaf',
        \ '218': 'ffafd7',
        \ '219': 'ffafff',
        \ '220': 'ffd700',
        \ '221': 'ffd75f',
        \ '222': 'ffd787',
        \ '223': 'ffd7af',
        \ '224': 'ffd7d7',
        \ '225': 'ffd7ff',
        \ '226': 'ffff00',
        \ '227': 'ffff5f',
        \ '228': 'ffff87',
        \ '229': 'ffffaf',
        \ '230': 'ffffd7',
        \ '231': 'ffffff',
        \ '232': '080808',
        \ '233': '121212',
        \ '234': '1c1c1c',
        \ '235': '262626',
        \ '236': '303030',
        \ '237': '3a3a3a',
        \ '238': '444444',
        \ '239': '4e4e4e',
        \ '240': '585858',
        \ '241': '626262',
        \ '242': '6c6c6c',
        \ '243': '767676',
        \ '244': '808080',
        \ '245': '8a8a8a',
        \ '246': '949494',
        \ '247': '9e9e9e',
        \ '248': 'a8a8a8',
        \ '249': 'b2b2b2',
        \ '250': 'bcbcbc',
        \ '251': 'c6c6c6',
        \ '252': 'd0d0d0',
        \ '253': 'dadada',
        \ '254': 'e4e4e4',
        \ '255': 'eeeeee'
        \ }

    " ------------------------------------------------------------ 
    " Generate RGB2Int Dictionary: {{{2
    " ------------------------------------------------------------ 
    let g:FCU.RGB2Int = {}
    for [key, value] in items(g:FCU.Int2RGB)
      let g:FCU.RGB2Int[value] = key
    endfor

    " ------------------------------------------------------------ 
    " ParseRGB: {{{2
    "  Parses arguments into List of Number
    "  parameters:
    "    rgb     : String rgb value "0fe012"
    "              String rgb with '#' value "#0fe012"
    "              List ["r","g", "b"] triplet of Strings ["0f","e0","12"]
    "              List [rn,gn, bn] triplet of Numbers (0 <= n < 256)
    "              List [rf,gf, bf] triplet of Floats (0.0 <= f < 256.0)
    "              String r value "0f"
    "              Number (0 <= n < 256) representing r value
    "              Float (0.0 <= f < 256.0) representing r value
    "    g       : optional 
    "              String g value "e0"
    "              Number (0 <= n < 256)
    "              Float (0.0 <= f < 256.0)
    "    b       : optional
    "              String b value "12"
    "              Number (0 <= n < 256)
    "              Float (0.0 <= f < 256.0)
    " ------------------------------------------------------------ 
    function! FORMS_COLOR_UTIL_ParseRGB(rgb, ...) dict
"call forms#log("ParseRGB: TOP rgb=". string(a:rgb) . " a:0=" . a:0)
"let start = reltime()
      let needs_extra_args = g:self#IS_FALSE

      if type(a:rgb) == g:self#STRING_TYPE
        " remove hash
        let rgb = (a:rgb[0] == '#') ? a:rgb[1:] : a:rgb

        if len(rgb) == 2
          let rs = rgb
          let rn = str2nr(rs, 16)
          let needs_extra_args = g:self#IS_TRUE

        elseif len(rgb) == 6
          let rs = rgb[0:1]
          let gs = rgb[2:3]
          let bs = rgb[4:5]
          let rn = str2nr(rs, 16)
          let gn = str2nr(gs, 16)
          let bn = str2nr(bs, 16)

        else
          throw "ColorUtil.ParseRGB Bad String rgb value: ".  string(a:rgb)
        endif

      elseif type(a:rgb) == g:self#LIST_TYPE
        let rgb = a:rgb
        if len(rgb) != 3
          throw "ColorUtil.ParseRGB Bad List rgb value: ".  string(rgb)
        endif

        let rx = rgb[0]
        if type(rx) == g:self#NUMBER_TYPE
          let rn = rx
        elseif type(rx) == g:self#FLOAT_TYPE
          let rn = float2nr(rx)
        elseif type(rx) == g:self#STRING_TYPE
          let rs = rx
          let rn = str2nr(rs, 16)
        else
          throw "ColorUtil.ParseRGB Bad List r type: ".  string(rgb)
        endif

        let gx = rgb[1]
        if type(gx) == g:self#NUMBER_TYPE
          let gn = gx
        elseif type(gx) == g:self#FLOAT_TYPE
          let gn = float2nr(gx)
        elseif type(gx) == g:self#STRING_TYPE
          let gs = gx
          let gn = str2nr(gs, 16)
        else
          throw "ColorUtil.ParseRGB Bad List g type: " . string(rgb)
        endif

        let bx = rgb[2]
        if type(bx) == g:self#NUMBER_TYPE
          let bn = bx
        elseif type(bx) == g:self#FLOAT_TYPE
          let bn = float2nr(bx)
        elseif type(bx) == g:self#STRING_TYPE
          let bs = bx
          let bn = str2nr(bs, 16)
        else
          throw "ColorUtil.ParseRGB Bad List b type: " . string(rgb)
        endif

      elseif type(a:rgb) == g:self#NUMBER_TYPE
        let rn = a:rgb
        let needs_extra_args = g:self#IS_TRUE

      elseif type(a:rgb) == g:self#FLOAT_TYPE
        let rn = float2nr(a:rgb)
        let needs_extra_args = g:self#IS_TRUE

      else
        throw "ColorUtil.ParseRGB Bad rgb type: " . string(a:rgb)
      endif

      if needs_extra_args == g:self#IS_TRUE
        if a:0 != 2
          throw "ColorUtil.ParseRGB requires 2 additional arugments: a:0=".  a:0)
        endif

        let gx = a:1
        if type(gx) == g:self#NUMBER_TYPE
          let gn = gx
        elseif type(gx) == g:self#FLOAT_TYPE
          let gn = float2nr(gx)
        elseif type(gx) == g:self#STRING_TYPE
          let gs = gx
          let gn = str2nr(gs, 16)
        else
          throw "ColorUtil.ParseRGB Bad g type: ".  string(gx)
        endif

        let bx = a:2
        if type(bx) == g:self#NUMBER_TYPE
          let bn = bx
        elseif type(bx) == g:self#FLOAT_TYPE
          let bn = float2nr(bx)
        elseif type(bx) == g:self#STRING_TYPE
          let bs = bx
          let bn = str2nr(bs, 16)
        else
          throw "ColorUtil.ParseRGB Bad b type: " . string(bx)
        endif

      endif
"call forms#log("ParseRGB: time=". reltimestr(reltime(start)))

      return [rn,gn,bn]
    endfunction
    let g:FCU.ParseRGB = function("FORMS_COLOR_UTIL_ParseRGB")

    " ------------------------------------------------------------ 
    " TintRGB: {{{2
    "  Brighten rgb color returns Number triplet
    "  sat/val      brighten/darken
    "  '0.25:1',      0.75:0,0
    "  '0.5:1',       0.5:0.0
    "  '0.666:0.666', 0.33: -0.33
    "  '0.666:0.333', 0.33: -0.66
    "  '0.5:0.75',    0.5: -0.25
    "  '0.25:0.87'    0.75: -0.13
    " brighten 
    " adjust saturation
    " 1.0      0
    " 0.5     50
    " 0.0    100
    "  parameters:
    "    adjust : Float used to brighten or darken rgb color 
    "              value must be between 0 <= adujst <= 1
    "              if value < 0 treated as value = 0
    "              if value > 1 treated as value = 1
    "              zero values unchanged
    "              positive values brighten
    "    rn    : Parameters accepted by ParseRGB
    "    gn    : Parameters accepted by ParseRGB
    "    bn    : Parameters accepted by ParseRGB
    " ------------------------------------------------------------ 
    function! FORMS_COLOR_UTIL_TintRGB(adjust, rn, gn, bn) dict
      let adjust = a:adjust
      let rn = a:rn
      let gn = a:gn
      let bn = a:bn

      if adjust <= 0.0
        return [rn,gn,bn]
      elseif adjust >= 1.0
        return [255,255,255]
      else
        " float2nr drops part after decimal point
        let rn = float2nr(rn + ((256 - rn) * adjust))
        let gn = float2nr(gn + ((256 - gn) * adjust))
        let bn = float2nr(bn + ((256 - bn) * adjust))
        return [rn,gn,bn]
      endif
    endfunction
    let g:FCU.TintRGB = function("FORMS_COLOR_UTIL_TintRGB")

    " ------------------------------------------------------------ 
    " ShadeRGB: {{{2
    "  Darken rgb color returns Number triplet
    "  sat/val      brighten/darken
    "  '0.5:1',       0.5:0.0
    "  '0.25:1',      0.75:0,0
    "  '0.666:0.666', 0.33: -0.33
    "  '0.666:0.333', 0.33: -0.66
    "  '0.5:0.75',    0.5: -0.25
    "  '0.25:0.87'    0.75: -0.13
    " darken 
    " adjust value
    "  1.0    100
    "  0.5     50
    "  0.0      0
    "  parameters:
    "    adjust : Float used to brighten or darken rgb color 
    "              value must be between 0 <= adujst <= 1
    "              if value < 0 treated as value = 0
    "              if value > 1 treated as value = 1
    "              negative values darken
    "              zero values unchanged
    "              positive values brighten
    "    rgb    : Parameters accepted by ParseRGB
    " ------------------------------------------------------------ 
    function! FORMS_COLOR_UTIL_ShadeRGB(adjust, rn, gn, bn) dict
      let adjust = a:adjust
      let rn = a:rn
      let gn = a:gn
      let bn = a:bn

      if adjust <= 0.0
        return [rn,gn,bn]
      elseif adjust >= 1.0
        return [0,0,0]
      else
        let f = 1.0 - adjust
        " float2nr drops part after decimal point
        let rn = float2nr(rn * f)
        let gn = float2nr(gn * f)
        let bn = float2nr(bn * f)
        return [rn,gn,bn]
      endif
    endfunction
    let g:FCU.ShadeRGB = function("FORMS_COLOR_UTIL_ShadeRGB")

    
    " ------------------------------------------------------------ 
    " BrightnessRGB: {{{2
    "  Brighten or darken rgb color returns Number triplet
    "  sat/val      brighten/darken
    "  '0.5:1',       0.5:0.0
    "  '0.25:1',      0.75:0,0
    "  '0.666:0.666', 0.33: -0.33
    "  '0.666:0.333', 0.33: -0.66
    "  '0.5:0.75',    0.5: -0.25
    "  '0.25:0.87'    0.75: -0.13
    "  parameters:
    "    adjust : Float used to brighten or darken rgb color 
    "              value must be between -1 <= adujst <= 1
    "              negative values darken
    "              zero values unchanged
    "              positive values brighten
    "    rgb    : Parameters accepted by ParseRGB
    " ------------------------------------------------------------ 
    function! g:FCU.BrightnessRGBXX(adjust, rgb, ...) dict
" call forms#log("BrightnessRGB: TOP rgb=". string(a:rgb)." a:0=".a:0)
      if a:0 == 0
        let [rn,gn,bn] = self.ParseRGB(a:rgb)
      elseif a:0 == 2
        let [rn,gn,bn] = self.ParseRGB(a:rgb, a:000[0], a:000[1])
      else
          throw "ColorUtil.BrightnessRGB: Wrong number of additional arguments: " . a:0
      endif
    endfunction

    function! FORMS_COLOR_UTIL_BrightnessRGB(adjust, rn, gn, bn) dict
      let adjust = a:adjust
      let rn = a:rn
      let gn = a:gn
      let bn = a:bn

      if adjust >= 0
        " brighten 
        " adjust saturation
        " 1.0      0
        " 0.5     50
        " 0.0    100
        let rn = float2nr(rn + ((255 - rn) * adjust))
        let gn = float2nr(gn + ((255 - gn) * adjust))
        let bn = float2nr(bn + ((255 - bn) * adjust))
      else
        " darken 
        " adjust value
        " -1.0     0
        " -0.5    50
        " -0.0   100
        let f = adjust + 1.0
        let rn = float2nr(rn * f)
        let gn = float2nr(gn * f)
        let bn = float2nr(bn * f)
      endif

      return [rn,gn,bn]
    endfunction
    let g:FCU.BrightnessRGB = function("FORMS_COLOR_UTIL_BrightnessRGB")

    " ------------------------------------------------------------ 
    " MergerRGBs: {{{2
    "  Take "average" of two rgb strings
    "    Returns List rgb-average of parameter.
    "  parameters:
    "    rgb1 : Parameters accepted by ParseRGB
    "    rgb2 : Parameters accepted by ParseRGB
    " ------------------------------------------------------------ 
    function! FORMS_COLOR_UTIL_MergerRGBs(rgb1, rgb2) dict
" call forms#log("MergerRGBs: TOP rgb1=". a:rgb1)
" call forms#log("MergerRGBs: TOP rgb2=". a:rgb2)
      let [rn1,gn1,bn1] = self.ParseRGB(a:rgb1)
      let [rn2,gn2,bn2] = self.ParseRGB(a:rgb2)

      let rn = (rn1+rn2)/2
      let gn = (gn1+gn2)/2
      let bn = (bn1+bn2)/2

      return [rn, gn, bn]
    endfunction
    let g:FCU.MergerRGBs = function("FORMS_COLOR_UTIL_MergerRGBs")

    " ------------------------------------------------------------ 
    " ShiftHue: {{{2
    "  Shift hue by given adjustment
    "  parameters:
    "    shift : -0.5 <= float <= 0.5
    "    hue   : hue to be adjusted
    " ------------------------------------------------------------ 
    function! FORMS_COLOR_UTIL_ShiftHue(shift, hue) dict
" let hues = printf("%f",a:hue)
" call forms#log("ShiftHue: TOP hue=". hues)
      let hc = a:hue + a:shift
      if (hc >= 1.0) 
        let hc -= 1.0
      elseif (hc < 0.0) 
        let hc += 1.0
      endif
      return hc
    endfunction
    let g:FCU.ShiftHue = function("FORMS_COLOR_UTIL_ShiftHue")

    " ------------------------------------------------------------ 
    " ConvertRGB2HSL: {{{2
    "  Converts an rgb String HSL triplet [h,s,l]
    "     with values 0.0 <= v <= 1.0
    "  parameters:
    "    rn  : red Number
    "    gn  : green Number
    "    bn  : blue Number
    " ------------------------------------------------------------ 
    function! FORMS_COLOR_UTIL_ConvertRGB2HSL(rn, gn, bn) dict
      let rn = a:rn
      let gn = a:gn
      let bn = a:bn

" call forms#log("ConvertRGB2HSL: rn,gn,bn=".rn.",".gn.",".bn)
      let rf = (0.0 + rn)/255
      let gf = (0.0 + gn)/255
      let bf = (0.0 + bn)/255
      
      let minn = min([rn,gn,bn])
      let maxn = max([rn,gn,bn])

      let minf = (0.0 + minn)/255
      let maxf = (0.0 + maxn)/255
      let delf = maxf - minf
" let mins = printf("%f",minf)
" let maxs = printf("%f",maxf)
" call forms#log("ConvertRGB2HSL: min,max=".mins.",".maxs)

      let l = (maxf + minf)/2.0

      if delf == 0
        let h = 0.0
        let s = 0.0
      else
          if l < 0.5
            let s = delf/(maxf + minf)
          else
            let s = delf/(2 - maxf - minf)
          endif

          if rn == maxn
            let h = ((gf - bf)/delf) + ((gf < bf)? 6 : 0)
          elseif gn == maxn
            let h = ((bf - rf)/delf) + 2
          else 
            let h = ((rf - gf)/delf) + 4
          endif

          let h = h / 6
if 0
          let delfhalf = delf/2
          
          let dr = (((maxf - rf)/6) + delfhalf)/delf
          let dg = (((maxf - gf)/6) + delfhalf)/delf
          let db = (((maxf - bf)/6) + delfhalf)/delf

          if rn == maxn
            let h = db - dg
          elseif gn == maxn
            let h = 0.3333333 + dr - db
          else
            let h = 0.6666666 + dg - dr
          endif

          if h < 0
            let h += 1
          elseif h > 1 
            let h -= 1
          endif
endif
      endif
      return [h,s,l]
    endfunction
    let g:FCU.ConvertRGB2HSL = function("FORMS_COLOR_UTIL_ConvertRGB2HSL")

    " ------------------------------------------------------------ 
    " ReduceHSL: {{{2
    "  Generates HSL triplets one for each pair of Floats in List.
    "  parameters:
    "    h           : hue
    "    s           : saturation
    "    l           : value
    "    adjustments : List of List of Float pair to be applied to s and l
    " ------------------------------------------------------------ 
    function! FORMS_COLOR_UTIL_ReduceHSL(h,s,l, adjustments) dict
      let r = []
      for adj in a:adjustments
        let sadj = a[0]
        let vadj = a[1]
        call add(r, [a:h, a:s * sadj, a:l * vadj])
      endfor
      return r
    endfunction
    let g:FCU.ReduceHSL = function("FORMS_COLOR_UTIL_ReduceHSL")

    " ------------------------------------------------------------ 
    " ConvertHSL2RGB: {{{2
    "  Converts HSL Float triplet to RGB Float triplet 
    "  parameters:
    "    h           : hue
    "    s           : saturation
    "    l           : value
    " ------------------------------------------------------------ 
    function! FORMS_COLOR_UTIL_ConvertHSL2RGB(h,s,l) dict
"let hstr = printf("%f",a:h)
"let sstr = printf("%f",a:s)
"let lstr = printf("%f",a:l)
" call forms#log("ConvertHSL2RGB: TOP h,s,l=". hstr.",".sstr.",".lstr)
      let h = a:h
      let s = a:s
      let l = a:l

      if s == 0.0
" call forms#log("ConvertHSL2RGB: IF")
        let r = 255.0 * l
        let g = 255.0 * l
        let b = 255.0 * l
      else
" call forms#log("ConvertHSL2RGB: ELSE")
        if l < 0.5
          let v2 = l * (1 + s)
        else
          let v2 = (l + s) - (s * l)
        endif

        " let v1 = l - v2
        let v1 = 2 * l - v2

        function! Hue2RGB(v1, v2, vh)
          let vh = a:vh
          if vh < 0
            let vh += 1
          elseif vh > 1
            let vh -= 1
          endif

          if (6 * vh) < 1
            return a:v1 + (a:v2 - a:v1) * 6 * vh
          elseif (2 * vh) < 1
            return a:v2
          elseif (3 * vh) < 2
            return a:v1 + (a:v2 - a:v1) * (0.6666666 - vh) * 6
          else
            return a:v1
          endif
        endfunction

        let r = 255 * Hue2RGB(v1, v2, h + 0.3333333)
        let g = 255 * Hue2RGB(v1, v2, h)
        let b = 255 * Hue2RGB(v1, v2, h - 0.3333333)

      endif
      return [r,g,b]
    endfunction
    let g:FCU.ConvertHSL2RGB = function("FORMS_COLOR_UTIL_ConvertHSL2RGB")

    " ------------------------------------------------------------ 
    " ShiftHueRGBusingHSL: {{{2
    "  ShiftHues rgb returns rgb triplet using HSL
    "  parameters:
    "    shift : -0.5 <= float <= 0.5
    "    rn  : red Number
    "    gn  : green Number
    "    bn  : blue Number
    " ------------------------------------------------------------ 
    function! FORMS_COLOR_UTIL_ShiftHueRGBusingHSL(shift, rn, gn, bn) dict
      let hsl = self.ConvertRGB2HSL(a:rn, a:gn, a:bn)

      let h = hsl[0]
      let s = hsl[1]
      let l = hsl[2]
      let hc = self.ShiftHue(a:shift, h)
      return self.ConvertHSL2RGB(hc,s,l)
    endfunction
    let g:FCU.ShiftHueRGBusingHSL = function("FORMS_COLOR_UTIL_ShiftHueRGBusingHSL")

    " ------------------------------------------------------------ 
    " ComplimentRGBusingHSL: {{{2
    "  Returns HSL compliment of RGB Float triplet
    "  parameters:
    "    rn  : red Number
    "    gn  : green Number
    "    bn  : blue Number
    " ------------------------------------------------------------ 
    function! FORMS_COLOR_UTIL_ComplimentRGBusingHSL(rn, gn, bn) dict
      let shift = 180.0/360
      return self.ShiftHueRGBusingHSL(shift, a:rgb, a:000)
    endfunction
    let g:FCU.ComplimentRGBusingHSL = function("FORMS_COLOR_UTIL_ComplimentRGBusingHSL")

    " ------------------------------------------------------------ 
    " AnalogicRGBusingHSL: {{{2
    "  Returns HSL analogic values (+30,-30) of pair of RGB Float triplet
    "  parameters:
    "    rn  : red Number
    "    gn  : green Number
    "    bn  : blue Number
    " ------------------------------------------------------------ 
    function! FORMS_COLOR_UTIL_AnalogicRGBusingHSL(rn, gn, bn) dict
      let hsl = self.ConvertRGB2HSL(a:rn, a:gn, a:bn)
      let h = hsl[0]
      let s = hsl[1]
      let l = hsl[2]
      let shift = 30.0/360
      let hc1 = self.ShiftHue(shift, h)
      let hc2 = self.ShiftHue(-shift, h)
      return [self.ConvertHSL2RGB(hc1,s,l), self.ConvertHSL2RGB(hc2,s,l)]
    endfunction
    let g:FCU.AnalogicRGBusingHSL = function("FORMS_COLOR_UTIL_AnalogicRGBusingHSL")

    " ------------------------------------------------------------ 
    " SplitComplimentaryRGBusingHSL: {{{2
    "  Returns HSL split complimentary values 
    "  (180+30,180-30) of pair of RGB Float triplet
    "  parameters:
    "    rn  : red Number
    "    gn  : green Number
    "    bn  : blue Number
    " ------------------------------------------------------------ 
    function! FORMS_COLOR_UTIL_SplitComplimentaryRGBusingHSL(rn, gn, bn) dict
      let hsl = self.ConvertRGB2HSL(a:rn, a:gn, a:bn)
      let h = hsl[0]
      let s = hsl[1]
      let v = hsl[2]
      let half = 180.0/360
      let shift = 30.0/360
      let hc2 = self.ShiftHue(half-shift, h)
      let hc1 = self.ShiftHue(half+shift, h)
      return [self.ConvertHSL2RGV(hc1,s,v), self.ConvertHSL2RGV(hc2,s,v)]
    endfunction
    let g:FCU.SplitComplimentaryRGBusingHSL = function("FORMS_COLOR_UTIL_SplitComplimentaryRGBusingHSL")

    " ------------------------------------------------------------ 
    " TriadicRGBusingHSL: {{{2
    "  Returns HSL triadic values 
    "  (180+60,180-60) of pair of RGB Float triplet
    "  parameters:
    "    rn  : red Number
    "    gn  : green Number
    "    bn  : blue Number
    " ------------------------------------------------------------ 
    function! FORMS_COLOR_UTIL_TriadicRGBusingHSL(rn, gn, bn) dict
      let hsl = self.ConvertRGB2HSL(a:rn, a:gn, a:bn)
      let h = hsl[0]
      let s = hsl[1]
      let v = hsl[2]
      let half = 180.0/360
      let shift = 60.0/360
      let hc2 = self.ShiftHue(half-shift, h)
      let hc1 = self.ShiftHue(half+shift, h)
      return [self.ConvertHSL2RGV(hc1,s,v), self.ConvertHSL2RGV(hc2,s,v)]
    endfunction
    let g:FCU.TriadicRGBusingHSL = function("FORMS_COLOR_UTIL_TriadicRGBusingHSL")

    " ------------------------------------------------------------ 
    " ConvertRGB2HSV: {{{2
    "  Converts an rgb values HSV Float triplet
    "  parameters:
    "    rn  : red Number
    "    gn  : green Number
    "    bn  : blue Number
    " ------------------------------------------------------------ 
    function! FORMS_COLOR_UTIL_ConvertRGB2HSV(rn, gn, bn) dict
      let rn = a:rn
      let gn = a:gn
      let bn = a:bn

      let rf = (0.0 + rn)/255
      let gf = (0.0 + gn)/255
      let bf = (0.0 + bn)/255

      if rf < gf
        if rf < bf
          let x = rf
        else
          let x = bf
        endif
      else
        if gf < bf
          let x = gf
        else
          let x = bf
        endif
      endif

      if rf > gf
        if rf > bf
          let val = rf
        else
          let val = bf
        endif
      else
        if gf > bf
          let val = gf
        else
          let val = bf
        endif
      endif

      if x == val
        return [0.0, 0.0, val]
      else

        if rf == x
          let f = gf-bf
          let i = 3
        elseif gf == x
          let f = bf-rf
          let i = 5
        else
          let f = rf-gf
          let i = 1
        endif

        let d = val - x
        let hue = (i - f/d) / 6
        let sat = d/val

        return [hue,sat,val]
      endif
    endfunction
    let g:FCU.ConvertRGB2HSV = function("FORMS_COLOR_UTIL_ConvertRGB2HSV")


    " ReduceHSV: {{{2
    "  Generates HSV triplets one for each pair of Floats in List.
    "  parameters:
    "    h           : hue
    "    s           : saturation
    "    v           : value
    "    adjustments : List of List of Float pair to be applied to s and v
    " ------------------------------------------------------------ 
    function! FORMS_COLOR_UTIL_ReduceHSV(h,s,v, adjustments) dict
      let r = []
      for adj in a:adjustments
        let sadj = a[0]
        let vadj = a[1]
        call add(r, [a:h, a:s * sadj, a:v * vadj])
      endfor
      return r
    endfunction
    let g:FCU.ReduceHSV = function("FORMS_COLOR_UTIL_ReduceHSV")

    " ------------------------------------------------------------ 
    " ConvertHSV2RGB: {{{2
    "  Converts HSV Float triplet to RGB Float triplet
    "  parameters:
    "    h : hue
    "    s : saturation
    "    v : value
    " ------------------------------------------------------------ 
    function! FORMS_COLOR_UTIL_ConvertHSV2RGB(h,s,v) dict
"let hstr = printf("%f",a:h)
"let sstr = printf("%f",a:s)
"let vstr = printf("%f",a:v)
"call forms#log("ConvertHSV2RGB: TOP h,s,v=". hstr.",".sstr.",".vstr)
      let h = a:h
      let s = a:s
      let v = a:v

      let i = floor(h*6)
      let f = h * 6 - i
      let p = v * (1 - s)
      let q = v * (1 - f*s) 
      let t = v * (1 - (1-f)*s)

      let im = float2nr(i) % 6
      if im == 0
        let r = v
        let g = t
        let b = p
      elseif im == 1
        let r = q
        let g = v
        let b = p
      elseif im == 2
        let r = p
        let g = v
        let b = t
      elseif im == 3
        let r = p
        let g = q
        let b = v
      elseif im == 4
        let r = t
        let g = p
        let b = v
      else
        let r = v
        let g = p
        let b = q
      endif
      let offset = 0.000000000001
      return [
              \ float2nr((r * 255)+offset), 
              \ float2nr((g * 255)+offset), 
              \ float2nr((b * 255)+offset)]
    endfunction
    let g:FCU.ConvertHSV2RGB = function("FORMS_COLOR_UTIL_ConvertHSV2RGB")

    " ------------------------------------------------------------ 
    " ShiftHueRGBusingHSV: {{{2
    "  ShiftHues rgb returns RGB Float triplet using HSV
    "  parameters:
    "    shift : -0.5 <= float <= 0.5
    "    rn  : red Number
    "    gn  : green Number
    "    bn  : blue Number
    " ------------------------------------------------------------ 
    function! FORMS_COLOR_UTIL_ShiftHueRGBusingHSV(shift, rn, gn, bn) dict
" call forms#log("ShiftHueRGBusingHSV: TOP rgbstr=". a:rgb)
      let hsl = self.ConvertRGB2HSV(a:rn, a:gn, a:bn)
      let h = hsl[0]
      let s = hsl[1]
      let l = hsl[2]
      let hc = self.ShiftHue(a:shift, h)
      return self.ConvertHSV2RGB(hc,s,l)
    endfunction
    let g:FCU.ShiftHueRGBusingHSV = function("FORMS_COLOR_UTIL_ShiftHueRGBusingHSV")

    " ------------------------------------------------------------ 
    " ComplimentRGBusingHSV: {{{2
    "  Returns HSV compliment of RGB Float triplet
    "  parameters:
    "    rn  : red Number
    "    gn  : green Number
    "    bn  : blue Number
    " ------------------------------------------------------------ 
    function! FORMS_COLOR_UTIL_ComplimentRGBusingHSV(rn, gn, bn) dict
      let shift = 180.0/360
      return self.ShiftHueRGBusingHSV(shift, a:rn, a:gn, a:bn)
    endfunction
    let g:FCU.ComplimentRGBusingHSV = function("FORMS_COLOR_UTIL_ComplimentRGBusingHSV")

    " ------------------------------------------------------------ 
    " AnalogicRGBusingHSV: {{{2
    "  Returns HSV analogic values shifted (for example: +30,-30) 
    "     of pair of RGB Float triplet
    "  parameters:
    "    shift  : Float how much to shift hue + and -.
    "               Should be from 0.0 to 0.5
    "    rn     : red Number
    "    gn     : green Number
    "    bn     : blue Number
    " ------------------------------------------------------------ 
    function! FORMS_COLOR_UTIL_AnalogicRGBusingHSV(shift, rn, gn, bn) dict
      let hsl = self.ConvertRGB2HSV(a:rn, a:gn, a:bn)
      let h = hsl[0]
      let s = hsl[1]
      let v = hsl[2]
      let hc1 = self.ShiftHue(a:shift, h)
      let hc2 = self.ShiftHue(-a:shift, h)
      return [self.ConvertHSV2RGB(hc1,s,v), self.ConvertHSV2RGB(hc2,s,v)]
    endfunction
    let g:FCU.AnalogicRGBusingHSV = function("FORMS_COLOR_UTIL_AnalogicRGBusingHSV")

    " ------------------------------------------------------------ 
    " SplitComplimentaryRGBusingHSV: {{{2
    "  Returns HSV split complimentary values 
    "  (for example: 180+30,180-30) of pair of RGB Float triplet
    "  parameters:
    "    shift  : Float how much to shift hue + and -.
    "               Should be from 0.0 to 0.5
    "    rn     : red Number
    "    gn     : green Number
    "    bn     : blue Number
    " ------------------------------------------------------------ 
    function! FORMS_COLOR_UTIL_SplitComplimentaryRGBusingHSV(shift, rn, gn, bn) dict
      let hsl = self.ConvertRGB2HSV(a:rn, a:gn, a:bn)
      let h = hsl[0]
      let s = hsl[1]
      let v = hsl[2]
      let half = 180.0/360
      let hc2 = self.ShiftHue(half-a:shift, h)
      let hc1 = self.ShiftHue(half+a:shift, h)
      return [self.ConvertHSV2RGB(hc1,s,v), self.ConvertHSV2RGB(hc2,s,v)]
    endfunction
    let g:FCU.SplitComplimentaryRGBusingHSV = function("FORMS_COLOR_UTIL_SplitComplimentaryRGBusingHSV")

    " ------------------------------------------------------------ 
    " TriadicRGBusingHSV: {{{2
    "  Returns HSV triadic values 
    "  (+120,-120) of pair of RGB Float triplet
    "  parameters:
    "    rn  : red Number
    "    gn  : green Number
    "    bn  : blue Number
    " ------------------------------------------------------------ 
    function! FORMS_COLOR_UTIL_TriadicRGBusingHSV(rn, gn, bn) dict
      let hsl = self.ConvertRGB2HSV(a:rn, a:gn, a:bn)
      let h = hsl[0]
      let s = hsl[1]
      let v = hsl[2]
      let third = 120.0/360
      let hc2 = self.ShiftHue(-third, h)
      let hc1 = self.ShiftHue(+third, h)
      return [self.ConvertHSV2RGB(hc1,s,v), self.ConvertHSV2RGB(hc2,s,v)]
    endfunction
    let g:FCU.TriadicRGBusingHSV = function("FORMS_COLOR_UTIL_TriadicRGBusingHSV")

    " ------------------------------------------------------------ 
    " DoubleContrastRGBusingHSV: {{{2
    "  Returns RGB triple of values.
    "  (for example: -30,180,180-30) of triplets of RGB Float triplet
    "  parameters:
    "    shift  : Float how much to shift hue and compliment.
    "               Should be from 0.0 to 0.5
    "    rn     : red Number
    "    gn     : green Number
    "    bn     : blue Number
    " ------------------------------------------------------------ 
    function! FORMS_COLOR_UTIL_DoubleContrastRGBusingHSV(shift, rn, gn, bn) dict
      let hsl = self.ConvertRGB2HSV(a:rn, a:gn, a:bn)
      let h = hsl[0]
      let s = hsl[1]
      let v = hsl[2]
      let minus = -a:shift
      let minusHue = self.ShiftHue(minus, h)
      let half = 180.0/360
      let halfHue = self.ShiftHue(half, h)
      let halfminus = half - a:shift
      let halfminusHue = self.ShiftHue(halfminus, h)
      return [
              \ self.ConvertHSV2RGB(minusHue,s,v), 
              \ self.ConvertHSV2RGB(halfHue,s,v), 
              \ self.ConvertHSV2RGB(halfminusHue,s,v)]
    endfunction
    let g:FCU.DoubleContrastRGBusingHSV = function("FORMS_COLOR_UTIL_DoubleContrastRGBusingHSV")

    " ------------------------------------------------------------ 
    " ConvertRGB2IntNEW: {{{2
    "  Converts an rgb String to a xterm 256 Number
    "    Tried to make this fast.
    "    Returns the xterm 256 Number
    "  parameters:
    "    rgb : Parameters accepted by ParseRGB
    " ------------------------------------------------------------ 
    function! g:FCU.ConvertRGB2IntNewX(rgb, ...) dict
"call forms#log("ConvertRGB2IntNew: TOP rgbstr=". a:rgb)
      if a:0 == 0
        let [rn,gn,bn] = self.ParseRGB(a:rgb)
      elseif a:0 == 2
        let [rn,gn,bn] = self.ParseRGB(a:rgb, a:000[0], a:000[1])
      else
          throw "ColorUtil.ConvertRGB2IntNew: Wrong number of additional arguments: " . a:0
      endif
    endfunction
    function! g:FCU.ConvertRGB2IntNew(rn, gn, bn) dict
"let start = reltime()
      let rn = a:rn
      let gn = a:gn
      let bn = a:bn

"call forms#log("ConvertRGB2IntNew: in rn=". rn)
"call forms#log("ConvertRGB2IntNew: in gn=". gn)
"call forms#log("ConvertRGB2IntNew: in bn=". bn)
      
      " binary search over possible intensities
      function! GetPartial(n)
        " intensities=[0, 95, 135, 175, 215, 255]
        " intensities = (0x00, 0x5f, 0x87, 0xaf, 0xd7, 0xff)
        let n = a:n
        let n2 = n+n

        if n <= 135
          if n <= 95
            return (n2 <= 95) ? 0 : 95
          else
            return (n2 <= 230) ? 95 : 135 
          endif
        else
          if n <= 215
            if n <= 175
              return (n2 <= 310) ? 135 : 175
            else
              return (n2 <= 390) ? 175 : 215
            endif
          else
            return (n2 <= 470) ? 215 : 255
          endif
        endif
      endfunction

      let rnx = GetPartial(rn)
      let gnx = GetPartial(gn)
      let bnx = GetPartial(bn)
"call forms#log("ConvertRGB2IntNew: outjrnx=". rnx)
"call forms#log("ConvertRGB2IntNew: outjgnx=". gnx)
"call forms#log("ConvertRGB2IntNew: outjbnx=". bnx)

      " must check grey levels which can be a closer match
      " TODO how to tell if we are near a grey level and
      "   only do the following if we are near?
      let diff = abs(rnx-rn) + abs(gnx-gn) + abs(bnx-bn)
      let best_match = -1
      let cnt = 232
      while cnt < 256
        let [rx,gx,bx] = self.ColorTable[cnt]
        let d = abs(rx-rn) + abs(gx-gn) + abs(bx-bn)

        if d < diff
          let diff = d
          let best_match = cnt
        endif

        let cnt += 1
      endwhile

      if best_match != -1
"call forms#log("ConvertRGB2IntNew: best_match=". best_match)
        let n = best_match
      else
        let rgbtxt = printf('%02x%02x%02x',rnx,gnx,bnx)
"call forms#log("ConvertRGB2IntNew: rgbtxt=". rgbtxt)
        let n = self.RGB2Int[rgbtxt]
      endif
"call forms#log("ConvertRGB2IntNew:          time=". reltimestr(reltime(start)))
"call forms#log("ConvertRGB2IntNew: n=". n)
      return n
    endfunction


    " http://root.cern.ch/svn/root/tags/v5-30-06/core/textinput/src/textinput/TerminalDisplayUnix.cpp
    " http://crunchbanglinux.org/forums/topic/20674/view-images-and-gifs-in-the-terminal/
    " 6 intensity RGB
    " intensities=[0, 95, 135, 175, 215, 255]
    " intensities = (0x00, 0x5f, 0x87, 0xaf, 0xd7, 0xff)
    let g:FCU.intensities = [
              \ str2nr("0x00",16),
              \ str2nr("0x5f",16),
              \ str2nr("0x87",16),
              \ str2nr("0xaf",16),
              \ str2nr("0xd7",16),
              \ str2nr("0xff",16)
              \ ]

    " ------------------------------------------------------------ 
    " ConvertRGB2IntOLD: {{{2
    "  Converts an rgb String to a xterm 256 Number
    "    Tried to make this fast.
    "    Returns the xterm 256 Number
    "  parameters:
    "    rgb : Parameters accepted by ParseRGB
    " ------------------------------------------------------------ 
    function! g:FCU.ConvertRGB2IntOLD(rgb, ...) dict
"call forms#log("ConvertRGB2IntOLD: TOP rgbstr=". a:rgb)
      if a:0 == 0
        let [rn,gn,bn] = self.ParseRGB(a:rgb)
      elseif a:0 == 2
        let [rn,gn,bn] = self.ParseRGB(a:rgb, a:000[0], a:000[1])
      else
          throw "ColorUtil.ConvertRGB2IntOLD: Wrong number of additional arguments: " . a:0
      endif
let start = reltime()

"call forms#log("ConvertRGB2IntOLD: in rn=". rn)
"call forms#log("ConvertRGB2IntOLD: in gn=". gn)
"call forms#log("ConvertRGB2IntOLD: in bn=". bn)
      
      function! GetPartial(n, intensities)
        let n = a:n
        let intensities = a:intensities
        let s = intensities[0]
        let b = intensities[1]
        if s <= n && n <= b
"call forms#log("ConvertRGB2IntOLD: 0")
          return (n+n <= s+b) ? s : b
        endif
        let s = b
        let b = intensities[2]
        if s <= n && n <= b
"call forms#log("ConvertRGB2IntOLD: 1")
          return (n+n <= s+b) ? s : b
        endif
        let s = b
        let b = intensities[3]
        if s <= n && n <= b
"call forms#log("ConvertRGB2IntOLD: 2")
          return (n+n <= s+b) ? s : b
        endif
        let s = b
        let b = intensities[4]
        if s <= n && n <= b
"call forms#log("ConvertRGB2IntOLD: 3")
          return (n+n <= s+b) ? s : b
        endif
        let s = b
        let b = intensities[5]
        if s <= n && n <= b
"call forms#log("ConvertRGB2IntOLD: 4")
          return (n+n <= s+b) ? s : b
        endif
        throw "ConvertRGB2IntOLD.GetPartial: Bad partial color: " . string(n)
      endfunction

      let rnx = GetPartial(rn, self.intensities)
      let gnx = GetPartial(gn, self.intensities)
      let bnx = GetPartial(bn, self.intensities)
"call forms#log("ConvertRGB2IntOLD: rnx=". rnx)
"call forms#log("ConvertRGB2IntOLD: gnx=". gnx)
"call forms#log("ConvertRGB2IntOLD: bnx=". bnx)

      " must check grey levels which can be a closer match
      let diff = abs(rnx-rn) + abs(gnx-gn) + abs(bnx-bn)
      let best_match = -1
      let cnt = 232
      while cnt < 256
        let [rx,gx,bx] = self.ColorTable[cnt]
        let d = abs(rx-rn) + abs(gx-gn) + abs(bx-bn)

        if d < diff
          let diff = d
          let best_match = cnt
        endif

        let cnt += 1
      endwhile

      if best_match != -1
"call forms#log("ConvertRGB2IntOLD: best_match=". best_match)
        let n = best_match
      else
        let rgbtxt = printf('%02x%02x%02x',rnx,gnx,bnx)
"call forms#log("ConvertRGB2IntOLD: rgbtxt=". rgbtxt)
        let n = self.RGB2Int[rgbtxt]
      endif
"call forms#log("ConvertRGB2IntOLD: time=". reltimestr(reltime(start)))
"call forms#log("ConvertRGB2IntOLD: n=". n)
      return n
    endfunction

    " xterm number to rgb string
    let g:FCU.ColorTable = []
    " TODO make into list of [r,g,b] values
    let g:FCU.RedColorTable = []
    let g:FCU.GreenColorTable = []
    let g:FCU.BlueColorTable = []
    let cnt = 0
    while cnt < 256
      let rgb = g:FCU.Int2RGB[cnt]
      let r = rgb[0:1]
      let g = rgb[2:3]
      let b = rgb[4:5]
      let rn = str2nr(r, 16)
      let gn = str2nr(g, 16)
      let bn = str2nr(b, 16)
      call add(g:FCU.ColorTable, [rn,gn,bn])
      call add(g:FCU.RedColorTable, rn)
      call add(g:FCU.GreenColorTable, gn)
      call add(g:FCU.BlueColorTable, bn)

      let cnt += 1
    endwhile

    " http://crunchbanglinux.org/forums/topic/20674/view-images-and-gifs-in-the-terminal/
    " ------------------------------------------------------------ 
    " ConvertRGB2Int: {{{2
    "  Converts an rgb String to a xterm 256 Number
    "    Tried to make this fast.
    "    Returns the xterm 256 Number
    "  parameters:
    "    rgb : Parameters accepted by ParseRGB
    " ------------------------------------------------------------ 
    function! FORMS_COLOR_UTIL_ConvertRGB2Int(rgb, ...) dict
"call forms#log("ConvertRGB2Int: TOP rgb=". a:rgb)
      if a:0 == 0
        let [rn,gn,bn] = self.ParseRGB(a:rgb)
      elseif a:0 == 2
        let [rn,gn,bn] = self.ParseRGB(a:rgb, a:000[0], a:000[1])
      else
          throw "ColorUtil.ConvertRGB2Int: Wrong number of additional arguments: " . a:0
      endif
"let start = reltime()

"call forms#log("ConvertRGB2Int: in rn=". rn)
"call forms#log("ConvertRGB2Int: in gn=". gn)
"call forms#log("ConvertRGB2Int: in bn=". bn)
      let best_match = 0
      let diff = 10000000

      let cnt = 16
      while cnt < 256
        let [rx,gx,bx] = self.ColorTable[cnt]
        " let rx = self.RedColorTable[cnt]
        " let gx = self.GreenColorTable[cnt]
        " let bx = self.BlueColorTable[cnt]
        let d = abs(rx-rn) + abs(gx-gn) + abs(bx-bn)

        if d < diff
          let diff = d
          let best_match = cnt
        endif

        let cnt += 1
      endwhile
"call forms#log("ConvertRGB2Int: time=". reltimestr(reltime(start)))
"call forms#log("ConvertRGB2Int: best_match=". best_match)

if 0
let x = self.ConvertRGB2IntOLD(rn,gn,bn)
" call forms#log("ConvertRGB2Int:          x=". x)
if x != best_match
  throw "ConvertRGB2Int missmatch"
endif

let y = self.ConvertRGB2IntNew(rn,gn,bn)
" call forms#log("ConvertRGB2Int:          y=". y)
if y != best_match
  throw "ConvertRGB2Int missmatch"
endif
endif
      return best_match

    endfunction
    let g:FCU.ConvertRGB2Int = function("FORMS_COLOR_UTIL_ConvertRGB2Int")

    " ------------------------------------------------------------ 
    " ConvertInt2RGB: {{{2
    "  Converts an xterm 256 String or Number to an rgb String
    "    Returns the rgb String
    "  parameters:
    "    nr : String or Number or xterm 256 value
    "           value must be 0 <= value <= 255
    " ------------------------------------------------------------ 
    function! FORMS_COLOR_UTIL_ConvertInt2RGB(nr) dict
      if (type(a:nr) == g:self#NUMBER_TYPE)
        return self.Int2RGB[a:nr]
      elseif (type(a:nr) == g:self#STRING_TYPE)
        return self.Int2RGB[a:nr]
      else
        throw "ConvertInt2RGB: Bad number: " . string(a:nsstr)
      endif
    endfunction
    let g:FCU.ConvertInt2RGB = function("FORMS_COLOR_UTIL_ConvertInt2RGB")
  endif

  return g:FCU
endfunction

" returns [label, mnemonic, mindex]
" ------------------------------------------------------------ 
" s:MakeMenuMnemonic {{{1
"   Extract menu mnemonic from label and return list of label 
"     without '&', the mnemonic character and index of the 
"     mnemonic character.
"     If the label does not contain a '&', then list contains
"     label, no character and -1.
"     It is an error for the '&' to be in the end of the label.
"  parameters:
"   label       : label possible with a mnemonic character
" ------------------------------------------------------------ 
function! s:MakeMenuMnemonic(label)
    let labellen = len(a:label)
    let mindex = stridx(a:label, '&')
    if mindex == -1
      return [a:label, '', -1]
    elseif mindex == labellen-1
      throw "MakeMenuMnemonic: menu label mnemonic '&' at end of label: " . a:label
    endif
    let mnemonic = a:label[mindex+1]
    if mindex == 0
      let label = forms#SubString(a:label, 1)
    else
      let front = forms#SubString(a:label, 0, mindex)
      let back = forms#SubString(a:label, mindex+1)
      let label = front . back
    endif
"call forms#log("s:MakeMenuMnemonic mnemonic=".mnemonic)
"call forms#log("s:MakeMenuMnemonic label=".label)
"call forms#log("s:MakeMenuMnemonic mindex=".mindex)
    return [label, mnemonic, mindex]
endfunction

"-------------------------------------------------------------------------------
" Action Prototype: {{{1
"-------------------------------------------------------------------------------
" forms#loadActionPrototype: {{{2
"   Load and return Action Prototype object
"  parameters: NONE
" ------------------------------------------------------------ 
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms#Action")
    unlet g:forms#Action
  endif
endif
function! forms#loadActionPrototype()

  if !exists("g:forms#Action")
    let g:forms#Action = self#LoadObjectPrototype().clone('forms#Action')

    " ------------------------------------------------------------ 
    " ActionNoOp: {{{3
    "   Function used to initialize Action object.
    "     The function does nothing.
    "  parameters: optional
    " ------------------------------------------------------------ 
    function! ActionNoOp(...) dict
"call forms#log("g:forms#Action.ActionNoOp called")
    endfunction
    let g:forms#Action.__execute = function("ActionNoOp")

    " ------------------------------------------------------------ 
    " g:forms#Action.init: {{{3
    "   Initialize Action object
    "  parameters: 
    "   attrs  : attributes for initializing new object
    " ------------------------------------------------------------ 
    function! FORMS_ACTION_init(attrs) dict
      call call(g:self_ObjectPrototype.init, [a:attrs], self)
      if type(self.__execute) != g:self#FUNCREF_TYPE
        throw "Action: Not Fuction, bad execute type " . type(self.__execute)
      endif
      return self
    endfunction
    let g:forms#Action.init = function("FORMS_ACTION_init")

    " ------------------------------------------------------------ 
    " g:forms#Action.execute: {{{3
    "   Execute Action object
    "  parameters: optional (depends upon situation)
    " ------------------------------------------------------------ 
    function! FORMS_ACTION_execute(...) dict
"call forms#log("g:forms#Action.execute TOP a:000=" . string(a:000))
"call forms#log("g:forms#Action.execute self.__execute=" . string(self.__execute))
      call call(self.__execute, a:000, self)
    endfunction
    let g:forms#Action.execute = function("FORMS_ACTION_execute")
  endif

  return g:forms#Action
endfunction
" ------------------------------------------------------------ 
" forms#newAction: {{{2
"   Create new Action object
"  parameters: 
"   attrs  : attributes for initializing new object
" ------------------------------------------------------------ 
function! forms#newAction(attrs)
  return forms#loadActionPrototype().clone().init(a:attrs)
endfunction


" ------------------------------------------------------------ 
" FormsCancelAction: {{{2
"   Function that appends 'Cancel' event to imput queue.
"  parameters: 
"   attrs  : ignored
" ------------------------------------------------------------ 
function! FormsCancelAction(...) dict
"call forms#log("FormsCancelAction.execute")
    call forms#AppendInput({ 'type': 'Cancel' })
endfunction
" ------------------------------------------------------------ 
" g:forms#cancelAction: {{{2
"   Action object that calls the FormsCancelAction function.
" ------------------------------------------------------------ 
let g:forms#cancelAction = forms#newAction({ 'execute': function("FormsCancelAction")})

" ------------------------------------------------------------ 
" FormsSubmitAction: {{{2
"   Function that appends 'Submit' event to imput queue.
"  parameters: 
"   attrs  : ignored
" ------------------------------------------------------------ 
function! FormsSubmitAction(...) dict
"call forms#log("FormsSubmitAction.execute")
    call forms#AppendInput({ 'type': 'Submit' })
endfunction
" ------------------------------------------------------------ 
" g:forms#submitAction: {{{2
"   Action object that calls the FormsSubmitAction function.
" ------------------------------------------------------------ 
let g:forms#submitAction = forms#newAction({ 'execute': function("FormsSubmitAction")})

" ------------------------------------------------------------ 
" FormsExitAction: {{{2
"   Function that appends 'Exit' event to imput queue.
"  parameters: 
"   attrs  : ignored
" ------------------------------------------------------------ 
function! FormsExitAction(...) dict
"call forms#log("FormsExitAction.execute")
    call forms#AppendInput({ 'type': 'Exit' })
endfunction
" ------------------------------------------------------------ 
" g:forms#exitAction: {{{2
"   Action object that calls the FormsExitAction function.
" ------------------------------------------------------------ 
let g:forms#exitAction = forms#newAction({ 'execute': function("FormsExitAction")})


"-------------------------------------------------------------------------------
" Glyph Prototype: {{{1
"-------------------------------------------------------------------------------
" Glyph Utils: {{{2
"-------------------------------------------------------------------------------
" Glyph node types
"----------------------------
let g:LEAF_NODE = 'leaf'
let g:MONO_NODE = 'mono'
let g:POLY_NODE = 'poly'
let g:GRID_NODE = 'grid'

"----------------------------
" Status of glyph
"   enabled 
"     does everything
"   disabled 
"     draws but with a "disabled" hilight
"     can not be selected
"     does not hilight, 
"     can not accept focus
"     can not process event/char
"   invisible
"     does nothing, 
"     has no size, 
"     can not be selected
"     does not draw, 
"     does not hilight, 
"     can not accept focus
"     can not process event/char
" Examples
"   Label invisible
"     has zero allocation
"     contributes no size to any parent container
"     takes up one slot in parent Mono or Poly 
"     will not be seen
"----------------------------
let g:IS_ENABLED   = 1
let g:IS_DISABLED  = 2
let g:IS_INVISIBLE = 3


function! s:CheckStatus(status)
  if a:status != g:IS_ENABLED &&
          \ a:status != g:IS_DISABLED &&
          \ a:status != g:IS_INVISIBLE
    throw "Bad status value: " . string(a:status)
  endif
endfunction

"---------------------------------------------------------------------------
" Glyph <- Object: {{{2
"---------------------------------------------------------------------------
"   Glyph object for all Glyphs
"
" attributes
"   status   : there are three possible status values:
"                g:IS_ENABLED,  g:IS_DISABLED and g:IS_INVISIBLE.
"                Default is IS_ENABLED.
"   tag      : tag associated with glyph. Used to name the glyph
"               so that its results can be found in the results dictionary
" public methods
"   nodeType  : return 'leaf', 'mono', 'poly' or 'grid'
"   canFocus  : return 1 if glyph can get focus and 0 otherwise
"   gainFocus : notify glyph it has gained focus
"   loseFocus : notify glyph it has lost focus
"   hotspot   : indicates active "focus" spot in glyph
"   flash     : indicates input error if applicable
"   getTag    : return tag attribute value of "tag_" . "id of Object"
"   addResults: adds tag-resultvalue to results parameter if applicable
"   handleChar   : handles Character input when in focus
"   handleEvent  : handles Event input when in focus
"   requestedSize  : returns list of width and height required to
"                    display glyph
"   hide     : the glyph in not to be drawn, hide any associated display
"                    display attributes such as highlights
"   redraw   : the glyph is re-rendered with its allocation
"   draw     : the glyph is rendered within the provided allocation
"              which is a dictionary of 'line', 'column', 
"              'width', and 'height'
"   usage    : for glyphs that can have focus, describes how a user interacts
"              with the glyph.
"   purpose  : form (application) specific information.
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms#Glyph")
    unlet g:forms#Glyph
  endif
endif
function! forms#loadGlyphPrototype()

  if !exists("g:forms#Glyph")
    let g:forms#Glyph = self#LoadObjectPrototype().clone('forms#Glyph')
    let g:forms#Glyph.__allocation = {}
    let g:forms#Glyph.__status = g:IS_ENABLED

    " ------------------------------------------------------------ 
    " g:forms#Glyph.init: {{{3
    "   Initialize object
    "  parameters: 
    "   attrs  : 
    "       status : optional (default: IS_ENABLED)
    "       tag    : optional tag name associated with glyph
    "                (default "tag".__id)
    " ------------------------------------------------------------ 
    function! FORMS_GLYPH_init(attrs) dict
      call call(g:self_ObjectPrototype.init, [a:attrs], self)
      call s:CheckStatus(self.__status)
      return self
    endfunction
    let g:forms#Glyph.init = function("FORMS_GLYPH_init")

    " ------------------------------------------------------------ 
    " g:forms#Glyph.reinit: {{{3
    "   Re-initialize object
    "  parameters: 
    "   attrs  : same a init method
    " ------------------------------------------------------------ 
    function! FORMS_GLYPH_reinit(attrs) dict
" call forms#log("forms#Glyph.reinit TOP")
      " let self.__allocation = {}
      let self.__status = g:IS_ENABLED

      call GlyphDeleteHi(self)

      call self.init(a:attrs)
    endfunction
    let g:forms#Glyph.reinit = function("FORMS_GLYPH_reinit")


    " ------------------------------------------------------------ 
    " g:forms#Glyph.delete: {{{3
    "   Delete any Highlight's associated with glyph
    "   Calls Object Prototype delete
    "  parameters: No user parameters
    " ------------------------------------------------------------ 
    function! FORMS_GLYPH_delete(...) dict
"call forms#log("Glyph.delete: TOP")
      call GlyphDeleteHi(self)

      call call(g:self_ObjectPrototype.delete, a:000, self)
"call forms#log("Glyph.delete: BOTTOM")
    endfunction
    let g:forms#Glyph.delete = function("FORMS_GLYPH_delete")


    "-----------------------------------------------
    " status methods
    "-----------------------------------------------

    " ------------------------------------------------------------ 
    " g:forms#Glyph.setStatus: {{{3
    "   Set the status of the glyph
    "   Calls Object Prototype delete
    "   Will cause glyph to be redrawn. Possibly a ReSize of
    "   ReFocus event will be prepended to input queue.
    "  parameters: 
    "   status : new status value
    " ------------------------------------------------------------ 
    function! FORMS_GLYPH_setStatus(status) dict
      if self.__status != a:status
        call s:CheckStatus(a:status)

        " must force a top-level requestedSize call
        if a:status == g:IS_INVISIBLE || self.__status == g:IS_INVISIBLE 
"call forms#log("Glyph.setStatus: put ReSize")
          call forms#PrependUniqueInput({'type': 'ReSize'})
        elseif a:status == g:IS_DISABLED || self.__status == g:IS_DISABLED 
"call forms#log("Glyph.setStatus: put ReFocus")
          call forms#PrependUniqueInput({'type': 'ReFocus'})
        endif

        let self.__status = a:status

        call GlyphDeleteHi(self)

        call forms#ViewerRedrawListAdd(self) 
      endif
    endfunction
    let g:forms#Glyph.setStatus = function("FORMS_GLYPH_setStatus")

    " ------------------------------------------------------------ 
    " g:forms#Glyph.getStatus: {{{3
    "   Get the status of the glyph
    "  parameters: None
    " ------------------------------------------------------------ 
    function! FORMS_GLYPH_getStatus() dict
      return self.__status
    endfunction
    let g:forms#Glyph.getStatus = function("FORMS_GLYPH_getStatus")

    " ------------------------------------------------------------ 
    " g:forms#Glyph.isEnabled: {{{3
    "   Returns true if glyph status is IS_ENABLED
    "  parameters: None
    " ------------------------------------------------------------ 
    function! FORMS_GLYPH_isEnabled() dict
      return self.__status == g:IS_ENABLED
    endfunction
    let g:forms#Glyph.isEnabled = function("FORMS_GLYPH_isEnabled")

    " ------------------------------------------------------------ 
    " g:forms#Glyph.isDisabled: {{{3
    "   Returns true if glyph status is IS_DISABLED
    "  parameters: None
    " ------------------------------------------------------------ 
    function! FORMS_GLYPH_isDisabled() dict
      return self.__status == g:IS_DISABLED
    endfunction
    let g:forms#Glyph.isDisabled = function("FORMS_GLYPH_isDisabled")

    " ------------------------------------------------------------ 
    " g:forms#Glyph.isInvisible: {{{3
    "   Returns true if glyph status is IS_INVISIBLE
    "  parameters: None
    " ------------------------------------------------------------ 
    function! FORMS_GLYPH_isInvisible() dict
      return self.__status == g:IS_INVISIBLE
    endfunction
    let g:forms#Glyph.isInvisible = function("FORMS_GLYPH_isInvisible")

    "-----------------------------------------------
    " public methods
    "-----------------------------------------------

    " ------------------------------------------------------------ 
    " g:forms#Glyph.allocation: {{{3
    "   Returns glyph's allocation.
    "     The allocation is non-empty only if glyph is visible
    "  parameters: None
    " ------------------------------------------------------------ 
    function! FORMS_GLYPH_allocation() dict
      return self.__allocation
    endfunction
    let g:forms#Glyph.allocation = function("FORMS_GLYPH_allocation")

    " ------------------------------------------------------------ 
    " g:forms#Glyph.inAllocation: {{{3
    "   Returns true (1) if point (line,column) is within allication
    "     and false (0) otherwise.
    "     Returns false if glyph is not visible.
    "  parameters: 
    "     line   : line position
    "     column : column position
    " ------------------------------------------------------------ 
    function! FORMS_GLYPH_inAllocation(line, column) dict
      let a = self.__allocation
      return empty(a) ? 0 : a:line >= a.line && a:line < a.line + a.height &&
                      \ a:column >= a.column && a:column < a.column + a.width
    endfunction
    let g:forms#Glyph.inAllocation = function("FORMS_GLYPH_inAllocation")

    " ------------------------------------------------------------ 
    " g:forms#Glyph.nodeType: {{{3
    "   Returns the node type of the glyph:
    "     leaf, mono, poly or grid
    "  parameters: None
    " ------------------------------------------------------------ 
    function! FORMS_GLYPH_nodeType() dict
      throw "Glyph: must define in child: nodeType"
    endfunction
    let g:forms#Glyph.nodeType = function("FORMS_GLYPH_nodeType")

    " ------------------------------------------------------------ 
    " g:forms#Glyph.canFocus: {{{3
    "   Returns true (1) if the glyph can accept input focus
    "     and false (0) otherwise.
    "     Returns false if glyph is invisible
    "     (if status == g:IS_INVISIBLE then false)
    "  parameters: None
    " ------------------------------------------------------------ 
    function! FORMS_GLYPH_canFocus() dict
      return g:self#IS_FALSE
    endfunction
    let g:forms#Glyph.canFocus = function("FORMS_GLYPH_canFocus")

    " ------------------------------------------------------------ 
    " g:forms#Glyph.gainFocus: {{{3
    "   Notify glyph it has gained focus
    "  parameters: None
    " ------------------------------------------------------------ 
    function! FORMS_GLYPH_gainFocus() dict
    endfunction
    let g:forms#Glyph.gainFocus = function("FORMS_GLYPH_gainFocus")

    " ------------------------------------------------------------ 
    " g:forms#Glyph.loseFocus: {{{3
    "   Notify glyph it has lost focus
    "  parameters: None
    " ------------------------------------------------------------ 
    function! FORMS_GLYPH_loseFocus() dict
    endfunction
    let g:forms#Glyph.loseFocus = function("FORMS_GLYPH_loseFocus")

    " ------------------------------------------------------------ 
    " g:forms#Glyph.hotspot: {{{3
    "   Render glyph's hotspot. With focus, a glyph generates an
    "     input hotspot (similar to blinking cursor in many
    "     displays).
    "     Does not hotspot if glyph is invisible
    "     (if status != g:IS_INVISIBLE then hotspot)
    "  parameters: None
    " ------------------------------------------------------------ 
    function! FORMS_GLYPH_hotspot() dict
    endfunction
    let g:forms#Glyph.hotspot = function("FORMS_GLYPH_hotspot")

    " ------------------------------------------------------------ 
    " g:forms#Glyph.flash: {{{3
    "   Glyph produces a flash indicating an error on input 
    "     condition. 
    "     Does not flash if glyph is invisible
    "     (if status != g:IS_INVISIBLE then flash)
    "  parameters: None
    " ------------------------------------------------------------ 
    function! FORMS_GLYPH_flash() dict
    endfunction
    let g:forms#Glyph.flash = function("FORMS_GLYPH_flash")

    " ------------------------------------------------------------ 
    " g:forms#Glyph.getTag: {{{3
    "   Returns tag associated with glyph.
    "     The glyph's tag attribute can be set during initialization
    "     and this attribute value will be returned. If not set,
    "     then 'tag' . self.__id will be returned.
    "  parameters: None
    " ------------------------------------------------------------ 
    function! FORMS_GLYPH_getTag() dict
      if exists("self.__tag")
        return self.__tag
      else
        return 'tag_' . self._id
      endif
    endfunction
    let g:forms#Glyph.getTag = function("FORMS_GLYPH_getTag")

    " ------------------------------------------------------------ 
    " g:forms#Glyph.addResults: {{{3
    "   Adds any results associated with this glyph.
    "     The results parameter is used to capture the state of
    "     a glyph Form on form submit. The calling application 
    "     then takes the returned results and acts upon them.
    "  parameters: 
    "     results: type Dictionary of glyph-tag:value entries.
    " ------------------------------------------------------------ 
    function! FORMS_GLYPH_addResults(results) dict
    endfunction
    let g:forms#Glyph.addResults = function("FORMS_GLYPH_addResults")

    " ------------------------------------------------------------ 
    " g:forms#Glyph.handleEvent: {{{3
    "   Hand off an event to a glyph to be processed. It the glyph
    "     handles the event, then it returns 1 and non-handled
    "     return 0.
    "     Does not handle event if glyph is invisible
    "     (if status != g:IS_INVISIBLE then can handle)
    "  parameters: 
    "     event: the event to be processed
    " ------------------------------------------------------------ 
    function! FORMS_GLYPH_handleEvent(event) dict
" call forms#log("g:forms#Glyph.handleEvent event=" . string(a:event))
      return 0
    endfunction
    let g:forms#Glyph.handleEvent = function("FORMS_GLYPH_handleEvent")

    " ------------------------------------------------------------ 
    " g:forms#Glyph.handleChar: {{{3
    "   Hand off an character to a glyph to be processed. It the glyph
    "     handles the character, then it returns 1 and non-handled
    "     return 0.
    "     Does not handle character if glyph is invisible
    "     (if status != g:IS_INVISIBLE then can handle)
    "  parameters: 
    "     character: the character to be processed
    " ------------------------------------------------------------ 
    function! FORMS_GLYPH_handleChar(nr) dict
" call forms#log("g:forms#Glyph.handleChar nr=" . a:nr)
      return 0
    endfunction
    let g:forms#Glyph.handleChar = function("FORMS_GLYPH_handleChar")

    " ------------------------------------------------------------ 
    " g:forms#Glyph.requestedSize: {{{3
    "   Return the size, width/height, that the glyph requires
    "     in order to be rendered. This is the size the glyph
    "     would "like" to have.
    "     Generally, this is called when the Form is first created 
    "     and not called again. But, sometimes, if a ReSize 
    "     event is seen, this method might be called again.
    "     Return [width,height]
    "     (if status == g:IS_INVISIBLE then return [0,0])
    "  parameters: None
    " ------------------------------------------------------------ 
    function! FORMS_GLYPH_requestedSize() dict
      return [0,0]
    endfunction
    let g:forms#Glyph.requestedSize = function("FORMS_GLYPH_requestedSize")

    " ------------------------------------------------------------ 
    " g:forms#Glyph.hide: {{{3
    "   Glyph is not to be drawn, after having been drawn.
    "     Clear any lingering screen effects due to the drawing
    "     of this glyph, such as any highlights
    "  parameters: None
    " ------------------------------------------------------------ 

    function! FORMS_GLYPH_hide() dict
      " empty for most glyphs
    endfunction
    let g:forms#Glyph.hide = function("FORMS_GLYPH_hide")

    " ------------------------------------------------------------ 
    " g:forms#Glyph.redraw: {{{3
    "   Redraw the glyph with its current allocation.
    "     This method should not be called until its draw method
    "     has been called (it is the draw method that gives
    "     a glyph its allocation).
    "  parameters: None
    " ------------------------------------------------------------ 
    function! FORMS_GLYPH_redraw() dict
      call self.draw(self.__allocation)
    endfunction
    let g:forms#Glyph.redraw = function("FORMS_GLYPH_redraw")

    " allocation { 'line': n, 'column': n, 'width': n, 'height': n}
    " Only draws if glyph is visible
    " if status != g:IS_INVISIBLE then draw
    " if status != g:IS_DISABLED then add disable highlight
    " ------------------------------------------------------------ 
    " g:forms#Glyph.draw: {{{3
    "   Draw the glyph with the allocation parameter.
    "     The glyph should save its allocation so that the redraw
    "     method can be called.
    "  parameters: 
    "     allocation: { 'line': n, 'column': n, 'width': n, 'height': n}
    " ------------------------------------------------------------ 
    function! FORMS_GLYPH_draw(allocation) dict
      throw "Glyph: must define in child: draw"
    endfunction
    let g:forms#Glyph.draw = function("FORMS_GLYPH_draw")

    " ------------------------------------------------------------ 
    " g:forms#Glyph.purpose: {{{3
    "   Returns the "application-specific" purpose of given
    "     glyph as List of text lines or a String of text
    "     with lines separated by '\n'.
    "     Each developer should redefine this method for all
    "     glyphs to provide context sensitive information.
    "  parameters: None
    " ------------------------------------------------------------ 
    function! FORMS_GLYPH_purpose() dict
      return "No purpose information provided"
    endfunction
    let g:forms#Glyph.purpose = function("FORMS_GLYPH_purpose")

    " ------------------------------------------------------------ 
    " g:forms#Glyph.usage: {{{3
    "   Returns the "application-independent" usage of given
    "     glyph as List of text lines or a String of text
    "     with lines separated by '\n'.
    "     Generally, developers should NOT redefine these
    "     methods. They provide information for end users
    "     concerning how a particular glyph can be interacted.
    "     Glyphs that can acquire focus have such information
    "     to provide context sensitive information.
    "  parameters: None
    " ------------------------------------------------------------ 
    function! FORMS_GLYPH_usage() dict
      return "No usage information provided"
    endfunction
    let g:forms#Glyph.usage = function("FORMS_GLYPH_usage")
  endif

  return g:forms#Glyph
endfunction

"-------------------------------------------------------------------------------
" Leaf Prototype: {{{1
"-------------------------------------------------------------------------------
" Leaf <- Glyph: {{{2
"   A glyph that contains no child glyphs
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms#Leaf")
    unlet g:forms#Leaf
  endif
endif
function! forms#loadLeafPrototype()

  if !exists("g:forms#Leaf")
    let g:forms#Leaf = forms#loadGlyphPrototype().clone('forms#Leaf')

    function! FORMS_LEAF_nodeType() dict
      return g:LEAF_NODE
    endfunction
    let g:forms#Leaf.nodeType = function("FORMS_LEAF_nodeType")

  endif

  return g:forms#Leaf
endfunction

"---------------------------------------------------------------------------
" NullGlyph <- Leaf: {{{2
"   A glyph that does nothing, has no size and no data
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms#NullGlyph")
    unlet g:forms#NullGlyph
  endif
endif
function! forms#loadNullGlyphPrototype()

  if !exists("g:forms#NullGlyph")
    let g:forms#NullGlyph = forms#loadLeafPrototype().clone('forms#NullGlyph')
    " Has now size
    let g:forms#NullGlyph.__allocation = {
                                          \ 'line': -1,
                                          \ 'column': -1,
                                          \ 'width': 0,
                                          \ 'height': 0
                                          \ }

    function! FORMS_NULL_GLYPH_delete(...) dict
      " Do not delete since instances may be used as singletons
      " See Utils nullGlyph() method
    endfunction
    let g:forms#NullGlyph.delete = function("FORMS_NULL_GLYPH_delete")

    function! FORMS_NULL_GLYPH_draw(allocation) dict
    endfunction
    let g:forms#NullGlyph.draw = function("FORMS_NULL_GLYPH_draw")
  endif

  return g:forms#NullGlyph
endfunction
function! forms#newNullGlyph(attrs)
  return forms#loadNullGlyphPrototype().clone().init(a:attrs)
endfunction

"---------------------------------------------------------------------------
" Line <- Leaf: {{{2
"---------------------------------------------------------------------------
" Abstract glyph object for vertical or horizontal line. A line has a length
"   and a width/height of 1 (depending upon vertical or horizontal)
" attributes
"   size     : length of the line
"   char     : optional character used to fill line 
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms#Line")
    unlet g:forms#Line
  endif
endif
function! forms#loadLinePrototype()
  if !exists("g:forms#Line")
    let g:forms#Line = forms#loadLeafPrototype().clone('forms#Line')
    let g:forms#Line.__char = ''
    let g:forms#Line.__size = 0

    function! FORMS_LINE_init(attrs) dict
      call call(g:forms#Leaf.init, [a:attrs], self)

      if self.__size < 0
        throw "Line: size < 0: " self.__size
      endif
      if self.__char != ''
        let len = strchars(self.__char)
        if len != 1
          throw "Line.init: char ".self.__char." not of length 1; " . len
        endif
      endif

      return self
    endfunction
    let g:forms#Line.init = function("FORMS_LINE_init")

    function! FORMS_LINE_reinit(attrs) dict
" call forms#log("forms#Line.reinit TOP")
      let oldSize = self.__size

      let self.__char = ''
      let self.__size = 0

      call call(g:forms#Leaf.reinit, [a:attrs], self)

      if oldSize != self.__size
        call forms#PrependUniqueInput({'type': 'ReSize'})
      else
        call forms#ViewerRedrawListAdd(self) 
      endif
    endfunction
    let g:forms#Line.reinit = function("FORMS_LINE_reinit")
  endif

  return g:forms#Line
endfunction

"---------------------------------------------------------------------------
" HLine <- Line: {{{2
"---------------------------------------------------------------------------
" Horizontal line
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms#HLine")
    unlet g:forms#HLine
  endif
endif
function! forms#loadHLine()

  if !exists("g:forms#HLine")
    let g:forms#HLine = forms#loadLinePrototype().clone('forms#HLine')

    function! FORMS_HLINE_requestedSize() dict
      return (self.__status == g:IS_INVISIBLE) ? [0,0] : [self.__size,1]
    endfunction
    let g:forms#HLine.requestedSize = function("FORMS_HLINE_requestedSize")

    function! FORMS_HLINE_draw(allocation) dict
" call forms#log("g:forms#HLine.draw" .  string(a:allocation))
      " [line, column, width, height]
      let self.__allocation = a:allocation
      let a = a:allocation

      if self.__status != g:IS_INVISIBLE

        " [line, column, size]
        let rec = [a.line, a.column, a.width]
        call g:forms_Util.drawHLine(rec, self.__char)
      endif

      if self.__status == g:IS_DISABLED
        call AugmentGlyphHilight(self, "DisableHi", a)
      endif                     
    endfunction
    let g:forms#HLine.draw = function("FORMS_HLINE_draw")

  endif

  return g:forms#HLine
endfunction
" ------------------------------------------------------------ 
" forms#newHLine: {{{2
"   Create new Horizontal Line
"  parameters: 
"   attrs  : attributes for initializing new object
" ------------------------------------------------------------ 
function! forms#newHLine(attrs)
  return forms#loadHLine().clone().init(a:attrs)
endfunction

"---------------------------------------------------------------------------
" VLine <- Line: {{{2
"---------------------------------------------------------------------------
" Vertical line
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms#VLine")
    unlet g:forms#VLine
  endif
endif
function! forms#loadVLine()

  if !exists("g:forms#VLine")
    let g:forms#VLine = forms#loadLinePrototype().clone('forms#VLine')

    function! FORMS_VLINE_requestedSize() dict
      return (self.__status == g:IS_INVISIBLE) ? [0,0] : [1,self.__size]
    endfunction
    let g:forms#VLine.requestedSize = function("FORMS_VLINE_requestedSize")

    function! FORMS_VLINE_draw(allocation) dict
"call forms#log("g:forms#VLine.draw" .  string(a:allocation))
      let self.__allocation = a:allocation
      let a = a:allocation

      if self.__status != g:IS_INVISIBLE
        " [line, column, size]
        let rec = [a.line, a.column, a.height]
        call g:forms_Util.drawVLine(rec, self.__char)
      endif

      if self.__status == g:IS_DISABLED
        call AugmentGlyphHilight(self, "DisableHi", a)
      endif                     

    endfunction
    let g:forms#VLine.draw = function("FORMS_VLINE_draw")

  endif

  return g:forms#VLine
endfunction
" ------------------------------------------------------------ 
" forms#newVLine: {{{2
"   Create new Vertical Line
"  parameters: 
"   attrs  : attributes for initializing new object
" ------------------------------------------------------------ 
function! forms#newVLine(attrs)
  return forms#loadVLine().clone().init(a:attrs)
endfunction

"---------------------------------------------------------------------------
" Area <- Leaf: {{{2
"---------------------------------------------------------------------------
" Glyph object for an area.
" attributes
"   width    : width of area
"   height   : height of area
"   char     : optional character used to fill line 
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms#Area")
    unlet g:forms#Area
  endif
endif
function! forms#loadAreaPrototype()
  if !exists("g:forms#Area")
    let g:forms#Area = forms#loadLeafPrototype().clone('forms#Area')
    let g:forms#Area.__char = ''
    let g:forms#Area.__width = 0
    let g:forms#Area.__height = 0

    function! FORMS_AREA_init(attrs) dict
      call call(g:forms#Leaf.init, [a:attrs], self)

      if self.__width < 0
        throw "Area: width < 0: " self.__width
      endif
      if self.__height < 0
        throw "Area: height < 0: " self.__height
      endif
      if self.__char != ''
        let len = strchars(self.__char)
        if len != 1
          throw "Area.init: char ".self.__char." not of length 1; " . len
        endif
      endif

      return self
    endfunction
    let g:forms#Area.init = function("FORMS_AREA_init")

    function! FORMS_AREA_reinit(attrs) dict
" call forms#log("forms#Area.reinit TOP")
      let oldWidth = self.__width
      let oldHeight = self.__height

      let self.__char = ''
      let self.__width = 0
      let self.__height = 0

      call call(g:forms#Leaf.reinit, [a:attrs], self)

      if oldWidth != self.__width
        call forms#PrependUniqueInput({'type': 'ReSize'})
      elseif oldHeight != self.__height
      else
        call forms#ViewerRedrawListAdd(self) 
      endif
    endfunction
    let g:forms#Area.reinit = function("FORMS_AREA_reinit")

    function! FORMS_AREA_requestedSize() dict
      return (self.__status == g:IS_INVISIBLE) ? [0,0] 
                    \ : [self.__width, self.__height]
    endfunction
    let g:forms#Area.requestedSize = function("FORMS_AREA_requestedSize")

    function! FORMS_AREA_draw(allocation) dict
" call forms#log("g:forms#Area.draw" .  string(a:allocation))
      let self.__allocation = a:allocation
      let a = a:allocation

      if self.__status != g:IS_INVISIBLE
        let box = [a.line, a.column, self.__width, self.__height]
        call g:forms_Util.drawRect(box, self.__char)
      endif
      if self.__status == g:IS_DISABLED
        call AugmentGlyphHilight(self, "DisableHi", a)
      endif                     

    endfunction
    let g:forms#Area.draw = function("FORMS_AREA_draw")
  endif

  return g:forms#Area
endfunction
" ------------------------------------------------------------ 
" forms#newArea: {{{2
"   Create new Area
"  parameters: 
"   attrs  : attributes for initializing new object
" ------------------------------------------------------------ 
function! forms#newArea(attrs)
  return forms#loadAreaPrototype().clone().init(a:attrs)
endfunction

"---------------------------------------------------------------------------
" Space <- Leaf: {{{2
"------------------------------------------------
" Glyph object for vertical or horizontal space. A shape has a size
"   and a width/height that fills the provided allocation.
"
" attributes
"   size     : length of the space
"   char     : optional character used to fill space 
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms#Space")
    unlet g:forms#Space
  endif
endif
function! forms#loadSpacePrototype()

  if !exists("g:forms#Space")
    let g:forms#Space = forms#loadLeafPrototype().clone('forms#Space')
    let g:forms#Space.__char = ''
    let g:forms#Space.__size = 0

    function! FORMS_SPACE_init(attrs) dict
      call call(g:forms#Leaf.init, [a:attrs], self)

      if self.__size < 0
        throw "Space: size < 0: " self.__size
      endif
      if self.__char != ''
        let len = strchars(self.__char)
        if len != 1
          throw "Space.init: char ".self.__char." not of length 1; " . len
        endif
      endif

      return self
    endfunction
    let g:forms#Space.init = function("FORMS_SPACE_init")

    function! FORMS_SPACE_reinit(attrs) dict
" call forms#log("forms#Space.reinit TOP")
      let oldSize = self.__size

      let self.__char = ''
      let self.__size = 0

      call call(g:forms#Leaf.reinit, [a:attrs], self)

      if oldSize != self.__size
        call forms#PrependUniqueInput({'type': 'ReSize'})
      else
        call forms#ViewerRedrawListAdd(self) 
      endif
    endfunction
    let g:forms#Space.reinit = function("FORMS_SPACE_reinit")

  endif

  return g:forms#Space
endfunction

"---------------------------------------------------------------------------
" HSpace <- Space: {{{2
"---------------------------------------------------------------------------
" Horizontal space with a length of 'size' and the height of its allocation.
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms#HSpace")
    unlet g:forms#HSpace
  endif
endif

function! forms#loadHSpace()
  if !exists("g:forms#HSpace")
    let g:forms#HSpace = forms#loadSpacePrototype().clone('forms#HSpace')

    function! FORMS_HSPACE_requestedSize() dict
      return (self.__status == g:IS_INVISIBLE) ? [0,0] : [self.__size,1]
    endfunction
    let g:forms#HSpace.requestedSize = function("FORMS_HSPACE_requestedSize")

    function! FORMS_HSPACE_draw(allocation) dict
" call forms#log("g:forms#HSpace.draw" .  string(a:allocation))
      let self.__allocation = a:allocation
      let a = a:allocation

      if self.__status != g:IS_INVISIBLE
        let box = [a.line, a.column, a.width, a.height]
        call g:forms_Util.drawRect(box, self.__char)
      endif
      if self.__status == g:IS_DISABLED
        call AugmentGlyphHilight(self, "DisableHi", a)
      endif                     

    endfunction
    let g:forms#HSpace.draw = function("FORMS_HSPACE_draw")
  endif

  return g:forms#HSpace
endfunction
" ------------------------------------------------------------ 
" forms#newHSpace: {{{2
"   Create new Horizontal Space
"  parameters: 
"   attrs  : attributes for initializing new object
" ------------------------------------------------------------ 
function! forms#newHSpace(attrs)
  return forms#loadHSpace().clone().init(a:attrs)
endfunction

"---------------------------------------------------------------------------
" VSpace <- Space: {{{2
"---------------------------------------------------------------------------
" Vertical space with a length of 'size' and the width of its allocation.
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms#VSpace")
    unlet g:forms#VSpace
  endif
endif
function! forms#loadVSpace()

  if !exists("g:forms#VSpace")
    let g:forms#VSpace = forms#loadSpacePrototype().clone('forms#VSpace')

    function! FORMS_VSPACE_requestedSize() dict
      return (self.__status == g:IS_INVISIBLE) ? [0,0] : [1,self.__size]
    endfunction
    let g:forms#VSpace.requestedSize = function("FORMS_VSPACE_requestedSize")

    function! FORMS_VSPACE_draw(allocation) dict
" call forms#log("g:forms#VSpace.draw" .  string(a:allocation))
      let self.__allocation = a:allocation
      let a = a:allocation

      if self.__status != g:IS_INVISIBLE
        let box = [a.line, a.column, a.width, a.height]
        call g:forms_Util.drawRect(box, self.__char)
      endif
      if self.__status == g:IS_DISABLED
        call AugmentGlyphHilight(self, "DisableHi", a)
      endif                     
    endfunction
    let g:forms#VSpace.draw = function("FORMS_VSPACE_draw")

  endif

  return g:forms#VSpace
endfunction
" ------------------------------------------------------------ 
" forms#newVSpace: {{{2
"   Create new Vertical Space
"  parameters: 
"   attrs  : attributes for initializing new object
" ------------------------------------------------------------ 
function! forms#newVSpace(attrs)
  return forms#loadVSpace().clone().init(a:attrs)
endfunction

"---------------------------------------------------------------------------
" Label <- Leaf: {{{2
"---------------------------------------------------------------------------
" A Horizontal Label.
"
" attributes
"   text     : the text of the label
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms#Label")
    unlet g:forms#Label
  endif
endif
function! forms#loadLabelPrototype()
  if !exists("g:forms#Label")
    let g:forms#Label = forms#loadLeafPrototype().clone('forms#Label')
    let g:forms#Label.__text = ''

    function! FORMS_LABEL_reinit(attrs) dict
" call forms#log("forms#Label.reinit TOP")
      let oldText = self.__text

      let self.__text = ''

      call call(g:forms#Leaf.reinit, [a:attrs], self)

      if oldText != self.__text
        call forms#PrependUniqueInput({'type': 'ReSize'})
      else
        call forms#ViewerRedrawListAdd(self) 
      endif
    endfunction
    let g:forms#Label.reinit = function("FORMS_LABEL_reinit")

    function! FORMS_LABEL_requestedSize() dict
      return (self.__status == g:IS_INVISIBLE) 
              \ ? [0,0] : [strchars(self.__text),1]
    endfunction
    let g:forms#Label.requestedSize = function("FORMS_LABEL_requestedSize")

    function! FORMS_LABEL_draw(allocation) dict
" call forms#log("g:forms#Label.draw" .  string(a:allocation))
      let self.__allocation = a:allocation
      let a = a:allocation

      if self.__status != g:IS_INVISIBLE
        let tlen = strchars(self.__text)
        if tlen > 0
          call forms#SetStringAt(self.__text, a.line, a.column)
        endif
      endif

      if self.__status == g:IS_DISABLED
        call AugmentGlyphHilight(self, "DisableHi", a)
      endif
    endfunction
    let g:forms#Label.draw = function("FORMS_LABEL_draw")
  endif

  return g:forms#Label
endfunction
" ------------------------------------------------------------ 
" forms#newLabel: {{{2
"   Create new (horizontal) Label
"  parameters: 
"   attrs  : attributes for initializing new object
" ------------------------------------------------------------ 
function! forms#newLabel(attrs)
  return forms#loadLabelPrototype().clone().init(a:attrs)
endfunction

"---------------------------------------------------------------------------
" VLabel <- Leaf: {{{2
"---------------------------------------------------------------------------
" A Vertical Label.
"
" attributes
"   text     : the text of the label
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms#VLabel")
    unlet g:forms#VLabel
  endif
endif
function! forms#loadVLabelPrototype()
  if !exists("g:forms#VLabel")
    let g:forms#VLabel = forms#loadLeafPrototype().clone('forms#VLabel')
    let g:forms#VLabel.__text = ''

    function! FORMS_VLABEL_reinit(attrs) dict
"call forms#log("forms#VLabel.reinit TOP")
      let oldText = self.__text

      let self.__text = ''

      call call(g:forms#Leaf.reinit, [a:attrs], self)

      if oldText != self.__text
        call forms#PrependUniqueInput({'type': 'ReSize'})
      else
        call forms#ViewerRedrawListAdd(self) 
      endif
    endfunction
    let g:forms#VLabel.reinit = function("FORMS_VLABEL_reinit")

    function! FORMS_VLABEL_requestedSize() dict
      return (self.__status == g:IS_INVISIBLE) ? [0,0] : [1, strchars(self.__text)]
    endfunction
    let g:forms#VLabel.requestedSize = function("FORMS_VLABEL_requestedSize")

    function! FORMS_VLABEL_draw(allocation) dict
" call forms#log("g:forms#VLabel.draw" .  string(a:allocation))
      let self.__allocation = a:allocation
      let a = a:allocation

      if self.__status != g:IS_INVISIBLE
        let line = a.line
        let column = a.column
        let text = self.__text
        let tlen = strchars(text)

        let cnt = 0
        while cnt < tlen
          call forms#SetCharAt(text[cnt], line+cnt, column)

          let cnt += 1
        endwhile
      endif
      if self.__status == g:IS_DISABLED
        call AugmentGlyphHilight(self, "DisableHi", a)
      endif                     
    endfunction
    let g:forms#VLabel.draw = function("FORMS_VLABEL_draw")

  endif

  return g:forms#VLabel
endfunction
" ------------------------------------------------------------ 
" forms#newVLabel: {{{2
"   Create new Vertical Label
"  parameters: 
"   attrs  : attributes for initializing new object
" ------------------------------------------------------------ 
function! forms#newVLabel(attrs)
  return forms#loadVLabelPrototype().clone().init(a:attrs)
endfunction

"---------------------------------------------------------------------------
" Text <- Leaf: {{{2
"---------------------------------------------------------------------------
" Multiple lines of text. The width of a text glyph is the width of
"   its widest text line. Its height is the number of text lines.
"
" attributes
"   textlines  : A List of text items or String with text separated by '\n'
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms#Text")
    unlet g:forms#Text
  endif
endif
function! forms#loadTextPrototype()
  if !exists("g:forms#Text")
    let g:forms#Text = forms#loadLeafPrototype().clone('forms#Text')
    let g:forms#Text.__textlines = []

    function! FORMS_TEXT_init(attrs) dict
      call call(g:forms#Leaf.init, [a:attrs], self)

      let textlines = self.__textlines
      if type(textlines) == g:self#LIST_TYPE
        " do nothing
      elseif type(textlines) == g:self#STRING_TYPE
        unlet self.__textlines
        let self.__textlines = split(textlines, '\n')
      else
        throw "forms#loadTextPrototype.init: textlines parameter must be List of text: " . string(textlines)
      endif

      return self
    endfunction
    let g:forms#Text.init = function("FORMS_TEXT_init")

    function! FORMS_TEXT_reinit(attrs) dict
" call forms#log("forms#Text.reinit TOP")
      let oldTextlines = self.__textlines

      let self.__textlines = []

      call call(g:forms#Leaf.reinit, [a:attrs], self)

      if oldTextlines != self.__textlines
        call forms#PrependUniqueInput({'type': 'ReSize'})
      else
        call forms#ViewerRedrawListAdd(self) 
      endif
    endfunction
    let g:forms#Text.reinit = function("FORMS_TEXT_reinit")


    function! FORMS_TEXT_requestedSize() dict
      if (self.__status == g:IS_INVISIBLE) 
         return [0,0]
      else
        let w = 0
        for l in self.__textlines
          let llen = strchars(l)
          if w < llen | let w = llen | endif
        endfor
" call forms#log("Text.requestedSize: " . string([w,len(self.__textlines)]))
        return [w,len(self.__textlines)]
      endif
    endfunction
    let g:forms#Text.requestedSize = function("FORMS_TEXT_requestedSize")

    function! FORMS_TEXT_draw(allocation) dict
" call forms#log("g:forms#Text.draw" .  string(a:allocation))
      let self.__allocation = a:allocation
      let a = a:allocation

      if self.__status != g:IS_INVISIBLE
        let line = a.line
        let column = a.column

        let textlines = self.__textlines
        let noslines = len(textlines)

        let cnt = 0
        while cnt < noslines
          let txt = textlines[cnt]
          call forms#SetStringAt(txt, line+cnt, column)

          let cnt += 1
        endwhile
      endif
      if self.__status == g:IS_DISABLED
        call AugmentGlyphHilight(self, "DisableHi", a)
      endif                     

    endfunction
    let g:forms#Text.draw = function("FORMS_TEXT_draw")
  endif

  return g:forms#Text
endfunction
" ------------------------------------------------------------ 
" forms#newText: {{{2
"   Create new Text glyph
"  parameters: 
"   attrs  : attributes for initializing new object
" ------------------------------------------------------------ 
function! forms#newText(attrs)
  return forms#loadTextPrototype().clone().init(a:attrs)
endfunction


"---------------------------------------------------------------------------
" CheckBox <- Leaf: {{{2
"---------------------------------------------------------------------------
" Simple checkbox used to indicate selection or not.
"
" attributes
"   char     : character used to indicated checkbox is selected
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms#CheckBox")
    unlet g:forms#CheckBox
  endif
endif
function! forms#loadCheckBoxPrototype()
  if !exists("g:forms#CheckBox")
    let g:forms#CheckBox = forms#loadLeafPrototype().clone('forms#CheckBox')
    let g:forms#CheckBox.__selected = 0
    let g:forms#CheckBox.__char = 'X'


    function! FORMS_CHECKBOX_init(attrs) dict
" call forms#log("forms#CheckBox.init TOP")
      call call(g:forms#Leaf.init, [a:attrs], self)
" call forms#log("forms#CheckBox.init BOTTOM")
      return self
    endfunction
    let g:forms#CheckBox.init = function("FORMS_CHECKBOX_init")

    function! FORMS_CHECKBOX_reinit(attrs) dict
" call forms#log("forms#CheckBox.reinit TOP")
      let self.__selected = 0
      let self.__char = 'X'

      call call(g:forms#Leaf.reinit, [a:attrs], self)

      call forms#ViewerRedrawListAdd(self) 
    endfunction
    let g:forms#CheckBox.reinit = function("FORMS_CHECKBOX_reinit")

    function! FORMS_CHECKBOX_canFocus() dict
      return (self.__status == g:IS_ENABLED)
    endfunction
    let g:forms#CheckBox.canFocus = function("FORMS_CHECKBOX_canFocus")

    function! FORMS_CHECKBOX_hotspot() dict
      if (self.__status == g:IS_ENABLED)
        call HotSpot(self.__allocation.line, self.__allocation.column+1)
      endif
    endfunction
    let g:forms#CheckBox.hotspot = function("FORMS_CHECKBOX_hotspot")

    function! FORMS_CHECKBOX_addResults(results) dict
      let tag = self.getTag()
      let a:results[tag] = self.__selected
    endfunction
    let g:forms#CheckBox.addResults = function("FORMS_CHECKBOX_addResults")

    function! FORMS_CHECKBOX_requestedSize() dict
      return (self.__status == g:IS_INVISIBLE) ? [0,0] : [3,1]
    endfunction
    let g:forms#CheckBox.requestedSize = function("FORMS_CHECKBOX_requestedSize")

    function! FORMS_CHECKBOX_handleEvent(event) dict
      if (self.__status == g:IS_ENABLED)
        let type = a:event.type
        if type == 'Select'
          let self.__selected = self.__selected ? 0 : 1
          call forms#ViewerRedrawListAdd(self) 
          return 1
        endif
      endif
      return 0
    endfunction
    let g:forms#CheckBox.handleEvent = function("FORMS_CHECKBOX_handleEvent")

    function! FORMS_CHECKBOX_handleChar(nr) dict
" call forms#log("g:forms#CheckBox.handleChar" .  string(a:nr))
      if (self.__status == g:IS_ENABLED)
        let c = nr2char(a:nr)
        if c == "\<CR>" || c == "\<Space>"
          let self.__selected = self.__selected ? 0 : 1
          call forms#ViewerRedrawListAdd(self) 
          return 1
        endif
      endif
      return 0
    endfunction
    let g:forms#CheckBox.handleChar = function("FORMS_CHECKBOX_handleChar")

    function! FORMS_CHECKBOX_draw(allocation) dict
"call forms#log("g:forms#CheckBox.draw" .  string(a:allocation))
      let self.__allocation = a:allocation
      let a = a:allocation

      if self.__status != g:IS_INVISIBLE
        let line = a.line
        let column = a.column

        let str = self.__selected ?  "[" . self.__char . "]" : "[ ]"
        call forms#SetStringAt(str, line, column)
      endif
      if self.__status == g:IS_DISABLED
        call AugmentGlyphHilight(self, "DisableHi", a)
      endif                     

    endfunction
    let g:forms#CheckBox.draw = function("FORMS_CHECKBOX_draw")

    function! FORMS_CHECKBOX_usage() dict
      return [
           \ "A CheckBox has two states: selected or not selected.",
           \ "Selection is with keyboard <CR> or <Space>,",
           \ "  or with a mouse <LeftMouse> click."
           \ ]
    endfunction
    let g:forms#CheckBox.usage = function("FORMS_CHECKBOX_usage")

  endif

  return g:forms#CheckBox
endfunction
" ------------------------------------------------------------ 
" forms#newCheckBox: {{{2
"   Create new CheckBox glyph
"  parameters: 
"   attrs  : attributes for initializing new object
" ------------------------------------------------------------ 
function! forms#newCheckBox(attrs)
  return forms#loadCheckBoxPrototype().clone().init(a:attrs)
endfunction

"---------------------------------------------------------------------------
" ButtonGroup <- Object: {{{2
"---------------------------------------------------------------------------
" Associates radiobutton or togglebuttons into a group and used to
"     enforce a single selected-at-a-time rule.
" attributes
"   member_kind  : 'forms#ToggleButton' or 'forms#RadioButton'
"   members      : all buttons controlled by the group
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms#ButtonGroup")
    unlet g:forms#ButtonGroup
  endif
endif
function! forms#loadButtonGroupPrototype()

  if !exists("g:forms#ButtonGroup")
" call forms#log("ButtonGroup. load BEFORE clone ")
    let g:forms#ButtonGroup = self#LoadObjectPrototype().clone('forms#ButtonGroup')
" call forms#log("ButtonGroup. load AFTER clone ")
    let g:forms#ButtonGroup.__member_kind = ''
    let g:forms#ButtonGroup.__members = []

    function! FORMS_BUTTON_GROUP_delete(...) dict
"call forms#log("ButtonGroup.delete: TOP")
      call ButtonGroupDeleteHi(self)
      unlet self.__members

      let p = g:forms#ButtonGroup._prototype
      call call(p.delete, [p], self)
"call forms#log("ButtonGroup.delete: BOTTOM")
    endfunction
    let g:forms#ButtonGroup.delete = function("FORMS_BUTTON_GROUP_delete")

" call forms#log("ButtonGroup: delete=" .  GetFunDef('g:forms#ButtonGroup.delete'))


    function! FORMS_BUTTON_GROUP_addMember(button) dict
"call forms#log("g:forms#ButtonGroup.addMember: TOP")
      if type(a:button) != g:self#DICTIONARY_TYPE
        throw "ButtonGroup.addMember: Bad type, not Dictionary: " + string(a:button)
      endif
      if ! has_key(a:button, '_kind')
        throw "ButtonGroup.addMember: Not a Glyph, no _kind attribute: " + string(a:button)
      endif
"call forms#log("g:forms#ButtonGroup.addMember: member_kind=" .  "self.__member_kind)
      if a:button._kind != self.__member_kind
        throw "ButtonGroup.addMember: Not type" . self.__member_kind . " type: " + a:button._kind
      endif

      call add(self.__members, a:button)
"call forms#log("g:forms#ButtonGroup.addMember: BOTTOM")
    endfunction
    let g:forms#ButtonGroup.addMember = function("FORMS_BUTTON_GROUP_addMember")

    function! FORMS_BUTTON_GROUP_setValues(button) dict
      let id = a:button._id
"call forms#log("g:forms#ButtonGroup.setValues: id=" .  id)
      let nos_members = len(self.__members)
      if nos_members == 1
        let member = self.__members[0]
        if member.getValue()
          call member.setValue(0)
          call ButtonGroupDeleteHi(self)
        else
          call member.setValue(1)
          call member.selected()
        endif
      elseif nos_members > 1
        for member in self.__members
          if member._id == id
            call member.setValue(1)
            call member.selected()
          else
            call member.setValue(0)
          endif
        endfor
      endif
    endfunction
    let g:forms#ButtonGroup.setValues = function("FORMS_BUTTON_GROUP_setValues")

  endif

  return g:forms#ButtonGroup
endfunction
" ------------------------------------------------------------ 
" forms#newButtonGroup: {{{2
"   Create new ButtonGroup 
"  parameters: 
"   attrs  : attributes for initializing new object
" ------------------------------------------------------------ 
function! forms#newButtonGroup(attrs)
  let p = forms#loadButtonGroupPrototype()
  let x = p.clone().init(a:attrs)
  return x
endfunction


"---------------------------------------------------------------------------
" RadioButton <- Leaf: {{{2
"---------------------------------------------------------------------------
" Simple radiobutton used to indicate selection or not.
"
" attributes
"   char     : character used to indicated radiobutton is selected
"              default: '*'
"   on_selection_action   : Action called when selected
"                           default: noop action
"   on_deselection_action : Action called when deselected
"                           default: noop action
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms#RadioButton")
    unlet g:forms#RadioButton
  endif
endif
function! forms#loadRadioButtonPrototype()
  if !exists("g:forms#RadioButton")
    let g:forms#RadioButton = forms#loadLeafPrototype().clone('forms#RadioButton')
    let g:forms#RadioButton.__selected = 0
    let g:forms#RadioButton.__char = '*'
    let g:forms#RadioButton.__on_selection_action = g:forms_Util.emptyAction()
    let g:forms#RadioButton.__on_deselection_action = g:forms_Util.emptyAction()


    function! FORMS_RADIO_BUTTON_init(attrs) dict
" call forms#log("forms#RadioButton.init TOP")
      call call(g:forms#Leaf.init, [a:attrs], self)
" call forms#log("forms#RadioButton.init BOTTOM")
      if has_key(a:attrs, 'group')
        let self['__group'] = a:attrs['group']
        call self.__group.addMember(self)
      endif
      if self.__char == ''
        let self.__char = '*'
      endif
      return self
    endfunction
    let g:forms#RadioButton.init = function("FORMS_RADIO_BUTTON_init")

    function! FORMS_RADIO_BUTTON_reinit(attrs) dict
"call forms#log("forms#RadioButton.reinit TOP")
      let self.__selected = 0
      let self.__char = '*'
      let self.__on_selection_action = g:forms_Util.emptyAction()
      let self.__on_deselection_action = g:forms_Util.emptyAction()

      call call(g:forms#Leaf.reinit, [a:attrs], self)

      call forms#ViewerRedrawListAdd(self) 
    endfunction
    let g:forms#RadioButton.reinit = function("FORMS_RADIO_BUTTON_reinit")


    function! FORMS_RADIO_BUTTON_canFocus() dict
      return (self.__status == g:IS_ENABLED)
    endfunction
    let g:forms#RadioButton.canFocus = function("FORMS_RADIO_BUTTON_canFocus")

    function! FORMS_RADIO_BUTTON_hotspot() dict
      if (self.__status == g:IS_ENABLED)
        call HotSpot(self.__allocation.line, self.__allocation.column+1)
      endif
    endfunction
    let g:forms#RadioButton.hotspot = function("FORMS_RADIO_BUTTON_hotspot")

    function! FORMS_RADIO_BUTTON_addResults(results) dict
      let tag = self.getTag()
      let a:results[tag] = self.__selected
    endfunction
    let g:forms#RadioButton.addResults = function("FORMS_RADIO_BUTTON_addResults")

    function! FORMS_RADIO_BUTTON_requestedSize() dict
      return (self.__status == g:IS_INVISIBLE) ? [0,0] : [3,1]
    endfunction
    let g:forms#RadioButton.requestedSize = function("FORMS_RADIO_BUTTON_requestedSize")

    function! FORMS_RADIO_BUTTON_handleEvent(event) dict
      if (self.__status == g:IS_ENABLED)
        let type = a:event.type
        if type == 'Select'
          if has_key(self, '__group')
            call self.__group.setValues(self)
          else
            if self.__selected
              call self.setValue(0)
            else
              call self.setValue(1)
            endif
          endif
          return 1
        endif
      endif
      return 0
    endfunction
    let g:forms#RadioButton.handleEvent = function("FORMS_RADIO_BUTTON_handleEvent")

    function! FORMS_RADIO_BUTTON_handleChar(nr) dict
" call forms#log("g:forms#RadioButton.handleChar: " .  string(a:nr))
      if (self.__status == g:IS_ENABLED)
        let c = nr2char(a:nr)
        if c == "\<CR>" || c == "\<Space>"
          if has_key(self, '__group')
            call self.__group.setValues(self)
          else
            if self.__selected
              call self.setValue(0)
            else
              call self.setValue(1)
            endif
          endif
          return 1
        endif
      endif
      return 0
    endfunction
    let g:forms#RadioButton.handleChar = function("FORMS_RADIO_BUTTON_handleChar")

    function! FORMS_RADIO_BUTTON_setValue(value) dict
      let oldvalue = self.__selected
      let self.__selected = a:value
      if oldvalue != a:value
        if a:value
          call self.__on_selection_action.execute()
        else
          call self.__on_deselection_action.execute()
        endif
        call forms#ViewerRedrawListAdd(self) 
      endif
    endfunction
    let g:forms#RadioButton.setValue = function("FORMS_RADIO_BUTTON_setValue")

    function! FORMS_RADIO_BUTTON_getValue() dict
      return self.__selected
    endfunction
    let g:forms#RadioButton.getValue = function("FORMS_RADIO_BUTTON_getValue")

    function! FORMS_RADIO_BUTTON_selected() dict
    endfunction
    let g:forms#RadioButton.selected = function("FORMS_RADIO_BUTTON_selected")

    function! FORMS_RADIO_BUTTON_draw(allocation) dict
" call forms#log("g:forms#RadioButton.draw" .  string(a:allocation))
      let self.__allocation = a:allocation
      let a = a:allocation

      if self.__status != g:IS_INVISIBLE
        let line = a.line
        let column = a.column

        let str = self.__selected ?  "(" . self.__char . ")" : "( )"
        call forms#SetStringAt(str, line, column)
      endif
      if self.__status == g:IS_DISABLED
        call AugmentGlyphHilight(self, "DisableHi", a)
      endif                     

    endfunction
    let g:forms#RadioButton.draw = function("FORMS_RADIO_BUTTON_draw")

    function! FORMS_RADIO_BUTTON_usage() dict
      return [
           \ "A RadioButton has two states: selected or not selected.",
           \ "  Generally, multiple Radiobuttons are grouped together.",
           \ "  Only one Radiobutton in a group can be selected at a time.",
           \ "Selection is with keyboard <CR> or <Space>,",
           \ "  or with a mouse <LeftMouse> click."
           \ ]
    endfunction
    let g:forms#RadioButton.usage = function("FORMS_RADIO_BUTTON_usage")

  endif

  return g:forms#RadioButton
endfunction
" ------------------------------------------------------------ 
" forms#newRadioButton: {{{2
"   Create new RadioButton 
"  parameters: 
"   attrs  : attributes for initializing new object
" ------------------------------------------------------------ 
function! forms#newRadioButton(attrs)
  return forms#loadRadioButtonPrototype().clone().init(a:attrs)
endfunction

"---------------------------------------------------------------------------
" FixedLengthField <- Leaf: {{{2
"---------------------------------------------------------------------------
" Simple single field editor of fixed length
"
" attributes
"   size      : size of editor field
"   init_text : optional text to be displayed in field prior to first edit
"   on_selection_action : optional action when <CR> pressed
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms#FixedLengthField")
    unlet g:forms#FixedLengthField
  endif
endif
function! forms#loadFixedLengthFieldPrototype()
  if !exists("g:forms#FixedLengthField")
    let g:forms#FixedLengthField = forms#loadLeafPrototype().clone('forms#FixedLengthField')
    let g:forms#FixedLengthField.__size = 0
    let g:forms#FixedLengthField.__init_text = ''
    let g:forms#FixedLengthField.__clearInitText = g:self#IS_FALSE
    let g:forms#FixedLengthField.__pos = 0
    let g:forms#FixedLengthField.__text = ''
    let g:forms#FixedLengthField.__on_selection_action = g:forms_Util.emptyAction()


    function! FORMS_FIXED_LENGTH_FIELD_init(attrs) dict
" call forms#log("forms#FixedLengthField.init TOP self.__size=" .  self.__size)
      call call(g:forms#Leaf.init, [a:attrs], self)
" call forms#log("forms#FixedLengthField.init BOTTOM self.__size=" .  self.__size)
      if self.__size < len(self.__init_text)
        throw "FixedLengthField: initial text length:" . self.__init_text . " greater than size: " . self.__size
      endif
      call self.reset()

      return self
    endfunction
    let g:forms#FixedLengthField.init = function("FORMS_FIXED_LENGTH_FIELD_init")

    function! FORMS_FIXED_LENGTH_FIELD_reinit(attrs) dict
" call forms#log("forms#FixedLengthField.reinit TOP")
      let oldSize = self.__size

      let self.__size = 0
      let self.__init_text = ''
      let self.__clearInitText = g:self#IS_FALSE
      let self.__pos = 0
      let self.__text = ''
      let self.__on_selection_action = g:forms_Util.emptyAction()

      call call(g:forms#Leaf.reinit, [a:attrs], self)

      if oldSize != self.__size
        call forms#PrependUniqueInput({'type': 'ReSize'})
      else
        call forms#ViewerRedrawListAdd(self) 
      endif
    endfunction
    let g:forms#FixedLengthField.reinit = function("FORMS_FIXED_LENGTH_FIELD_reinit")

    function! FORMS_FIXED_LENGTH_FIELD_getText() dict
      return self.__text
    endfunction
    let g:forms#FixedLengthField.getText = function("FORMS_FIXED_LENGTH_FIELD_getText")

    function! FORMS_FIXED_LENGTH_FIELD_setText(text) dict
" call forms#log("forms#FixedLengthField.setText TOP")
      let slen = len(a:text)
      if self.__size < slen
        throw "FixedLengthField: setText text length:" . a:text . " greater than size: " . self.__size
      endif

      if self.__text != a:text
        let self.__pos = slen
        let self.__text = a:text
        if ! empty(self.__allocation)
          call forms#ViewerRedrawListAdd(self) 
        endif
      endif
    endfunction
    let g:forms#FixedLengthField.setText = function("FORMS_FIXED_LENGTH_FIELD_setText")

    function! FORMS_FIXED_LENGTH_FIELD_canFocus() dict
      return (self.__status == g:IS_ENABLED)
    endfunction
    let g:forms#FixedLengthField.canFocus = function("FORMS_FIXED_LENGTH_FIELD_canFocus")

    function! FORMS_FIXED_LENGTH_FIELD_hotspot() dict
      if (self.__status == g:IS_ENABLED)
        let a = self.__allocation
        if self.__pos == 0
          call HotSpot(a.line, a.column)
        else
          call HotSpot(a.line, a.column + self.__pos - 1)
        endif
      endif
    endfunction
    let g:forms#FixedLengthField.hotspot = function("FORMS_FIXED_LENGTH_FIELD_hotspot")

    function! FORMS_FIXED_LENGTH_FIELD_addResults(results) dict
      let tag = self.getTag()
      let txt = self.__text

      let a:results[tag] = substitute(txt, '[[:space:][:cntrl:]]\+$', '', '')
    endfunction
    let g:forms#FixedLengthField.addResults = function("FORMS_FIXED_LENGTH_FIELD_addResults")

    function! FORMS_FIXED_LENGTH_FIELD_requestedSize() dict
      return (self.__status == g:IS_INVISIBLE) ? [0,0] : [self.__size,1]
    endfunction
    let g:forms#FixedLengthField.requestedSize = function("FORMS_FIXED_LENGTH_FIELD_requestedSize")

    function! FORMS_FIXED_LENGTH_FIELD_handleEvent(event) dict
      if (self.__status == g:IS_ENABLED)
        let type = a:event.type
        if type == 'Select'
          " TODO after Left and Right set position
          call forms#ViewerRedrawListAdd(self) 
          return 1
        elseif type == 'SelectDobule'
          call self.__on_selection_action.execute(self.__text)
          return 1
        endif
      endif
      return 0
    endfunction
    let g:forms#FixedLengthField.handleEvent = function("FORMS_FIXED_LENGTH_FIELD_handleEvent")

    function! FORMS_FIXED_LENGTH_FIELD_handleChar(nr) dict
      let handled = 0
      if (self.__status == g:IS_ENABLED)
        if self.__clearInitText
          call self.__reset('')
          let self.__clearInitText = g:self#IS_FALSE
        endif

        let c = nr2char(a:nr)
if 0
        if a:nr >= 32 && a:nr < 127
          let txt = join(self.__txtbuf, '')
          if self.__pos < strchars(txt)
            let self.__txtbuf[self.__pos] = c
            let self.__pos = self.__pos + 1
            call forms#ViewerRedrawListAdd(self) 
          else
            call self.flash()
          endif
          return 1

          " TODO Left and Right
        elseif a:nr == "\<Del>" || a:nr == "\<BS>"
          if self.__pos > 0
            let self.__pos = self.__pos - 1
            let self.__txtbuf[self.__pos] = ' '
            call forms#ViewerRedrawListAdd(self) 
          else
            call self.flash()
          endif
          return 1
        endif
endif

        let c = nr2char(a:nr)
        if a:nr >= 32 && a:nr < 127
          let slen = strchars(self.__text)
          let size = self.__size

          if slen == size
            call self.flash()
          else
            if self.__pos == 0
              let self.__text = c . self.__text
            elseif self.__pos == 1
              let self.__text = self.__text . c
            elseif self.__pos == slen
              let self.__text .= c
            else " pos < slen && pos > 0
              let diff = slen - self.__pos
              let front = strpart(self.__text, 0, self.__pos)
              let back = strpart(self.__text, self.__pos, diff)
              let self.__text = front . c . back
            endif

            let self.__pos += 1
            call forms#ViewerRedrawListAdd(self) 
          endif
          let handled = 1

        elseif c == "\<CR>" 
" call forms#log("g:forms#VariableLengthField.handleChar CR=")
          call self.__on_selection_action.execute(self.__text)
          let handled = 1

        elseif a:nr == "\<Del>" || a:nr == "\<BS>"
          let slen = strchars(self.__text)

          if self.__pos == 0
            if slen == 0
              call self.flash()
            else
              let self.__text = strpart(self.__text, 1, slen - 1)
            endif

          elseif self.__pos == slen
            let self.__text = strpart(self.__text, 0, slen - 1)
            let self.__pos -= 1

          elseif self.__pos == 1
            let self.__text = strpart(self.__text, 1, slen - 1)
            let self.__pos -= 1

          else " pos < slen && pos > 1
            let diff = slen - self.__pos

            let front = strpart(self.__text, 0, self.__pos - 1)
            let back = strpart(self.__text, self.__pos, diff)
            let self.__text = front . back

            let self.__pos -= 1
          endif
          let handled = 1
          call forms#ViewerRedrawListAdd(self) 

        elseif a:nr == "\<Right>" || 
                \ a:nr == "\<ScrollWheelRight>" ||
                \ a:nr == "\<Up>" ||
                \ a:nr == "\<ScrollWheelUp>"
          let slen = strchars(self.__text)

          if self.__pos == slen
            call self.flash()
          else
            let self.__pos += 1
          endif
" call forms#log("g:forms#VariableLengthField.handleChar RIGHT pos=" .  self.__pos)
          let handled = 1
          call forms#ViewerRedrawListAdd(self) 

        elseif a:nr == "\<Left>" || 
                \ a:nr == "\<ScrollWheelLeft>" ||
                \ a:nr == "\<Down>" ||
                \ a:nr == "\<ScrollWheelDown>"
          if self.__pos == 0
            call self.flash()
          else
            let self.__pos -= 1
          endif
" call forms#log("g:forms#VariableLengthField.handleChar LEFT pos=" .  self.__pos)

          let handled = 1
          call forms#ViewerRedrawListAdd(self) 

        endif
      endif
      return handled
    endfunction
    let g:forms#FixedLengthField.handleChar = function("FORMS_FIXED_LENGTH_FIELD_handleChar")

    function! FORMS_FIXED_LENGTH_FIELD_flash() dict
      if (self.__status == g:IS_ENABLED)
        let a = self.__allocation
        call Flash(a.line, a.column, a.column + self.__size - 1)
      endif
    endfunction
    let g:forms#FixedLengthField.flash = function("FORMS_FIXED_LENGTH_FIELD_flash")

    function! FORMS_FIXED_LENGTH_FIELD_draw(allocation) dict
" call forms#log("g:forms#FixedLengthField.draw" .  string(a:allocation))
      let self.__allocation = a:allocation
      let a = a:allocation

      if self.__status != g:IS_INVISIBLE
        let line = a:allocation.line
        let column = a:allocation.column
        let size = self.__size

        let text = self.__text
        let slen = len(text)
        call forms#SetStringAt(text, line, column)
        if slen < size
          call forms#SetHCharsAt(' ', (size-slen), line, column+slen)
        endif
      endif
      if self.__status == g:IS_DISABLED
        call AugmentGlyphHilight(self, "DisableHi", a)
      endif                     
    endfunction
    let g:forms#FixedLengthField.draw = function("FORMS_FIXED_LENGTH_FIELD_draw")

    function! FORMS_FIXED_LENGTH_FIELD_reset() dict
      call self.__reset(self.__init_text)
    endfunction
    let g:forms#FixedLengthField.reset = function("FORMS_FIXED_LENGTH_FIELD_reset")

    function! FORMS_FIXED_LENGTH_FIELD___reset(initTxt) dict
      let self.__pos = 0

      if a:initTxt != ''
        let self.__clearInitText = g:self#IS_TRUE
        let self.__text = a:initTxt
      else
        let self.__text = ''
      endif

    endfunction
    let g:forms#FixedLengthField.__reset = function("FORMS_FIXED_LENGTH_FIELD___reset")

    function! FORMS_FIXED_LENGTH_FIELD_usage() dict
      return [
           \ "A FixedLengthField is a line editor with a fixed",
           \ "  number of characters which is also the width",
           \ "  of its display.",
           \ "  Keyboard characters are entered at the hotspot.",
           \ "  Backspace and delete (<BS> and <Del>) erase the.",
           \ "    character at the hotspot.",
           \ "Navigation across entered text can be done with",
           \ "  keyboard <Left> and <Right> buttons and mouse",
           \ "  <ScrollWheelLeft> and <ScrollWheelRight>",
           \ "Selection is with keyboard <CR> or <Space>,",
           \ "  or with a mouse <LeftMouse> click."
           \ ]
    endfunction
    let g:forms#FixedLengthField.usage = function("FORMS_FIXED_LENGTH_FIELD_usage")
  endif

  return g:forms#FixedLengthField
endfunction
" ------------------------------------------------------------ 
" forms#newFixedLengthField: {{{2
"   Create new FixedLengthField 
"  parameters: 
"   attrs  : attributes for initializing new object
" ------------------------------------------------------------ 
function! forms#newFixedLengthField(attrs)
  return forms#loadFixedLengthFieldPrototype().clone().init(a:attrs)
endfunction


"---------------------------------------------------------------------------
" VariableLenghtField <- Leaf: {{{2
"---------------------------------------------------------------------------
" Simple single field editor of variable length
"
" attributes
"   size      : display size of editor field
"   init_text : optional text to be displayed in field prior to first edit
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms#VariableLengthField")
    unlet g:forms#VariableLengthField
  endif
endif
function! forms#loadVariableLengthFieldPrototype()
  if !exists("g:forms#VariableLengthField")
    let g:forms#VariableLengthField = forms#loadLeafPrototype().clone('forms#VariableLengthField')
    let g:forms#VariableLengthField.__size = 0
    let g:forms#VariableLengthField.__init_text = ''
    let g:forms#VariableLengthField.__clearInitText = g:self#IS_FALSE
    let g:forms#VariableLengthField.__pos = 0
    let g:forms#VariableLengthField.__win_start = 0
    let g:forms#VariableLengthField.__text = ''
    let g:forms#VariableLengthField.__on_selection_action = g:forms_Util.emptyAction()


    function! FORMS_VARIABLE_LENGTH_FIELD_init(attrs) dict
" call forms#log("forms#VariableLengthField.init TOP self.__size=" .  self.__size)
      call call(g:forms#Leaf.init, [a:attrs], self)

      if self.__size < strchars(self.__init_text)
        throw "VariableLenghtField: Initial text length:" . self.__init_text . " greater than size: " . self.__size
      endif
      call self.reset()

      return self
    endfunction
    let g:forms#VariableLengthField.init = function("FORMS_VARIABLE_LENGTH_FIELD_init")

    function! FORMS_VARIABLE_LENGTH_FIELD_reinit(attrs) dict
" call forms#log("forms#VariableLengthField.reinit TOP")
      let oldSize = self.__size

      let self.__size = 0
      let self.__init_text = ''
      let self.__clearInitText = g:self#IS_FALSE
      let self.__pos = 0
      let self.__win_start = 0
      let self.__text = ''
      let self.__on_selection_action = g:forms_Util.emptyAction()

      call call(g:forms#Leaf.reinit, [a:attrs], self)

      if oldSize != self.__size
        call forms#PrependUniqueInput({'type': 'ReSize'})
      else
        call forms#ViewerRedrawListAdd(self) 
      endif
    endfunction
    let g:forms#VariableLengthField.reinit = function("FORMS_VARIABLE_LENGTH_FIELD_reinit")

    function! FORMS_VARIABLE_LENGTH_FIELD_setText(text) dict
" call forms#log("forms#VariableLengthField.setText TOP")
      if self.__text != a:text
        let self.__pos = len(a:text)
        let self.__win_start = 0
        let self.__text = a:text
        if ! empty(self.__allocation)
          call forms#ViewerRedrawListAdd(self) 
        endif
      endif
    endfunction
    let g:forms#VariableLengthField.setText = function("FORMS_VARIABLE_LENGTH_FIELD_setText")

    function! FORMS_VARIABLE_LENGTH_FIELD_canFocus() dict
      return (self.__status == g:IS_ENABLED)
    endfunction
    let g:forms#VariableLengthField.canFocus = function("FORMS_VARIABLE_LENGTH_FIELD_canFocus")

    function! FORMS_VARIABLE_LENGTH_FIELD_hotspot() dict
      if (self.__status == g:IS_ENABLED)
        let pos = self.__pos
        let size = self.__size
        let a = self.__allocation
        
        if pos == 0
          call HotSpot(a.line, a.column)
        elseif pos <= size
          call HotSpot(a.line, a.column + pos - 1)
        else
          call HotSpot(a.line, a.column + size - 1)
        endif
      endif
    endfunction
    let g:forms#VariableLengthField.hotspot = function("FORMS_VARIABLE_LENGTH_FIELD_hotspot")

    function! FORMS_VARIABLE_LENGTH_FIELD_flash() dict
      if (self.__status == g:IS_ENABLED)
        let a = self.__allocation
        call Flash(a.line, a.column, a.column + self.__size - 1)
      endif
    endfunction
    let g:forms#VariableLengthField.flash = function("FORMS_VARIABLE_LENGTH_FIELD_flash")

    function! FORMS_VARIABLE_LENGTH_FIELD_addResults(results) dict
      let tag = self.getTag()
      let txt = self.__text

      let a:results[tag] = substitute(txt, '[[:space:][:cntrl:]]\+$', '', '')
    endfunction
    let g:forms#VariableLengthField.addResults = function("FORMS_VARIABLE_LENGTH_FIELD_addResults")

    function! FORMS_VARIABLE_LENGTH_FIELD_requestedSize() dict
      return (self.__status == g:IS_INVISIBLE) ? [0,0] : [self.__size,1]
    endfunction
    let g:forms#VariableLengthField.requestedSize = function("FORMS_VARIABLE_LENGTH_FIELD_requestedSize")

    function! FORMS_VARIABLE_LENGTH_FIELD_handleEvent(event) dict
" call forms#log("g:forms#VariableLengthField.handleEvent event="+string(a:event))
      if (self.__status == g:IS_ENABLED)
        let type = a:event.type
        if type == 'Select'
          let a = self.__allocation
          let column = a:event.column
          let diff = column - a.column
          let pos = self.__win_start + diff
          let slen = strchars(self.__text)

          let self.__pos = (pos > slen) ? slen : pos
          call forms#ViewerRedrawListAdd(self) 

          return 1

        elseif type == 'SelectDobule'
          call self.__on_selection_action.execute(self.__text)
          return 1
        endif
      endif
      return 0
    endfunction
    let g:forms#VariableLengthField.handleEvent = function("FORMS_VARIABLE_LENGTH_FIELD_handleEvent")

    function! FORMS_VARIABLE_LENGTH_FIELD_handleChar(nr) dict
" call forms#log("g:forms#VariableLengthField.handleChar TOP")
      let handled = 0
      if (self.__status == g:IS_ENABLED)
        if self.__clearInitText
          call self.__reset('')
          let self.__clearInitText = g:self#IS_FALSE
        endif
  " call forms#log("g:forms#VariableLengthField.handleChar text=" .  self.__text)

        let c = nr2char(a:nr)
        if a:nr >= 32 && a:nr < 127
          let slen = strchars(self.__text)

          if self.__pos == 0
            let self.__text = c . self.__text
          elseif self.__pos == 1
            let self.__text = self.__text . c
          elseif self.__pos == slen
            let self.__text .= c
          else " pos < slen && pos > 0
            let diff = slen - self.__pos
            let front = strpart(self.__text, 0, self.__pos)
            let back = strpart(self.__text, self.__pos, diff)
            let self.__text = front . c . back
          endif

          let self.__pos += 1
          let handled = 1
          call forms#ViewerRedrawListAdd(self) 

        elseif c == "\<CR>" 
          call self.__on_selection_action.execute(self.__text)

        elseif a:nr == "\<Del>" || a:nr == "\<BS>"
          let slen = strchars(self.__text)

          if self.__pos == 0
            if slen == 0
              call self.flash()
            else
              let self.__text = strpart(self.__text, 1, slen - 1)
            endif

          elseif self.__pos == slen
            let self.__text = strpart(self.__text, 0, slen - 1)
            let self.__pos -= 1

          elseif self.__pos == 1
            let self.__text = strpart(self.__text, 1, slen - 1)
            let self.__pos -= 1

          else " pos < slen && pos > 1
            let diff = slen - self.__pos

            let front = strpart(self.__text, 0, self.__pos - 1)
            let back = strpart(self.__text, self.__pos, diff)
            let self.__text = front . back

            let self.__pos -= 1
          endif
          let handled = 1
          call forms#ViewerRedrawListAdd(self) 

        elseif a:nr == "\<Right>" || 
                \ a:nr == "\<ScrollWheelRight>" ||
                \ a:nr == "\<Up>" ||
                \ a:nr == "\<ScrollWheelUp>"
          let slen = strchars(self.__text)

          if self.__pos == slen
            call self.flash()
          else
            let self.__pos += 1
          endif
  " call forms#log("g:forms#VariableLengthField.handleChar RIGHT pos=" .  self.__pos)
          let handled = 1
          call forms#ViewerRedrawListAdd(self) 

        elseif a:nr == "\<Left>" || 
                \ a:nr == "\<ScrollWheelLeft>" ||
                \ a:nr == "\<Down>" ||
                \ a:nr == "\<ScrollWheelDown>"
          if self.__pos == 0
            call self.flash()
          else
            let self.__pos -= 1
          endif
  " call forms#log("g:forms#VariableLengthField.handleChar LEFT pos=" .  self.__pos)

          let handled = 1
          call forms#ViewerRedrawListAdd(self) 

        endif

        let size = self.__size
        if self.__pos > self.__win_start + size
          let self.__win_start += 1
        elseif self.__win_start > 0 && self.__pos < self.__win_start + size
          let self.__win_start -= 1
        endif

      endif
      return handled

    endfunction
    let g:forms#VariableLengthField.handleChar = function("FORMS_VARIABLE_LENGTH_FIELD_handleChar")

    function! FORMS_VARIABLE_LENGTH_FIELD_draw(allocation) dict
" call forms#log("g:forms#VariableLengthField.draw" .  string(a:allocation))
      let self.__allocation = a:allocation
      let a = a:allocation

      if self.__status != g:IS_INVISIBLE
        let line = a.line
        let column = a.column
        let slen = strchars(self.__text)
        let size = self.__size
        let win_start = self.__win_start
  " call forms#log("g:forms#VariableLengthField.draw slen=" .  slen)
  " call forms#log("g:forms#VariableLengthField.draw win_start=" .  win_start)

        if slen <= size " does not matter what pos is
          let diff =  size - slen

          if slen > 0
            call forms#SetStringAt(self.__text, line, column)
          endif

          if diff > 0
            let blankStr = repeat(' ', diff)
            call forms#SetStringAt(blankStr, line, column+slen)
          endif

        else " want text at pos to be displayed win_start
          let text = strpart(self.__text, win_start, size)
  " call forms#log("g:forms#VariableLengthField.draw text=" .  text)
          " call cursor(line, column)
          " execute ":normal " . size . 's' . text  . ''
          call forms#SetStringAt(text, line, column)
        endif
      endif
      if self.__status == g:IS_DISABLED
        call AugmentGlyphHilight(self, "DisableHi", a)
      endif                     

    endfunction
    let g:forms#VariableLengthField.draw = function("FORMS_VARIABLE_LENGTH_FIELD_draw")

    function! FORMS_VARIABLE_LENGTH_FIELD_reset() dict
      call self.__reset(self.__init_text)
    endfunction
    let g:forms#VariableLengthField.reset = function("FORMS_VARIABLE_LENGTH_FIELD_reset")

    function! FORMS_VARIABLE_LENGTH_FIELD___reset(initTxt) dict
      let self.__text = ''

      if a:initTxt != ''
        let self.__clearInitText = g:self#IS_TRUE
        let self.__text = a:initTxt
      endif
      let slen = strchars(self.__text)
      let self.__pos = slen
      let self.__win_start = slen <= self.__size ? 0 : slen - self.__size

    endfunction
    let g:forms#VariableLengthField.__reset = function("FORMS_VARIABLE_LENGTH_FIELD___reset")

    function! FORMS_VARIABLE_LENGTH_FIELD_usage() dict
      return [
           \ "A VariableLengthField is a line editor a fixed display",
           \ "  size but can hold any number of characters.",
           \ "  The displayed characters will be scrolled as needed.",
           \ "  Keyboard characters are entered at the hotspot.",
           \ "  Backspace and delete (<BS> and <Del>) erase the.",
           \ "    character at the hotspot.",
           \ "Navigation across entered text can be done with",
           \ "  keyboard <Left> and <Right> buttons and mouse",
           \ "  <ScrollWheelLeft> and <ScrollWheelRight>",
           \ "Selection is with keyboard <CR>",
           \ "  or with a mouse <LeftMouse> click."
           \ ]
    endfunction
    let g:forms#VariableLengthField.usage = function("FORMS_VARIABLE_LENGTH_FIELD_usage")
  endif

  return g:forms#VariableLengthField
endfunction
" ------------------------------------------------------------ 
" forms#newVariableLengthField: {{{2
"   Create new VariableLengthField 
"  parameters: 
"   attrs  : attributes for initializing new object
" ------------------------------------------------------------ 
function! forms#newVariableLengthField(attrs)
  return forms#loadVariableLengthFieldPrototype().clone().init(a:attrs)
endfunction


"---------------------------------------------------------------------------
" TextEditor <- Leaf: {{{2
"---------------------------------------------------------------------------
" Simple multi-line text editor glyph. No, it is not the Vim editor.
"
" attributes
"   width     : display width of editor (default 15)
"   height    : display height of editor (default 5)
"   init_text : optional text to be displayed in field prior to first edit
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms#TextEditor")
    unlet g:forms#TextEditor
  endif
endif
function! forms#loadTextEditorPrototype()
  if !exists("g:forms#TextEditor")
    let g:forms#TextEditor = forms#loadLeafPrototype().clone('forms#TextEditor')
    let g:forms#TextEditor.__width = 15
    let g:forms#TextEditor.__height = 5
    let g:forms#TextEditor.__init_text = []
    let g:forms#TextEditor.__clearInitText = g:self#IS_FALSE
    let g:forms#TextEditor.__x_pos = 0
    let g:forms#TextEditor.__y_pos = 0
    let g:forms#TextEditor.__x_win_start = 0
    let g:forms#TextEditor.__y_win_start = 0
    let g:forms#TextEditor.__textlines = []

    function! FORMS_TEXT_EDITOR_init(attrs) dict
" call forms#log("forms#TextEditor.init TOP self.__width=" .  self.__width)
" call forms#log("forms#TextEditor.init TOP self.__height=" .  self.__height)
      call call(g:forms#Leaf.init, [a:attrs], self)

      if self.__width < 1
        throw "TextEditor: Initial text width:" . self.__width . " less than one"
      endif
      if self.__height < 1
        throw "TextEditor: Initial text height:" . self.__height . " less than one"
      endif
      if type(self.__init_text) != g:self#STRING_TYPE &&
        \ type(self.__init_text) != g:self#LIST_TYPE 
        throw "TextEditor: Initial text must be either a string or a list of strings"
      endif

      call self.reset()

      return self
    endfunction
    let g:forms#TextEditor.init = function("FORMS_TEXT_EDITOR_init")

    function! FORMS_TEXT_EDITOR_reinit(attrs) dict
" call forms#log("forms#TextEditor.reinit TOP")
      let oldWidth = self.__width
      let oldHeight = self.__height

      let self.__width = 15
      let self.__height = 5
      let self.__init_text = []
      let self.__clearInitText = g:self#IS_FALSE
      let self.__x_pos = 0
      let self.__y_pos = 0
      let self.__x_win_start = 0
      let self.__y_win_start = 0
      let self.__textlines = []

      call call(g:forms#Leaf.reinit, [a:attrs], self)

      if oldWidth != self.__width
        call forms#PrependUniqueInput({'type': 'ReSize'})
      elseif oldHeight != self.__height
        call forms#PrependUniqueInput({'type': 'ReSize'})
      else
        call forms#ViewerRedrawListAdd(self) 
      endif
    endfunction
    let g:forms#TextEditor.reinit = function("FORMS_TEXT_EDITOR_reinit")

    function! FORMS_TEXT_EDITOR_canFocus() dict
      return (self.__status == g:IS_ENABLED)
    endfunction
    let g:forms#TextEditor.canFocus = function("FORMS_TEXT_EDITOR_canFocus")

    function! FORMS_TEXT_EDITOR_hotspot() dict
      if (self.__status == g:IS_ENABLED)
        let x_pos = self.__x_pos
        let y_pos = self.__y_pos
        let width = self.__width
        " let height = self.__height
        let a = self.__allocation
        let y_win_start = self.__y_win_start
        let x_win_start = self.__x_win_start
        let xdiff = x_pos - x_win_start
        let ydiff = y_pos - y_win_start

        if x_pos == 0
          call HotSpot(a.line+ydiff, a.column)
        elseif xdiff <= width
          call HotSpot(a.line+ydiff, a.column + xdiff - 1)
        else
          call HotSpot(a.line+ydiff, a.column + width - 1)
        endif
      endif
    endfunction
    let g:forms#TextEditor.hotspot = function("FORMS_TEXT_EDITOR_hotspot")

    function! FORMS_TEXT_EDITOR_flash() dict
      if (self.__status == g:IS_ENABLED)
        let a = self.__allocation
        let y_pos = self.__y_pos
        let y_win_start = self.__y_win_start
        let diff = y_pos - y_win_start

        call Flash(a.line+diff, a.column, a.column + self.__width - 1)
      endif
    endfunction
    let g:forms#TextEditor.flash = function("FORMS_TEXT_EDITOR_flash")

    function! FORMS_TEXT_EDITOR_addResults(results) dict
      let tag = self.getTag()

      let a:results[tag] = copy(self.__textlines)
    endfunction
    let g:forms#TextEditor.addResults = function("FORMS_TEXT_EDITOR_addResults")

    function! FORMS_TEXT_EDITOR_requestedSize() dict
      return (self.__status == g:IS_INVISIBLE) ? [0,0] : [self.__width,self.__height]
    endfunction
    let g:forms#TextEditor.requestedSize = function("FORMS_TEXT_EDITOR_requestedSize")

    function! FORMS_TEXT_EDITOR_handleEvent(event) dict
" call forms#log("g:forms#TextEditor.handleEvent event=" . string(a:event))
      if (self.__status == g:IS_ENABLED)
        let type = a:event.type
        if type == 'Select'
          let a = self.__allocation
          let line = a:event.line
          let column = a:event.column
          let xdiff = column - a.column
          let ydiff = line - a.line
" call forms#log("g:forms#TextEditor.handleEvent line=" . line)
" call forms#log("g:forms#TextEditor.handleEvent column=" . column)
" call forms#log("g:TextEditor.handleEvent xdiff=" . xdiff)
" call forms#log("g:TextEditor.handleEvent ydiff=" . ydiff)
          let xpos = self.__x_win_start + xdiff
          let ypos = self.__y_win_start + ydiff
" call forms#log("g:forms#TextEditor.handleEvent xpos=" . xpos)
" call forms#log("g:forms#TextEditor.handleEvent ypos=" . ypos)
" call forms#log("g:forms#TextEditor.handleEvent self.__x_pos=" . self.__x_pos)
" call forms#log("g:forms#TextEditor.handleEvent self.__y_pos=" . self.__y_pos)
          if xpos != self.__x_pos || ypos != self.__y_pos
            let txtlns = self.__textlines
            let llen = len(txtlns)

            let self.__y_pos = (ypos > llen - 1) ? llen - 1 : ypos
            let xlen = strchars(txtlns[self.__y_pos])
            let self.__x_pos = (xpos > xlen) ? xlen : xpos
            call forms#ViewerRedrawListAdd(self) 
          endif

          return 1
        endif
      endif
      return 0
    endfunction
    let g:forms#TextEditor.handleEvent = function("FORMS_TEXT_EDITOR_handleEvent")

    function! FORMS_TEXT_EDITOR_handleChar(nr) dict
" call forms#log("g:forms#TextEditor.handleChar ")
      let handled = 0
      if (self.__status == g:IS_ENABLED)
        if self.__clearInitText
          call self.__reset('')
          let self.__clearInitText = g:self#IS_FALSE
        endif

        let x_pos = self.__x_pos
        let y_pos = self.__y_pos
        let x_win_start = self.__x_win_start
        let y_win_start = self.__y_win_start
        let width = self.__width
        let height = self.__height
        let txtlns = self.__textlines
        let str = txtlns[y_pos]
        let slen = strchars(str)

        let adjust_x_win_start = g:self#IS_TRUE

        let c = nr2char(a:nr)
        if a:nr >= 32 && a:nr < 127
          if x_pos == 0
            let str = c . str 
          elseif x_pos == 1
            let str = str  . c
          elseif x_pos == slen
            let str .= c
          else " x_pos < slen && x_pos > 1
            let diff = slen - x_pos
            let front = forms#SubString(str, 0, x_pos)
            let back = forms#SubString(str, x_pos, diff)
            let str = front . c . back
          endif

          let txtlns[y_pos] = str
          let self.__x_pos += 1
          let handled = 1
          call forms#ViewerRedrawListAdd(self) 

        elseif a:nr == "\<Del>" || a:nr == "\<BS>"
          if x_pos == 0
            if slen == 0
              if y_pos == 0
                let llen = len(txtlns)
                if  llen > 1
                  call remove(txtlns, 0)
                else
                  call self.flash()
                endif
              else
                call remove(txtlns, y_pos)
                let self.__y_pos -= 1

                let str = txtlns[self.__y_pos]
"  call forms#log("g:forms#TextEditor.handleChar  str=" .  str)
                let slen = strchars(str)
                let self.__x_pos = slen

                if slen < width
                  let self.__x_win_start = 0
                else
                  let self.__x_win_start = slen - width
                endif
                let adjust_x_win_start = g:self#IS_FALSE

              endif
            else
              let str = forms#SubString(str, 1, slen - 1)
              let txtlns[y_pos] = str
            endif

          elseif x_pos == slen
            let str = forms#SubString(str, 0, slen - 1)
            let txtlns[y_pos] = str
            let self.__x_pos -= 1

          elseif x_pos == 1
            let str = forms#SubString(str, 1, slen - 1)
            let txtlns[y_pos] = str
            let self.__x_pos -= 1

          else " x_pos < slen && x_pos > 1
            let diff = slen - x_pos

            let front = forms#SubString(str, 0, x_pos - 1)
            let back = forms#SubString(str, x_pos, diff)
            let str = front . back
            let txtlns[y_pos] = str

            let self.__x_pos -= 1
          endif

          let handled = 1
          call forms#ViewerRedrawListAdd(self) 

        elseif c == "\<CR>" 
          if x_pos == 0
            call insert(txtlns, '', y_pos)
          elseif x_pos == slen
            call insert(txtlns, '', y_pos+1)
          else
            let diff = slen - x_pos
            let front = forms#SubString(str, 0, x_pos)
            let back = forms#SubString(str, x_pos, diff)
            let txtlns[y_pos] = front
            call insert(txtlns, back, y_pos+1)
          endif

          let self.__x_pos = 0
          let self.__y_pos += 1
          let self.__x_win_start = 0
          let adjust_x_win_start = g:self#IS_FALSE

          let handled = 1
          call forms#ViewerRedrawListAdd(self) 

        elseif a:nr == "\<Right>" || a:nr == "\<ScrollWheelRight>"
          if x_pos == slen
            call self.flash()
          else
            let self.__x_pos += 1
          endif

          let handled = 1
          call forms#ViewerRedrawListAdd(self) 
        elseif a:nr == "\<Left>" || a:nr == "\<ScrollWheelLeft>"
          if x_pos == 0
            call self.flash()
          else
            let self.__x_pos -= 1
          endif

          let handled = 1
          call forms#ViewerRedrawListAdd(self) 

        elseif a:nr == "\<Up>" || a:nr == "\<ScrollWheelUp>"
          if y_pos == 0
            call self.flash()
          else
            let self.__y_pos -= 1

            let slenU = strchars(txtlns[self.__y_pos])
            if slenU < slen
              if slenU < x_win_start
                if slenU < width 
                  let self.__x_win_start = 0
                else
                  let self.__x_win_start = slenU - width
                endif
                let self.__x_pos = slenU
              elseif x_pos > slenU
                let self.__x_pos = slenU
              endif
            endif 

            let adjust_x_win_start = g:self#IS_FALSE
            call forms#ViewerRedrawListAdd(self) 
          endif

          let handled = 1

        elseif a:nr == "\<Down>" || a:nr == "\<ScrollWheelDown>"
          let llen = len(txtlns)
          if y_pos == llen - 1
            call self.flash()
          else
            let self.__y_pos += 1

            let slenD = strchars(txtlns[self.__y_pos])
            if slenD < slen
              if slenD < x_win_start
"  call forms#log("g:forms#TextEditor.handleChar  YYYYYYYYY")
                if slenD < width 
                  let self.__x_win_start = 0
                else
                  let self.__x_win_start = slenD - width
                endif
                let self.__x_pos = slenD
              elseif x_pos > slenD
                let self.__x_pos = slenD
              endif
            endif 
            let adjust_x_win_start = g:self#IS_FALSE
            call forms#ViewerRedrawListAdd(self) 
          endif

          let handled = 1

        endif

  if adjust_x_win_start
        if self.__x_pos > self.__x_win_start + width
"  call forms#log("g:forms#TextEditor.handleChar  AAAA")
          let self.__x_win_start += 1
        elseif self.__x_win_start > 0 && self.__x_pos < self.__x_win_start + width
"  call forms#log("g:forms#TextEditor.handleChar  BBBB")
          let self.__x_win_start -= 1
        endif
  endif

        if self.__y_pos >= self.__y_win_start + height
          let self.__y_win_start += 1
        elseif self.__y_win_start > 0 && self.__y_pos < self.__y_win_start
          let self.__y_win_start -= 1
        elseif self.__y_win_start > 0 && height > len(txtlns) - self.__y_win_start
          let self.__y_win_start -= 1
        endif
      endif

      return handled
    endfunction
    let g:forms#TextEditor.handleChar = function("FORMS_TEXT_EDITOR_handleChar")

    function! FORMS_TEXT_EDITOR_draw(allocation) dict
"call forms#log("g:forms#TextEditor.draw" .  string(a:allocation))
      let self.__allocation = a:allocation
      let a = a:allocation

      if self.__status != g:IS_INVISIBLE
        let line = a:allocation.line
        let column = a:allocation.column
        let x_pos = self.__x_pos
        let y_pos = self.__y_pos
        let width = self.__width
        let height = self.__height
        let x_win_start = self.__x_win_start
        let y_win_start = self.__y_win_start
        let txtlns = self.__textlines
        let xlen = strchars(txtlns[y_pos])
        let ylen = len(txtlns)

"  call forms#log("g:forms#TextEditor.draw x_pos=" .  x_pos)
"  call forms#log("g:forms#TextEditor.draw y_pos=" .  y_pos)
"  call forms#log("g:forms#TextEditor.draw xlen=" .  xlen)
"  call forms#log("g:forms#TextEditor.draw x_win_start=" .  x_win_start)
"  call forms#log("g:forms#TextEditor.draw y_win_start=" .  y_win_start)

" call forms#log("g:forms#TextEditor.draw 2 NOT IMPL")
        let blankStr = repeat(' ', width)

        if y_win_start+height < ylen
          let yend = height
        else
          let yend = ylen - y_win_start
        endif

        let ycnt = 0
        while ycnt < yend
          let str = txtlns[ycnt+y_win_start]
          let slen = strchars(str)

          if slen < x_win_start
            call forms#SetStringAt(blankStr, line+ycnt, column)
          elseif slen - x_win_start < width
            let substr = forms#SubString(str, x_win_start)
" call forms#log("g:forms#TextEditor.draw substr=" . substr)
            call forms#SetStringAt(substr, line+ycnt, column)

            let bs = repeat(' ', width - slen + x_win_start)
            call forms#SetStringAt(bs, line+ycnt, column+slen-x_win_start)
          else
            let substr = forms#SubString(str, x_win_start, width)
" call forms#log("g:forms#TextEditor.draw substr=" . substr)
            call forms#SetStringAt(substr, line+ycnt, column)
          endif

          let ycnt += 1
        endwhile

        while ycnt < height
          call forms#SetStringAt(blankStr, line+ycnt, column)

          let ycnt += 1
        endwhile
      endif
      if self.__status == g:IS_DISABLED
        call AugmentGlyphHilight(self, "DisableHi", a)
      endif                     
    endfunction
    let g:forms#TextEditor.draw = function("FORMS_TEXT_EDITOR_draw")

    function! FORMS_TEXT_EDITOR_reset() dict
      call self.__reset(self.__init_text)
    endfunction
    let g:forms#TextEditor.reset = function("FORMS_TEXT_EDITOR_reset")

    function! FORMS_TEXT_EDITOR___reset(initTxt) dict
      if type(a:initTxt) == g:self#STRING_TYPE
        let self.__clearInitText = g:self#IS_TRUE
        let self.__textlines = [ a:initTxt ]
        let xlen = strchars(a:initTxt)
        let self.__x_pos = xlen
        let self.__y_pos = 0
        let self.__x_win_start = xlen <= self.__width ? 0 : xlen - self.__width
      elseif type(a:initTxt) == g:self#LIST_TYPE 
        if len(a:initTxt) > 0
          let self.__clearInitText = g:self#IS_TRUE
          let self.__textlines = copy(a:initTxt)
          let ylen = len(self.__textlines)
          let xlen = strchars(self.__textlines[ylen-1])
          let self.__x_pos = xlen
          let self.__y_pos = ylen
          let self.__x_win_start = xlen <= self.__width ? 0 : xlen - self.__width
          let self.__y_win_start = ylen <= self.__height ? 0 : ylen - self.__height
        endif
      else
        throw "TextEditor: reset inital text must be either a string or a list of strings"
      endif
    endfunction
    let g:forms#TextEditor.__reset = function("FORMS_TEXT_EDITOR___reset")

    function! FORMS_TEXT_EDITOR_usage() dict
      return [
           \ "A TextEditor is a multi-line editor a fixed display",
           \ "  size but can hold any number of lines, each line.",
           \ "  holding number of characters.",
           \ "  The displayed characters will be scrolled both",
           \ "  left and right, and up and down as needed.",
           \ "  Keyboard characters are entered at the hotspot.",
           \ "  Backspace and delete (<BS> and <Del>) erase the.",
           \ "    character at the hotspot.",
           \ "Navigation across entered text can be done with",
           \ "  keyboard <Left> and <Right> buttons and mouse",
           \ "  <ScrollWheelLeft> and <ScrollWheelRight>",
           \ "  Up/down navigation is done with keyboard <Up>",
           \ "  and <Down> buttons and mouse <ScrollWheelUp>",
           \ "  and <ScrollWheelDown>.",
           \ "  Also, the mouse can be used to position the",
           \ "  TextEditor hotspot.",
           \ "There is no selection activity.",
           \ ]
    endfunction
    let g:forms#TextEditor.usage = function("FORMS_TEXT_EDITOR_usage")
  endif

  return g:forms#TextEditor
endfunction
" ------------------------------------------------------------ 
" forms#newTextEditor: {{{2
"   Create new TextEditor 
"  parameters: 
"   attrs  : attributes for initializing new object
" ------------------------------------------------------------ 
function! forms#newTextEditor(attrs)
  return forms#loadTextEditorPrototype().clone().init(a:attrs)
endfunction

"---------------------------------------------------------------------------
" TextBlock <- Leaf: {{{2
"---------------------------------------------------------------------------
" Similar to Text but here all lines must be of equal length.
"   Can be used to capture the background that a Glyph is about
"   to overwrite. As an example, Deck needs to use this TextBlock
"   because different Deck Cards write over possibly different 
"   areas.
"
" attributes
"   textblock : list of string of equal length
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms#TextBlock")
    unlet g:forms#TextBlock
  endif
endif
function! forms#loadTextBlockPrototype()
  if !exists("g:forms#TextBlock")
    let g:forms#TextBlock = forms#loadLeafPrototype().clone('forms#TextBlock')
    let g:forms#TextBlock.__textblock = []

    function! FORMS_TEXT_BLOCK_init(attrs) dict
      call call(g:forms#Leaf.init, [a:attrs], self)

      " make sure each line in the textblock has the same length
      let tb = self.__textblock
      let tblen = len(tb)
      if tblen > 0
        let l0len = len(tb[0])
        let cnt = 1
        while cnt < tblen
          if len(tb[cnt]) != l0len
            throw "TextBlock: First line length " . l0len . ", but line " . cnt . " has different length " . len(tb[cnt])
          endif
          let cnt += 1
        endwhile
      endif

      return self
    endfunction
    let g:forms#TextBlock.init = function("FORMS_TEXT_BLOCK_init")

    function! FORMS_TEXT_BLOCK_reinit(attrs) dict
" call forms#log("forms#TextBlock.reinit TOP")
      let oldTextBlock = self.__textblock

      let self.__textblock = []
      call call(g:forms#Leaf.reinit, [a:attrs], self)

      if len(oldTextBlock) != len(self.__textblock)
        call forms#PrependUniqueInput({'type': 'ReSize'})
      elseif len(oldTextBlock) > 0 && 
            \ len(oldTextBlock[0]) != len(self.__textblock)
        call forms#PrependUniqueInput({'type': 'ReSize'})
      else
        call forms#ViewerRedrawListAdd(self) 
      endif
    endfunction
    let g:forms#TextBlock.reinit = function("FORMS_TEXT_BLOCK_reinit")

    function! FORMS_TEXT_BLOCK_requestedSize() dict
" call forms#log("TextBlock.requestedSize: TOP")
      if (self.__status == g:IS_INVISIBLE) 
        return [0,0]
      else
        let tb = self.__textblock
        return (len(tb) == 0) ?  [0,0] : [len(tb[0]),len(tb)]
      endif
    endfunction
    let g:forms#TextBlock.requestedSize = function("FORMS_TEXT_BLOCK_requestedSize")

    function! FORMS_TEXT_BLOCK_draw(allocation) dict
" call forms#log("g:forms#TextBlock.draw" .  string(a:allocation))
      let self.__allocation = a:allocation
      let a = a:allocation

      if self.__status != g:IS_INVISIBLE
        let line = a:allocation.line
        let column = a:allocation.column
        " let width = a:allocation.width
        " let height = a:allocation.height

        let cnt = 0
        for str in self.__textblock
          call forms#SetStringAt(str, line+cnt, column)

          let cnt += 1
        endfor
      endif
      if self.__status == g:IS_DISABLED
        call AugmentGlyphHilight(self, "DisableHi", a)
      endif                     

    endfunction
    let g:forms#TextBlock.draw = function("FORMS_TEXT_BLOCK_draw")
  endif

  return g:forms#TextBlock
endfunction
" ------------------------------------------------------------ 
" forms#newTextBlock: {{{2
"   Create new TextBlock 
"  parameters: 
"   attrs  : attributes for initializing new object
" ------------------------------------------------------------ 
function! forms#newTextBlock(attrs)
  return forms#loadTextBlockPrototype().clone().init(a:attrs)
endfunction



"---------------------------------------------------------------------------
" SelectList <- Leaf: {{{2
"---------------------------------------------------------------------------
" Select from list of alternatives.
"
" attributes
"   pos      : optional: position of an initially selected item 
"   size     : display window size of choices
"   on_selection_action   : Action called when choice is selected
"                           default: noop action
"   on_deselection_action : Action called when choice is deselected
"                           default: noop action
"   choices  : list of name-id pairs (as list) [[text, id]*]
"                 where text and id are a strings
"   mode     : operation mode for selectlist:
"               single (default)
"                 zero or one selected at a time
"               mandatory_single 
"                 one selected at a time
"               mandatory_on_move_single 
"                 moving onto a choice, selects it and 
"                 deselects previous choice
"               multiple
"                 zero or more selected at a time
"               mandatory_multiple
"                 one or more selected at a time
"
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms#SelectList")
    unlet g:forms#SelectList
  endif
endif
function! forms#loadSelectListPrototype()
  if !exists("g:forms#SelectList")
    let g:forms#SelectList = forms#loadLeafPrototype().clone('forms#SelectList')
    let g:forms#SelectList.__size = -1
    let g:forms#SelectList.__pos = -1
    let g:forms#SelectList.__on_selection_action = g:forms_Util.emptyAction()
    let g:forms#SelectList.__on_deselection_action = g:forms_Util.emptyAction()
    let g:forms#SelectList.__win_start = 0
    let g:forms#SelectList.__choices = []
    let g:forms#SelectList.__mode = 'single'
    let g:forms#SelectList.__selections = []   " [idx, matchId]


    function! FORMS_SELECT_LIST_init(attrs) dict
" call forms#log("g:forms#SelectList.init ")
      call call(g:forms#Leaf.init, [a:attrs], self)

      if self.__mode != 'single' && 
          \ self.__mode != 'mandatory_single' &&
          \ self.__mode != 'mandatory_on_move_single' &&
          \ self.__mode != 'multiple' &&
          \ self.__mode != 'mandatory_multiple'
        throw "SelectList: Mode must be 'single', 'mandatory_single', 'mandatory_on_move_single', 'multiple' or 'mandatory_multiple': " . self.__mode
      endif

      if self.__pos >= len(self.__choices)
        throw "SelectList: pos greater than number of choices: " . self.__pos
      endif

      " Its initial value has been set in attrs. So, add a well-known magic
      " number to it which will serve as a clue for the first time that the
      " draw method is called that a selection should be highlighted.
      " If pos is not set but its mandatory, then set to 0 using magic value.
      " Finally, if pos is not set, then set to plain old 0.
      if self.__pos >= 0
        let self.__pos += 10000
      elseif self.__mode == 'mandatory_single' 
        let self.__pos = 10000
      elseif self.__mode == 'mandatory_on_move_single' 
        let self.__pos = 10000
      elseif self.__mode == 'mandatory_multiple' 
        let self.__pos = 10000
      else
        let self.__pos = 0
      endif

      return self
    endfunction
    let g:forms#SelectList.init = function("FORMS_SELECT_LIST_init")

    function! FORMS_SELECT_LIST_reinit(attrs) dict
" call forms#log("g:forms#SelectList.reinit TOP")
      for selection in self.__selections 
        let [_, sid] = selection
        call ClearSelectionId(sid)
      endfor

      let oldSize = self.__size

      let self.__size = -1
      let self.__pos = -1
      let self.__on_selection_action = g:forms_Util.emptyAction()
      let self.__on_deselection_action = g:forms_Util.emptyAction()
      let self.__win_start = 0
      let self.__choices = []
      let self.__mode = 'single'
      let self.__selections = [] 

      call call(g:forms#Leaf.reinit, [a:attrs], self)

      call forms#PrependUniqueInput({'type': 'ReSize'})
if 0
      if oldSize != self.__size
        call forms#PrependUniqueInput({'type': 'ReSize'})
      else
        call forms#ViewerRedrawListAdd(self) 
      endif
endif
    endfunction
    let g:forms#SelectList.reinit = function("FORMS_SELECT_LIST_reinit")

    function! FORMS_SELECT_LIST_canFocus() dict
      return (self.__status == g:IS_ENABLED)
    endfunction
    let g:forms#SelectList.canFocus = function("FORMS_SELECT_LIST_canFocus")

    function! FORMS_SELECT_LIST_hotspot() dict
      if (self.__status == g:IS_ENABLED)
        let pos = self.__pos
        "let size = self.__size
        let win_start = self.__win_start
        let a = self.__allocation
        let line = a.line
        let column = a.column
        
        if pos == 0
          call HotSpot(line, column)
        else
          call HotSpot(line+pos-win_start, column)
        endif
      endif
    endfunction
    let g:forms#SelectList.hotspot = function("FORMS_SELECT_LIST_hotspot")

    function! FORMS_SELECT_LIST_flash() dict
      if (self.__status == g:IS_ENABLED)
        call FlashRegion(self.__allocation)
      endif
    endfunction
    let g:forms#SelectList.flash = function("FORMS_SELECT_LIST_flash")

    function! FORMS_SELECT_LIST_addResults(results) dict
      let selections = self.__selections
      let slen = len(selections)
      if slen > 0
        let tag = self.getTag()

        if self.__mode == 'single' || self.__mode == 'mandatory_single' || self.__mode == 'mandatory_on_move_single'
" TODO what if nothing was selected
          let [idx, _] = selections[0]
          let [text, id] = self.__choices[idx]
          let a:results[tag] = [text, id]
        else
          let choices = []
          for selection in selections
            let [idx, _] = selection
            let [text, id] = self.__choices[idx]
            call add(choices, [text, id])
          endfor
          let a:results[tag] = choices

        endif
      endif

    endfunction
    let g:forms#SelectList.addResults = function("FORMS_SELECT_LIST_addResults")

    function! FORMS_SELECT_LIST_requestedSize() dict
      if (self.__status == g:IS_INVISIBLE) 
        return [0,0]
      else
        let w = 0
        for [text, _] in self.__choices
          let tlen = strchars(text)
          if w < tlen
            let w = tlen
          endif
        endfor
        let h = len(self.__choices)
        if self.__size < 0
          let self.__size = h
"call forms#log("g:forms#SelectList.requestedSize " .  string([w,h]))
          return [w,h]
        else
"call forms#log("g:forms#SelectList.requestedSize " .  string([w,self.__size]))
          return [w,self.__size]
        endif
      endif
    endfunction
    let g:forms#SelectList.requestedSize = function("FORMS_SELECT_LIST_requestedSize")

    function! FORMS_SELECT_LIST_selection() dict
      return self.__pos
    endfunction
    let g:forms#SelectList.selection = function("FORMS_SELECT_LIST_selection")

    function! FORMS_SELECT_LIST_handleEvent(event) dict
" call forms#log("g:forms#SelectList.handleEvent event=" . string(a:event))
      if (self.__status == g:IS_ENABLED)
        let type = a:event.type
        if type == 'Select'
          let a = self.__allocation
          let line = a:event.line
          let diff = line - a.line
          let pos = self.__win_start + diff
" call forms#log("g:forms#SelectList.handleEvent line=" . line)
" call forms#log("g:forms#SelectList.handleEvent diff=" . diff)
" call forms#log("g:forms#SelectList.handleEvent pos=" . pos)
" call forms#log("g:forms#SelectList.handleEvent self.__pos=" . self.__pos)
          let self.__pos = pos
          call self.handleSelection()
          call forms#ViewerRedrawListAdd(self) 
          return 1
        elseif type == 'SelectDobule'
          let a = self.__allocation
          let line = a:event.line
          let diff = line - a.line
          let pos = self.__win_start + diff
          if pos == self.__pos
            call self.handleSelectionDouble()
            call forms#ViewerRedrawListAdd(self) 
          endif
        endif
      endif
      return 0
    endfunction
    let g:forms#SelectList.handleEvent = function("FORMS_SELECT_LIST_handleEvent")

    function! FORMS_SELECT_LIST_handleChar(nr) dict
" call forms#log("g:forms#SelectList.handleChar")
      let handled = 0
      if (self.__status == g:IS_ENABLED)
        let size = self.__size

" call forms#log("g:forms#SelectList.handleChar: nr=". a:nr)
        let c = nr2char(a:nr)
        if a:nr == "\<Up>" || a:nr == "\<ScrollWheelUp>"
          if self.__pos == 0
            call self.flash()
          else
            let self.__pos -= 1
            if self.__mode == 'mandatory_on_move_single'
              call self.handleSelection()
            endif
           call forms#ViewerRedrawListAdd(self) 
          endif
" call forms#log("g:forms#SelectList.handleChar Up pos=" .  self.__pos)
          let handled = 1

        elseif a:nr == "\<Down>" || a:nr == "\<ScrollWheelDown>"
          if self.__pos == len(self.__choices) - 1
            call self.flash()
          else
            let self.__pos += 1
            if self.__mode == 'mandatory_on_move_single'
              call self.handleSelection()
            endif
           call forms#ViewerRedrawListAdd(self) 
          endif
" call forms#log("g:forms#SelectList.handleChar Down pos=" .  self.__pos)
          let handled = 1

        elseif c == "\<CR>" || c == "\<Space>"
" call forms#log("g:forms#SelectList.handleChar NEW CR pos=" .  self.__pos)
          call self.handleSelection() 
          let handled = 1
        endif

        let pos = (self.__pos >= 10000) ? self.__pos - 10000 : self.__pos

        if pos >= self.__win_start + size
          let self.__win_start += 1
        elseif self.__win_start > 0 && pos < self.__win_start
          let self.__win_start -= 1
        endif
      endif
" call forms#log("g:forms#SelectList.handleChar win_start=" .  self.__win_start)

      return handled
    endfunction
    let g:forms#SelectList.handleChar = function("FORMS_SELECT_LIST_handleChar")

    function! FORMS_SELECT_LIST_handleSelection() dict
" call forms#log("g:forms#SelectList.handleSelection")
      let selections = self.__selections
      let pos = self.__pos
      let slen = len(selections)

      if slen == 0 " first time
" call forms#log("g:forms#SelectList.handleSelection first time")
        let a = self.__allocation
        let sid = GetSelectionId({
                                \ 'line': a.line+pos,
                                \ 'column': a.column,
                                \ 'height': 1,
                                \ 'width': a.width,
                                \ })
        if self.__mode == 'single' || self.__mode == 'mandatory_single' || self.__mode == 'mandatory_on_move_single'
          let self.__selections = [[pos, sid]]
        else
          call add(self.__selections, [pos, sid])
        endif
        call self.__on_selection_action.execute(pos)

      else
        if self.__mode == 'single'
" call forms#log("g:forms#SelectList.handleSelection single")
          let i = -1
          if slen > 0
            let [idx, sid] = selections[0]
" call forms#log("g:forms#SelectList.handleSelection single: idx=" .idx)
" call forms#log("g:forms#SelectList.handleSelection single: sid=" .sid)
            call ClearSelectionId(sid)
            let i = idx
            let self.__selections = []
" call forms#log("g:forms#SelectList.handleSelection single: BEFORE")
            call self.__on_deselection_action.execute(i)

          endif

" call forms#log("g:forms#SelectList.handleSelection pos=". pos)
" call forms#log("g:forms#SelectList.handleSelection i=". i)
          if i != pos
            let a = self.__allocation
            let sid = GetSelectionId({
                                    \ 'line': a.line+pos,
                                    \ 'column': a.column,
                                    \ 'height': 1,
                                    \ 'width': a.width,
                                    \ })
            let self.__selections = [[pos, sid]]
            call self.__on_selection_action.execute(pos)
          endif

        elseif self.__mode == 'mandatory_single' || self.__mode == 'mandatory_on_move_single'
" call forms#log("g:forms#SelectList.handleSelection mandatory_single")
          let [idx, sid] = selections[0]
          if idx != pos
            call ClearSelectionId(sid)
            let self.__selections = []
            call self.__on_deselection_action.execute(idx)

            let a = self.__allocation
            let sid = GetSelectionId({
                                    \ 'line': a.line+pos,
                                    \ 'column': a.column,
                                    \ 'height': 1,
                                    \ 'width': a.width,
                                    \ })
            let self.__selections = [[pos, sid]]
            call self.__on_selection_action.execute(pos)
          endif

        elseif self.__mode == 'multiple'
" call forms#log("g:forms#SelectList.handleSelection multiple")
          let s = []
          let found = 0 
          for selection in selections
            let [idx, sid] = selection
            if idx == pos
              call ClearSelectionId(sid)
              call self.__on_deselection_action.execute(pos)
              let found = 1
            else
              call add(s, selection)
            endif
          endfor

          if ! found
            let a = self.__allocation
            let sid = GetSelectionId({
                                    \ 'line': a.line+pos,
                                    \ 'column': a.column,
                                    \ 'height': 1,
                                    \ 'width': a.width,
                                    \ })
            call add(s, [pos, sid])
            call self.__on_selection_action.execute(pos)
          endif

          unlet self.__selections
          let self.__selections = s

        else " mandatory_multiple
" call forms#log("g:forms#SelectList.handleSelection mandatory_multiple")
          let s = []
          let found = 0 
          for selection in selections
            let [idx, sid] = selection
            if idx == pos
              if slen > 1
                call ClearSelectionId(sid)
                call self.__on_deselection_action.execute(pos)
              else
                call add(s, selection)
              endif
              let found = 1
            else
              call add(s, selection)
            endif
          endfor

          if ! found
            let a = self.__allocation
            let sid = GetSelectionId({
                                    \ 'line': a.line+pos,
                                    \ 'column': a.column,
                                    \ 'height': 1,
                                    \ 'width': a.width,
                                    \ })
            call add(s, [pos, sid])
            call self.__on_selection_action.execute(pos)
          endif

          unlet self.__selections
          let self.__selections = s

        endif
      endif
    endfunction
    let g:forms#SelectList.handleSelection = function("FORMS_SELECT_LIST_handleSelection")

    function! FORMS_SELECT_LIST_draw(allocation) dict
" call forms#log("g:forms#SelectList.draw" .  string(a:allocation))
      let self.__allocation = a:allocation
      let a = a:allocation

      if self.__status != g:IS_INVISIBLE
        let line = a.line
        let column = a.column
        let width = a.width
        let size = self.__size
        let win_start = self.__win_start
        let selections = self.__selections
        let slen = len(selections)
" call forms#log("g:forms#SelectList.draw slen=" .  slen)
" call forms#log("g:forms#SelectList.draw win_start=" .  win_start)

        
        " If magic number, then pos has an initial value, so mock the entry of
        " a <CR> to highlight the position.
        if self.__pos >= 10000
          let self.__pos -= 10000
          call self.handleChar(13)
        endif

        let nos_choices = len(self.__choices)
        if nos_choices > size
          let endcnt = size
        else
          let endcnt = nos_choices
        endif
"call forms#log("g:forms#SelectList.draw endcnt=" .  endcnt)
        let cnt = 0
        while cnt < endcnt
"call forms#log("g:forms#SelectList.draw cnt=" .  cnt)
"call forms#log("g:forms#SelectList.draw win_start=" .  win_start)
          let [text, _] = self.__choices[cnt+win_start]
" call forms#log("g:forms#SelectList.draw text=" .  text)
          let tlen = strchars(text)

          if tlen == width
            call forms#SetStringAt(text, line+cnt, column)
          else
            let diff =  width - tlen
            if tlen > 0
              call forms#SetStringAt(text, line+cnt, column)
            endif
            if diff > 0
              let blankStr = repeat(' ', diff)
              call forms#SetStringAt(blankStr, line+cnt, column+tlen)
            endif
          endif
          

          let cnt += 1
        endwhile

        let min_idx = win_start
        let max_idx = min_idx + endcnt

        if slen > 0
          if self.__mode == 'single' || self.__mode == 'mandatory_single' || self.__mode == 'mandatory_on_move_single'
            let [idx, sid] = selections[0]
            call ClearSelectionId(sid)
            if idx >= min_idx && idx < max_idx
              let sid = GetSelectionId({
                                      \ 'line': a.line+idx-win_start,
                                      \ 'column': a.column,
                                      \ 'height': 1,
                                      \ 'width': a.width,
                                      \ })
              let self.__selections = [[idx, sid]]
            endif
          else
            for selection in selections
              let [idx, sid] = selection
              call ClearSelectionId(sid)
              if idx >= min_idx && idx < max_idx
                let sid = GetSelectionId({
                                        \ 'line': a.line+idx-win_start,
                                        \ 'column': a.column,
                                        \ 'height': 1,
                                        \ 'width': a.width,
                                        \ })
                let selection[1] = sid
              endif
            endfor
          endif
        endif
      endif
      if self.__status == g:IS_DISABLED
        call AugmentGlyphHilight(self, "DisableHi", a)
      endif                     
    endfunction
    let g:forms#SelectList.draw = function("FORMS_SELECT_LIST_draw")

    function! FORMS_SELECT_LIST_usage() dict
      return [
           \ "A SelectList is a multi-line editor a fixed display",
           \ "  size but can hold any number of lines, each line.",
           \ "  holding number of characters.",
           \ "  The displayed characters will be scrolled both",
           \ "  left and right, and up and down as needed.",
           \ "  Keyboard characters are entered at the hotspot.",
           \ "  Backspace and delete (<BS> and <Del>) erase the.",
           \ "    character at the hotspot.",
           \ "Navigation across entered text can be done with",
           \ "  keyboard <Left> and <Right> buttons and mouse",
           \ "  <ScrollWheelLeft> and <ScrollWheelRight>",
           \ "  Up/down navigation is done with keyboard <Up>",
           \ "  and <Down> buttons and mouse <ScrollWheelUp>",
           \ "  and <ScrollWheelDown>.",
           \ "Selection is with keyboard with a mouse <LeftMouse>",
           \ "  click."
           \ ]
    endfunction
    let g:forms#SelectList.usage = function("FORMS_SELECT_LIST_usage")
  endif

  return g:forms#SelectList
endfunction
" ------------------------------------------------------------ 
" forms#newSelectList: {{{2
"   Create new SelectList 
"  parameters: 
"   attrs  : attributes for initializing new object
" ------------------------------------------------------------ 
function! forms#newSelectList(attrs)
  return forms#loadSelectListPrototype().clone().init(a:attrs)
endfunction

"---------------------------------------------------------------------------
" PopDownList <- Leaf: {{{2
"---------------------------------------------------------------------------
" Select and displays from pop menu of alternative labels.
"
" attributes
"   pos      : position of an initially selected item (default 0)
"   on_selection_action   : Action called when choice is selected
"                           default: noop action
"   choices  : list of name-id pairs (as list) [[text, id]*]
"                 where text and id are a strings
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms#PopDownList")
    unlet g:forms#PopDownList
  endif
endif
function! forms#loadPopDownListPrototype()
  if !exists("g:forms#PopDownList")
    let g:forms#PopDownList = forms#loadLeafPrototype().clone('forms#PopDownList')
    let g:forms#PopDownList.__pos = 0
    let g:forms#PopDownList.__on_selection_action = g:forms_Util.emptyAction()
    let g:forms#PopDownList.__choices = []


    function! FORMS_POP_DOWN_LIST_init(attrs) dict
" call forms#log("g:forms#PopDownList.init ")
      call call(g:forms#Leaf.init, [a:attrs], self)

      if self.__pos >= len(self.__choices)
        throw "PopDownList: pos greater than number of choices: " . self.__pos
      endif

      function! CBAction(...) dict
" call forms#log("CBAction.execute: pos=" . self.pos)
        if self.popdownlist.__pos != self.pos
          let self.popdownlist.__pos = self.pos
          " call self.popdownlist.__on_selection_action.execute(self.pos)
          " call forms#ViewerRedrawListAdd(self.popdownlist) 
        endif
        call forms#AppendInput({ 'type': 'Exit' })
      endfunction

      let items = []
      let cnt = 0
      for choice in self.__choices
        let [label, id] = choice
        let action = forms#newAction({ 'execute': function("CBAction")})
        let action.pos = cnt
        let action.popdownlist = self

        call add(items, { 'type': 'button',
                      \   'label': label,
                      \   'highlight': 0, 
                      \   'action': action
                      \ })
        let cnt += 1
      endfor
      let attrs = {'items': items}
      let self.__menu = forms#newMenu(attrs)

      return self
    endfunction
    let g:forms#PopDownList.init = function("FORMS_POP_DOWN_LIST_init")

    function! FORMS_POP_DOWN_LIST_reinit(attrs) dict
" call forms#log("g:forms#PopDownList.reinit TOP")

      let self.__pos = 0
      let self.__on_selection_action = g:forms_Util.emptyAction()
      let self.__choices = []
      call self.__menu.delete()
      unlet self.__menu

      call call(g:forms#Leaf.reinit, [a:attrs], self)
    endfunction
    let g:forms#PopDownList.reinit = function("FORMS_POP_DOWN_LIST_reinit")

    function! FORMS_POP_DOWN_LIST_canFocus() dict
      return (self.__status == g:IS_ENABLED)
    endfunction
    let g:forms#PopDownList.canFocus = function("FORMS_POP_DOWN_LIST_canFocus")

    function! FORMS_POP_DOWN_LIST_hotspot() dict
      if (self.__status == g:IS_ENABLED)
        let a = self.__allocation
        let line = a.line
        let column = a.column
        call HotSpot(line, column)
      endif
    endfunction
    let g:forms#PopDownList.hotspot = function("FORMS_POP_DOWN_LIST_hotspot")

    function! FORMS_POP_DOWN_LIST_flash() dict
      if (self.__status == g:IS_ENABLED)
        call FlashRegion(self.__allocation)
      endif
    endfunction
    let g:forms#PopDownList.flash = function("FORMS_POP_DOWN_LIST_flash")

    function! FORMS_POP_DOWN_LIST_addResults(results) dict
      let tag = self.getTag()
      let [text, id] = self.__choices[self.__pos]
      let a:results[tag] = [text, id]
    endfunction
    let g:forms#PopDownList.addResults = function("FORMS_POP_DOWN_LIST_addResults")

    function! FORMS_POP_DOWN_LIST_requestedSize() dict
      if (self.__status == g:IS_INVISIBLE) 
        return [0,0]
      else
        let h = 1
        let w = 0
        for [text, _] in self.__choices
          let tlen = strchars(text)
          if w < tlen
            let w = tlen
          endif
        endfor
" call forms#log("g:forms#PopDownList.requestedSize " .  string([w,h]))
        return [w,h]
      endif
    endfunction
    let g:forms#PopDownList.requestedSize = function("FORMS_POP_DOWN_LIST_requestedSize")

    function! FORMS_POP_DOWN_LIST_selection() dict
      return self.__pos
    endfunction
    let g:forms#PopDownList.selection = function("FORMS_POP_DOWN_LIST_selection")

    function! FORMS_POP_DOWN_LIST_handleEvent(event) dict
" call forms#log("g:forms#PopDownList.handleEvent event=" . string(a:event))
      if (self.__status == g:IS_ENABLED)
        let type = a:event.type
        if type == 'Select'
          call self.handleSelection() 
          return 1
        elseif type == 'SelectDobule'
        endif
      endif
      return 0
    endfunction
    let g:forms#PopDownList.handleEvent = function("FORMS_POP_DOWN_LIST_handleEvent")

    function! FORMS_POP_DOWN_LIST_handleChar(nr) dict
" call forms#log("g:forms#PopDownList.handleChar")
      let handled = 0
      if (self.__status == g:IS_ENABLED)
" call forms#log("g:forms#PopDownList.handleChar: nr=". a:nr)
        let c = nr2char(a:nr)
        if c == "\<CR>" || c == "\<Space>"
" call forms#log("g:forms#PopDownList.handleChar NEW CR pos=" .  self.__pos)
          call self.handleSelection() 
          let handled = 1
        endif
      endif
" call forms#log("g:forms#PopDownList.handleChar win_start=" .  self.__win_start)
      return handled
    endfunction
    let g:forms#PopDownList.handleChar = function("FORMS_POP_DOWN_LIST_handleChar")

    function! FORMS_POP_DOWN_LIST_handleSelection() dict
"call forms#log("g:forms#PopDownList.handleSelection: TOP")
      let pos = self.__pos
      let a = self.__allocation
"call forms#log("g:forms#PopDownList.handleSelection: a=".string(a))
      let line = a.line
      let column = a.column
      let menu = self.__menu
      let y_screen = line+1 -s:form_top_screen_line
      let attrs = {
                  \ 'x_screen': column, 
                  \ 'y_screen': y_screen, 
                  \ 'delete': 0, 
                  \ 'body': menu 
                  \ }
      let form = forms#newForm(attrs)
      function! form.purpose() dict
        return [
            \ "This Form shows a list selections for the PopDownList."
            \ ]
      endfunction
      call form.run()
      if pos != self.__pos
"call forms#log("g:forms#PopDownList.handleSelection: CHANGE")
        call self.__on_selection_action.execute(self.__pos)
        call forms#ViewerRedrawListAdd(self) 
      endif
"call forms#log("g:forms#PopDownList.handleSelection: BOTTOM")
    endfunction
    let g:forms#PopDownList.handleSelection = function("FORMS_POP_DOWN_LIST_handleSelection")

    function! FORMS_POP_DOWN_LIST_draw(allocation) dict
"call forms#log("g:forms#PopDownList.draw" .  string(a:allocation))
      let self.__allocation = a:allocation
      let a = a:allocation

      if self.__status != g:IS_INVISIBLE
        let line = a.line
        let column = a.column
        let width = a.width
        let pos = self.__pos
        let [label, id] = self.__choices[pos]

        call forms#SetStringAt(label, line, column)
        let llen = len(label)
        if llen < width
          call forms#SetHCharsAt(' ', (width-llen), line, column+llen)
        endif
      endif

      if self.__status == g:IS_DISABLED
        call AugmentGlyphHilight(self, "DisableHi", a)
      endif                     
    endfunction
    let g:forms#PopDownList.draw = function("FORMS_POP_DOWN_LIST_draw")

    function! FORMS_POP_DOWN_LIST_usage() dict
      return [
           \ "A PopDownList is type of Button with a selection action",
           \ "  that generates a popup menu. An entry in the popup",
           \ "  menu can be selected to become the new title of the",
           \ "  PopDownList button.",
           \ "Navigation across entered text can be done with",
           \ "  keyboard <Left> and <Right> buttons and mouse",
           \ "  <ScrollWheelLeft> and <ScrollWheelRight>",
           \ "  Up/down navigation is done with keyboard <Up>",
           \ "  and <Down> buttons and mouse <ScrollWheelUp>",
           \ "  and <ScrollWheelDown>.",
           \ "Selection is with keyboard <CR> or <Space>, or",
           \ "  mouse <LeftMouse> click."
           \ ]
    endfunction
    let g:forms#PopDownList.usage = function("FORMS_POP_DOWN_LIST_usage")
  endif

  return g:forms#PopDownList
endfunction
" ------------------------------------------------------------ 
" forms#newPopDownList: {{{2
"   Create new PopDownList 
"  parameters: 
"   attrs  : attributes for initializing new object
" ------------------------------------------------------------ 
function! forms#newPopDownList(attrs)
  return forms#loadPopDownListPrototype().clone().init(a:attrs)
endfunction


"---------------------------------------------------------------------------
" Slider <- Leaf: {{{2
"---------------------------------------------------------------------------
" Abstract Slider with size, range and resolution
"   The display resolution depends upon the number of postions 
"   per charater cell:
"     1 : one position per cell
"     2 : two positions per cell
"     3 : four positions per cell
"     4 : eight positions per cell
"     [ positions_per_cell == 2^(resolution-1) ]
"  The number of characters, the size, times the number of display positions
"    per cell yeilds the total display resolution; how many different
"    positions the slider can occupy on the screen.
"  For a size of 1, there is in fact only a single position. Not
"    very interesting.
"  For a size of 2, there can be from 2 (resolution == 1) to 
"   9 (resolution == 4) possible slider positions 
"  For a size of 3, there can be from 2 (resolution == 1) to 
"   17 (resolution == 4) possible slider positions 
"     [ number_slider_positions == positions_per_cell * (size-1) + 1]
"  So, what values should one select. Say one has a variable that can
"  take values from 0 to 255, 256 possible values. Then
"     256 = 2^(resolution-1) * (size - 1) + 1
"   let resolution == 4, so
"     256 = 8 * (size - 1) + 1
"   or, size == 32 (about); you need a slider 32 characters long.
"   Well, this is a TUI, a text character-base User Interface so thats
"     the smallest slider that accurately displays the full range.
"
" attributes
"   size       : Number of characters for slider
"   range      : List of lower and upper values
"                 [lower, upper] inclusive
"   value      : Number initial value of slider
"                 default value is range minimum
"   resolution : Number from 1 to 4 
"                  Per character location display resolution
"   on_move_action : Action called every time slider moves
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms#Slider")
    unlet g:forms#Slider
  endif
endif
function! forms#loadSliderPrototype()
  if !exists("g:forms#Slider")
    " HSLIDER SPECIFIC
    let g:forms#Slider = forms#loadLeafPrototype().clone('forms#Slider')
    let g:forms#Slider.__value = -1
    let g:forms#Slider.__size = -1
    let g:forms#Slider.__range = []
    let g:forms#Slider.__resolution = 1
    let g:forms#Slider.__on_move_action = g:forms_Util.emptyAction()


    function! FORMS_SLIDER_init(attrs) dict
" call forms#log("g:forms#Slider.init ")
      call call(g:forms#Leaf.init, [a:attrs], self)

      if self.__size < 2
        throw "Slider: size must be greater than 1, number: " . self.__size
      endif

      let [lower,upper] = self.__range
      if lower == upper
        throw "Slider: bad range lower == upper: " . string(self.__range)
      endif
      if lower > upper
        throw "Slider: bad range lower > upper: " . string(self.__range)
      endif
      let value = self.__value

      if value == -1
        " -1 might be a valid value
        if value < lower || value > upper
          let self.__value = lower
        endif
      else
        if value < lower
          throw "Slider: value less than lower range: " . value
        endif
        if value > upper
          throw "Slider: value greater than upper range: " . value
        endif
      endif

      if self.__resolution < 0
        throw "Slider: resolution must 1, 2, 3 or 4: " . self.__resolution
      endif
      if self.__resolution > 4
        throw "Slider: resolution must 1, 2, 3 or 4: " . self.__resolution
      endif

      return self
    endfunction
    let g:forms#Slider.init = function("FORMS_SLIDER_init")

    function! FORMS_SLIDER_reinit(attrs) dict
" call forms#log("g:forms#Slider.reinit TOP")
      let oldSize = self.__size

      let self.__value = 0
      let self.__size = -1
      let self.__range = []
      let self.__resolution = 1
      let self.__on_move_action = g:forms_Util.emptyAction()

      call call(g:forms#Leaf.reinit, [a:attrs], self)

      if self.__size != oldSize
        call forms#PrependUniqueInput({'type': 'ReSize'})
      endif
    endfunction
    let g:forms#Slider.reinit = function("FORMS_SLIDER_reinit")

    function! FORMS_SLIDER_delete(...) dict
      call ReverseClear(self)

      let p = g:forms#Leaf._prototype
      call call(p.delete, [p], self)
    endfunction
    let g:forms#Slider.delete = function("FORMS_SLIDER_delete")

    function! FORMS_SLIDER_canFocus() dict
      return (self.__status == g:IS_ENABLED)
    endfunction
    let g:forms#Slider.canFocus = function("FORMS_SLIDER_canFocus")

    function! FORMS_SLIDER_hotspot() dict
      if (self.__status == g:IS_ENABLED)
" call forms#log("g:forms#Slider.hotspot")
      endif
    endfunction
    let g:forms#Slider.hotspot = function("FORMS_SLIDER_hotspot")

    function! FORMS_SLIDER_flash() dict
" call forms#log("g:forms#Slider.flash")
      if (self.__status == g:IS_ENABLED)
        call FlashRegion(self.__allocation)
      endif
    endfunction
    let g:forms#Slider.flash = function("FORMS_SLIDER_flash")

    function! FORMS_SLIDER_getRangeValue() dict
      return self.__value
    endfunction
    let g:forms#Slider.getRangeValue = function("FORMS_SLIDER_getRangeValue")

    function! FORMS_SLIDER_setRangeValue(value) dict
" call forms#log("g:forms#Slider.setRangeValue: value=" . a:value)
      let [lower, upper] = self.__range
      if a:value < lower
        throw "Slider: value out of range: " . value
      endif
      if a:value > upper
        throw "Slider: value out of range: " . value
      endif

      if a:value != self.__value
        let self.__value = a:value
        if ! empty(self.__allocation)
          call forms#ViewerRedrawListAdd(self) 
        endif
      endif
    endfunction
    let g:forms#Slider.setRangeValue = function("FORMS_SLIDER_setRangeValue")

    function! FORMS_SLIDER_addResults(results) dict
      let tag = self.getTag()
      let value = self.__value
      let a:results[tag] = value
    endfunction
    let g:forms#Slider.addResults = function("FORMS_SLIDER_addResults")

    function! FORMS_SLIDER_handleEvent(event) dict
" call forms#log("g:forms#Slider.handleEvent event=" . string(a:event))
      if (self.__status == g:IS_ENABLED)
        let type = a:event.type
        if type == 'Select'
          let v = self.dimension2value(a:event)
" call forms#log("g:forms#Slider.handleEvent v=" . v)
          if self.__value != v
            let self.__value = v
            call self.handleSelection() 
          endif
          let self.doing_drag = 1

          return 1
        elseif type == 'Drag' && exists("self.doing_drag")
          let v = self.dimension2value(a:event)
          if self.__value != v
            let self.__value = v
            call self.handleSelection() 
          endif
          return 1
        elseif type == 'Release' && exists("self.doing_drag")
          unlet! self.doing_drag 
          return 1
        endif
      endif
      return 0
    endfunction
    let g:forms#Slider.handleEvent = function("FORMS_SLIDER_handleEvent")

    function! FORMS_SLIDER_handleChar(nr) dict
" call forms#log("g:forms#Slider.handleChar")
      let handled = 0
      if (self.__status == g:IS_ENABLED)
" call forms#log("g:forms#Slider.handleChar: nr=". a:nr)
        let c = nr2char(a:nr)
        if c == "\<CR>" || c == "\<Space>"
" call forms#log("g:forms#Slider.handleChar NEW CR pos=" .  self.__pos)
          "call self.handleSelection() 
          let handled = 1

        elseif a:nr == "\<Left>" || 
                \ a:nr == "\<ScrollWheelLeft>" ||
                \ a:nr == "\<Down>" ||
                \ a:nr == "\<ScrollWheelDown>"
          let [lower, upper] = self.__range
          if self.__value == lower
            call self.flash()
          else
            let self.__value -= 1
            call self.handleSelection() 
          endif
" call forms#log("g:forms#Slider.handleChar LEFT value=" .  self.__value)
          let handled = 1

        elseif a:nr == "\<S-Left>" || 
                \ a:nr == "\<S-ScrollWheelLeft>" ||
                \ a:nr == "\<S-Down>" ||
                \ a:nr == "\<S-ScrollWheelDown>"
          let [lower, upper] = self.__range
          if self.__value == lower
            call self.flash()
          else
            let d = (upper - lower) / 10
            let self.__value -= d
            if self.__value < lower
              let self.__value = lower
            endif
            call self.handleSelection() 
          endif
          let handled = 1

        elseif a:nr == "\<C-Left>" || 
                \ a:nr == "\<C-ScrollWheelLeft>" ||
                \ a:nr == "\<C-Down>" ||
                \ a:nr == "\<C-ScrollWheelDown>"
          let [lower, upper] = self.__range
          if self.__value == lower
            call self.flash()
          else
            let d = (upper - lower) / 10
            let self.__value -= d
            if self.__value < lower
              let self.__value = lower
            endif
            call self.handleSelection() 
          endif
          let handled = 1

        elseif a:nr == "\<Right>" || 
                \ a:nr == "\<ScrollWheelRight>" ||
                \ a:nr == "\<Up>" ||
                \ a:nr == "\<ScrollWheelUp>"
          let [lower, upper] = self.__range
          if self.__value == upper
            call self.flash()
          else
            let self.__value += 1
            call self.handleSelection() 
          endif
" call forms#log("g:forms#Slider.handleChar RIGHT value=" .  self.__value)
          let handled = 1

        elseif a:nr == "\<S-Right>" || 
                \ a:nr == "\<S-ScrollWheelRight>" ||
                \ a:nr == "\<S-Up>" ||
                \ a:nr == "\<S-ScrollWheelUp>"
          let [lower, upper] = self.__range
          if self.__value == upper
            call self.flash()
          else
            let d = (upper - lower) / 10
            let self.__value += d
            if self.__value > upper
              let self.__value = upper
            endif
            call self.handleSelection() 
          endif
          let handled = 1

        elseif a:nr == "\<C-Right>" || 
                \ a:nr == "\<C-ScrollWheelRight>" ||
                \ a:nr == "\<C-Up>" ||
                \ a:nr == "\<C-ScrollWheelUp>"
          let [lower, upper] = self.__range
          if self.__value == upper
            call self.flash()
          else
            let d = (upper - lower) / 10
            let self.__value += d
            if self.__value > upper
              let self.__value = upper
            endif
            call self.handleSelection() 
          endif
          let handled = 1

        endif
      endif

      return handled
    endfunction
    let g:forms#Slider.handleChar = function("FORMS_SLIDER_handleChar")

    function! FORMS_SLIDER_handleSelection() dict
      let value = self.__value
      call self.__on_move_action.execute(value)
      if ! empty(self.__allocation)
        call forms#ViewerRedrawListAdd(self) 
      endif
    endfunction
    let g:forms#Slider.handleSelection = function("FORMS_SLIDER_handleSelection")

    function! FORMS_SLIDER_value2pos() dict
      let value = self.__value
      let size = self.__size
      let [lower, upper] = self.__range

      return value * size / (upper - lower + 1)
    endfunction
    let g:forms#Slider.value2pos = function("FORMS_SLIDER_value2pos")

    function! FORMS_SLIDER_usage() dict
      return [
           \ "A Slider lets one position the hotspot and, thus, select a",
           \ "  value from the Slider's range of discrete values. A",
           \ "  Slider can be vertical or horizontal. Each Slider has one",
           \ "  of four resolutions. Each resolution determines the",
           \ "  allowable positions of the hotspot; number of character",
           \ "  positions per screen character cell, This number ranges",
           \ "  from 1 (lowest resolution) to 8 (highest resolution).",
           \ "  For a Slider to have a value range of size 5, with",
           \ "  resolution 1, it would take 5 character cells while with",
           \ "  resolution 8, it would take a single character cell.",
           \ "Navigation can be done with keyboard <Left>, <Right>,",
           \ "  <Down> and <UP> with optional Shift and Control metakeys.",
           \ "  Also, with <ScrollWheelLeft>, <ScrollWheelRight>,",
           \ "  <ScrollWheelUp>, <ScrollWheelDown> again with optional,",
           \ "  Shift and Control metakeys. Mouse <LeftMouse> select",
           \ "  and <Drag>/<Release> are supported.",
           \ "  Not all keyboard+metakey combinations are always supported.",
           \ "There is no selection activity.",
           \ ]
    endfunction
    let g:forms#Slider.usage = function("FORMS_SLIDER_usage")
  endif

  return g:forms#Slider
endfunction

"---------------------------------------------------------------------------
" HSlider <- Slider: {{{2
"---------------------------------------------------------------------------
" Horizontal Slider concrete object of Slider
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms#HSlider")
    unlet g:forms#HSlider
  endif
endif
function! forms#loadHSliderPrototype()
  if !exists("g:forms#HSlider")
    let g:forms#HSlider = forms#loadSliderPrototype().clone('forms#HSlider')

    function! FORMS_HSLIDER_gainFocus() dict
      if (self.__status == g:IS_ENABLED)
" call forms#log("g:forms#HSlider.gainFocus")
        let self.__hasfocus = 1
        let a = self.__allocation
        call HotRegion(a)
        if exists("self.__reverse")
" call forms#log("g:forms#HSlider.gainFocus: DO REVERSE")
          call ReverseHotSpot(a.line, self.__reverse)
        endif
      endif
    endfunction
    let g:forms#HSlider.gainFocus = function("FORMS_HSLIDER_gainFocus")

    function! FORMS_HSLIDER_loseFocus() dict
" call forms#log("g:forms#HSlider.loseFocus")
      call ReverseHotSpotClear()
      if exists("self.__hasfocus")
        unlet self.__hasfocus
      endif
      if exists("self.__reverse")
" call forms#log("g:forms#HSlider.loseFocus: DO REVERSE")
        let a = self.__allocation
        call Reverse(self, a.line, self.__reverse)
      endif
    endfunction
    let g:forms#HSlider.loseFocus = function("FORMS_HSLIDER_loseFocus")

    function! FORMS_HSLIDER_requestedSize() dict
" call forms#log("g:forms#HSlider.requestedSize ")
      if (self.__status == g:IS_INVISIBLE) 
        return [0,0]
      else
        return [self.__size,1]
      endif
    endfunction
    let g:forms#HSlider.requestedSize = function("FORMS_HSLIDER_requestedSize")

    function! FORMS_HSLIDER_dimension2value(event) dict
      let col = a:event.column
      let a = self.__allocation
      let column = a.column
      let width = a.width
      let [lower, upper] = self.__range
" call forms#log("g:forms#HSlider.dimension2value: col=".col)
" call forms#log("g:forms#HSlider.dimension2value: column=".column)
" call forms#log("g:forms#HSlider.dimension2value: width=".width)

      if col <= column
        return lower
      elseif col >= column+width-1
        return upper
      else
        let pos = col - column
        return lower + ((pos * (upper - lower)) / (width-1))
      endif
    endfunction
    let g:forms#HSlider.dimension2value = function("FORMS_HSLIDER_dimension2value")

    function! FORMS_HSLIDER_draw(allocation) dict
"call forms#log("g:forms#HSlider.draw" .  string(a:allocation))
      let self.__allocation = a:allocation
      let a = a:allocation

      if self.__status != g:IS_INVISIBLE
        let has_focus = exists("self.__hasfocus")
" call forms#log("g:forms#HSlider.draw has_focus" .   has_focus)
        if has_focus
          call HotRegion(a)
        endif

        let line = a.line
        let column = a.column
        "let width = a.width
        let pos = self.value2pos()
        let size = self.__size
        let resolution = self.__resolution

        let full = b:forms_FullB
" call forms#log("g:forms#HSlider.draw resolution=" .  resolution)

        " nos possible positions = resolution * (size-1) + 1
        if resolution == 1
          if pos == 0
            call forms#SetCharAt(full, line, column)
            call forms#SetHCharsAt(' ', (size-1), line, column+1)
          elseif pos == size-1
            call forms#SetHCharsAt(' ', (size-1), line, column)
            call forms#SetCharAt(full, line, column+size-1)
          else
            call forms#SetHCharsAt(' ', (pos-1), line, column)
            call forms#SetCharAt(full, line, column+pos)
            call forms#SetHCharsAt(' ', (size-pos=1), line, column+pos+1)
          endif

        elseif resolution == 2
          let el_per_cell = 2
          let nosoffsets = el_per_cell * (size-1) + 1
          let value = self.__value
          let [lower, upper] = self.__range
          let offset = value * nosoffsets/(upper-lower+1)
          let p = (offset/el_per_cell) * el_per_cell
          let i = offset - p
" call forms#log("g:forms#HSlider.draw nosoffsets=" .  nosoffsets)
" call forms#log("g:forms#HSlider.draw value=" .  value)
" call forms#log("g:forms#HSlider.draw offset=" .  offset)
" call forms#log("g:forms#HSlider.draw p=" .  p)
" call forms#log("g:forms#HSlider.draw i=" .  i)
          let pp = p / el_per_cell
" call forms#log("g:forms#HSlider.draw pp=" .  pp)

          if i == 0
            if pp == 0
" call forms#log("g:forms#HSlider.draw A")
              call forms#SetCharAt(full, line, column)
              call forms#SetHCharsAt(' ', (size-1), line, column+1)

            elseif pp == size-1
" call forms#log("g:forms#HSlider.draw B")
              call forms#SetHCharsAt(' ', (size-1), line, column)
              call forms#SetCharAt(full, line, column+size-1)

            else
" call forms#log("g:forms#HSlider.draw C")
              call forms#SetHCharsAt(' ', (pp), line, column)
              " call forms#SetCharAt(' ', line, column+pp-1)
              call forms#SetCharAt(full, line, column+pp)
              " call forms#SetCharAt(' ', line, column+pp+1)
              call forms#SetHCharsAt(' ', (size-pp-1), line, column+pp+1)

            endif
          else
" call forms#log("g:forms#HSlider.draw D")
            if pp > 0
              call forms#SetHCharsAt(' ', (pp), line, column)
            endif
            let righthalf = b:forms_RightHalfB
            let lefthalf = b:forms_LeftHalfB
            call forms#SetCharAt(righthalf, line, column+pp)
            call forms#SetCharAt(lefthalf, line, column+pp+1)
            if size-pp-2 > 0
              call forms#SetHCharsAt(' ', (size-pp-2), line, column+pp+2)
            endif
          endif

        elseif resolution == 3
          let el_per_cell = 4
          let nosoffsets = el_per_cell * (size-1) + 1
          let value = self.__value
          let [lower, upper] = self.__range
          let offset = value * nosoffsets/(upper-lower+1)
          let p = (offset/el_per_cell) * el_per_cell
          let i = offset - p
" call forms#log("g:forms#HSlider.draw nosoffsets=" .  nosoffsets)
" call forms#log("g:forms#HSlider.draw value=" .  value)
" call forms#log("g:forms#HSlider.draw offset=" .  offset)
" call forms#log("g:forms#HSlider.draw p=" .  p)
" call forms#log("g:forms#HSlider.draw i=" .  i)
          let pp = p / el_per_cell
" call forms#log("g:forms#HSlider.draw pp=" .  pp)

          if pp == size-1
" call forms#log("g:forms#HSlider.draw END")
            call ReverseClear(self)
            if exists("self.__reverse")
              unlet self.__reverse
            endif
            call forms#SetHCharsAt(' ', (size-1), line, column)
            call forms#SetCharAt(full, line, column+size-1)
          else
            if i == 0
" call forms#log("g:forms#HSlider.draw FULL")
              call ReverseClear(self)
              if exists("self.__reverse")
                unlet self.__reverse
              endif
              if pp > 0
                call forms#SetHCharsAt(' ', (pp), line, column)
              endif
              call forms#SetCharAt(full, line, column+pp)
              if size-pp-1 > 0
                call forms#SetHCharsAt(' ', (size-pp-1), line, column+pp+1)
              endif

            else
              if i == 1
" call forms#log("g:forms#HSlider.draw 1/4")
                " let b:forms_LeftOneQuarterB = '▎'
                let chr = b:forms_LeftOneQuarterB
              elseif i == 2
" call forms#log("g:forms#HSlider.draw 1/2")
                " let b:forms_LeftHalfB  = '▌'
                let chr = b:forms_LeftHalfB
              elseif i == 3
" call forms#log("g:forms#HSlider.draw 3/4")
                " let b:forms_LeftThreeQuartersB = '▊'
                let chr = b:forms_LeftThreeQuartersB
              else
                throw "HSlider.draw bad inter-character index: " . i
              endif

              if pp > 0
                call forms#SetHCharsAt(' ', (pp), line, column)
              endif
              call forms#SetCharAt(chr, line, column+pp)
              let self.__reverse = column+pp
              if has_focus
                call ReverseHotSpot(line, column+pp)
              else
                call Reverse(self, a.line, self.__reverse)
              endif
              call forms#SetCharAt(chr, line, column+pp+1)
              if size-pp-2 > 0
                call forms#SetHCharsAt(' ', (size-pp-2), line, column+pp+2)
              endif
            endif
          endif
        elseif resolution == 4
          let el_per_cell = 8
          let nosoffsets = el_per_cell * (size-1) + 1
          let value = self.__value
          let [lower, upper] = self.__range
          let offset = value * nosoffsets/(upper-lower+1)
          let p = (offset/el_per_cell) * el_per_cell
          let i = offset - p
" call forms#log("g:forms#HSlider.draw nosoffsets=" .  nosoffsets)
" call forms#log("g:forms#HSlider.draw value=" .  value)
" call forms#log("g:forms#HSlider.draw offset=" .  offset)
" call forms#log("g:forms#HSlider.draw p=" .  p)
" call forms#log("g:forms#HSlider.draw i=" .  i)
          let pp = p / el_per_cell
" call forms#log("g:forms#HSlider.draw pp=" .  pp)

          if pp == size-1
" call forms#log("g:forms#HSlider.draw END")
            call ReverseClear(self)
            if exists("self.__reverse")
              unlet self.__reverse
            endif
            call forms#SetHCharsAt(' ', (size-1), line, column)
            call forms#SetCharAt(full, line, column+size-1)
          else
            if i == 0
" call forms#log("g:forms#HSlider.draw FULL")
              call ReverseClear(self)
              if exists("self.__reverse")
                unlet self.__reverse
              endif
              if pp > 0
                call forms#SetHCharsAt(' ', (pp), line, column)
              endif
              call forms#SetCharAt(full, line, column+pp)
              if size-pp-1 > 0
                call forms#SetHCharsAt(' ', (size-pp-1), line, column+pp+1)
              endif

            else
              if i == 1
" call forms#log("g:forms#HSlider.draw 1/8")
                " let b:forms_LeftOneEighthsB = '▏'
                let chr = b:forms_LeftOneEighthsB
              elseif i == 2
" call forms#log("g:forms#HSlider.draw 1/4")
                " let b:forms_LeftOneQuarterB = '▎'
                let chr = b:forms_LeftOneQuarterB
              elseif i == 3
" call forms#log("g:forms#HSlider.draw 1/2")
                " let b:forms_LeftThreeEighthsB = '▍'
                let chr = b:forms_LeftThreeEighthsB
              elseif i == 4
" call forms#log("g:forms#HSlider.draw 1/2")
                " let b:forms_LeftHalfB  = '▌'
                let chr = b:forms_LeftHalfB
              elseif i == 5
" call forms#log("g:forms#HSlider.draw 5/8")
                " let b:forms_leftFiveEighthsB = '▋'
                let chr = b:forms_leftFiveEighthsB
              elseif i == 6
" call forms#log("g:forms#HSlider.draw 3/4")
                " let b:forms_LeftThreeQuartersB = '▊'
                let chr = b:forms_LeftThreeQuartersB
              elseif i == 7
" call forms#log("g:forms#HSlider.draw 7/8")
                " let b:forms_LeftSevenEighthsB = '▉'
                let chr = b:forms_LeftSevenEighthsB
              else
                throw "HSlider.draw bad inter-character index: " . i
              endif

              if pp > 0
                call forms#SetHCharsAt(' ', (pp), line, column)
              endif
              call forms#SetCharAt(chr, line, column+pp)
              let self.__reverse = column+pp
              if has_focus
                call ReverseHotSpot(line, column+pp)
              else
                call Reverse(self, a.line, self.__reverse)
              endif
              call forms#SetCharAt(chr, line, column+pp+1)
              if size-pp-2 > 0
                call forms#SetHCharsAt(' ', (size-pp-2), line, column+pp+2)
              endif
            endif
          endif
        else
          throw "HSlider.draw: unsupported resolution: " . resolution
        endif

      endif

      if self.__status == g:IS_DISABLED
        call AugmentGlyphHilight(self, "DisableHi", a)
      endif                     
    endfunction
    let g:forms#HSlider.draw = function("FORMS_HSLIDER_draw")

  endif

  return g:forms#HSlider
endfunction
" ------------------------------------------------------------ 
" forms#newHSlider: {{{2
"   Create new HSlider 
"  parameters: 
"   attrs  : attributes for initializing new object
" ------------------------------------------------------------ 
function! forms#newHSlider(attrs)
  return forms#loadHSliderPrototype().clone().init(a:attrs)
endfunction

"---------------------------------------------------------------------------
" VSlider <- Slider: {{{2
"---------------------------------------------------------------------------
" Vertical Slider concrete object of Slider
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms#VSlider")
    unlet g:forms#VSlider
  endif
endif
function! forms#loadVSliderPrototype()
  if !exists("g:forms#VSlider")
    let g:forms#VSlider = forms#loadSliderPrototype().clone('forms#VSlider')

    function! FORMS_VSLIDER_gainFocus() dict
      if (self.__status == g:IS_ENABLED)
" call forms#log("g:forms#VSlider.gainFocus")
        let self.__hasfocus = 1
        let a = self.__allocation
        call HotRegion(a)
        if exists("self.__reverse")
" call forms#log("g:forms#VSlider.gainFocus: DO REVERSE")
          call ReverseHotSpot(self.__reverse, a.column)
        endif
      endif
    endfunction
    let g:forms#VSlider.gainFocus = function("FORMS_VSLIDER_gainFocus")

    function! FORMS_VSLIDER_loseFocus() dict
" call forms#log("g:forms#VSlider.loseFocus")
      call ReverseHotSpotClear()
      if exists("self.__hasfocus")
        unlet self.__hasfocus
      endif
      if exists("self.__reverse")
" call forms#log("g:forms#VSlider.loseFocus: DO REVERSE")
        let a = self.__allocation
        call Reverse(self, self.__reverse, a.column)
      endif
    endfunction
    let g:forms#VSlider.loseFocus = function("FORMS_VSLIDER_loseFocus")

    function! FORMS_VSLIDER_requestedSize() dict
" call forms#log("g:forms#VSlider.requestedSize ")
      if (self.__status == g:IS_INVISIBLE) 
        return [0,0]
      else
        return [1,self.__size]
      endif
    endfunction
    let g:forms#VSlider.requestedSize  = function("FORMS_VSLIDER_requestedSize")

    function! FORMS_VSLIDER_dimension2value(event) dict
      let ln = a:event.line
      let a = self.__allocation
      let line = a.line
      let height = a.height
      let [lower, upper] = self.__range
" call forms#log("g:forms#VSlider.dimension2value: ln=".ln)
" call forms#log("g:forms#VSlider.dimension2value: line=".line)
" call forms#log("g:forms#VSlider.dimension2value: height=".height)

      if ln <= line
        return lower
      elseif ln >= line+height-1
        return upper
      else
        let pos = ln - line
        return lower + ((pos * (upper - lower)) / (height-1))
      endif
    endfunction
    let g:forms#VSlider.dimension2value  = function("FORMS_VSLIDER_dimension2value")

    function! FORMS_VSLIDER_draw(allocation) dict
" call forms#log("g:forms#VSlider.draw" .  string(a:allocation))
      let self.__allocation = a:allocation
      let a = a:allocation

      if self.__status != g:IS_INVISIBLE
        let has_focus = exists("self.__hasfocus")
" call forms#log("g:forms#VSlider.draw has_focus" .   has_focus)
        if has_focus
          call HotRegion(a)
        endif

        let line = a.line
        let column = a.column
        let pos = self.value2pos()
        let size = self.__size
        let resolution = self.__resolution

        let full = b:forms_FullB
" call forms#log("g:forms#VSlider.draw resolution=" .  resolution)

        " nos possible positions = resolution * (size-1) + 1
        if resolution == 1
          if pos == 0
            call forms#SetCharAt(full, line, column)
            call forms#SetVCharsAt(' ', (size-1), line+1, column)
          elseif pos == size-1
            call forms#SetVCharsAt(' ', (size-1), line, column)
            call forms#SetCharAt(full, line+size-1, column)
          else
            call forms#SetVCharsAt(' ', (pos-1), line, column)
            call forms#SetCharAt(full, line+pos, column)
            call forms#SetVCharsAt(' ', (size-pos=1), line+pos+1, column)
          endif

        elseif resolution == 2
          let el_per_cell = 2
          let nosoffsets = el_per_cell * (size-1) + 1
          let value = self.__value
          let [lower, upper] = self.__range
          let offset = value * nosoffsets/(upper-lower+1)
          let p = (offset/el_per_cell) * el_per_cell
          let i = offset - p
" call forms#log("g:forms#VSlider.draw nosoffsets=" .  nosoffsets)
" call forms#log("g:forms#VSlider.draw value=" .  value)
" call forms#log("g:forms#VSlider.draw offset=" .  offset)
" call forms#log("g:forms#VSlider.draw p=" .  p)
" call forms#log("g:forms#VSlider.draw i=" .  i)
          let pp = p / el_per_cell
" call forms#log("g:forms#VSlider.draw pp=" .  pp)

          if i == 0
            if pp == 0
" call forms#log("g:forms#VSlider.draw A")
              call forms#SetCharAt(full, line, column)
              call forms#SetVCharsAt(' ', (size-1), line+1, column)

            elseif pp == size-1
" call forms#log("g:forms#VSlider.draw B")
              call forms#SetVCharsAt(' ', (size-1), line, column)
              call forms#SetCharAt(full, line+size-1, column)

            else
" call forms#log("g:forms#VSlider.draw C")
              call forms#SetVCharsAt(' ', (pp), line, column)
              call forms#SetCharAt(full, line+pp, column)
              call forms#SetVCharsAt(' ', (size-pp-1), line+pp+1, column)

            endif
          else
" call forms#log("g:forms#VSlider.draw D")
            if pp > 0
              call forms#SetVCharsAt(' ', (pp), line, column)
            endif
            let lowerhalf = b:forms_LowerHalfB
            let upperhalf = b:forms_UpperHalfB
            call forms#SetCharAt(lowerhalf, line+pp, column)
            call forms#SetCharAt(upperhalf, line+pp+1, column)
            if size-pp-2 > 0
              call forms#SetVCharsAt(' ', (size-pp-2), line+pp+2, column)
            endif
          endif

        elseif resolution == 3
          let el_per_cell = 4
          let nosoffsets = el_per_cell * (size-1) + 1
          let value = self.__value
          let [lower, upper] = self.__range
          let offset = value * nosoffsets/(upper-lower+1)
          let p = (offset/el_per_cell) * el_per_cell
          let i = offset - p
" call forms#log("g:forms#VSlider.draw nosoffsets=" .  nosoffsets)
" call forms#log("g:forms#VSlider.draw value=" .  value)
" call forms#log("g:forms#VSlider.draw offset=" .  offset)
" call forms#log("g:forms#VSlider.draw p=" .  p)
" call forms#log("g:forms#VSlider.draw i=" .  i)
          let pp = p / el_per_cell
" call forms#log("g:forms#VSlider.draw pp=" .  pp)

          if pp == size-1
" call forms#log("g:forms#VSlider.draw END")
            call ReverseClear(self)
            if exists("self.__reverse")
              unlet self.__reverse
            endif
            call forms#SetVCharsAt(' ', (size-1), line, column)
            call forms#SetCharAt(full, line+size-1, column)
          else
            if i == 0
" call forms#log("g:forms#VSlider.draw FULL")
              call ReverseClear(self)
              if exists("self.__reverse")
                unlet self.__reverse
              endif
              if pp > 0
                call forms#SetVCharsAt(' ', (pp), line, column)
              endif
              call forms#SetCharAt(full, line+pp, column)
              if size-pp-1 > 0
                call forms#SetVCharsAt(' ', (size-pp-1), line+pp+1, column)
              endif

            else
              if i == 1
" call forms#log("g:forms#VSlider.draw 1/4")
                " let b:forms_LowerThreeQuartersB = '▆'
                let chr = b:forms_LowerThreeQuartersB
              elseif i == 2
" call forms#log("g:forms#VSlider.draw 1/2")
                " let b:forms_LowerHalfB = '▄'
                let chr = b:forms_LowerHalfB
              elseif i == 3
" call forms#log("g:forms#VSlider.draw 3/4")
                " let b:forms_LowerOneQuarterB = '▂'
                let chr = b:forms_LowerOneQuarterB
              else
                throw "VSlider.draw bad inter-character index: " . i
              endif

              if pp > 0
                call forms#SetVCharsAt(' ', (pp), line, column)
              endif
              call forms#SetCharAt(chr, line+pp, column)
              call forms#SetCharAt(chr, line+pp+1, column)
              let self.__reverse = line+pp+1
              if has_focus
                call ReverseHotSpot(line+pp+1, column)
              else
                call Reverse(self, self.__reverse, a.column)
              endif
              if size-pp-2 > 0
                call forms#SetVCharsAt(' ', (size-pp-2), line+pp+2, column)
              endif
            endif
          endif
        elseif resolution == 4
          let el_per_cell = 8
          let nosoffsets = el_per_cell * (size-1) + 1
          let value = self.__value
          let [lower, upper] = self.__range
          let offset = value * nosoffsets/(upper-lower+1)
          let p = (offset/el_per_cell) * el_per_cell
          let i = offset - p
" call forms#log("g:forms#VSlider.draw nosoffsets=" .  nosoffsets)
" call forms#log("g:forms#VSlider.draw value=" .  value)
" call forms#log("g:forms#VSlider.draw offset=" .  offset)
" call forms#log("g:forms#VSlider.draw p=" .  p)
" call forms#log("g:forms#VSlider.draw i=" .  i)
          let pp = p / el_per_cell
" call forms#log("g:forms#VSlider.draw pp=" .  pp)

          if pp == size-1
" call forms#log("g:forms#VSlider.draw END")
            call ReverseClear(self)
            if exists("self.__reverse")
              unlet self.__reverse
            endif
            call forms#SetVCharsAt(' ', (size-1), line, column)
            call forms#SetCharAt(full, line+size-1, column)
          else
            if i == 0
" call forms#log("g:forms#VSlider.draw FULL")
              call ReverseClear(self)
              if exists("self.__reverse")
                unlet self.__reverse
              endif
              if pp > 0
                call forms#SetVCharsAt(' ', (pp), line, column)
              endif
              call forms#SetCharAt(full, line+pp, column)
              if size-pp-1 > 0
                call forms#SetVCharsAt(' ', (size-pp-1), line+pp+1, column)
              endif

            else
              if i == 1
" call forms#log("g:forms#VSlider.draw 1/8")
                " let b:forms_LowerSevenEighthsB = '▇'
                let chr = b:forms_LowerSevenEighthsB
              elseif i == 2
" call forms#log("g:forms#VSlider.draw 1/4")
                " let b:forms_LowerThreeQuartersB = '▆'
                let chr = b:forms_LowerThreeQuartersB
              elseif i == 3
" call forms#log("g:forms#VSlider.draw 1/2")
                " let b:forms_LowerFiveEighthsB = '▅'
                let chr = b:forms_LowerFiveEighthsB
              elseif i == 4
" call forms#log("g:forms#VSlider.draw 1/2")
                " let b:forms_LowerHalfB = '▄'
                let chr = b:forms_LowerHalfB
              elseif i == 5
" call forms#log("g:forms#VSlider.draw 5/8")
                " let b:forms_LowerThreeEighthsB = '▃'
                let chr = b:forms_LowerThreeEighthsB
              elseif i == 6
" call forms#log("g:forms#VSlider.draw 3/4")
                " let b:forms_LowerOneQuarterB = '▂'
                let chr = b:forms_LowerOneQuarterB
              elseif i == 7
" call forms#log("g:forms#VSlider.draw 7/8")
                " let b:forms_LowerOneEighthB = '▁'
                let chr = b:forms_LowerOneEighthB
              else
                throw "VSlider.draw bad inter-character index: " . i
              endif

              if pp > 0
                call forms#SetVCharsAt(' ', (pp), line, column)
              endif
              call forms#SetCharAt(chr, line+pp, column)
              call forms#SetCharAt(chr, line+pp+1, column)
              let self.__reverse = line+pp+1
              if has_focus
                call ReverseHotSpot(line+pp+1, column)
              else
                call Reverse(self, self.__reverse, a.column)
              endif
              if size-pp-2 > 0
                call forms#SetVCharsAt(' ', (size-pp-2), line+pp+2, column)
              endif
            endif
          endif
        else
          throw "VSlider.draw: unsupported resolution: " . resolution
        endif

      endif

      if self.__status == g:IS_DISABLED
        call AugmentGlyphHilight(self, "DisableHi", a)
      endif                     
    endfunction
    let g:forms#VSlider.draw  = function("FORMS_VSLIDER_draw")
  endif

  return g:forms#VSlider
endfunction
" ------------------------------------------------------------ 
" forms#newVSlider: {{{2
"   Create new VSlider 
"  parameters: 
"   attrs  : attributes for initializing new object
" ------------------------------------------------------------ 
function! forms#newVSlider(attrs)
  return forms#loadVSliderPrototype().clone().init(a:attrs)
endfunction

"-------------------------------------------------------------------------------
" Mono Prototype: {{{1
"------------------------------------------------------------------------------1
" Mono <- Glyph: {{{2
"   Abstract glyph object for all glyphs that have single child.
"
" attributes
"   body     : single child of Mono glyph
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms#Mono")
    unlet g:forms#Mono
  endif
endif
function! forms#loadMonoPrototype()
  if !exists("g:forms#Mono")
    let g:forms#Mono = forms#loadGlyphPrototype().clone('forms#Mono')
    let g:forms#Mono.__body = g:forms_Util.nullGlyph()

    function! FORMS_MONO_nodeType() dict
      return g:MONO_NODE
    endfunction
    let g:forms#Mono.nodeType  = function("FORMS_MONO_nodeType")

    function! FORMS_MONO_reinit(attrs) dict
" call forms#log("g:forms#Mono.reinit TOP")

      let oldBodyId = self.__body._id

      let self.__body = g:forms_Util.nullGlyph()

      call call(g:forms#Glyph.reinit, [a:attrs], self)

      if oldBodyId != self.__body._id
        call forms#PrependUniqueInput({'type': 'ReSize'})
      else
        call forms#ViewerRedrawListAdd(self) 
      endif
    endfunction
    let g:forms#Mono.reinit  = function("FORMS_MONO_reinit")

    function! FORMS_MONO_delete(...) dict
" call forms#log("Mono.delete: TOP")
      if has_key(self.__body, 'delete')
        call self.__body.delete()
      endif

      let p = g:forms#Mono._prototype
      call call(p.delete, [p], self)
" call forms#log("Mono.delete: BOTTOM")
    endfunction
    let g:forms#Mono.delete  = function("FORMS_MONO_delete")

    function! FORMS_MONO_requestedSize() dict
      if (self.__status == g:IS_INVISIBLE) 
        return [0,0]
      else
        let [w,h] = self.__body.requestedSize()
" call forms#log("Mono.requestedSize: " . string([w,h]))
        return [w,h]
      endif
    endfunction
    let g:forms#Mono.requestedSize  = function("FORMS_MONO_requestedSize")

    function! FORMS_MONO_hide() dict
      call self.__body.hide()
    endfunction
    let g:forms#Mono.hide  = function("FORMS_MONO_hide")

    "-----------------------------------------------
    " mono methods
    "-----------------------------------------------
    " DEPRECATED
    function! FORMS_MONO_setBody(body) dict
      let self.__body = a:body
    endfunction
    let g:forms#Mono.setBody  = function("FORMS_MONO_setBody")

    function! FORMS_MONO_getBody() dict
      return self.__body
    endfunction
    let g:forms#Mono.getBody  = function("FORMS_MONO_getBody")

  endif

  return g:forms#Mono
endfunction

"---------------------------------------------------------------------------
" Box <- Mono: {{{2
"---------------------------------------------------------------------------
" A box object supports both standard box drawing character sets as well
"   a format for specifying the eight characters that make up the corners
"   and sides of a box.
"
"   Ths standard box "modes", character sets are:
"                         dr  uh  dl  rv  ul  lh  ur  lv
"    default: (ascii)     '+' '-' '+' '|' '+' '-' '+' '|'
"    light:  (utf-8)      '┌' '─' '┐' '│' '┘' '─' '└' '│'
"    heavy:  (utf-8)      '┏' '━' '┓' '┃' '┛' '━' '┗' '┃' 
"    double: (utf-8)      '╔' '═' '╗' '║' '╝' '═' '╚' '║'
"    light_arc:  (utf-8)  '╭' '─' '╮' '│' '╯' '─' '╰' '│'
"
"    as well as these additional ones: 
"       light_double_dash light_double_dash_arc heavy_double_dash
"       light_triple_dash light_triple_dash_arc heavy_triple_dash
"       light_quadruple_dash light_quadruple_dash_arc heavy_quadruple_dash
"       block semi_block triangle_block
"
"   Also, each corner and edge can be specifically specified
"     as a list of 8 charcters in this order:
"       down-right, upper-horizontal, down-left, right-vertial
"       up-left, lower-horizontal, up-right, left-vertial
"
" attributes
"   mode     : one of the box drawing modes listed above
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms#Box")
    unlet g:forms#Box
  endif
endif
function! forms#loadBoxPrototype()
  if !exists("g:forms#Box")
    let g:forms#Box = forms#loadMonoPrototype().clone('forms#Box')
    let g:forms#Box.__mode = (&encoding == 'utf-8') ? 'light' : 'default'

    function! FORMS_BOX_init(attrs) dict
"call forms#log("forms#Box.init TOP")
      call call(g:forms#Mono.init, [a:attrs], self)

      return self
    endfunction
    let g:forms#Box.init  = function("FORMS_BOX_init")

    function! FORMS_BOX_reinit(attrs) dict
"call forms#log("g:forms#Box.reinit TOP")
      let oldMode = self.__mode

      let self.__mode = (&encoding == 'utf-8') ? 'light' : 'default'

      call call(g:forms#Mono.reinit, [a:attrs], self)

      if oldMode != self.__mode
        call forms#ViewerRedrawListAdd(self) 
      endif
    endfunction
    let g:forms#Box.reinit  = function("FORMS_BOX_reinit")

    function! FORMS_BOX_requestedSize() dict
"call forms#log("Box.requestedSize: TOP")
      if (self.__status == g:IS_INVISIBLE) 
        return [0,0]
      else
        let [w,h] = self.__body.requestedSize()
        let m = 2
" call forms#log("Box.requestedSize: " . string([m+w,m+h]))
        return [m + w, m + h]
      endif
    endfunction
    let g:forms#Box.requestedSize  = function("FORMS_BOX_requestedSize")

    function! FORMS_BOX_draw(allocation) dict
"call forms#log("g:forms#Box.draw" .  string(a:allocation))
      " [line, column, width, height]
      let self.__allocation = a:allocation
      let a = a:allocation

      if self.__status != g:IS_INVISIBLE
        let m = 1

        call forms#DrawBox(self.__mode, a.line, a.column, a.width, a.height)

"  call forms#log("g:forms#Box.draw calling body")
        " draw body
        call self.__body.draw({
                            \ 'line': a.line+m,
                            \ 'column': a.column+m,
                            \ 'width': a.width-m-m,
                            \ 'height': a.height-m-m
                            \ })
      endif
      if self.__status == g:IS_DISABLED
        call AugmentGlyphHilight(self, "DisableHi", a)
      endif                     

    endfunction
    let g:forms#Box.draw  = function("FORMS_BOX_draw")

  endif

  return g:forms#Box
endfunction
" ------------------------------------------------------------ 
" forms#newBox: {{{2
"   Create new TextBox 
"  parameters: 
"   attrs  : attributes for initializing new object
" ------------------------------------------------------------ 
function! forms#newBox(attrs)
  return forms#loadBoxPrototype().clone().init(a:attrs)
endfunction

"---------------------------------------------------------------------------
" Border <- Mono: {{{2
"---------------------------------------------------------------------------
" Draw a border around child glyph
"
" attributes
"   size     : size (>=1) of border
"   char     : optional character to use to draw border
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms#Border")
    unlet g:forms#Border
  endif
endif
function! forms#loadBorderPrototype()
  if !exists("g:forms#Border")
    let g:forms#Border = forms#loadMonoPrototype().clone('forms#Border')
    let g:forms#Border.__char = ''
    let g:forms#Border.__size = 1

    function! FORMS_BORDER_init(attrs) dict
"call forms#log("forms#Border.init TOP self.__size=" .  self.__size)
      call call(g:forms#Mono.init, [a:attrs], self)
"call forms#log("forms#Border.init BOTTOM self.__size=" .  self.__size)
      if self.__size < 1 
        throw "Border: size < 1: " . self.__size
      endif
      if self.__char != ''
        let len = strchars(self.__char)
        if len != 1
          throw "Border.init: char ".self.__char." not of length 1; " . len
        endif
      endif

      return self
    endfunction
    let g:forms#Border.init  = function("FORMS_BORDER_init")

    function! FORMS_BORDER_reinit(attrs) dict
"call forms#log("g:forms#Border.reinit TOP")
      let oldSize = self.__size

      let self.__char = ''
      let self.__size = 1

      call call(g:forms#Mono.reinit, [a:attrs], self)

      if oldSize != self.__size
        call forms#PrependUniqueInput({'type': 'ReSize'})
      else
        call forms#ViewerRedrawListAdd(self) 
      endif
    endfunction
    let g:forms#Border.reinit  = function("FORMS_BORDER_reinit")

    function! FORMS_BORDER_requestedSize() dict
"call forms#log("Border.requestedSize: TOP")
      if (self.__status == g:IS_INVISIBLE) 
        return [0,0]
      else
        let [w,h] = self.__body.requestedSize()
        let m = 2 * self.__size
" call forms#log("Border.requestedSize: " . string([m+w,m+h]))
        return [m + w, m + h]
      endif
    endfunction
    let g:forms#Border.requestedSize  = function("FORMS_BORDER_requestedSize")

    function! FORMS_BORDER_draw(allocation) dict
" call forms#log("g:forms#Border.draw" .  string(a:allocation))
      let self.__allocation = a:allocation
      let a = a:allocation

      if self.__status != g:IS_INVISIBLE
        let m = self.__size
        let char = self.__char

        if char != ''
" call forms#log("g:forms#Border.draw do border")
          if !  forms#existsBoxDrawingCharacterSet(char)
            call forms#addBoxDrawingCharacter(char)
          endif

          let cnt = 0
          while cnt < m
            call forms#DrawBox(char, 
                               \ a.line+cnt, 
                               \ a.column+cnt, 
                               \ a.width-2*cnt, 
                               \ a.height-2*cnt)
            let cnt += 1
          endwhile
        endif

"call forms#log("g:forms#Border.draw calling body")
        " draw body
        call self.__body.draw({
                            \ 'line': a.line+m,
                            \ 'column': a.column+m,
                            \ 'width': a.width-m-m,
                            \ 'height': a.height-m-m
                            \ })
      endif
      if self.__status == g:IS_DISABLED
        call AugmentGlyphHilight(self, "DisableHi", a)
      endif                     

    endfunction
    let g:forms#Border.draw  = function("FORMS_BORDER_draw")

  endif

  return g:forms#Border
endfunction
" ------------------------------------------------------------ 
" forms#newBorder: {{{2
"   Create new Border 
"  parameters: 
"   attrs  : attributes for initializing new object
" ------------------------------------------------------------ 
function! forms#newBorder(attrs)
  return forms#loadBorderPrototype().clone().init(a:attrs)
endfunction

"---------------------------------------------------------------------------
" DropShadow <- Mono: {{{2
"---------------------------------------------------------------------------
" Draw a drop shadow around child glyph
"
" attributes
"   corner     : name of corner of drop shadow
"                 'ul' (upper left)
"                 'ur' (upper right)
"                 'll' (lower left)
"                 'lr' (lower right) (default)
"   highlight  : optional name of highlight group to use.
"                   (default "DropShadowHi")
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms#DropShadow")
    unlet g:forms#DropShadow
  endif
endif
function! forms#loadDropShadowPrototype()
  if !exists("g:forms#DropShadow")
    let g:forms#DropShadow = forms#loadMonoPrototype().clone('forms#DropShadow')
    let g:forms#DropShadow.__corner = 'lr'
    let g:forms#DropShadow.__highlight = 'DropShadowHi'

    function! FORMS_DROP_SHADOW_init(attrs) dict
      call call(g:forms#Mono.init, [a:attrs], self)

      let c = self.__corner
      if c != 'ul' && c != 'ur' && c != 'll' && c != 'lr'
        throw "DropShadow.init: Bad corner value= ".string(c)
      endif
      let hi = self.__highlight
      if exists(hi) != 0
        throw "DropShadow.init: Bad highlight group name: ".string(hi)
      endif

      return self
    endfunction
    let g:forms#DropShadow.init  = function("FORMS_DROP_SHADOW_init")

    function! FORMS_DROP_SHADOW_reinit(attrs) dict
"call forms#log("g:forms#DropShadow.reinit TOP")
      let oldCorner = self.__corner

      let self.__corner = 'lr'
      let self.__highlight = 'DropShadowHi'

      call call(g:forms#Mono.reinit, [a:attrs], self)

      if oldCorner != self.__corner
        call forms#ViewerRedrawListAdd(self) 
      endif
    endfunction
    let g:forms#DropShadow.reinit  = function("FORMS_DROP_SHADOW_reinit")

    function! FORMS_DROP_SHADOW_requestedSize() dict
"call forms#log("DropShadow.requestedSize: TOP")
      if (self.__status == g:IS_INVISIBLE) 
        return [0,0]
      else
        let [w,h] = self.__body.requestedSize()
        return [w+1, h+1]
      endif
    endfunction
    let g:forms#DropShadow.requestedSize  = function("FORMS_DROP_SHADOW_requestedSize")

    function! FORMS_DROP_SHADOW_draw(allocation) dict
" call forms#log("g:forms#DropShadow.draw" .  string(a:allocation))
      let self.__allocation = a:allocation
      let a = a:allocation

      if self.__status != g:IS_INVISIBLE
        let line = a.line
        let column = a.column
        let width = a.width
        let height = a.height
        let c = self.__corner
        let hi = self.__highlight


        call forms#DrawDropShadow(c, line, column, width-1, height-1)

        if c == 'ul'
          call GlyphHilight(self, hi, {
                                       \ 'line': line,
                                       \ 'column': column,
                                       \ 'width': width,
                                       \ 'height': 1
                                       \ })
          call AugmentGlyphHilight(self, hi, {
                                       \ 'line': line,
                                       \ 'column': column,
                                       \ 'width': 1,
                                       \ 'height': height
                                       \ })
          let line += 1
          let column += 1

        elseif c == 'ur'
          call GlyphHilight(self, hi, {
                                       \ 'line': line,
                                       \ 'column': column,
                                       \ 'width': width,
                                       \ 'height': 1
                                       \ })
        call AugmentGlyphHilight(self, hi, {
                                       \ 'line': line,
                                       \ 'column': column+width-1,
                                       \ 'width': 1,
                                       \ 'height': height
                                       \ })
          let line += 1

        elseif c == 'll'
        call GlyphHilight(self, hi, {
                                       \ 'line': line,
                                       \ 'column': column,
                                       \ 'width': 1,
                                       \ 'height': height
                                       \ })
        call AugmentGlyphHilight(self, hi, {
                                       \ 'line': line+height-1,
                                       \ 'column': column,
                                       \ 'width': width,
                                       \ 'height': 1
                                       \ })
          let column += 1

        elseif c == 'lr'
        call GlyphHilight(self, hi, {
                                       \ 'line': line,
                                       \ 'column': column+width-1,
                                       \ 'width': 1,
                                       \ 'height': height
                                       \ })
        call AugmentGlyphHilight(self, hi, {
                                       \ 'line': line+height-1,
                                       \ 'column': column,
                                       \ 'width': width,
                                       \ 'height': 1
                                       \ })
          " no adjustment
          
        else
          throw "DropShadow.draw: Bad corner value= ".string(c)
        endif

        " draw body
        call self.__body.draw({
                            \ 'line': line,
                            \ 'column': column,
                            \ 'width': width-1,
                            \ 'height': height-1
                            \ })
      endif
      if self.__status == g:IS_DISABLED
        call AugmentGlyphHilight(self, "DisableHi", a)
      endif                     

    endfunction
    let g:forms#DropShadow.draw  = function("FORMS_DROP_SHADOW_draw")

  endif

  return g:forms#DropShadow
endfunction
" ------------------------------------------------------------ 
" forms#newDropShadow: {{{2
"   Create new DropShadow 
"  parameters: 
"   attrs  : attributes for initializing new object
" ------------------------------------------------------------ 
function! forms#newDropShadow(attrs)
  return forms#loadDropShadowPrototype().clone().init(a:attrs)
endfunction

"---------------------------------------------------------------------------
" Frame <- Mono: {{{2
"---------------------------------------------------------------------------
" Draw a frame around child glyph
"
" attributes
"   corner     : name of corner of drop shadow
"                 'ul' (upper left)
"                 'ur' (upper right)
"                 'll' (lower left)
"                 'lr' (lower right) (default)
"   highlight  : optional name of highlight group to use.
"                   (default "FrameHi")
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms#Frame")
    unlet g:forms#Frame
  endif
endif
function! forms#loadFramePrototype()
  if !exists("g:forms#Frame")
    let g:forms#Frame = forms#loadMonoPrototype().clone('forms#Frame')
    let g:forms#Frame.__corner = 'lr'
    let g:forms#Frame.__set = 'outset'
    let g:forms#Frame.__highlight = 'FrameHi'

    function! FORMS_FRAME_init(attrs) dict
      call call(g:forms#Mono.init, [a:attrs], self)

      let c = self.__corner
      if c != 'ul' && c != 'ur' && c != 'll' && c != 'lr'
        throw "Frame.init: Bad corner value= ".string(c)
      endif
      let hi = self.__highlight
      if exists(hi) != 0
        throw "Frame.init: Bad highlight group name: ".string(hi)
      endif

      return self
    endfunction
    let g:forms#Frame.init  = function("FORMS_FRAME_init")

    function! FORMS_FRAME_reinit(attrs) dict
"call forms#log("g:forms#Frame.reinit TOP")
      let oldCorner = self.__corner
      let oldSet = self.__set

      let self.__corner = 'lr'
      let self.__set = 'outset'
      let self.__highlight = 'FrameHi'

      call call(g:forms#Mono.reinit, [a:attrs], self)

      if oldCorner != self.__corner
        call forms#ViewerRedrawListAdd(self) 
      elseif oldSet != self.__set
        call forms#ViewerRedrawListAdd(self) 
      endif
    endfunction
    let g:forms#Frame.reinit  = function("FORMS_FRAME_reinit")

    function! FORMS_FRAME_requestedSize() dict
"call forms#log("Frame.requestedSize: TOP")
      if (self.__status == g:IS_INVISIBLE) 
        return [0,0]
      else
        let [w,h] = self.__body.requestedSize()
" call forms#log("g:forms#Frame.requestedSize: ".string([w+2, h+2]))
        return [w+2, h+2]
      endif
    endfunction
    let g:forms#Frame.requestedSize  = function("FORMS_FRAME_requestedSize")

    function! FORMS_FRAME_draw(allocation) dict
" call forms#log("g:forms#Frame.draw" .  string(a:allocation))
      let self.__allocation = a:allocation
      let a = a:allocation

      if self.__status != g:IS_INVISIBLE
        let line = a.line
        let column = a.column
        let width = a.width
        let height = a.height
        let c = self.__corner
        let hi = self.__highlight
"call forms#log("g:forms#Frame.draw c=".c)

        call forms#DrawFrame(c, line, column, width, height)

        call GlyphHilight(self, hi, {
                                       \ 'line': line,
                                       \ 'column': column,
                                       \ 'width': width,
                                       \ 'height': 1
                                       \ })
        call AugmentGlyphHilight(self, hi, {
                                       \ 'line': line,
                                       \ 'column': column,
                                       \ 'width': 1,
                                       \ 'height': height
                                       \ })
        call AugmentGlyphHilight(self, hi, {
                                       \ 'line': line+height-1,
                                       \ 'column': column,
                                       \ 'width': width,
                                       \ 'height': 1
                                       \ })
        call AugmentGlyphHilight(self, hi, {
                                       \ 'line': line,
                                       \ 'column': column+width-1,
                                       \ 'width': 1,
                                       \ 'height': height
                                       \ })
        let line += 1
        let column += 1

        " draw body
        call self.__body.draw({
                            \ 'line': line,
                            \ 'column': column,
                            \ 'width': width-2,
                            \ 'height': height-2
                            \ })
      endif
      if self.__status == g:IS_DISABLED
        call AugmentGlyphHilight(self, "DisableHi", a)
      endif                     

    endfunction
    let g:forms#Frame.draw  = function("FORMS_FRAME_draw")

  endif

  return g:forms#Frame
endfunction
" ------------------------------------------------------------ 
" forms#newFrame: {{{2
"   Create new Frame 
"  parameters: 
"   attrs  : attributes for initializing new object
" ------------------------------------------------------------ 
function! forms#newFrame(attrs)
  return forms#loadFramePrototype().clone().init(a:attrs)
endfunction

"---------------------------------------------------------------------------
" Background <- Mono: {{{2
"---------------------------------------------------------------------------
" Draw a background over which children glyphs will be drawn
"
" attributes
"   char     : character to use to draw border (default ' ')
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms#Background")
    unlet g:forms#Background
  endif
endif
function! forms#loadBackgroundPrototype()
  if !exists("g:forms#Background")
    let g:forms#Background = forms#loadMonoPrototype().clone('forms#Background')
    let g:forms#Background.__char = ' '

    function! FORMS_BACKGROUND_init(attrs) dict
"call forms#log("forms#Background.init TOP")
"call forms#log("forms#Background.init attrs=" . string(a:attrs))
      call call(g:forms#Mono.init, [a:attrs], self)

      if self.__char != ''
        let len = strchars(self.__char)
        if len != 1
          throw "Background.init: char ".self.__char." not of length 1; " . len
        endif
      endif

      return self
    endfunction
    let g:forms#Background.init  = function("FORMS_BACKGROUND_init")

    function! FORMS_BACKGROUND_reinit(attrs) dict
"call forms#log("g:forms#Background.reinit TOP")
      let oldChar = self.__char

      let self.__char = ' '

      call call(g:forms#Mono.reinit, [a:attrs], self)

      if oldChar != self.__char
        call forms#ViewerRedrawListAdd(self) 
      endif
    endfunction
    let g:forms#Background.reinit  = function("FORMS_BACKGROUND_reinit")

    function! FORMS_BACKGROUND_requestedSize() dict
" call forms#log("Background.requestedSize: TOP")
      if (self.__status == g:IS_INVISIBLE) 
        return [0,0]
      else
        let [w,h] = self.__body.requestedSize()
"call forms#log("Background.requestedSize: " . string([w,h]))
        return [w,h]
      endif
    endfunction
    let g:forms#Background.requestedSize  = function("FORMS_BACKGROUND_requestedSize")

    function! FORMS_BACKGROUND_draw(allocation) dict
"call forms#log("g:forms#Background.draw" .  string(a:allocation))
      let self.__allocation = a:allocation
      let a = a:allocation

      if self.__status != g:IS_INVISIBLE
        let line = a.line
        let column = a.column
        let width = a.width
        let height = a.height
        let char = self.__char

        if char != ''
          let str = repeat(char, width)
          let cnt = 0
          while cnt < height
            call forms#SetStringAt(str, line+cnt, column)

            let cnt += 1
          endwhile
        endif

        call GlyphHilight(self, "BackgroundHi", a)
        call self.__body.draw(a)
      endif
      if self.__status == g:IS_DISABLED
        call AugmentGlyphHilight(self, "DisableHi", a)
      endif                     

    endfunction
    let g:forms#Background.draw  = function("FORMS_BACKGROUND_draw")
  endif

  return g:forms#Background
endfunction
" ------------------------------------------------------------ 
" forms#newBackground: {{{2
"   Create new Background 
"  parameters: 
"   attrs  : attributes for initializing new object
" ------------------------------------------------------------ 
function! forms#newBackground(attrs)
  return forms#loadBackgroundPrototype().clone().init(a:attrs)
endfunction

"---------------------------------------------------------------------------
" MinWidth <- Mono: {{{2
"---------------------------------------------------------------------------
" Used to override the requestedSize width of child glyph
"     when that width is less than the MinWidth 'width' value.
"
" attributes
"   width    : minimum glyph returned by requestedSize call
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms#MinWidth")
    unlet g:forms#MinWidth
  endif
endif
function! forms#loadMinWidthPrototype()
  if !exists("g:forms#MinWidth")
    let g:forms#MinWidth = forms#loadMonoPrototype().clone('forms#MinWidth')
    let g:forms#MinWidth.__width = -1

    function! FORMS_MIN_WIDTH_reinit(attrs) dict
" call forms#log("g:forms#MinWidth.reinit TOP")
      let oldWidth = self.__width

      let self.__width = -1

      call call(g:forms#Mono.reinit, [a:attrs], self)

      if oldWidth != self.__width
        call forms#PrependUniqueInput({'type': 'ReSize'})
      endif
    endfunction
    let g:forms#MinWidth.reinit  = function("FORMS_MIN_WIDTH_reinit")

    function! FORMS_MIN_WIDTH_requestedSize() dict
      if (self.__status == g:IS_INVISIBLE) 
        return [0,0]
      else
        let w = self.__width
        let [childwidth, childheight] = self.__body.requestedSize()
        if w < childwidth | let w = childwidth | endif
        return [w,childheight]
      endif
    endfunction
    let g:forms#MinWidth.requestedSize  = function("FORMS_MIN_WIDTH_requestedSize")

    function! FORMS_MIN_WIDTH_draw(allocation) dict
" call forms#log("g:forms#MinWidth.draw" .  string(a:allocation))
      let self.__allocation = a:allocation
      let a = a:allocation

      if self.__status != g:IS_INVISIBLE
        call self.__body.draw(a)
      endif
      if self.__status == g:IS_DISABLED
        call AugmentGlyphHilight(self, "DisableHi", a)
      endif                     
    endfunction
    let g:forms#MinWidth.draw  = function("FORMS_MIN_WIDTH_draw")
  endif

  return g:forms#MinWidth
endfunction
" ------------------------------------------------------------ 
" forms#newMinWidth: {{{2
"   Create new MinWidth 
"  parameters: 
"   attrs  : attributes for initializing new object
" ------------------------------------------------------------ 
function! forms#newMinWidth(attrs)
  return forms#loadMinWidthPrototype().clone().init(a:attrs)
endfunction

"---------------------------------------------------------------------------
" MinHeight <- Mono: {{{2
"---------------------------------------------------------------------------
" Used to override the requestedSize height of child glyph
"     when that height is less than the MinWidth 'height' value.
"
" attributes
"   height    : minimum height returned by requestedSize call
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms#MinHeight")
    unlet g:forms#MinHeight
  endif
endif
function! forms#loadMinHeightPrototype()
  if !exists("g:forms#MinHeight")
    let g:forms#MinHeight = forms#loadMonoPrototype().clone('forms#MinHeight')
    let g:forms#MinHeight.__height = -1

    function! FORMS_MIN_HEIGHT_reinit(attrs) dict
" call forms#log("g:forms#MinHeight.reinit TOP")
      let oldHeight = self.__height

      let self.__height = -1

      call call(g:forms#Mono.reinit, [a:attrs], self)

      if oldHeight != self.__height
        call forms#PrependUniqueInput({'type': 'ReSize'})
      endif
    endfunction
    let g:forms#MinHeight.reinit  = function("FORMS_MIN_HEIGHT_reinit")

    function! FORMS_MIN_HEIGHT_requestedSize() dict
      if (self.__status == g:IS_INVISIBLE) 
        return [0,0]
      else
        let h = self.__height
        let [childwidth, childheight] = self.__body.requestedSize()
        if h < childheight | let h = childheight | endif
        return [childwidth, h]
      endif
    endfunction
    let g:forms#MinHeight.requestedSize  = function("FORMS_MIN_HEIGHT_requestedSize")

    function! FORMS_MIN_HEIGHT_draw(allocation) dict
" call forms#log("g:forms#MinHeight.draw" .  string(a:allocation))
      let self.__allocation = a:allocation
      let a = a:allocation

      if self.__status != g:IS_INVISIBLE
        call self.__body.draw(a)
      endif
      if self.__status == g:IS_DISABLED
        call AugmentGlyphHilight(self, "DisableHi", a)
      endif                     
    endfunction
    let g:forms#MinHeight.draw  = function("FORMS_MIN_HEIGHT_draw")
  endif

  return g:forms#MinHeight
endfunction
" ------------------------------------------------------------ 
" forms#newMinHeight: {{{2
"   Create new MinHeight 
"  parameters: 
"   attrs  : attributes for initializing new object
" ------------------------------------------------------------ 
function! forms#newMinHeight(attrs)
  return forms#loadMinHeightPrototype().clone().init(a:attrs)
endfunction

"---------------------------------------------------------------------------
" MinSize <- Mono: {{{2
"---------------------------------------------------------------------------
" Used to override the requestedSize width and height of child glyph
"     when that width/height is less than the 'width'/'height' value.
"
" attributes
"   width     : minimum width returned by requestedSize call
"   height    : minimum height returned by requestedSize call
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms#MinSize")
    unlet g:forms#MinSize
  endif
endif
function! forms#loadMinSizePrototype()
  if !exists("g:forms#MinSize")
    let g:forms#MinSize = forms#loadMonoPrototype().clone('forms#MinSize')
    let g:forms#MinSize.__width = -1
    let g:forms#MinSize.__height = -1

    function! FORMS_MIN_SIZE_reinit(attrs) dict
" call forms#log("g:forms#MinSize.reinit TOP")
      let oldWidth = self.__width
      let oldHeight = self.__height

      let self.__width = -1
      let self.__height = -1

      call call(g:forms#Mono.reinit, [a:attrs], self)

      if oldHeight != self.__height
        call forms#PrependUniqueInput({'type': 'ReSize'})
      else if oldWidth != self.__width
        call forms#PrependUniqueInput({'type': 'ReSize'})
      endif
    endfunction
    let g:forms#MinSize.reinit  = function("FORMS_MIN_SIZE_reinit")

    function! FORMS_MIN_SIZE_requestedSize() dict
      if (self.__status == g:IS_INVISIBLE) 
        return [0,0]
      else
        let w = self.__width
        let h = self.__height
        let [childwidth, childheight] = self.__body.requestedSize()
        if w < childwidth | let w = childwidth | endif
        if h < childheight | let h = childheight | endif
        return [w,h]
      endif
    endfunction
    let g:forms#MinSize.requestedSize  = function("FORMS_MIN_SIZE_requestedSize")

    function! FORMS_MIN_SIZE_draw(allocation) dict
" call forms#log("g:forms#MinSize.draw" .  string(a:allocation))
      let self.__allocation = a:allocation
      let a = a:allocation

      if self.__status != g:IS_INVISIBLE
        call self.__body.draw(a)
      endif
      if self.__status == g:IS_DISABLED
        call AugmentGlyphHilight(self, "DisableHi", a)
      endif                     

    endfunction
    let g:forms#MinSize.draw  = function("FORMS_MIN_SIZE_draw")
  endif

  return g:forms#MinSize
endfunction
" ------------------------------------------------------------ 
" forms#newMinSize: {{{2
"   Create new MinSize 
"  parameters: 
"   attrs  : attributes for initializing new object
" ------------------------------------------------------------ 
function! forms#newMinSize(attrs)
  return forms#loadMinSizePrototype().clone().init(a:attrs)
endfunction

"---------------------------------------------------------------------------
" HAlign <- Mono: {{{2
"---------------------------------------------------------------------------
" Mono that horizontally aligns body
"    float align 0-1 or 'L' 'C' 'R'
"    It is the same width as its body and does no horizontal alignments
"
" attributes
"   width     : minimum width returned by requestedSize call
"   alignment : float align 0-1 or 'L' 'C' 'R' (default 'L')
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms#HAlign")
    unlet g:forms#HAlign
  endif
endif
function! forms#loadHAlignPrototype()
  if !exists("g:forms#HAlign")
    let g:forms#HAlign = forms#loadMonoPrototype().clone('forms#HAlign')
    let g:forms#HAlign.__width = -1
    let g:forms#HAlign.__alignment = 'L'

    function! FORMS_HALIGN_init(attrs) dict
      call call(g:forms#Mono.init, [a:attrs], self)

      call g:forms_Util.checkHAlignment(self.__alignment, "HAlign.init")

      return self
    endfunction
    let g:forms#HAlign.init  = function("FORMS_HALIGN_init")

    function! FORMS_HALIGN_reinit(attrs) dict
" call forms#log("g:forms#HAlign.reinit TOP")
      let oldWidth = self.__width
      let oldAlignment = self.__alignment

      let self.__width = -1
      let self.__alignment =  'L'

      call call(g:forms#Mono.reinit, [a:attrs], self)

      if oldWidth != self.__width
        call forms#PrependUniqueInput({'type': 'ReSize'})
      elseif oldAlignment != self.__alignment
        call forms#ViewerRedrawListAdd(self) 
      endif
    endfunction
    let g:forms#HAlign.reinit  = function("FORMS_HALIGN_reinit")

    function! FORMS_HALIGN_requestedSize() dict
      if (self.__status == g:IS_INVISIBLE) 
        return [0,0]
      else
        let [w,h] = self.__body.requestedSize()
        return (self.__width <= w) ? [w,h] : [self.__width,h]
      endif
    endfunction
    let g:forms#HAlign.requestedSize  = function("FORMS_HALIGN_requestedSize")

    function! FORMS_HALIGN_draw(allocation) dict
" call forms#log("g:forms#HAlign.draw" .  string(a:allocation))
      let self.__allocation = a:allocation
      let a = a:allocation

      if self.__status != g:IS_INVISIBLE
        let line = a.line
        let column = a.column
        let width = a.width
        let alignment = self.__alignment
        let char = ''
        let body = self.__body

        " TODO should child info be cached
        let [childwidth,childheight] = body.requestedSize()
      
        call g:forms_Util.drawHAlign(body, {
                               \ 'line': line,
                               \ 'column': column,
                               \ 'width': width,
                               \ 'childwidth': childwidth,
                               \ 'childheight': childheight
                               \ }, alignment, char)
      endif
      if self.__status == g:IS_DISABLED
        call AugmentGlyphHilight(self, "DisableHi", a)
      endif                     
    endfunction
    let g:forms#HAlign.draw  = function("FORMS_HALIGN_draw")

  endif

  return g:forms#HAlign
endfunction
" ------------------------------------------------------------ 
" forms#newHAlign: {{{2
"   Create new HAlign 
"  parameters: 
"   attrs  : attributes for initializing new object
" ------------------------------------------------------------ 
function! forms#newHAlign(attrs)
  return forms#loadHAlignPrototype().clone().init(a:attrs)
endfunction

"---------------------------------------------------------------------------
" VAlign <- Mono: {{{{{{2
"---------------------------------------------------------------------------
" Mono that vertically aligns body
"    float align 0-1 or 'T' 'C' 'B'
"    It is the same height as its body and does no vertial alignments
"
" attributes
"   height    : minimum height returned by requestedSize call
"   alignment : float align 0-1 or 'T' 'C' 'B' (default 'T')
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms#VAlign")
    unlet g:forms#VAlign
  endif
endif
function! forms#loadVAlignPrototype()
  if !exists("g:forms#VAlign")
    let g:forms#VAlign = forms#loadMonoPrototype().clone('forms#VAlign')
    let g:forms#VAlign.__height = -1
    let g:forms#VAlign.__alignment = 'T'

    function! FORMS_VALIGN_init(attrs) dict
      call call(g:forms#Mono.init, [a:attrs], self)

      call g:forms_Util.checkVAlignment(self.__alignment, "VAlign.init")

      return self
    endfunction
    let g:forms#VAlign.init  = function("FORMS_VALIGN_init")

    function! FORMS_VALIGN_reinit(attrs) dict
" call forms#log("g:forms#VAlign.reinit TOP")
      let oldHeight = self.__height
      let oldAlignment = self.__alignment

      let self.__height = -1
      let self.__alignment =  'T'

      call call(g:forms#Mono.reinit, [a:attrs], self)

      if oldHeight != self.__height
        call forms#PrependUniqueInput({'type': 'ReSize'})
      elseif oldAlignment != self.__alignment
        call forms#ViewerRedrawListAdd(self) 
      endif
    endfunction
    let g:forms#VAlign.reinit  = function("FORMS_VALIGN_reinit")

    function! FORMS_VALIGN_requestedSize() dict
      if (self.__status == g:IS_INVISIBLE) 
        return [0,0]
      else
        let [w,h] = self.__body.requestedSize()
        return (self.__height <= h) ? [w,h] : [w,self.__height]
      endif
    endfunction
    let g:forms#VAlign.requestedSize  = function("FORMS_VALIGN_requestedSize")

    function! FORMS_VALIGN_draw(allocation) dict
" call forms#log("g:forms#VAlign.draw" .  string(a:allocation))
      let self.__allocation = a:allocation
      let a = a:allocation

      if self.__status != g:IS_INVISIBLE
        let line = a.line
        let column = a.column
        let height = a.height
        let alignment = self.__alignment
        let char = ''
        let body = self.__body

        " TODO should child info be cached
        let [childwidth,childheight] = body.requestedSize()

        call g:forms_Util.drawVAlign(body, {
                               \ 'line': line,
                               \ 'column': column,
                               \ 'height': height,
                               \ 'childwidth': childwidth,
                               \ 'childheight': childheight
                               \ }, alignment, char)

      endif
      if self.__status == g:IS_DISABLED
        call AugmentGlyphHilight(self, "DisableHi", a)
      endif                     
    endfunction
    let g:forms#VAlign.draw  = function("FORMS_VALIGN_draw")

  endif

  return g:forms#VAlign
endfunction
" ------------------------------------------------------------ 
" forms#newVAlign: {{{2
"   Create new VAlign 
"  parameters: 
"   attrs  : attributes for initializing new object
" ------------------------------------------------------------ 
function! forms#newVAlign(attrs)
  return forms#loadVAlignPrototype().clone().init(a:attrs)
endfunction

"---------------------------------------------------------------------------
" HVAlign <- Mono: {{{2
"---------------------------------------------------------------------------
" Mono that horizontallly and vertically aligns body
"    horizontal: float align 0-1 or 'L' 'C' 'R'
"    vertical: float align 0-1 or 'T' 'C' 'B'
"    It is the same width as its body and does no horizontal alignments
"    It is the same height as its body and does no vertial alignments
"
" attributes
"   width     : minimum width returned by requestedSize call
"   height    : minimum height returned by requestedSize call
"   halignment : float align 0-1 or 'L' 'C' 'R' (default 'L')
"   valignment : float align 0-1 or 'T' 'C' 'B' (default 'T')
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms#HVAlign")
    unlet g:forms#HVAlign
  endif
endif
function! forms#loadHVAlignPrototype()
  if !exists("g:forms#HVAlign")
    let g:forms#HVAlign = forms#loadMonoPrototype().clone('forms#HVAlign')
    let g:forms#HVAlign.__width = -1
    let g:forms#HVAlign.__halignment = 'L'
    let g:forms#HVAlign.__height = -1
    let g:forms#HVAlign.__valignment = 'T'

    function! FORMS_HVALIGN_init(attrs) dict
" call forms#log("g:forms#HVAlign.init TOP ")
      call call(g:forms#Mono.init, [a:attrs], self)

      call g:forms_Util.checkHAlignment(self.__halignment, "HVAlign.init")
      call g:forms_Util.checkVAlignment(self.__valignment, "HVAlign.init")

" call forms#log("g:forms#HVAlign.init BOTTOM ")
      return self
    endfunction
    let g:forms#HVAlign.init  = function("FORMS_HVALIGN_init")

    function! FORMS_HVALIGN_reinit(attrs) dict
"call forms#log("g:forms#HVAlign.reinit TOP")
      let oldWidth = self.__width
      let oldHeight = self.__height
      let oldHAlignment = self.__halignment
      let oldVAlignment = self.__valignment

      let self.__height = -1
      let self.__valignment =  'T'
      let self.__width = -1
      let self.__halignment =  'L'

      call call(g:forms#Mono.reinit, [a:attrs], self)

      if oldHeight != self.__height
        call forms#PrependUniqueInput({'type': 'ReSize'})
      elseif oldWidth != self.__width
        call forms#PrependUniqueInput({'type': 'ReSize'})
      elseif oldHAlignment != self.__halignment
        call forms#ViewerRedrawListAdd(self) 
      elseif oldVAlignment != self.__valignment
        call forms#ViewerRedrawListAdd(self) 
      endif
    endfunction
    let g:forms#HVAlign.reinit  = function("FORMS_HVALIGN_reinit")

    function! FORMS_HVALIGN_requestedSize() dict
" call forms#log("g:forms#HVAlign.requestedSize TOP ")
      if (self.__status == g:IS_INVISIBLE) 
        return [0,0]
      else
        let [w,h] = self.__body.requestedSize()
        if self.__height > h
          let h = self.__height
        endif
        if self.__width > w
          let w = self.__width
        endif
" call forms#log("g:forms#HVAlign.requestedSize BOTTOM: [w,h]=" . string([w,h]))
        return [w,h]
      endif
    endfunction
    let g:forms#HVAlign.requestedSize  = function("FORMS_HVALIGN_requestedSize")

    function! FORMS_HVALIGN_draw(allocation) dict
" call forms#log("g:forms#HVAlign.draw" .  string(a:allocation))
      let self.__allocation = a:allocation
      let a = a:allocation

      if self.__status != g:IS_INVISIBLE
        let line = a.line
        let column = a.column
        let width = a.width
        let height = a.height
        let halignment = self.__halignment
        let valignment = self.__valignment
        let char = ''
        let body = self.__body

        " TODO should child info be cached
        let [childwidth,childheight] = body.requestedSize()
" call forms#log("g:forms#HVAlign.draw b childwidth=" .  childwidth)
" call forms#log("g:forms#HVAlign.draw b childheight=" .  childheight)

        call g:forms_Util.drawHVAlign(body, {
                               \ 'line': line,
                               \ 'column': column,
                               \ 'width': width,
                               \ 'height': height,
                               \ 'childwidth': childwidth,
                               \ 'childheight': childheight
                               \ }, 
                               \ halignment, 
                               \ valignment, 
                               \ char)
      endif
      if self.__status == g:IS_DISABLED
        call AugmentGlyphHilight(self, "DisableHi", a)
      endif                     

" call forms#log("g:forms#HVAlign.draw BOTTOM ")
    endfunction
    let g:forms#HVAlign.draw  = function("FORMS_HVALIGN_draw")
  endif

  return g:forms#HVAlign
endfunction
" ------------------------------------------------------------ 
" forms#newHVAlign: {{{2
"   Create new HVAlign 
"  parameters: 
"   attrs  : attributes for initializing new object
" ------------------------------------------------------------ 
function! forms#newHVAlign(attrs)
  return forms#loadHVAlignPrototype().clone().init(a:attrs)
endfunction


"---------------------------------------------------------------------------
" Button <- Mono: {{{2
"---------------------------------------------------------------------------
"   Pressing the button results in an action.
"
" attributes
"   highlight : should button be highlighted (default true (1))
"   action    : action object executed on press 
"   command   : Vim command to execute
"
"   If neither action nor command is set, default: noop action
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms#Button")
    unlet g:forms#Button
  endif
endif
function! forms#loadButtonPrototype()
  if !exists("g:forms#Button")
    let g:forms#Button = forms#loadMonoPrototype().clone('forms#Button')
    let g:forms#Button.__selected = 0
    let g:forms#Button.__highlight = 1

    function! FORMS_BUTTON_init(attrs) dict
" call forms#log("g:forms#Button.init TOP ")
      call call(g:forms#Mono.init, [a:attrs], self)

      if exists("a:attrs.action")
"call forms#log("g:forms#Button.init action ")
        let self.__action = a:attrs.action
      elseif exists("a:attrs.command")
"call forms#log("g:forms#Button.init command ")
        let self.__command = a:attrs.command
      else
"call forms#log("g:forms#Button.init default action ")
        let self.__action = g:forms_Util.emptyAction()

        " throw "Button.init: Must have either an action or command attribute: " . string(a:attrs)
      endif

      return self
    endfunction
    let g:forms#Button.init  = function("FORMS_BUTTON_init")

    function! FORMS_BUTTON_reinit(attrs) dict
" call forms#log("g:forms#Botton.reinit TOP")
      if exists("self.__action")
        unlet self.__action
      elseif exists("self.__command")
        unlet self.__command
      endif
      let self.__selected = 0
      let self.__highlight =  1

      call call(g:forms#Mono.reinit, [a:attrs], self)
    endfunction
    let g:forms#Button.reinit  = function("FORMS_BUTTON_reinit")

    function! FORMS_BUTTON_canFocus() dict
      return (self.__status == g:IS_ENABLED)
    endfunction
    let g:forms#Button.canFocus  = function("FORMS_BUTTON_canFocus")

    function! FORMS_BUTTON_hotspot() dict
      if (self.__status == g:IS_ENABLED)
        let a = self.__allocation
        call HotSpot(a.line, a.column)
      endif
    endfunction
    let g:forms#Button.hotspot  = function("FORMS_BUTTON_hotspot")

    function! FORMS_BUTTON_addResults(results) dict
      let tag = self.getTag()
      let a:results[tag] = self.__selected
    endfunction
    let g:forms#Button.addResults  = function("FORMS_BUTTON_addResults")

    function! FORMS_BUTTON_handleEvent(event) dict
" call forms#log("g:forms#Button.handleEvent: " .  string(a:event))
      if (self.__status == g:IS_ENABLED)
        let type = a:event.type
        if type == 'Select'
          call self.doSelect()
          return 1
        endif
      endif
      return 0
    endfunction
    let g:forms#Button.handleEvent  = function("FORMS_BUTTON_handleEvent")

    function! FORMS_BUTTON_handleChar(nr) dict
" call forms#log("g:forms#Button.handleChar: " .  string(a:nr))
      if (self.__status == g:IS_ENABLED)
        let c = nr2char(a:nr)
        if c == "\<CR>" || c == "\<Space>"
          call self.doSelect()
          return 1
        endif
      endif
      return 0
    endfunction
    let g:forms#Button.handleChar  = function("FORMS_BUTTON_handleChar")

    function! FORMS_BUTTON_doSelect() dict
      if (self.__status == g:IS_ENABLED)
        let self.__selected = 1
        call ButtonFlashHi(self.__allocation)
        if exists("self.__action")
          call self.__action.execute(self.__allocation)
          call forms#ViewerRedrawListAdd(self) 
          return 1
        else
" call forms#log("g:forms#Button.doSelect: command=" . self.__command)
          call forms#PrependInput({
                              \ 'type': 'Command',
                              \ 'command': self.__command
                              \ }) 
        endif
      endif
    endfunction
    let g:forms#Button.doSelect  = function("FORMS_BUTTON_doSelect")

    function! FORMS_BUTTON_draw(allocation) dict
" call forms#log("g:forms#Button.draw" .  string(a:allocation))
      let self.__allocation = a:allocation
      let a = a:allocation

      if self.__status != g:IS_INVISIBLE
        call self.__body.draw(a)
        if self.__highlight
          call GlyphHilight(self, "ButtonHi", a)
        endif
      endif
      if self.__status == g:IS_DISABLED
        call AugmentGlyphHilight(self, "DisableHi", a)
      endif                     

    endfunction
    let g:forms#Button.draw  = function("FORMS_BUTTON_draw")

    function! FORMS_BUTTON_usage() dict
      return [
           \ "A Button on selection performs an action or command.",
           \ "  Selection is with keyboard <CR> or <Space>,",
           \ "  or with a mouse <LeftMouse> click.",
           \ "There is no navigation activity.",
           \ ]
    endfunction
    let g:forms#Button.usage  = function("FORMS_BUTTON_usage")
  endif

  return g:forms#Button
endfunction
" ------------------------------------------------------------ 
" forms#newButton: {{{2
"   Create new Button 
"  parameters: 
"   attrs  : attributes for initializing new object
" ------------------------------------------------------------ 
function! forms#newButton(attrs)
  return forms#loadButtonPrototype().clone().init(a:attrs)
endfunction


"---------------------------------------------------------------------------
" ToggleButton <- Mono: {{{2
"---------------------------------------------------------------------------
" Similar to a RadioButton but, as a Mono, has a child glyph used
"     for display 
"
" attributes
"   selected  : optional does button start off being selected
"                           default false (0)
"   group     : optional button group associated with this button
"   on_selection_action   : Action called when choice is selected
"                           default noop action
"   on_deselection_action : Action called when choice is deselected
"                           default noop action
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms#ToggleButton")
    unlet g:forms#ToggleButton
  endif
endif
function! forms#loadToggleButtonPrototype()
  if !exists("g:forms#ToggleButton")
    let g:forms#ToggleButton = forms#loadMonoPrototype().clone('forms#ToggleButton')
    let g:forms#ToggleButton.__selected = 0
    let g:forms#ToggleButton.__on_selection_action = g:forms_Util.emptyAction()
    let g:forms#ToggleButton.__on_deselection_action = g:forms_Util.emptyAction()


    function! FORMS_TOGGLE_BUTTON_init(attrs) dict
"call forms#log("forms#ToggleButton.init TOP")
      call call(g:forms#Leaf.init, [a:attrs], self)

      if has_key(a:attrs, 'group')
        let self['__group'] = a:attrs['group']
"call forms#log("forms#ToggleButton.init attrs has group")
"if has_key(self.__group, 'delete')
"call forms#log("ToggleButton.init: self.__group had delete")
"else
"call forms#log("ToggleButton.init: self.__group not have delete")
"endif
        call self.__group.addMember(self)
      endif
"call forms#log("forms#ToggleButton.init BOTTOM")

      return self
    endfunction
    let g:forms#ToggleButton.init  = function("FORMS_TOGGLE_BUTTON_init")

    function! FORMS_TOGGLE_BUTTON_reinit(attrs) dict
"call forms#log("g:forms#ToggleButton.reinit TOP")
      if exists('self.__group')
        if has_key(self.__group, 'delete')
          call self.__group.delete()
        endif
        unlet self.__group
      endif
      let self.__selected = 0
      let self.__on_selection_action = g:forms_Util.emptyAction()
      let self.__on_deselection_action = g:forms_Util.emptyAction()

      call call(g:forms#Mono.reinit, [a:attrs], self)
    endfunction
    let g:forms#ToggleButton.reinit  = function("FORMS_TOGGLE_BUTTON_reinit")

    function! FORMS_TOGGLE_BUTTON_delete(...) dict
"call forms#log("ToggleButton.delete: TOP")
      if has_key(self, '__group')
        if has_key(self.__group, 'delete')
          call self.__group.delete()
        endif
      endif

      let p = g:forms#ToggleButton._prototype
      call call(p.delete, [p], self)
"call forms#log("ToggleButton.delete: BOTTOM")
    endfunction
    let g:forms#ToggleButton.delete  = function("FORMS_TOGGLE_BUTTON_delete")

    function! FORMS_TOGGLE_BUTTON_canFocus() dict
      return (self.__status == g:IS_ENABLED)
    endfunction
    let g:forms#ToggleButton.canFocus  = function("FORMS_TOGGLE_BUTTON_canFocus")

    function! FORMS_TOGGLE_BUTTON_hotspot() dict
      if (self.__status == g:IS_ENABLED)
        call HotSpot(self.__allocation.line, self.__allocation.column)
      endif
    endfunction
    let g:forms#ToggleButton.hotspot  = function("FORMS_TOGGLE_BUTTON_hotspot")

    function! FORMS_TOGGLE_BUTTON_addResults(results) dict
      let tag = self.getTag()
      let a:results[tag] = self.__selected
    endfunction
    let g:forms#ToggleButton.addResults  = function("FORMS_TOGGLE_BUTTON_addResults")

    function! FORMS_TOGGLE_BUTTON_handleEvent(event) dict
      if (self.__status == g:IS_ENABLED)
        let type = a:event.type
        if type == 'Select'
          if ! has_key(self, '__group')
            let self.__group = forms#newButtonGroup({ 'member_kind': 'forms#ToggleButton'})
            call self.__group.addMember(self)
          endif

          call self.__group.setValues(self)
          return 1
        endif
      endif
      return 0
    endfunction
    let g:forms#ToggleButton.handleEvent  = function("FORMS_TOGGLE_BUTTON_handleEvent")

    function! FORMS_TOGGLE_BUTTON_handleChar(nr) dict
"call forms#log("g:forms#ToggleButton.handleChar: " .  string(a:nr))
      if (self.__status == g:IS_ENABLED)
        let c = nr2char(a:nr)
        if c == "\<CR>" || c == "\<Space>"
          if ! has_key(self, '__group')
  call forms#log("g:forms#ToggleButton.handleChar: make group")
            let self.__group = forms#newButtonGroup({ 'member_kind': 'forms#ToggleButton'})
            call self.__group.addMember(self)
          endif

          call self.__group.setValues(self)
          return 1
        endif
      endif
      return 0
    endfunction
    let g:forms#ToggleButton.handleChar  = function("FORMS_TOGGLE_BUTTON_handleChar")

    function! FORMS_TOGGLE_BUTTON_setValue(value) dict
      let oldvalue = self.__selected
      let self.__selected = a:value
      if oldvalue != a:value
        if a:value
          call self.__on_selection_action.execute()
        else
          call self.__on_deselection_action.execute()
        endif
        call forms#ViewerRedrawListAdd(self) 
      endif
    endfunction
    let g:forms#ToggleButton.setValue  = function("FORMS_TOGGLE_BUTTON_setValue")

    function! FORMS_TOGGLE_BUTTON_getValue() dict
      return self.__selected
    endfunction
    let g:forms#ToggleButton.getValue  = function("FORMS_TOGGLE_BUTTON_getValue")

    " TODO is this method needed/used
    function! FORMS_TOGGLE_BUTTON_selected() dict
"call forms#log("g:forms#ToggleButton.selected")
    endfunction
    let g:forms#ToggleButton.selected  = function("FORMS_TOGGLE_BUTTON_selected")

    function! FORMS_TOGGLE_BUTTON_draw(allocation) dict
" call forms#log("g:forms#ToggleButton.draw" .  string(a:allocation))
      let self.__allocation = a:allocation
      let a = a:allocation

      if self.__status != g:IS_INVISIBLE
        call self.__body.draw(a)

        if self.__selected
          call ButtonGroupAddHi(self.__group, a)
        endif
      endif
      if self.__status == g:IS_DISABLED
        call AugmentGlyphHilight(self, "DisableHi", a)
      endif                     
    endfunction
    let g:forms#ToggleButton.draw  = function("FORMS_TOGGLE_BUTTON_draw")

    function! FORMS_TOGGLE_BUTTON_usage() dict
      return [
           \ "A ToggleButton is similar to a RadioButton. It has two states:",
           \ "  selected or not selected.",
           \ "  ToggleButtons can be standalone or grouped with other.",
           \ "  associated ToggleButtons. ",
           \ "  Only one ToggleButtons in a group can be selected at a time.",
           \ "Selection is with keyboard <CR> or <Space>,",
           \ "  or with a mouse <LeftMouse> click."
           \ ]
    endfunction
    let g:forms#ToggleButton.usage  = function("FORMS_TOGGLE_BUTTON_usage")

  endif

  return g:forms#ToggleButton
endfunction
" ------------------------------------------------------------ 
" forms#newToggleButton: {{{2
"   Create new ToggleButton 
"  parameters: 
"   attrs  : attributes for initializing new object
" ------------------------------------------------------------ 
function! forms#newToggleButton(attrs)
  return forms#loadToggleButtonPrototype().clone().init(a:attrs)
endfunction

"---------------------------------------------------------------------------
" Viewer <- Mono: {{{2
"---------------------------------------------------------------------------
" Runs a input-stream dispatch loop. The <Esc> char always escapes
"     the loop returning the user to a higher level viewer or
"     exiting the form completely.
"
" attributes: NONE
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms#Viewer")
    unlet g:forms#Viewer
  endif
endif
function! forms#loadViewerPrototype()
  if !exists("g:forms#Viewer")
    let g:forms#Viewer = forms#loadMonoPrototype().clone('forms#Viewer')

    function! FORMS_VIEWER_delete(...) dict
" call forms#log("Viewer.delete: TOP")
      let p = g:forms#Viewer._prototype
      call call(p.delete, [p], self)
" call forms#log("Viewer.delete: BOTTOM")
    endfunction
    let g:forms#Viewer.delete  = function("FORMS_VIEWER_delete")

    function! FORMS_VIEWER_canFocus() dict
      return (self.__status == g:IS_ENABLED)
    endfunction
    let g:forms#Viewer.canFocus  = function("FORMS_VIEWER_canFocus")

    function! FORMS_VIEWER_hotspot() dict
      if (self.__status == g:IS_ENABLED)
        let a = self.__allocation
        call HotSpot(a.line, a.column)
      endif
    endfunction
    let g:forms#Viewer.hotspot  = function("FORMS_VIEWER_hotspot")

    function! FORMS_VIEWER_unGetChar(event) dict
      call forms#PrependInput(a:event) 
    endfunction
    let g:forms#Viewer.unGetChar  = function("FORMS_VIEWER_unGetChar")

    function! FORMS_VIEWER_clearInputStream() dict
      call forms#ClearVimInputStream()
    endfunction
    let g:forms#Viewer.clearInputStream  = function("FORMS_VIEWER_clearInputStream")

    function! FORMS_VIEWER_getInput() dict
      return self.mapInput(forms#GetInput())
    endfunction
    let g:forms#Viewer.getInput  = function("FORMS_VIEWER_getInput")

    function! FORMS_VIEWER_mapInput(input) dict 
      if type(a:input) == g:self#DICTIONARY_TYPE | return a:input | endif

      let nr = a:input
      let c = nr2char(nr)

      if c == "\<Tab>" || c ==  "\<C-n>"
        return { 'type': 'NextFocus' }
      elseif c == "\<S-Tab>" || c == "\<C-p>" 
        return { 'type': 'PrevFocus' }
      elseif nr == "\<Home>" 
        return { 'type': 'FirstFocus' }
      elseif nr == "\<End>" 
        return { 'type': 'LastFocus' }
      elseif nr == "\<LeftMouse>" && v:mouse_win > 0
"call forms#log("g:forms#Viewer.mapInput: LeftMouse")
        " execute ":w! SCREEN"
        return { 
              \ 'type': 'NewFocus',
              \ 'line': v:mouse_lnum,
              \ 'column': v:mouse_col
              \ }
      elseif nr == "\<LeftDrag>" && v:mouse_win > 0
        return { 
              \ 'type': 'Drag',
              \ 'line': v:mouse_lnum,
              \ 'column': v:mouse_col
              \ }
      elseif nr == "\<LeftRelease>" && v:mouse_win > 0
        return { 
              \ 'type': 'Release',
              \ 'line': v:mouse_lnum,
              \ 'column': v:mouse_col
              \ }
      elseif nr == "\<2-LeftMouse>" && v:mouse_win > 0
" call forms#log("g:forms#Viewer.mapInput: 2-LeftMouse")
        return { 
              \ 'type': 'SelectDouble',
              \ 'line': v:mouse_lnum,
              \ 'column': v:mouse_col
              \ }
      elseif nr == "\<RightMouse>" && v:mouse_win > 0
        return { 
              \ 'type': 'Context',
              \ 'line': v:mouse_lnum,
              \ 'column': v:mouse_col
              \ }
      elseif c == "\<Esc>" 
        return { 'type': 'Exit' }
      else
        return nr
      endif
    endfunction
    let g:forms#Viewer.mapInput  = function("FORMS_VIEWER_mapInput")

    function! FORMS_VIEWER_handleEvent(event) dict
" call forms#log("g:forms#Viewer.handleEvent: " .  string(a:event))
      if (self.__status == g:IS_ENABLED)
        let type = a:event.type
        if type == 'Select'
          call self.unGetChar({
                          \ 'type': 'NewFocus',
                          \ 'line': a:event.line,
                          \ 'column': a:event.column
                          \ }) 
          call self.run()
          return 1
        elseif type == 'ReDrawAll'
          call self.__body.draw({
                             \ 'line': a.line,
                             \ 'column': a.column,
                             \ 'width': a.width,
                             \ 'height': a.height
                             \ })
          " call focus.hotspot()
          redraw
          return 1
        elseif type == 'ReDraw'
          " call focus.redraw()
          " call focus.hotspot()
          redraw
          return 1
        endif
      endif
      return 0
    endfunction
    let g:forms#Viewer.handleEvent  = function("FORMS_VIEWER_handleEvent")

    function! FORMS_VIEWER_handleChar(nr) dict
" call forms#log("g:forms#Viewer.handleChar: " .  string(a:nr))
      if (self.__status == g:IS_ENABLED)
        let c = nr2char(a:nr)
        if c == "\<CR>" || c == "\<Space>"
          call self.run()
          return 1
        endif
      endif
      return 0
    endfunction
    let g:forms#Viewer.handleChar  = function("FORMS_VIEWER_handleChar")

    function! FORMS_VIEWER_draw(allocation) dict
" call forms#log("g:forms#Viewer.draw" .  string(a:allocation))
      let self.__allocation = a:allocation
      let a = a:allocation

      if self.__status != g:IS_INVISIBLE
        call self.__body.draw(a)
        " call ViewerHilight(self, a)
      endif
      if self.__status == g:IS_DISABLED
        call AugmentGlyphHilight(self, "DisableHi", a)
      endif                     

    endfunction
    let g:forms#Viewer.draw  = function("FORMS_VIEWER_draw")

    function! FORMS_VIEWER_generateResults(glyph, results) dict
      call forms#GenerateResults(a:glyph, a:results)
    endfunction
    let g:forms#Viewer.generateResults  = function("FORMS_VIEWER_generateResults")

    " find all glyphs whose allocation includes the point (line, column)
    function! FORMS_VIEWER_select(glyph, line, column, slist) dict
      call forms#Select(a:glyph, a:line, a:column, a:slist)
    endfunction
    let g:forms#Viewer.select  = function("FORMS_VIEWER_select")

    "-------------------------------------------------------------------
    " Viewer.run
    " return status or nothing
    "   when Viewer is at top of stack, then status: Exit, Cancel or Submit
    "     event is returned
    "   when Viewer is not at top of stack, then nothing is returned
    "-------------------------------------------------------------------
    function! FORMS_VIEWER_run() dict
      let a = self.__allocation

      " Create a list of all glyphs that can have focus. Maybe empty.
      let flist = []
      let fpos = 0
      call forms#GenerateFocusList(self.__body, flist)
" call forms#log("g:forms#Viewer.run len(flist)=".len(flist))
      if len(flist) > 0 
        let focus = flist[fpos] 
        call focus.gainFocus() 
        call focus.hotspot() 
        redraw
      endif

      " inputsave() is called in forms#DoGlyphSelectInfo()
      call inputrestore()
      call self.clearInputStream() 

      call forms#ViewerStackPush(self) 
      try

        " Main REPL (of course, it really does not print)
        while 1
          let input = self.getInput()
" call forms#log("g:forms#Viewer.run input=".string(input))
" call forms#log("g:forms#Viewer.run type(input)=".type(input))

          if type(input) == g:self#DICTIONARY_TYPE
            let event = input
" call forms#log("g:forms#Viewer.run EVENT=".string(event))
            let type = event.type

            if type == 'NextFocus'
" call forms#log("g:forms#Viewer.run NextFocus")
              if exists('focus') 
" call forms#log("g:forms#Viewer.run do NextFocus")
                let newfpos = fpos + 1
                if newfpos == len(flist)
                  let newfpos = 0
                endif
                if newfpos != fpos
                  call focus.loseFocus()
                  let fpos = newfpos 
                  let focus = flist[fpos]
                  call focus.handleEvent(event)
                  call focus.gainFocus() 
                  call focus.hotspot()
                endif

                redraw
              endif

            elseif type == 'PrevFocus'
              if exists('focus') 
                let newfpos = fpos - 1
                if newfpos == -1
                  let newfpos = len(flist) - 1
                endif
                if newfpos != fpos
                  call focus.loseFocus()
                  let fpos = newfpos 
                  let focus = flist[fpos]
                  call focus.handleEvent(event)
                  call focus.gainFocus() 
                  call focus.hotspot()
                endif

                redraw
              endif

            elseif type == 'FirstFocus'
              if exists('focus') 
                if len(flist) == 1
                  if focus.handleEvent(event)
                    for w in forms#ViewerRedrawListCopyAndClear() 
                      call w.redraw()
                    endfor
                    call focus.hotspot()

                    " TODO is this needed
                    redraw
                  endif
                elseif fpos != 0
                  call focus.loseFocus()
                  let fpos = 0
                  let focus = flist[fpos]
                  call focus.handleEvent(event)
                  call focus.gainFocus() 
                  call focus.hotspot()
                  redraw
                endif
              endif

            elseif type == 'LastFocus'
              if exists('focus') 
                let end = len(flist) - 1
                if len(flist) == 1
                  if focus.handleEvent(event)
                    for w in forms#ViewerRedrawListCopyAndClear() 
                      call w.redraw()
                    endfor
                    call focus.hotspot()

                    " TODO is this needed
                    redraw
                  endif
                elseif fpos != end
                  call focus.loseFocus()
                  let fpos = end
                  let focus = flist[fpos]
                  call focus.handleEvent(event)
                  call focus.gainFocus() 
                  call focus.hotspot()
                  redraw
                endif
              endif

            elseif type == 'NewFocus'
              " selection
              let eline = event.line
              let ecolumn = event.column
" call forms#log("g:forms#Viewer.run NewFocus: eline=" . eline . ", ecolumn=" . ecolumn)
              " Is click within this Viewer
              if eline >= a.line && eline < a.line + a.height &&
                      \ ecolumn >= a.column && ecolumn < a.column + a.width

                " Yes, this Viewer should handle the NewFocus evdnt
                let selFocusPos = -1
                let cnt = 0
                while cnt < len(flist)
                  let f = flist[cnt]
                  let fa = f.allocation()
                  if ! empty(fa)
                    if eline >= fa.line && eline < fa.line + fa.height &&
                        \ ecolumn >= fa.column && ecolumn < fa.column + fa.width
" call forms#log("g:forms#Viewer.run NewFocus: FOUND ONE: cnt=" . cnt)
                      let selFocusPos = cnt
                      break
                    endif
                  endif

                  let cnt += 1
                endwhile

                if selFocusPos != -1 
                  if selFocusPos == fpos
"   call forms#log("g:forms#Viewer.run NewFocus: Same Focus to Select")
                    " Existing focus but maybe different "sub" focus
                    call self.unGetChar({
                                     \ 'type': 'Select',
                                     \ 'line': eline,
                                     \ 'column': ecolumn
                                     \ }) 
                  
                  else
" call forms#log("g:forms#Viewer.run NewFocus : New Focus hotspot")
                    " New focus
                    call focus.loseFocus()
                    let fpos = selFocusPos
                    let focus = flist[fpos]
                    call focus.gainFocus() 
                    call focus.hotspot()
                    redraw
if 0
                    call self.unGetChar({
                                     \ 'type': 'NewFocus',
                                     \ 'line': eline,
                                     \ 'column': ecolumn
                                     \ }) 
endif
                  endif
                endif
              else
" call forms#log("g:forms#Viewer.run NewFocus: Walk Viewer Stack")
                let vsSize  = forms#ViewerStackDepth()
" call forms#log("g:forms#Viewer.run NewFocus: vsSize=" . vsSize)
                if vsSize > 1
                  let cnt  = vsSize - 2
" call forms#log("g:forms#Viewer.run NewFocus: cnt=" . cnt)
                  while cnt >= 0
                    let viewer = forms#ViewerStackPeek(cnt) 
                    let va = viewer.__allocation
                    if eline >= va.line && eline < va.line + va.height &&
                      \ ecolumn >= va.column && ecolumn < va.column + va.width
                      break
                    endif

                    let cnt -= 1
                  endwhile
                  if cnt >= 0
" call forms#log("g:forms#Viewer.run NewFocus: FOUND VIEWER at: " . cnt)
                    call self.unGetChar({
                                     \ 'type': 'PopViewer',
                                     \ 'depth': (vsSize-cnt-1),
                                     \ 'event': event
                                     \ }) 
                    break
                  else
                    call self.unGetChar({ 'type': 'Exit' }) 
                  endif
                endif
              endif

            elseif type == 'PopViewer'
" call forms#log("g:forms#Viewer.run PopViewer: POP VIEWER depth: " . event.depth)
              let event.depth -= 1
              if event.depth > 0
                call self.unGetChar(event)
                break
              else
                call self.unGetChar(event.event)
              endif

            elseif type == 'Context'
              let a = self.__allocation
              let eline = event.line
              let ecolumn = event.column
" call forms#log("g:forms#Viewer.run Context: eline=" . eline . ", ecolumn=" . ecolumn)

              " hit within Viewer allocation
              if eline >= a.line && eline < a.line + a.height &&
                        \ ecolumn >= a.column && ecolumn < a.column + a.width
                " hit glyph if focus list or not
                for f in flist
                  let fa = f.allocation()
                  if ! empty(fa)
                    if eline >= fa.line && eline < fa.line + fa.height &&
                        \ ecolumn >= fa.column && ecolumn < fa.column + fa.width
                      let focusHit = f
                      break
                    endif
                  endif
                endfor
                if exists("focusHit")
                  call forms#DoFocusInfo(focusHit, self, eline, ecolumn)
                  unlet focusHit
                else
                  call forms#DoFormInfo(self, eline, ecolumn)
                endif
if 0
                call forms#DoGlyphSelectInfo(self.__body, eline, ecolumn)
endif
                call self.__body.redraw()
                if exists('focus')
                  call focus.hotspot()
                endif
                redraw
              endif

            elseif type == 'Exit'
              if forms#ViewerStackDepth() > 1
                break
              else
" call forms#log("g:forms#Viewer.run return Exit event=" . string(event))
                return event
              endif

            elseif type == 'ReSize'
              return event

            elseif type == 'ReFocus'
              let flist = []
              call forms#GenerateFocusList(self.__body, flist)
              " Had a old focus
              if exists('focus')
                let oldfocus = focus
                let fpos = 0
                unlet focus

                " There is a new focus list
                if len(flist) > 0 
                  " See if the oldfocus is in the new list
                  " if so, its is still the focus
                  let fpos = 0
                  while fpos < len(flist)
                    let g = flist[fpos]
                    if g.equals(oldfocus)
                      let focus = g
                      call focus.hotspot() 
                      redraw
                      break
                    endif

                    let fpos += 1
                  endwhile
                  " if the oldfocus is no longer in new focus list
                  " then simply pick the first one as the new focus
                  if ! exists('focus')
                    call oldFocus.loseFocus()
                    let fpos = 0
                    let focus = flist[fpos] 
                    call focus.gainFocus() 
                    call focus.hotspot() 
                    redraw
                  endif
                endif
              elseif len(flist) > 0 
                " no old focus so just pick the first one as new focus
                let fpos = 0
                let focus = flist[fpos] 
                call focus.gainFocus() 
                call focus.hotspot() 
                redraw
              endif


            elseif type == 'Command'
              if forms#ViewerStackDepth() > 1
" call forms#log("g:forms#Viewer.run return unGetChar Command event")
                call self.unGetChar(event)
                break
              else
" call forms#log("g:forms#Viewer.run return return Command event")
                return event
              endif

            elseif type == 'Cancel'
              if forms#ViewerStackDepth() > 1
                call self.unGetChar(event)
                break
              else
                return event
              endif

            elseif type == 'Submit'
              if forms#ViewerStackDepth() > 1
                call self.unGetChar(event)
                break
              else
                return event
              endif

            elseif type == 'Sleep'
              let time = event.time
" call forms#log("g:forms#Viewer.run Sleep time=".time)
              execute 'sleep '.time

            else
              if exists('focus')
                if focus.handleEvent(event)
                  for w in forms#ViewerRedrawListCopyAndClear() 
" call forms#log("g:forms#Viewer.run call e redraw: w.tag=".w.getTag())
" call forms#log("g:forms#Viewer.run call e redraw: w.kind=".w.getKind())
                    call w.redraw()
                  endfor
                  call focus.hotspot()

                  " TODO is this needed
                  redraw
                endif
              endif
            endif

          elseif type(input) == g:self#NUMBER_TYPE || type(input) == g:self#STRING_TYPE
            let nr = input
            let c = nr2char(nr)
" call forms#log("g:forms#Viewer.run nr=".string(nr))
" call forms#log("g:forms#Viewer.run c=".string(c))

            if g:forms_window_dump_enabled
              if c == ''
                execute ":w! ".g:forms_window_dump_file
              endif
            endif

            if exists('focus')
              if focus.handleChar(nr)
                for w in forms#ViewerRedrawListCopyAndClear() 
" call forms#log("g:forms#Viewer.run call c redraw")
                  call w.redraw()
                endfor
                call focus.hotspot()

              else
                if nr == "\<Up>" || nr == "\<ScrollWheelUp>"
                  call self.unGetChar({ 'type': 'PrevFocus' })
                elseif nr == "\<Down>" || nr == "\<ScrollWheelDown>"
                  call self.unGetChar({ 'type': 'NextFocus' })
                elseif c == ''
                  call forms#DoFocusInfo(focus)
                endif
              endif

            else
              if c == ''
                call forms#DoFormInfo(self)
              endif
            endif

            redraw
          else
            throw "Viewer.run: Bad input: " . input
          endif

          unlet input
        endwhile

        return {'type': 'Cancel'}

      finally
        if exists('focus') 
          call focus.loseFocus()
        endif
        call forms#ViewerStackPop() 

      endtry
    endfunction
    let g:forms#Viewer.run  = function("FORMS_VIEWER_run")

    function! FORMS_VIEWER_usage() dict
      return [
           \ "A Viewer can gain focus and has child glyphs that can then",
           \ "  have focus. It is the basic glyph unit of input control.",
           \ "  A Form ia a top-level Viewer. A Form can have multiple sub-.",
           \ "  Viewers. To exit, pop-out-of, a sub-Viewer, enter <ESC>.",
           \ "Navigation between Viewers can be done by selecting and exiting.",
           \ "  A mouse select <LeftMouse> can be used to move between.",
           \ "  Viewers selecting a new child focus glyph.",
           \ "  Tabbing <Tab>, <S-Tab>, <C-p> and <C-n> can be used to move",
           \ "  between focus glyphs. The mouse scroll wheel can also",
           \ "  be used.",
           \ "Selection is with keyboard <CR> or <Space>,",
           \ "  or with a mouse <LeftMouse> click."
           \ ]
    endfunction
    let g:forms#Viewer.usage  = function("FORMS_VIEWER_usage")
  endif

  return g:forms#Viewer
endfunction
" ------------------------------------------------------------ 
" forms#newViewer: {{{2
"   Create new Viewer 
"  parameters: 
"   attrs  : attributes for initializing new object
" ------------------------------------------------------------ 
function! forms#newViewer(attrs)
  return forms#loadViewerPrototype().clone().init(a:attrs)
endfunction

"---------------------------------------------------------------------------
" Form <- Viewer: {{{2
"---------------------------------------------------------------------------
" The top-level glyph for ALL displays. It is a top-level viewer. 
"   Saves the current state of Vim (displayed lines,
"   options, matches mouse setting, wrap value, etc.) which are all
"   restored in a finally clause when the form is exited. Also,
"   makes sure lines/columns the form is to be displayed upon exist
"   and have a length great enough to display the form on.
"   And, lines that wrap, are truncated.
"
" attributes:
"    delete     : Should form be deleted on exit. Default true (1).
"    x_screen   : Place form a x (column) screen (window) position.
"                   Takes precedence over halignment value.
"    y_screen   : Place form a y (line) screen (window) position.
"                   Takes precedence over valignment value.
"    halignment : Horizontally align form in window.
"                   float align 0-1 or 'L' 'C' 'R' (default 'L')
"                   default is 'C'
"    valignment : Vertically align form in window.
"                   float align 0-1 or 'T' 'C' 'B' (default 'T')
"                   default is 'C'
"---------------------------------------------------------------------------

if exists("s:form_top_screen_line")
  unlet s:form_top_screen_line
endif
if exists("s:form_cursor_line")
  unlet s:form_cursor_line
endif
if exists("s:form_cursor_column")
  unlet s:form_cursor_column
endif
if exists("s:form_winline")
  unlet s:form_winline
endif

let s:handling_form_too_big_info = g:self#IS_FALSE

if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms#Form")
    unlet g:forms#Form
  endif
endif
function! forms#loadFormPrototype()
  if !exists("g:forms#Form")
    let g:forms#Form = forms#loadViewerPrototype().clone('forms#Form')
    let g:forms#Form.__delete = 1
    let g:forms#Form.__x_screen = -1
    let g:forms#Form.__y_screen = -1
    let g:forms#Form.__halignment = 'C'
    let g:forms#Form.__valignment = 'C'

    function! FORMS_FORM_init(attrs) dict
      call call(g:forms#Viewer.init, [a:attrs], self)

      call g:forms_Util.checkHAlignment(self.__halignment, "Form.init")
      call g:forms_Util.checkVAlignment(self.__valignment, "Form.init")

      return self
    endfunction
    let g:forms#Form.init  = function("FORMS_FORM_init")

    function! FORMS_FORM_reinit(attrs) dict
" call forms#log("g:forms#Form.reinit TOP")
      let oldXScreen = self.__x_screen
      let oldYScreen = self.__y_screen
      let oldHAlignment = self.__halignment
      let oldVAlignment = self.__valignment

      let self.__delete = 1
      let self.__x_screen = -1
      let self.__y_screen = -1
      let self.__halignment = 'C'
      let self.__valignment = 'C'

      call call(g:forms#Viewer.reinit, [a:attrs], self)

      if oldXScreen != self.__x_screen
        call forms#PrependUniqueInput({'type': 'ReSize'})
      elseif oldYScreen != self.__y_screen
        call forms#PrependUniqueInput({'type': 'ReSize'})
      elseif oldHAlignment != self.__halignment
        call forms#PrependUniqueInput({'type': 'ReSize'})
      elseif oldVAlignment != self.__valignment
        call forms#PrependUniqueInput({'type': 'ReSize'})
      endif
    endfunction
    let g:forms#Form.reinit  = function("FORMS_FORM_reinit")


    " Form.run
    " return result Dictionary
    "   On Submit, Dictionary contains result data
    "   On Cancel or Exit, Dictionary is empty
    function! FORMS_FORM_run() dict
"call forms#log("g:forms#Form.run TOP")

      "==============================================
      " Capture environment
      "==============================================

      " command to run
      let command = ''

      " Save current state to be restored before returning
      let l:save_cpo = &cpo
      let l:save_matches = getmatches()
      call clearmatches()
      let l:save_mouse = &mouse
      setlocal mouse=a
      let l:save_wrap = &wrap
      if &wrap | set nowrap | endif

      let l:save_scrolloff = &scrolloff
      let l:save_sidescrolloff = &sidescrolloff
      set scrolloff=0
      set sidescrolloff=0

      if forms#ViewerStackDepth() == 0 

        " save the syntax if it can be determined
        if exists("&syntax")
          let l:save_syntax = &syntax
          set syntax=
        endif
        if exists("b:current_syntax")
          let l:current_syntax = b:current_syntax
          execute "syntax clear"
        endif

        " Save current gui font and set to a fixed char-width font
        " that supports box-drawing and block uft-8 characters
        if has("gui_running")
          let l:save_gui_font = &guifont
          let &guifont = g:forms_gui_font
        endif

" let save_cursor = getpos(".")
" call forms#log("g:forms#Form save_cursor=" . string(save_cursor))
        let save_view = winsaveview()
"call forms#log("g:forms#Form save_view=" . string(save_view))

        " Current cursor first line in screen
        let s:form_top_screen_line = line('w0')
        " Current cursor position
        let s:form_cursor_line = line('.')
        let s:form_cursor_column = virtcol('.')

        " get winline after nowrap is set
        let s:form_winline = winline()
        
        " Make sure the undo list is not empty
        " This is undone after the undofile is read at bottom 
        " execute ":normal Go"
        execute ":normal G$a "

        let undof = tempname()
        " let undof = undofile("xx")
"call forms#log("g:forms#Form wundo undof=" . undof)
        execute "wundo " . undof

      endif

      let l:top_screen_line = s:form_top_screen_line
      let l:line = s:form_cursor_line
      let l:column = s:form_cursor_column
      let winline = s:form_winline
"call forms#log("g:forms#Form top_screen_line=" . l:top_screen_line)
"call forms#log("g:forms#Form line=" . l:line)
"call forms#log("g:forms#Form column=" . l:column)
"call forms#log("g:forms#Form winline=" . winline)

      " Current window width and height
      let l:winWidth = winwidth(0)
      let l:winHeigth = winheight(0)
"call forms#log("g:forms#Form self.__y_screen=" . self.__y_screen)
"call forms#log("g:forms#Form self.__x_screen=" . self.__x_screen)
"call forms#log("g:forms#Form winWidth=" . l:winWidth)
"call forms#log("g:forms#Form winHeigth=" . l:winHeigth)

      " Gel line number at top of screen
      " Current line in buffer minus screen line from top of window.
      "   Note that winline() returns incorrect value if wrap is on.
      let l:lineStartOfScreen = 0
      let l:lineEndOfScreen = l:lineStartOfScreen + l:winHeigth
      let l:columnStartOfScreen = 1
      let l:columnEndOfScreen = l:winWidth

      " Determina form placement in window
      let halignment = self.__halignment
      let valignment = self.__valignment

      try

        let run_viewer = g:self#IS_TRUE

        while run_viewer == g:self#IS_TRUE
          let run_viewer = g:self#IS_FALSE

          "==============================================
          " Get Allocation and Capture Screen 
          "==============================================

          " How big is the form
          let [formWidth, formHeight] = self.requestedSize()

"call forms#log("g:forms#Form formWidth=" . formWidth)
"call forms#log("g:forms#Form formHeight=" . formHeight)

          " Can the form fit in the window
          let y_success = g:self#IS_TRUE
          if self.__y_screen >= 0
            if l:winHeigth < formHeight + self.__y_screen
              let ydelta = formHeight + self.__y_screen - l:winHeigth
              let self.__y_screen -= ydelta
              let self.__y_screen -= 1
            endif
"call forms#log("g:forms#Form self.__y_screen=" . self.__y_screen)
            if self.__y_screen < 0
              let y_success = g:self#IS_FALSE
            endif
          endif
          if l:winHeigth < formHeight || ! y_success

            let textlines = "Form too big for current window height.\n  Window height=".l:winHeigth."\n  Form height=" . formHeight."\nSuggest making window taller by ".(formHeight-l:winHeigth+1)." lines."

            if s:handling_form_too_big_info == g:self#IS_TRUE
              throw textlines
            else
              let s:handling_form_too_big_info = g:self#IS_TRUE
              try 
                call forms#dialog#info#Make(textlines)
                return
              catch /.*/
                throw textlines
              finally
                let s:handling_form_too_big_info = g:self#IS_FALSE
              endtry
            endif
          endif

          let x_success = g:self#IS_TRUE
          if self.__x_screen >= 0
            if l:winWidth < formWidth + self.__x_screen
              let xdelta = formWidth + self.__x_screen - l:winWidth
              let self.__x_screen -= xdelta
            endif
            if self.__x_screen < 0
              let x_success = g:self#IS_FALSE
            endif
          endif
          if l:winWidth < formWidth || ! x_success
            let textlines = "Form too big for current window width.\n  Window width=".l:winWidth."\n  Form width=" . formWidth."\nSuggest making window wider by ".(formHeight-l:winHeigth+1)." columns."

            if s:handling_form_too_big_info == g:self#IS_TRUE
              throw textlines
            else
              let s:handling_form_too_big_info = g:self#IS_TRUE
              try 
                call forms#dialog#info#Make(textlines)
                return
              catch /.*/
                throw textlines
              finally
                let s:handling_form_too_big_info = g:self#IS_FALSE
              endtry
            endif
          endif

          let l:lineStartOfFormScreen = (self.__y_screen >= 0) 
                    \ ? self.__y_screen 
                    \ : g:forms_Util.vAlign({
                                      \ 'line': l:lineStartOfScreen,
                                      \ 'height': l:winHeigth,
                                      \ 'childheight': formHeight
                                      \ }, valignment)
          let l:lineEndOfFormScreen = l:lineStartOfFormScreen + formHeight

          let l:lineStartOfFormBuffer = l:lineStartOfFormScreen+l:top_screen_line
          let l:lineEndOfFormBuffer = l:lineStartOfFormBuffer + formHeight


          let l:columnStartOfFormScreen = (self.__x_screen >= 0) 
                    \ ? self.__x_screen 
                    \ : g:forms_Util.hAlign({
                                      \ 'column': l:columnStartOfScreen,
                                      \ 'width': l:winWidth,
                                      \ 'childwidth': formWidth
                                      \ }, halignment)
          let l:columnEndOfFormScreen = l:columnStartOfFormScreen + formWidth

          let totalLinesBuffer = line('$')

"call forms#log("g:forms#Form lineStartOfScreen=" . l:lineStartOfScreen)
"call forms#log("g:forms#Form lineEndOfScreen=" . l:lineEndOfScreen)
"call forms#log("g:forms#Form lineStartOfFormScreen=" . l:lineStartOfFormScreen)
"call forms#log("g:forms#Form lineEndOfFormScreen=" . l:lineEndOfFormScreen)
"call forms#log("g:forms#Form lineStartOfFormBuffer=" . l:lineStartOfFormBuffer)
"call forms#log("g:forms#Form lineEndOfFormBuffer=" . l:lineEndOfFormBuffer)
"call forms#log("g:forms#Form columnStartOfFormScreen=" . l:columnStartOfFormScreen)
"call forms#log("g:forms#Form totalLinesBuffer=" . totalLinesBuffer)
      
          " -------------------------------------------------
          " Will the form overlap existing text in the window.
          " Three possible values:
          "   normal - lines in window below end of form
          "   partial - lines in window intersect with mid-form
          "   one - lines in window are one
          "   full - lines in window above start of form
          " -------------------------------------------------
          if totalLinesBuffer > l:lineEndOfFormBuffer " normal case
"call forms#log("g:forms#Form case=normal")
            let l:nosLinesToSave = formHeight
            let l:nosLinesToAdd = 0
          elseif totalLinesBuffer < l:lineStartOfFormBuffer " partial case
" call forms#log("g:forms#Form case=partial")
            let l:nosLinesToSave = 0
            let l:nosLinesToAdd = formHeight +  (l:lineStartOfFormBuffer - totalLinesBuffer)
          elseif totalLinesBuffer == 1 " one case
"call forms#log("g:forms#Form case=one")
            let l:nosLinesToSave = 1
            let l:nosLinesToAdd = (l:lineEndOfFormBuffer - totalLinesBuffer) - 1
          else " full case
"call forms#log("g:forms#Form case=full")
            let l:nosLinesToSave = totalLinesBuffer -  l:lineStartOfFormBuffer
            let l:nosLinesToAdd = (l:lineEndOfFormBuffer - totalLinesBuffer) - 1
          endif
"call forms#log("g:forms#Form nosLinesToSave=" . l:nosLinesToSave)
"call forms#log("g:forms#Form nosLinesToAdd=" . l:nosLinesToAdd)


          " save current lines (if needed)
          if l:nosLinesToSave > 0
            let l:savedLines = getline(l:lineStartOfFormBuffer,
                                   \ l:lineStartOfFormBuffer+l:nosLinesToSave)
          endif

          " Add new lines (if needed)
          if l:nosLinesToAdd > 0
            call cursor(line('$'), 0)
            let cnt = 0
            while cnt < l:nosLinesToAdd
              execute ":normal o"
              execute ":normal " . l:columnEndOfFormScreen . 'i' . ' '

              let cnt += 1
            endwhile
          endif

          " Extend all of the lines to be used by the Form to the whole 
          " width of the window
          if l:nosLinesToSave > 0
            let pos = l:lineStartOfFormBuffer
            let cnt = 0
            while cnt <= l:nosLinesToSave
              let cline = getline(pos)
              let clineLen = strchars(cline)
              let diff = l:columnEndOfFormScreen - clineLen
              if diff > 0
"  call forms#log("g:forms#Form diff > 0")
                call cursor(pos, clineLen)
                execute ":normal " . diff . 'A' . ' '
              elseif l:winWidth < clineLen
" call forms#log("g:forms#Form LINE TOO LONG: " . cline)
                call cursor(pos, l:winWidth)
                execute ":normal D"
              endif

              let cnt += 1
              let pos += 1
            endwhile
          endif


"call forms#log("g:forms#Form wait getchar before draw")
"call getchar()
" http://stackoverflow.com/questions/9625028/vim-buffer-position-change-on-window-split-annoyance

          if exists("save_view")
            let copy_save_view = copy(save_view)
            let copy_save_view.topline =  l:top_screen_line
            call winrestview(copy_save_view)
          endif

          call self.draw({
                        \ 'line': l:lineStartOfFormBuffer,
                        \ 'column': l:columnStartOfFormScreen,
                        \ 'width': formWidth,
                        \ 'height': formHeight
                        \ })
          redraw
" call forms#log("g:forms#Form after first draw")

          try 
            let p = g:forms#Form._prototype
            let rval = call(p.run, [], self)
" call forms#log("g:forms#Form after rval=".string(rval))
            let results = {}
            if rval.type == 'Exit'
              " nothing
            elseif rval.type == 'ReSize'
              let run_viewer = g:self#IS_TRUE
            elseif rval.type == 'Command'
              if forms#ViewerStackDepth() > 1
                call self.unGetChar(event)
              else
                let command = rval.command
              endif
" call forms#log("g:forms#Form after processing command event")
            elseif rval.type == 'Cancel'
              " nothing
            elseif rval.type == 'Submit'
              call self.generateResults(self.__body, results)
" call forms#log("g:forms#Form.run results=" . string(results))
              return results
            else
              throw "Form.run: Bad rval object: " . string(rval)
            endif

          finally
" call forms#log("g:forms#Form inner finally")
            "==============================================
            " Restore Captured Screen 
            "==============================================
  
            " restore all lines that were over written by Form
            if l:nosLinesToSave > 0
              let l:save_formatoptions = &formatoptions
              execute ":set formatoptions="

              call setline(l:lineStartOfFormBuffer, l:savedLines)

              let &formatoptions = l:save_formatoptions
            endif

            if l:nosLinesToAdd > 0
              call cursor(line('$'), 0)
              let cnt = 0
              while cnt < l:nosLinesToAdd
                execute ":normal dd"

                let cnt += 1
              endwhile
            endif

          endtry

          " Need to delete all of the glyph's highlights
          " because the new form might be smaller than the current form.
          if run_viewer == g:self#IS_TRUE
            call forms#DeleteHighLights(self.__body)
          endif

        endwhile

      catch /Vim.*/
        if g:forms_log_enabled == g:self#IS_TRUE
          call forms#log("Caught Vim Exception: " . v:exception . " at " . v:throwpoint)
          echo v:exception
        else
          echoerr v:exception . " at " . v:throwpoint
        endif
      catch /.*/
        if g:forms_log_enabled == g:self#IS_TRUE
          call forms#log("Caught Exception: " . v:exception . " at " . v:throwpoint)
          echo v:exception
        else
          throw "Forms: " . v:exception . " at " . v:throwpoint
        endif
      finally
"  call forms#log("g:forms#Form outer finally")

        "==============================================
        " Automatic Delete of Form body
        "==============================================
        
        if self.__delete
          let body = self.getBody()
          call body.delete()
        endif

        "==============================================
        " Restore environment
        "==============================================

        let &mouse = l:save_mouse
        unlet l:save_mouse

        call setmatches(l:save_matches)
        unlet l:save_matches

        if forms#ViewerStackDepth() == 0 
          if has("gui_running")
            if exists("l:save_gui_font")
              let &guifont = l:save_gui_font
              unlet l:save_gui_font
            endif
          endif

          " reset the syntax if it is known
          if exists("l:current_syntax")
            let difile = "/syntax/".l:current_syntax.".vim"
            for rtp in split(&runtimepath, ',')
              if filereadable(rtp . difile)
                execute "source " . rtp . difile
                break
              endif
            endfor
          endif
          if exists("l:save_syntax")
            let &syntax = l:save_syntax
          endif

        endif

        let &scrolloff = l:save_scrolloff
        let &sidescrolloff = l:save_sidescrolloff
        let &wrap = l:save_wrap
        let &cpo = l:save_cpo
        unlet l:save_cpo

        if forms#ViewerStackDepth() == 0 
          try
" call forms#log("g:forms#Form rundo undof=" . undof)
            silent execute "rundo " . undof
            silent call delete(undof)

            " Now, undo the operation done before undo write was done
            execute ":normal u"
          catch /.*/
            " do nothing
          endtry

"call setpos('.', save_cursor)
          call winrestview(save_view)
        endif

      endtry

" call forms#log("g:forms#Form.run BOTTOM command=".command)
      "==============================================
      " Execute Commnad
      "==============================================
      if command != ''
        try
          if command[0] == ':'
            execute command
          else
            " execute ":normal " . command
            let x = ":normal " . command
" call forms#log("g:forms#Form.run BOTTOM x=".x)
            execute x
          endif
        catch /.*/
          if g:forms_log_enabled == g:self#IS_TRUE
            call forms#log("g:forms#Form.run Caught Exception: " . v:exception . " at " . v:throwpoint)
            echo v:exception
          else
            throw "Forms: " . v:exception . " at " . v:throwpoint
          endif
        endtry
      endif
    endfunction
    let g:forms#Form.run  = function("FORMS_FORM_run")

  endif

  return g:forms#Form
endfunction
" ------------------------------------------------------------ 
" forms#newForm: {{{2
"   Create new Form 
"  parameters: 
"   attrs  : attributes for initializing new object
" ------------------------------------------------------------ 
function! forms#newForm(attrs)
  return forms#loadFormPrototype().clone().init(a:attrs)
endfunction

"---------------------------------------------------------------------------
" Debug <- Mono: {{{2
"---------------------------------------------------------------------------
" The Debug Glyph wrapps all of the methods of its child Glyph 
"   with ENTRY and EXIT logging statements. The wrapping is achieved
"   using Vim reflection on the child Glyph's functions names.
"   The log messages use the wrapped child's type and not the Debug
"   Glyph's type so that it appears as if it the messages are actually
"   originating in the child Glyph's methods (but they are not).
"
"   In terms of usage, since the Debug Glyph wraps ALL of its child's
"   methods, one should simply use a Debug object as if it were the
"   actually child Glyph.
"
" attributes:
"    msg   : Message to be printed out along with child's type, tag
"              and id on initializtion if not empty.
"              This can serve as a means of mapping between the wrapped
"              Glyph and its id in latter debug messages.
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms#Debug")
    unlet g:forms#Debug
  endif
endif
function! forms#loadDebugPrototype()
  if !exists("g:forms#Debug")
    let g:forms#Debug = forms#loadMonoPrototype().clone('forms#Debug')
    let g:forms#Debug.__msg = ''

    function! FORMS_DEBUG_init(attrs) dict
      call call(g:forms#Mono.init, [a:attrs], self)

      " Use id for all logging
      let initmsg = "forms#Debug.init"
      if self.__msg != ''
        let initmsg = initmsg . ":msg(".self.__msg.")"
      endif
      let initmsg = initmsg . ":type(" . self.__body.getKind() . ")"
      let initmsg = initmsg . ":tag(" . self.__body.getTag() . ")"
      let initmsg = initmsg . ":id(" . self.__body._id . ")"
      call forms#log(initmsg)

      " create methods for each method the body has that Debug does not have
      let type = self.__body.getKind()
      let id = self.__body._id
      for key in keys(self.__body)
        " TODO handle clone and delete methods
        let FN = self.__body[key]
        if type(FN) == g:self#FUNCREF_TYPE
          let l:fd =        "function! self." . key . "(...) dict\n"
            let l:fd = l:fd .   "call forms#log('".type.key.": ENTRY ".id.": args='.string(a:000))\n"
            let l:fd = l:fd .   "let l:o = g:self_ObjectManager.lookup(".id.")\n"
            let l:fd = l:fd .   "let l:r = call(l:o.".key.", a:000, l:o)\n"
            let l:fd = l:fd .   "call forms#log('".type.key.": EXIT  ".id.": r='.string(l:r))\n"
            let l:fd = l:fd .   "return l:r\n"
            let l:fd = l:fd . "endfunction"
            execute l:fd
        endif
        unlet FN
      endfor

      return self
    endfunction
    let g:forms#Debug.init  = function("FORMS_DEBUG_init")
  endif

  return g:forms#Debug
endfunction
" ------------------------------------------------------------ 
" forms#newDebug: {{{2
"   Create new Debug 
"  parameters: 
"   attrs  : attributes for initializing new object
" ------------------------------------------------------------ 
function! forms#newDebug(attrs)
  return forms#loadDebugPrototype().clone().init(a:attrs)
endfunction







"-------------------------------------------------------------------------------
" Poly Prototype: {{{1
"---------------------------------------------------------------------------
" Poly <- Glyph: {{{2
"   Abstract Glyph
"   Contains one or more child glyphs.
"
" attributes
"   children : list of child glyphs
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms#Poly")
    unlet g:forms#Poly
  endif
endif
function! forms#loadPolyPrototype()
  if !exists("g:forms#Poly")
    let g:forms#Poly = forms#loadGlyphPrototype().clone('forms#Poly')
    let g:forms#Poly.__children = []
    let g:forms#Poly.__children_request_size = []

    function! FORMS_POLY_nodeType() dict
      return g:POLY_NODE
    endfunction
    let g:forms#Poly.nodeType  = function("FORMS_POLY_nodeType")

    function! FORMS_POLY_init(attrs) dict
" call forms#log("g:forms#Poly.init TOP")
      call call(g:forms#Glyph.init, [a:attrs], self)

      return self
    endfunction
    let g:forms#Poly.init  = function("FORMS_POLY_init")

    function! FORMS_POLY_reinit(attrs) dict
" call forms#log("g:forms#Poly.reinit TOP")
      let oldChildSize = len(self.__children)

      let self.__children = []
      let self.__children_request_size = []

      call call(g:forms#Glyph.reinit, [a:attrs], self)

      if oldChildSize != len(self.__children)
        call forms#PrependUniqueInput({'type': 'ReSize'})
      else
        call forms#ViewerRedrawListAdd(self) 
      endif
    endfunction
    let g:forms#Poly.reinit  = function("FORMS_POLY_reinit")

    function! FORMS_POLY_delete(...) dict
" call forms#log("Poly.delete: TOP")
      for child in self.__children
        if has_key(child, 'delete')
          call child.delete()
        endif
      endfor

      let p = g:forms#Poly._prototype
      call call(p.delete, [p], self)
" call forms#log("Poly.delete: BOTTOM")
    endfunction
    let g:forms#Poly.delete  = function("FORMS_POLY_delete")

    function! FORMS_POLY_hide() dict
      for child in self.__children
        call child.hide()
      endfor
    endfunction
    let g:forms#Poly.hide  = function("FORMS_POLY_hide")

    function! FORMS_POLY_setChildStatus(index, status) dict
      call self.__children[a:index].setStatus(a:status)
    endfunction
    let g:forms#Poly.setChildStatus  = function("FORMS_POLY_setChildStatus")

    function! FORMS_POLY_children() dict
      return self.__children
    endfunction
    let g:forms#Poly.children  = function("FORMS_POLY_children")

    function! FORMS_POLY_size() dict
      return len(self.__children)
    endfunction
    let g:forms#Poly.size  = function("FORMS_POLY_size")

    function! FORMS_POLY_prepend(child) dict
      call insert(self.__children, a:child)
    endfunction
    let g:forms#Poly.prepend  = function("FORMS_POLY_prepend")

    function! FORMS_POLY_setAt(child, index) dict
      let self.__children[a:index] = a:child
    endfunction
    let g:forms#Poly.setAt  = function("FORMS_POLY_setAt")

    function! FORMS_POLY_insertAt(child, index) dict
      call insert(self.__children, a:child, a:index)
    endfunction
    let g:forms#Poly.insertAt  = function("FORMS_POLY_insertAt")

    function! FORMS_POLY_removeAt(index) dict
      call remove(self.__children, a:index)
    endfunction
    let g:forms#Poly.removeAt  = function("FORMS_POLY_removeAt")

    function! FORMS_POLY_append(child) dict
"call forms#log("Poly.append: TOP")
      call add(self.__children, a:child)
    endfunction
    let g:forms#Poly.append  = function("FORMS_POLY_append")

    function! FORMS_POLY_indexOf(child) dict
      return index(self.__children, a:child)
    endfunction
    let g:forms#Poly.indexOf  = function("FORMS_POLY_indexOf")

    function! FORMS_POLY_childAt(index) dict
      return self.__children[a:index]
    endfunction
    let g:forms#Poly.childAt  = function("FORMS_POLY_childAt")

  endif

  return g:forms#Poly
endfunction

"---------------------------------------------------------------------------
" HPoly <- Poly: {{{2
"---------------------------------------------------------------------------
" Children are displayed horizontally from left to right.
"   When the children have different heights, then vertically they
"   are displayed based upon the alignment.
"
" attributes
"   alignment : float align 0-1 or 'T' 'C' 'B'
"   mode      : optional box drawing mode
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms#HPoly")
    unlet g:forms#HPoly
  endif
endif
function! forms#loadHPolyPrototype()
  if !exists("g:forms#HPoly")
    let g:forms#HPoly = forms#loadPolyPrototype().clone('forms#HPoly')
    let g:forms#HPoly.__alignment = 'T'
    let g:forms#HPoly.__size = -1
    let g:forms#HPoly.__win_start = 0


    function! FORMS_HPOLY_init(attrs) dict
" call forms#log("g:forms#HPoly.init TOP")
      call call(g:forms#Poly.init, [a:attrs], self)

      call g:forms_Util.checkVAlignment(self.__alignment, "HPoly.init")
      call self.loadAlignments(a:attrs)

      if has_key(a:attrs, 'mode')
        let mode = a:attrs['mode']
        if type(mode) != g:self#STRING_TYPE
          throw "HPoly.init: mode attribute must be String type"
        endif
        let self.__mode = mode
      endif

      return self
    endfunction
    let g:forms#HPoly.init  = function("FORMS_HPOLY_init")

    function! FORMS_HPOLY_reinit(attrs) dict
" call forms#log("g:forms#HPoly.reinit TOP")
      unlet self.__alignments
      if exists("self.__mode")
        unlet self.__mode
      endif
      let self.__win_start = 0
      let self.__size = -1

      call call(g:forms#Poly.reinit, [a:attrs], self)

      call forms#ViewerRedrawListAdd(self) 
    endfunction
    let g:forms#HPoly.reinit  = function("FORMS_HPOLY_reinit")

    " delay loading alignments since menu items are loaded after Poly.init
    function! FORMS_HPOLY_loadAlignments(attrs) dict
      if ! exists("self.__alignment")
        return
      endif

      " Load the per-child aligments list
      let alignment = self.__alignment
      let alignments = []

      let nos_children = len(self.__children)
" call forms#log("g:forms#HPoly.loadAlignments nos_children=".nos_children)
      let cnt = 0
      while cnt < nos_children
        call add(alignments, alignment)
        let cnt += 1
      endwhile

      if has_key(a:attrs, 'alignments')
        let adata = a:attrs['alignments']
" call forms#log("g:forms#HPoly.loadAlignments: adata=" .  string(adata))
        if type(adata) != g:self#LIST_TYPE
          throw "HPoly.init: alignments attribute must be list type"
        endif

        for d in adata
          if type(d) != g:self#LIST_TYPE
            throw "HPoly.init: alignments attribute member must be list type"
          endif
          let [pos, a] = d
          if pos < 0 || pos >= nos_children
            throw "HPoly.init: alignments attribute postion not valid: " . pos
          endif
          call g:forms_Util.checkVAlignment(a, "HPoly.init")
          let alignments[pos] = a
        endfor
      endif
      let self.__alignments = alignments

      unlet self.__alignment
    endfunction
    let g:forms#HPoly.loadAlignments  = function("FORMS_HPOLY_loadAlignments")


    function! FORMS_HPOLY_requestedSize() dict
"call forms#log("g:forms#HPoly.requestedSize TOP")
      if (self.__status == g:IS_INVISIBLE) 
        return [0,0]
      else
        let children_request_size = []
        let width = 0
        let height = 0
        for child in self.__children
          let [w,h] = child.requestedSize()
          call add(children_request_size, [w,h])
          let width = width + w
          if height < h | let height = h | endif
        endfor
        unlet self.__children_request_size
        let self.__children_request_size = children_request_size

"call forms#log("g:forms#HPoly.requestedSize " . string([width, height]))
        if exists("self.__mode")
          let width += len(self.__children)+1
          let height += 2
        endif
" call forms#log("g:forms#HPoly.requestedSize " . string([width, height]))
        return [width, height]
      endif
    endfunction
    let g:forms#HPoly.requestedSize  = function("FORMS_HPOLY_requestedSize")

    function! FORMS_HPOLY_drawBoxes() dict
      if exists("self.__mode")
        let a = self.__allocation
        let children_request_size =  self.__children_request_size
        if self.__size < 0
          call forms#DrawHBoxes(self.__mode, a, children_request_size)
        else
          let start = self.__win_start
          let end = start + self.__size
"call forms#log("g:forms#HPoly.drawBoxes: start=".start)
"call forms#log("g:forms#HPoly.drawBoxes: end=".end)
          let crs = children_request_size[start:end]
          call forms#DrawHBoxes(self.__mode, a, crs)
        endif
      endif
    endfunction
    let g:forms#HPoly.drawBoxes  = function("FORMS_HPOLY_drawBoxes")

    function! FORMS_HPOLY_draw(allocation) dict
"call forms#log("g:forms#HPoly.draw" .  string(a:allocation))
      let self.__allocation = a:allocation
      let a = a:allocation

      if self.__status != g:IS_INVISIBLE
        let line = a.line
        let column = a.column
        let width = a.width
        let height = a.height
        let size = self.__size
        let win_start = self.__win_start
        let alignments = self.__alignments
        let char = ''
        let children = self.__children
        let children_request_size =  self.__children_request_size

        call self.drawBoxes()
        let bdelta = exists("self.__mode") ? 1 : 0
        let bheight = height - 2*bdelta

        let l:x = bdelta
        let nos_children = len(children)

        if size > 0 && nos_children > size
          let endcnt = size
        else
          let endcnt = nos_children
        endif

        let cnt = 0
        while cnt < endcnt
          let child = children[cnt]
          let [childwidth, childheight] = children_request_size[cnt]
          if childheight == 0
            let childheight = bheight
          endif

          if bheight > childheight
            call g:forms_Util.drawVAlign(child, {
                                         \ 'line': line+bdelta,
                                         \ 'column': column+l:x,
                                         \ 'height': bheight,
                                         \ 'childwidth': childwidth,
                                         \ 'childheight': childheight
                                         \ }, 
                                         \ alignments[cnt], 
                                         \ char)

          else
            call child.draw({
                         \ 'line': line+bdelta,
                         \ 'column': column+l:x,
                         \ 'width': childwidth,
                         \ 'height': childheight
                         \ })
          endif

          let l:x = l:x + childwidth + bdelta
          let cnt += 1
        endwhile

      endif

      if self.__status == g:IS_DISABLED
        call AugmentGlyphHilight(self, "DisableHi", a)
      endif                     
    endfunction
    let g:forms#HPoly.draw  = function("FORMS_HPOLY_draw")

  endif

  return g:forms#HPoly
endfunction
" ------------------------------------------------------------ 
" forms#newHPoly: {{{2
"   Create new HPoly 
"  parameters: 
"   attrs  : attributes for initializing new object
" ------------------------------------------------------------ 
function! forms#newHPoly(attrs)
  return forms#loadHPolyPrototype().clone().init(a:attrs)
endfunction

"---------------------------------------------------------------------------
" VPoly <- Poly: {{{2
"---------------------------------------------------------------------------
" Children are displayed vertically from top to bottom.
"   When the children have different widths, then horizontally they
"   are displayed based upon the alignment.
"
" attributes
"   alignment : float align 0-1 or 'L' 'C' 'R'
"   mode      : optional box drawing mode
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms#VPoly")
    unlet g:forms#VPoly
  endif
endif
function! forms#loadVPolyPrototype()
  if !exists("g:forms#VPoly")
    let g:forms#VPoly = forms#loadPolyPrototype().clone('forms#VPoly')
    let g:forms#VPoly.__alignment = 'L'
    let g:forms#VPoly.__size = -1
    let g:forms#VPoly.__win_start = 0

    function! FORMS_VPOLY_init(attrs) dict
" call forms#log("g:forms#VPoly.init: TOP")
      call call(g:forms#Poly.init, [a:attrs], self)

      call g:forms_Util.checkHAlignment(self.__alignment, "VPoly.init")

      call self.loadAlignments(a:attrs)


      if has_key(a:attrs, 'mode')
        let mode = a:attrs['mode']
        if type(mode) != g:self#STRING_TYPE
          throw "VPoly.init: mode attribute must be String type"
        endif
        let self.__mode = mode
      endif

      return self
    endfunction
    let g:forms#VPoly.init  = function("FORMS_VPOLY_init")

    function! FORMS_VPOLY_reinit(attrs) dict
" call forms#log("g:forms#VPoly.reinit TOP")
      unlet self.__alignments
      if exists("self.__mode")
        unlet self.__mode
      endif
      let self.__win_start = 0
      let self.__size = -1

      call call(g:forms#Poly.reinit, [a:attrs], self)

      call forms#ViewerRedrawListAdd(self) 
    endfunction
    let g:forms#VPoly.reinit  = function("FORMS_VPOLY_reinit")

    " delay loading alignments since menu items are loaded after Poly.init
    function! FORMS_VPOLY_loadAlignments(attrs) dict
      if ! exists("self.__alignment")
        return
      endif

      " Load the per-child aligments list
      let alignment = self.__alignment
      let alignments = []

      let nos_children = len(self.__children)
" call forms#log("g:forms#VPoly.loadAlignments: nos_children=".nos_children)
      let cnt = 0
      while cnt < nos_children
        call add(alignments, alignment)
        let cnt += 1
      endwhile

      if has_key(a:attrs, 'alignments')
        let adata = a:attrs['alignments']
" call forms#log("g:forms#VPoly.loadAlignments: adata=" .  string(adata))
        if type(adata) != g:self#LIST_TYPE
          throw "VPoly.init: alignments attribute must be list type"
        endif

        for d in adata
          if type(d) != g:self#LIST_TYPE
            throw "VPoly.init: alignments attribute member must be list type"
          endif
          let [pos, a] = d
          if pos < 0 || pos >= nos_children
            throw "VPoly.init: alignments attribute postion not valid: " . pos
          endif
          call g:forms_Util.checkHAlignment(a, "VPoly.init")
          let alignments[pos] = a
        endfor
      endif
      let self.__alignments = alignments

      unlet self.__alignment

    endfunction
    let g:forms#VPoly.loadAlignments  = function("FORMS_VPOLY_loadAlignments")

    "-----------------------------------------------
    " vpoly methods
    "-----------------------------------------------

    function! FORMS_VPOLY_requestedSize() dict
      if (self.__status == g:IS_INVISIBLE) 
        return [0,0]
      else
        let children_request_size = []
        let width = 0
        let height = 0
        for child in self.__children
          let [w,h] = child.requestedSize()
" call forms#log("g:forms#VPoly.requestedSize: [w,h]" .  string([w,h]))
          call add(children_request_size, [w,h])
          let height = height + h
          if width < w | let width = w | endif
        endfor
        unlet self.__children_request_size
        let self.__children_request_size = children_request_size

" call forms#log("g:forms#VPoly.requestedSize: " .  string([width, height]))
        if exists("self.__mode")
          let width += 2
          let height += len(self.__children)+1
        endif

" call forms#log("g:forms#VPoly.requestedSize: " .  string([width, height]))
        return [width, height]
      endif
    endfunction
    let g:forms#VPoly.requestedSize  = function("FORMS_VPOLY_requestedSize")

    function! FORMS_VPOLY_drawBoxes() dict
      if exists("self.__mode")
        let a = self.__allocation
        let children_request_size =  self.__children_request_size
        if self.__size < 0
          call forms#DrawVBoxes(self.__mode, a, children_request_size)
        else
          let start = self.__win_start
          let end = start + self.__size
" call forms#log("g:forms#VPoly.drawBoxes: start=".start)
" call forms#log("g:forms#VPoly.drawBoxes: end=".end)
          let crs = children_request_size[start:end]
          call forms#DrawVBoxes(self.__mode, a, crs)
        endif
      endif
    endfunction
    let g:forms#VPoly.drawBoxes  = function("FORMS_VPOLY_drawBoxes")

    function! FORMS_VPOLY_draw(allocation) dict
" call forms#log("g:forms#VPoly.draw" .  string(a:allocation))
      let self.__allocation = a:allocation
      let a = a:allocation

      if self.__status != g:IS_INVISIBLE
        let line = a.line
        let column = a.column
        let width = a.width
        let height = a.height
        let size = self.__size
        let win_start = self.__win_start
        let alignments = self.__alignments
" call forms#log("g:forms#VPoly.draw: size=".size)
" call forms#log("g:forms#VPoly.draw: win_start=".win_start)
" call forms#log("g:forms#VPoly.draw: alignments=".string(alignments))
        let char = ''
        let children = self.__children
        let children_request_size =  self.__children_request_size

        call self.drawBoxes()
        let bdelta = exists("self.__mode") ? 1 : 0
        let bwidth = width - 2*bdelta


        let l:y = bdelta
        let nos_children = len(children)
" call forms#log("g:forms#VPoly.draw: nos_children=".nos_children)

        if size > 0 && nos_children > size
          let endcnt = size
        else
          let endcnt = nos_children
        endif

        let cnt = 0
        while cnt < endcnt
          let child = children[cnt+win_start]
          let [childwidth, childheight] = children_request_size[cnt]
          if childwidth == 0
            let childwidth = bwidth
          endif

          if bwidth > childwidth
            call g:forms_Util.drawHAlign(child, {
                                         \ 'line': line+l:y,
                                         \ 'column': column+bdelta,
                                         \ 'width': bwidth,
                                         \ 'childwidth': childwidth,
                                         \ 'childheight': childheight
                                         \ }, 
                                         \ alignments[cnt], 
                                         \ char)

          else
            call child.draw({
                         \ 'line': line+l:y,
                         \ 'column': column+bdelta,
                         \ 'width': childwidth,
                         \ 'height': childheight
                         \ })
          endif

          let l:y = l:y + childheight + bdelta
          let cnt += 1
        endwhile
      endif
      if self.__status == g:IS_DISABLED
        call AugmentGlyphHilight(self, "DisableHi", a)
      endif                     
    endfunction
    let g:forms#VPoly.draw  = function("FORMS_VPOLY_draw")
  endif

  return g:forms#VPoly
endfunction
" ------------------------------------------------------------ 
" forms#newVPoly: {{{2
"   Create new VPoly 
"  parameters: 
"   attrs  : attributes for initializing new object
" ------------------------------------------------------------ 
function! forms#newVPoly(attrs)
  return forms#loadVPolyPrototype().clone().init(a:attrs)
endfunction


"---------------------------------------------------------------------------
" Deck <- Poly: {{{2
"---------------------------------------------------------------------------
" Children are stacked in the z-axis where only on child is
"   visible at a time.
"   When the children have different widths, then they
"     are displayed based upon the halignment.
"   When the children have different heights, then they
"     are displayed based upon the valignment.
"
" attributes
"   card       : Which card starts on top (default 0)
"   halignment : float align 0-1 or 'L' 'C' 'R'
"   valignment : float align 0-1 or 'T' 'C' 'B'
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms#Deck")
    unlet g:forms#Deck
  endif
endif
function! forms#loadDeckPrototype()
  if !exists("g:forms#Deck")
    let g:forms#Deck = forms#loadPolyPrototype().clone('forms#Deck')
    let g:forms#Deck.__halignment = 'L'
    let g:forms#Deck.__valignment = 'T'
    let g:forms#Deck.__card = 0

    function! FORMS_DECK_init(attrs) dict
      call call(g:forms#Poly.init, [a:attrs], self)

      call g:forms_Util.checkHAlignment(self.__halignment, "Deck.init")
      call g:forms_Util.checkVAlignment(self.__valignment, "Deck.init")

      let card = self.__card
      if card < 0 
        throw "Deck.init: card less than 0 " . card
      elseif card >= len(self.__children)
        throw "Deck.init: card greater than or equal to children count " . card
      endif

      return self
    endfunction
    let g:forms#Deck.init  = function("FORMS_DECK_init")

    function! FORMS_DECK_reinit(attrs) dict
" call forms#log("g:forms#Deck.reinit TOP")
      let oldHAlignment = self.__halignment
      let oldVAlignment = self.__valignment
      let oldCard = self.__card

      let self.__halignment = 'L'
      let self.__valignment = 'T'
      let self.__card = 0

      call call(g:forms#Poly.reinit, [a:attrs], self)

      if oldHAlignment != self.__halignment
        call forms#ViewerRedrawListAdd(self) 
      elseif oldVAlignment != self.__valignment
        call forms#ViewerRedrawListAdd(self) 
      elseif oldCard != self.__card
      endif
    endfunction
    let g:forms#Deck.reinit  = function("FORMS_DECK_reinit")

    "-----------------------------------------------
    " deck methods
    "-----------------------------------------------
    "
    function! FORMS_DECK_getCard() dict
      return self.__card
    endfunction
    let g:forms#Deck.getCard  = function("FORMS_DECK_getCard")

    function! FORMS_DECK_setCard(card) dict
      if a:card < 0 
        throw "Deck.setCard: card less than 0 " . card
      elseif a:card >= len(self.__children)
        throw "Deck.setCard: card greater than or equal to children count " . card
      elseif self.__card != a:card
        " clean up existing card screen attributes
        let children = self.__children
        let child = children[self.__card]
        call child.hide()

        let self.__card = a:card
        if exists("self.__textblock")
" call forms#log("g:forms#Deck.setCard add textblock")
          call forms#ViewerRedrawListAdd(self.__textblock) 
        endif
        call forms#ViewerRedrawListAdd(self) 
      endif
    endfunction
    let g:forms#Deck.setCard  = function("FORMS_DECK_setCard")

    function! FORMS_DECK_requestedSize() dict
      if (self.__status == g:IS_INVISIBLE) 
        return [0,0]
      else
        let children_request_size = []
        let width = 0
        let height = 0
        for child in self.__children
          let [w,h] = child.requestedSize()
          call add(children_request_size, [w,h])
          if width < w | let width = w | endif
          if height < h | let height = h | endif
        endfor
        unlet self.__children_request_size
        let self.__children_request_size = children_request_size

        return [width, height]
      endif
    endfunction
    let g:forms#Deck.requestedSize  = function("FORMS_DECK_requestedSize")

    function! FORMS_DECK_draw(allocation) dict
" call forms#log("g:forms#Deck.draw" .  string(a:allocation))
      let self.__allocation = a:allocation
      let a = a:allocation

      if self.__status != g:IS_INVISIBLE
        let line = a.line
        let column = a.column
        let width = a.width
        let height = a.height
        let halignment = self.__halignment
        let valignment = self.__valignment
        let char = ''

        " Must capture background in a TextBlock
        " Why? 1) Cards have different sizes and 
        " 2) So that when only the deck has changed (and a redraw()
        " rather than a full top down draw is called) its background
        " as well as itself can be put on the Viewer ReDraw list
        if ! exists("self.__textblock")
          let fulllines = getline(line, line+height-1)
          let textblock = []
          for fline in fulllines
            " let pline = fline[column-1 : column+width-2]
            " let pline = fline[column : column+width-2]
            let pline = fline[column : column+width-1]
" call forms#log("g:forms#Deck.draw pline=" . pline . "END")
            call add(textblock, pline)
          endfor
          let attrs = { 
                      \ 'textblock': textblock,
                      \ 'allocation': copy(a:allocation)
                      \ }
          let self.__textblock = forms#newTextBlock(attrs)
        endif

        let card = self.__card
"   call forms#log("g:forms#Deck.draw card=" .  card)
        let children = self.__children
        let child = children[card]
        let [childwidth, childheight] = self.__children_request_size[card]

        call g:forms_Util.drawHVAlign(child, {
                                \ 'line': line,
                                \ 'column': column,
                                \ 'width': width,
                                \ 'height': height,
                                \ 'childwidth': childwidth,
                                \ 'childheight': childheight
                                \ }, 
                                \ halignment, 
                                \ valignment, 
                                \ char)
      endif
      if self.__status == g:IS_DISABLED
        call AugmentGlyphHilight(self, "DisableHi", a)
      endif                     
    endfunction
    let g:forms#Deck.draw  = function("FORMS_DECK_draw")

  endif

  return g:forms#Deck
endfunction
" ------------------------------------------------------------ 
" forms#newDeck: {{{2
"   Create new Deck 
"  parameters: 
"   attrs  : attributes for initializing new object
" ------------------------------------------------------------ 
function! forms#newDeck(attrs)
  return forms#loadDeckPrototype().clone().init(a:attrs)
endfunction

"---------------------------------------------------------------------------
" FixedLayout <- Poly: {{{2
"---------------------------------------------------------------------------
" Children have specific locations.
"
" attributes
"   width : minimum width of glyph
"   height : minimum height of glyph
"   x_positiosn : list of the x (column) positions of each child
"   y_positiosn : list of the y (line) positions of each child
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms#FixedLayout")
    unlet g:forms#FixedLayout
  endif
endif
function! forms#loadFixedLayout()
  if !exists("g:forms#FixedLayout")
    let g:forms#FixedLayout = forms#loadPolyPrototype().clone('forms#FixedLayout')
    let g:forms#FixedLayout.__is_validated = g:self#IS_FALSE
    let g:forms#FixedLayout.__width = -1
    let g:forms#FixedLayout.__height = -1
    let g:forms#FixedLayout.__x_positions = []
    let g:forms#FixedLayout.__y_positions = []

    function! FORMS_FIXED_LAYOUT_reinit(attrs) dict
" call forms#log("g:forms#FixedLayout.reinit TOP")
      let oldWidht = self.__width
      let oldHeight = self.__height

      let self.__width = -1
      let self.__height = -1
      let self.__x_positions = []
      let self.__y_positions = []

      call call(g:forms#Poly.reinit, [a:attrs], self)

      if oldHeight != self.__height
        call forms#PrependUniqueInput({'type': 'ReSize'})
      elseif oldWidht != self.__width
        call forms#PrependUniqueInput({'type': 'ReSize'})
      else
        call forms#ViewerRedrawListAdd(self) 
      endif
    endfunction
    let g:forms#FixedLayout.reinit  = function("FORMS_FIXED_LAYOUT_reinit")

    "-----------------------------------------------
    " glyph methods
    "-----------------------------------------------

    function! FORMS_FIXED_LAYOUT_requestedSize() dict
      if (self.__status == g:IS_INVISIBLE) 
        return [0,0]
      else
        let l:w = self.__width
        let l:h = self.__height

        if !self.__is_validated
          if l:w != -1 || l:h != -1
            let children = self.children()
            let cnt = 0
            while cnt < len(children)
              let child = children[cnt]
              let size = child.requestedSize()
              if l:w != -1 
                if self.__x_positions[cnt] + size[0] > l:w
                  throw "FixedLayout Child width " . cnt . " too large"
                endif
              endif
              if l:h != -1 
                if self.__y_positions[cnt] + size[1] > l:h
                  throw "FixedLayout Child height " . cnt . " too large"
                endif
              endif
              let cnt += 1
            endwhile
          endif
          let self.__is_validated = g:self#IS_TRUE
        endif

        if l:w == -1 || l:h == -1
          " let size = self.super().requestedSize()
          let size = call(self.super().requestedSize, [], self)
          if l:w == -1 
            let l:w = size[0]
          endif
          if l:h == -1
            let l:h = size[1]
          endif
        endif
"   call forms#log("FixedLayout.requestedSize: w=" . l:w . ' h=' . l:h)
        return [l:w, l:h]
      endif
    endfunction
    let g:forms#FixedLayout.requestedSize  = function("FORMS_FIXED_LAYOUT_requestedSize")

    function! FORMS_FIXED_LAYOUT_draw(allocation) dict
" call forms#log("g:forms#FixedLayout.draw" .  string(a:allocation))
      let self.__allocation = a:allocation
      let a = a:allocation

      if self.__status != g:IS_INVISIBLE
        let line = a.line
        let column = a.column
        let width = a.width
        let height = a.height

        " draw children
        let l:children = self.children()
        let l:x_positions = self.__x_positions
        let l:y_positions = self.__y_positions
        let cnt = 0
        while cnt < len(l:children)
          let l:child = l:children[cnt]
          " TODO should child size be cached
          let [childwidth, childheight] = child.requestedSize()
          call l:child.draw({
                          \ 'line': line+l:y_positions[cnt],
                          \ 'column': column+l:x_positions[cnt],
                          \ 'width': childwidth,
                          \ 'height': childheight
                          \ })

          let cnt += 1
        endwhile
      endif
      if self.__status == g:IS_DISABLED
        call AugmentGlyphHilight(self, "DisableHi", a)
      endif                     
" call forms#log("FixedLayout.draw: BOTTOM")
    endfunction
    let g:forms#FixedLayout.draw  = function("FORMS_FIXED_LAYOUT_draw")


    "-----------------------------------------------
    " fixed layout methods
    "-----------------------------------------------
    function! FORMS_FIXED_LAYOUT_getWidth() dict
      return self.__width
    endfunction
    let g:forms#FixedLayout.getWidth  = function("FORMS_FIXED_LAYOUT_getWidth")

    function! FORMS_FIXED_LAYOUT_getHeight() dict
      return self.__height
    endfunction
    let g:forms#FixedLayout.getHeight  = function("FORMS_FIXED_LAYOUT_getHeight")

    function! FORMS_FIXED_LAYOUT_childrenXPositions() dict
      return self.__x_positions
    endfunction
    let g:forms#FixedLayout.childrenXPositions  = function("FORMS_FIXED_LAYOUT_childrenXPositions")

    function! FORMS_FIXED_LAYOUT_childrenYPositions() dict
      return self.__y_positions
    endfunction
    let g:forms#FixedLayout.childrenYPositions  = function("FORMS_FIXED_LAYOUT_childrenYPositions")

    function! FORMS_FIXED_LAYOUT_childrenXPositionAt(index) dict
      return self.__x_positions[index]
    endfunction
    let g:forms#FixedLayout.childrenXPositionAt  = function("FORMS_FIXED_LAYOUT_childrenXPositionAt")

    function! FORMS_FIXED_LAYOUT_childrenYPositionAt(index) dict
      return self.__y_positions[index]
    endfunction
    let g:forms#FixedLayout.childrenYPositionAt  = function("FORMS_FIXED_LAYOUT_childrenYPositionAt")
    
    "-----------------------------------------------
    " poly methods
    "-----------------------------------------------

    function! FORMS_FIXED_LAYOUT_prepend(child, x, y) dict
      " call self.super().prepend(a:child)
      call call(self.super().prepend, [a:child], self)
      call insert(self.__x_positions, a:x)
      call insert(self.__y_positions, a:y)
    endfunction
    let g:forms#FixedLayout.prepend  = function("FORMS_FIXED_LAYOUT_prepend")

    function! FORMS_FIXED_LAYOUT_setAt(child, index, x, y) dict
      call call(self.super().setAt, [a:child, a:index], self)
      let self.__x_positions[a:index] = a:x
      let self.__y_positions[a:index] = a:y
    endfunction
    let g:forms#FixedLayout.setAt  = function("FORMS_FIXED_LAYOUT_setAt")

    function! FORMS_FIXED_LAYOUT_insertAt(child, index, x, y) dict
      " call self.super().insertAt(a:child, a:index)
      call call(self.super().insertAt, [a:child, a:index], self)
      call insert(self.__x_positions, a:x, a:index)
      call insert(self.__y_positions, a:y, a:index)
    endfunction
    let g:forms#FixedLayout.insertAt  = function("FORMS_FIXED_LAYOUT_insertAt")

    function! FORMS_FIXED_LAYOUT_removeAt(index) dict
      " call self.super().removeAt(a:index)
      call call(self.super().removeAt, [a:index], self)
      call remove(self.__x_positions, a:index)
      call remove(self.__y_positions, a:index)
    endfunction
    let g:forms#FixedLayout.removeAt  = function("FORMS_FIXED_LAYOUT_removeAt")

    function! FORMS_FIXED_LAYOUT_append(child, x, y) dict
" call forms#log("FixedLayout.append: TOP")
      " call self.super().append(a:child)
      call call(self.super().append, [a:child], self)
" call forms#log("FixedLayout.append: MID")
      call add(self.__x_positions, a:x)
      call add(self.__y_positions, a:y)
" call forms#log("FixedLayout.append: BOTTOM")
    endfunction
    let g:forms#FixedLayout.append  = function("FORMS_FIXED_LAYOUT_append")

  endif

  return g:forms#FixedLayout
endfunction
" ------------------------------------------------------------ 
" forms#newFixedLayout: {{{2
"   Create new FixedLayout 
"  parameters: 
"   attrs  : attributes for initializing new object
" ------------------------------------------------------------ 
function! forms#newFixedLayout(attrs)
  return forms#loadFixedLayout().clone().init(a:attrs)
endfunction


"---------------------------------------------------------------------------
" MenuBar <- HPoly: {{{2
"---------------------------------------------------------------------------
" Children are buttons that launch menus
"
" attributes
"   menus : list of menu { label: string, menu: menu }
"   full : 1 take full horizontal line, 0 only what is needed
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms#MenuBar")
    unlet g:forms#MenuBar
  endif
endif
function! forms#loadMenuBar()
  if !exists("g:forms#MenuBar")
    let g:forms#MenuBar = forms#loadHPolyPrototype().clone('forms#MenuBar')
    let g:forms#MenuBar.__pos = -1
    let g:forms#MenuBar.__full = 1
    " char to [button position, mnemonic index]
    let g:forms#MenuBar.__mnemonics = {}

    function! FORMS_MENUBAR_init(attrs) dict
" call forms#log("g:forms#MenuBar.init TOP")
      " call call(g:forms#HPoly.init, [a:attrs], self)

      let children = []
      let width_sum = 0

      if ! exists("a:attrs.menus")
        throw "MenuBar.init: must have menus attribute: " . string(a:attrs)
      endif

      let menus = a:attrs.menus
      if type(menus) != g:self#LIST_TYPE
        throw "MenuBar.init: menus attribute must be a List: " . string(menus)
      endif
      if len(menus) < 1
        throw "MenuBar.init: must have at least one menu in menus List: " . string(menus)
      endif

      let mnemonics = self.__mnemonics
      let childCnt = 0
      for imenu in menus
        if type(imenu) != g:self#DICTIONARY_TYPE 
          throw "MenuBar.init: menu must be a Dictionary: " . string(imenu)
        endif
        if ! exists("imenu.label")
          throw "MenuBar.init: menu must have label attribute: " . string(imenu)
        endif

        " Process label
        if type(imenu.label) == g:self#STRING_TYPE
          let label = imenu.label
          let [label, mnemonic, mindex] = s:MakeMenuMnemonic(label)
          let labelGlyph = forms#newLabel({'text': label})
        else
          let label = imenu.label.__text
          let [label, mnemonic, mindex] = s:MakeMenuMnemonic(label)
          let labelGlyph = imenu.label
        endif

" call forms#log("g:forms#MenuBar.init label=". label)

        " Process menu or menuFN
        if exists("menu")
          unlet menu
        elseif exists("MenuFN")
          unlet MenuFN
        endif

        if exists("imenu.menu")
          let menu = imenu.menu
       
          if type(menu) != g:self#DICTIONARY_TYPE
            throw "MenuBar.init: menu.menu must be of type Dictionary: " . string(menu)
          endif
          if ! exists("menu.isKindOf")
            throw "MenuBar.init: menu menu must be a Menu: " . string(menu)
          endif
          if ! menu.isKindOf('forms#Menu')
            throw "MenuBar.init: menu menu must be a Menu: " . string(menu)
          endif

        elseif exists("imenu.menuFN")
          let MenuFN = imenu.menuFN
          if type(MenuFN) != g:self#FUNCREF_TYPE
            throw "MenuBar.init: menu.menuFN must be of type FunctionRef: " . string(MenuFN)
          endif
        else
          throw "MenuBar.init: menu must have menu or menuFN attribute: " . string(imenu)
        endif


        " TODO have a function counter which is appended to funcname
        " just to assure uniqueness
        let funcname = "FN_MB_" . substitute(label,' ','_','g')
" call forms#log("g:forms#MenuBar.init funcname=".funcname)

        " Function to create form holding menu. 
        " Note, form is told NOT to delete the menu when it exits
        let fdef = "function! " . funcname . "(...) dict \n"
        let fdef = fdef .   "call forms#log('" . funcname . " TOP')\n"
        let fdef = fdef .   "let child = self.menubar.__children[self.pos]\n"
        let fdef = fdef .   "let a = child.__allocation \n"
        let fdef = fdef .   "call forms#log('winheight='.winheight(0))\n"
        " Assuming menubar is on line 1 of screen, then drop
        " down ought to be on line 2.
        let fdef = fdef .   "let y = 1\n"
        " This will be wrong if the screen has horizontally scrolled
        let fdef = fdef .   "let x = a.column\n"
        let fdef = fdef .   "if ! exists('self.menu')\n"
        let fdef = fdef .   "  let self.menu = self.menuFN()\n"
        let fdef = fdef .   "endif\n"
        let fdef = fdef .   "let attrs = {'x_screen': x, 'y_screen': y, 'delete': 0, 'body': self.menu}\n"
        " let fdef = fdef .   "call forms#log('attrs='.string(attrs))\n"
        let fdef = fdef .   "let form = forms#newForm(attrs)\n"
        let fdef = fdef .   "call form.run()\n"
        let fdef = fdef .   "redraw\n"
        let fdef = fdef .   "endfunction"
        execute fdef
" call forms#log("g:forms#MenuBar.init fdef=".fdef)

        let action = forms#newAction({ 'execute': function(funcname)})
        if exists('menu')
          let action['menu'] = menu
        elseif exists('MenuFN')
          let action['menuFN'] = MenuFN
        endif
        let action['pos'] = childCnt+1
        let action['menubar'] = self

        let buttonGlyph = forms#newButton({
                                  \ 'tag': label, 
                                  \ 'highlight': 0, 
                                  \ 'body': labelGlyph, 
                                  \ 'action': action})

        let hspace = forms#newHSpace({'size': 1})

        call add(children, hspace)
        call add(children, buttonGlyph)
        let width_sum += 1
        let [w,_] = buttonGlyph.requestedSize()
        let width_sum += w

        " call self.append(hspace)
        " call self.append(buttonGlyph)


        let childCnt += 2

        if has_key(mnemonics, mnemonic)
          throw "MenuBar.init: duplicate mnemonic: " . mnemonic
        endif
        let mnemonics[mnemonic] = [childCnt-1, mindex]
      endfor

      " If MenuBar takes full width, then get current width and
      " the window's width and make a HSpace of the difference
      if self.__full
        let ww = winwidth(0)
        let diff = ww - width_sum
        if diff > 0
          let hspace = forms#newHSpace({'size': diff})
          call add(children, hspace)
        endif
      else
        let hspace = forms#newHSpace({'size': 1})
        call add(children, hspace)
      endif


      let a:attrs['children'] = children
      call call(g:forms#HPoly.init, [a:attrs], self)

      if childCnt > 0 && self.__pos < 0
        let self.__pos = 1
      endif

      return self
    endfunction
    let g:forms#MenuBar.init  = function("FORMS_MENUBAR_init")

    function! FORMS_MENUBAR_reinit(attrs) dict
" call forms#log("g:forms#MenuBar.reinit TOP")
      let oldFull = self.__full

      let self.__pos = -1
      let self.__full = 1
      let self.__mnemonics = {}

      call call(g:forms#HPoly.reinit, [a:attrs], self)

      if oldFull != self.__full
        call forms#ViewerRedrawListAdd(self) 
      endif
    endfunction
    let g:forms#MenuBar.reinit  = function("FORMS_MENUBAR_reinit")

    function! FORMS_MENUBAR_delete(...) dict
      " TODO must delete action functions
      let p = g:forms#MenuBar._prototype
      call call(p.delete, [p], self)
    endfunction
    let g:forms#MenuBar.delete  = function("FORMS_MENUBAR_delete")

    function! FORMS_MENUBAR_canFocus() dict
      return (self.__status == g:IS_ENABLED)
    endfunction
    let g:forms#MenuBar.canFocus  = function("FORMS_MENUBAR_canFocus")

    function! FORMS_MENUBAR_hotspot() dict
      if (self.__status == g:IS_ENABLED)
        let pos = self.__pos
"   call forms#log("g:forms#MenuBar.hotspot pos=" . pos)
        if pos >= 0
          let a = self.__allocation

          let child = self.__children[pos]
          let a = child.__allocation
          call GlyphHilight(child, "MenuHotSpotHi", a)
          call self.highlightMnemonicHotSpot(pos)
        endif
      endif
    endfunction
    let g:forms#MenuBar.hotspot  = function("FORMS_MENUBAR_hotspot")

    function! FORMS_MENUBAR_flash() dict
      if (self.__status == g:IS_ENABLED)
        call FlashRegion(self.__allocation)
      endif
    endfunction
    let g:forms#MenuBar.flash  = function("FORMS_MENUBAR_flash")

    function! FORMS_MENUBAR_handleEvent(event) dict
" call forms#log("g:forms#MenuBar.handleEvent event=" . string(a:event))
      if (self.__status == g:IS_ENABLED)
        let type = a:event.type
        if type == 'Select'
          let a = self.__allocation
          let column = a:event.column
          let line = a:event.line
          let children = self.__children

          let pos = 0
          let found = 0
          for child in children
            if child.canFocus() && child.inAllocation(line, column)
"   call forms#log("g:forms#MenuBar.handleEvent found pos=" . pos)
              let found = 1
              break
            endif

            let pos += 1
          endfor

          if found
            if pos != self.__pos
              call GlyphDeleteHi(self.__children[self.__pos])
              call self.highlightMnemonic(self.__pos)
              let self.__pos = pos
            else
              call children[pos].handleEvent(a:event) 
            endif
          endif

          return 1
        elseif type == 'NewFocus'
          return 1
        elseif type == 'NextFocus'
          call self.doNextFocus()
          return 1
        elseif type == 'PrevFocus'
          call self.doPreviousFocus()
          return 1
        elseif type == 'FirstFocus'
          call self.doFirstFocus()
          return 1
        elseif type == 'LastFocus'
          call self.doLastFocus()
          return 1
        endif
      endif
      return 0
    endfunction
    let g:forms#MenuBar.handleEvent  = function("FORMS_MENUBAR_handleEvent")

    function! FORMS_MENUBAR_handleChar(nr) dict
" call forms#log("g:forms#MenuBar.handleChar")
      let handled = 0
      if (self.__status == g:IS_ENABLED)

        let c = nr2char(a:nr)
        if a:nr == "\<Left>" || 
                \ a:nr == "\<ScrollWheelLeft>" ||
                \ a:nr == "\<Down>" ||
                \ a:nr == "\<ScrollWheelDown>"
          call self.doPreviousFocus()

"   call forms#log("g:forms#MenuBar.handleChar Left pos=" .  self.__pos)
          let handled = 1

        elseif a:nr == "\<Right>" || 
                \ a:nr == "\<ScrollWheelRight>" ||
                \ a:nr == "\<Up>" ||
                \ a:nr == "\<ScrollWheelUp>"
          call self.doNextFocus()

"   call forms#log("g:forms#MenuBar.handleChar Right pos=" .  self.__pos)
          let handled = 1

        elseif c == "\<CR>" || c == "\<Space>"
"   call forms#log("g:forms#MenuBar.handleChar NEW CR pos=" .  self.__pos)
          let children = self.__children
          let focus = children[self.__pos]
          call focus.handleChar(a:nr) 
          let handled = 1

        else
"  call forms#log("g:forms#MenuBar.handleChar else")
          let mnemonics = self.__mnemonics
          if has_key(mnemonics, c)
            let [p,_] = mnemonics[c]
"  call forms#log("g:forms#MenuBar.handleChar HAS MNUMONIC=" .  p)
            if p != self.__pos
              let child = self.__children[self.__pos]
              call GlyphDeleteHi(child)
              call self.highlightMnemonic(self.__pos)
              let self.__pos = p
              let handled = 1
            endif
          endif
        endif
      endif

      return handled
    endfunction
    let g:forms#MenuBar.handleChar  = function("FORMS_MENUBAR_handleChar")

    function! FORMS_MENUBAR_doPreviousFocus() dict
      call self.doFocus(self.getPreviousFocus())
    endfunction
    let g:forms#MenuBar.doPreviousFocus  = function("FORMS_MENUBAR_doPreviousFocus")
    
    function! FORMS_MENUBAR_doNextFocus() dict
      call self.doFocus(self.getNextFocus())
    endfunction
    let g:forms#MenuBar.doNextFocus  = function("FORMS_MENUBAR_doNextFocus")

    function! FORMS_MENUBAR_doFirstFocus() dict
      call self.doFocus(self.getFirstFocus())
    endfunction
    let g:forms#MenuBar.doFirstFocus  = function("FORMS_MENUBAR_doFirstFocus")

    function! FORMS_MENUBAR_doLastFocus() dict
      call self.doFocus(self.getLastFocus())
    endfunction
    let g:forms#MenuBar.doLastFocus  = function("FORMS_MENUBAR_doLastFocus")

    function! FORMS_MENUBAR_doFocus(pos) dict
      if a:pos < 0
        call self.flash()
      else
        call GlyphDeleteHi(self.__children[self.__pos])
        call self.highlightMnemonic(self.__pos)
        let self.__pos = a:pos
      endif
    endfunction
    let g:forms#MenuBar.doFocus  = function("FORMS_MENUBAR_doFocus")


    function! FORMS_MENUBAR_getPreviousFocus() dict
      let pos = self.__pos
      let children = self.__children

      let cnt = pos - 1
      while cnt >= 0
        if children[cnt].canFocus()
          return cnt
        endif

        let cnt -= 1
      endwhile
      
      return -1
    endfunction
    let g:forms#MenuBar.getPreviousFocus  = function("FORMS_MENUBAR_getPreviousFocus")

    function! FORMS_MENUBAR_getNextFocus() dict
      let pos = self.__pos
      let children = self.__children
      let len = len(children)

      let cnt = pos + 1
      while cnt < len
        if children[cnt].canFocus()
          return cnt
        endif

        let cnt += 1
      endwhile
      
      return -1
    endfunction
    let g:forms#MenuBar.getNextFocus  = function("FORMS_MENUBAR_getNextFocus")

    function! FORMS_MENUBAR_getFirstFocus() dict
      let children = self.__children
      let len = len(children)

      let cnt = 0
      while cnt < len
        if children[cnt].canFocus()
          return cnt
        endif

        let cnt += 1
      endwhile
      
      return -1
    endfunction
    let g:forms#MenuBar.getFirstFocus  = function("FORMS_MENUBAR_getFirstFocus")

    function! FORMS_MENUBAR_getLastFocus() dict
      let children = self.__children
      let len = len(children)

      let cnt = len - 1
      while cnt >= 0
        if children[cnt].canFocus()
          return cnt
        endif

        let cnt -= 1
      endwhile
      
      return -1
    endfunction
    let g:forms#MenuBar.getLastFocus  = function("FORMS_MENUBAR_getLastFocus")

    function! FORMS_MENUBAR_highlightMnemonic(pos) dict
      let child = self.__children[a:pos]
      let mnemonics = self.__mnemonics
      for [pos, mindex] in values(mnemonics)
        if pos == a:pos
          let a = child.__allocation
          call GlyphHilight(child, "MenuMnemonicHi", {
                                      \ 'line': a.line,
                                      \ 'column': a.column+mindex,
                                      \ 'width': 1,
                                      \ 'height': 1
                                      \ })
          break
        endif
      endfor
    endfunction
    let g:forms#MenuBar.highlightMnemonic  = function("FORMS_MENUBAR_highlightMnemonic")

    function! FORMS_MENUBAR_highlightMnemonicHotSpot(pos) dict
      let child = self.__children[a:pos]
      let mnemonics = self.__mnemonics
      for [pos, mindex] in values(mnemonics)
        if pos == a:pos
          let a = child.__allocation
          call AugmentGlyphHilight(child, "MenuMnemonicHotSpotHi", {
                                      \ 'line': a.line,
                                      \ 'column': a.column+mindex,
                                      \ 'width': 1,
                                      \ 'height': 1
                                      \ })
          break
        endif
      endfor
    endfunction
    let g:forms#MenuBar.highlightMnemonicHotSpot  = function("FORMS_MENUBAR_highlightMnemonicHotSpot")


    function! FORMS_MENUBAR_draw(allocation) dict
" call forms#log("g:forms#MenuBar.draw" .  string(a:allocation))
      let self.__allocation = a:allocation
      let a = a:allocation

      if self.__status != g:IS_INVISIBLE
        let line = a.line
        let column = a.column
        let width = a.width
        let height = a.height

        let str = repeat(' ', width)
        call forms#SetStringAt(str, line, column)

        call GlyphHilight(self, "MenuHi", a)
"call forms#log("g:forms#MenuBar.draw: line('$')=" .  line('$'))

        " TODO must delete action functions
        let p = g:forms#MenuBar._prototype
        call call(p.draw, [a], self)

"call forms#log("g:forms#MenuBar.draw: line('$')=" .  line('$'))
        let children = self.__children
        let mnemonics = self.__mnemonics
        for [pos, mindex] in values(mnemonics)
" call forms#log("g:forms#MenuBar.draw: pos=" .  pos . ", mindex=" . mindex)
          let child = children[pos]
          let a = child.__allocation
          call GlyphHilight(child, "MenuMnemonicHi", {
                                        \ 'line': a.line,
                                        \ 'column': a.column+mindex,
                                        \ 'width': 1,
                                        \ 'height': 1
                                        \ })
        endfor
      endif
      if self.__status == g:IS_DISABLED
        call AugmentGlyphHilight(self, "DisableHi", a)
      endif                     

    endfunction
    let g:forms#MenuBar.draw  = function("FORMS_MENUBAR_draw")

    function! FORMS_MENUBAR_usage() dict
      return [
           \ "A MenuBar displays buttons for pop down sub-menus.",
           \ "Navigation between MenuBar buttons using keyboard",
           \ "  <Left> and <Right>, as well as a mouse scroll wheel.",
           \ "  Additionally, button labels can have a mnemonic which",
           \ "  is the underlined character.",
           \ "Selection is with keyboard <CR> or <Space>,",
           \ "  or with a mouse <LeftMouse> click."
           \ ]
    endfunction
    let g:forms#MenuBar.usage  = function("FORMS_MENUBAR_usage")

  endif

  return g:forms#MenuBar
endfunction
" ------------------------------------------------------------ 
" forms#newMenuBar: {{{2
"   Create new MenuBar 
"  parameters: 
"   attrs  : attributes for initializing new object
" ------------------------------------------------------------ 
function! forms#newMenuBar(attrs)
  return forms#loadMenuBar().clone().init(a:attrs)
endfunction

"---------------------------------------------------------------------------
" Menu <- VPoly: {{{2
"---------------------------------------------------------------------------
" Children are: buttons, checkboxes, radiobuttons and submenus
"
" attributes
"   items : list of menu items types 
"     type == 'separator'
"     type == 'label'
"     type == 'button'
"     type == 'checkbox'
"     type == 'radiobuttons'
"     type == 'menu'
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms#Menu")
    unlet g:forms#Menu
  endif
endif
function! forms#loadMenuPrototype()
  if !exists("g:forms#Menu")
    let g:forms#Menu = forms#loadVPolyPrototype().clone('forms#Menu')
    let g:forms#Menu.__pos = -1
    let g:forms#Menu.__focuslist = []
    " map char to list of pairs of [button position, mnemonic index]
    let g:forms#Menu.__mnemonics = {}
    let g:forms#Menu.__required_left_space = 0

    function! FORMS_MENU_init(attrs) dict
" call forms#log("g:forms#Menu.init TOP")
      " call call(g:forms#VPoly.init, [a:attrs], self)

      if ! exists("a:attrs.items")
        throw "Menu.init: must have items attribute: " . string(a:attrs)
      endif

      let items = a:attrs.items
      if type(items) != g:self#LIST_TYPE
        throw "Menu.init: items attribute must be a List: " . string(items)
      endif
      if len(items) < 1
        throw "Menu.init: must have at least one item in items List: " . string(items)
      endif

      let requires_extra_left_hspace = 0
      let max_width = 0

      " check attributes are valid and complete
      for item in items
        if type(item) != g:self#DICTIONARY_TYPE 
          throw "Menu.init: item must be a Dictionary: " . string(item)
        endif
        if ! exists("item.type")
          throw "Menu.init: item must have type attribute: " . string(item)
        endif

        let type = item.type
" call forms#log("g:forms#Menu.init type=" . type)
        if type == 'separator'
          " no sub attributes

        elseif type == 'label'
          if ! exists("item.label")
            throw "Menu.init: label item must have label attribute: " . string(item)
          endif
          if type(item.label) == g:self#STRING_TYPE
            let llen = len(item.label)
          else
            let llen = len(item.label.__text)
          endif

          if llen > max_width
            let max_width = llen
          endif

        elseif type == 'button'
          if ! exists("item.label")
            throw "Menu.init: button item must have label attribute: " . string(item)
          endif
          if ! exists("item.action") && ! exists("item.command")
            throw "Menu.init: button item must have action or command attribute: " . string(item)
          endif
          if type(item.label) == g:self#STRING_TYPE
            let llen = len(item.label)
          else
            let llen = len(item.label.__text)
          endif
          if exists("item.hint")
            if type(item.hint) == g:self#STRING_TYPE
              let llen += len(item.hint) + 1
            else
              throw "Menu.init: optional button item hint must type String: " . string(item)
            endif
          endif

          if llen > max_width
            let max_width = llen
          endif
          
        elseif type == 'checkbox'
          if ! exists("item.label")
            throw "Menu.init: checkbox item must have label attribute: " . string(item)
          endif
          if ! exists("item.tag")
            throw "Menu.init: checkbox item must have tag attribute: " . string(item)
          endif
          if type(item.label) == g:self#STRING_TYPE
            let llen = len(item.label)
          else
            let llen = len(item.label.__text)
          endif

          if llen > max_width
            let max_width = llen
          endif
          let requires_extra_left_hspace = 1

        elseif type == 'radiobutton'
          if ! exists("item.label")
            throw "Menu.init: radiobutton item must have label attribute: " . string(item)
          endif
          if ! exists("item.group")
            throw "Menu.init: radiobutton item must have group attribute: " . string(item)
          endif
          if ! exists("item.tag")
            throw "Menu.init: radiobutton item must have tag attribute: " . string(item)
          endif
          if type(item.label) == g:self#STRING_TYPE
            let llen = len(item.label)
          else
            let llen = len(item.label.__text)
          endif

          let requires_extra_left_hspace = 1
          if llen > max_width
            let max_width = llen
          endif

        elseif type == 'menu'
          if ! exists("item.label")
            throw "Menu.init: menu item must have label attribute: " . string(item)
          endif
          if exists("item.menu")
            let menu = item.menu
       
            if type(menu) != g:self#DICTIONARY_TYPE
              throw "Menu.init: item menu must be of type Dictionary: " . string(menu)
            endif
            if ! exists("menu.isKindOf")
              throw "Menu.init: item menu must be a Menu: " . string(menu)
            endif
            if ! menu.isKindOf('forms#Menu')
              throw "Menu.init: item menu must be a Menu: " . string(menu)
            endif

          elseif exists("item.menuFN")
            let MenuFN = item.menuFN
            if type(MenuFN) != g:self#FUNCREF_TYPE
              throw "Menu.init: item.menuFN must be of type FunctionRef: " . string(MenuFN)
            endif
          else
            throw "Menu.init: item menu must have menu or menuFN attribute: " . string(imenu)
          endif
          if type(item.label) == g:self#STRING_TYPE
            let llen = len(item.label) + 1
          else
            let llen = len(item.label.__text) + 1
          endif

          if llen > max_width
            let max_width = llen
          endif

        else
          throw "Menu.init: bad item type: " . type
        endif

      endfor
     

      let flist = self.__focuslist
      let mnemonics = self.__mnemonics
      let max_width += 1

      let children = []

      " build menu components
      let cnt = 0
      for item in items
        let mnemonic = ''
        let mindex = -1

        let type = item.type
        if type == 'separator'
          let char = (&encoding == 'utf-8') 
                        \ ?  b:forms_BDLightHorizontal 
                        \ : b:forms_horz
          let itemGlyph = forms#newHLine({'char': char})
          call add(flist, {'canfocus': 0})

        elseif type == 'label'
          if type(item.label) == g:self#STRING_TYPE
            let llen = len(item.label)
            let labelGlyph = forms#newLabel({'text': item.label})
          else
            let llen = len(item.label.__text)
            let labelGlyph = item.label
          endif

          let item_children = []

          if requires_extra_left_hspace 
            let hspace = forms#newHSpace({'size': 4})
            call add(item_children, hspace)
          else
            let hspace = forms#newHSpace({'size': 1})
            call add(item_children, hspace)
          endif

          call add(item_children, labelGlyph)

          if llen < max_width
            let hspace = forms#newHSpace({'size': (max_width - llen)})
            call add(item_children, hspace)
          endif

          if len(item_children) > 1
            let itemGlyph = forms#newHPoly({ 'children': item_children})
          else
            " TODO remove
            unlet item_children
            let itemGlyph = labelGlyph
          endif

          call add(flist, {'canfocus': 0})

        elseif type == 'button'
          let buttonAttrs = {'highlight': 0}

          if exists("item.action") 
            let buttonAttrs.action = item.action
          else
            let buttonAttrs.command = item.command
          endif

          if type(item.label) == g:self#STRING_TYPE
            let llen = len(item.label)
            let [label, mnemonic, mindex] = s:MakeMenuMnemonic(item.label)
            let labelGlyph = forms#newLabel({'text': label})
            let buttonAttrs.tag = label
          else
            let llen = len(item.label.__text)
            let [label, mnemonic, mindex] = s:MakeMenuMnemonic(item.label.__text)
" call forms#log("g:forms#Menu.init button label=" . label)
            let labelGlyph = item.label
            let labelGlyph.__text = label
            let buttonAttrs.tag = label
          endif
          if exists("item.hint") 
            let llen += len(item.hint) + 1
          endif


          let item_children = []

          if requires_extra_left_hspace 
            let hspace = forms#newHSpace({'size': 4})
            call add(item_children, hspace)
          else
            let hspace = forms#newHSpace({'size': 1})
            call add(item_children, hspace)
          endif

          let buttonAttrs.body = labelGlyph
          let buttonGlyph = forms#newButton(buttonAttrs)
          call add(item_children, buttonGlyph)

          if exists("item.hint") 
            if llen < max_width
              let hspace = forms#newHSpace({'size': (max_width - llen)+1 })
              call add(item_children, hspace)
            endif
            let hintLabelGlyph = forms#newLabel({'text': item.hint})
            call add(item_children, hintLabelGlyph)
          else
            if llen < max_width
              let hspace = forms#newHSpace({'size': (max_width - llen)})
              call add(item_children, hspace)
            endif
          endif

          if len(item_children) > 1
            let itemGlyph = forms#newHPoly({ 'children': item_children})
          else
            " TODO remove
            unlet item_children
            let itemGlyph = buttonGlyph
          endif

          call add(flist, {'canfocus': 1, 'target': buttonGlyph})
          if self.__pos == -1
            let self.__pos = cnt
          endif

        elseif type == 'checkbox'
          let tag = item.tag
          if type(item.label) == g:self#STRING_TYPE
            let llen = len(item.label)
            let [label, mnemonic, mindex] = s:MakeMenuMnemonic(item.label)
            let labelGlyph = forms#newLabel({'text': label})
          else
            let llen = len(item.label.__text)
            let labelGlyph = item.label
            let [label, mnemonic, mindex] = s:MakeMenuMnemonic(item.label.__text)
          endif

          let item_children = []
          let hspace = forms#newHSpace({'size': 1})
          call add(item_children, hspace)

          let checkbox = forms#newCheckBox({'tag': tag})
          let cblGlyph = forms#newHPoly({ 'children': 
                                  \ [checkbox, labelGlyph]})
          call add(item_children, cblGlyph)

          if llen < max_width
            let hspace = forms#newHSpace({'size': (max_width - llen)})
            call add(item_children, hspace)
          endif

          if len(item_children) > 1
            let itemGlyph = forms#newHPoly({ 'children': item_children})
          else
            " TODO remove
            unlet item_children
            let itemGlyph = cblGlyph
          endif

          call add(flist, {'canfocus': 1, 'target': checkbox})
          if self.__pos == -1
            let self.__pos = cnt
          endif

        elseif type == 'radiobutton'
          let selected = exists("item.selected") ?  item.selected : 0
          let tag = item.tag
          let group = item.group
          if type(item.label) == g:self#STRING_TYPE
            let llen = len(item.label)
            let [label, mnemonic, mindex] = s:MakeMenuMnemonic(item.label)
            let labelGlyph = forms#newLabel({'text': label})
          else
            let llen = len(item.label.__text)
            let labelGlyph = item.label
            let [label, mnemonic, mindex] = s:MakeMenuMnemonic(item.label.__text)
          endif

          let item_children = []
          let hspace = forms#newHSpace({'size': 1})
          call add(item_children, hspace)

          let radiobutton = forms#newRadioButton({
                                    \ 'tag': tag, 
                                    \ 'selected': selected, 
                                    \ 'group': group})
          let rblGlyph = forms#newHPoly({ 'children': 
                                  \ [radiobutton, labelGlyph]})
          call add(item_children, rblGlyph)

          if llen < max_width
            let hspace = forms#newHSpace({'size': (max_width - llen)})
            call add(item_children, hspace)
          endif

          if len(item_children) > 1
            let itemGlyph = forms#newHPoly({ 'children': item_children})
          else
            " TODO remove
            unlet item_children
            let itemGlyph = rblGlyph
          endif

          call add(flist, {'canfocus': 1, 'target': radiobutton})
          if self.__pos == -1
            let self.__pos = cnt
          endif

        elseif type == 'menu'
          if type(item.label) == g:self#STRING_TYPE
            let label = item.label
" call forms#log("g:forms#Menu.init menu.label=" . label)
            let llen = len(item.label)
            let [label, mnemonic, mindex] = s:MakeMenuMnemonic(item.label)
            let labelGlyph = forms#newLabel({'text': label})
          else
            let text = item.label.__text
" call forms#log("g:forms#Menu.init menu.label.__text=" . text)
            let llen = len(text)
            let [label, mnemonic, mindex] = s:MakeMenuMnemonic(text)
            let labelGlyph = item.label
            let labelGlyph.__text = label
          endif
" call forms#log("g:forms#Menu.init labelGlyph.__text=" . labelGlyph.__text)


          let item_children = []
          if requires_extra_left_hspace 
            let hspace = forms#newHSpace({'size': 4})
            call add(item_children, hspace)
          else
            let hspace = forms#newHSpace({'size': 1})
            call add(item_children, hspace)
          endif

          " Process submenu or SubMenuFN
          if exists("submenu")
            unlet submenu
          elseif exists("SubMenuFN")
            unlet SubMenuFN
          endif

          if exists("item.menu")
            let submenu = item.menu
         
            if type(submenu) != g:self#DICTIONARY_TYPE
              throw "Menu.init: menu.submenu must be of type Dictionary: " . string(submenu)
            endif
            if ! exists("submenu.isKindOf")
              throw "Menu.init: menu submenu must be a Menu: " . string(submenu)
            endif
            if ! submenu.isKindOf('forms#Menu')
              throw "Menu.init: menu submenu must be a Menu: " . string(submenu)
            endif

          elseif exists("item.menuFN")
            let SubMenuFN = item.menuFN
            if type(SubMenuFN) != g:self#FUNCREF_TYPE
              throw "Menu.init: menu.menuFN must be of type FunctionRef: " . string(SubMenuFN)
            endif
          else
            throw "Menu.init: menu must have menu or menuFN attribute: " . string(item)
          endif

          " TODO have a function counter which is appended to funcname
          " just to assure uniqueness
          let funcname = "FN_M_" . substitute(label,' ','_','g')
" call forms#log("g:forms#Menu.init funcname=".funcname)

          " Function to create form holding submenu. 
          " Note, form is told NOT to delete the submenu when it exits
          let fdef = "function! " . funcname . "(...) dict \n"
          " let fdef = fdef .   "call forms#log('" . funcname . " TOP')\n"
          let fdef = fdef .   "let child = self.menu.__children[self.pos]\n"
          let fdef = fdef .   "let a = child.__allocation \n"
          let fdef = fdef .   "call forms#log('a='.string(a))\n"
          let fdef = fdef .   "if ! exists('self.submenu')\n"
          let fdef = fdef .   "  let self.submenu = self.submenuFN()\n"
          let fdef = fdef .   "endif\n"
          let fdef = fdef .   "let y=a.line-line('w0')\n"
          " This will be wrong if the screen has horizontally scrolled
          let fdef = fdef .   "let x=a.column+a.width\n"
          let fdef = fdef .   "let attrs = {'x_screen': x, 'y_screen': y, 'delete': 0, 'body': self.submenu}\n"
          " let fdef = fdef .   "call forms#log('attrs='.string(attrs))\n"
          let fdef = fdef .   "let form = forms#newForm(attrs)\n"
          let fdef = fdef .   "call form.run()\n"
          let fdef = fdef .   "redraw\n"
          let fdef = fdef .   "endfunction"
          execute fdef
" call forms#log("g:forms#Menu.init fdef=".fdef)

          let action = forms#newAction({ 'execute': function(funcname)})
          if exists('submenu')
            let action['submenu'] = submenu
          elseif exists('SubMenuFN')
            let action['submenuFN'] = SubMenuFN
          endif
          let action['pos'] = cnt
          let action['menu'] = self

          let buttonGlyph = forms#newButton({
                                  \ 'tag': label, 
                                  \ 'highlight': 0, 
                                  \ 'body': labelGlyph, 
                                  \ 'action': action})

          call add(item_children, buttonGlyph)

          if llen < max_width
            let hspace = forms#newHSpace({'size': (max_width - llen)})
            call add(item_children, hspace)
          endif

          let submenuLabelGlyph = forms#newLabel({'text': '>'})
          call add(item_children, submenuLabelGlyph)

          if len(item_children) > 1
            let itemGlyph = forms#newHPoly({ 'children': item_children})
          else
            " TODO remove
            unlet item_children
            let itemGlyph = buttonGlyph
          endif

          call add(flist, {'canfocus': 1, 'target': buttonGlyph})
          if self.__pos == -1
            let self.__pos = cnt
          endif

        else
          throw "Menu.init: bad item type: " . type
        endif

        call add(children, itemGlyph)
        " call self.append(itemGlyph)

        if mindex != -1
          if has_key(mnemonics, mnemonic)
            let pairs = mnemonics[mnemonic] 
            call add(pairs, [cnt, mindex])
          else
            let mnemonics[mnemonic] = [[cnt, mindex]]
          endif
        endif


        let cnt += 1
      endfor

      let a:attrs['children'] = children
      call call(g:forms#VPoly.init, [a:attrs], self)

      if requires_extra_left_hspace 
        let self.__required_left_space = 4
      else
        let self.__required_left_space = 1
      endif

      if self.__size < 0
        let max = winheight(0) - 2
        if max <= len(self.__children)
          let self.__size = max
        endif
      endif

" call forms#log("g:forms#Menu.init mnemonics=" . string(mnemonics))

      return self
    endfunction
    let g:forms#Menu.init  = function("FORMS_MENU_init")

    function! FORMS_MENU_reinit(attrs) dict
" call forms#log("g:forms#Menu.reinit TOP")
      let oldRLS = self.__required_left_space

      let self.__pos = -1
      let self.__focuslist = []
      let self.__mnemonics = {}
      let self.__required_left_space = 0

      call call(g:forms#VPoly.reinit, [a:attrs], self)

      if oldRLS != self.__required_left_space
        call forms#PrependUniqueInput({'type': 'ReSize'})
      endif
    endfunction
    let g:forms#Menu.reinit  = function("FORMS_MENU_reinit")

    function! FORMS_MENU_requestedSize() dict
      let [w,h] = call(g:forms#VPoly.requestedSize, [], self)
      if self.__size < 0
        return [w, h]
      else
        return [w, self.__size]
      endif
    endfunction
    let g:forms#Menu.requestedSize  = function("FORMS_MENU_requestedSize")

    "-----------------------------------------------
    " status method
    "-----------------------------------------------
    
    function! FORMS_MENU_setChildStatus(index, status) dict
" call forms#log("g:forms#Menu.setChildStatus TOP")
      let child = self.__children[a:index]
      let oldstatus = child.__status
      if oldstatus != a:status
        " TODO call super setStatus
        let child.__status = a:status
" call forms#log("g:forms#Menu.setChildStatus new status=" . a:status)

        let flist = self.__focuslist
        if a:status == g:IS_ENABLED
          let flist[a:index].canfocus = 1
        elseif a:status == g:IS_DISABLED
          let flist[a:index].canfocus = 0
        else
          let flist[a:index].canfocus = 0
        endif
        " If we are changing status on focus, then get next focus
        if self.__pos == a:index
          let self.__pos = self.getNextFocus()
        endif
      endif
    endfunction
    let g:forms#Menu.setChildStatus  = function("FORMS_MENU_setChildStatus")

    function! FORMS_MENU_canFocus() dict
      return (self.__status == g:IS_ENABLED)
    endfunction
    let g:forms#Menu.canFocus  = function("FORMS_MENU_canFocus")

    function! FORMS_MENU_hotspot() dict
      if (self.__status == g:IS_ENABLED)
        let pos = self.__pos
" call forms#log("g:forms#Menu.hotspot pos=" . pos)
        if pos >= 0
          let a = self.__allocation
          let line = a.line
          let column = a.column

          let child = self.__children[pos]
          let a = child.__allocation
"call forms#log("g:forms#Menu.hotspot pos=" . pos)
"call forms#log("g:forms#Menu.hotspot a=" . string(a))
          call GlyphHilight(child, "MenuHotSpotHi", a)
          call self.highlightMnemonicHotSpot(pos)
        endif
      endif
    endfunction
    let g:forms#Menu.hotspot  = function("FORMS_MENU_hotspot")

    function! FORMS_MENU_flash() dict
      if (self.__status == g:IS_ENABLED)
        call FlashRegion(self.__allocation)
      endif
    endfunction
    let g:forms#Menu.flash  = function("FORMS_MENU_flash")

    function! FORMS_MENU_handleEvent(event) dict
" call forms#log("g:forms#Menu.handleEvent event=" . string(a:event))
      if (self.__status == g:IS_ENABLED)
        let type = a:event.type
        if type == 'Select'
          let a = self.__allocation
          let line = a:event.line
          let diff = line - a.line
          let pos = self.__win_start + diff
"call forms#log("g:forms#Menu.handleEvent pos=" . pos)

          " adjust for invisible children
          let totalcnt = 0
          let seencnt = 0
          while seencnt <= pos
            if self.__children[totalcnt].__status != g:IS_INVISIBLE
              let seencnt += 1
            endif
            let totalcnt += 1
          endwhile
          let pos = totalcnt-1
"call forms#log("g:forms#Menu.handleEvent pos=" . pos)

          let flist = self.__focuslist
          if flist[pos].canfocus
            if pos != self.__pos
              call GlyphDeleteHi(self.__children[self.__pos])
              call self.highlightMnemonic(self.__pos)
              let self.__pos = pos
            else
              call flist[pos].target.handleEvent(a:event) 
            endif
          endif
          return 1
        elseif type == 'NewFocus'
          return 1
        elseif type == 'NextFocus'
          call self.doNextFocus()
          return 1
        elseif type == 'PrevFocus'
          call self.doPreviousFocus()
          return 1
        elseif type == 'FirstFocus'
          call self.doFirstFocus()
          return 1
        elseif type == 'LastFocus'
          call self.doLastFocus()
          return 1

        endif
      endif
      return 0
    endfunction
    let g:forms#Menu.handleEvent  = function("FORMS_MENU_handleEvent")

    function! FORMS_MENU_handleChar(nr) dict
" call forms#log("g:forms#Menu.handleChar")
      let handled = 0
      if (self.__status == g:IS_ENABLED)
        let c = nr2char(a:nr)
        if a:nr == "\<Up>" || a:nr == "\<ScrollWheelUp>"
          call self.doPreviousFocus()
" call forms#log("g:forms#Menu.handleChar Up pos=" .  self.__pos)
          let handled = 1

        elseif a:nr == "\<Down>" || a:nr == "\<ScrollWheelDown>"
          call self.doNextFocus()
" call forms#log("g:forms#Menu.handleChar Down pos=" .  self.__pos)
          let handled = 1

        elseif a:nr == "\<PageDown>" || 
            \ a:nr == "\<S-ScrollWheelDown>" ||
            \ a:nr == "\<C-ScrollWheelDown>"
" call forms#log("g:forms#Menu.handleChar PageDown pos=" .  self.__pos)
          call self.doPageDown()
          let handled = 1

        elseif a:nr == "\<PageUp>" ||
            \ a:nr == "\<S-ScrollWheelUp>" ||
            \ a:nr == "\<C-ScrollWheelUp>"
" call forms#log("g:forms#Menu.handleChar PageUp pos=" .  self.__pos)
          call self.doPageUp()
          let handled = 1

        elseif c == "\<CR>" || c == "\<Space>"
"   call forms#log("g:forms#Menu.handleChar NEW CR pos=" .  self.__pos)
          let flist = self.__focuslist
          let focus = flist[self.__pos]
          call focus.target.handleChar(a:nr) 
          let handled = 1

        else
"   call forms#log("g:forms#Menu.handleChar else")
          let mnemonics = self.__mnemonics
          if has_key(mnemonics, c)
            let pairs = mnemonics[c]
"   call forms#log("g:forms#Menu.handleChar HAS MNUMONIC=" .  string(pairs))
            let plen = len(pairs)
            if plen == 1
              let [p,_] = pairs[0]
              if p != self.__pos
                let child = self.__children[self.__pos]
                call GlyphDeleteHi(child)
                call self.highlightMnemonic(self.__pos)
                let self.__pos = p
                let handled = 1
              endif
            else
              let cnt = 0
              while cnt < plen
                let [p,_] = pairs[cnt]
                if p != self.__pos
                  let child = self.__children[self.__pos]
                  call GlyphDeleteHi(child)
                  call self.highlightMnemonic(self.__pos)
                  let self.__pos = p
                  let handled = 1
                  break
                endif

                let cnt += 1
              endwhile
            endif
          endif

        endif
      endif

      let needs_redraw = g:self#IS_FALSE
      let size = self.__size
      let pos = self.__pos
      if size > 0
        if pos >= self.__win_start + size
          while pos >= self.__win_start + size
            let self.__win_start += 1
            let needs_redraw = g:self#IS_TRUE
          endwhile
        elseif self.__win_start > 0 && pos < self.__win_start
          while self.__win_start > 0 && pos < self.__win_start
            let self.__win_start -= 1
            let needs_redraw = g:self#IS_TRUE
          endwhile
        endif
      endif

" call forms#log("g:forms#Menu.handleChar win_start=" .  self.__win_start)
      if needs_redraw
" call forms#log("g:forms#Menu.handleChar needs_redraw")
        call forms#ViewerRedrawListAdd(self)
      endif


      return handled
    endfunction
    let g:forms#Menu.handleChar  = function("FORMS_MENU_handleChar")

    function! FORMS_MENU_doPageDown() dict
      let size = self.__size
      if size > 0
        let p = self.getNextFocus()
        if p == -1 
          call self.flash()
        else
          call GlyphDeleteHi(self.__children[self.__pos])
          let self.__pos = p
          let cnt = 1
          while cnt < size
            let p = self.getNextFocus()
            if p == -1 
              break
            else
              let self.__pos = p
            endif

            let cnt += 1
          endwhile
        endif
      else
        call self.flash()
      endif
    endfunction
    let g:forms#Menu.doPageDown  = function("FORMS_MENU_doPageDown")

    function! FORMS_MENU_doPageUp() dict
      let size = self.__size
      if size > 0
" call forms#log("g:forms#Menu.doPageUp pos=" .  self.__pos)
        let p = self.getPreviousFocus()
" call forms#log("g:forms#Menu.doPageUp p=" .  p)
        if p == -1
          call self.flash()
        else
          call GlyphDeleteHi(self.__children[self.__pos])
          let self.__pos = p
          let cnt = 1
          while cnt < size
            let p = self.getPreviousFocus()
" call forms#log("g:forms#Menu.doPageUp p=" .  p)
            if p == -1 
              break
            else
              let self.__pos = p
            endif

            let cnt += 1
          endwhile
        endif
      else
        call self.flash()
      endif
    endfunction
    let g:forms#Menu.doPageUp  = function("FORMS_MENU_doPageUp")

    function! FORMS_MENU_doPreviousFocus() dict
      call self.doFocus(self.getPreviousFocus())
    endfunction
    let g:forms#Menu.doPreviousFocus  = function("FORMS_MENU_doPreviousFocus")
    
    function! FORMS_MENU_doNextFocus() dict
      call self.doFocus(self.getNextFocus())
    endfunction
    let g:forms#Menu.doNextFocus  = function("FORMS_MENU_doNextFocus")

    function! FORMS_MENU_doFirstFocus() dict
      call self.doFocus(self.getFirstFocus())
    endfunction
    let g:forms#Menu.doFirstFocus  = function("FORMS_MENU_doFirstFocus")

    function! FORMS_MENU_doLastFocus() dict
      call self.doFocus(self.getLastFocus())
    endfunction
    let g:forms#Menu.doLastFocus  = function("FORMS_MENU_doLastFocus")

    function! FORMS_MENU_doFocus(pos) dict
      if a:pos < 0
        call self.flash()
      else
        if self.__pos >= 0
          call GlyphDeleteHi(self.__children[self.__pos])
        endif
        call self.highlightMnemonic(self.__pos)
        let self.__pos = a:pos
      endif
    endfunction
    let g:forms#Menu.doFocus  = function("FORMS_MENU_doFocus")

    function! FORMS_MENU_getPreviousFocus() dict
      let pos = self.__pos
      let flist = self.__focuslist

      let cnt = pos - 1
      while cnt >= 0
        if flist[cnt].canfocus
          return cnt
        endif

        let cnt -= 1
      endwhile
      
      return -1
    endfunction
    let g:forms#Menu.getPreviousFocus  = function("FORMS_MENU_getPreviousFocus")

    function! FORMS_MENU_getNextFocus() dict
      let pos = self.__pos
      let flist = self.__focuslist
      let len = len(flist)

      let cnt = pos + 1
      while cnt < len
        if flist[cnt].canfocus
          return cnt
        endif

        let cnt += 1
      endwhile
      
      return -1
    endfunction
    let g:forms#Menu.getNextFocus  = function("FORMS_MENU_getNextFocus")

    function! FORMS_MENU_getFirstFocus() dict
      let flist = self.__focuslist
      let len = len(flist)

      let cnt = 0
      while cnt < len
        if flist[cnt].canfocus
          return cnt
        endif

        let cnt += 1
      endwhile
      
      return -1
    endfunction
    let g:forms#Menu.getFirstFocus  = function("FORMS_MENU_getFirstFocus")

    function! FORMS_MENU_getLastFocus() dict
      let flist = self.__focuslist
      let len = len(flist)

      let cnt = len - 1
      while cnt >= 0
        if flist[cnt].canfocus
          return cnt
        endif

        let cnt -= 1
      endwhile
      
      return -1
    endfunction
    let g:forms#Menu.getLastFocus  = function("FORMS_MENU_getLastFocus")




    function! FORMS_MENU_highlightMnemonic(pos) dict
      let child = self.__children[a:pos]
      let mnemonics = self.__mnemonics
      let left_offset = self.__required_left_space
      for pairs in values(mnemonics)
        for [pos, mindex] in pairs
          if pos == a:pos
            let a = child.__allocation
            call GlyphHilight(child, "MenuMnemonicHi", {
                                        \ 'line': a.line,
                                        \ 'column': a.column+mindex+left_offset,
                                        \ 'width': 1,
                                        \ 'height': 1
                                        \ })
            return
          endif
        endfor
      endfor

    endfunction
    let g:forms#Menu.highlightMnemonic  = function("FORMS_MENU_highlightMnemonic")

    function! FORMS_MENU_highlightMnemonicHotSpot(pos) dict
      let child = self.__children[a:pos]
      let mnemonics = self.__mnemonics
      let left_offset = self.__required_left_space
      for pairs in values(mnemonics)
        for [pos, mindex] in pairs
          if pos == a:pos
            let a = child.__allocation
            call AugmentGlyphHilight(child, "MenuMnemonicHotSpotHi", {
                                        \ 'line': a.line,
                                        \ 'column': a.column+mindex+left_offset,
                                        \ 'width': 1,
                                        \ 'height': 1
                                        \ })
            return
          endif
        endfor
      endfor

    endfunction
    let g:forms#Menu.highlightMnemonicHotSpot  = function("FORMS_MENU_highlightMnemonicHotSpot")

    function! FORMS_MENU_draw(allocation) dict
"call forms#log("g:forms#Menu.draw" .  string(a:allocation))
      let self.__allocation = a:allocation
      let a = a:allocation

      if self.__status != g:IS_INVISIBLE
        let line = a.line
        let column = a.column
        let width = a.width
        let height = a.height
        let win_start = self.__win_start

        " clear menu allocation
        let str = repeat(' ', width)
        let cnt = 0
        while cnt < height
          call forms#SetStringAt(str, line+cnt, column)

          let cnt += 1
        endwhile

        " highlight menu allocation
        call GlyphHilight(self, "MenuHi", a)

        " TODO must delete action functions
        let p = g:forms#Menu._prototype
        call call(p.draw, [a], self)


        let children = self.__children
        let size = self.__size
        let nos_children = len(children)
        let mnemonics = self.__mnemonics
        let mnemonics = self.__mnemonics
        let mnemonics = self.__mnemonics
        let left_offset = self.__required_left_space
        let left_offset = self.__required_left_space
        let left_offset = self.__required_left_space

        if size > 0 && nos_children > size
          let endcnt = win_start + size
        else
          let endcnt = nos_children
        endif


        for pairs in values(mnemonics)
          for [pos, mindex] in pairs
  " call forms#log("g:forms#Menu.draw: pos=" .  pos . ", mindex=" . mindex)
            let child = children[pos]
            if pos >= win_start && pos < endcnt
              let a = child.__allocation
              call GlyphHilight(child, "MenuMnemonicHi", {
                                          \ 'line': a.line,
                                          \ 'column': a.column+mindex+left_offset,
                                          \ 'width': 1,
                                          \ 'height': 1
                                          \ })
            else
              call GlyphDeleteHi(child)
            endif

          endfor
        endfor
      endif
      if self.__status == g:IS_DISABLED
        call AugmentGlyphHilight(self, "DisableHi", a)
      endif                     
    endfunction
    let g:forms#Menu.draw  = function("FORMS_MENU_draw")

    function! FORMS_MENU_usage() dict
      return [
           \ "A Menu displays menu items: buttons, separators,",
           \ "  labels, checkboxes, radiobuttons and sub-menu buttons.",
           \ "  There are actions associated with the checkbox, button,",
           \ "  radiobutton and sub-menu button.",
           \ "Navigation between Menu items using keyboard <Up> and",
           \ "  <Down>, <PageUp>, <PageDown>, <Home>, <End> and mouse.",
           \ "  scroll wheel.",
           \ "  Additionally, Menu item labels can have a mnemonic which",
           \ "  is the underlined character.",
           \ "Selection is with keyboard <CR> or <Space>,",
           \ "  or with a mouse <LeftMouse> click."
           \ ]
    endfunction
    let g:forms#Menu.usage  = function("FORMS_MENU_usage")

  endif

  return g:forms#Menu
endfunction
" ------------------------------------------------------------ 
" forms#newMenu: {{{2
"   Create new Menu
"  parameters: 
"   attrs  : attributes for initializing new object
" ------------------------------------------------------------ 
function! forms#newMenu(attrs)
  return forms#loadMenuPrototype().clone().init(a:attrs)
endfunction

"-------------------------------------------------------------------------------
" Grid Prototype: {{{1
"-------------------------------------------------------------------------------
" Grid <- Glyph: {{{2
"   Children are layed out in a grid
"
" attributes
"    nos_rows    : number of rows in the grid (> 0)
"    nos_columns : number of columns in the grid (> 0)
"    cell_height : minimum cell height
"    cell_width  : minimum cell width
"    major_axis  : row or column (default row)
"    halignment  : default horizontal alignments for all rows
"                      float align 0-1 or L C R (default L)
"    valignment  : default vertical alignments for all columns
"                      float align 0-1 or T C B (default T)
"    halignments : list of row/halignment override values
"                     [row, (L) float align 0-1 or L C R]
"    valignments : list of column/valignment override values
"                     [column, (T) float align 0-1 or T C B]
"    data        : list of list of glyph row/column
"                     placement,  [[row, column, glyph]]
"    mode : optional box drawing mode
"---------------------------------------------------------------------------
if g:self#IN_DEVELOPMENT_MODE
  if exists("g:forms#Grid")
    unlet g:forms#Grid
  endif
endif
function! forms#loadGridPrototype()
  if !exists("g:forms#Grid")
    let g:forms#Grid = forms#loadGlyphPrototype().clone('forms#Grid')
    let g:forms#Grid.__nos_rows = -1
    let g:forms#Grid.__nos_columns = -1
    let g:forms#Grid.__cell_height = -1
    let g:forms#Grid.__cell_width = -1
    let g:forms#Grid.__halignment = 'L'
    let g:forms#Grid.__row_halignments = []
    let g:forms#Grid.__valignment = 'T'
    let g:forms#Grid.__column_valignments = []
    let g:forms#Grid.__major_axis = 'row'

    let g:forms#Grid.__grid = []
    let g:forms#Grid.__gridsize = []
    let g:forms#Grid.__max_column_width = []
    let g:forms#Grid.__max_row_height = []

    let g:forms#Grid.__needToLoadCache = 1

    function! FORMS_GRID_delete(...) dict
"call forms#log("Grid.delete: TOP")
      for minor in self.major()
        for child in minor
          if has_key(child, 'delete')
            call child.delete()
          endif
        endfor
      endfor

      let p = g:forms#Grid._prototype
      call call(p.delete, [p], self)
"call forms#log("Grid.delete: BOTTOM")
    endfunction
    let g:forms#Grid.delete  = function("FORMS_GRID_delete")

    function! FORMS_GRID_hide() dict
      for minor in self.major()
        for child in minor
          call child.hide()
        endfor
      endfor
    endfunction
    let g:forms#Grid.hide  = function("FORMS_GRID_hide")

    function! FORMS_GRID_nodeType() dict
      return g:GRID_NODE
    endfunction
    let g:forms#Grid.nodeType  = function("FORMS_GRID_nodeType")

    function! FORMS_GRID_major() dict
      return self.__grid
    endfunction
    let g:forms#Grid.major  = function("FORMS_GRID_major")

    function! FORMS_GRID_init(attrs) dict
"call forms#log("g:forms#Grid.init TOP")
      call call(g:forms#Glyph.init, [a:attrs], self)

      " Validate number of rows and columns
      if self.__nos_rows < 1
        throw "Grid.init: nos_rows must be positive: " . self.__nos_rows
      endif
      if self.__nos_columns < 1
        throw "Grid.init: nos_columns must be positive: " . self.__nos_columns
      endif

      " Validate default horizontal and vertical alignments
      call g:forms_Util.checkHAlignment(self.__halignment, "Grid.init")
      call g:forms_Util.checkVAlignment(self.__valignment, "Grid.init")

      " Load alignments
      let nos_rows = self.__nos_rows
      let nos_columns = self.__nos_columns
      let halignment = self.__halignment
      let valignment = self.__valignment
" call forms#log("g:forms#Grid.init nos_rows=" .  nos_rows)
" call forms#log("g:forms#Grid.init nos_columns=" .  nos_columns)

      " Load the row halignments and the column valignments
      " with their default values, the halignment and valignment values.
      let row_halignments = []
      let column_valignments = []

      let rcnt = 0
      while rcnt < nos_rows
        call add(row_halignments, halignment)

        let rcnt = rcnt + 1
      endwhile

      let ccnt = 0
      while ccnt < nos_columns
        call add(column_valignments, valignment)

        let ccnt = ccnt + 1
      endwhile

" call forms#log("g:forms#Grid.init row_halignments=" .  string(row_halignments))
" call forms#log("g:forms#Grid.init column_valignments=" .  string(column_valignments))

      " Validate and load any row/column override alignments
      if has_key(a:attrs, 'halignments')
        let halignments = a:attrs['halignments']
        if type(halignments) != g:self#LIST_TYPE
          throw "Grid.init: halignments attribute must be list type"
        endif
        for haligns in halignments
          if type(haligns) != g:self#LIST_TYPE
            throw "Grid.init: halignments attribute member must be list type"
          endif
          let [row, ha] = haligns
          if row < 0 || row >= nos_rows
            throw "Grid.init: halignments attribute row not valid: " . row
          endif
          call g:forms_Util.checkHAlignment(ha, "Grid.init")
          " unlet row_halignments[row]
          let row_halignments[row] = ha
        endfor
      endif

      if has_key(a:attrs, 'valignments')
        let valignments = a:attrs['valignments']
        if type(valignments) != g:self#LIST_TYPE
          throw "Grid.init: valignments attribute must be list type"
        endif
        for valigns in valignments
          if type(valigns) != g:self#LIST_TYPE
            throw "Grid.init: valignments attribute member must be list type"
          endif
          let [column, va] = valigns
          if column < 0 || column >= nos_columns
            throw "Grid.init: valignments attribute column not valid: " . column
          endif
          call g:forms_Util.checkVAlignment(va, "Grid.init")
          " unlet column_valignments[column]
          let column_valignments[column] = va
        endfor
      endif
" call forms#log("g:forms#Grid.init row_halignments=" .  string(row_halignments))
" call forms#log("g:forms#Grid.init column_valignments=" .  string(column_valignments))

      let self.__row_halignments = row_halignments
      let self.__column_valignments = column_valignments

      if self.__major_axis != 'row' && self.__major_axis != 'column'
        throw "Grid.init: major_axis must be 'row' or 'column': " . self.__major_axis
      endif

      let nullglyph = g:forms_Util.nullGlyph()

      let grid = []
      let gridsize = []

      if self.__major_axis == 'row' 
        let rcnt = 0
        while rcnt < nos_rows
          let rowlist = []
          let rowsize = []

          let ccnt = 0
          while ccnt < nos_columns
            call add(rowlist, nullglyph)
            call add(rowsize, [0,0])

            let ccnt = ccnt + 1
          endwhile

          call add(grid, rowlist)
          call add(gridsize, rowsize)

          let rcnt = rcnt + 1
        endwhile

      else
        let ccnt = 0
        while ccnt < nos_columns
          let columnlist = []
          let columnsize = []

          let rcnt = 0
          while rcnt < nos_rows
            call add(columnlist, nullglyph)
            call add(columnsize, [0,0])

            let rcnt = rcnt + 1
          endwhile

          call add(grid, columnlist)
          call add(gridsize, columnsize)

          let ccnt = ccnt + 1
        endwhile

      endif

      " Ok, now load all of the row/column/glyph data
      if has_key(a:attrs, 'data')
        let data = a:attrs['data']
        if type(data) != g:self#LIST_TYPE
          throw "Grid.init: data attribute must be list type"
        endif
        for cell in data
          if type(cell) != g:self#LIST_TYPE
            throw "Grid.init: data attribute cell member must be list type"
          endif
          let [row, column, glyph] = cell
"call forms#log("g:forms#Grid.init data row=" .  row)
"call forms#log("g:forms#Grid.init data column=" .  column)

          if self.__major_axis == 'row' 
            let grid[row][column] = glyph
          else
            let grid[column][row] = glyph
          endif
        endfor
      endif
"call forms#log("g:forms#Grid.init len(grid)=" .  len(grid))

      let self.__grid = grid
      let self.__gridsize = gridsize



      let max_row_height = []
      let rcnt = 0
      while rcnt < nos_rows
        call add(max_row_height, 0)

        let rcnt = rcnt + 1
      endwhile
      let self._max_row_height = max_row_height

      let max_column_height = []
      let ccnt = 0
      while ccnt < nos_columns
        call add(max_column_height, 0)

        let ccnt = ccnt + 1
      endwhile
      let self._max_column_height = max_column_height

      if has_key(a:attrs, 'mode')
        let mode = a:attrs['mode']
        if type(mode) != g:self#STRING_TYPE
          throw "Grid.init: mode attribute must be String type"
        endif
        let self.__mode = mode
      endif

"call forms#log("g:forms#Grid.init BOTTOM")
      return self
    endfunction
    let g:forms#Grid.init  = function("FORMS_GRID_init")

    function! FORMS_GRID_reinit(attrs) dict
" call forms#log("g:forms#Grid.reinit TOP")
      let oldRLS = self.__required_left_space

      if exists("self.__mode")
        unlet self.__mode
      endif

      let self.__nos_rows = -1
      let self.__nos_columns = -1
      let self.__cell_height = -1
      let self.__cell_width = -1
      let self.__halignment = 'L'
      let self.__row_halignments = []
      let self.__valignment = 'T'
      let self.__column_valignments = []
      let self.__major_axis = 'row'

      let self.__grid = []
      let self.__gridsize = []
      let self.__max_column_width = []
      let self.__max_row_height = []

      call call(g:forms#Grid.reinit, [a:attrs], self)

      " TODO too strong?
      call forms#PrependUniqueInput({'type': 'ReSize'})
    endfunction
    let g:forms#Grid.reinit  = function("FORMS_GRID_reinit")

    function! FORMS_GRID_requestedSize() dict
" call forms#log("g:forms#Grid.requesting TOP")
      if (self.__status == g:IS_INVISIBLE) 
        return [0,0]
      else
        let grid = self.__grid
        let gridsize = self.__gridsize
        let nos_rows = self.__nos_rows
        let nos_columns = self.__nos_columns
        let cell_height = self.__cell_height
        let cell_width = self.__cell_width

        " First get and cache requestedSize of all cells
        " If any cell's height/width is less than __cell_height/width
        " then use __cell_height/width instead.
        if self.__needToLoadCache
          if self.__major_axis == 'row' 
            let rcnt = 0
            while rcnt < nos_rows
              let ccnt = 0
              while ccnt < nos_columns
                let [w,h] = grid[rcnt][ccnt].requestedSize()
                if w < cell_width | let w = cell_width | endif
                if h < cell_height | let h = cell_height | endif
                let gridsize[rcnt][ccnt] = [w,h]
        
                let ccnt = ccnt + 1
              endwhile

              let rcnt = rcnt + 1
            endwhile

          else
            let ccnt = 0
            while ccnt < nos_columns
              let rcnt = 0
              while rcnt < nos_rows
                let [w,h] = grid[ccnt][rcnt].requestedSize()
                if w < cell_width | let w = cell_width | endif
                if h < cell_height | let h = cell_height | endif
                let gridsize[ccnt][rcnt] = [w,h]
        
                let rcnt = rcnt + 1
              endwhile

              let ccnt = ccnt + 1
            endwhile
          endif

          "Now, per row maximum height
          "Now, per column maximum width
          if self.__major_axis == 'row' 
            let rcnt = 0
            while rcnt < nos_rows
              let max_row_height = 0
              let ccnt = 0
              while ccnt < nos_columns
                let [w,h] = gridsize[rcnt][ccnt]
                if max_row_height < h
                  let max_row_height = h
                endif
                let ccnt = ccnt + 1
              endwhile

              call add(self.__max_row_height, max_row_height)
              let rcnt = rcnt + 1
            endwhile

            let ccnt = 0
            while ccnt < nos_columns
              let max_column_width = 0
              let rcnt = 0
              while rcnt < nos_rows
                let [w,h] = gridsize[rcnt][ccnt]
                if max_column_width < w
                  let max_column_width = w
                endif
                let rcnt = rcnt + 1
              endwhile

              call add(self.__max_column_width, max_column_width)
              let ccnt = ccnt + 1
            endwhile

          else
            let ccnt = 0
            while ccnt < nos_columns
              let max_column_width = 0
              let rcnt = 0
              while rcnt < nos_rows
                let [w,h] = gridsize[ccnt][rcnt]
                if max_column_width < w
                  let max_column_width = w
                endif
                let rcnt = rcnt + 1
              endwhile

              call add(self.__max_column_width, max_column_width)
              let ccnt = ccnt + 1
            endwhile

            let rcnt = 0
            while rcnt < nos_rows
              let max_row_height = 0
              let ccnt = 0
              while ccnt < nos_columns
                let [w,h] = gridsize[ccnt][rcnt]
                if max_row_height < h
                  let max_row_height = h
                endif
                let ccnt = ccnt + 1
              endwhile

              call add(self.__max_row_height, max_row_height)
              let rcnt = rcnt + 1
            endwhile

          endif

"  call forms#log("g:forms#Grid.requesting max_column_width=" . string(self.__max_column_width))
"  call forms#log("g:forms#Grid.requesting max_row_height=" . string(self.__max_row_height))

          let self.__needToLoadCache = 0
        endif

        " Now, need total width and height
        " The total width is the sum of the column max widths
        " and total height the sum of row max heights.

        let total_width = 0
        let total_height = 0

        let rcnt = 0
        while rcnt < nos_rows
          let total_height = total_height + self.__max_row_height[rcnt] 

          let rcnt = rcnt + 1
        endwhile

        let ccnt = 0
        while ccnt < nos_columns
          let total_width = total_width + self.__max_column_width[ccnt] 

          let ccnt = ccnt + 1
        endwhile

        if exists("self.__mode")
          let total_width += nos_columns+1
          let total_height += nos_rows+1
        endif

"call forms#log("g:forms#Grid.requesting BOTTOM: " .  string([total_width, total_height]))
        return [total_width, total_height]
      endif
    endfunction
    let g:forms#Grid.requestedSize  = function("FORMS_GRID_requestedSize")


    function! FORMS_GRID_drawBoxes() dict
      if exists("self.__mode")
        let a = self.__allocation
        let column_width = self.__max_column_width
        let row_height = self.__max_row_height
        call forms#DrawBoxes(self.__mode, a, column_width, row_height)
      endif
    endfunction
    let g:forms#Grid.drawBoxes  = function("FORMS_GRID_drawBoxes")



    function! FORMS_GRID_draw(allocation) dict
" call forms#log("g:forms#Grid.draw" .  string(a:allocation))
      let self.__allocation = a:allocation
      let a = a:allocation

      if self.__status != g:IS_INVISIBLE
        let line = a.line
        let column = a.column
        let width = a.width
        let height = a.height
        let char = ''

        let row_halignments = self.__row_halignments
        let column_valignments = self.__column_valignments
"call forms#log("g:forms#Grid.draw row_halignments=" .  string(row_halignments))
"call forms#log("g:forms#Grid.draw column_valignments=" .  string(column_valignments))

        let max_column_width = self.__max_column_width
        let max_row_height = self.__max_row_height
        let grid = self.__grid
        let gridsize = self.__gridsize
        let nos_rows = self.__nos_rows
        let nos_columns = self.__nos_columns

        call self.drawBoxes()
        let bdelta = exists("self.__mode") ? 1 : 0

        if self.__major_axis == 'row' 
          let row_line = line

          let rcnt = 0
          while rcnt < nos_rows
"  call forms#log("g:forms#Grid.draw rcnt=" .  rcnt)
            let column_column = column

            let ccnt = 0
            while ccnt < nos_columns
"  call forms#log("g:forms#Grid.draw ccnt=" .  ccnt)
              let glyph = grid[rcnt][ccnt]
              let [w,h] = gridsize[rcnt][ccnt]

              if w < max_column_width[ccnt] && h < max_row_height[rcnt]
                " { 'line', 'column', 'width', 'height', 'childwidth', 'childheight' }
                call g:forms_Util.drawHVAlign(glyph, {
                                             \ 'line': row_line+bdelta,
                                             \ 'column': column_column+bdelta,
                                             \ 'width': max_column_width[ccnt],
                                             \ 'height': max_row_height[rcnt],
                                             \ 'childwidth': w,
                                             \ 'childheight': h
                                             \ }, 
                                             \ row_halignments[rcnt], 
                                             \ column_valignments[ccnt], 
                                             \ char)

              elseif w < max_column_width[ccnt]
                " { 'line', 'column', 'width', 'childwidth', 'childwidth' }
                call g:forms_Util.drawHAlign(glyph, {
                                            \ 'line': row_line+bdelta,
                                            \ 'column': column_column+bdelta,
                                            \ 'width': max_column_width[ccnt],
                                            \ 'childwidth': w,
                                            \ 'childheight': h
                                            \ }, 
                                            \ row_halignments[rcnt], 
                                            \ char)
              elseif h < max_row_height[rcnt]
                " { 'line', 'column', 'height', 'childwidth', 'childwidth' }
                call g:forms_Util.drawVAlign(glyph, {
                                            \ 'line': row_line+bdelta,
                                            \ 'column': column_column+bdelta,
                                            \ 'height': max_row_height[rcnt],
                                            \ 'childwidth': w,
                                            \ 'childheight': h
                                            \ },
                                             \ column_valignments[ccnt], 
                                             \ char)
              else
                call glyph.draw({
                                \ 'line': row_line+bdelta,
                                \ 'column': column_column+bdelta,
                                \ 'width': w,
                                \ 'height': h
                                \ })
              endif

              let column_column += max_column_width[ccnt]+bdelta
              let ccnt += 1
            endwhile

            let row_line += max_row_height[rcnt]+bdelta
            let rcnt += 1
          endwhile
        else
          throw "Grid.draw major_axis column not done yet"

          let column_column = column

          let ccnt = 0
          while ccnt < nos_columns
"  call forms#log("g:forms#Grid.draw ccnt=" .  ccnt)
            let row_line = line

            let rcnt = 0
            while rcnt < nos_rows
"  call forms#log("g:forms#Grid.draw rcnt=" .  rcnt)
              let glyph = grid[ccnt][rcnt]
              let [w,h] = gridsize[ccnt][rcnt]

              if h < max_row_height[rcnt] && w < max_column_width[ccnt]
                " { 'line', 'column', 'width', 'height', 'childwidth', 'childheight' }
                call g:forms_Util.drawHVAlign(glyph, {
                                             \ 'line': row_line,
                                             \ 'column': column_column,
                                             \ 'width': max_column_width[ccnt],
                                             \ 'height': max_row_height[rcnt],
                                             \ 'childwidth': w,
                                             \ 'childheight': h
                                             \ }, 
                                             \ row_halignments[rcnt], 
                                             \ column_valignments[ccnt], 
                                             \ char)

              elseif h < max_row_height[rcnt]
                " { 'line', 'column', 'width', 'childwidth', 'childwidth' }
                call g:forms_Util.drawVAlign(glyph, {
                                            \ 'line': row_line,
                                            \ 'column': column_column,
                                            \ 'height': max_row_height[rcnt],
                                            \ 'childwidth': w,
                                            \ 'childheight': h
                                            \ }, 
                                            \ row_valignments[ccnt], 
                                            \ char)
              elseif w < max_column_width[ccnt]
                " { 'line', 'column', 'height', 'childwidth', 'childwidth' }
                call g:forms_Util.drawHAlign(glyph, {
                                            \ 'line': row_line,
                                            \ 'column': column_column,
                                            \ 'width': max_column_width[ccnt],
                                            \ 'childwidth': w,
                                            \ 'childheight': h
                                            \ },
                                             \ column_halignments[rcnt], 
                                             \ char)
              else
                call glyph.draw({
                                \ 'line': row_line,
                                \ 'column': column_column,
                                \ 'width': w,
                                \ 'height': h
                                \ })
              endif

              let row_line += max_row_height[Rcnt]
              let rcnt += 1
            endwhile

            let column_column += max_column_width[ccnt]
            let ccnt += 1
          endwhile

        endif
      endif
      if self.__status == g:IS_DISABLED
        call AugmentGlyphHilight(self, "DisableHi", a)
      endif                     
    endfunction
    let g:forms#Grid.draw  = function("FORMS_GRID_draw")
  endif

  return g:forms#Grid
endfunction
" ------------------------------------------------------------ 
" forms#newGrid: {{{2
"   Create new Grid
"  parameters: 
"   attrs  : attributes for initializing new object
" ------------------------------------------------------------ 
function! forms#newGrid(attrs)
  return forms#loadGridPrototype().clone().init(a:attrs)
endfunction

"---------------------------------------------------------------------------
" Viewer Utilities: {{{1
"-------------------------------------------------------------------------------
" Viewer Utilities
"-------------------------------------------------------------------------------

"---------------------------------------------------------------------------
" Viewer ReDraw: {{{2
"---------------------
" Viewer ReDraw list
"---------------------

" ------------------------------------------------------------ 
" s:viewer_redraw_list: {{{2
"  List of glyphs requiring redrawing.
"  After an event of character is handled by a child glyph, a 
"  Viewer will get all of the glyphs that have been added to
"  the list and call redraw() on each of them.
" ------------------------------------------------------------ 
let s:viewer_redraw_list = []

" ------------------------------------------------------------ 
" forms#CheckIsGlyph: {{{2
"  Is the glyph parameter a Glyph, 
"    Throws exception if it is not.
"  parameters:
"    glyph : object to be check if its a Glyph
" ------------------------------------------------------------ 
function! forms#CheckIsGlyph(glyph) 
  let type = type(a:glyph)
  if type == g:self#DICTIONARY_TYPE
    if ! exists("a:glyph.isKindOf")
      throw "CheckIsGlyph: Dictionary not Self object: " . string(a:glyph)
    endif
    if ! a:glyph.isKindOf('forms#Glyph')
      throw "CheckIsGlyph: Self object not a Glyph: " . string(a:glyph)
    endif
  else
    throw "CheckIsGlyph: Parameter not Dictionary: " . string(a:glyph)
  endif
endfunction

" ------------------------------------------------------------ 
" forms#ViewerRedrawListAdd: {{{2
"  Add a glyph to the redraw list.
"  parameters:
"    glyph : glyph to add to redraw list
" ------------------------------------------------------------ 
function! forms#ViewerRedrawListAdd(glyph) 
  call forms#CheckIsGlyph(a:glyph)
  call add(s:viewer_redraw_list, a:glyph)
endfunction

" ------------------------------------------------------------ 
" forms#ViewerRedrawListClear: {{{2
"  Clear all glyph from redraw list
"  parameters: None
" ------------------------------------------------------------ 
function! forms#ViewerRedrawListClear() 
  let s:viewer_redraw_list = []
endfunction

" ------------------------------------------------------------ 
" forms#ViewerRedrawListCopyAndClear: {{{2
"  Copy the redraw list and return it. 
"    Also, clear all glyph from viewser_redraw_list
"  parameters: None
" ------------------------------------------------------------ 
function! forms#ViewerRedrawListCopyAndClear() 
  try
    return copy(s:viewer_redraw_list)
  finally
    let s:viewer_redraw_list = []
  endtry
endfunction

"---------------------------------------------------------------------------
" Viewer Stack: {{{2
"---------------------
" Viewer Stack
"---------------------
" ------------------------------------------------------------ 
" s:viewer_stack: {{{2
"  Viewers are entered and exited (push and pop). This stack
"    keeps track of them. It is the Viewer at the top of 
"    stack which is the active Viewer and handles input 
"    events and characters.
" ------------------------------------------------------------ 
let s:viewer_stack = []

" ------------------------------------------------------------ 
" forms#CheckIsViewer: {{{2
"  Is the viewer parameter a Viewer
"    Throws exception if it is not.
"  parameters:
"    viewer : object to be check if its a Viewer
" ------------------------------------------------------------ 
function! forms#CheckIsViewer(viewer) 
  let type = type(a:viewer)
  if type == g:self#DICTIONARY_TYPE
    if ! exists("a:viewer.isKindOf")
      throw "CheckIsViewer: Dictionary not Self object: " . string(a:viewer)
    endif
    if ! a:viewer.isKindOf('forms#Viewer')
      throw "CheckIsViewer: Self object not a Viewer: " . string(a:viewer)
    endif
  else
    throw "CheckIsViewer: Parameter not Dictionary: " . string(a:viewer)
  endif
endfunction

" ------------------------------------------------------------ 
" forms#ViewerStackPush: {{{2
"  Add a Viewer to the Viewer Stack.
"  parameters:
"    viewer : viewer to be added to stack
" ------------------------------------------------------------ 
function! forms#ViewerStackPush(viewer) 
" call forms#log("g:forms#ViewerStackPush TOP")
  call forms#CheckIsViewer(a:viewer)
  call add(s:viewer_stack, a:viewer)
endfunction

" ------------------------------------------------------------ 
" forms#ViewerStackDepth: {{{2
"  Returns depth of Viewer Stack.
"  parameters: None
" ------------------------------------------------------------ 
function! forms#ViewerStackDepth() 
  return len(s:viewer_stack)
endfunction

" ------------------------------------------------------------ 
" forms#ViewerStackPeek: {{{2
"  Return Viewer at stack depth given by index.
"    An index out of bound throws and exception.
"  parameters:
"    index : index of Viewer to be returned.
" ------------------------------------------------------------ 
function! forms#ViewerStackPeek(index) 
  let vslen = len(s:viewer_stack)
  if a:index < 0
    throw "ViewerStackPeek: Parameter index < 0: " . a:index)
  elseif a:index >= vslen
    throw "ViewerStackPeek: Parameter index >= stack size: " . a:index)
  else
    return s:viewer_stack[a:index]
  endif
endfunction

" ------------------------------------------------------------ 
" forms#ViewerStackPop: {{{2
"  Return Viewer at top of stack.
"    If there are no Viewers on the Viewer stack, an exception
"    is thrown.
"  parameters: None
" ------------------------------------------------------------ 
function! forms#ViewerStackPop() 
" call forms#log("g:forms#ViewerStackPop TOP")
  let vs = s:viewer_stack
  if empty(vs) 
    throw "PopViewer: Viewer Stack is empty")
  else
    call remove(vs, len(vs)-1)
  endif
endfunction


"---------------------------------------------------------------------------
" Form Utilities: {{{1
"-------------------------------------------------------------------------------

" ------------------------------------------------------------ 
" forms#DeleteHighLights: {{{2
"  Delete a Glyph's highlights and recursively its children's.
"  parameters:
"    glyph : glyph to have its highlights deleted and recursively
"            its children's highlights.
" ------------------------------------------------------------ 
function! forms#DeleteHighLights(glyph)
  let nodeType = a:glyph.nodeType()
  if nodeType == g:LEAF_NODE
    call GlyphDeleteHi(a:glyph)

  elseif nodeType == g:MONO_NODE
    call forms#DeleteHighLights(a:glyph.getBody())
    call GlyphDeleteHi(a:glyph)

  elseif nodeType == g:POLY_NODE
    for child in a:glyph.children()
      call forms#DeleteHighLights(child)
    endfor
    call GlyphDeleteHi(a:glyph)
  elseif nodeType == g:GRID_NODE
    for minor in a:glyph.major()
      for child in minor
        call forms#DeleteHighLights(child)
      endfor
    endfor
    call GlyphDeleteHi(a:glyph)
  else
    throw "Unknown glyph nodeType " . nodeType
  endif
endfunction

" ------------------------------------------------------------ 
" forms#GenerateFocusList: {{{2
"  Find all glyphs that can accept focus given a top glyph.
"    If a glyph can accept focus it is added to the list and
"    its child glyphs are not walked.
"  parameters:
"    glyph : glyph to be determined if it can accept focus, and,
"            if so, it is added to the focus list (flist).
"            its children are searched if it can not.
"    flist : list to add focusable glyphs to.
" ------------------------------------------------------------ 
function! forms#GenerateFocusList(glyph, flist)
  let nodeType = a:glyph.nodeType()
  if nodeType == g:LEAF_NODE
    if a:glyph.canFocus() | call add(a:flist, a:glyph) | endif
  elseif nodeType == g:MONO_NODE
    if a:glyph.canFocus() 
      call add(a:flist, a:glyph) 
    else
      call forms#GenerateFocusList(a:glyph.getBody(), a:flist)
    endif
  elseif nodeType == g:POLY_NODE
    if a:glyph.canFocus() 
      call add(a:flist, a:glyph) 
    else
      for child in a:glyph.children()
        call forms#GenerateFocusList(child, a:flist)
      endfor
    endif
  elseif nodeType == g:GRID_NODE
    if a:glyph.canFocus() 
      call add(a:flist, a:glyph) 
    else
      for minor in a:glyph.major()
        for child in minor
          call forms#GenerateFocusList(child, a:flist)
        endfor
      endfor
    endif
  else
    throw "Unknown glyph nodeType " . nodeType
  endif
endfunction

" ------------------------------------------------------------ 
" forms#GenerateResults: {{{2
"  Walk a glyph hierarchy asking each glyph visited to add its
"    results to the results Dictionary. 
"    A glyph with no results will add nothing.
"    A glyph's tag is the key to its results.
"  parameters:
"    glyph : Glyph to determine if its results should be add to
"            list. Also, all of its child glyphs are tested.
"    results : Dictionary holding each glyph results.
" ------------------------------------------------------------ 
function! forms#GenerateResults(glyph, results)
  let nodeType = a:glyph.nodeType()
  if nodeType == g:LEAF_NODE
    call a:glyph.addResults(a:results)

  elseif nodeType == g:MONO_NODE
    if has_key(a:glyph, 'addResults')
      call a:glyph.addResults(a:results)
    endif

    call forms#GenerateResults(a:glyph.getBody(), a:results)

  elseif nodeType == g:POLY_NODE
    if has_key(a:glyph, 'addResults')
      call a:glyph.addResults(a:results)
    endif

    for child in a:glyph.children()
      call forms#GenerateResults(child, a:results)
    endfor

  elseif nodeType == g:GRID_NODE
    if has_key(a:glyph, 'addResults')
      call a:glyph.addResults(a:results)
    endif

    for minor in a:glyph.major()
      for child in minor
        call forms#GenerateResults(child, a:results)
      endfor
    endfor

  else
    throw "Unknown glyph nodeType " . nodeType
  endif
endfunction

" ------------------------------------------------------------ 
" forms#Select: {{{2
"  Walk a glyph hierarchy added each glyph to the select list
"    (slist) if its allocation contains the point defined by:
"    line and column.
"    Find all glyphs whose allocation includes the point 
"    (line, column)
"  parameters:
"    glyph : Glyph to test if its allocation contains point.
"            Also, all of its child glyphs are tested.
"    line    : y coordinate of point.
"    column  : x coordinate of point.
"    slist : List of selected glyphs
" ------------------------------------------------------------ 
function! forms#Select(glyph, line, column, slist)
" call forms#log("Select: glyph.kind=" . a:glyph.getKind())
  let a = a:glyph.allocation()
  " glyphs that have not been drawn yet, have empty allocations
  if ! empty(a)
    if a:line >= a.line && a:line < a.line + a.height &&
          \ a:column >= a.column && a:column < a.column + a.width

      call add(a:slist, a:glyph) 

      let nodeType = a:glyph.nodeType()
      if nodeType == g:LEAF_NODE
        " nothing

      elseif nodeType == g:MONO_NODE
        call forms#Select(a:glyph.getBody(), a:line, a:column, a:slist)

      elseif nodeType == g:POLY_NODE
        for child in a:glyph.children()
          call forms#Select(child, a:line, a:column, a:slist)
        endfor

      elseif nodeType == g:GRID_NODE
        for minor in a:glyph.major()
          for child in minor
            call forms#Select(child, a:line, a:column, a:slist)
          endfor
        endfor

      else
        throw "Unknown glyph nodeType " . nodeType
      endif
    endif
  endif
endfunction

" ------------------------------------------------------------ 
" forms#DoFocusInfo: {{{2
"  Display Focus Glyph purpose and usage. Optionally, create button
"    to display developer Glyph tree.
"  parameters:
"    focusHit : Focus Glyph
"    form    : Optional Form 
"    line     : Optional y point
"    column   : Optional x point
" ------------------------------------------------------------ 
function! forms#DoFocusInfo(focusHit, ...)
  let purposetextlines = a:focusHit.purpose()
  let purposetext = forms#newText({'textlines': purposetextlines })

  let usagetextlines = a:focusHit.usage()
  let usagetext = forms#newText({'textlines': usagetextlines })


  let closelabel = forms#newLabel({'text': "Close"})
  let closebutton = forms#newButton({
                         \ 'tag': 'close',
                         \ 'body': closelabel,
                         \ 'action': g:forms#exitAction})
  function! closebutton.purpose() dict
    return "Close the current form"
  endfunction

  let hspace = forms#newHLine({'size': 6})
  if a:0 == 0
    let vpoly = forms#newVPoly({ 'children': [
                            \ purposetext, 
                            \ hspace, 
                            \ usagetext, 
                            \ hspace, 
                            \ closebutton], 
                            \ 'alignments': [[4,'R']],
                            \ 'alignment': 'C' })

  else
    let form = a:1
    let line = a:2
    let column = a:3

    let gsaction = forms#newAction({ 'execute': function("forms#GlyphSelectAction")})
    let gsaction.glyph = form.__body
    let gsaction.line = line
    let gsaction.column = column

    let sellabel = forms#newLabel({'text': "Show Selection"})
    let selbutton = forms#newButton({
                           \ 'tag': 'select',
                           \ 'body': sellabel,
                           \ 'action': gsaction})
    function! selbutton.purpose() dict
      return "Show glyph selection information."
    endfunction

    let vpoly = forms#newVPoly({ 'children': [
                            \ purposetext, 
                            \ hspace, 
                            \ usagetext, 
                            \ hspace, 
                            \ selbutton, 
                            \ hspace, 
                            \ closebutton], 
                            \ 'alignments': [[6,'R']],
                            \ 'alignment': 'C' })
  endif


  let box = forms#newBox({ 'body': vpoly })

  let bg = forms#newBackground({ 'body': box} )
  let form = forms#newForm({'body': bg })
  function! form.purpose() dict
    return "This Form provides usage information for the selected glyph."
  endfunction
  call form.run()
endfunction

" ------------------------------------------------------------ 
" forms#DoFormInfo: {{{2
"  Display Form purpose. Optionally, create button
"    to display developer Glyph tree.
"  parameters:
"    form     : Form 
"    line     : Optional y point
"    column   : Optional x point
" ------------------------------------------------------------ 
function! forms#DoFormInfo(form, ...)
  let textlines = a:form.purpose()
  let text = forms#newText({'textlines': textlines })

  let closelabel = forms#newLabel({'text': "Close"})
  let closebutton = forms#newButton({
                         \ 'tag': 'close',
                         \ 'body': closelabel,
                         \ 'action': g:forms#exitAction})
  function! closebutton.purpose() dict
    return "Close the current form"
  endfunction

  let hspace = forms#newHLine({'size': 6})

  if a:0 == 0
    let vpoly = forms#newVPoly({ 'children': [
                              \ text, 
                              \ hspace, 
                              \ closebutton], 
                              \ 'alignments': [[2,'R']],
                              \ 'alignment': 'C' })
  else
    let line = a:1
    let column = a:2

    let gsaction = forms#newAction({ 'execute': function("forms#GlyphSelectAction")})
    let gsaction.glyph = a:form.__body
    let gsaction.line = line
    let gsaction.column = column

    let sellabel = forms#newLabel({'text': "Show Selection"})
    let selbutton = forms#newButton({
                           \ 'tag': 'select',
                           \ 'body': sellabel,
                           \ 'action': gsaction})
    function! selbutton.purpose() dict
      return "Show glyph selection information."
    endfunction


    let vpoly = forms#newVPoly({ 'children': [
                              \ text, 
                              \ hspace, 
                              \ selbutton, 
                              \ hspace, 
                              \ closebutton], 
                              \ 'alignments': [[4,'R']],
                              \ 'alignment': 'C' })
  endif

  let box = forms#newBox({ 'body': vpoly })

  let bg = forms#newBackground({ 'body': box} )
  let form = forms#newForm({'body': bg })
  function! form.purpose() dict
    return "This Form provides information about the selected Form."
  endfunction
  call form.run()
endfunction

function! forms#GlyphSelectAction(...) dict
  let glyph = self.glyph
  let line = self.line
  let column = self.column
  call forms#DoGlyphSelectInfo(glyph, line, column)
endfunction

" ------------------------------------------------------------ 
" forms#DoGlyphSelectInfo: {{{2
"  Generate information about each glyph whose allocation 
"    contains the point defined by line and column.
"    Display the information in a Form.
"    This is an example of using Forms. A forms developer
"    can see the glyph hierarchy at any selection point.
"  parameters:
"    glyph : Glyph and children to test if there
"            allocation contains point.
"            Display information about the glyphs in a Form.
"    line    : y coordinate of point.
"    column  : x coordinate of point.
" ------------------------------------------------------------ 
function! forms#DoGlyphSelectInfo(glyph, line, column)
  " inputrestore() is called in Viewer.run()
  call inputsave()
  let hits = []
  call forms#Select(a:glyph, a:line, a:column, hits)

" call forms#log("forms#DoGlyphSelectInfo: hits.len=" . len(hits))
" for s in hits
" call forms#log("forms#DoGlyphSelectInfo:   " . s.getKind())
" endfor

  let infoList = []
  let choices = []
  let cnt = 0
  for s in hits
"call forms#log("forms#DoGlyphSelectInfo:   " . s.getKind())
    let kind = s.getKind()
    let lc = []
    let rc = []
    call add(lc, forms#newLabel({'text': 'kind:'}))
    call add(lc, forms#newLabel({'text': 'nodeType:'}))
    call add(lc, forms#newLabel({'text': 'canfocus:'}))
    call add(lc, forms#newLabel({'text': 'allocation:'}))
    call add(lc, forms#newLabel({'text': ''}))

    call add(rc, forms#newLabel({'text': kind}))
    call add(rc, forms#newLabel({'text': s.nodeType()}))
    if s.canFocus()
      call add(rc, forms#newLabel({'text': 'true'}))
    else
      call add(rc, forms#newLabel({'text': 'false'}))
    endif
    let a = s.allocation()
    let allocStr1 = 'line: ' . a.line . ', column: ' . a.column
    let allocStr2 = 'width: ' . a.width . ', height: ' . a.height
    call add(rc, forms#newLabel({'text': allocStr1}))
    call add(rc, forms#newLabel({'text': allocStr2}))

    for key in keys(s)
      if key[0] == '_' && key[1] == '_'
        if key == '__allocation' " skip
        else
" call forms#log("forms#DoGlyphSelectInfo:  key=" . key)

          let attr = key[2:]
          call add(lc, forms#newLabel({'text': attr . ':'}))

          let typeName = ''
          if type(s[key]) == g:self#FUNCREF_TYPE
            let typeName = 'FUNCRED'
          else
            " Must check type above for FUNCREF_TYPE
            " E704: Funcref variable name must start with a capital
            let value = s[key]
            if type(value) == g:self#NUMBER_TYPE
              let typeName = 'NUMBER'
            elseif type(value) == g:self#STRING_TYPE
              let typeName = 'STRING'
            elseif type(value) == g:self#LIST_TYPE
              let typeName = 'LIST'
            elseif type(value) == g:self#DICTIONARY_TYPE
              let typeName = 'DICTIONARY'
            elseif type(value) == g:self#FLOAT_TYPE
              let typeName = 'FLOAT'
            else
              throw 'Unknown data type ' . type(value) . ' for attribute ' . key
            endif
            unlet value
          endif
          call add(rc, forms#newLabel({'text': typeName}))

        endif
      endif
    endfor

    " call add(rc, g:forms_Util.nullGlyph())

    let vpolyLeft = forms#newVPoly({ 'children': lc, 'alignment': 'L' })
    let vpolyRight = forms#newVPoly({ 'children': rc, 'alignment': 'L' })

    let hpoly = forms#newHPoly({ 'children': [vpolyLeft, vpolyRight]})
    call add(infoList, hpoly)
    call add(choices, [kind, cnt])

    let cnt += 1
  endfor

" call forms#log("forms#DoGlyphSelectInfo:   len(infoList)=" . len(infoList))
" call forms#log("forms#DoGlyphSelectInfo:   make deck")

  let deck = forms#newDeck({ 'children': infoList })
  let bd = forms#newBorder({ 'body': deck })

" let vl = forms#newVLabel({ 'text': 'ABCD'})
" let hva = forms#newHVAlign({ 'body': vl, 'halignment': 'C', 'valignment': 'C' })
" let minSize = forms#newMinSize({'body': hva, 'width': 20, 'height': 6})
" let bd = forms#newBorder({ 'body': minSize })

  function! DoGlyphSelectInfoAction(...) dict
    let pos = a:1
" call forms#log("DoGlyphSelectInfoAction.execute: " . pos)
    call self.deck.setCard(pos)
  endfunction
  let action = forms#newAction({ 'execute': function("DoGlyphSelectInfoAction")})
  let action['deck'] = deck

  let attrs = { 'mode': 'mandatory_on_move_single',
          \ 'pos': 0,
          \ 'choices': choices,
          \ 'on_selection_action': action
          \ }
  let slist = forms#newSelectList(attrs)
  let bsl = forms#newBorder({ 'body': slist })

  let hpoly = forms#newHPoly({ 'children': [bsl, bd], 'alignment': 'T' })

  let title = forms#newLabel({'text': 'Selection List'})
  let ptStr = 'Point(line: ' . a:line . ', column: ' . a:column . ')'
  let pt = forms#newLabel({'text': ptStr})
  let vpoly = forms#newVPoly({ 'children': [title, pt, hpoly], 'alignment': 'C' })

  let bg = forms#newBackground({ 'body': vpoly} )
  let form = forms#newForm({'body': bg })
  function! form.purpose() dict
    return [
         \ "This Form shows a list of glyphs whose allocation includes the",
         \ "  current mouse hit position. Selecting a glyph shows information",
         \ "  (attributes) assocatied with the glyph in the deck to the right",
         \ "  of the list of glyphs."
         \ ]
  endfunction
  call form.run()

endfunction

"---------------------------------------------------------------------------
" Special Characters: {{{1
"-------------------------------------------------------------------------------

"---------------------------------------------------------------------------
" Latin (non-UTF-8) Box Drawing Characters: {{{2
"-------------------------------------------------------------------------------
if !exists("b:forms_vert") | let b:forms_vert = '|' | endif
if !exists("b:forms_horz") | let b:forms_horz = '-' | endif
if !exists("b:forms_dr")   | let b:forms_dr  = '+'  | endif
if !exists("b:forms_dl")   | let b:forms_dl  = '+'  | endif
if !exists("b:forms_ur")   | let b:forms_ur  = '+'  | endif
if !exists("b:forms_ul")   | let b:forms_ul  = '+'  | endif
if !exists("b:forms_d")    | let b:forms_d   = '+'  | endif
if !exists("b:forms_u")    | let b:forms_u   = '+'  | endif
if !exists("b:forms_l")    | let b:forms_l   = '+'  | endif
if !exists("b:forms_r")    | let b:forms_r   = '+'  | endif

" format for box drawing char set: dr  uh  dl  rv  ul  lh  ur  lv

"---------------------------------------------------------------------------
" UTF-8 Box Drawing Characters: {{{2
"-------------------------------------------------------------------------------
if !exists("b:forms_BoxDrawingCharacters") 

  " '─' 9472 2500 BOX DRAWINGS LIGHT HORIZONTAL (present in WGL4)
  let b:forms_BDLightHorizontal = '─'
  " '━' 9473 2501 BOX DRAWINGS HEAVY HORIZONTAL
  let b:forms_BDHeavyHorizontal = '━'
  " '│' 9474 2502 BOX DRAWINGS LIGHT VERTICAL (present in WGL4)
  let b:forms_BDLightVertical = '│'
  " '┃' 9475 2503 BOX DRAWINGS HEAVY VERTICAL
  let b:forms_BDHeavyVertical = '┃'
  " '┄' 9476 2504 BOX DRAWINGS LIGHT TRIPLE DASH HORIZONTAL
  let b:forms_BDLightTripleDashHorizontal = '┄'
  " '┅' 9477 2505 BOX DRAWINGS HEAVY TRIPLE DASH HORIZONTAL
  let b:forms_BDHeavyTripleDashHorizontal = '┅'
  " '┆' 9478 2506 BOX DRAWINGS LIGHT TRIPLE DASH VERTICAL
  let b:forms_BDLightTripleDashVertical = '┆'
  " '┇' 9479 2507 BOX DRAWINGS HEAVY TRIPLE DASH VERTICAL
  let b:forms_BDHeavyTripleDashVertical = '┇'
  " '┈' 9480 2508 BOX DRAWINGS LIGHT QUADRUPLE DASH HORIZONTAL
  let b:forms_BDLightQuadrupleDashHorizontal = '┈'
  " '┉' 9481 2509 BOX DRAWINGS HEAVY QUADRUPLE DASH HORIZONTAL
  let b:forms_BDHeavyQuadrupleDashHorizontal = '┉'
  " '┊' 9482 250A BOX DRAWINGS LIGHT QUADRUPLE DASH VERTICAL        
  let b:forms_BDLightQuadrupleDashVertical = '┊'
  " '┋' 9483 250B BOX DRAWINGS HEAVY QUADRUPLE DASH VERTICAL        
  let b:forms_BDHeavyQuadrupleDashVertical = '┋'

  " '┌' 9484 250C BOX DRAWINGS LIGHT DOWN AND RIGHT (present in WGL4)
  let b:forms_BDLightDownAndRight = '┌'
  " '┍' 9485 250D BOX DRAWINGS DOWN LIGHT AND RIGHT HEAVY
  let b:forms_BDDownLightAndRightHeavy = '┍'
  " '┎' 9486 250E BOX DRAWINGS DOWN HEAVY AND RIGHT LIGHT
  let b:forms_BDDownHeavyAndRightLight = '┎'
  " '┏' 9487 250F BOX DRAWINGS HEAVY DOWN AND RIGHT
  let b:forms_BDHeavyDownAndRight = '┏'
  " '┐' 9488 2510 BOX DRAWINGS LIGHT DOWN AND LEFT (present in WGL4)
  let b:forms_BDLightDownAndLeft = '┐'
  " '┑' 9489 2511 BOX DRAWINGS DOWN LIGHT AND LEFT HEAVY
  let b:forms_BDDownLightAndLeftHeavy = '┑'
  " '┒' 9490 2512 BOX DRAWINGS DOWN HEAVY AND LEFT LIGHT
  let b:forms_BDDownHeavyAndLeftLight = '┒'
  " '┓' 9491 2513 BOX DRAWINGS HEAVY DOWN AND LEFT
  let b:forms_BDHeavyDownAndLeft = '┓'
  " '└' 9492 2514 BOX DRAWINGS LIGHT UP AND RIGHT (present in WGL4)
  let b:forms_BDLightUpAndRight = '└'
  " '┕' 9493 2515 BOX DRAWINGS UP LIGHT AND RIGHT HEAVY
  let b:forms_BDUpLightAndRightHeavy = '┕'
  " '┖' 9494 2516 BOX DRAWINGS UP HEAVY AND RIGHT LIGHT
  let b:forms_BDUpHeavyAndRightLight = '┖'
  " '┗' 9495 2517 BOX DRAWINGS HEAVY UP AND RIGHT
  let b:forms_BDHeavyUpAndRight = '┗'
  " '┘' 9496 2518 BOX DRAWINGS LIGHT UP AND LEFT (present in WGL4)
  let b:forms_BDLightUpAndLeft = '┘'
  " '┙' 9497 2519 BOX DRAWINGS UP LIGHT AND LEFT HEAVY
  let b:forms_BDUpLightAndLeftHeavy = '┙'
  " '┚' 9498 251A BOX DRAWINGS UP HEAVY AND LEFT LIGHT
  let b:forms_BDUpHeavyAndLeftLight = '┚'
  " '┛' 9499 251B BOX DRAWINGS HEAVY UP AND LEFT        
  let b:forms_BDHeavyUpAndLeft = '┛'

  " '├' 9500 251C BOX DRAWINGS LIGHT VERTICAL AND RIGHT (present in WGL4)
  let b:forms_BDLightVerticalAndRight = '├'
  " '┝' 9501 251D BOX DRAWINGS VERTICAL LIGHT AND RIGHT HEAVY
  let b:forms_BDVerticalLightAndRIghtHeavy = '┝'
  " '┞' 9502 251E BOX DRAWINGS UP HEAVY AND RIGHT DOWN LIGHT
  let b:forms_BDUpHeavyAndRIghtDownLight = '┞'
  " '┟' 9503 251F BOX DRAWINGS DOWN HEAVY AND RIGHT UP LIGHT
  let b:forms_BDDownHeavyAndRightUpLight = '┟'
  " '┠' 9504 2520 BOX DRAWINGS VERTICAL HEAVY AND RIGHT LIGHT
  let b:forms_BDVerticalHeavyAndRightLight = '┠'
  " '┡' 9505 2521 BOX DRAWINGS DOWN LIGHT AND RIGHT UP HEAVY
  let b:forms_BDDownLightAndRIghtUpHeavy = '┡'
  " '┢' 9506 2522 BOX DRAWINGS UP LIGHT AND RIGHT DOWN HEAVY
  let b:forms_BDUpLightAndRightDownHeavy = '┢'
  " '┣' 9507 2523 BOX DRAWINGS HEAVY VERTICAL AND RIGHT
  let b:forms_BDHeavyVerticalAndRight = '┣'
  " '┤' 9508 2524 BOX DRAWINGS LIGHT VERTICAL AND LEFT (present in WGL4)
  let b:forms_BDLightVerticalAndLeft = '┤'
  " '┥' 9509 2525 BOX DRAWINGS VERTICAL LIGHT AND LEFT HEAVY
  let b:forms_BDVerticalLightAndLeftHeavy = '┥'
  " '┦' 9510 2526 BOX DRAWINGS UP HEAVY AND LEFT DOWN LIGHT       
  let b:forms_BDUpHeavyAndLeftDownLight = '┦'
  " '┧' 9511 2527 BOX DRAWINGS DOWN HEAVY AND LEFT UP LIGHT
  let b:forms_BDDownHeavyAndLeftUpLight = '┧'
  " '┨' 9512 2528 BOX DRAWINGS VERTICAL HEAVY AND LEFT LIGHT            
  let b:forms_BDVerticalHeavyAndLeftLight = '┨'
  " '┩' 9513 2529 BOX DRAWINGS DOWN LIGHT AND LEFT UP HEAVY
  let b:forms_BDDownLightAndLeftUpHeavy = '┩'
  " '┪' 9514 252A BOX DRAWINGS UP LIGHT AND LEFT DOWN HEAVY
  let b:forms_BDUpLightAndLeftDownHeavy = '┪'


  " '┫' 9515 252B BOX DRAWINGS HEAVY VERTICAL AND LEFT
  let b:forms_BDHeavyVerticalAndLeft = '┫'
  " '┬' 9516 252C BOX DRAWINGS LIGHT DOWN AND HORIZONTAL (present in WGL4)
  let b:forms_BDLightDownAndHorizontal = '┬'
  " '┭' 9517 252D BOX DRAWINGS LEFT HEAVY AND RIGHT DOWN LIGHT
  let b:forms_BDLeftHeavyAndRightDownLight = '┭'
  " '┮' 9518 252E BOX DRAWINGS RIGHT HEAVY AND LEFT DOWN LIGHT
  let b:forms_BDRightHeavyAndLeftDownLight = '┮'
  " '┯' 9519 252F BOX DRAWINGS DOWN LIGHT AND HORIZONTAL HEAVY
  let b:forms_BDDOwnLightAndHorizontalHeavy = '┯'
  " '┰' 9520 2530 BOX DRAWINGS DOWN HEAVY AND HORIZONTAL LIGHT
  let b:forms_BDDownHeavyAndHorizontalLight = '┰'
  " '┱' 9521 2531 BOX DRAWINGS RIGHT LIGHT AND LEFT DOWN HEAVY
  let b:forms_BDRightLightAndLeftDownHeavy = '┱'
  " '┲' 9522 2532 BOX DRAWINGS LEFT LIGHT AND RIGHT DOWN HEAVY
  let b:forms_BDLeftLightAndRightDownHeavy = '┲'
  " '┳' 9523 2533 BOX DRAWINGS HEAVY DOWN AND HORIZONTAL
  let b:forms_BDHeavyDownAndHorizontal = '┳'
  " '┴' 9524 2534 BOX DRAWINGS LIGHT UP AND HORIZONTAL (present in WGL4)
  let b:forms_BDLightUpAndHorizontal = '┴'
  " '┵' 9525 2535 BOX DRAWINGS LEFT HEAVY AND RIGHT UP LIGHT
  let b:forms_BDLeftHeavyAndRightUpLight = '┵'
  " '┶' 9526 2536 BOX DRAWINGS RIGHT HEAVY AND LEFT UP LIGHT
  let b:forms_BDRightHeavyAndLeftUpLight = '┶'
  " '┷' 9527 2537 BOX DRAWINGS UP LIGHT AND HORIZONTAL HEAVY
  let b:forms_BDUpLightAndHorizontalHeavy = '┷'
  " '┸' 9528 2538 BOX DRAWINGS UP HEAVY AND HORIZONTAL LIGHT
  let b:forms_BDUpHeavyAndHorizontalLight = '┸'
  " '┹' 9529 2539 BOX DRAWINGS RIGHT LIGHT AND LEFT UP HEAVY
  let b:forms_BDRightLightAndLeftUpHeavy = '┹'
  " '┺' 9530 253A BOX DRAWINGS LEFT LIGHT AND RIGHT UP HEAVY
  let b:forms_BDLeftLightAndRightUpHeavy = '┺'

  " '┻' 9531 253B BOX DRAWINGS HEAVY UP AND HORIZONTAL
  let b:forms_BDHeavyUpAndHorizontal = '┻'
  " '┼' 9532 253C BOX DRAWINGS LIGHT VERTICAL AND HORIZONTAL (present in WGL4)
  let b:forms_BDLightVerticalAndHorizontal = '┼'
  " '┽' 9533 253D BOX DRAWINGS LEFT HEAVY AND RIGHT VERTICAL LIGHT
  let b:forms_BDLeftHeavyAndRIghtVerticalLight = '┽'
  " '┾' 9534 253E BOX DRAWINGS RIGHT HEAVY AND LEFT VERTICAL LIGHT
  let b:forms_BDRIghtHeavyAndLeftVerticalLight = '┾'
  " '┿' 9535 253F BOX DRAWINGS VERTICAL LIGHT AND HORIZONTAL HEAVY
  let b:forms_BDVerticalLightAndHorizontalHeavy = '┿'
  " '╀' 9536 2540 BOX DRAWINGS UP HEAVY AND DOWN HORIZONTAL LIGHT
  let b:forms_BDUpHeavyAndDownHorizontalLight = '╀'
  " '╁' 9537 2541 BOX DRAWINGS DOWN HEAVY AND UP HORIZONTAL LIGHT
  let b:forms_BDDownHeavyAndUPHorizontalLight = '╁'
  " '╂' 9538 2542 BOX DRAWINGS VERTICAL HEAVY AND HORIZONTAL LIGHT
  let b:forms_BDVerticalHeavyAndHorizontalLight = '╂'
  " '╃' 9539 2543 BOX DRAWINGS LEFT UP HEAVY AND RIGHT DOWN LIGHT
  let b:forms_BDLeftUpHeavyAndRightDownLight = '╃'
  " '╄' 9540 2544 BOX DRAWINGS RIGHT UP HEAVY AND LEFT DOWN LIGHT
  let b:forms_BDRightUpHeavyAndLeftDownLight = '╄'
  " '╅' 9541 2545 BOX DRAWINGS LEFT DOWN HEAVY AND RIGHT UP LIGHT
  let b:forms_BDLeftDownHeavyAndRightUpLight = '╅'
  " '╆' 9542 2546 BOX DRAWINGS RIGHT DOWN HEAVY AND LEFT UP LIGHT
  let b:forms_BDRightDownHeavyAndLeftUpLight = '╆'
  " '╇' 9543 2547 BOX DRAWINGS DOWN LIGHT AND UP HORIZONTAL HEAVY
  let b:forms_BDDownLightAndUpHorizontalHeavy = '╇'
  " '╈' 9544 2548 BOX DRAWINGS UP LIGHT AND DOWN HORIZONTAL HEAVY
  let b:forms_BDUpLightAndDownHorizontalHeavy = '╈'
  " '╉' 9545 2549 BOX DRAWINGS RIGHT LIGHT AND LEFT VERTICAL HEAVY
  let b:forms_BDRightLightAndLeftVerticalHeavy = '╉'
  " '╊' 9546 254A BOX DRAWINGS LEFT LIGHT AND RIGHT VERTICAL HEAVY
  let b:forms_BDLeftLightAndRightVerticalHeavy = '╊'
  " '╋' 9547 254B BOX DRAWINGS HEAVY VERTICAL AND HORIZONTAL        
  let b:forms_BDHeavyVerticalAndHorizontal = '╋'


  " '╌' 9548 254C BOX DRAWINGS LIGHT DOUBLE DASH HORIZONTAL
  let b:forms_BDLightDoubleDashHorizontal = '╌'
  " '╍' 9549 254D BOX DRAWINGS HEAVY DOUBLE DASH HORIZONTAL
  let b:forms_BDHeavyDoubleDashHorizontal = '╍'
  " '╎' 9550 254E BOX DRAWINGS LIGHT DOUBLE DASH VERTICAL
  let b:forms_BDLightDoubleDashVertical = '╎'
  " '╏' 9551 254F BOX DRAWINGS HEAVY DOUBLE DASH VERTICAL
  let b:forms_BDHeavyDoubleDashVertical = '╏'


  " '═' 9552 2550 BOX DRAWINGS DOUBLE HORIZONTAL (present in WGL4)
  let b:forms_BDDoubleHorizontal = '═'
  " '║' 9553 2551 BOX DRAWINGS DOUBLE VERTICAL (present in WGL4)
  let b:forms_BDDoubleVertical = '║'
  " '╒' 9554 2552 BOX DRAWINGS DOWN SINGLE AND RIGHT DOUBLE (present in WGL4)
  let b:forms_BDDownSingleAndRightDouble = '╒'
  " '╓' 9555 2553 BOX DRAWINGS DOWN DOUBLE AND RIGHT SINGLE (present in WGL4)
  let b:forms_BDDownDoubleAndRightSingle = '╓'
  " '╔' 9556 2554 BOX DRAWINGS DOUBLE DOWN AND RIGHT (present in WGL4)
  let b:forms_BDDoubleDownAndRight = '╔'
  " '╕' 9557 2555 BOX DRAWINGS DOWN SINGLE AND LEFT DOUBLE (present inWGL4)
  let b:forms_BDDownSingleAndLeftDouble = '╕'
  " '╖' 9558 2556 BOX DRAWINGS DOWN DOUBLE AND LEFT SINGLE (present in WGL4)
  let b:forms_BDDownDoubleAndLeftSingle = '╖'
  " '╗' 9559 2557 BOX DRAWINGS DOUBLE DOWN AND LEFT (present in WGL4)
  let b:forms_BDDoubleDownAndLeft = '╗'
  " '╘' 9560 2558 BOX DRAWINGS UP SINGLE AND RIGHT DOUBLE (present in WGL4)
  let b:forms_BDUpSingleAndRightDouble = '╘'
  " '╙' 9561 2559 BOX DRAWINGS UP DOUBLE AND RIGHT SINGLE (present in WGL4)
  let b:forms_BDUpDoubleAndRightSingle = '╙'
  " '╚' 9562 255A BOX DRAWINGS DOUBLE UP AND RIGHT (present in WGL4)
  let b:forms_BDDoubleUpAndRight = '╚'
  " '╛' 9563 255B BOX DRAWINGS UP SINGLE AND LEFT DOUBLE (present in WGL4)
  let b:forms_BDUpSingleAndLeftDouble = '╛'
  " '╜' 9564 255C BOX DRAWINGS UP DOUBLE AND LEFT SINGLE (present in WGL4)
  let b:forms_BDUpDoubleAndLeftSingle = '╜'
  " '╝' 9565 255D BOX DRAWINGS DOUBLE UP AND LEFT (present in WGL4)
  let b:forms_BDDoubleUpAndleft = '╝'
  " '╞' 9566 255E BOX DRAWINGS VERTICAL SINGLE AND RIGHT DOUBLE (present in WGL4)
  let b:forms_BDVerticalSingleAndRightDouble = '╞'
  " '╟' 9567 255F BOX DRAWINGS VERTICAL DOUBLE AND RIGHT SINGLE (present in WGL4)
  let b:forms_BDVertialDoubleAndRightSingle = '╟'
  " '╠' 9568 2560 BOX DRAWINGS DOUBLE VERTICAL AND RIGHT (present in WGL4)
  let b:forms_BDDoubleVerticalAndRight = '╠'
  " '╡' 9569 2561 BOX DRAWINGS VERTICAL SINGLE AND LEFT DOUBLE (present in WGL4)
  let b:forms_BDVerticalSingleAndLeftDouble = '╡'
  " '╢' 9570 2562 BOX DRAWINGS VERTICAL DOUBLE AND LEFT SINGLE (present in WGL4)
  let b:forms_BDVerticalDoubleAndLeftSingle = '╢'
  " '╣' 9571 2563 BOX DRAWINGS DOUBLE VERTICAL AND LEFT (present in WGL4)    
  let b:forms_BDDoubleVerticalAndLeft = '╣'
  " '╤' 9572 2564 BOX DRAWINGS DOWN SINGLE AND HORIZONTAL DOUBLE (present in WGL4)
  let b:forms_BDDownSingleAndHorizontalDouble = '╤'
  " '╥' 9573 2565 BOX DRAWINGS DOWN DOUBLE AND HORIZONTAL SINGLE (present in WGL4)
  let b:forms_BDDownDoubleAndHorizontalSingle = '╥'
  " '╦' 9574 2566 BOX DRAWINGS DOUBLE DOWN AND HORIZONTAL (present in WGL4)
  let b:forms_BDDoubleDownAndHorizontal = '╦'
  " '╧' 9575 2567 BOX DRAWINGS UP SINGLE AND HORIZONTAL DOUBLE (present in WGL4)
  let b:forms_BDUpSingleAndHorizontalDouble = '╧'
  " '╨' 9576 2568 BOX DRAWINGS UP DOUBLE AND HORIZONTAL SINGLE (present in WGL4)
  let b:forms_BDUpDoubleAndHorizontalSingle = '╨'
  " '╩' 9577 2569 BOX DRAWINGS DOUBLE UP AND HORIZONTAL (present in WGL4)
  let b:forms_BDDoubleUpAndHorizontal = '╩'
  " '╪' 9578 256A BOX DRAWINGS VERTICAL SINGLE AND HORIZONTAL DOUBLE (present in WGL4)
  let b:forms_BDVertialSingleAndHorizontalDouble = '╪'
  " '╫' 9579 256B BOX DRAWINGS VERTICAL DOUBLE AND HORIZONTAL SINGLE (present in WGL4)
  let b:forms_BDVertialDoubleAndHorixontalSingle = '╫'
  " '╬' 9580 256C BOX DRAWINGS DOUBLE VERTICAL AND HORIZONTAL (present in WGL4)
  let b:forms_BDDoubleVerticalAndHorizontal = '╬'



  " '╭' 9581 256D BOX DRAWINGS LIGHT ARC DOWN AND RIGH        T
  let b:forms_BDLightArchDownAndRight = '╭'
  " '╮' 9582 256E BOX DRAWINGS LIGHT ARC DOWN AND LEFT
  let b:forms_BDLightArchDownAndLeft = '╮'
  " '╯' 9583 256F BOX DRAWINGS LIGHT ARC UP AND LEFT
  let b:forms_BDLightArchUpAndLeft = '╯'
  " '╰' 9584 2570 BOX DRAWINGS LIGHT ARC UP AND RIGHT
  let b:forms_BDLightArchUpAndRight = '╰'


  " '╱' 9585 2571 BOX DRAWINGS LIGHT DIAGONAL UPPER RIGHT TO LOWER LEFT
  let b:forms_BDLightDiagonalUpperRightToLowerLeft = '╱'
  " '╲' 9586 2572 BOX DRAWINGS LIGHT DIAGONAL UPPER LEFT TO LOWER RIGHT       
  let b:forms_BDLightDiagonalUpperLeftToLowerRight = '╲'
  " '╳' 9587 2573 BOX DRAWINGS LIGHT DIAGONAL CROSS       
  let b:forms_BDLightDiagonalCross = '╳'


  " '╴' 9588 2574 BOX DRAWINGS LIGHT LEFT
  let b:forms_BDLightLeft = '╴'
  " '╵' 9589 2575 BOX DRAWINGS LIGHT UP
  let b:forms_BDLightUp = '╵'
  " '╶' 9590 2576 BOX DRAWINGS LIGHT RIGHT
  let b:forms_BDLightRight = '╶'
  " '╷' 9591 2577 BOX DRAWINGS LIGHT DOWN
  let b:forms_BDLightDown = '╷'
  " '╸' 9592 2578 BOX DRAWINGS HEAVY LEFT         
  let b:forms_BDHeavyLeft = '╸'
  " '╹' 9593 2579 BOX DRAWINGS HEAVY UP
  let b:forms_BDHeavyUp = '╹'
  " '╺' 9594 257A BOX DRAWINGS HEAVY RIGHT
  let b:forms_BDHeavyRight = '╺'
  " '╻' 9595 257B BOX DRAWINGS HEAVY DOWN
  let b:forms_BDHeavyDown = '╻'
  " '╼' 9596 257C BOX DRAWINGS LIGHT LEFT AND HEAVY RIGHT
  let b:forms_BDLightLeftAndHeavyRight = '╼'
  " '╽' 9597 257D BOX DRAWINGS LIGHT UP AND HEAVY DOWN
  let b:forms_BDLightUpAndHeavyDown = '╽'
  " '╾' 9598 257E BOX DRAWINGS HEAVY LEFT AND LIGHT RIGHT
  let b:forms_BDHeavyLeftAndLightRight = '╾'
  " '╿' 9599 257F BOX DRAWINGS HEAVY UP AND LIGHT DOWN        
  let b:forms_BDHeavyUpAndLightDown = '╿'

  let b:forms_BoxDrawingCharacters = 1
endif

if !exists("b:forms_BlockCharacters") 

  " '▀' 9600 2580 UPPER HALF BLOCK (present in WGL4)
  let b:forms_UpperHalfB = '▀'
  " '▁' 9601 2581  LOWER ONE EIGHTH BLOCK
  let b:forms_LowerOneEighthB = '▁'
  " '▂' 9602 2582 LOWER ONE QUARTER BLOCK
  let b:forms_LowerOneQuarterB = '▂'
  " '▃' 9603 2583 LOWER THREE EIGHTHS BLOCK
  let b:forms_LowerThreeEighthsB = '▃'
  " '▄' 9604 2584 LOWER HALF BLOCK (present in WGL4)
  let b:forms_LowerHalfB = '▄'
  " '▅' 9605 2585 LOWER FIVE EIGHTHS BLOCK
  let b:forms_LowerFiveEighthsB = '▅'
  " '▆' 9606 2586 LOWER THREE QUARTERS BLOCK
  let b:forms_LowerThreeQuartersB = '▆'
  " '▇' 9607 2587 LOWER SEVEN EIGHTHS BLOCK
  let b:forms_LowerSevenEighthsB = '▇'


  " '█' 9608 2588 FULL BLOCK (present in WGL4)
  let b:forms_FullB = '█'
  " '▉' 9609 2589 LEFT SEVEN EIGHTHS BLOCK        
  let b:forms_LeftSevenEighthsB = '▉'
  " '▊' 9610 258A LEFT THREE QUARTERS BLOCK
  let b:forms_LeftThreeQuartersB = '▊'
  " '▋' 9611 258B LEFT FIVE EIGHTHS BLOCK
  let b:forms_leftFiveEighthsB = '▋'
  " '▌' 9612 258C LEFT HALF BLOCK (present in WGL4)
  let b:forms_LeftHalfB = '▌'
  " '▍' 9613 258D LEFT THREE EIGHTHS BLOCK
  let b:forms_LeftThreeEighthsB = '▍'
  " '▎' 9614 258E LEFT ONE QUARTER BLOCK
  let b:forms_LeftOneQuarterB = '▎'
  " '▏' 9615 258F LEFT ONE EIGHTH BLOCK
  let b:forms_LeftOneEighthsB = '▏'


  " '▐' 9616 2590 RIGHT HALF BLOCK (present in WGL4)
  let b:forms_RightHalfB = '▐' 
  " '░' 9617 2591 LIGHT SHADE (present in WGL4)
  let b:forms_LightShade = '░'
  " '▒' 9618 2592 MEDIUM SHADE (present in WGL4)
  let b:forms_MediumShade = '▒'
  " '▓' 9619 2593 DARK SHADE (present in WGL4)
  let b:forms_DarkShade = '▓'


  " '▔' 9620 2594 UPPER ONE EIGHTH BLOCK
  let b:forms_UpperOneEighthsB = '▔'
  " '▕' 9621 2595 RIGHT ONE EIGHTH BLOCK
  let b:forms_RightOneEighthsB = '▕'
  " '▖' 9622 2596 QUADRANT LOWER LEFT
  let b:forms_QuardrantLowerLeft = '▖'
  " '▗' 9623 2597 QUADRANT LOWER RIGHT
  let b:forms_QuardrantLowerRight = '▗'
  " '▘' 9624 2598 QUADRANT UPPER LEFT
  let b:forms_QuardrantUpperLeft = '▘'
  " '▙' 9625 2599 QUADRANT UPPER LEFT AND LOWER LEFT AND LOWER RIGHT
  let b:forms_QuardrantUpperLeftAndLowerLeftAndLowerRight = '▙'
  " '▚' 9626 259A QUADRANT UPPER LEFT AND LOWER RIGHT
  let b:forms_QuadrantUpperLeftAndLowerRight = '▚'
  " '▛' 9627 259B QUADRANT UPPER LEFT AND UPPER RIGHT AND LOWER LEFT
  let b:forms_QuadrantUpperLeftAndUpperRightAndLowerLeft = '▛'
  " '▜' 9628 259C QUADRANT UPPER LEFT AND UPPER RIGHT AND LOWER RIGHT
  let b:forms_QuadrantUpperLeftAndUpperRightAndLowerRight = '▜'
  " '▝' 9629 259D QUADRANT UPPER RIGHT
  let b:forms_QuadrantUpperRight = '▝'
  " '▞' 9630 259E QUADRANT UPPER RIGHT AND LOWER LEFT
  let b:forms_QuadrantUpperRightAndLowerLeft = '▞'
  " '▟' 9631 259F QUADRANT UPPER RIGHT AND LOWER LEFT AND LOWER RIGHT 
  let b:forms_QuadrantUpperRightAndLowerLeftAndLowerRight = '▟'

  let b:forms_BlockCharacters = 1
endif

if !exists("b:forms_GeometricShapes") 

  " '◢' 9698 25E2  BLACK LOWER RIGHT TRIANGLE
  let b:forms_GSBlackLowerRightTriangle = '◢'
  " '◣' 9699 25E3  BLACK LOWER LEFT TRIANGLE
  let b:forms_GSBlackLowerLeftTriangle = '◣'
  " '◤' 9700 25E4  BLACK UPPER LEFT TRIANGLE
  let b:forms_GSBlackUpperLeftTriangle = '◤'
  " '◥' 9701 25E5  BLACK UPPER RIGHT TRIANGLE  
  let b:forms_GSBlackUpperRightTriangle = '◥'

  let b:forms_GeometricShapes = 1
endif

"---------------------------------------------------------------------------
" Map of Box Drawing Character Sets: {{{2
"-------------------------------------------------------------------------------
" format for box drawing char set: dr  uh  dl  rv  ul  lh  ur  lv
"     down-right, upper-horizontal, down-left, right-vertial
"     up-left, lower-horizontal, up-right, left-vertial
" Set names:
"    default                 : non UFT-8
"    light                   :
"    heavy                   :
"    double                  :
"    light_arc               :
"    light_double_dash       :
"    light_double_dash_arc   :
"    heavy_double_dash       :
"    heavy_triple_dash       :
"    light_quadruple_dash    :
"    light_quadruple_dash_arc :
"    heavy_quadruple_dash    :
"    block                   :
"    semi_block              :
"    triangle_block          :
"----------------------------------------------------------------
let s:boxDrawingCharacterSets = {}

let s:boxDrawingCharacterSets['default'] = [
                        \ b:forms_dr,
                        \ b:forms_horz,
                        \ b:forms_dl,
                        \ b:forms_vert,
                        \ b:forms_ul,
                        \ b:forms_horz,
                        \ b:forms_ur,
                        \ b:forms_vert,
                        \ ]

let s:boxDrawingCharacterSets['light'] = [
                        \ b:forms_BDLightDownAndRight,
                        \ b:forms_BDLightHorizontal,
                        \ b:forms_BDLightDownAndLeft,
                        \ b:forms_BDLightVertical,
                        \ b:forms_BDLightUpAndLeft,
                        \ b:forms_BDLightHorizontal,
                        \ b:forms_BDLightUpAndRight,
                        \ b:forms_BDLightVertical,
                        \ ]

let s:boxDrawingCharacterSets['heavy'] = [
                        \ b:forms_BDHeavyDownAndRight,
                        \ b:forms_BDHeavyHorizontal,
                        \ b:forms_BDHeavyDownAndLeft,
                        \ b:forms_BDHeavyVertical,
                        \ b:forms_BDHeavyUpAndLeft,
                        \ b:forms_BDHeavyHorizontal,
                        \ b:forms_BDHeavyUpAndRight,
                        \ b:forms_BDHeavyVertical,
                        \ ]

let s:boxDrawingCharacterSets['double'] = [
                        \ b:forms_BDDoubleDownAndRight,
                        \ b:forms_BDDoubleHorizontal,
                        \ b:forms_BDDoubleDownAndLeft,
                        \ b:forms_BDDoubleVertical,
                        \ b:forms_BDDoubleUpAndleft,
                        \ b:forms_BDDoubleHorizontal,
                        \ b:forms_BDDoubleUpAndRight,
                        \ b:forms_BDDoubleVertical,
                        \ ]

let s:boxDrawingCharacterSets['light_arc'] = [
                        \ b:forms_BDLightArchDownAndRight,
                        \ b:forms_BDLightHorizontal,
                        \ b:forms_BDLightArchDownAndLeft,
                        \ b:forms_BDLightVertical,
                        \ b:forms_BDLightArchUpAndLeft,
                        \ b:forms_BDLightHorizontal,
                        \ b:forms_BDLightArchUpAndRight,
                        \ b:forms_BDLightVertical,
                        \ ]

let s:boxDrawingCharacterSets['light_double_dash'] = [
                        \ b:forms_BDLightDownAndRight,
                        \ b:forms_BDLightDoubleDashHorizontal,
                        \ b:forms_BDLightDownAndLeft,
                        \ b:forms_BDLightDoubleDashVertical,
                        \ b:forms_BDLightUpAndLeft,
                        \ b:forms_BDLightDoubleDashHorizontal,
                        \ b:forms_BDLightUpAndRight,
                        \ b:forms_BDLightDoubleDashVertical
                        \ ]

let s:boxDrawingCharacterSets['light_double_dash_arc'] = [
                        \ b:forms_BDLightArchDownAndRight,
                        \ b:forms_BDLightDoubleDashHorizontal,
                        \ b:forms_BDLightArchDownAndLeft,
                        \ b:forms_BDLightDoubleDashVertical,
                        \ b:forms_BDLightArchUpAndLeft,
                        \ b:forms_BDLightDoubleDashHorizontal,
                        \ b:forms_BDLightArchUpAndRight,
                        \ b:forms_BDLightDoubleDashVertical
                        \ ]

let s:boxDrawingCharacterSets['heavy_double_dash'] = [
                        \ b:forms_BDHeavyDownAndRight,
                        \ b:forms_BDHeavyDoubleDashHorizontal,
                        \ b:forms_BDHeavyDownAndLeft,
                        \ b:forms_BDHeavyDoubleDashVertical,
                        \ b:forms_BDHeavyUpAndLeft,
                        \ b:forms_BDHeavyDoubleDashHorizontal,
                        \ b:forms_BDHeavyUpAndRight,
                        \ b:forms_BDHeavyDoubleDashVertical
                        \ ]

let s:boxDrawingCharacterSets['light_triple_dash'] = [
                        \ b:forms_BDLightDownAndRight,
                        \ b:forms_BDLightTripleDashHorizontal,
                        \ b:forms_BDLightDownAndLeft,
                        \ b:forms_BDLightTripleDashVertical,
                        \ b:forms_BDLightUpAndLeft,
                        \ b:forms_BDLightTripleDashHorizontal,
                        \ b:forms_BDLightUpAndRight,
                        \ b:forms_BDLightTripleDashVertical
                        \ ]

let s:boxDrawingCharacterSets['light_triple_dash_arc'] = [
                        \ b:forms_BDLightArchDownAndRight,
                        \ b:forms_BDLightTripleDashHorizontal,
                        \ b:forms_BDLightArchDownAndLeft,
                        \ b:forms_BDLightTripleDashVertical,
                        \ b:forms_BDLightArchUpAndLeft,
                        \ b:forms_BDLightTripleDashHorizontal,
                        \ b:forms_BDLightArchUpAndRight,
                        \ b:forms_BDLightTripleDashVertical
                        \ ]

let s:boxDrawingCharacterSets['heavy_triple_dash'] = [
                        \ b:forms_BDHeavyDownAndRight,
                        \ b:forms_BDHeavyTripleDashHorizontal,
                        \ b:forms_BDHeavyDownAndLeft,
                        \ b:forms_BDHeavyTripleDashVertical,
                        \ b:forms_BDHeavyUpAndLeft,
                        \ b:forms_BDHeavyTripleDashHorizontal,
                        \ b:forms_BDHeavyUpAndRight,
                        \ b:forms_BDHeavyTripleDashVertical
                        \ ]

let s:boxDrawingCharacterSets['light_quadruple_dash'] = [
                        \ b:forms_BDLightDownAndRight,
                        \ b:forms_BDLightQuadrupleDashHorizontal,
                        \ b:forms_BDLightDownAndLeft,
                        \ b:forms_BDLightQuadrupleDashVertical,
                        \ b:forms_BDLightUpAndLeft,
                        \ b:forms_BDLightQuadrupleDashHorizontal,
                        \ b:forms_BDLightUpAndRight,
                        \ b:forms_BDLightQuadrupleDashVertical
                        \ ]

let s:boxDrawingCharacterSets['light_quadruple_dash_arc'] = [
                        \ b:forms_BDLightArchDownAndRight,
                        \ b:forms_BDLightQuadrupleDashHorizontal,
                        \ b:forms_BDLightArchDownAndLeft,
                        \ b:forms_BDLightQuadrupleDashVertical,
                        \ b:forms_BDLightArchUpAndLeft,
                        \ b:forms_BDLightQuadrupleDashHorizontal,
                        \ b:forms_BDLightArchUpAndRight,
                        \ b:forms_BDLightQuadrupleDashVertical
                        \ ]

let s:boxDrawingCharacterSets['heavy_quadruple_dash'] = [
                        \ b:forms_BDHeavyDownAndRight,
                        \ b:forms_BDHeavyQuadrupleDashHorizontal,
                        \ b:forms_BDHeavyDownAndLeft,
                        \ b:forms_BDHeavyQuadrupleDashVertical,
                        \ b:forms_BDHeavyUpAndLeft,
                        \ b:forms_BDHeavyQuadrupleDashHorizontal,
                        \ b:forms_BDHeavyUpAndRight,
                        \ b:forms_BDHeavyQuadrupleDashVertical
                        \ ]

let s:boxDrawingCharacterSets['block'] = [
                        \ b:forms_QuadrantUpperLeftAndUpperRightAndLowerLeft,
                        \ b:forms_UpperHalfB,
                        \ b:forms_QuadrantUpperLeftAndUpperRightAndLowerRight,
                        \ b:forms_RightHalfB,
                        \ b:forms_QuadrantUpperRightAndLowerLeftAndLowerRight,
                        \ b:forms_LowerHalfB,
                        \ b:forms_QuardrantUpperLeftAndLowerLeftAndLowerRight,
                        \ b:forms_LeftHalfB
                        \ ]

let s:boxDrawingCharacterSets['semi_block'] = [
                        \ b:forms_QuadrantUpperRightAndLowerLeft,
                        \ b:forms_UpperHalfB,
                        \ b:forms_QuadrantUpperLeftAndLowerRight,
                        \ b:forms_RightHalfB,
                        \ b:forms_QuadrantUpperRightAndLowerLeft,
                        \ b:forms_LowerHalfB,
                        \ b:forms_QuadrantUpperLeftAndLowerRight,
                        \ b:forms_LeftHalfB
                        \ ]

let s:boxDrawingCharacterSets['triangle_block'] = [
                        \ b:forms_GSBlackUpperLeftTriangle,
                        \ b:forms_UpperOneEighthsB,
                        \ b:forms_GSBlackUpperRightTriangle,
                        \ b:forms_RightOneEighthsB,
                        \ b:forms_GSBlackLowerRightTriangle,
                        \ b:forms_LowerOneEighthB,
                        \ b:forms_GSBlackLowerLeftTriangle,
                        \ b:forms_LeftOneEighthsB
                        \ ]


function! forms#LookupVerticalCharacter(name)
  return forms#LookupBoxDrawingCharacterSet(a:name)[3]
endfunction
function! forms#LookupHorizontalCharacter(name)
  return forms#LookupBoxDrawingCharacterSet(a:name)[1]
endfunction

function! forms#existsBoxDrawingCharacterSet(name)
  return has_key(s:boxDrawingCharacterSets, a:name)
endfunction

function! forms#addBoxDrawingCharacter(name)
  let n = a:name
  call forms#addBoxDrawingCharacterSet(n, n, n, n, n, n, n, n, n,)
endfunction

function! forms#addBoxDrawingCharacterSet(name, dr, uh, dl, rv, ul, lh, ur, lv,)
  if ! has_key(s:boxDrawingCharacterSets, a:name)
    let s:boxDrawingCharacterSets[a:name] = [
                            \ a:dr,
                            \ a:uh,
                            \ a:dl,
                            \ a:rv,
                            \ a:ul,
                            \ a:lh,
                            \ a:ur,
                            \ a:lv
                            \ ]

    return g:self#IS_TRUE
  else
    return g:self#IS_FALSE
  endif
endfunction

function! forms#LookupBoxDrawingCharacterSet(name)
  if has_key(s:boxDrawingCharacterSets, a:name)
    return s:boxDrawingCharacterSets[a:name]
  else
    call forms#log("LookupBoxDrawingCharacterSet: unknown box drawing character set: " . a:name)
    if &encoding == 'utf-8'
      return s:boxDrawingCharacterSets['light']
    else
      return s:boxDrawingCharacterSets['default']
    endif
  endif
endfunction

"----------------------------------------------------------------
" Down and Horizontal characters: {{{2
"----------------------------------------------------------------
let s:boxDownAndHorizontal = {}
let s:boxDownAndHorizontal['default'] = b:forms_d
let s:boxDownAndHorizontal['light']   = b:forms_BDLightDownAndHorizontal 
let s:boxDownAndHorizontal['light_arc']   = b:forms_BDLightDownAndHorizontal 
let s:boxDownAndHorizontal['light_double_dash']   = b:forms_BDLightDownAndHorizontal 
let s:boxDownAndHorizontal['light_double_dash_arc']   = b:forms_BDLightDownAndHorizontal 
let s:boxDownAndHorizontal['light_triple_dash'] =  b:forms_BDLightDownAndHorizontal
let s:boxDownAndHorizontal['light_triple_dash_arc'] =  b:forms_BDLightDownAndHorizontal
let s:boxDownAndHorizontal['light_quadruple_dash'] =  b:forms_BDLightDownAndHorizontal
let s:boxDownAndHorizontal['light_quadruple_dash_arc'] =  b:forms_BDLightDownAndHorizontal


let s:boxDownAndHorizontal['heavy']   = b:forms_BDHeavyDownAndHorizontal
let s:boxDownAndHorizontal['heavy_double_dash'] = b:forms_BDHeavyDownAndHorizontal
let s:boxDownAndHorizontal['heavy_triple_dash'] = b:forms_BDHeavyDownAndHorizontal
let s:boxDownAndHorizontal['heavy_quadruple_dash'] = b:forms_BDHeavyDownAndHorizontal

let s:boxDownAndHorizontal['double']  = b:forms_BDDoubleDownAndHorizontal

let s:boxDownAndHorizontal['block'] = b:forms_FullB
let s:boxDownAndHorizontal['semi_block'] = b:forms_FullB
let s:boxDownAndHorizontal['triangle_block'] = b:forms_FullB

function! forms#LookupDownAndHorizontal(name)
  if has_key(s:boxDownAndHorizontal, a:name)
    return s:boxDownAndHorizontal[a:name]
  else
    if &encoding == 'utf-8'
      return s:boxDownAndHorizontal['light']
    else
      return s:forms_d
    endif
  endif
endfunction

"----------------------------------------------------------------
" Up and Horizontal characters: {{{2
"----------------------------------------------------------------
let s:boxUpAndHorizontal = {}
let s:boxUpAndHorizontal['default'] = b:forms_u
let s:boxUpAndHorizontal['light']   = b:forms_BDLightUpAndHorizontal 
let s:boxUpAndHorizontal['light_arc']   = b:forms_BDLightUpAndHorizontal 
let s:boxUpAndHorizontal['light_double_dash']   = b:forms_BDLightUpAndHorizontal 
let s:boxUpAndHorizontal['light_double_dash_arc']   = b:forms_BDLightUpAndHorizontal 
let s:boxUpAndHorizontal['light_triple_dash'] =  b:forms_BDLightUpAndHorizontal
let s:boxUpAndHorizontal['light_triple_dash_arc'] =  b:forms_BDLightUpAndHorizontal
let s:boxUpAndHorizontal['light_quadruple_dash'] =  b:forms_BDLightUpAndHorizontal
let s:boxUpAndHorizontal['light_quadruple_dash_arc'] =  b:forms_BDLightUpAndHorizontal


let s:boxUpAndHorizontal['heavy']   = b:forms_BDHeavyUpAndHorizontal
let s:boxUpAndHorizontal['heavy_double_dash'] = b:forms_BDHeavyUpAndHorizontal
let s:boxUpAndHorizontal['heavy_triple_dash'] = b:forms_BDHeavyUpAndHorizontal
let s:boxUpAndHorizontal['heavy_quadruple_dash'] = b:forms_BDHeavyUpAndHorizontal

let s:boxUpAndHorizontal['double'] = b:forms_BDDoubleUpAndHorizontal

let s:boxUpAndHorizontal['block'] = b:forms_FullB
let s:boxUpAndHorizontal['semi_block'] = b:forms_FullB
let s:boxUpAndHorizontal['triangle_block'] = b:forms_FullB

function! forms#LookupUpAndHorizontal(name)
  if has_key(s:boxUpAndHorizontal, a:name)
    return s:boxUpAndHorizontal[a:name]
  else
    if &encoding == 'utf-8'
      return s:boxUpAndHorizontal['light']
    else
      return s:forms_u
    endif
  endif
endfunction


"----------------------------------------------------------------
" Left and Vertical characters: {{{2
"----------------------------------------------------------------
let s:boxVerticalAndLeft = {}
let s:boxVerticalAndLeft['default'] = b:forms_l
let s:boxVerticalAndLeft['light']   = b:forms_BDLightVerticalAndLeft 
let s:boxVerticalAndLeft['light_arc']   = b:forms_BDLightVerticalAndLeft 
let s:boxVerticalAndLeft['light_double_dash']   = b:forms_BDLightVerticalAndLeft 
let s:boxVerticalAndLeft['light_double_dash_arc']   = b:forms_BDLightVerticalAndLeft 
let s:boxVerticalAndLeft['light_triple_dash'] =  b:forms_BDLightVerticalAndLeft
let s:boxVerticalAndLeft['light_triple_dash_arc'] =  b:forms_BDLightVerticalAndLeft
let s:boxVerticalAndLeft['light_quadruple_dash'] =  b:forms_BDLightVerticalAndLeft
let s:boxVerticalAndLeft['light_quadruple_dash_arc'] =  b:forms_BDLightVerticalAndLeft


let s:boxVerticalAndLeft['heavy']   = b:forms_BDHeavyVerticalAndLeft
let s:boxVerticalAndLeft['heavy_double_dash'] = b:forms_BDHeavyVerticalAndLeft
let s:boxVerticalAndLeft['heavy_triple_dash'] = b:forms_BDHeavyVerticalAndLeft
let s:boxVerticalAndLeft['heavy_quadruple_dash'] = b:forms_BDHeavyVerticalAndLeft

let s:boxVerticalAndLeft['double']  = b:forms_BDDoubleVerticalAndLeft

let s:boxVerticalAndLeft['block'] = b:forms_FullB
let s:boxVerticalAndLeft['semi_block'] = b:forms_FullB
let s:boxVerticalAndLeft['triangle_block'] = b:forms_FullB

function! forms#LookupVerticalAndLeft(name)
  if has_key(s:boxVerticalAndLeft, a:name)
    return s:boxVerticalAndLeft[a:name]
  else
    if &encoding == 'utf-8'
      return s:boxVerticalAndLeft['light']
    else
      return s:forms_l
    endif
  endif
endfunction

"----------------------------------------------------------------
" Up and Vertical characters: {{{2
"----------------------------------------------------------------
let s:boxVerticalAndRight = {}
let s:boxVerticalAndRight['default'] = b:forms_r
let s:boxVerticalAndRight['light']   = b:forms_BDLightVerticalAndRight 
let s:boxVerticalAndRight['light_arc']   = b:forms_BDLightVerticalAndRight 
let s:boxVerticalAndRight['light_double_dash']   = b:forms_BDLightVerticalAndRight 
let s:boxVerticalAndRight['light_double_dash_arc']   = b:forms_BDLightVerticalAndRight 
let s:boxVerticalAndRight['light_triple_dash'] =  b:forms_BDLightVerticalAndRight
let s:boxVerticalAndRight['light_triple_dash_arc'] =  b:forms_BDLightVerticalAndRight
let s:boxVerticalAndRight['light_quadruple_dash'] =  b:forms_BDLightVerticalAndRight
let s:boxVerticalAndRight['light_quadruple_dash_arc'] =  b:forms_BDLightVerticalAndRight


let s:boxVerticalAndRight['heavy']   = b:forms_BDHeavyVerticalAndRight
let s:boxVerticalAndRight['heavy_double_dash'] = b:forms_BDHeavyVerticalAndRight
let s:boxVerticalAndRight['heavy_triple_dash'] = b:forms_BDHeavyVerticalAndRight
let s:boxVerticalAndRight['heavy_quadruple_dash'] = b:forms_BDHeavyVerticalAndRight

let s:boxVerticalAndRight['double'] = b:forms_BDDoubleVerticalAndRight

let s:boxVerticalAndRight['block'] = b:forms_FullB
let s:boxVerticalAndRight['semi_block'] = b:forms_FullB
let s:boxVerticalAndRight['triangle_block'] = b:forms_FullB

function! forms#LookupVerticalAndRight(name)
  if has_key(s:boxVerticalAndRight, a:name)
    return s:boxVerticalAndRight[a:name]
  else
    if &encoding == 'utf-8'
      return s:boxVerticalAndRight['light']
    else
      return s:forms_r
    endif
  endif
endfunction

"----------------------------------------------------------------
" Vertical and Horizontal characters: {{{2
"----------------------------------------------------------------
let s:boxVerticalAndHorizontal = {}
let s:boxVerticalAndHorizontal['default'] = b:forms_r
let s:boxVerticalAndHorizontal['light']   = b:forms_BDLightVerticalAndHorizontal 
let s:boxVerticalAndHorizontal['light_arc']   = b:forms_BDLightVerticalAndHorizontal 
let s:boxVerticalAndHorizontal['light_double_dash']   = b:forms_BDLightVerticalAndHorizontal 
let s:boxVerticalAndHorizontal['light_double_dash_arc']   = b:forms_BDLightVerticalAndHorizontal 
let s:boxVerticalAndHorizontal['light_triple_dash'] =  b:forms_BDLightVerticalAndHorizontal
let s:boxVerticalAndHorizontal['light_triple_dash_arc'] =  b:forms_BDLightVerticalAndHorizontal
let s:boxVerticalAndHorizontal['light_quadruple_dash'] =  b:forms_BDLightVerticalAndHorizontal
let s:boxVerticalAndHorizontal['light_quadruple_dash_arc'] =  b:forms_BDLightVerticalAndHorizontal


let s:boxVerticalAndHorizontal['heavy']   = b:forms_BDHeavyVerticalAndHorizontal
let s:boxVerticalAndHorizontal['heavy_double_dash'] = b:forms_BDHeavyVerticalAndHorizontal
let s:boxVerticalAndHorizontal['heavy_triple_dash'] = b:forms_BDHeavyVerticalAndHorizontal
let s:boxVerticalAndHorizontal['heavy_quadruple_dash'] = b:forms_BDHeavyVerticalAndHorizontal

let s:boxVerticalAndHorizontal['double'] = b:forms_BDDoubleVerticalAndHorizontal

let s:boxVerticalAndHorizontal['block'] = b:forms_FullB
let s:boxVerticalAndHorizontal['semi_block'] = b:forms_FullB
let s:boxVerticalAndHorizontal['triangle_block'] = b:forms_FullB

function! forms#LookupVerticalAndHorizontal(name)
  if has_key(s:boxVerticalAndHorizontal, a:name)
    return s:boxVerticalAndHorizontal[a:name]
  else
    if &encoding == 'utf-8'
      return s:boxVerticalAndHorizontal['light']
    else
      return s:forms_r
    endif
  endif
endfunction



" format for box drawing char set: dr  uh  dl  rv  ul  lh  ur  lv
" ------------------------------------------------------------ 
" forms#DrawBox: {{{2
"  Draw a box with upper-left corner at allocation
"    line/column, width and height 
"  parameters:
"    name          : name of box drawing character set
"    allocation    : line and column 
"    width         : width of box
"    height        : height of box
" ------------------------------------------------------------ 
function! forms#DrawBox(name, line, column, width, height)
" call forms#log("forms#DrawBox: TOP")
  let l = a:line
  let c = a:column
  let w = a:width
  let h = a:height
  let boxcharset = forms#LookupBoxDrawingCharacterSet(a:name)
  let dr = boxcharset[0]
  let uh = boxcharset[1]
  let dl = boxcharset[2]
  let rv = boxcharset[3]
  let ul = boxcharset[4]
  let lh = boxcharset[5]
  let ur = boxcharset[6]
  let lv = boxcharset[7]

  " draw upper left corner
  call forms#SetCharAt(dr, l, c)
 
  " draw top 
  let cnt = 1
  while cnt < w - 1
    call forms#SetCharAt(uh, l, c+cnt)

    let cnt += 1
  endwhile

  " draw upper right corner
  call forms#SetCharAt(dl, l, c+w-1)

  " draw left side
  " draw right side
  let cnt = 1
  while cnt < h - 1
    call forms#SetCharAt(lv, l+cnt, c)
    call forms#SetCharAt(rv, l+cnt, c+w-1)

    let cnt += 1
  endwhile

  " draw lower left corner
  call forms#SetCharAt(ur, l+h-1, c)

  " draw bottom 
  let cnt = 1
  while cnt < w - 1
    call forms#SetCharAt(lh, l+h-1, c+cnt)

    let cnt += 1
  endwhile

  " draw lower right corner
  call forms#SetCharAt(ul, l+h-1, c+w-1)
endfunction

" ------------------------------------------------------------ 
" forms#DrawHBoxes: {{{2
"  Draw a box of boxes with upper-left corner at allocation
"    line/column, height with width size
"  parameters:
"    name          : name of box drawing character set
"    allocation    : line and column and height
"    children_request_size   : list of width sizes
" ------------------------------------------------------------ 
function! forms#DrawHBoxes(name, allocation, children_request_size)
  let a = a:allocation
  let l = a.line
  let c = a.column
  " let w = a.width
  let h = a.height
  let sizes = a:children_request_size

  let boxcharset = forms#LookupBoxDrawingCharacterSet(a:name)
  let dr = boxcharset[0]
  let uh = boxcharset[1]
  let dl = boxcharset[2]
  let rv = boxcharset[3]
  let ul = boxcharset[4]
  let lh = boxcharset[5]
  let ur = boxcharset[6]
  let lv = boxcharset[7]

  let hd = forms#LookupDownAndHorizontal(a:name)
  let hu = forms#LookupUpAndHorizontal(a:name)

  let x = 0
  let nos_children = len(sizes)
  let index = 0
  while index < nos_children
    let [childwidth, _] = sizes[index]
    let cx = c+x
    let cw = childwidth+2

    " draw upper left corner
    if index == 0
      call forms#SetCharAt(dr, l, cx)
    else
      call forms#SetCharAt(hd, l, cx)
    endif
   
    " draw top 
    let cnt = 1
    while cnt < cw - 1
      call forms#SetCharAt(uh, l, cx+cnt)

      let cnt += 1
    endwhile

    " draw upper right corner
    if index == nos_children - 1
      call forms#SetCharAt(dl, l, cx+cw-1)
    endif

    " draw left side
    " draw right side
    let cnt = 1
    while cnt < h - 1
      call forms#SetCharAt(lv, l+cnt, cx)
      if index == nos_children - 1
        call forms#SetCharAt(rv, l+cnt, cx+cw-1)
      endif

      let cnt += 1
    endwhile


    " draw lower left corner
    if index == 0
      call forms#SetCharAt(ur, l+h-1, cx)
    else
      call forms#SetCharAt(hu, l+h-1, cx)
    endif

    " draw bottom 
    let cnt = 1
    while cnt < cw - 1
      call forms#SetCharAt(lh, l+h-1, cx+cnt)

      let cnt += 1
    endwhile

    " draw lower right corner
    if index == nos_children - 1
      call forms#SetCharAt(ul, l+h-1, cx+cw-1)
    endif

    let x += childwidth+1
    let index += 1
  endwhile
endfunction

" ------------------------------------------------------------ 
" forms#DrawVBoxes: {{{2
"  Draw a box of boxes with upper-left corner at allocation
"    line/column, width with height size
"  parameters:
"    name          : name of box drawing character set
"    allocation    : line and column and width
"    children_request_size   : list of height sizes
" ------------------------------------------------------------ 
function! forms#DrawVBoxes(name, allocation, children_request_size)
" call forms#log("forms#DrawVBoxes: TOP")
  let a = a:allocation
  let l = a.line
  let c = a.column
  let w = a.width
  " let h = a.height
  let sizes = a:children_request_size

  let boxcharset = forms#LookupBoxDrawingCharacterSet(a:name)
  let dr = boxcharset[0]
  let uh = boxcharset[1]
  let dl = boxcharset[2]
  let rv = boxcharset[3]
  let ul = boxcharset[4]
  let lh = boxcharset[5]
  let ur = boxcharset[6]
  let lv = boxcharset[7]

  let vl = forms#LookupVerticalAndLeft(a:name)
  let vr = forms#LookupVerticalAndRight(a:name)

  let y = 0
  let nos_children = len(sizes)
  let index = 0
  while index < nos_children
    let [_, childheight] = sizes[index]
    let ly = l+y
    let ch = childheight+2

    " draw upper left corner
    if index == 0
      call forms#SetCharAt(dr, ly, c)
    else
      call forms#SetCharAt(vr, ly, c)
    endif
   
    " draw top 
    let cnt = 1
    while cnt < w - 1
      call forms#SetCharAt(uh, ly, c+cnt)

      let cnt += 1
    endwhile

    " draw upper right corner
    if index == 0
      call forms#SetCharAt(dl, ly, c+w-1)
    else
      call forms#SetCharAt(vl, ly, c+w-1)
    endif

    " draw left side
    " draw right side
    let cnt = 1
    while cnt < ch - 1
      call forms#SetCharAt(lv, ly+cnt, c)
      call forms#SetCharAt(rv, ly+cnt, c+w-1)

      let cnt += 1
    endwhile

    " draw lower left corner
    if index == nos_children -1
      call forms#SetCharAt(ur, ly+ch-1, c)
    endif

    " draw bottom 
    if index == nos_children -1
      let cnt = 1
      while cnt < w - 1
        call forms#SetCharAt(lh, ly+ch-1, c+cnt)

        let cnt += 1
      endwhile
    endif

    " draw lower right corner
    if index == nos_children -1
      call forms#SetCharAt(ul, ly+ch-1, c+w-1)
    endif

    let y += childheight+1
    let index += 1
  endwhile
endfunction

" ------------------------------------------------------------ 
" forms#DrawBoxes: {{{2
"  Draw a grid of boxes with upper-left corner at allocation
"    line/column with column widths and row heights
"  parameters:
"    name          : name of box drawing character set
"    allocation    : line and column
"    column_widths : list of column widths
"    row_heights   : list of row heights
" ------------------------------------------------------------ 
function! forms#DrawBoxes(name, allocation, column_widths, row_heights)
"silent call forms#log("forms#DrawBoxes: TOP")
  let a = a:allocation
  let l = a.line
  let c = a.column
  "let w = a.width
  "let h = a.height
  let col_ws = a:column_widths
  let row_hs = a:row_heights

  let boxcharset = forms#LookupBoxDrawingCharacterSet(a:name)
  let dr = boxcharset[0]
  let uh = boxcharset[1]
  let dl = boxcharset[2]
  let rv = boxcharset[3]
  let ul = boxcharset[4]
  let lh = boxcharset[5]
  let ur = boxcharset[6]
  let lv = boxcharset[7]

  let hd = forms#LookupDownAndHorizontal(a:name)
  let hu = forms#LookupUpAndHorizontal(a:name)
  let vl = forms#LookupVerticalAndLeft(a:name)
  let vr = forms#LookupVerticalAndRight(a:name)
  let vh = forms#LookupVerticalAndHorizontal(a:name)

  " outer loop: row 0 to nos_row-1
  " inner loop: col 0 to nos_col-1

  let nos_row = len(row_hs)
  let nos_col = len(col_ws)

  let y = l
  let rcnt = 0
  while rcnt < nos_row
    let h = row_hs[rcnt]

    let x = c
    let ccnt = 0
    while ccnt < nos_col
      let w = col_ws[ccnt]

      " draw upper left corner
      if rcnt == 0
        if ccnt == 0
          call forms#SetCharAt(dr, y, x)
        else
          call forms#SetCharAt(hd, y, x)
        endif
      else
        if ccnt == 0
          call forms#SetCharAt(vr, y, x)
        else
          call forms#SetCharAt(vh, y, x)
        endif
      endif

      " draw top 
      let cnt = 1
      while cnt < w+1
        call forms#SetCharAt(uh, y, x+cnt)

        let cnt += 1
      endwhile

      " draw upper right corner
      if ccnt == nos_col-1
        if rcnt == 0
          call forms#SetCharAt(dl, y, x+w+1)
        else
          call forms#SetCharAt(vl, y, x+w+1)
        endif
      endif

      " draw left side
      let cnt = 1
      while cnt < h+1
        call forms#SetCharAt(lv, y+cnt, x)

        let cnt += 1
      endwhile
      " call forms#SetCharAt(rv, ly+cnt, c+w-1)

      " draw right side
      if ccnt == nos_col-1
        let cnt = 1
        while cnt < h+1
          call forms#SetCharAt(lv, y+cnt, x+w+1)

          let cnt += 1
        endwhile
      endif

      " draw lower left corner
      if rcnt == nos_row-1
        if ccnt == 0
          call forms#SetCharAt(ur, y+h+1, x)
        else
          call forms#SetCharAt(hu, y+h+1, x)
        endif
      endif

      " draw bottom 
      if rcnt == nos_row-1
        let cnt = 1
        while cnt < w+1
          call forms#SetCharAt(uh, y+h+1, x+cnt)

          let cnt += 1
        endwhile
      endif

      " draw lower right corner
      if rcnt == nos_row-1 && ccnt == nos_col-1
        call forms#SetCharAt(ul, y+h+1, x+w+1)
      endif

      let x += w+1
      let ccnt += 1
    endwhile

    let y += h+1
    let rcnt += 1
  endwhile
endfunction

" ------------------------------------------------------------ 
" forms#DrawFrame: {{{2
"  Draw a frame with upper-left corner at allocation
"    line/column, width and height 
"  parameters:
"    corner        : which corner has the drop shadow
"                      'ul'
"                      'ur'
"                      'll'
"                      'lr'
"    allocation    : line and column 
"    width         : width of box
"    height        : height of box
" ------------------------------------------------------------ 
function! forms#DrawFrame(corner, line, column, width, height)
  let corner = a:corner
  let c = a:column
  let w = a:width
  let h = a:height
  let l = a:line
  let c = a:column
  let w = a:width
  let h = a:height

  let fb =  b:forms_FullB

  if corner == 'ul'
    " draw ll
    call forms#SetCharAt(b:forms_GSBlackUpperLeftTriangle, l+h-1, c)

    " draw left and ul
    let cnt = 1
    while cnt < h-1
      call forms#SetCharAt(fb, l+cnt, c)
  
      let cnt += 1
    endwhile

    " draw top
    call forms#SetHCharsAt(fb, w-1, l, c)

    " draw ur
    call forms#SetCharAt(b:forms_GSBlackUpperLeftTriangle, l, c+w-1)

  elseif corner == 'ur'
    " draw ul
    call forms#SetCharAt(b:forms_GSBlackUpperRightTriangle, l, c)

    " draw top and ur
    call forms#SetHCharsAt(fb, w-1, l, c+1)
    
    " draw right
    let cnt = 1
    while cnt < h-1
      call forms#SetCharAt(fb, l+cnt, c+w-1)
  
      let cnt += 1
    endwhile

    " draw lr
    call forms#SetCharAt(b:forms_GSBlackUpperRightTriangle, l+h-1, c+w-1)

  elseif corner == 'll'
    " draw ul
    call forms#SetCharAt(b:forms_GSBlackLowerLeftTriangle, l, c)
    
    " draw left
    let cnt = 1
    while cnt < h-1
      call forms#SetCharAt(fb, l+cnt, c)
  
      let cnt += 1
    endwhile
    
    " draw bottom and ll
    call forms#SetHCharsAt(fb, w-1, l+h-1, c)
    
    " draw lr
    call forms#SetCharAt(b:forms_GSBlackLowerLeftTriangle, l+h-1, c+w-1)

  elseif corner == 'lr'
    " draw ll
    call forms#SetCharAt(b:forms_GSBlackLowerRightTriangle, l+h-1, c)

    " draw bottom and lr
    call forms#SetHCharsAt(fb, w-1, l+h-1, c+1)

    " draw right
    let cnt = 1
    while cnt < h-1
      call forms#SetCharAt(fb, l+cnt, c+w-1)
  
      let cnt += 1
    endwhile

    " draw ur
    call forms#SetCharAt(b:forms_GSBlackLowerRightTriangle, l, c+w-1)
  else
    throw "DrawDropShadow: Bad corner name: " . string(corner)
  endif
endfunction

" ------------------------------------------------------------ 
" forms#DrawDropShadow: {{{2
"  Draw a drop shadow box with upper-left corner at allocation
"    line/column, width and height 
"  parameters:
"    corner        : which corner has the drop shadow
"                      'ul'
"                      'ur'
"                      'll'
"                      'lr'
"    allocation    : line and column 
"    width         : width of box
"    height        : height of box
" ------------------------------------------------------------ 
function! forms#DrawDropShadow(corner, line, column, width, height)
  let corner = a:corner
  let c = a:column
  let w = a:width
  let h = a:height
  let l = a:line
  let c = a:column
  let w = a:width
  let h = a:height

  let fb =  b:forms_FullB

  if corner == 'ul'
    " draw ll
    call forms#SetCharAt(b:forms_GSBlackUpperRightTriangle, l+h, c)

    " draw left and ul
    let cnt = 1
    while cnt < h
      call forms#SetCharAt(fb, l+cnt, c)
  
      let cnt += 1
    endwhile

    " draw top
    call forms#SetHCharsAt(fb, w, l, c)

    " draw ur
    call forms#SetCharAt(b:forms_GSBlackLowerLeftTriangle, l, c+w)

  elseif corner == 'ur'
    " draw ul
    call forms#SetCharAt(b:forms_GSBlackLowerRightTriangle, l, c)

    " draw top and ur
    call forms#SetHCharsAt(fb, w, l, c+1)
    
    " draw right
    let cnt = 1
    while cnt < h
      call forms#SetCharAt(fb, l+cnt, c+w)
  
      let cnt += 1
    endwhile

    " draw lr
    call forms#SetCharAt(b:forms_GSBlackUpperLeftTriangle, l+h, c+w)

  elseif corner == 'll'
    " draw ul
    call forms#SetCharAt(b:forms_GSBlackLowerRightTriangle, l, c)
    
    " draw left
    let cnt = 1
    while cnt < h
      call forms#SetCharAt(fb, l+cnt, c)
  
      let cnt += 1
    endwhile
    
    " draw bottom and ll
    call forms#SetHCharsAt(fb, w, l+h, c)
    
    " draw lr
    call forms#SetCharAt(b:forms_GSBlackUpperLeftTriangle, l+h, c+w)

  elseif corner == 'lr'
    " draw ll
    call forms#SetCharAt(b:forms_GSBlackUpperRightTriangle, l+h, c)

    " draw bottom and lr
    call forms#SetHCharsAt(fb, w, l+h, c+1)

    " draw right
    let cnt = 1
    while cnt < h
      call forms#SetCharAt(fb, l+cnt, c+w)
  
      let cnt += 1
    endwhile

    " draw ur
    call forms#SetCharAt(b:forms_GSBlackLowerLeftTriangle, l, c+w)
  else
    throw "DrawDropShadow: Bad corner name: " . string(corner)
  endif
endfunction


"---------------------------------------------------------------------------
" Character and String UTF-8 aware rendering: {{{1
"-----------------------------------------------------------------------

" ------------------------------------------------------------ 
" forms#SetCharAt: {{{2
"  This code places a character at a point on the screen.
"    What is VERY important about this code is that it
"    works when there are multi-byte characters around.
"  parameters:
"    chr    : character to add
"    line   : line the character should be added at
"    column : column the character should be added at
" ------------------------------------------------------------ 
function! forms#SetCharAt(chr, line, column)
  exe a:line
  if a:column <= 1
    exe "norm! 0r".a:chr
  else
    exe "norm! 0".(a:column-1)."lr".a:chr
  endif
endfunction

" ------------------------------------------------------------ 
" forms#SetHCharsAt: {{{2
"  This code places a character a number of times
"    on the screen starting at given line/column.
"    What is VERY important about this code is that it
"    works when there are multi-byte characters around.
"  parameters:
"    chr    : character to add
"    nos    : number of times the character should be added
"    line   : line the character should be added at
"    column : start column the character should be added at
" ------------------------------------------------------------ 
function! forms#SetHCharsAt(chr, nos, line, column)
  let chr = a:chr
  let slen = a:nos * strchars(chr)
  if slen == 1
    call forms#SetCharAt(chr, a:line, a:column)

  elseif slen > 1
    exe a:line

    let c = a:column

    if c <= 1
      exe "norm! 0r".chr
      let slen -= 1
      let c += 1
    endif

    exe "norm! 0".(c-1)."l".slen."r".chr.''

  endif
endfunction

" ------------------------------------------------------------ 
" forms#SetVCharsAt: {{{2
"  This code places a character a number of times
"    on the screen starting at given line/column.
"    What is VERY important about this code is that it
"    works when there are multi-byte characters around.
"  parameters:
"    chr    : character to add
"    nos    : number of times the character should be added
"    line   : start line the character should be added at
"    column : column the character should be added at
" ------------------------------------------------------------ 
function! forms#SetVCharsAt(chr, nos, line, column)
  let chr = a:chr
  let slen = a:nos * strchars(chr)
  if slen == 1
    call forms#SetCharAt(chr, a:line, a:column)

  elseif slen > 1
    let l = a:line
    let c = a:column

    if c <= 1
      let cnt = 0
      while cnt < slen
        exe l+cnt
        exe "norm! 0r".chr

        let cnt += 1
      endwhile
    else
      let cnt = 0
      while cnt < slen
        exe l+cnt
        exe "norm! 0".(c-1)."l1r".chr.''
        " execute "normal 05l1rX"

        let cnt += 1
      endwhile
    endif
  endif
endfunction

" ------------------------------------------------------------ 
" forms#SetStringAt: {{{2
"  This code places a string on the screen starting at 
"    given line/column.
"    What is VERY important about this code is that it
"    works when there are multi-byte characters around.
"  parameters:
"    str    : string to add
"    line   : line the character should be added at
"    column : start column the character should be added at
" ------------------------------------------------------------ 
function! forms#SetStringAt(str, line, column)
  let s = a:str
  let slen = strchars(s)
  if slen == 1
    call forms#SetCharAt(s[0], a:line, a:column)

  elseif slen > 1
    let slen2 = strlen(s)
    if slen == slen2
      " there are no multi-byte characters
      let cnt = 0
      while cnt < slen
        call forms#SetCharAt(s[cnt], a:line, a:column+cnt)

        let cnt += 1
      endwhile
    else
      " multibyte characters, must do some ugly work
      let cnt = 0
      while cnt < slen-1
        let start = byteidx(s, cnt)
        let end = byteidx(s, cnt+1)
        let ch = strpart(s, start, (end-start))
        call forms#SetCharAt(ch, a:line, a:column+cnt)

        let cnt += 1
      endwhile
      let ch = strpart(s, end)
      call forms#SetCharAt(ch, a:line, a:column+cnt)
    endif

if 0
    exe a:line

    let c = a:column

    if c <= 1
      exe "norm! 0r".s[0]
      let s = s[1:]
      let slen -= 1
      let c += 1
    endif

    " TODO why does this not work all the time
    exe "norm! 0".(c-1)."l".slen."s".s.''
endif

  endif
endfunction



" strpart but for characters not bytes
" arguments:
"   str
"   start
"   optional len
" ------------------------------------------------------------ 
" forms#SubString: {{{2
"  This is basically strpart but for characters, not bytes.
"  parameters:
"    str    : source string
"    start  : where to start the substring
"    len    : optional length of substring
" ------------------------------------------------------------ 
function! forms#SubString(str, start, ...)
  let bstart = byteidx(a:str, a:start)
  if a:0 == 0
    let r = strpart(a:str, bstart) 
    return r
  else
    let r = strpart(a:str, bstart, byteidx(a:str, a:1))
    return r
  endif
endfunction

" ==============
"  Restore: {{{1
" ==============
let &cpo= s:keepcpo
unlet s:keepcpo

if 0
" call forms#log("BEFORE label")
let label = forms#newLabel({'text': 'mylabel'})
" call forms#log("BEFORE debug")
let debug = forms#newDebug({'body': label, 'msg': 'mylabel'})
" call forms#log("AFTER debug")
let rs = debug.requestedSize()
" call forms#log("rs=".string(rs))
endif

" ================
"  Modelines: {{{1
" ================
" vim: ts=4 fdm=marker
