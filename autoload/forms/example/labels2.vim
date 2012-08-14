
function! forms#example#labels2#Make()
  let l1 = forms#newLabel({ 'text': 'one'})
  let l2 = forms#newLabel({ 'text': 'two'})
  let l3 = forms#newLabel({ 'text': 'three'})
  let hpoly1 = forms#newHPoly({ 'children': [l1, l2, l3] })
  let bhp = forms#newBorder({ 'body': hpoly1, 'char': '.' })

  let la = forms#newLabel({ 'text': 'aaaa'})
  let lb = forms#newLabel({ 'text': 'bbbbbbb'})
  let blb = forms#newBorder({ 'body': lb, 'char': '*' })



  let vpoly1 = forms#newVPoly({ 'children': [bhp,la,blb], 'alignment': 'L' })
  let vpoly2 = forms#newVPoly({ 'children': [bhp,la,blb], 'alignment': 'C' })
  let vpoly3 = forms#newVPoly({ 'children': [bhp,la,blb], 'alignment': 'R' })
  let hpoly2 = forms#newHPoly({ 'children': [vpoly1, vpoly2, vpoly3] })
  let bo = forms#newBorder({ 'body': hpoly2 })
  let bg = forms#newBackground({ 'body': bo} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction

function! forms#example#labels2#MakeTest()
  call forms#AppendInput({'type': 'Sleep', 'time': 5})
  call forms#AppendInput({'type': 'Exit'})
  call forms#example#labels2#Make()
endfunction
