
" ------------------------------------------------------------ 
" forms#dialog#input#Make:
"  A form that display information, provides line editor
"      and submit/cancel buttons.
"    The form has: 
"      Text 
"      VariableLengthField 
"      Submit and Cancel buttons
"    Example:
"       ┌──────────────────────────────────────────────────────────────┐
"       │  Enter a command or word to find help on:                    │
"       │                                                              │
"       │  Prepend i_ for Input mode commands (e.g.: i_CTRL-X)         │
"       │  Prepend c_ for command-line editing commands (e.g.: c_<Del>)│
"       │  Prepend ' for an option name (e.g.: 'shiftwidth')           │
"       │┌────────────────────────────────────────────────────────────┐│
"       ││                                                            ││
"       │└────────────────────────────────────────────────────────────┘│
"       │──────────────────────────────────────────────────────────────│
"       │                                                     Ok Cancel│
"       └──────────────────────────────────────────────────────────────┘

"  parameters:
"     texlines    : List of static text to be displayed
"                   or string with text separated by '\n'
"     initialtext : optional initial text value 
" ------------------------------------------------------------ 
" forms#dialog#input#Make: {{{1
function!  forms#dialog#input#Make(textlines, ...)
" call forms#log("forms#dialog#input#Make")
  if type(a:textlines) == g:self#LIST_TYPE
    let textlines = a:textlines
  elseif type(a:textlines) == g:self#STRING_TYPE
    let textlines = split(a:textlines, '\n')
  else
    throw "forms#dialog#input#Make: textlines parameter must be list of text: " . string(a:textlines)
  endif
  let outputtag = 'output'
  let text = forms#newText({'textlines': textlines })
  let size = 20
  for line in textlines
    let len = len(line)
    if len > size
      let size = len
    endif
  endfor
  let vfield = forms#newVariableLengthField({'size': size,
                                         \ 'tag': outputtag
                                         \ })
  function! vfield.purpose() dict
    return [
        \ "Enter the requested information."
        \ ]
  endfunction
  if a:0 > 0 && a:1 != ''
    call vfield.setText(a:1)
  endif

  let box = forms#newBox({ 'body': vfield} )
  let char = (&encoding == 'utf-8') 
                      \ ?  b:forms_BDLightHorizontal 
                      \ : b:forms_horz
  let hline = forms#newHLine({'char': char})

  let oklabel = forms#newLabel({'text': "Ok"})
  let ok = forms#newButton({
                          \ 'tag': 'submit', 
                          \ 'body': oklabel, 
                          \ 'action': g:forms#submitAction})
  function! ok.purpose() dict
    return [
        \ "Accept the entered information."
        \ ]
  endfunction
  let hspace = forms#newHSpace({'size': 1})
  let cancellabel = forms#newLabel({'text': "Cancel"})
  let cancel = forms#newButton({
                          \ 'tag': 'cancel', 
                          \ 'body': cancellabel, 
                          \ 'action': g:forms#cancelAction})
  function! cancel.purpose() dict
    return [
        \ "Cancel the operation, nothing is returned."
        \ ]
  endfunction
  let buttons = forms#newHPoly({ 'children': [ok, hspace, cancel]})

  let vpoly = forms#newVPoly({ 'children': [text, box, hline, buttons], 'alignment': 'R' })

  let b = forms#newBox({ 'body': vpoly })
  let bg = forms#newBackground({ 'body': b} )
  let form = forms#newForm({'body': bg })
  function! form.purpose() dict
    return [
        \ "Request input from the user."
        \ ]
  endfunction
  let results = form.run()
" call forms#log("forms#dialog#input#Make: results=".string(results))
  if exists("results.output")
    return results.output
  else
    return ''
  endif
endfunction

" forms#dialog#input#MakeTest: {{{1
function! forms#dialog#input#MakeTest()
  call forms#AppendInput({'type': 'Sleep', 'time': 5})
  call forms#AppendInput({'type': 'Exit'})
  let textlines = "User should add requested input.\n\nCan be on multiple lines." 
  call forms#dialog#input#Make(textlines, 'some initial text')
endfunction

"  Modelines: {{{1
" ================
" vim: ts=4 fdm=marker
