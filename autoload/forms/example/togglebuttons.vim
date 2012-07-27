
function! forms#example#togglebuttons#Make()
  let text = forms#newText({'textlines': [
                                      \ "All", 
                                      \ "Alone" 
                                      \ ]})
  let tbo = forms#newToggleButton({'tag': 'alone', 'body': text})
  let boxtbo = forms#newBox({ 'body': tbo} )

  let group = forms#newButtonGroup({ 'member_type': 'forms#ToggleButton'})
  let l1 = forms#newLabel({'text': "ONE"})
  let tb1 = forms#newToggleButton({'tag': 'one', 'body': l1, 'group': group})
  let b1 = forms#newBox({ 'body': tb1} )

  let l2 = forms#newLabel({'text': "TWO"})
  let tb2 = forms#newToggleButton({'tag': 'two', 'body': l2, 'group': group})
  let b2 = forms#newBox({ 'body': tb2} )

  let l3 = forms#newLabel({'text': "THREE"})
  let tb3 = forms#newToggleButton({'tag': 'three', 'body': l3, 'group': group})
  let b3 = forms#newBox({ 'body': tb3} )
  let vpoly = forms#newVPoly({ 'children': [b1, b2, b3], 'alignment': 'L' })

  let group = forms#newButtonGroup({ 'member_type': 'forms#ToggleButton'})
  let lx1 = forms#newLabel({'text': "XONE"})
  let tbx1 = forms#newToggleButton({'tag': 'xone', 'body': lx1, 'group': group})
  let bx1 = forms#newBox({ 'body': tbx1} )
  let lx2 = forms#newLabel({'text': "XTWO"})
  let tbx2 = forms#newToggleButton({'tag': 'xtwo', 'body': lx2, 'group': group})
  let bx2 = forms#newBox({ 'body': tbx2} )
  let vpolyx = forms#newVPoly({ 'children': [bx1, bx2], 'alignment': 'L' })

  let hpoly = forms#newHPoly({ 'children': [tbo, vpoly, vpolyx], 'alignment': 'T' })

  let boxOuter = forms#newBox({ 'body': hpoly, 'mode': 'double'} )

  let bg = forms#newBackground({ 'body': boxOuter} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction
