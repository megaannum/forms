" ============================================================================
" term.vim
"
" File:          term.vim
" Summary:       Term (part of Forms Library)
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" ============================================================================

" http://vim.wikia.com/wiki/256_colors_setup_for_console_Vim

" ------------------------------------------------------------ 
" Define konsole and eterm variables: {{{2
" Refs:
" ------------------------------------------------------------ 
if ! exists("g:FORMS_COLOR_TERM_KONSOLE")
  let g:FORMS_COLOR_TERM_KONSOLE = 0
endif
if ! exists("g:FORMS_COLOR_TERM_ETERM")
  let g:FORMS_COLOR_TERM_ETERM = 0
endif

" ------------------------------------------------------------ 
" Set current session Term functions: {{{2
" Refs:
" ------------------------------------------------------------ 
if has("gui_running")
  " Want to support Forms in GVim, so must still set term functions
  " Use Xterm
  let g:FORMS_COLOR_TERM_TYPE = 'gui'
  let g:FORMS_COLOR_TERM_CONVERT_RGB_2_INT = function("forms#color#xterm#ConvertRGB_2_Int")
  let g:FORMS_COLOR_TERM_CONVERT_INT_2_RGB = function("forms#color#xterm#ConvertInt_2_RGB")


elseif &t_Co == 256
  if &term =~? '^konsole' || g:FORMS_COLOR_TERM_KONSOLE
    let g:FORMS_COLOR_TERM_TYPE = 'konsole'
    let g:FORMS_COLOR_TERM_CONVERT_RGB_2_INT = function("forms#color#konsole#ConvertRGB_2_Int")
    let g:FORMS_COLOR_TERM_CONVERT_INT_2_RGB = function("forms#color#konsole#ConvertInt256_2_RGB")

  elseif &term =~? '^eterm' || g:FORMS_COLOR_TERM_ETERM
    let g:FORMS_COLOR_TERM_TYPE = 'eterm'
    let g:FORMS_COLOR_TERM_CONVERT_RGB_2_INT = function("forms#color#eterm#ConvertRGB_2_Int")
    let g:FORMS_COLOR_TERM_CONVERT_INT_2_RGB = function("forms#color#eterm#ConvertInt256_2_RGB")

  elseif &term =~? '^rxvt'
    " Use Xterm functions for rxvt-unicode-256color
    " rxvt-unicode-256color 
    let g:FORMS_COLOR_TERM_TYPE = 'urxvt256'
    let g:FORMS_COLOR_TERM_CONVERT_RGB_2_INT = function("forms#color#xterm#ConvertRGB_2_Int")
    let g:FORMS_COLOR_TERM_CONVERT_INT_2_RGB = function("forms#color#xterm#ConvertInt_2_RGB")
  else
    " xterm
    let g:FORMS_COLOR_TERM_TYPE = 'xterm'
    let g:FORMS_COLOR_TERM_CONVERT_RGB_2_INT = function("forms#color#xterm#ConvertRGB_2_Int")
    let g:FORMS_COLOR_TERM_CONVERT_INT_2_RGB = function("forms#color#xterm#ConvertInt_2_RGB")
  endif

elseif &t_Co == 88
  " rxvt-unicode
  let g:FORMS_COLOR_TERM_TYPE = 'urxvt'
  let g:FORMS_COLOR_TERM_CONVERT_RGB_2_INT = function("forms#color#urxvt#ConvertRGB_2_Int")
  let g:FORMS_COLOR_TERM_CONVERT_INT_2_RGB = function("forms#color#urxvt#ConvertInt_2_RGB")
endif

function forms#color#term#ConvertRGBTxt_2_Int(rgbtxt)
  let [r,g,b] = forms#color#util#ParseRGB(a:rgbtxt)
  return g:FORMS_COLOR_TERM_CONVERT_RGB_2_INT(r, g, b)
endfunction

function forms#color#term#ConvertRGB_2_Int(rn, gn, bn)
  return g:FORMS_COLOR_TERM_CONVERT_RGB_2_INT(a:rn, a:gn, a:bn)
endfunction

function forms#color#term#ConvertInt_2_RGB(n)
  return g:FORMS_COLOR_TERM_CONVERT_INT_2_RGB(a:n)
endfunction

" ================
"  Modelines: {{{1
" ================
" vim: ts=4 fdm=marker
