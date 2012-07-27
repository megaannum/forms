
function! forms#example#labels#Make()

  let attrs11 = { 'text': 'My Label11'}
  let label11 = forms#newLabel(attrs11)
  let box11 = forms#newBox({ 'body': label11} )
  let attrs12 = { 'text': 'My Label12'}
  let label12 = forms#newLabel(attrs12)
  let box12 = forms#newBox({ 'body': label12} )
  let vpoly1 = forms#newVPoly({ 'children': [box11, box12] })

  let attrs21 = { 'text': 'My Label21'}
  let label21 = forms#newLabel(attrs21)
  let box21 = forms#newBox({ 'body': label21} )
  let attrs22 = { 'text': 'My Label22'}
  let label22 = forms#newLabel(attrs22)
  let box22 = forms#newBox({ 'body': label22} )
  let vpoly2 = forms#newVPoly({ 'children': [box21, box22] })

  let hpoly = forms#newHPoly({ 'children': [vpoly1, vpoly2] })

  let boxOuter = forms#newBox({ 'body': hpoly, 'mode': 'double'} )

  let bg = forms#newBackground({ 'body': boxOuter} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction
