
" labels center/center aligned in border
function! forms#example#labelsaligned#Make()
  let l1 = forms#newLabel({ 'text': 'one'})
  let l2 = forms#newLabel({ 'text': 'two'})
  let l3 = forms#newLabel({ 'text': 'three'})
  let vpoly = forms#newVPoly({ 'children': [l1, l2, l3] })

  let bi = forms#newBorder({ 'body': vpoly })

  let hva = forms#newHVAlign({ 'body': bi, 'halignment': 'C', 'valignment': 'C' })
  let ms = forms#newMinSize({ 'body': hva, 'height': 16 , 'width': 20})
  let bo = forms#newBorder({ 'body': ms })
  let bg = forms#newBackground({ 'body': bo} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction

