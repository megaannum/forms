
function! forms#example#checkboxes#Make()
  let cb11 = forms#newCheckBox({'tag': 'oneone'})
  let box11 = forms#newBox({ 'body': cb11} )
  let cb12 = forms#newCheckBox({'tag': 'onetwo'})
  let box12 = forms#newBox({ 'body': cb12} )
  let vpoly1 = forms#newVPoly({ 'children': [box11, box12] })

  let cb21 = forms#newCheckBox({'tag': 'twoone'})
  let box21 = forms#newBox({ 'body': cb21} )
  let cb22 = forms#newCheckBox({'tag': 'twotow'})
  let box22 = forms#newBox({ 'body': cb22} )
  let vpoly2 = forms#newVPoly({ 'children': [box21, box22] })

  let hpoly = forms#newHPoly({ 'children': [vpoly1, vpoly2] })

  let boxOuter = forms#newBox({ 'body': hpoly, 'mode': 'double'} )

  let bg = forms#newBackground({ 'body': boxOuter} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction

