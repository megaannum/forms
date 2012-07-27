
function! forms#example#labels3#Make()
  let l1 = forms#newLabel({ 'text': 'one', 'status': g:IS_ENABLED})
  let l2 = forms#newLabel({ 'text': 'two', 'status': g:IS_DISABLED})
  let l3 = forms#newLabel({ 'text': 'three', 'status': g:IS_ENABLED})
  let vpoly1 = forms#newVPoly({ 'children': [l1, l2, l3] })
  let bvp = forms#newBorder({ 'body': vpoly1, 'char': '.' })

  let la = forms#newLabel({ 'text': 'aaaaaa'})
  let lb = forms#newLabel({ 'text': 'bbbbb'})
  let blb = forms#newBorder({ 'body': lb, 'char': '*' })



  let hpoly1 = forms#newHPoly({ 'children': [bvp,la,blb], 
                             \ 'mode': 'light',
                             \ 'alignment': 'T' })
  let hpoly2 = forms#newHPoly({ 'children': [bvp,la,blb], 
                             \ 'mode': 'double',
                             \ 'alignment': 'C' })
  let hpoly3 = forms#newHPoly({ 'children': [bvp,la,blb], 
                             \ 'mode': 'heavy',
                             \ 'alignment': 'B' })
  let vpoly2 = forms#newVPoly({ 'children': [hpoly1, hpoly2, hpoly3],
                             \ 'mode': 'light',
                             \ })
  let bo = forms#newBorder({ 'body': vpoly2 })
  let bg = forms#newBackground({ 'body': bo} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction

