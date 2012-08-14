
function! forms#example#boxchars#Make()
  let attrs11 = { 'text': 'Light Box'}
  let label11 = forms#newLabel(attrs11)
  let box11 = forms#newBox({ 'body': label11, 'mode': 'light'} )

  let attrs12 = { 'text': 'Heavy Box'}
  let label12 = forms#newLabel(attrs12)
  let box12 = forms#newBox({ 'body': label12, 'mode': 'heavy'} )

  let attrs13 = { 'text': 'Light Arc Box'}
  let label13 = forms#newLabel(attrs13)
  let box13 = forms#newBox({ 'body': label13, 'mode': 'light_arc'} )

  let attrs14 = { 'text': 'Light Double Dash Arc'}
  let label14 = forms#newLabel(attrs14)
  let box14 = forms#newBox({ 'body': label14, 'mode': 'light_double_dash_arc'} )

  let attrs15 = { 'text': 'Light Trible Dash Arc'}
  let label15 = forms#newLabel(attrs15)
  let box15 = forms#newBox({ 'body': label15, 'mode': 'light_triple_dash_arc'} )

  let attrs16 = { 'text': 'Light Quadruple Dash Arc'}
  let label16 = forms#newLabel(attrs16)
  let box16 = forms#newBox({ 'body': label16, 'mode': 'light_quadruple_dash_arc'} )

  let attrs17 = { 'text': 'Semi-Block'}
  let label17 = forms#newLabel(attrs17)
  let box17 = forms#newBox({ 'body': label17, 'mode': 'semi_block'} )

  let hspace = forms#newHSpace({})

  let attrs18 = { 'text': 'Triangle-Block'}
  let label18 = forms#newLabel(attrs18)
  let box18 = forms#newBox({ 'body': label18, 'mode': 'triangle_block'} )

  let vpoly1 = forms#newVPoly({ 'children': [box11, box12, box13, box14, box15, box16, box17, hspace, box18] })

  let attrs21 = { 'text': 'Light Double Dash'}
  let label21 = forms#newLabel(attrs21)
  let box21 = forms#newBox({ 'body': label21, 'mode': 'light_double_dash'} )

  let attrs22 = { 'text': 'Heavy Double Dash'}
  let label22 = forms#newLabel(attrs22)
  let box22 = forms#newBox({ 'body': label22, 'mode': 'heavy_double_dash'} )

  let attrs23 = { 'text': 'Light Triple Dash'}
  let label23 = forms#newLabel(attrs23)
  let box23 = forms#newBox({ 'body': label23, 'mode': 'light_triple_dash'} )

  let attrs24 = { 'text': 'Heavy Triple Dash'}
  let label24 = forms#newLabel(attrs24)
  let box24 = forms#newBox({ 'body': label24, 'mode': 'heavy_triple_dash'} )

  let attrs25 = { 'text': 'Light Quadruple Dash'}
  let label25 = forms#newLabel(attrs25)
  let box25 = forms#newBox({ 'body': label25, 'mode': 'light_quadruple_dash'} )

  let attrs26 = { 'text': 'Heavy Quadruple Dash'}
  let label26 = forms#newLabel(attrs26)
  let box26 = forms#newBox({ 'body': label26, 'mode': 'heavy_quadruple_dash'} )

  let attrs27 = { 'text': 'Block'}
  let label27 = forms#newLabel(attrs27)
  let box27 = forms#newBox({ 'body': label27, 'mode': 'block'} )

  let vpoly2 = forms#newVPoly({ 'children': [box21, box22, box23, box24, box25, box26, box27] })


  let hpoly = forms#newHPoly({ 'children': [vpoly1, vpoly2] })

  let boxMid = forms#newBox({ 'body': hpoly, 'mode': 'double'} )
  let boxOuter = forms#newBox({ 'body': boxMid, 'mode': 'default'} )

  let bg = forms#newBackground({ 'body': boxOuter} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction

function! forms#example#boxchars#MakeTest()
  call forms#AppendInput({'type': 'Sleep', 'time': 5})
  call forms#AppendInput({'type': 'Exit'})
  call forms#example#boxchars#Make()
endfunction
