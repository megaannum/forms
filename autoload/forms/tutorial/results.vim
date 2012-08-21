"---------------------------------------------------------------------------
" forms#tutorial#results#Make() 
"   Create a simple Label in a Form.
"
"  parameters: None
"---------------------------------------------------------------------------
function! forms#tutorial#results#Make()
  let attrs = {'textlines': "Enter Text\nSelect Buttons\nClick Cancel or Submit"}
  let text = forms#newText(attrs)

  let editor = forms#newFixedLengthField({'tag': 'editor', 'size': 15})
  let editorbox = forms#newBox({'body': editor, 'mode': 'light_arc'})


  let group = forms#newButtonGroup({'member_kind': 'forms#ToggleButton'})
  let l1 = forms#newLabel({'text': "ONE"})
  let tb1 = forms#newToggleButton({'tag': 'tbone', 
                                  \ 'body': l1, 
                                  \ 'group': group})
  let b1 = forms#newBox({ 'body': tb1} )

  let l2 = forms#newLabel({'text': "TWO"})
  let tb2 = forms#newToggleButton({'tag': 'tbtwo', 
                                  \ 'body': l2, 
                                  \ 'selected': 1, 
                                  \ 'group': group})
  let b2 = forms#newBox({ 'body': tb2} )
                  
  let l3 = forms#newLabel({'text': "THREE"})
  let tb3 = forms#newToggleButton({'tag': 'tbthree', 
                                  \ 'body': l3, 
                                  \ 'group': group})
  let b3 = forms#newBox({ 'body': tb3} )
  let hpolytb = forms#newHPoly({ 
                             \ 'children': [b1, b2, b3], 
                             \ 'alignment': 'C' })


  let group = forms#newButtonGroup({ 'member_kind': 'forms#RadioButton'})
  let rb1 = forms#newRadioButton({'tag': 'rbone', 
                                  \ 'group': group})
  let b1 = forms#newBox({ 'body': rb1 })
  let rb2 = forms#newRadioButton({'tag': 'rbtwo', 
                                  \ 'group': group})
  let b2 = forms#newBox({ 'body': rb2 })
  let rb3 = forms#newRadioButton({'tag': 'rbthree', 
                                  \ 'selected': 1, 
                                  \ 'group': group})
  let b3 = forms#newBox({ 'body': rb3 })
  let hpolyrb = forms#newHPoly({ 'children': [b1, b2, b3] })

  let attrs = { 'text': 'Cancel'}
  let cancellabel = forms#newLabel(attrs)
  let cancelbutton = forms#newButton({
                                      \ 'tag': 'cancel',
                                      \ 'body': cancellabel,
                                      \ 'action': g:forms#cancelAction})
  let attrs = { 'text': 'Submit'}
  let submitlabel = forms#newLabel(attrs)
  let submitbutton = forms#newButton({
                                      \ 'tag': 'submit',
                                      \ 'body': submitlabel,
                                      \ 'action': g:forms#submitAction})


  let hspace = forms#newHSpace({'size': 2})
  let hpolybuttons = forms#newHPoly({'children': 
                            \ [cancelbutton, hspace, submitbutton]})

  let vspace = forms#newHSpace({'size': 1})
  let vpoly = forms#newVPoly({'children': [
                            \ text, 
                            \ vspace, 
                            \ editorbox, 
                            \ vspace, 
                            \ hpolytb,
                            \ vspace, 
                            \ hpolyrb,
                            \ vspace, 
                            \ hpolybuttons
                            \ ],
                            \ 'alignments': [[8, 'R']]
                            \ })

  let border = forms#newBorder({ 'body': vpoly, 'size': 2 })
  let bg = forms#newBackground({ 'body': border })
  let form = forms#newForm({'body': bg })
  function! form.purpose() dict
    return "This is Help associated with the More Code Structure Tutorial Form."
  endfunction

  let results = form.run()
  if type(results) == g:self#DICTIONARY_TYPE
    echo "" . string(results)
  endif

endfunction

" call forms#tutorial#results#Make()
