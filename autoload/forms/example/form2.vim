
function! forms#example#form2#Make()
  let attrs = {'size': 15 }

  let attrs['init_text'] = "oneone"
  let txtEditor11 = forms#newFixedLengthField(attrs)
  let b11 = forms#newBorder({ 'body': txtEditor11 })

  let attrs['init_text'] = "onetwo"
  let txtEditor12 = forms#newFixedLengthField(attrs)
  let b12 = forms#newBorder({ 'body': txtEditor12 })

  let vpoly1 = forms#newVPoly({ 'children': [b11, b12] })

  let viewer1 = forms#newViewer({'body': vpoly1 })

  let label = forms#newLabel({'text': "Submit"})
  let button = forms#newButton({ 
                              \ 'tag': 'submit',  
                              \ 'body': label,  
                              \ 'action': g:forms#submitAction})
  let b = forms#newBorder({ 'body': button })

  let attrs['init_text'] = "twoone"
  let txtEditor21 = forms#newFixedLengthField(attrs)
  let b21 = forms#newBorder({ 'body': txtEditor21 })

  let attrs['init_text'] = "twotwo"
  let txtEditor22 = forms#newFixedLengthField(attrs)
  let b22 = forms#newBorder({ 'body': txtEditor22 })
  let vpoly2 = forms#newVPoly({ 'children': [b21, b22] })

  let viewer2 = forms#newViewer({'body': vpoly2 })

  let hpoly = forms#newHPoly({ 'children': [viewer1, b, viewer2], 'alignment': 'T' })
  let bg = forms#newBackground({ 'body': hpoly} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction

function! forms#example#form2#MakeTest()
  call forms#AppendInput({'type': 'Sleep', 'time': 5})
  call forms#AppendInput({'type': 'Exit'})
  call forms#example#form2#Make()
endfunction
