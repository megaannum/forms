
" four editors in borders in polys

function! forms#example#foureditors#Make()
  let attrs = {'size': 15 }

  let attrs['init_text'] = "oneone"
  let txtEditor11 = forms#newFixedLengthField(attrs)
  let b11 = forms#newBorder({ 'body': txtEditor11 })

  let attrs['init_text'] = "onetwo"
  let txtEditor12 = forms#newFixedLengthField(attrs)
  let b12 = forms#newBorder({ 'body': txtEditor12 })

  let vpoly1 = forms#newVPoly({ 'children': [b11, b12] })


  let attrs['init_text'] = "twoone"
  let txtEditor21 = forms#newFixedLengthField(attrs)
  let b21 = forms#newBorder({ 'body': txtEditor21 })

  let attrs['init_text'] = "twotwo"
  let txtEditor22 = forms#newFixedLengthField(attrs)
  let b22 = forms#newBorder({ 'body': txtEditor22 })
  let vpoly2 = forms#newVPoly({ 'children': [b21, b22] })

  let hpoly = forms#newHPoly({ 'children': [vpoly1, vpoly2] })
  let bg = forms#newBackground({ 'body': hpoly} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction

function! forms#example#foureditors#MakeTest()
  call forms#AppendInput({'type': 'Sleep', 'time': 5})
  call forms#AppendInput({'type': 'Exit'})
  call forms#example#foureditors#Make()
endfunction
