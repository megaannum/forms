
" ------------------------------------------------------------ 
" forms#dialog#confirm#Make:
"  A form that display information and provides choice 
"      buttons.
"    The form has: 
"      Text 
"      Buttons for all choices
"    Example:
"       ┌──────────────────────────────────┐ 
"       │Select format for writing the file│ 
"       │──────────────────────────────────│ 
"       │               Unix Dos Mac Cancel│ 
"       └──────────────────────────────────┘ 
"       
"  parameters:
"     texlines : List of static text to be displayed
"                 or string with lines separated by '\n'
"     choices  : List of text for buttons 
"                 or string with text separated by '\n'
"     def      : default value (1, 2, ...)
"     type     : type of Dialog
" ------------------------------------------------------------ 
" forms#dialog#confirm#Make: {{{1
function!  forms#dialog#confirm#Make(textlines, choices, def)
" call forms#log("forms#dialog#confirm#Make")
  if type(a:textlines) == g:self#LIST_TYPE
    let textlines = a:textlines
  elseif type(a:textlines) == g:self#STRING_TYPE
    let textlines = split(a:textlines, '\n')
  else
    throw "forms#dialog#confirm#Make: textlines parameter must be List of text: " . string(a:textlines)
  endif
  if type(a:choices) == g:self#LIST_TYPE
    let choices = a:choices
  elseif type(a:choices) == g:self#STRING_TYPE
    let choices = split(a:choices, '\n')
  else
    throw "forms#dialog#confirm#Make: choices parameter must be List of text: " . string(a:choices)
  endif
  if type(a:def) == g:self#NUMBER_TYPE
    let def = a:def
  else
    throw "forms#dialog#confirm#Make: def (default) parameter must be number of text: " . string(a:def)
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

  let children = []
  let cnt = 1
  for choice in choices
    let label = forms#newLabel({'text': choice})
    let button = forms#newButton({
                          \ 'tag': choice, 
                          \ 'body': label, 
                          \ 'selected': (cnt == def), 
                          \ 'action': g:forms#submitAction})
    function! button.purpose() dict
      return [
          \ "Select the option labeled: ".self.getTag()."."
          \ ]
    endfunction
    call add(children, button)
    let hspace = forms#newHSpace({'size': 1})
    call add(children, hspace)

    let cnt += 1
  endfor

  " This kluge code advances the hotspot to the default button
  " after the form is displayed by adding NextFocus events to the
  " input queue.
  let cnt = 1
  while cnt < def
    call forms#AppendInput({ 'type': 'NextFocus' })
    let cnt += 1
  endwhile

  let label = forms#newLabel({'text': "Cancel"})
  let cancel = forms#newButton({
                          \ 'tag': 'cancel', 
                          \ 'body': label, 
                          \ 'action': g:forms#cancelAction})
  function! cancel.purpose() dict
    return [
        \ "Make no selection, cancel operation."
        \ ]
  endfunction
  call add(children, cancel)
  
  let buttons = forms#newHPoly({ 'children': children})

  let vpoly = forms#newVPoly({ 'children': [text, hline, buttons], 'alignment': 'R' })
  let b = forms#newBox({ 'body': vpoly })
  let bg = forms#newBackground({ 'body': b} )
  let form = forms#newForm({'body': bg })
  function! form.purpose() dict
    return [
        \ "Pick on of the option buttons or cancel."
        \ ]
  endfunction
  let results = form.run()
" call forms#log("forms#dialog#confirm#Make: results=".string(results))
  if type(results) == g:self#NUMBER_TYPE && results == 0
" call forms#log("forms#dialog#confirm#Make: cancel")
    return 0
  else
    let cnt = 1
    for choice in choices
"call forms#log("forms#dialog#confirm#Make: choice=".choice)
      if has_key(results, choice) 
        if results[choice] 
"call forms#log("forms#dialog#confirm#Make: match")
          return cnt
        endif
      endif

      let cnt += 1
    endfor
  endif
" call forms#log("forms#dialog#confirm#Make: bottom")
  return 0
endfunction

" forms#dialog#confirm#MakeTest: {{{1
function! forms#dialog#confirm#MakeTest()
  call forms#AppendInput({'type': 'Sleep', 'time': 5})
  call forms#AppendInput({'type': 'Exit'})
  let textlines = "User should pick one.\nCan be on multiple lines." 
  let choices = "Apple\nOrange\nPear\nPeach" 
  let def = 2
  call forms#dialog#confirm#Make(textlines, choices, def)
endfunction

"  Modelines: {{{1
" ================
" vim: ts=4 fdm=marker
