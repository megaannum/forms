
" vertical label bottom aligned in border
function! forms#example#labelvaligned#Make()
  let attrs = { 'text': 'Bottom Label'}
  let l1 = forms#newVLabel(attrs)
  let bi1 = forms#newBorder({ 'body': l1 })
  let va1 = forms#newVAlign({ 'body': bi1, 'alignment': 'B' })
  let mh1 = forms#newMinHeight({ 'body': va1, 'height': 20 })
  let bo1 = forms#newBorder({ 'body': mh1 })

  let attrs = { 'text': 'Top Label'}
  let l2 = forms#newVLabel(attrs)
  let bi2 = forms#newBorder({ 'body': l2 })
  let va2 = forms#newVAlign({ 'body': bi2, 'alignment': 'T' })
  let mh2 = forms#newMinHeight({ 'body': va2, 'height': 20 })
  let bo2 = forms#newBorder({ 'body': mh2 })

  let hpoly = forms#newHPoly({'children': [bo1, bo2] })
  let bg = forms#newBackground({ 'body': hpoly} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction

function! forms#example#labelvaligned#MakeTest()
  call forms#AppendInput({'type': 'Sleep', 'time': 5})
  call forms#AppendInput({'type': 'Exit'})
  call forms#example#labelvaligned#Make()
endfunction
