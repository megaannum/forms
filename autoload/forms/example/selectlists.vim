
function! forms#example#selectlists#Make()
  let attrs11 = {'choices': [
          \ ["one", 1],
          \ ["two", 2],
          \ ["three", 3],
          \ ["four", 4]
          \ ]
          \ }

  let slist11 = forms#newSelectList(attrs11)
  let box11 = forms#newBox({ 'body': slist11} )

  let attrs12 = { 'mode': 'multiple',
          \ 'choices': [
          \ ["one", 1],
          \ ["two", 2],
          \ ["three", 3],
          \ ["four", 4]
          \ ]
          \ }
  let slist12 = forms#newSelectList(attrs12)
  let box12 = forms#newBox({ 'body': slist12 })

  let vpoly1 = forms#newVPoly({ 'children': [box11, box12], 'alignment': 'L' })

  let attrs21 = {'choices': [
          \ ["one", 1],
          \ ["two", 2],
          \ ["three", 3],
          \ ["four", 4],
          \ ["five", 5],
          \ ["six", 6]
          \ ], 'size': 4
          \ }

  let slist21 = forms#newSelectList(attrs21)
  let b21 = forms#newBox({ 'body': slist21 })

  let attrs22 = { 'mode': 'multiple',
          \ 'choices': [
          \ ["one", 1],
          \ ["two", 2],
          \ ["three", 3],
          \ ["four", 4],
          \ ["five", 5],
          \ ["six", 6]
          \ ], 'size': 4
          \ }
  let slist22 = forms#newSelectList(attrs22)
  let b22 = forms#newBox({ 'body': slist22 })

  let vpoly2 = forms#newVPoly({ 'children': [b21, b22], 'alignment': 'L' })

  let attrs31 = { 'mode': 'mandatory_single',
          \ 'choices': [
          \ ["one", 1],
          \ ["two", 2],
          \ ["three", 3],
          \ ["four", 4],
          \ ["five", 5],
          \ ["six", 6]
          \ ], 'size': 4
          \ }

  let slist31 = forms#newSelectList(attrs31)
  let b31 = forms#newBox({ 'body': slist31 })

  let attrs32 = { 'mode': 'mandatory_multiple',
          \ 'choices': [
          \ ["one", 1],
          \ ["two", 2],
          \ ["three", 3],
          \ ["four", 4],
          \ ["five", 5],
          \ ["six", 6]
          \ ], 'size': 4
          \ }
  let slist32 = forms#newSelectList(attrs32)
  let b32 = forms#newBox({ 'body': slist32 })

  let vpoly3 = forms#newVPoly({ 'children': [b31, b32], 'alignment': 'L' })


  let hpoly = forms#newHPoly({ 'children': [vpoly1, vpoly2, vpoly3], 'alignment': 'T' })
  let boxOuter = forms#newBox({ 'body': hpoly, 'mode': 'double'} )

  let bg = forms#newBackground({ 'body': boxOuter} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction

