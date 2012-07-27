
function! forms#example#editors#Make()
  let attrs11 = {'size': 10, 'init_text': 'hi11' }
  let edi11 = forms#newFixedLengthField(attrs11)
  let box11 = forms#newBox({ 'body': edi11} )
  let attrs12 = {'size': 10, 'init_text': 'hi12' }
  let edi12 = forms#newFixedLengthField(attrs12)
  let box12 = forms#newBox({ 'body': edi12} )
  let vpoly1 = forms#newVPoly({ 'children': [box11, box12] })

  let attrs21 = {'size': 10, 'init_text': 'hi21' }
  let edi21 = forms#newFixedLengthField(attrs21)
  let box21 = forms#newBox({ 'body': edi21} )
  let attrs22 = {'size': 10, 'init_text': 'hi22' }
  let edi22 = forms#newFixedLengthField(attrs22)
  let box22 = forms#newBox({ 'body': edi22} )
  let vpoly2 = forms#newVPoly({ 'children': [box21, box22] })

  let hpoly = forms#newHPoly({ 'children': [vpoly1, vpoly2] })

  let boxOuter = forms#newBox({ 'body': hpoly, 'mode': 'double'} )

  let bg = forms#newBackground({ 'body': boxOuter} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction

