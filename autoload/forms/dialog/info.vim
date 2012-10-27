
" ------------------------------------------------------------ 
" forms#dialog#info#Make:
"  A form that display information.
"    The form has: 
"      Text 
"      Close Button
"    Example:
"       ┌────────────────────────────┐
"       │Changing Fonts not supported│
"       │────────────────────────────│
"       │                       Close│
"       └────────────────────────────┘
"
"  parameters:
"     texlines : List of static text to be displayed
"                 or String with text separated by '\n'
" ------------------------------------------------------------ 
" forms#dialog#info#Make: {{{1
function! forms#dialog#info#Make(textlines)
" call forms#log("forms#dialog#info#Make")
  if type(a:textlines) == g:self#LIST_TYPE
    let textlines = a:textlines
  elseif type(a:textlines) == g:self#STRING_TYPE
    let textlines = split(a:textlines, '\n')
  else
    throw "forms#dialog#info#Make: textlines parameter must be List of text: " . string(a:textlines)
  endif

  let text = forms#newText({'textlines': textlines })
  let size = 20
  for line in textlines
    let len = len(line)
    if len > size
      let size = len
    endif
  endfor

  let char = (&encoding == 'utf-8') 
                      \ ?  g:forms_BDLightHorizontal 
                      \ : g:forms_horz
  let hline = forms#newHLine({'char': char})


  let label = forms#newLabel({'text': "Close"})
  let closebutton = forms#newButton({
                          \ 'tag': 'exit', 
                          \ 'body': label, 
                          \ 'action': g:forms#exitAction})
  
  function! closebutton.purpose() dict
    return [
        \ "Close the information dialog."
        \ ]
  endfunction
  let vpoly = forms#newVPoly({ 'children': [text, hline, closebutton], 'alignment': 'R' })
  let b = forms#newBox({ 'body': vpoly })
  let bg = forms#newBackground({ 'body': b} )
  let form = forms#newForm({'body': bg })
  function! form.purpose() dict
    return [
        \ "Provide information to the user."
        \ ]
  endfunction
  call form.run()
" call forms#log("forms#dialog#info#Make: bottom")
endfunction

" forms#dialog#info#MakeTest: {{{1
function! forms#dialog#info#MakeTest()
  call forms#AppendInput({'type': 'Sleep', 'time': 5})
  call forms#AppendInput({'type': 'Exit'})
  let textlines = "Display some information.\nText can be on multiple lines." 
  call forms#dialog#info#Make(textlines)
endfunction

"  Modelines: {{{1
" ================
" vim: ts=4 fdm=marker
