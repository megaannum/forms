
function! forms#example#radiobuttons#Make()
  let group = forms#newButtonGroup({ 'member_kind': 'forms#RadioButton'})

  let rb11 = forms#newRadioButton({'tag': 'one', 'group': group})
  let b11 = forms#newBorder({ 'body': rb11 })
  let box11 = forms#newBox({ 'body': b11} )
  let rb12 = forms#newRadioButton({'tag': 'one', 'group': group})
  let b12 = forms#newBorder({ 'body': rb12 })
  let box12 = forms#newBox({ 'body': b12} )
  let vpoly1 = forms#newVPoly({ 'children': [box11, box12] })

  let rb21 = forms#newRadioButton({'tag': 'one', 'group': group})
  let b21 = forms#newBorder({ 'body': rb21 })
  let box21 = forms#newBox({ 'body': b21} )
  let rb22 = forms#newRadioButton({'tag': 'one', 'group': group})
  let b22 = forms#newBorder({ 'body': rb22 })
  let box22 = forms#newBox({ 'body': b22} )
  let vpoly2 = forms#newVPoly({ 'children': [box21, box22] })

  let hpoly = forms#newHPoly({ 'children': [vpoly1, vpoly2] })

  let boxOuter = forms#newBox({ 'body': hpoly, 'mode': 'double'} )

  let bg = forms#newBackground({ 'body': boxOuter} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction

function! forms#example#radiobuttons#MakeTest()
  call forms#AppendInput({'type': 'Sleep', 'time': 5})
  call forms#AppendInput({'type': 'Exit'})
  call forms#example#radiobuttons#Make()
endfunction
