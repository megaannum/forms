
function! forms#example#editors2#Make()
  let attrs1 = {'size': 10, 'init_text': 'one' }
  let editor1 = forms#newVariableLengthField(attrs1)
  let b1 = forms#newBox({ 'body': editor1 })

  let attrs2 = {'size': 20}
  let editor2 = forms#newVariableLengthField(attrs2)
  let b2 = forms#newBox({ 'body': editor2 })

  let vpoly = forms#newVPoly({ 'children': [b1, b2], 'alignment': 'L' })
  let bg = forms#newBackground({ 'body': vpoly} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction

function! forms#example#editors2#MakeTest()
  call forms#AppendInput({'type': 'Sleep', 'time': 5})
  call forms#AppendInput({'type': 'Exit'})
  call forms#example#editors2#Make()
endfunction
