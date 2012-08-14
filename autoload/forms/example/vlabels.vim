
function! forms#example#vlabels#Make()
  let attrs11 = { 'text': 'My Label11'}
  let vl11 = forms#newVLabel(attrs11)
  let box11 = forms#newBox({ 'body': vl11} )
  let attrs12 = { 'text': 'My Label12'}
  let vl12 = forms#newVLabel(attrs12)
  let box12 = forms#newBox({ 'body': vl12} )
  let vpoly1 = forms#newVPoly({ 'children': [box11, box12] })

  let attrs21 = { 'text': 'My Label21'}
  let vl21 = forms#newVLabel(attrs21)
  let box21 = forms#newBox({ 'body': vl21} )
  let attrs22 = { 'text': 'My Label22'}
  let vl22 = forms#newVLabel(attrs22)
  let box22 = forms#newBox({ 'body': vl22} )
  let vpoly2 = forms#newVPoly({ 'children': [box21, box22] })

  let hpoly = forms#newHPoly({ 'children': [vpoly1, vpoly2] })

  let boxOuter = forms#newBox({ 'body': hpoly, 'mode': 'double'} )

  let bg = forms#newBackground({ 'body': boxOuter} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction

function! forms#example#vlabels#MakeTest()
  call forms#AppendInput({'type': 'Sleep', 'time': 5})
  call forms#AppendInput({'type': 'Exit'})
  call forms#example#vlabels#Make()
endfunction
