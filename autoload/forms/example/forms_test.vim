
source $HOME/.vim/autoload/forms.vim

"---------------------------------------------------------------------------
" Tests and Examples: {{{1
"-------------------------------------------------------------------------------


map <Leader>bc :call BoxChars()<CR>
function! BoxChars()
  " 9472 - 9599
  let cnt = 9472
  while cnt < 9631
    execute 'normal o' .  nr2char(cnt)

    let cnt += 1
  endwhile
endfunction

function! TestAttribute()
  let slf = { '__msg': "" }
  let d = { 'msg': "hi there" }
  let s = "slf.__msg"
  if exists(s)
    let slf['__msg'] = d.msg
    echo "EXISTS: slf.__msg=" . slf.__msg
  else
    echo "NOT EXISTS: " . s
  endif
endfunction

map <Leader>s :call DrawDropShadow()<CR>
function! DrawDropShadow()
  let line = line('.')
  let column = col('.')
  let height = 10
  let width = 10

  let name = 'light'
  call forms#DrawBox(name, line, column, width, height)

  let corner = 'ul'

  if corner == 'ul'
    call forms#DrawDropShadow(corner, line-1, column-1, width, height)
  elseif corner == 'ur'
    call forms#DrawDropShadow(corner, line-1, column, width, height)
  elseif corner == 'll'
    call forms#DrawDropShadow(corner, line, column-1, width, height)
  elseif corner == 'lr'
    call forms#DrawDropShadow(corner, line, column, width, height)
  endif

endfunction

map <Leader>b :call DrawABox()<CR>
function! DrawABox()
  let line = line('.')
  let column = col('.')

  let h = '─'
  let dh = len(h)
  let v = '│'
  " dv == 3
  let dv = len(v)
  let lt = '┌'
  let dlt = len(lt)
  let rt = '┐'
  let drt = len(rt)
  let lb = '└'
  let dlb = len(lb)
  let rb = '┘'
  let drb = len(rb)
  let width = 10
  let height = 10

  " :call cursor(line('.'), col('.')+1)
  call cursor(line, column)
  execute 'normal r' . lt . ''

  let d =  dlt
  call cursor(line, column+d)
  execute 'normal ' . (width-2) . 'r' . h . ''

  let d =  dlt + dh * (width-2)
  call cursor(line, column+d)
  execute 'normal r' . rt . ''

  let d =  dv + (width-2)
  let cnt = 1
  while cnt < (height - 1)
    call cursor(line+cnt, column)
    execute 'normal r' . v . ''
    call cursor(line+cnt, column+d)
    execute 'normal r' . v . ''

    let cnt += 1
  endwhile

  call cursor(line+height-1, column)
  execute 'normal r' . lb . ''

  let d =  dlb
  call cursor(line+height-1, column+d)
  execute 'normal ' . (width-2) . 'r' . h . ''

  let d =  dlb + dh * (width-2)
  call cursor(line+height-1, column+d)
  execute 'normal r' . rb . ''

"call forms#log("DrawABox dv=" .  dv)
endfunction

function! DoEcho()
  execute "echo 'shift-tab'"
endfunction

" getchar takes presidence
" nmap <silent> <buffer> <S-Tab> :call DoEcho()<CR>


"-------------------------------------------------------------------------------
"-------------------------------------------------------------------------------
" Test Code
"-------------------------------------------------------------------------------
"-------------------------------------------------------------------------------

" background(box(label))
map <Leader>b0 :call MakeFormb0()<CR>
function! MakeFormb0() 
call forms#log("MakeFormb0 TOP")

  let attrs = { 'text': 'My Label'}
  let label = forms#newLabel(attrs)
  let box = forms#newBox({ 'body': label} )
  let bg = forms#newBackground({ 'body': box} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction

" different box drawing characters
map <Leader>b1 :call MakeFormb1()<CR>
function! MakeFormb1() 
call forms#log("MakeFormb1 TOP")

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

" labels in boxes
map <Leader>b2 :call MakeFormb2()<CR>
function! MakeFormb2() 
call forms#log("MakeFormb2 TOP")

  let attrs1 = { 'text': 'My Label'}
  let label1 = forms#newLabel(attrs1)
  let box1 = forms#newBox({ 'body': label1} )

  let attrs2 = { 'text': 'My Label'}
  let label2 = forms#newLabel(attrs2)
  let box2 = forms#newBox({ 'body': label2} )

  let hpoly = forms#newHPoly({ 'children': [box1, box2] })
  let boxOuter = forms#newBox({ 'body': hpoly, 'mode': 'double'} )

  let bg = forms#newBackground({ 'body': boxOuter} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction


" more labels in boxes
map <Leader>b3 :call MakeFormb3()<CR>
function! MakeFormb3() 
call forms#log("MakeFormb3 TOP")

  let attrs11 = { 'text': 'My Label11'}
  let label11 = forms#newLabel(attrs11)
  let box11 = forms#newBox({ 'body': label11} )
  let attrs12 = { 'text': 'My Label12'}
  let label12 = forms#newLabel(attrs12)
  let box12 = forms#newBox({ 'body': label12} )
  let vpoly1 = forms#newVPoly({ 'children': [box11, box12] })

  let attrs21 = { 'text': 'My Label21'}
  let label21 = forms#newLabel(attrs21)
  let box21 = forms#newBox({ 'body': label21} )
  let attrs22 = { 'text': 'My Label22'}
  let label22 = forms#newLabel(attrs22)
  let box22 = forms#newBox({ 'body': label22} )
  let vpoly2 = forms#newVPoly({ 'children': [box21, box22] })

  let hpoly = forms#newHPoly({ 'children': [vpoly1, vpoly2] })

  let boxOuter = forms#newBox({ 'body': hpoly, 'mode': 'double'} )

  let bg = forms#newBackground({ 'body': boxOuter} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction

" editor in a box
map <Leader>b4 :call MakeFormb4()<CR>
function! MakeFormb4() 
call forms#log("MakeFormb4 TOP")

  let attrs = {'size': 10, 'init_text': 'hi' }
  let edi = forms#newFixedLengthField(attrs)
  let box = forms#newBox({ 'body': edi} )

  let bg = forms#newBackground({ 'body': box} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction


" editors in  boxes
map <Leader>b5 :call MakeFormb5()<CR>
function! MakeFormb5() 
call forms#log("MakeFormb5 TOP")

  let attrs11 = {'size': 10, 'init_text': 'hi11' }
  let edi11 = forms#newFixedLengthField(attrs11)
  let box11 = forms#newBox({ 'body': edi11} )
  let attrs12 = {'size': 10, 'init_text': 'hi12' }
  let edi12 = forms#newFixedLengthField(attrs12)
  let box12 = forms#newBox({ 'body': edi12} )
  let vpoly1 = forms#newVPoly({ 'children': [box11, box12] })

  let attrs21 = {'size': 10, 'init_text': 'hi21' }
  let edi21 = forms#newFixedLengthField(attrs21)
  let box21 = forms#newBox({ 'body': edi21} )
  let attrs22 = {'size': 10, 'init_text': 'hi22' }
  let edi22 = forms#newFixedLengthField(attrs22)
  let box22 = forms#newBox({ 'body': edi22} )
  let vpoly2 = forms#newVPoly({ 'children': [box21, box22] })

  let hpoly = forms#newHPoly({ 'children': [vpoly1, vpoly2] })

  let boxOuter = forms#newBox({ 'body': hpoly, 'mode': 'double'} )

  let bg = forms#newBackground({ 'body': boxOuter} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction

" editor in a box
map <Leader>b6 :call MakeFormb6()<CR>
function! MakeFormb6() 
call forms#log("MakeFormb6 TOP")

  let attrs = {'size': 10, 'init_text': 'hi' }
  let edi = forms#newVariableLengthField(attrs)
  let box = forms#newBox({ 'body': edi} )

  let bg = forms#newBackground({ 'body': box} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction

" editors in boxes
map <Leader>b7 :call MakeFormb7()<CR>
function! MakeFormb7() 
call forms#log("MakeFormb7 TOP")

  let attrs11 = {'size': 10, 'init_text': 'hi11' }
  let edi11 = forms#newVariableLengthField(attrs11)
  let box11 = forms#newBox({ 'body': edi11} )
  let attrs12 = {'size': 10, 'init_text': 'hi12' }
  let edi12 = forms#newVariableLengthField(attrs12)
  let box12 = forms#newBox({ 'body': edi12} )
  let vpoly1 = forms#newVPoly({ 'children': [box11, box12] })

  let attrs21 = {'size': 10, 'init_text': 'hi21' }
  let edi21 = forms#newVariableLengthField(attrs21)
  let box21 = forms#newBox({ 'body': edi21} )
  let attrs22 = {'size': 10, 'init_text': 'hi22' }
  let edi22 = forms#newVariableLengthField(attrs22)
  let box22 = forms#newBox({ 'body': edi22} )
  let vpoly2 = forms#newVPoly({ 'children': [box21, box22] })

  let hpoly = forms#newHPoly({ 'children': [vpoly1, vpoly2] })

  let boxOuter = forms#newBox({ 'body': hpoly, 'mode': 'double'} )

  let bg = forms#newBackground({ 'body': boxOuter} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction


" vertical label in a box
map <Leader>b8 :call MakeFormb8()<CR>
function! MakeFormb8() 
call forms#log("MakeFormb8 TOP")

  let attrs = { 'text': 'My Label'}
  let vl = forms#newVLabel(attrs)
  let box = forms#newBox({ 'body': vl} )

  let bg = forms#newBackground({ 'body': box} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction


" vertical labels in boxes
map <Leader>b9 :call MakeFormb9()<CR>
function! MakeFormb9() 
call forms#log("MakeFormb9 TOP")

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

" checkbox in a box 
map <Leader>c0 :call MakeFormc0()<CR>
function! MakeFormc0() 
call forms#log("MakeFormc0 TOP")

  let checkbox1 = forms#newCheckBox({'tag': 'one'})
  let box = forms#newBox({ 'body': checkbox1} )

  let bg = forms#newBackground({ 'body': box} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction


" checkboxes in boxes
map <Leader>c1 :call MakeFormc1()<CR>
function! MakeFormc1() 
call forms#log("MakeFormc1 TOP")

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

" radiobuttons in a box
map <Leader>c2 :call MakeFormc2()<CR>
function! MakeFormc2() 
call forms#log("MakeFormc2 TOP")

  let group = forms#newButtonGroup({ 'member_type': 'forms#RadioButton'})

  let rb1 = forms#newRadioButton({'tag': 'one', 'group': group})
  let b1 = forms#newBorder({ 'body': rb1 })
  let rb2 = forms#newRadioButton({'tag': 'two', 'group': group})
  let b2 = forms#newBorder({ 'body': rb2 })
  let vpoly = forms#newVPoly({ 'children': [b1, b2], 'alignment': 'L' })

  let box = forms#newBox({ 'body': vpoly} )

  let bg = forms#newBackground({ 'body': box} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction

" radiobuttons in boxes
map <Leader>c3 :call MakeFormc3()<CR>
function! MakeFormc3() 
call forms#log("MakeFormc3 TOP")
  let group = forms#newButtonGroup({ 'member_type': 'forms#RadioButton'})

  let rb11 = forms#newRadioButton({'tag': 'one', 'group': group})
  let b11 = forms#newBorder({ 'body': rb11 })
  let box11 = forms#newBox({ 'body': b11} )
  let rb12 = forms#newRadioButton({'tag': 'one', 'group': group})
  let b12 = forms#newBorder({ 'body': rb12 })
  let box12 = forms#newBox({ 'body': b12} )
  let vpoly1 = forms#newVPoly({ 'children': [box11, box12] })

  let rb21 = forms#newRadioButton({'tag': 'one', 'group': group})
  let b21 = forms#newBorder({ 'body': rb21 })
  let box21 = forms#newBox({ 'body': b21} )
  let rb22 = forms#newRadioButton({'tag': 'one', 'group': group})
  let b22 = forms#newBorder({ 'body': rb22 })
  let box22 = forms#newBox({ 'body': b22} )
  let vpoly2 = forms#newVPoly({ 'children': [box21, box22] })

  let hpoly = forms#newHPoly({ 'children': [vpoly1, vpoly2] })

  let boxOuter = forms#newBox({ 'body': hpoly, 'mode': 'double'} )

  let bg = forms#newBackground({ 'body': boxOuter} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction


" togglebutton in a boxe
map <Leader>c4 :call MakeFormc4()<CR>
function! MakeFormc4() 
call forms#log("MakeFormc4 TOP")

  let l1 = forms#newLabel({'text': "ONE"})
  let tb1 = forms#newToggleButton({'tag': 'one', 'body': l1})

  let box = forms#newBox({ 'body': tb1} )

  let bg = forms#newBackground({ 'body': box} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction

" a number of togglebuttons in boxes
map <Leader>c5 :call MakeFormc5()<CR>
function! MakeFormc5() 
call forms#log("MakeFormc5 TOP")
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


" selectlist in box
map <Leader>c6 :call MakeFormc6()<CR>
function! MakeFormc6() 
call forms#log("MakeFormc6 TOP")

  let attrs1 = {'choices': [
          \ ["one", 1],
          \ ["two", 2],
          \ ["three", 3],
          \ ["four", 4]
          \ ]
          \ }

  let slist1 = forms#newSelectList(attrs1)
  let box = forms#newBox({ 'body': slist1} )

  let bg = forms#newBackground({ 'body': box} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction


" multiple selectlists in boxes
map <Leader>c7 :call MakeFormc7()<CR>
function! MakeFormc7() 
call forms#log("MakeFormc7 TOP")
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


" buttons and label in subform 
map <Leader>c8 :call MakeFormc8()<CR>
function! MakeFormc8() 
call forms#log("MakeFormc8 TOP")

  function! C8HelpAction(...) dict
call forms#log("HelpAction.execute")
    let nohelp = forms#newLabel({'text': "NO Help"})
    let b = forms#newBox({ 'body': nohelp, 'mode': 'double' })
    let bg = forms#newBackground({ 'body': b} )

    let form = forms#newForm({'body': bg })
    call form.run()
    redraw
  endfunction
  let helpaction = forms#newAction({ 'execute': function("C8HelpAction")})

  let helplabel = forms#newLabel({'text': "Help"})
  let helpbox = forms#newBox({ 'body': helplabel })
  let helpbutton = forms#newButton({
                                \ 'tag': 'help', 
                                \ 'body': helpbox, 
                                \ 'action': helpaction})


  let label1 = forms#newLabel({'text': "Cancel"})
  let button1 = forms#newButton({
                              \ 'tag': 'cancel', 
                              \ 'body': label1, 
                              \ 'action': g:forms#cancelAction})
  let b1 = forms#newBox({ 'body': button1 })

  let label2 = forms#newLabel({'text': "Submit"})
  let button2 = forms#newButton({
                              \ 'tag': 'submit', 
                              \ 'body': label2, 
                              \ 'action': g:forms#submitAction})
  let b2 = forms#newBox({ 'body': button2 })


  let hpoly = forms#newHPoly({ 'children': [helpbutton, b1, b2], 'alignment': 'T' })

  let boxOuter = forms#newBox({ 'body': hpoly, 'mode': 'double'} )

  let bg = forms#newBackground({ 'body': boxOuter} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction


" three labels in a deck (only first label available)
map <Leader>c9 :call MakeFormc9()<CR>
function! MakeFormc9() 
call forms#log("MakeFormc9 TOP")

  let l1 = forms#newLabel({'text': "label one"})
  let b1 = forms#newBox({ 'body': l1} )
  let l2 = forms#newLabel({'text': "label two"})
  let l3 = forms#newLabel({'text': "label three"})

  let deck = forms#newDeck({ 'children': [b1, l2, l3] })
  let box = forms#newBox({ 'body': deck} )
  let bg = forms#newBackground({ 'body': box} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction


" four labels in a deck and selectlist
map <Leader>a1 :call MakeForma1()<CR>
function! MakeForma1() 
call forms#log("MakeForma1 TOP")
  let l1 = forms#newLabel({'text': "label one"})
  let b1 = forms#newBox({ 'body': l1, 'mode': 'single'} )
  let l2 = forms#newLabel({'text': "label two"})
  let l3 = forms#newLabel({'text': "label three"})
  let b3 = forms#newBox({ 'body': l3, 'mode': 'double'} )
  let l4 = forms#newLabel({'text': "label four"})

  let deck = forms#newDeck({ 'children': [b1, l2, b3, l4] })

  function! A4Action(...) dict
    let pos = a:1
call forms#log("A4Action.execute: " . pos)
    call self.deck.setCard(pos)
  endfunction
  let action = forms#newAction({ 'execute': function("A4Action")})
  let action['deck'] = deck

  let attrs = { 'mode': 'single',
          \ 'pos': 0,
          \ 'choices': [
          \ ["one", 1],
          \ ["two", 2],
          \ ["three", 3],
          \ ["four", 4]
          \ ], 'size': 4,
          \ 'on_selection_action': action
          \ }
  let slist = forms#newSelectList(attrs)
  let b = forms#newBorder({ 'body': slist })

  let hpoly = forms#newHPoly({ 'children': [b, deck], 'alignment': 'T' })

  let box = forms#newBox({ 'body': hpoly, 'mode': 'double'} )
  let bg = forms#newBackground({ 'body': box} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction

" XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

" labels in box in button
map <Leader>a2 :call MakeForma2()<CR>
function! MakeForma2() 
call forms#log("MakeForma2 TOP")

  let l1 = forms#newLabel({'text': "label one"})
  let b1 = forms#newBox({ 'body': l1} )
  let button = forms#newButton({'tag': 'submit', 'body': b1})

  let bg = forms#newBackground({ 'body': button} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction


" 10 H in box
map <Leader>d1 :call MakeFormd1()<CR>
function! MakeFormd1() 
  let attrs = {'size': 10, 'char': 'H' }
  let hspace = forms#newHSpace(attrs)
  let top = forms#newBox({ 'body': hspace})

  let form = forms#newForm({'body': top })
  call form.run()
endfunction

" 10 H in border
map <Leader>d2 :call MakeFormd2()<CR>
function! MakeFormd2() 
  let attrs = {'size': 10, 'char': 'H' }
  let hspace = forms#newHSpace(attrs)
  let top = forms#newBorder({ 'body': hspace, 'char': '*', 'size': 2})

  let form = forms#newForm({'body': top })
  call form.run()
endfunction

" 10 H in box
map <Leader>d3 :call MakeFormd3()<CR>
function! MakeFormd3() 
  let attrs = {'size': 10, 'char': 'H' }
  let vspace = forms#newVSpace(attrs)
  let top = forms#newBox({ 'body': vspace})

  let form = forms#newForm({'body': top })
  call form.run()
endfunction

" 10 H in border
map <Leader>d4 :call MakeFormd4()<CR>
function! MakeFormd4() 
  let attrs = {'size': 10, 'char': 'H' }
  let vspace = forms#newVSpace(attrs)
  let top = forms#newBorder({ 'body': vspace, 'char': '*', 'size': 2})

  let form = forms#newForm({'body': top })
  call form.run()
endfunction



" editor in border
map <Leader>e1 :call MakeForme1()<CR>
function! MakeForme1() 
  let attrs = {'size': 10, 'init_text': 'hi' }
  let txtEditor = forms#newFixedLengthField(attrs)
  let top = forms#newBorder({ 'body': txtEditor, 'char':'*' })

  let form = forms#newForm({'body': top })
  call form.run()
endfunction

" editor in border in vpoly
map <Leader>e2 :call MakeForme2()<CR>
function! MakeForme2() 
  let attrs = {'size': 10, 'init_text': 'hi' }
  let txtEditor = forms#newFixedLengthField(attrs)
  let b1 = forms#newBorder({ 'body': txtEditor, 'char':'*' })
  let vpoly = forms#newVPoly({ 'children': [b1] })


  let form = forms#newForm({'body': vpoly })
  call form.run()
endfunction

" two lables in borders in polys
map <Leader>e3 :call MakeForme3()<CR>
function! MakeForme3() 
  " let attrs = {'size': 10, 'init_text': 'hi' }
  " let txtEditor1 = forms#newFixedLengthField(attrs)
  let l1 = forms#newLabel({'text': "label one"})
  let b1 = forms#newBorder({ 'body': l1, 'char': '*' })
  let hpoly1 = forms#newHPoly({ 'children': [b1], 'mode': 'light' })

  "let attrs = {'size': 10, 'init_text': 'hi' }
  "let txtEditor2 = forms#newFixedLengthField(attrs)
  let l2 = forms#newLabel({'text': "label two"})
  let b2 = forms#newBorder({ 'body': l2, 'char': '+' })
  let hpoly2 = forms#newHPoly({ 'children': [b2], 'mode': 'light' })

  let vpoly = forms#newVPoly({ 'children': [hpoly1, hpoly2] })

  let form = forms#newForm({'body': vpoly })
  call form.run()
endfunction

" two lables in borders in polys
map <Leader>e4 :call MakeForme4()<CR>
function! MakeForme4() 
  let l1 = forms#newLabel({'text': "label one"})
  let b1 = forms#newBorder({ 'body': l1, 'char': '*' })
  let vpoly1 = forms#newVPoly({ 'children': [b1], 'mode': 'light' })

  let l2 = forms#newLabel({'text': "label two"})
  let b2 = forms#newBorder({ 'body': l2, 'char': '+' })
  let vpoly2 = forms#newVPoly({ 'children': [b2], 'mode': 'light' })

  let hpoly = forms#newHPoly({ 'children': [vpoly1, vpoly2] })

  let form = forms#newForm({'body': hpoly })
  call form.run()
endfunction
" XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

if 0
map <Leader>e4O :call MakeForme4O()<CR>
function! MakeForme4O() 
  let attrs1 = {'size': 10, 'init_text': 'one' }
  let txtEditor1 = forms#newFixedLengthField(attrs1)
  let b1 = forms#newBorder({ 'body': txtEditor1 })

  let attrs2 = {'size': 20, 'init_text': 'two' }
  let txtEditor2 = forms#newFixedLengthField(attrs2)
  let b2 = forms#newBorder({ 'body': txtEditor2 })

  let vpoly = forms#newVPoly({ 'children': [b1, b2] })
  let bg = forms#newBackground({ 'body': vpoly} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction
endif

" four editors in borders in polys
map <Leader>e5 :call MakeForme5()<CR>
function! MakeForme5() 
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

" two editors in borders in fixed layout
map <Leader>e6 :call MakeForme6()<CR>
function! MakeForme6() 
call forms#log("MakeForme6 TOP")

  let attrs = {'size': 15 , 'init_text': 'one'}
  let txtEditor1 = forms#newFixedLengthField(attrs)
  let b1 = forms#newBorder({ 'body': txtEditor1, 'char': '*' })


  let attrs = {'size': 10 , 'init_text': 'two'}
  let txtEditor2 = forms#newFixedLengthField(attrs)
  let b2 = forms#newBorder({ 'body': txtEditor2, 'char': '+' })

  let fixedlayout = forms#newFixedLayout({ 
                                          \ 'width': 30, 
                                          \ 'height': 10,
                                          \ 'children': [b1, b2],
                                          \ 'x_positions': [2, 10],
                                          \ 'y_positions': [2, 7]
                                          \ })
  let bg = forms#newBackground({ 'body': fixedlayout} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction

" enabled label
map <Leader>e7 :call MakeForme7()<CR>
function! MakeForme7() 
call forms#log("MakeForme7 TOP")
  let attrs = { 'text': 'My Label', 'status': g:IS_ENABLED}
  let l = forms#newLabel(attrs)
  let b = forms#newBackground({ 'body': l })

  let form = forms#newForm({'body': b })
  call form.run()
endfunction

" vertical label
map <Leader>e8 :call MakeForme8()<CR>
function! MakeForme8() 
call forms#log("MakeForme8 TOP")
  let attrs = { 'text': 'My Label'}
  let l = forms#newVLabel(attrs)
  let b = forms#newBackground({ 'body': l })

  let form = forms#newForm({'body': b })
  call form.run()
endfunction

" label center aligned in border
map <Leader>e9 :call MakeForme9()<CR>
function! MakeForme9() 
call forms#log("MakeForme9 TOP")
  let attrs = { 'text': 'My Label'}
  let l = forms#newLabel(attrs)
  let ha = forms#newHAlign({ 'body': l, 'alignment': 'C' })
  let mw = forms#newMinWidth({ 'body': ha, 'width': 16 })
  let b = forms#newBorder({ 'body': mw, 'char': '*' })
  let bg = forms#newBackground({ 'body': b} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction

" label right aligned in border
map <Leader>f0 :call MakeFormf0()<CR>
function! MakeFormf0() 
call forms#log("MakeFormf0 TOP")
  let attrs = { 'text': 'My Label'}
  let l = forms#newLabel(attrs)
  let bi = forms#newBorder({ 'body': l })
  let ha = forms#newHAlign({ 'body': bi, 'alignment': 'R' })
  let mw = forms#newMinWidth({ 'body': ha, 'width': 16 })
  let bo = forms#newBorder({ 'body': mw })
  let bg = forms#newBackground({ 'body': bo} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction

" vertical label top aligned in border
map <Leader>f1 :call MakeFormf1()<CR>
function! MakeFormf1() 
call forms#log("MakeFormf1 TOP")
  let attrs = { 'text': 'My Label'}
  let l = forms#newVLabel(attrs)
  let va = forms#newVAlign({ 'body': l })
  let mh = forms#newMinHeight({ 'body': va, 'height': 16 })
  let b = forms#newBorder({ 'body': mh })
  let bg = forms#newBackground({ 'body': b} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction

" vertical label bottom aligned in border
map <Leader>f2 :call MakeFormf2()<CR>
function! MakeFormf2() 
call forms#log("MakeFormf2 TOP")
  let attrs = { 'text': 'My Label'}
  let l = forms#newVLabel(attrs)
  let bi = forms#newBorder({ 'body': l })
  let va = forms#newVAlign({ 'body': bi, 'alignment': 'B' })
  let mh = forms#newMinHeight({ 'body': va, 'height': 16 })
  let bo = forms#newBorder({ 'body': mh })
  let bg = forms#newBackground({ 'body': bo} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction

" label center/center aligned in border
map <Leader>f3 :call MakeFormf3()<CR>
function! MakeFormf3() 
call forms#log("MakeFormf3 TOP")
  let attrs = { 'text': 'Hello My Label'}
  let l = forms#newLabel(attrs)
  let hva = forms#newHVAlign({ 'body': l })
  let b = forms#newBorder({ 'body': hva })
  let bg = forms#newBackground({ 'body': b} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction

" vertical label center/center aligned in border
map <Leader>f4 :call MakeFormf4()<CR>
function! MakeFormf4() 
call forms#log("MakeFormf4 TOP")
  let attrs = { 'text': 'Hello My Label'}
  let l = forms#newVLabel(attrs)
  let hva = forms#newHVAlign({ 'body': l })
  let b = forms#newBorder({ 'body': hva })
  let bg = forms#newBackground({ 'body': b} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction

" labels center/center aligned in border
map <Leader>f5 :call MakeFormf5()<CR>
function! MakeFormf5() 
call forms#log("MakeFormf5 TOP")
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

" labels polys and alignments
map <Leader>f6 :call MakeFormf6()<CR>
function! MakeFormf6() 
call forms#log("MakeFormf6 TOP")
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


" labels polys and alignments
map <Leader>f7 :call MakeFormf7()<CR>
function! MakeFormf7() 
call forms#log("MakeFormf7 TOP")
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


" labels polys and alignments
map <Leader>f8 :call MakeFormf8()<CR>
function! MakeFormf8() 
call forms#log("MakeFormf8 TOP")
  let l11 = forms#newLabel({ 'text': '11'})

  let l12 = forms#newLabel({ 'text': 'onetwo'})

  let l1 = forms#newLabel({ 'text': 'one'})
  let l2 = forms#newLabel({ 'text': 'two'})
  let l3 = forms#newLabel({ 'text': 'three'})

  let vpoly13 = forms#newVPoly({ 'children': [l1, l2, l3] })


  let l21 = forms#newVLabel({ 'text': 'twoone'})
  let l22 = forms#newLabel({ 'text': '22'})
  let l23 = forms#newLabel({ 'text': 'twothree'})

  let vpoly31 = forms#newVPoly({ 'children': [l1, l2, l3] })
  let l32 = forms#newLabel({ 'text': 'threetwo'})
  let l33 = forms#newLabel({ 'text': '33'})


"    nos_rows: (> 0)
"    nos_columns: (> 0)
"    char
"    cell_height 
"    cell_width
"    major_axis: (row) row or column
"    halignment: (L) float align 0-1 or L C R
"    valignment: (T) float align 0-1 or T C B
"    halignments: [row, (L) float align 0-1 or L C R]
"    valignments: [column, (T) float align 0-1 or T C B]
"    data[[row, column, glyph]]

  let grid = forms#newGrid({ 
                          \ 'nos_rows': 3, 
                          \ 'nos_columns': 3, 
                          \ 'mode': 'light', 
                          \ 'halignment': 'L', 
                          \ 'valignment': 'T', 
                          \ 'halignments': [[1,'C'],[2,'R']], 
                          \ 'valignments': [[1,'C'],[2,'B']], 
                          \ 'data': [
                            \ [0, 0, l11],
                            \ [0, 1, l12],
                            \ [0, 2, vpoly13],
                            \ [1, 0, l21],
                            \ [1, 1, l22],
                            \ [1, 2, l23],
                            \ [2, 0, vpoly31],
                            \ [2, 1, l32],
                            \ [2, 2, l33]
                            \ ] 
                          \ })
  " let b = forms#newBorder({ 'body': grid })
  let bg = forms#newBackground({ 'body': grid} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction

" checkboxes in vpoly
map <Leader>f9 :call MakeFormf9()<CR>
function! MakeFormf9() 
call forms#log("MakeFormf9 TOP")
  let checkbox1 = forms#newCheckBox({'tag': 'one'})
  let b1 = forms#newBorder({ 'body': checkbox1 })
  let checkbox2 = forms#newCheckBox({'char': '+', 'tag': 'two'})
  let b2 = forms#newBorder({ 'body': checkbox2 })

  let vpoly = forms#newVPoly({ 'children': [b1, b2], 'alignment': 'L' })
  let bv = forms#newBorder({ 'body': vpoly })
  let bg = forms#newBackground({ 'body': bv} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction

" radiobuttons in vpoly
map <Leader>g0 :call MakeFormg0()<CR>
function! MakeFormg0() 
call forms#log("MakeFormg0 TOP")
  let group = forms#newButtonGroup({ 'member_type': 'forms#RadioButton'})
  let rb1 = forms#newRadioButton({'tag': 'one', 'group': group})
  let b1 = forms#newBorder({ 'body': rb1 })
  let rb2 = forms#newRadioButton({'tag': 'two', 'group': group})
  let b2 = forms#newBorder({ 'body': rb2 })
  let rb3 = forms#newRadioButton({'char': '+', 'tag': 'three', 'group': group})
  let b3 = forms#newBorder({ 'body': rb3 })

  let vpoly = forms#newVPoly({ 'children': [b1, b2, b3], 'alignment': 'L' })
  let bv = forms#newBorder({ 'body': vpoly })
  let bg = forms#newBackground({ 'body': bv} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction

" togglebuttons 
map <Leader>g1 :call MakeFormg1()<CR>
function! MakeFormg1() 
call forms#log("MakeFormg1 TOP")
  let text = forms#newText({'textlines': [
                                      \ "All", 
                                      \ "Alone" 
                                      \ ]})
  let tbo = forms#newToggleButton({'tag': 'alone', 'body': text})

  let group = forms#newButtonGroup({ 'member_type': 'forms#ToggleButton'})
  let l1 = forms#newLabel({'text': "ONE"})
  let tb1 = forms#newToggleButton({'tag': 'one', 'body': l1, 'group': group})
  let b1 = forms#newBorder({ 'body': tb1 })

  let l2 = forms#newLabel({'text': "TWO"})
  let tb2 = forms#newToggleButton({'tag': 'two', 'body': l2, 'group': group})
  let b2 = forms#newBorder({ 'body': tb2 })

  let l3 = forms#newLabel({'text': "THREE"})
  let tb3 = forms#newToggleButton({'tag': 'three', 'body': l3, 'group': group})
  let b3 = forms#newBorder({ 'body': tb3 })
  let vpoly = forms#newVPoly({ 'children': [b1, b2, b3], 'alignment': 'L' })

  let group = forms#newButtonGroup({ 'member_type': 'forms#ToggleButton'})
  let lx1 = forms#newLabel({'text': "XONE"})
  let tbx1 = forms#newToggleButton({'tag': 'xone', 'body': lx1, 'group': group})
  let lx2 = forms#newLabel({'text': "XTWO"})
  let tbx2 = forms#newToggleButton({'tag': 'xtwo', 'body': lx2, 'group': group})
  let vpolyx = forms#newVPoly({ 'children': [tbx1, tbx2], 'alignment': 'L' })

  let hpoly = forms#newHPoly({ 'children': [tbo, vpoly, vpolyx], 'alignment': 'T' })
  let bv = forms#newBorder({ 'body': hpoly })
  let bg = forms#newBackground({ 'body': bv} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction

" buttons with subform
map <Leader>g2 :call MakeFormg2()<CR>
function! MakeFormg2() 
call forms#log("MakeFormg2 TOP")

  function! G2HelpAction(...) dict
call forms#log("HelpAction.execute")
    let nohelp = forms#newLabel({'text': "NO Help"})
    let b = forms#newBorder({ 'body': nohelp })
    let bg = forms#newBackground({ 'body': b} )

    let form = forms#newForm({'body': bg })
    call form.run()
    redraw
  endfunction
  let helpaction = forms#newAction({ 'execute': function("G2HelpAction")})

if 0
  function! G2Action(...) dict
call forms#log("Action.execute")
    call forms#AppendInput(27)
  endfunction
  let action = forms#newAction({ 'execute': function("G2Action")})
endif

  let helplabel = forms#newLabel({'text': "Help"})
  let helpbutton = forms#newButton({
                                \ 'tag': 'help', 
                                \ 'body': helplabel, 
                                \ 'action': helpaction})

  let help = forms#newBorder({ 'body': helpbutton })

  let label1 = forms#newLabel({'text': "Cancel"})
  let button1 = forms#newButton({
                              \ 'tag': 'cancel', 
                              \ 'body': label1, 
                              \ 'action': g:forms#cancelAction})
  let b1 = forms#newBorder({ 'body': button1 })

  let label2 = forms#newLabel({'text': "Submit"})
  let button2 = forms#newButton({
                              \ 'tag': 'submit', 
                              \ 'body': label2, 
                              \ 'action': g:forms#submitAction})
  let b2 = forms#newBorder({ 'body': button2 })

  let label3 = forms#newLabel({'text': "Credits"})
  let button3 = forms#newButton({
                              \ 'tag': 'submit', 
                              \ 'body': label3, 
                              \ 'command': ':help credits'})
  let b3 = forms#newBorder({ 'body': button3 })


  let hpoly = forms#newHPoly({ 'children': [help, b1, b2, b3], 'alignment': 'T' })
  let bg = forms#newBackground({ 'body': hpoly} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction


" text
map <Leader>g3 :call MakeFormg3()<CR>
function! MakeFormg3() 
call forms#log("MakeFormg3 TOP")

  let text = forms#newText({'textlines': [
                                      \ "Now is the time", 
                                      \ "to speak of many things.", 
                                      \ "Of cabages and kings.", 
                                      \ ]})
  let b = forms#newBorder({ 'body': text })
  let bg = forms#newBackground({ 'body': b} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction


" editor
map <Leader>g4 :call MakeFormg4()<CR>
function! MakeFormg4() 
call forms#log("MakeFormg4 TOP")
  let attrs = {'size': 10, 'init_text': 'one' }
  let editor = forms#newVariableLengthField(attrs)

  let b = forms#newBorder({ 'body': editor })
  let bg = forms#newBackground({ 'body': b} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction


" editors
map <Leader>g5 :call MakeFormg5()<CR>
function! MakeFormg5() 
call forms#log("MakeFormg5 TOP")
  let attrs1 = {'size': 10, 'init_text': 'one' }
  let editor1 = forms#newVariableLengthField(attrs1)
  let b1 = forms#newBorder({ 'body': editor1 })

  let attrs2 = {'size': 20}
  let editor2 = forms#newVariableLengthField(attrs2)
  let b2 = forms#newBorder({ 'body': editor2 })

  let vpoly = forms#newVPoly({ 'children': [b1, b2], 'alignment': 'L' })
  let bg = forms#newBackground({ 'body': vpoly} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction


" selectlists different modes
map <Leader>g6 :call MakeFormg6()<CR>
function! MakeFormg6() 
call forms#log("MakeFormg6 TOP")

  function! G6SelectAction(...) dict
call forms#log("G6SelectAction.execute: selection=".a:1)
  endfunction
  let select_action = forms#newAction({ 'execute': function("G6SelectAction")})
  function! G6DeSelectAction(...) dict
call forms#log("G6DeSelectAction.execute: selection=".a:1)
  endfunction
  let deselect_action = forms#newAction({ 'execute': function("G6DeSelectAction")})

  let attrs1 = {'choices': [
          \ ["one", 1],
          \ ["two", 2],
          \ ["three", 3],
          \ ["four", 4]
          \ ],
          \ 'on_selection_action':  select_action,
          \ 'on_deselection_action':  deselect_action
          \ }


  let slist1 = forms#newSelectList(attrs1)
  let b1 = forms#newBorder({ 'body': slist1 })

  let attrs2 = { 'mode': 'multiple',
          \ 'choices': [
          \ ["one", 1],
          \ ["two", 2],
          \ ["three", 3],
          \ ["four", 4]
          \ ],
          \ 'on_selection_action':  select_action,
          \ 'on_deselection_action':  deselect_action
          \ }
  let slist2 = forms#newSelectList(attrs2)
  let b2 = forms#newBorder({ 'body': slist2 })

  let vpoly = forms#newVPoly({ 'children': [b1, b2], 'alignment': 'L' })
  let bg = forms#newBackground({ 'body': vpoly} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction


" selectlists different modes
map <Leader>g7 :call MakeFormg7()<CR>
function! MakeFormg7() 
call forms#log("MakeFormg7 TOP")
  let attrs11 = {'choices': [
          \ ["one", 1],
          \ ["two", 2],
          \ ["three", 3],
          \ ["four", 4]
          \ ]
          \ }

  let slist11 = forms#newSelectList(attrs11)
  let b11 = forms#newBorder({ 'body': slist11 })

  let attrs12 = { 'mode': 'multiple',
          \ 'choices': [
          \ ["one", 1],
          \ ["two", 2],
          \ ["three", 3],
          \ ["four", 4]
          \ ]
          \ }
  let slist12 = forms#newSelectList(attrs12)
  let b12 = forms#newBorder({ 'body': slist12 })

  let vpoly1 = forms#newVPoly({ 'children': [b11, b12], 'alignment': 'L' })

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
  let b21 = forms#newBorder({ 'body': slist21 })

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
  let b22 = forms#newBorder({ 'body': slist22 })

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
  let b31 = forms#newBorder({ 'body': slist31 })

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
  let b32 = forms#newBorder({ 'body': slist32 })

  let vpoly3 = forms#newVPoly({ 'children': [b31, b32], 'alignment': 'L' })


  let hpoly = forms#newHPoly({ 'children': [vpoly1, vpoly2, vpoly3], 'alignment': 'T' })
  let bg = forms#newBackground({ 'body': hpoly} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction

" menu and submenu
map <Leader>m0 :call MakeFormm0()<CR>
function! MakeFormm0() 

call forms#log("MakeFormm0 TOP")
  function! M0Action(...) dict
call forms#log("MOAction.execute: name=" . self.name)
  endfunction
  let action_one = forms#newAction({ 'execute': function("M0Action")})
  let action_one.name = 'ONE'

  let action_two = forms#newAction({ 'execute': function("M0Action")})
  let action_two.name = 'TWO'

  let group = forms#newButtonGroup({ 'member_type': 'forms#RadioButton'})

  let subattrs = {
        \ 'items' : [
        \ { 'type': 'label',
        \   'label': 'SubMenu'
        \ },
        \ { 'type': 'separator' },
        \ { 'type': 'button',
        \   'label': 'Button &One',
        \   'highlight': 0, 
        \   'action': action_one
        \ },
        \ { 'type': 'separator' },
        \ { 'type': 'button',
        \   'label': 'Button &Two',
        \   'highlight': 0, 
        \   'action': action_two
        \ }
        \ ]
        \ }
  let submenu = forms#newMenu(subattrs)

  let attrs = {
        \ 'items' : [
        \ { 'type': 'button',
        \   'label': 'Button &One',
        \   'highlight': 0, 
        \   'action': action_one
        \ },
        \ { 'type': 'separator' },
        \ { 'type': 'button',
        \   'label': 'Button &Two',
        \   'highlight': 0, 
        \   'action': action_two
        \ },
        \ { 'type': 'separator' },
        \ { 'type': 'checkbox',
        \   'tag': 'Stereo',
        \   'label': '&Stereo'
        \ },
        \ { 'type': 'checkbox',
        \   'tag': 'Woofer',
        \   'label': '&Woofer'
        \ },
        \ { 'type': 'separator' },
        \ { 'type': 'label',
        \   'label': 'Volume Control'
        \ },
        \ { 'type': 'radiobutton',
        \   'group': group,
        \   'tag': 'VolumeHigh',
        \   'label': '&High'
        \ },
        \ { 'type': 'radiobutton',
        \   'group': group,
        \   'tag': 'VolumeMedium',
        \   'selected': 1,
        \   'label': '&Medium'
        \ },
        \ { 'type': 'radiobutton',
        \   'group': group,
        \   'tag': 'VolumeLow',
        \   'label': '&Low'
        \ },
        \ { 'type': 'separator' },
        \ { 'type': 'menu',
        \   'menu': submenu,
        \   'label': 'Su&bMenu'
        \ }
        \ ]
        \ }
  let menu = forms#newMenu(attrs)

  let form = forms#newForm({'body': menu})
  call form.run()
endfunction

" long menu 
map <Leader>m1 :call MakeFormm1()<CR>
function! MakeFormm1() 

call forms#log("MakeFormt1 TOP")
  function! M0Action(...) dict
call forms#log("MOAction.execute: name=" . self.name)
  endfunction
  let action_one = forms#newAction({ 'execute': function("M0Action")})
  let action_one.name = 'ONE'

  let action_two = forms#newAction({ 'execute': function("M0Action")})
  let action_two.name = 'TWO'

  let group = forms#newButtonGroup({ 'member_type': 'forms#RadioButton'})

  let items = []

  call add(items, { 
        \ 'type': 'button',
        \ 'label': 'Button &One',
        \ 'highlight': 0, 
        \ 'action': action_one
        \ })
  call add(items, {'type': 'separator' })
  call add(items, { 
        \ 'type': 'button',
        \ 'label': 'Button &Two',
        \ 'highlight': 0, 
        \ 'action': action_two
        \ })
  call add(items, {'type': 'separator' })
  call add(items, { 
        \ 'type': 'checkbox',
        \ 'tag': 'Stereo',
        \ 'label': '&Stereo'
        \ })
  call add(items, { 
        \ 'type': 'checkbox',
        \ 'tag': 'Woofer',
        \ 'label': '&Woofer'
        \ })
  call add(items, {'type': 'separator' })
  call add(items, { 
        \ 'type': 'label',
        \ 'label': 'Volume Control'
        \ })
  call add(items, { 
        \ 'type': 'radiobutton',
        \ 'group': group,
        \ 'tag': 'VolumeHigh',
        \ 'label': '&High'
        \ })
  call add(items, { 
        \ 'type': 'radiobutton',
        \ 'group': group,
        \ 'tag': 'VolumeMedium',
        \ 'selected': 1,
        \ 'label': '&Medium'
        \ })
  call add(items, { 
        \ 'type': 'radiobutton',
        \ 'group': group,
        \ 'tag': 'VolumeLow',
        \ 'label': '&Low'
        \ })

  let cnt = 0
  while cnt < 15
    call add(items, { 
          \ 'type': 'button',
          \ 'label': 'Button '.cnt,
          \ 'action': action_one
          \ })

    let cnt += 1
  endwhile
  call add(items, { 
        \ 'type': 'button',
        \ 'label': '&Button '.cnt,
        \ 'action': action_one
        \ })

  let attrs = {'items' : items,
              \ 'size': 13
              \ }
  let menu = forms#newMenu(attrs)

  let form = forms#newForm({'body': menu})
  call form.run()
endfunction


" drop shadows
map <Leader>s0 :call MakeForms0()<CR>
function! MakeForms0() 
call forms#log("MakeForms0 TOP")

  " ul
  let t = forms#newText({'textlines': [
                                    \ "Upper Left", 
                                    \ "Drop Shadow" 
                                    \ ]})
  let box = forms#newBox({ 'body': t} )
  let ds = forms#newDropShadow({ 'body': box, 'corner': 'ul'} )
  let bul = forms#newBorder({ 'body': ds, 'size': 2} )

  " ur
  let t = forms#newText({'textlines': [
                                    \ "Upper Right", 
                                    \ "Drop Shadow" 
                                    \ ]})
  let box = forms#newBox({ 'body': t} )
  let ds = forms#newDropShadow({ 'body': box, 'corner': 'ur'} )
  let bur = forms#newBorder({ 'body': ds, 'size': 2} )

  let hpolyu = forms#newHPoly({ 'children': [bul, bur] })
  
  " ll
  let t = forms#newText({'textlines': [
                                    \ "Lower Left", 
                                    \ "Drop Shadow" 
                                    \ ]})
  let box = forms#newBox({ 'body': t} )
  let ds = forms#newDropShadow({ 'body': box, 'corner': 'll'} )
  let bll = forms#newBorder({ 'body': ds, 'size': 2} )

  " lr
  let t = forms#newText({'textlines': [
                                    \ "Lower Right", 
                                    \ "Drop Shadow" 
                                    \ ]})
  let box = forms#newBox({ 'body': t} )
  let ds = forms#newDropShadow({ 'body': box, 'corner': 'lr'} )
  let blr = forms#newBorder({ 'body': ds, 'size': 2} )

  let hpolyl = forms#newHPoly({ 'children': [bll, blr] })

  let vpoly = forms#newVPoly({ 'children': [hpolyu, hpolyl] })

  let bg = forms#newBackground({ 'body': vpoly} )

  let form = forms#newForm({'body': bg})
  call form.run()
endfunction


" frame
map <Leader>s1 :call MakeForms1()<CR>
function! MakeForms1() 
call forms#log("MakeForms1 TOP")

  " ul
  let t = forms#newText({'textlines': [
                                    \ "Upper Left", 
                                    \ "Frame"]})
  let box = forms#newBox({ 'body': t} )
  let ds = forms#newFrame({ 'body': box, 
                                \ 'corner': 'ul'} )
  let bul = forms#newBorder({ 'body': ds, 'size': 1} )

  " ur
  let t = forms#newText({'textlines': [
                                    \ "Upper Right", 
                                    \ "Frame" ]})
  let box = forms#newBox({ 'body': t} )
  let ds = forms#newFrame({ 'body': box, 
                                \ 'corner': 'ur'} )
  let bur = forms#newBorder({ 'body': ds, 'size': 1} )

  let hpolyu = forms#newHPoly({ 'children': [bul, bur] })
  
  " ll
  let t = forms#newText({'textlines': [
                                    \ "Lower Left", 
                                    \ "Frame" ]})
  let box = forms#newBox({ 'body': t} )
  let ds = forms#newFrame({ 'body': box, 
                                \ 'corner': 'll'} )
  let bll = forms#newBorder({ 'body': ds, 'size': 1} )

  " lr
  let t = forms#newText({'textlines': [
                                    \ "Lower Right", 
                                    \ "Frame" ]})
  let box = forms#newBox({ 'body': t} )
  let ds = forms#newFrame({ 'body': box, 
                                \ 'corner': 'lr'} )
  let blr = forms#newBorder({ 'body': ds, 'size': 1} )

  let hpolyl = forms#newHPoly({ 'children': [bll, blr] })

  let vpoly = forms#newVPoly({ 'children': [hpolyu, hpolyl] })

  let bg = forms#newBackground({ 'body': vpoly} )

  let form = forms#newForm({'body': bg})
  call form.run()
endfunction


" popdownlist
map <Leader>s2 :call MakeForms2()<CR>
function! MakeForms2() 
call forms#log("MakeForms2 TOP")
  let attrs = {
        \ 'choices' : [
        \   ["ONE", 1],
        \   ["TWO", 2],
        \   ["THREE", 3]
        \ ]
        \ }
  let popdownlist = forms#newPopDownList(attrs)

  let b = forms#newBorder({ 'body': popdownlist })
  let bg = forms#newBackground({ 'body': b} )
  let form = forms#newForm({'body': bg })
  call form.run()
endfunction


" slider
map <Leader>s3 :call MakeForms3()<CR>
function! MakeForms3() 
call forms#log("MakeForms3 TOP")

  function! S2HSliderAction(...) dict
    let value = "".a:1
call forms#log("S2HSliderAction.execute: value=" . value)
    call self.editor.setText(value)
  endfunction

  function! S2EditorAction(...) dict
    let value = a:1 + 0
" call forms#log("S2EditorAction.execute: value=" . value)
    try 
      call self.hslider.setRangeValue(value)
    catch /.*/
" call forms#log("S2EditorAction.execute: exception=" . v:exception)
    endtry
  endfunction

  let hsa1 = forms#newAction({ 'execute': function("S2HSliderAction")})
  let ea1 = forms#newAction({ 'execute': function("S2EditorAction")})
  let attrs = {
            \ 'size' : 2,
            \ 'on_move_action' : hsa1,
            \ 'range' : [0,10]
            \ }
  let hs1 = forms#newHSlider(attrs)
  let ea1.hslider = hs1
  let b1 = forms#newBox({ 'body': hs1} )
  let sp1 = forms#newHSpace({ 'size': 1} )
  let e1 = forms#newFixedLengthField({
                                  \ 'size': 2, 
                                  \ 'on_selection_action' : ea1,
                                  \ 'init_text': '0'})
  let hsa1.editor = e1
  let hpoly1 = forms#newHPoly({ 'children': [b1, sp1, e1], 'alignment': 'C' })

  let hsa2 = forms#newAction({ 'execute': function("S2HSliderAction")})
  let ea2 = forms#newAction({ 'execute': function("S2EditorAction")})
  let attrs = {
            \ 'size' : 2,
            \ 'resolution' : 2,
            \ 'on_move_action' : hsa2,
            \ 'range' : [0,10]
            \ }
  let hs2 = forms#newHSlider(attrs)
  let ea2.hslider = hs2
  let b2 = forms#newBox({ 'body': hs2} )
  let sp2 = forms#newHSpace({ 'size': 1} )
  let e2 = forms#newFixedLengthField({
                                  \ 'size': 2, 
                                  \ 'on_selection_action' : ea2,
                                  \ 'init_text': '0'})
  let hsa2.editor = e2
  let hpoly2 = forms#newHPoly({ 'children': [b2, sp2, e2], 'alignment': 'C' })

  let hsa3 = forms#newAction({ 'execute': function("S2HSliderAction")})
  let ea3 = forms#newAction({ 'execute': function("S2EditorAction")})
  let attrs = {
            \ 'size' : 3,
            \ 'resolution' : 2,
            \ 'on_move_action' : hsa3,
            \ 'range' : [0,10]
            \ }
  let hs3 = forms#newHSlider(attrs)
  let ea3.hslider = hs3
  let b3 = forms#newBox({ 'body': hs3} )
  let sp3 = forms#newHSpace({ 'size': 1} )
  let e3 = forms#newFixedLengthField({
                                  \ 'size': 2, 
                                  \ 'on_selection_action' : ea3,
                                  \ 'init_text': '0'})
  let hsa3.editor = e3
  let hpoly3 = forms#newHPoly({ 'children': [b3, sp3, e3], 'alignment': 'C' })

  let hsa4 = forms#newAction({ 'execute': function("S2HSliderAction")})
  let ea4 = forms#newAction({ 'execute': function("S2EditorAction")})
  let attrs = {
            \ 'size' : 5,
            \ 'resolution' : 2,
            \ 'on_move_action' : hsa4,
            \ 'range' : [0,10]
            \ }
  let hs4 = forms#newHSlider(attrs)
  let ea4.hslider = hs4
  let b4 = forms#newBox({ 'body': hs4} )
  let sp4 = forms#newHSpace({ 'size': 1} )
  let e4 = forms#newFixedLengthField({
                                  \ 'size': 2, 
                                  \ 'on_selection_action' : ea4,
                                  \ 'init_text': '0'})
  let hsa4.editor = e4
  let hpoly4 = forms#newHPoly({ 'children': [b4, sp4, e4], 'alignment': 'C' })

  let hsa5 = forms#newAction({ 'execute': function("S2HSliderAction")})
  let ea5 = forms#newAction({ 'execute': function("S2EditorAction")})
  let attrs = {
            \ 'size' : 5,
            \ 'resolution' : 3,
            \ 'on_move_action' : hsa5,
            \ 'range' : [0,20]
            \ }
  let hs5 = forms#newHSlider(attrs)
  let ea5.hslider = hs5
  let b5 = forms#newBox({ 'body': hs5} )
  let sp5 = forms#newHSpace({ 'size': 1} )
  let e5 = forms#newFixedLengthField({
                                  \ 'size': 2, 
                                  \ 'on_selection_action' : ea5,
                                  \ 'init_text': '0'})
  let hsa5.editor = e5
  let hpoly5 = forms#newHPoly({ 'children': [b5, sp5, e5], 'alignment': 'C' })

  let hsa6 = forms#newAction({ 'execute': function("S2HSliderAction")})
  let ea6 = forms#newAction({ 'execute': function("S2EditorAction")})
  let attrs = {
            \ 'size' : 5,
            \ 'resolution' : 4,
            \ 'on_move_action' : hsa6,
            \ 'range' : [0,32]
            \ }
  let hs6 = forms#newHSlider(attrs)
  let ea6.hslider = hs6
  let b6 = forms#newBox({ 'body': hs6} )
  let sp6 = forms#newHSpace({ 'size': 1} )
  let e6 = forms#newFixedLengthField({
                                  \ 'size': 2, 
                                  \ 'on_selection_action' : ea6,
                                  \ 'init_text': '0'})
  let hsa6.editor = e6
  let hpoly6 = forms#newHPoly({ 'children': [b6, sp6, e6], 'alignment': 'C' })

  let vpolyh = forms#newVPoly({ 'children': [
                                  \ hpoly1, 
                                  \ hpoly2, 
                                  \ hpoly3, 
                                  \ hpoly4,
                                  \ hpoly5,
                                  \ hpoly6
                                  \ ] })

  "....................

  let vsa1 = forms#newAction({ 'execute': function("S2HSliderAction")})
  let vea1 = forms#newAction({ 'execute': function("S2EditorAction")})
  let attrs = {
            \ 'size' : 2,
            \ 'on_move_action' : vsa1,
            \ 'range' : [0,10]
            \ }
  let vs1 = forms#newVSlider(attrs)
  let vea1.hslider = vs1
  let b1 = forms#newBox({ 'body': vs1} )
  let sp1 = forms#newVSpace({ 'size': 1} )
  let e1 = forms#newFixedLengthField({
                                  \ 'size': 2, 
                                  \ 'on_selection_action' : vea1,
                                  \ 'init_text': '0'})
  let vsa1.editor = e1
  let vpoly1 = forms#newVPoly({ 'children': [b1, sp1, e1], 'alignment': 'C' })

  let vsa2 = forms#newAction({ 'execute': function("S2HSliderAction")})
  let vea2 = forms#newAction({ 'execute': function("S2EditorAction")})
  let attrs = {
            \ 'size' : 2,
            \ 'resolution' : 2,
            \ 'on_move_action' : vsa2,
            \ 'range' : [0,10]
            \ }
  let vs2 = forms#newVSlider(attrs)
  let vea2.hslider = vs2
  let b2 = forms#newBox({ 'body': vs2})
  let sp2 = forms#newVSpace({ 'size': 1})
  let e2 = forms#newFixedLengthField({
                                  \ 'size': 2, 
                                  \ 'on_selection_action' : vea2,
                                  \ 'init_text': '0'})
  let vsa2.editor = e2
  let vpoly2 = forms#newVPoly({ 'children': [b2, sp2, e2], 'alignment': 'C' })

  let vsa3 = forms#newAction({ 'execute': function("S2HSliderAction")})
  let vea3 = forms#newAction({ 'execute': function("S2EditorAction")})
  let attrs = {
            \ 'size' : 3,
            \ 'resolution' : 2,
            \ 'on_move_action' : vsa3,
            \ 'range' : [0,10]
            \ }
  let vs3 = forms#newVSlider(attrs)
  let vea3.hslider = vs3
  let b3 = forms#newBox({ 'body': vs3})
  let sp3 = forms#newVSpace({ 'size': 1})
  let e3 = forms#newFixedLengthField({
                                  \ 'size': 2, 
                                  \ 'on_selection_action' : vea3,
                                  \ 'init_text': '0'})
  let vsa3.editor = e3
  let vpoly3 = forms#newVPoly({ 'children': [b3, sp3, e3], 'alignment': 'C' })

  let vsa4 = forms#newAction({ 'execute': function("S2HSliderAction")})
  let vea4 = forms#newAction({ 'execute': function("S2EditorAction")})
  let attrs = {
            \ 'size' : 5,
            \ 'resolution' : 2,
            \ 'on_move_action' : vsa4,
            \ 'range' : [0,10]
            \ }
  let vs4 = forms#newVSlider(attrs)
  let vea4.hslider = vs4
  let b4 = forms#newBox({ 'body': vs4})
  let sp4 = forms#newVSpace({ 'size': 1})
  let e4 = forms#newFixedLengthField({
                                  \ 'size': 2, 
                                  \ 'on_selection_action' : vea4,
                                  \ 'init_text': '0'})
  let vsa4.editor = e4
  let vpoly4 = forms#newVPoly({ 'children': [b4, sp4, e4], 'alignment': 'C' })

  let vsa5 = forms#newAction({ 'execute': function("S2HSliderAction")})
  let vea5 = forms#newAction({ 'execute': function("S2EditorAction")})
  let attrs = {
            \ 'size' : 5,
            \ 'resolution' : 3,
            \ 'on_move_action' : vsa5,
            \ 'range' : [0,20]
            \ }
  let vs5 = forms#newVSlider(attrs)
  let vea5.hslider = vs5
  let b5 = forms#newBox({ 'body': vs5})
  let sp5 = forms#newVSpace({ 'size': 1})
  let e5 = forms#newFixedLengthField({
                                  \ 'size': 2, 
                                  \ 'on_selection_action' : vea5,
                                  \ 'init_text': '0'})
  let vsa5.editor = e5
  let vpoly5 = forms#newVPoly({ 'children': [b5, sp5, e5], 'alignment': 'C' })

  let vsa6 = forms#newAction({ 'execute': function("S2HSliderAction")})
  let vea6 = forms#newAction({ 'execute': function("S2EditorAction")})
  let attrs = {
            \ 'size' : 5,
            \ 'resolution' : 4,
            \ 'on_move_action' : vsa6,
            \ 'range' : [0,32]
            \ }
  let vs6 = forms#newVSlider(attrs)
  let vea6.hslider = vs6
  let b6 = forms#newBox({ 'body': vs6})
  let sp6 = forms#newVSpace({ 'size': 1})
  let e6 = forms#newFixedLengthField({
                                  \ 'size': 2, 
                                  \ 'on_selection_action' : vea6,
                                  \ 'init_text': '0'})
  let vsa6.editor = e6
  let vpoly6 = forms#newVPoly({ 'children': [b6, sp6, e6], 'alignment': 'C' })

  "....................
  let hpoly = forms#newHPoly({ 'children': [
                                      \ vpolyh, 
                                      \ vpoly1, 
                                      \ vpoly2, 
                                      \ vpoly3, 
                                      \ vpoly4, 
                                      \ vpoly5, 
                                      \ vpoly6], 
                                      \ 'alignment': 'C' })

  let b = forms#newBorder({ 'body': hpoly })
  let bg = forms#newBackground({ 'body': b} )
  let form = forms#newForm({'body': bg })
  call form.run()
endfunction


"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


map <Leader>s4 :call ColorChooser(0)<CR>
map <Leader>s5 :call ColorChooser(1)<CR>
"  '0.25:1',      0.75:0,0
"  '0.5:1',       0.5:0.0
"  '0.666:0.666', 0.33: -0.33
"  '0.666:0.333', 0.33: -0.66
if ! exists("g:tint1Init")
  let g:tint1Init = 0.75
endif
if ! exists("g:shade1Init")
  let g:shade1Init = 0.0
endif
if ! exists("g:tint2Init")
  let g:tint2Init = 0.50
endif
if ! exists("g:shade2Init")
  let g:shade2Init = 0.0
endif
if ! exists("g:tint3Init")
  let g:tint3Init = 0.0
endif
if ! exists("g:shade3Init")
  let g:shade3Init =  0.33
endif
if ! exists("g:tint4Init")
  let g:tint4Init = 0.0
endif
if ! exists("g:shade4Init")
  let g:shade4Init =  0.66
endif

" Double Complimentary
if ! exists("g:doubleComplimentaryShiftInit")
  let g:doubleComplimentaryShiftInit =  30.0/360
endif
" Accented Analogic
if ! exists("g:accentedAnalogicShiftInit")
  let g:accentedAnalogicShiftInit =  30.0/360
endif
" Analogic
if ! exists("g:analogicShiftInit")
  let g:analogicShiftInit =  30.0/360
endif
" Split Complimentary
if ! exists("g:splitComplimentaryShiftInit")
  let g:splitComplimentaryShiftInit =  30.0/360
endif

function! ColorChooser(with_pallet) 
" call forms#log("ColorChooser TOP")

  "........................................
  " Slider to Info
  "........................................
  function! CCSlider2InfoAction(...) dict
" call forms#log("CCSlider2InfoAction.execute: TOP")
    let rtxt = self.reditor.getText()
    let gtxt = self.geditor.getText()
    let btxt = self.beditor.getText()

    let rn = str2nr(rtxt, 10)
    let gn = str2nr(gtxt, 10)
    let bn = str2nr(btxt, 10)
" call forms#log("CCSlider2InfoAction: read   time=". reltimestr(reltime(start)))

    " let rhtxt = printf('%02x',rn)
    " let ghtxt = printf('%02x',gn)
    " let bhtxt = printf('%02x',bn)
    " let rgbtxt = rhtxt.ghtxt.bhtxt
    let rgbtxt = printf('%02x%02x%02x',rn,gn,bn)
" call forms#log("CCSlider2InfoAction.execute: rgbtxt=".rgbtxt)
    call self.rgbeditor.setText(rgbtxt)

    let n = g:ColorUtil().ConvertRGB2IntNew(rn,gn,bn)
" call forms#log("CCSlider2InfoAction.execute: n=".n)
    call self.neditor.setText(n)

    let hiname = 'XXHi'
    execute ":hi ".hiname." ctermbg=".n." guibg=#".rgbtxt
    if exists("self.palletaction")
      call self.palletaction.execute(rn, gn, bn)
    endif

  endfunction
  let slider2infoa = forms#newAction({ 'execute': function("CCSlider2InfoAction")})

  "........................................
  " Info RGB editor to others
  "........................................
  function! CCRGBEditor2OthersAction(...) dict
    let rgbtxt = "".a:1
" call forms#log("CCRGBEditor2OthersAction.execute: rgbtxt=".rgbtxt)
    if len(rgbtxt) != 6
" call forms#log("CCRGBEditor2OthersAction.execute: bad length=".len(rgbtxt))
      return
    endif
    let r = rgbtxt[0:1]
    let g = rgbtxt[2:3]
    let b = rgbtxt[4:5]
    let rn = str2nr(r, 16)
    let gn = str2nr(g, 16)
    let bn = str2nr(b, 16)
    if printf('%02x',rn) != r
" call forms#log("CCRGBEditor2OthersAction.execute: bad r=".r)
      return
    endif
    if printf('%02x',gn) != g
" call forms#log("CCRGBEditor2OthersAction.execute: bad g=".g)
      return
    endif
    if printf('%02x',bn) != b
" call forms#log("CCRGBEditor2OthersAction.execute: bad b=".b)
      return
    endif

    let n = g:ColorUtil().ConvertRGB2IntNew(rn,gn,bn)
" call forms#log("CCSlider2InfoAction.execute: n=".n)
    call self.neditor.setText(n)

    let hiname = 'XXHi'
    execute ":hi ".hiname." ctermbg=".n." guibg=#".rgbtxt
    if exists("self.palletaction")
      call self.palletaction.execute(rn, gn, bn)
    endif

    try 
      call self.rhs.setRangeValue(rn)
    catch /.*/
" call forms#log("CCEditorAction.execute: exception=" . v:exception)
    endtry
    try 
      call self.ghs.setRangeValue(gn)
    catch /.*/
" call forms#log("CCEditorAction.execute: exception=" . v:exception)
    endtry
    try 
      call self.bhs.setRangeValue(bn)
    catch /.*/
" call forms#log("CCEditorAction.execute: exception=" . v:exception)
    endtry

    call self.reditor.setText(rn)
    call self.geditor.setText(gn)
    call self.beditor.setText(bn)
  endfunction
  let rgbeditor2others = forms#newAction({ 'execute': function("CCRGBEditor2OthersAction")})

  "........................................
  " Info N editor to others
  "........................................
  function! CCNEditor2OthersAction(...) dict
    let n = "".a:1
" call forms#log("CCNEditor2OthersAction.execute: n=".n)
    let rgbtxt = g:ColorUtil().ConvertInt2RGB(n)
" call forms#log("CCNEditor2OthersAction.execute: rgbtxt=".rgbtxt)

    call self.rgbeditor.setText(rgbtxt)

    let hiname = 'XXHi'
    execute ":hi ".hiname." ctermbg=".n." guibg=#".rgbtxt

    let r = rgbtxt[0:1]
    let g = rgbtxt[2:3]
    let b = rgbtxt[4:5]
    let rn = str2nr(r, 16)
    let gn = str2nr(g, 16)
    let bn = str2nr(b, 16)

    if exists("self.palletaction")
      call self.palletaction.execute(rn, gn, bn)
    endif

    try 
      call self.rhs.setRangeValue(rn)
    catch /.*/
" call forms#log("CCEditorAction.execute: exception=" . v:exception)
    endtry
    try 
      call self.ghs.setRangeValue(gn)
    catch /.*/
" call forms#log("CCEditorAction.execute: exception=" . v:exception)
    endtry
    try 
      call self.bhs.setRangeValue(bn)
    catch /.*/
" call forms#log("CCEditorAction.execute: exception=" . v:exception)
    endtry

    call self.reditor.setText(rn)
    call self.geditor.setText(gn)
    call self.beditor.setText(bn)
  endfunction
  let neditor2others = forms#newAction({ 'execute': function("CCNEditor2OthersAction")})
  
  "........................................
  " Slider side
  "........................................
  function! CCSliderAction(...) dict
    let value = "".a:1
" call forms#log("CCSliderAction.execute: value=" . value)
    call self.editor.setText(value)
    call self.slider2infoa.execute()
  endfunction

  function! CCEditorAction(...) dict
    let value = a:1 + 0
" call forms#log("CCEditorAction.execute: value=" . value)
    try 
      call self.hslider.setRangeValue(value)
    catch /.*/
" call forms#log("CCEditorAction.execute: exception=" . v:exception)
    endtry
  endfunction

  "----

  :hi CCRedHi    cterm=NONE ctermbg=196 guibg=#ff0000
  :hi CCGreenHi  cterm=NONE ctermbg=46  guibg=#00ff00
  :hi CCBlueHi   cterm=NONE ctermbg=21  guibg=#0000ff

  "----
  let rhsa = forms#newAction({ 'execute': function("CCSliderAction")})
  let rhsa.slider2infoa = slider2infoa
  let rea = forms#newAction({ 'execute': function("CCEditorAction")})

  let rlabel = forms#newLabel({'text': "R"})
  let rsp = forms#newVLine({ 'size': 3})
  function! rsp.draw(allocation) dict
" call forms#log("rsp.draw" .  string(a:allocation))
    call GlyphHilight(self, "CCRedHi", a:allocation)

    let p = self._prototype
    call call(p.draw, [a:allocation], self)
  endfunction
  let attrs = {
            \ 'size' : 32,
            \ 'tag' : 'red_slider',
            \ 'resolution' : 4,
            \ 'on_move_action' : rhsa,
            \ 'range' : [0,255]
            \ }
  let rhs = forms#newHSlider(attrs)
  let rea.hslider = rhs
  let rgbeditor2others.rhs = rhs
  let neditor2others.rhs = rhs
  let rhsb = forms#newBox({ 'body': rhs} )
  let hsp = forms#newHSpace({ 'size': 1} )
  let reditor = forms#newFixedLengthField({
                                  \ 'size': 3, 
                                  \ 'tag' : 'red_editor',
                                  \ 'on_selection_action' : rea,
                                  \ 'init_text': '0'})
  let slider2infoa.reditor = reditor
  let rgbeditor2others.reditor = reditor
  let neditor2others.reditor = reditor
  let rhsa.editor = reditor 
  let reditorbox = forms#newBox({ 'body': reditor} )
  let rhpoly = forms#newHPoly({ 'children': [
                                  \ rlabel, 
                                  \ rsp, 
                                  \ rhsb, 
                                  \ hsp, 
                                  \ reditorbox
                                  \ ], 
                                  \ 'alignment': 'C' })

  "----
  let ghsa = forms#newAction({ 'execute': function("CCSliderAction")})
  let ghsa.slider2infoa = slider2infoa
  let gea = forms#newAction({ 'execute': function("CCEditorAction")})

  let glabel = forms#newLabel({'text': "G"})
  let gsp = forms#newVLine({ 'size': 3})
  function! gsp.draw(allocation) dict
    call GlyphHilight(self, "CCGreenHi", a:allocation)
    let p = self._prototype
    call call(p.draw, [a:allocation], self)
  endfunction
  let attrs = {
            \ 'size' : 32,
            \ 'tag' : 'green_slider',
            \ 'resolution' : 4,
            \ 'on_move_action' : ghsa,
            \ 'range' : [0,255]
            \ }
  let ghs = forms#newHSlider(attrs)
  let rgbeditor2others.ghs = ghs
  let neditor2others.ghs = ghs
  let gea.hslider = ghs
  let ghsb = forms#newBox({ 'body': ghs} )
  let hsp = forms#newHSpace({ 'size': 1} )
  let geditor = forms#newFixedLengthField({
                                  \ 'size': 3, 
                                  \ 'tag' : 'green_editor',
                                  \ 'on_selection_action' : gea,
                                  \ 'init_text': '0'})
  let slider2infoa.geditor = geditor
  let rgbeditor2others.geditor = geditor
  let neditor2others.geditor = geditor
  let ghsa.editor = geditor 
  let geditorbox = forms#newBox({ 'body': geditor} )
  let ghpoly = forms#newHPoly({ 'children': [
                                  \ glabel, 
                                  \ gsp, 
                                  \ ghsb, 
                                  \ hsp, 
                                  \ geditorbox
                                  \ ], 
                                  \ 'alignment': 'C' })

  "----
  let bhsa = forms#newAction({ 'execute': function("CCSliderAction")})
  let bhsa.slider2infoa = slider2infoa
  let bea = forms#newAction({ 'execute': function("CCEditorAction")})

  let blabel = forms#newLabel({'text': "B"})
  let bsp = forms#newVLine({ 'size': 3})
  function! bsp.draw(allocation) dict
    call GlyphHilight(self, "CCBlueHi", a:allocation)
    let p = self._prototype
    call call(p.draw, [a:allocation], self)
  endfunction
  let attrs = {
            \ 'size' : 32,
            \ 'tag' : 'blue_slider',
            \ 'resolution' : 4,
            \ 'on_move_action' : bhsa,
            \ 'range' : [0,255]
            \ }
  let bhs = forms#newHSlider(attrs)
  let rgbeditor2others.bhs = bhs
  let neditor2others.bhs = bhs
  let bea.hslider = bhs
  let bhsb = forms#newBox({ 'body': bhs} )
  let hsp = forms#newHSpace({ 'size': 1} )
  let beditor = forms#newFixedLengthField({
                                  \ 'size': 3, 
                                  \ 'tag' : 'blue_editor',
                                  \ 'on_selection_action' : bea,
                                  \ 'init_text': '0'})
  let slider2infoa.beditor = beditor
  let rgbeditor2others.beditor = beditor
  let neditor2others.beditor = beditor
  let bhsa.editor = beditor 
  let beditorbox = forms#newBox({ 'body': beditor} )
  let bhpoly = forms#newHPoly({ 'children': [
                                  \ blabel, 
                                  \ bsp, 
                                  \ bhsb, 
                                  \ hsp, 
                                  \ beditorbox
                                  \ ], 
                                  \ 'alignment': 'C' })


  let slidersVPoly = forms#newVPoly({ 'children': [
                                      \ rhpoly, 
                                      \ ghpoly, 
                                      \ bhpoly], 
                                      \ 'alignment': 'L' })
  "....................
  
  let attrs = {'size': 1}
  let hspace = forms#newHSpace(attrs)

  "....................
  " Info side
  "....................
  let neditor = forms#newFixedLengthField({
                                  \ 'size': 3, 
                                  \ 'tag' : 'number_editor',
                                  \ 'on_selection_action': neditor2others,
                                  \ 'init_text': '0'})
  let slider2infoa.neditor = neditor
  let rgbeditor2others.neditor = neditor
  let neditorb = forms#newBox({ 'body': neditor} )

  let attrs = {'height': 1, 'width': 6}
  let colorspace = forms#newArea(attrs)
  let slider2infoa.colorspace = colorspace
  let neditor2others.colorspace = colorspace
  let rgbeditor2others.colorspace = colorspace

  function! colorspace.draw(allocation) dict
" call forms#log("colorspace.draw")
    " TODO: This has to be done once, registering group name with allocation
    " Changing the attributes of group does not require calling this again.
    if exists("self.__hiname")
      call GlyphHilight(self, self.__hiname, a:allocation)
    endif
    let p = self._prototype
    call call(p.draw, [a:allocation], self)
  endfunction
if 0
  function! colorspace.setHi(hiname) dict
    if exists("self.__hiname")
      if self.__hiname != a:hiname
        let self.__hiname = a:hiname
        call forms#ViewerRedrawListAdd(self) 
      endif
    else
        let self.__hiname = a:hiname
        call forms#ViewerRedrawListAdd(self) 
    endif
  endfunction
endif
  let hiname = 'XXHi'
  execute ":hi ".hiname." ctermbg=16 guibg=#000000"
  let colorspace.__hiname = hiname

  let colorspaceb = forms#newBox({ 'body': colorspace} )

  let rgbeditor = forms#newFixedLengthField({
                                  \ 'size': 6, 
                                  \ 'tag' : 'rgb_editor',
                                  \ 'on_selection_action': rgbeditor2others,
                                  \ 'init_text': '0'})
  let slider2infoa.rgbeditor = rgbeditor
  let neditor2others.rgbeditor = rgbeditor
  let rgbeditorb = forms#newBox({ 'body': rgbeditor} )

  let infoVPoly = forms#newVPoly({ 'children': [
                                      \ neditorb, 
                                      \ colorspaceb, 
                                      \ rgbeditorb], 
                                      \ 'alignment': 'L' })

  "....................

  let hpoly = forms#newHPoly({ 'children': [
                                      \ slidersVPoly, 
                                      \ hspace, 
                                      \ infoVPoly], 
                                      \ 'alignment': 'C' })
  
  "....................
  let cancellabel = forms#newLabel({'text': "Cancel"})
  let cancelbutton = forms#newButton({
                              \ 'tag': 'cancel', 
                              \ 'body': cancellabel, 
                              \ 'action': g:forms#cancelAction})
  let hspace = forms#newHSpace({'size': 1})
  let label = forms#newLabel({'text': "Submit"})
  let submitbutton = forms#newButton({
                              \ 'tag': 'submit', 
                              \ 'body': label, 
                              \ 'action': g:forms#submitAction})
  let buttonhpoly = forms#newHPoly({ 'children': [
                                      \ cancelbutton, 
                                      \ hspace, 
                                      \ submitbutton], 
                                      \ 'alignment': 'T' })
  "....................
  if ! a:with_pallet
    let title = forms#newLabel({'text': "Color Choose"})
    let topvpoly = forms#newVPoly({ 'children': [
                                        \ title, 
                                        \ hpoly, 
                                        \ buttonhpoly], 
                                        \ 'mode': 'light',
                                        \ 'alignments': [[0,'C']],
                                        \ 'alignment': 'R' })
  else
    function! CCConvertInitText(txt)
      if type(a:txt) == g:self#STRING_TYPE
        return a:txt
      elseif type(a:txt) == g:self#NUMBER_TYPE
        return "".a:txt
      elseif type(a:txt) == g:self#FLOAT_TYPE
        return printf('%4.2f', a:txt)
      else
        throw "Bad initial value for Tint or Shade: " . string(a:txt)
      endif
    endfunction

    let s:tint1Init = CCConvertInitText(g:tint1Init)
    let s:shade1Init = CCConvertInitText(g:shade1Init)
    let s:tint2Init = CCConvertInitText(g:tint2Init)
    let s:shade2Init = CCConvertInitText(g:shade2Init)
    let s:tint3Init = CCConvertInitText(g:tint3Init)
    let s:shade3Init = CCConvertInitText(g:shade3Init)
    let s:tint4Init = CCConvertInitText(g:tint4Init)
    let s:shade4Init = CCConvertInitText(g:shade4Init)


    "....................
    function! CCSchemeAction(...) dict
      let pos = self.popdownlist.__pos
" call forms#log("CCSchemeAction.execute: " . pos)
      call self.deck.setCard(pos)

      let rgbtxt = self.rgbeditor.getText()
      let r = rgbtxt[0:1]
      let g = rgbtxt[2:3]
      let b = rgbtxt[4:5]
      let rn = str2nr(r, 16)
      let gn = str2nr(g, 16)
      let bn = str2nr(b, 16)
      call self.palletaction.execute(rn, gn, bn)
    endfunction
    let comboboxaction = forms#newAction({ 'execute': function("CCSchemeAction")})
    let comboboxaction.rgbeditor = rgbeditor

    let attrs = {
        \ 'choices' : [
        \   ["Monochromatic", 0],
        \   ["Complimentary", 1],
        \   ["Split Complimentary", 2],
        \   ["Analogic", 3],
        \   ["Accented Analogic", 4],
        \   ["Triadic", 5],
        \   ["Double Complimentary", 6]
        \ ],
        \ 'on_selection_action': comboboxaction
        \ }
    let popdownlist = forms#newPopDownList(attrs)
    let comboboxaction.popdownlist = popdownlist
    "....................

    " called by rgbeditor, neditor, and slider to info actions
    function! CCDeckAction(...) dict
" call forms#log("CCDeckAction.execute: ")
      let rn = a:1
      let gn = a:2
      let bn = a:3
      let pos = self.deck.getCard()
" call forms#log("CCDeckAction.execute: pos=".pos)
      call self.palletactions[pos].execute(rn, gn, bn)
    endfunction
    let deckaction = forms#newAction({ 'execute': function("CCDeckAction")})
    let deckaction.palletactions = []
    let neditor2others.palletaction = deckaction
    let rgbeditor2others.palletaction = deckaction
    let slider2infoa.palletaction = deckaction
    let comboboxaction.palletaction = deckaction

    " called by tint and shade editors
    function! CCAdjustersAction(...) dict
" call forms#log("CCAdjustersAction.execute: ")
      let pos = self.deck.getCard()
" call forms#log("CCAdjustersAction.execute: pos=".pos)
      let rgbtxt = self.rgbeditor.getText()
      let r = rgbtxt[0:1]
      let g = rgbtxt[2:3]
      let b = rgbtxt[4:5]
      let rn = str2nr(r, 16)
      let gn = str2nr(g, 16)
      let bn = str2nr(b, 16)
      call self.palletactions[pos].execute(rn, gn, bn)
    endfunction
    let adjusteraction = forms#newAction({ 'execute': function("CCAdjustersAction")})
    let adjusteraction.rgbeditor = rgbeditor
    let adjusteraction.palletactions = []

    
    let hspace = forms#newHLine({'size': 6})
    let tintlabel = forms#newLabel({'text': "Tint"})
    let shadelabel = forms#newLabel({'text': "Shade"})

    " One
    "  '0.25:1',      0.75:0,0
    let label1 = forms#newLabel({'text': "One"})
    let tint1editor = forms#newFixedLengthField({
                                  \ 'size': 5, 
                                  \ 'tag' : 'tint1_editor',
                                  \ 'on_selection_action': adjusteraction,
                                  \ 'init_text': s:tint1Init})
    let shade1editor = forms#newFixedLengthField({
                                  \ 'size': 5, 
                                  \ 'tag' : 'shade1_editor',
                                  \ 'on_selection_action': adjusteraction,
                                  \ 'init_text': s:shade1Init})
    " Two
    "  '0.5:1',       0.5:0.0
    let label2 = forms#newLabel({'text': "Two"})
    let tint2editor = forms#newFixedLengthField({
                                  \ 'size': 5, 
                                  \ 'tag' : 'tint2_editor',
                                  \ 'on_selection_action': adjusteraction,
                                  \ 'init_text': s:tint2Init})
    let shade2editor = forms#newFixedLengthField({
                                  \ 'size': 5, 
                                  \ 'tag' : 'shade2_editor',
                                  \ 'on_selection_action': adjusteraction,
                                  \ 'init_text': s:shade2Init})
    " Three
    "  '0.666:0.666', 0.33: -0.33
    let label3 = forms#newLabel({'text': "Three"})
    let tint3editor = forms#newFixedLengthField({
                                  \ 'size': 5, 
                                  \ 'tag' : 'tint3_editor',
                                  \ 'on_selection_action': adjusteraction,
                                  \ 'init_text': s:tint3Init})
    let shade3editor = forms#newFixedLengthField({
                                  \ 'size': 5, 
                                  \ 'tag' : 'shade3_editor',
                                  \ 'on_selection_action': adjusteraction,
                                  \ 'init_text': s:shade3Init})
    
    " Four
    "  '0.666:0.333', 0.33: -0.66
    let label4 = forms#newLabel({'text': "Four"})
    let tint4editor = forms#newFixedLengthField({
                                  \ 'size': 5, 
                                  \ 'tag' : 'tint4_editor',
                                  \ 'on_selection_action': adjusteraction,
                                  \ 'init_text': s:tint4Init})
    let shade4editor = forms#newFixedLengthField({
                                  \ 'size': 5, 
                                  \ 'tag' : 'shade4_editor',
                                  \ 'on_selection_action': adjusteraction,
                                  \ 'init_text': s:shade4Init})

    let adjustergrid = forms#newGrid({ 
                          \ 'nos_rows': 5, 
                          \ 'nos_columns': 3, 
                          \ 'halignment': 'L', 
                          \ 'valignment': 'T', 
                          \ 'data': [
                            \ [0, 0, hspace],
                            \ [0, 1, tintlabel],
                            \ [0, 2, shadelabel],
                            \ [1, 0, label1],
                            \ [1, 1, tint1editor],
                            \ [1, 2, shade1editor],
                            \ [2, 0, label2],
                            \ [2, 1, tint2editor],
                            \ [2, 2, shade2editor],
                            \ [3, 0, label3],
                            \ [3, 1, tint3editor],
                            \ [3, 2, shade3editor],
                            \ [4, 0, label4],
                            \ [4, 1, tint4editor],
                            \ [4, 2, shade4editor]
                            \ ] 
                          \ })
    "....................
   
  
    let colorblock = forms#newArea({'width': 6, 'height': 2})
    let colorblock.__rgbtxt = "000000"
    let colorblock.__numbertxt = "0"
    let colorblock.__hiname = "ERROR_HIGHLIGHT_NOT_SET"

    function! colorblock.init(attrs) dict
      call call(g:forms#Area.init, [a:attrs], self)

      let ctermfg = "0"
      let guifg="#000000"
      execute ":hi ".self.__hiname." ctermfg=".ctermfg." ctermbg=".self.__numbertxt." guifg=".guifg." guibg=#".self.__rgbtxt
      return self
    endfunction

    function! colorblock.setNumberText(numbertxt) dict
      let l = len(a:numbertxt)
      if l == 3
        let self.__numbertxt = " " . a:numbertxt
      elseif l == 2
        let self.__numbertxt = "  " . a:numbertxt
      else
        let self.__numbertxt = "   " . a:numbertxt
      endif
    endfunction

    function! colorblock.addResults(results) dict
      " only add to results if its activitly being displayed, i.e.,
      " self.__matchId exisits
      if exists("self.__matchId")
        let nt = self.__numbertxt[1:]
        if nt[0] == ' '
          let nt = nt[1:]
        endif
        if nt[0] == ' '
          let nt = nt[1:]
        endif
        let a:results[self.__hiname] = [self.__rgbtxt, nt]
      endif
    endfunction

    function! colorblock.hide() dict
      call GlyphDeleteHi(self)
    endfunction

    function! colorblock.draw(allocation) dict
"" call forms#log("colorblock.draw: TOP ". self.__hiname)
      call call(g:forms#Area.draw, [a:allocation], self)

      let a = a:allocation
      call forms#SetStringAt(self.__rgbtxt, a.line, a.column)
      call forms#SetStringAt(self.__numbertxt, a.line+1, a.column)
      call GlyphHilight(self, self.__hiname, a)
    endfunction



    function! CCBlockAdjuster(block,rn,gn,bn)
" call forms#log("CCBlockAdjuster.execute: TOP")
      let block = a:block
      if exists("block.tinteditor")
        let tinttxt = block.tinteditor.getText()
        let tintf = str2float(tinttxt)
        let shadetxt = block.shadeeditor.getText()
        let shadef = str2float(shadetxt)
        let [rn1,gn1,bn1] = g:ColorUtil().TintRGB(tintf, a:rn, a:gn, a:bn)
        let [rn1,gn1,bn1] = g:ColorUtil().ShadeRGB(shadef, rn1, gn1, bn1)
      else
        let [rn1,gn1,bn1] = [a:rn, a:gn, a:bn]
      endif

      let n1 = g:ColorUtil().ConvertRGB2IntNew(rn1,gn1,bn1)
      let rgbtxt1 = printf('%02x%02x%02x',rn1,gn1,bn1)
      if((0.5*rn1+gn1+0.3*bn1)>220)
        let ctermfg = "0"
        let guifg="#000000"
      else
        let ctermfg = "255"
        let guifg="#ffffff"
      endif

      let hiname = block.__hiname
      execute ":hi ".hiname." ctermfg=".ctermfg." ctermbg=".n1." guifg=".guifg." guibg=#".rgbtxt1
      let block.__rgbtxt = rgbtxt1
      call block.setNumberText(n1)
if empty(block.__allocation)
" call forms#log("CCBlockAdjuster.execute: EMPTY: ".hiname)
endif
      call forms#ViewerRedrawListAdd(block) 
" call forms#log("CCBlockAdjuster.execute: BOTTOM")
    endfunction


    " called by deckaction
    function! CCDeckRowAction(...) dict
" call forms#log("CCDeckRowAction.execute: TOP")
      let rn = a:1
      let gn = a:2
      let bn = a:3

      for block in self.blocks
        call CCBlockAdjuster(block, rn, gn, bn)
      endfor
" call forms#log("CCDeckRowAction.execute: BOTTOM")
    endfunction


    " Monochromatic Card --------------------------------------------
    let oneblock = colorblock.clone().init({ 'hiname' : 'MOneHi' })
    let oneblock.tinteditor = tint1editor
    let oneblock.shadeeditor = shade1editor

    let twoblock = colorblock.clone().init({ 'hiname' : 'MTwoHi' })
    let twoblock.tinteditor = tint2editor
    let twoblock.shadeeditor = shade2editor

    let baseblock = colorblock.clone().init({ 'hiname' : 'MBaseHi'})

    let threeblock = colorblock.clone().init({ 'hiname' : 'MThreeHi' })
    let threeblock.tinteditor = tint3editor
    let threeblock.shadeeditor = shade3editor

    let fourblock = colorblock.clone().init({ 'hiname' : 'MFourHi' })
    let fourblock.tinteditor = tint4editor
    let fourblock.shadeeditor = shade4editor

    let monochromaticdraction = forms#newAction({ 'execute': function("CCDeckRowAction")})
    let monochromaticdraction.blocks = [
                                 \ oneblock,
                                 \ twoblock,
                                 \ baseblock,
                                 \ threeblock,
                                 \ fourblock
                                 \ ]


    " called by deckaction
    function! CCMonochromaticAction(...) dict
" call forms#log("CCMonochromaticAction.execute: TOP")
      let rn = a:1
      let gn = a:2
      let bn = a:3

      call self.draction.execute(rn, gn, bn)
" call forms#log("CCMonochromaticAction.execute: BOTTOM")
    endfunction

    let monochromaticaction = forms#newAction({ 'execute': function("CCMonochromaticAction")})
    let monochromaticaction.draction = monochromaticdraction


    call add(deckaction.palletactions, monochromaticaction)
    call add(adjusteraction.palletactions, monochromaticaction)

    let vspace = forms#newVSpace({'size': 1})
    let monochromhpoly = forms#newHPoly({ 'children': [
                                        \ oneblock, 
                                        \ vspace, 
                                        \ twoblock, 
                                        \ vspace, 
                                        \ baseblock, 
                                        \ vspace, 
                                        \ threeblock, 
                                        \ vspace, 
                                        \ fourblock], 
                                        \ 'alignment': 'C' })


    " Complimentary Card --------------------------------------------
    
    " mono
    let cmoneblock = colorblock.clone().init({ 'hiname' : 'CMOneHi' })
    let cmoneblock.tinteditor = tint1editor
    let cmoneblock.shadeeditor = shade1editor

    let cmtwoblock = colorblock.clone().init({ 'hiname' : 'CMTwoHi' })
    let cmtwoblock.tinteditor = tint2editor
    let cmtwoblock.shadeeditor = shade2editor

    let cmbaseblock = colorblock.clone().init({ 'hiname' : 'CMBaseHi'})

    let cmthreeblock = colorblock.clone().init({ 'hiname' : 'CMThreeHi' })
    let cmthreeblock.tinteditor = tint3editor
    let cmthreeblock.shadeeditor = shade3editor

    let cmfourblock = colorblock.clone().init({ 'hiname' : 'CMFourHi' })
    let cmfourblock.tinteditor = tint4editor
    let cmfourblock.shadeeditor = shade4editor

    let cmmonochromaticdraction = forms#newAction({ 'execute': function("CCDeckRowAction")})
    let cmmonochromaticdraction.blocks = [
                                      \ cmoneblock,
                                      \ cmtwoblock,
                                      \ cmbaseblock,
                                      \ cmthreeblock,
                                      \ cmfourblock
                                      \ ]

    " comp
    let cconeblock = colorblock.clone().init({ 'hiname' : 'CCOneHi' })
    let cconeblock.tinteditor = tint1editor
    let cconeblock.shadeeditor = shade1editor

    let cctwoblock = colorblock.clone().init({ 'hiname' : 'CCTwoHi' })
    let cctwoblock.tinteditor = tint2editor
    let cctwoblock.shadeeditor = shade2editor

    let ccbaseblock = colorblock.clone().init({ 'hiname' : 'CCBaseHi'})

    let ccthreeblock = colorblock.clone().init({ 'hiname' : 'CCThreeHi' })
    let ccthreeblock.tinteditor = tint3editor
    let ccthreeblock.shadeeditor = shade3editor

    let ccfourblock = colorblock.clone().init({ 'hiname' : 'CCFourHi' })
    let ccfourblock.tinteditor = tint4editor
    let ccfourblock.shadeeditor = shade4editor

    let ccdraction = forms#newAction({ 'execute': function("CCDeckRowAction")})
    let ccdraction.blocks = [
                                      \ cconeblock,
                                      \ cctwoblock,
                                      \ ccbaseblock,
                                      \ ccthreeblock,
                                      \ ccfourblock
                                      \ ]

    function! CCComplimentaryAction(...) dict
" call forms#log("CCComplimentaryAction.execute: TOP")
      let rn = a:1
      let gn = a:2
      let bn = a:3

      call self.cmmonochromaticdraction.execute(rn, gn, bn)

      let [rn,gn,bn] = g:ColorUtil().ComplimentRGBusingHSV(rn, gn, bn)
      call self.ccdraction.execute(rn, gn, bn)

" call forms#log("CCComplimentaryAction.execute: BOTTOM")
    endfunction
    let complimentaryaction = forms#newAction({ 'execute': function("CCComplimentaryAction")})
    let complimentaryaction.cmmonochromaticdraction = cmmonochromaticdraction
    let complimentaryaction.ccdraction = ccdraction

    call add(deckaction.palletactions, complimentaryaction)
    call add(adjusteraction.palletactions, complimentaryaction)

    let vspace = forms#newVSpace({'size': 1})
    let cmonochromhpoly = forms#newHPoly({ 'children': [
                                        \ cmoneblock, 
                                        \ vspace, 
                                        \ cmtwoblock, 
                                        \ vspace, 
                                        \ cmbaseblock, 
                                        \ vspace, 
                                        \ cmthreeblock, 
                                        \ vspace, 
                                        \ cmfourblock], 
                                        \ 'alignment': 'C' })
    let ccomplimenthpoly = forms#newHPoly({ 'children': [
                                        \ cconeblock, 
                                        \ vspace, 
                                        \ cctwoblock, 
                                        \ vspace, 
                                        \ ccbaseblock, 
                                        \ vspace, 
                                        \ ccthreeblock, 
                                        \ vspace, 
                                        \ ccfourblock], 
                                        \ 'alignment': 'C' })

    let complimentbpoly = forms#newVPoly({ 'children': [
                                        \ cmonochromhpoly, 
                                        \ hspace, 
                                        \ ccomplimenthpoly], 
                                        \ 'alignment': 'C' })
    
    " Split Complimentary Card --------------------------------------
    
    " mono
    let scmoneblock = colorblock.clone().init({ 'hiname' : 'SCMOneHi' })
    let scmoneblock.tinteditor = tint1editor
    let scmoneblock.shadeeditor = shade1editor

    let scmtwoblock = colorblock.clone().init({ 'hiname' : 'SCMTwoHi' })
    let scmtwoblock.tinteditor = tint2editor
    let scmtwoblock.shadeeditor = shade2editor

    let scmbaseblock = colorblock.clone().init({ 'hiname' : 'SCMBaseHi'})

    let scmthreeblock = colorblock.clone().init({ 'hiname' : 'SCMThreeHi' })
    let scmthreeblock.tinteditor = tint3editor
    let scmthreeblock.shadeeditor = shade3editor

    let scmfourblock = colorblock.clone().init({ 'hiname' : 'SCMFourHi' })
    let scmfourblock.tinteditor = tint4editor
    let scmfourblock.shadeeditor = shade4editor

    let scmmonochromaticdraction = forms#newAction({ 'execute': function("CCDeckRowAction")})
    let scmmonochromaticdraction.blocks = [
                                      \ scmoneblock,
                                      \ scmtwoblock,
                                      \ scmbaseblock,
                                      \ scmthreeblock,
                                      \ scmfourblock
                                      \ ]
   
    " s1comp
    let s1cconeblock = colorblock.clone().init({ 'hiname' : 'S1CCOneHi' })
    let s1cconeblock.tinteditor = tint1editor
    let s1cconeblock.shadeeditor = shade1editor

    let s1cctwoblock = colorblock.clone().init({ 'hiname' : 'S1CCTwoHi' })
    let s1cctwoblock.tinteditor = tint2editor
    let s1cctwoblock.shadeeditor = shade2editor

    let s1ccbaseblock = colorblock.clone().init({ 'hiname' : 'S1CCBaseHi'})

    let s1ccthreeblock = colorblock.clone().init({ 'hiname' : 'S1CCThreeHi' })
    let s1ccthreeblock.tinteditor = tint3editor
    let s1ccthreeblock.shadeeditor = shade3editor

    let s1ccfourblock = colorblock.clone().init({ 'hiname' : 'S1CCFourHi' })
    let s1ccfourblock.tinteditor = tint4editor
    let s1ccfourblock.shadeeditor = shade4editor

    let s1ccdraction = forms#newAction({ 'execute': function("CCDeckRowAction")})
    let s1ccdraction.blocks = [
                                      \ s1cconeblock,
                                      \ s1cctwoblock,
                                      \ s1ccbaseblock,
                                      \ s1ccthreeblock,
                                      \ s1ccfourblock
                                      \ ]

    " s2comp
    let s2cconeblock = colorblock.clone().init({ 'hiname' : 'S2CCOneHi' })
    let s2cconeblock.tinteditor = tint1editor
    let s2cconeblock.shadeeditor = shade1editor

    let s2cctwoblock = colorblock.clone().init({ 'hiname' : 'S2CCTwoHi' })
    let s2cctwoblock.tinteditor = tint2editor
    let s2cctwoblock.shadeeditor = shade2editor

    let s2ccbaseblock = colorblock.clone().init({ 'hiname' : 'S2CCBaseHi'})

    let s2ccthreeblock = colorblock.clone().init({ 'hiname' : 'S2CCThreeHi' })
    let s2ccthreeblock.tinteditor = tint3editor
    let s2ccthreeblock.shadeeditor = shade3editor

    let s2ccfourblock = colorblock.clone().init({ 'hiname' : 'S2CCFourHi' })
    let s2ccfourblock.tinteditor = tint4editor
    let s2ccfourblock.shadeeditor = shade4editor

    let s2ccdraction = forms#newAction({ 'execute': function("CCDeckRowAction")})
    let s2ccdraction.blocks = [
                                      \ s2cconeblock,
                                      \ s2cctwoblock,
                                      \ s2ccbaseblock,
                                      \ s2ccthreeblock,
                                      \ s2ccfourblock
                                      \ ]

    function! SCCComplimentaryAction(...) dict
" call forms#log("SCCComplimentaryAction.execute: TOP")
      let rn = a:1
      let gn = a:2
      let bn = a:3

      call self.scmmonochromaticdraction.execute(rn, gn, bn)

      let shift = g:splitComplimentaryShiftInit
      let [rgb1,rgb2] = g:ColorUtil().SplitComplimentaryRGBusingHSV(shift, rn, gn, bn)
      let [rn1,gn1,bn1] = rgb1
      let [rn2,gn2,bn2] = rgb2

      " split 1
      call self.s1ccdraction.execute(rn1, gn1, bn1)

      " split 2
      call self.s2ccdraction.execute(rn2, gn2, bn2)

" call forms#log("SCCComplimentaryAction.execute: BOTTOM")
    endfunction
    let scomplimentaryaction = forms#newAction({ 'execute': function("SCCComplimentaryAction")})
    let scomplimentaryaction.scmmonochromaticdraction = scmmonochromaticdraction
    let scomplimentaryaction.s1ccdraction = s1ccdraction
    let scomplimentaryaction.s2ccdraction = s2ccdraction

    call add(deckaction.palletactions, scomplimentaryaction)
    call add(adjusteraction.palletactions, scomplimentaryaction)

    let vspace = forms#newVSpace({'size': 1})
    let scmonochromhpoly = forms#newHPoly({ 'children': [
                                        \ scmoneblock, 
                                        \ vspace, 
                                        \ scmtwoblock, 
                                        \ vspace, 
                                        \ scmbaseblock, 
                                        \ vspace, 
                                        \ scmthreeblock, 
                                        \ vspace, 
                                        \ scmfourblock], 
                                        \ 'alignment': 'C' })
    let s1ccomplimenthpoly = forms#newHPoly({ 'children': [
                                        \ s1cconeblock, 
                                        \ vspace, 
                                        \ s1cctwoblock, 
                                        \ vspace, 
                                        \ s1ccbaseblock, 
                                        \ vspace, 
                                        \ s1ccthreeblock, 
                                        \ vspace, 
                                        \ s1ccfourblock], 
                                        \ 'alignment': 'C' })
    let s2ccomplimenthpoly = forms#newHPoly({ 'children': [
                                        \ s2cconeblock, 
                                        \ vspace, 
                                        \ s2cctwoblock, 
                                        \ vspace, 
                                        \ s2ccbaseblock, 
                                        \ vspace, 
                                        \ s2ccthreeblock, 
                                        \ vspace, 
                                        \ s2ccfourblock], 
                                        \ 'alignment': 'C' })

    let scomplimentbpoly = forms#newVPoly({ 'children': [
                                        \ scmonochromhpoly, 
                                        \ hspace, 
                                        \ s1ccomplimenthpoly, 
                                        \ hspace, 
                                        \ s2ccomplimenthpoly], 
                                        \ 'alignment': 'C' })
    
    " Analogic Card -------------------------------------------------
    
    " mono
    let acmoneblock = colorblock.clone().init({ 'hiname' : 'ACMOneHi' })
    let acmoneblock.tinteditor = tint1editor
    let acmoneblock.shadeeditor = shade1editor

    let acmtwoblock = colorblock.clone().init({ 'hiname' : 'ACMTwoHi' })
    let acmtwoblock.tinteditor = tint2editor
    let acmtwoblock.shadeeditor = shade2editor

    let acmbaseblock = colorblock.clone().init({ 'hiname' : 'ACMBaseHi'})

    let acmthreeblock = colorblock.clone().init({ 'hiname' : 'ACMThreeHi' })
    let acmthreeblock.tinteditor = tint3editor
    let acmthreeblock.shadeeditor = shade3editor

    let acmfourblock = colorblock.clone().init({ 'hiname' : 'ACMFourHi' })
    let acmfourblock.tinteditor = tint4editor
    let acmfourblock.shadeeditor = shade4editor

    let acmmonochromaticdraction = forms#newAction({ 'execute': function("CCDeckRowAction")})
    let acmmonochromaticdraction.blocks = [
                                      \ acmoneblock,
                                      \ acmtwoblock,
                                      \ acmbaseblock,
                                      \ acmthreeblock,
                                      \ acmfourblock
                                      \ ]
   
    " a1comp
    let a1cconeblock = colorblock.clone().init({ 'hiname' : 'A1CCOneHi' })
    let a1cconeblock.tinteditor = tint1editor
    let a1cconeblock.shadeeditor = shade1editor

    let a1cctwoblock = colorblock.clone().init({ 'hiname' : 'A1CCTwoHi' })
    let a1cctwoblock.tinteditor = tint2editor
    let a1cctwoblock.shadeeditor = shade2editor

    let a1ccbaseblock = colorblock.clone().init({ 'hiname' : 'A1CCBaseHi'})

    let a1ccthreeblock = colorblock.clone().init({ 'hiname' : 'A1CCThreeHi' })
    let a1ccthreeblock.tinteditor = tint3editor
    let a1ccthreeblock.shadeeditor = shade3editor

    let a1ccfourblock = colorblock.clone().init({ 'hiname' : 'A1CCFourHi' })
    let a1ccfourblock.tinteditor = tint4editor
    let a1ccfourblock.shadeeditor = shade4editor

    let a1ccdraction = forms#newAction({ 'execute': function("CCDeckRowAction")})
    let a1ccdraction.blocks = [
                                      \ a1cconeblock,
                                      \ a1cctwoblock,
                                      \ a1ccbaseblock,
                                      \ a1ccthreeblock,
                                      \ a1ccfourblock
                                      \ ]

    " a2comp
    let a2cconeblock = colorblock.clone().init({ 'hiname' : 'A2CCOneHi' })
    let a2cconeblock.tinteditor = tint1editor
    let a2cconeblock.shadeeditor = shade1editor

    let a2cctwoblock = colorblock.clone().init({ 'hiname' : 'A2CCTwoHi' })
    let a2cctwoblock.tinteditor = tint2editor
    let a2cctwoblock.shadeeditor = shade2editor

    let a2ccbaseblock = colorblock.clone().init({ 'hiname' : 'A2CCBaseHi'})

    let a2ccthreeblock = colorblock.clone().init({ 'hiname' : 'A2CCThreeHi' })
    let a2ccthreeblock.tinteditor = tint3editor
    let a2ccthreeblock.shadeeditor = shade3editor

    let a2ccfourblock = colorblock.clone().init({ 'hiname' : 'A2CCFourHi' })
    let a2ccfourblock.tinteditor = tint4editor
    let a2ccfourblock.shadeeditor = shade4editor

    let a2ccdraction = forms#newAction({ 'execute': function("CCDeckRowAction")})
    let a2ccdraction.blocks = [
                                      \ a2cconeblock,
                                      \ a2cctwoblock,
                                      \ a2ccbaseblock,
                                      \ a2ccthreeblock,
                                      \ a2ccfourblock
                                      \ ]

    function! ACCComplimentaryAction(...) dict
" call forms#log("ACCComplimentaryAction.execute: TOP")
      let rn = a:1
      let gn = a:2
      let bn = a:3

      call self.acmmonochromaticdraction.execute(rn, gn, bn)

      let shift = g:analogicShiftInit
      let [rgb1,rgb2] = g:ColorUtil().AnalogicRGBusingHSV(shift, rn, gn, bn)
      let [rn1,gn1,bn1] = rgb1
      let [rn2,gn2,bn2] = rgb2

      " analogic 1
      call self.a1ccdraction.execute(rn1, gn1, bn1)

      " analogic 2
      call self.a2ccdraction.execute(rn2, gn2, bn2)

" call forms#log("ACCComplimentaryAction.execute: BOTTOM")
    endfunction
    let acomplimentaryaction = forms#newAction({ 'execute': function("ACCComplimentaryAction")})
    let acomplimentaryaction.acmmonochromaticdraction = acmmonochromaticdraction
    let acomplimentaryaction.a1ccdraction = a1ccdraction
    let acomplimentaryaction.a2ccdraction = a2ccdraction

    call add(deckaction.palletactions, acomplimentaryaction)
    call add(adjusteraction.palletactions, acomplimentaryaction)

    let vspace = forms#newVSpace({'size': 1})
    let acmonochromhpoly = forms#newHPoly({ 'children': [
                                        \ acmoneblock, 
                                        \ vspace, 
                                        \ acmtwoblock, 
                                        \ vspace, 
                                        \ acmbaseblock, 
                                        \ vspace, 
                                        \ acmthreeblock, 
                                        \ vspace, 
                                        \ acmfourblock], 
                                        \ 'alignment': 'C' })
    let a1ccomplimenthpoly = forms#newHPoly({ 'children': [
                                        \ a1cconeblock, 
                                        \ vspace, 
                                        \ a1cctwoblock, 
                                        \ vspace, 
                                        \ a1ccbaseblock, 
                                        \ vspace, 
                                        \ a1ccthreeblock, 
                                        \ vspace, 
                                        \ a1ccfourblock], 
                                        \ 'alignment': 'C' })
    let a2ccomplimenthpoly = forms#newHPoly({ 'children': [
                                        \ a2cconeblock, 
                                        \ vspace, 
                                        \ a2cctwoblock, 
                                        \ vspace, 
                                        \ a2ccbaseblock, 
                                        \ vspace, 
                                        \ a2ccthreeblock, 
                                        \ vspace, 
                                        \ a2ccfourblock], 
                                        \ 'alignment': 'C' })

    let acomplimentbpoly = forms#newVPoly({ 'children': [
                                        \ acmonochromhpoly, 
                                        \ hspace, 
                                        \ a1ccomplimenthpoly, 
                                        \ hspace, 
                                        \ a2ccomplimenthpoly], 
                                        \ 'alignment': 'C' })
    
    " Accented Analogic ---------------------------------------------
    
    " mono
    let aacmoneblock = colorblock.clone().init({ 'hiname' : 'AACMOneHi' })
    let aacmoneblock.tinteditor = tint1editor
    let aacmoneblock.shadeeditor = shade1editor

    let aacmtwoblock = colorblock.clone().init({ 'hiname' : 'AACMTwoHi' })
    let aacmtwoblock.tinteditor = tint2editor
    let aacmtwoblock.shadeeditor = shade2editor

    let aacmbaseblock = colorblock.clone().init({ 'hiname' : 'AACMBaseHi'})

    let aacmthreeblock = colorblock.clone().init({ 'hiname' : 'AACMThreeHi' })
    let aacmthreeblock.tinteditor = tint3editor
    let aacmthreeblock.shadeeditor = shade3editor

    let aacmfourblock = colorblock.clone().init({ 'hiname' : 'AACMFourHi' })
    let aacmfourblock.tinteditor = tint4editor
    let aacmfourblock.shadeeditor = shade4editor

    let aacmmonochromaticdraction = forms#newAction({ 'execute': function("CCDeckRowAction")})
    let aacmmonochromaticdraction.blocks = [
                                      \ aacmoneblock,
                                      \ aacmtwoblock,
                                      \ aacmbaseblock,
                                      \ aacmthreeblock,
                                      \ aacmfourblock
                                      \ ]
   
    " aa1comp
    let aa1cconeblock = colorblock.clone().init({ 'hiname' : 'AA1CCOneHi' })
    let aa1cconeblock.tinteditor = tint1editor
    let aa1cconeblock.shadeeditor = shade1editor

    let aa1cctwoblock = colorblock.clone().init({ 'hiname' : 'AA1CCTwoHi' })
    let aa1cctwoblock.tinteditor = tint2editor
    let aa1cctwoblock.shadeeditor = shade2editor

    let aa1ccbaseblock = colorblock.clone().init({ 'hiname' : 'AA1CCBaseHi'})

    let aa1ccthreeblock = colorblock.clone().init({ 'hiname' : 'AA1CCThreeHi' })
    let aa1ccthreeblock.tinteditor = tint3editor
    let aa1ccthreeblock.shadeeditor = shade3editor

    let aa1ccfourblock = colorblock.clone().init({ 'hiname' : 'AA1CCFourHi' })
    let aa1ccfourblock.tinteditor = tint4editor
    let aa1ccfourblock.shadeeditor = shade4editor

    let aa1ccdraction = forms#newAction({ 'execute': function("CCDeckRowAction")})
    let aa1ccdraction.blocks = [
                                      \ aa1cconeblock,
                                      \ aa1cctwoblock,
                                      \ aa1ccbaseblock,
                                      \ aa1ccthreeblock,
                                      \ aa1ccfourblock
                                      \ ]

    " aa2comp
    let aa2cconeblock = colorblock.clone().init({ 'hiname' : 'AA2CCOneHi' })
    let aa2cconeblock.tinteditor = tint1editor
    let aa2cconeblock.shadeeditor = shade1editor

    let aa2cctwoblock = colorblock.clone().init({ 'hiname' : 'AA2CCTwoHi' })
    let aa2cctwoblock.tinteditor = tint2editor
    let aa2cctwoblock.shadeeditor = shade2editor

    let aa2ccbaseblock = colorblock.clone().init({ 'hiname' : 'AA2CCBaseHi'})

    let aa2ccthreeblock = colorblock.clone().init({ 'hiname' : 'AA2CCThreeHi' })
    let aa2ccthreeblock.tinteditor = tint3editor
    let aa2ccthreeblock.shadeeditor = shade3editor

    let aa2ccfourblock = colorblock.clone().init({ 'hiname' : 'AA2CCFourHi' })
    let aa2ccfourblock.tinteditor = tint4editor
    let aa2ccfourblock.shadeeditor = shade4editor

    let aa2ccdraction = forms#newAction({ 'execute': function("CCDeckRowAction")})
    let aa2ccdraction.blocks = [
                                      \ aa2cconeblock,
                                      \ aa2cctwoblock,
                                      \ aa2ccbaseblock,
                                      \ aa2ccthreeblock,
                                      \ aa2ccfourblock
                                      \ ]

    " comp
    let aacconeblock = colorblock.clone().init({ 'hiname' : 'AACCOneHi' })
    let aacconeblock.tinteditor = tint1editor
    let aacconeblock.shadeeditor = shade1editor

    let aacctwoblock = colorblock.clone().init({ 'hiname' : 'AACCTwoHi' })
    let aacctwoblock.tinteditor = tint2editor
    let aacctwoblock.shadeeditor = shade2editor

    let aaccbaseblock = colorblock.clone().init({ 'hiname' : 'AACCBaseHi'})

    let aaccthreeblock = colorblock.clone().init({ 'hiname' : 'AACCThreeHi' })
    let aaccthreeblock.tinteditor = tint3editor
    let aaccthreeblock.shadeeditor = shade3editor

    let aaccfourblock = colorblock.clone().init({ 'hiname' : 'AACCFourHi' })
    let aaccfourblock.tinteditor = tint4editor
    let aaccfourblock.shadeeditor = shade4editor

    let aaccdraction = forms#newAction({ 'execute': function("CCDeckRowAction")})
    let aaccdraction.blocks = [
                                      \ aacconeblock,
                                      \ aacctwoblock,
                                      \ aaccbaseblock,
                                      \ aaccthreeblock,
                                      \ aaccfourblock
                                      \ ]

    function! AACCComplimentaryAction(...) dict
" call forms#log("AACCComplimentaryAction.execute: TOP")
      let rn = a:1
      let gn = a:2
      let bn = a:3

      call self.aacmmonochromaticdraction.execute(rn, gn, bn)

      let shift = g:accentedAnalogicShiftInit
      let [rgb1,rgb2] = g:ColorUtil().AnalogicRGBusingHSV(shift, rn, gn, bn)
      let [rn1,gn1,bn1] = rgb1
      let [rn2,gn2,bn2] = rgb2
      " analogic 1
      call self.aa1ccdraction.execute(rn1, gn1, bn1)
      " analogic 2
      call self.aa2ccdraction.execute(rn2, gn2, bn2)

      " comp
      let [rn,gn,bn] = g:ColorUtil().ComplimentRGBusingHSV(rn, gn, bn)
      call self.aaccdraction.execute(rn, gn, bn)

" call forms#log("AACCComplimentaryAction.execute: BOTTOM")
    endfunction
    let aacomplimentaryaction = forms#newAction({ 'execute': function("AACCComplimentaryAction")})
    let aacomplimentaryaction.aacmmonochromaticdraction = aacmmonochromaticdraction
    let aacomplimentaryaction.aa1ccdraction = aa1ccdraction
    let aacomplimentaryaction.aa2ccdraction = aa2ccdraction
    let aacomplimentaryaction.aaccdraction = aaccdraction

    call add(deckaction.palletactions, aacomplimentaryaction)
    call add(adjusteraction.palletactions, aacomplimentaryaction)

    let vspace = forms#newVSpace({'size': 1})
    let aacmonochromhpoly = forms#newHPoly({ 'children': [
                                        \ aacmoneblock, 
                                        \ vspace, 
                                        \ aacmtwoblock, 
                                        \ vspace, 
                                        \ aacmbaseblock, 
                                        \ vspace, 
                                        \ aacmthreeblock, 
                                        \ vspace, 
                                        \ aacmfourblock], 
                                        \ 'alignment': 'C' })
    let aa1ccomplimenthpoly = forms#newHPoly({ 'children': [
                                        \ aa1cconeblock, 
                                        \ vspace, 
                                        \ aa1cctwoblock, 
                                        \ vspace, 
                                        \ aa1ccbaseblock, 
                                        \ vspace, 
                                        \ aa1ccthreeblock, 
                                        \ vspace, 
                                        \ aa1ccfourblock], 
                                        \ 'alignment': 'C' })
    let aa2ccomplimenthpoly = forms#newHPoly({ 'children': [
                                        \ aa2cconeblock, 
                                        \ vspace, 
                                        \ aa2cctwoblock, 
                                        \ vspace, 
                                        \ aa2ccbaseblock, 
                                        \ vspace, 
                                        \ aa2ccthreeblock, 
                                        \ vspace, 
                                        \ aa2ccfourblock], 
                                        \ 'alignment': 'C' })
    let aaccomplimenthpoly = forms#newHPoly({ 'children': [
                                        \ aacconeblock, 
                                        \ vspace, 
                                        \ aacctwoblock, 
                                        \ vspace, 
                                        \ aaccbaseblock, 
                                        \ vspace, 
                                        \ aaccthreeblock, 
                                        \ vspace, 
                                        \ aaccfourblock], 
                                        \ 'alignment': 'C' })

    let aacomplimentbpoly = forms#newVPoly({ 'children': [
                                        \ aacmonochromhpoly, 
                                        \ hspace, 
                                        \ aa1ccomplimenthpoly, 
                                        \ hspace, 
                                        \ aa2ccomplimenthpoly, 
                                        \ hspace, 
                                        \ aaccomplimenthpoly], 
                                        \ 'alignment': 'C' })
    
    
    " Triadic Card --------------------------------------------------
    
    " mono
    let tmoneblock = colorblock.clone().init({ 'hiname' : 'TMOneHi' })
    let tmoneblock.tinteditor = tint1editor
    let tmoneblock.shadeeditor = shade1editor

    let tmtwoblock = colorblock.clone().init({ 'hiname' : 'TMTwoHi' })
    let tmtwoblock.tinteditor = tint2editor
    let tmtwoblock.shadeeditor = shade2editor

    let tmbaseblock = colorblock.clone().init({ 'hiname' : 'TMBaseHi'})

    let tmthreeblock = colorblock.clone().init({ 'hiname' : 'TMThreeHi' })
    let tmthreeblock.tinteditor = tint3editor
    let tmthreeblock.shadeeditor = shade3editor

    let tmfourblock = colorblock.clone().init({ 'hiname' : 'TMFourHi' })
    let tmfourblock.tinteditor = tint4editor
    let tmfourblock.shadeeditor = shade4editor

    let tmmonochromaticdraction = forms#newAction({ 'execute': function("CCDeckRowAction")})
    let tmmonochromaticdraction.blocks = [
                                      \ tmoneblock,
                                      \ tmtwoblock,
                                      \ tmbaseblock,
                                      \ tmthreeblock,
                                      \ tmfourblock
                                      \ ]
   
    " t1comp
    let t1cconeblock = colorblock.clone().init({ 'hiname' : 'T1CCOneHi' })
    let t1cconeblock.tinteditor = tint1editor
    let t1cconeblock.shadeeditor = shade1editor

    let t1cctwoblock = colorblock.clone().init({ 'hiname' : 'T1CCTwoHi' })
    let t1cctwoblock.tinteditor = tint2editor
    let t1cctwoblock.shadeeditor = shade2editor

    let t1ccbaseblock = colorblock.clone().init({ 'hiname' : 'T1CCBaseHi'})

    let t1ccthreeblock = colorblock.clone().init({ 'hiname' : 'T1CCThreeHi' })
    let t1ccthreeblock.tinteditor = tint3editor
    let t1ccthreeblock.shadeeditor = shade3editor

    let t1ccfourblock = colorblock.clone().init({ 'hiname' : 'T1CCFourHi' })
    let t1ccfourblock.tinteditor = tint4editor
    let t1ccfourblock.shadeeditor = shade4editor

    let t1ccdraction = forms#newAction({ 'execute': function("CCDeckRowAction")})
    let t1ccdraction.blocks = [
                                      \ t1cconeblock,
                                      \ t1cctwoblock,
                                      \ t1ccbaseblock,
                                      \ t1ccthreeblock,
                                      \ t1ccfourblock
                                      \ ]

    " t2comp
    let t2cconeblock = colorblock.clone().init({ 'hiname' : 'T2CCOneHi' })
    let t2cconeblock.tinteditor = tint1editor
    let t2cconeblock.shadeeditor = shade1editor

    let t2cctwoblock = colorblock.clone().init({ 'hiname' : 'T2CCTwoHi' })
    let t2cctwoblock.tinteditor = tint2editor
    let t2cctwoblock.shadeeditor = shade2editor

    let t2ccbaseblock = colorblock.clone().init({ 'hiname' : 'T2CCBaseHi'})

    let t2ccthreeblock = colorblock.clone().init({ 'hiname' : 'T2CCThreeHi' })
    let t2ccthreeblock.tinteditor = tint3editor
    let t2ccthreeblock.shadeeditor = shade3editor

    let t2ccfourblock = colorblock.clone().init({ 'hiname' : 'T2CCFourHi' })
    let t2ccfourblock.tinteditor = tint4editor
    let t2ccfourblock.shadeeditor = shade4editor

    let t2ccdraction = forms#newAction({ 'execute': function("CCDeckRowAction")})
    let t2ccdraction.blocks = [
                                      \ t2cconeblock,
                                      \ t2cctwoblock,
                                      \ t2ccbaseblock,
                                      \ t2ccthreeblock,
                                      \ t2ccfourblock
                                      \ ]

    function! TCCComplimentaryAction(...) dict
" call forms#log("TCCComplimentaryAction.execute: TOP")
      let rn = a:1
      let gn = a:2
      let bn = a:3

      call self.tmmonochromaticdraction.execute(rn, gn, bn)

      let [rgb1,rgb2] = g:ColorUtil().TriadicRGBusingHSV(rn, gn, bn)
      let [rn1,gn1,bn1] = rgb1
      let [rn2,gn2,bn2] = rgb2
      " triadic 1
      call self.t1ccdraction.execute(rn1, gn1, bn1)
      " triadic 2
      call self.t2ccdraction.execute(rn2, gn2, bn2)

" call forms#log("TCCComplimentaryAction.execute: BOTTOM")
    endfunction
    let tcomplimentaryaction = forms#newAction({ 'execute': function("TCCComplimentaryAction")})
    let tcomplimentaryaction.tmmonochromaticdraction = tmmonochromaticdraction
    let tcomplimentaryaction.t1ccdraction = t1ccdraction
    let tcomplimentaryaction.t2ccdraction = t2ccdraction

    call add(deckaction.palletactions, tcomplimentaryaction)
    call add(adjusteraction.palletactions, tcomplimentaryaction)

    let vspace = forms#newVSpace({'size': 1})
    let tcmonochromhpoly = forms#newHPoly({ 'children': [
                                        \ tmoneblock, 
                                        \ vspace, 
                                        \ tmtwoblock, 
                                        \ vspace, 
                                        \ tmbaseblock, 
                                        \ vspace, 
                                        \ tmthreeblock, 
                                        \ vspace, 
                                        \ tmfourblock], 
                                        \ 'alignment': 'C' })
    let t1ccomplimenthpoly = forms#newHPoly({ 'children': [
                                        \ t1cconeblock, 
                                        \ vspace, 
                                        \ t1cctwoblock, 
                                        \ vspace, 
                                        \ t1ccbaseblock, 
                                        \ vspace, 
                                        \ t1ccthreeblock, 
                                        \ vspace, 
                                        \ t1ccfourblock], 
                                        \ 'alignment': 'C' })
    let t2ccomplimenthpoly = forms#newHPoly({ 'children': [
                                        \ t2cconeblock, 
                                        \ vspace, 
                                        \ t2cctwoblock, 
                                        \ vspace, 
                                        \ t2ccbaseblock, 
                                        \ vspace, 
                                        \ t2ccthreeblock, 
                                        \ vspace, 
                                        \ t2ccfourblock], 
                                        \ 'alignment': 'C' })

    let tcomplimentbpoly = forms#newVPoly({ 'children': [
                                        \ tcmonochromhpoly, 
                                        \ hspace, 
                                        \ t1ccomplimenthpoly, 
                                        \ hspace, 
                                        \ t2ccomplimenthpoly], 
                                        \ 'alignment': 'C' })
    
    " Double Complimentary Card -------------------------------------
    
    " mono
    let dcmoneblock = colorblock.clone().init({ 'hiname' : 'DCMOneHi' })
    let dcmoneblock.tinteditor = tint1editor
    let dcmoneblock.shadeeditor = shade1editor

    let dcmtwoblock = colorblock.clone().init({ 'hiname' : 'DCMTwoHi' })
    let dcmtwoblock.tinteditor = tint2editor
    let dcmtwoblock.shadeeditor = shade2editor

    let dcmbaseblock = colorblock.clone().init({ 'hiname' : 'DCMBaseHi'})

    let dcmthreeblock = colorblock.clone().init({ 'hiname' : 'DCMThreeHi' })
    let dcmthreeblock.tinteditor = tint3editor
    let dcmthreeblock.shadeeditor = shade3editor

    let dcmfourblock = colorblock.clone().init({ 'hiname' : 'DCMFourHi' })
    let dcmfourblock.tinteditor = tint4editor
    let dcmfourblock.shadeeditor = shade4editor

    let dcmmonochromaticdraction = forms#newAction({ 'execute': function("CCDeckRowAction")})
    let dcmmonochromaticdraction.blocks = [
                                      \ dcmoneblock,
                                      \ dcmtwoblock,
                                      \ dcmbaseblock,
                                      \ dcmthreeblock,
                                      \ dcmfourblock
                                      \ ]

    " minus
    let dmoneblock = colorblock.clone().init({ 'hiname' : 'DMOneHi' })
    let dmoneblock.tinteditor = tint1editor
    let dmoneblock.shadeeditor = shade1editor

    let dmtwoblock = colorblock.clone().init({ 'hiname' : 'DMTwoHi' })
    let dmtwoblock.tinteditor = tint2editor
    let dmtwoblock.shadeeditor = shade2editor

    let dmbaseblock = colorblock.clone().init({ 'hiname' : 'DMBaseHi'})

    let dmthreeblock = colorblock.clone().init({ 'hiname' : 'DMThreeHi' })
    let dmthreeblock.tinteditor = tint3editor
    let dmthreeblock.shadeeditor = shade3editor

    let dmfourblock = colorblock.clone().init({ 'hiname' : 'DMFourHi' })
    let dmfourblock.tinteditor = tint4editor
    let dmfourblock.shadeeditor = shade4editor

    let dmdraction = forms#newAction({ 'execute': function("CCDeckRowAction")})
    let dmdraction.blocks = [
                                      \ dmoneblock,
                                      \ dmtwoblock,
                                      \ dmbaseblock,
                                      \ dmthreeblock,
                                      \ dmfourblock
                                      \ ]

    " comp
    let dconeblock = colorblock.clone().init({ 'hiname' : 'DCOneHi' })
    let dconeblock.tinteditor = tint1editor
    let dconeblock.shadeeditor = shade1editor

    let dctwoblock = colorblock.clone().init({ 'hiname' : 'DCTwoHi' })
    let dctwoblock.tinteditor = tint2editor
    let dctwoblock.shadeeditor = shade2editor

    let dcbaseblock = colorblock.clone().init({ 'hiname' : 'DCBaseHi'})

    let dcthreeblock = colorblock.clone().init({ 'hiname' : 'DCThreeHi' })
    let dcthreeblock.tinteditor = tint3editor
    let dcthreeblock.shadeeditor = shade3editor

    let dcfourblock = colorblock.clone().init({ 'hiname' : 'DCFourHi' })
    let dcfourblock.tinteditor = tint4editor
    let dcfourblock.shadeeditor = shade4editor

    let dcdraction = forms#newAction({ 'execute': function("CCDeckRowAction")})
    let dcdraction.blocks = [
                                      \ dconeblock,
                                      \ dctwoblock,
                                      \ dcbaseblock,
                                      \ dcthreeblock,
                                      \ dcfourblock
                                      \ ]

    " comp-minus
    let dc_moneblock = colorblock.clone().init({ 'hiname' : 'DC_MOneHi' })
    let dc_moneblock.tinteditor = tint1editor
    let dc_moneblock.shadeeditor = shade1editor

    let dc_mtwoblock = colorblock.clone().init({ 'hiname' : 'DC_MTwoHi' })
    let dc_mtwoblock.tinteditor = tint2editor
    let dc_mtwoblock.shadeeditor = shade2editor

    let dc_mbaseblock = colorblock.clone().init({ 'hiname' : 'DC_MBaseHi'})

    let dc_mthreeblock = colorblock.clone().init({ 'hiname' : 'DC_MThreeHi' })
    let dc_mthreeblock.tinteditor = tint3editor
    let dc_mthreeblock.shadeeditor = shade3editor

    let dc_mfourblock = colorblock.clone().init({ 'hiname' : 'DC_MFourHi' })
    let dc_mfourblock.tinteditor = tint4editor
    let dc_mfourblock.shadeeditor = shade4editor

    let dc_mdraction = forms#newAction({ 'execute': function("CCDeckRowAction")})
    let dc_mdraction.blocks = [
                                      \ dc_moneblock,
                                      \ dc_mtwoblock,
                                      \ dc_mbaseblock,
                                      \ dc_mthreeblock,
                                      \ dc_mfourblock
                                      \ ]

    function! DCCComplimentaryAction(...) dict
" call forms#log("DCCComplimentaryAction.execute: TOP")
      let rn = a:1
      let gn = a:2
      let bn = a:3

      call self.dcmmonochromaticdraction.execute(rn, gn, bn)

      let shift = g:doubleComplimentaryShiftInit
      let [m,c,cm] = g:ColorUtil().DoubleContrastRGBusingHSV(shift, rn, gn, bn)
      let [mrn,mgn,mbn] = m
      let [crn,cgn,cbn] = c
      let [cmrn,cmgn,cmbn] = cm

      " minus
      call self.dmdraction.execute(mrn, mgn, mbn)
      " comp
      call self.dcdraction.execute(crn, cgn, cbn)
      " comp-minus
      call self.dc_mdraction.execute(cmrn, cmgn, cmbn)

" call forms#log("DCCComplimentaryAction.execute: BOTTOM")
    endfunction
    let dcomplimentaryaction = forms#newAction({ 'execute': function("DCCComplimentaryAction")})
    let dcomplimentaryaction.dcmmonochromaticdraction = dcmmonochromaticdraction
    let dcomplimentaryaction.dmdraction = dmdraction
    let dcomplimentaryaction.dcdraction = dcdraction
    let dcomplimentaryaction.dc_mdraction = dc_mdraction

    call add(deckaction.palletactions, dcomplimentaryaction)
    call add(adjusteraction.palletactions, dcomplimentaryaction)

    let vspace = forms#newVSpace({'size': 1})
    let dcmonochromhpoly = forms#newHPoly({ 'children': [
                                        \ dcmoneblock, 
                                        \ vspace, 
                                        \ dcmtwoblock, 
                                        \ vspace, 
                                        \ dcmbaseblock, 
                                        \ vspace, 
                                        \ dcmthreeblock, 
                                        \ vspace, 
                                        \ dcmfourblock], 
                                        \ 'alignment': 'C' })
    let dmomplimenthpoly = forms#newHPoly({ 'children': [
                                        \ dmoneblock, 
                                        \ vspace, 
                                        \ dmtwoblock, 
                                        \ vspace, 
                                        \ dmbaseblock, 
                                        \ vspace, 
                                        \ dmthreeblock, 
                                        \ vspace, 
                                        \ dmfourblock], 
                                        \ 'alignment': 'C' })
    let dcomplimenthpoly = forms#newHPoly({ 'children': [
                                        \ dconeblock, 
                                        \ vspace, 
                                        \ dctwoblock, 
                                        \ vspace, 
                                        \ dcbaseblock, 
                                        \ vspace, 
                                        \ dcthreeblock, 
                                        \ vspace, 
                                        \ dcfourblock], 
                                        \ 'alignment': 'C' })
    let dc_monochromhpoly = forms#newHPoly({ 'children': [
                                        \ dc_moneblock, 
                                        \ vspace, 
                                        \ dc_mtwoblock, 
                                        \ vspace, 
                                        \ dc_mbaseblock, 
                                        \ vspace, 
                                        \ dc_mthreeblock, 
                                        \ vspace, 
                                        \ dc_mfourblock], 
                                        \ 'alignment': 'C' })

    let dcomplimentbpoly = forms#newVPoly({ 'children': [
                                        \ dcmonochromhpoly, 
                                        \ hspace, 
                                        \ dmomplimenthpoly, 
                                        \ hspace, 
                                        \ dcomplimenthpoly, 
                                        \ hspace, 
                                        \ dc_monochromhpoly], 
                                        \ 'alignment': 'C' })


    "....................
    let deck = forms#newDeck({ 'children': [
                                      \ monochromhpoly, 
                                      \ complimentbpoly, 
                                      \ scomplimentbpoly, 
                                      \ acomplimentbpoly, 
                                      \ aacomplimentbpoly, 
                                      \ tcomplimentbpoly, 
                                      \ dcomplimentbpoly]
                                      \ })

    let deckaction.deck = deck 
    let comboboxaction.deck = deck
    let adjusteraction.deck = deck

    "....................
    let vspace = forms#newVSpace({'size': 1})
    let pallethpoly = forms#newHPoly({ 'children': [
                                        \ adjustergrid, 
                                        \ vspace, 
                                        \ deck], 
                                        \ 'alignment': 'T' })

    let hspace = forms#newHSpace({'size': 1})
    let ivpoly = forms#newVPoly({ 'children': [
                                        \ popdownlist, 
                                        \ hspace, 
                                        \ pallethpoly], 
                                        \ 'alignment': 'C' })

    let title = forms#newLabel({'text': "Pallet Designer"})
    let topvpoly = forms#newVPoly({ 'children': [
                                        \ title, 
                                        \ hpoly, 
                                        \ ivpoly, 
                                        \ buttonhpoly], 
                                        \ 'mode': 'light',
                                        \ 'alignments': [[0,'C']],
                                        \ 'alignment': 'C' })
  endif

  let b = forms#newBorder({ 'body': topvpoly })
  let bg = forms#newBackground({ 'body': b} )
  let form = forms#newForm({'body': bg })
  let results = form.run()
  if type(results) == g:self#DICTIONARY_TYPE
call forms#log("ColorChooser: results=" . string(results))
  endif
endfunction



"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX















map <Leader>s6 :call TestRGB2HSL()<CR>
function! TestRGB2HSL() 
call forms#log("TestRGB2HSL TOP")

  let rgbtxt = "000000"
call forms#log("TestRGB2HSL rgbtxt=".rgbtxt)
  let hsl = g:ColorUtil().ConvertRGB2HSL(rgbtxt)
call forms#log("TestRGB2HSL hsl=".string(hsl))
  let rgb = g:ColorUtil().ConvertHSL2RGB(hsl[0], hsl[1], hsl[2])
call forms#log("TestRGB2HSL rgb=".string(rgb))

  let rgbtxt = "ffffff"
call forms#log("TestRGB2HSL rgbtxt=".rgbtxt)
  let hsl = g:ColorUtil().ConvertRGB2HSL(rgbtxt)
call forms#log("TestRGB2HSL hsl=".string(hsl))
  let rgb = g:ColorUtil().ConvertHSL2RGB(hsl[0], hsl[1], hsl[2])
call forms#log("TestRGB2HSL rgb=".string(rgb))

  let rgbtxt = "a0a0a0"
call forms#log("TestRGB2HSL rgbtxt=".rgbtxt)
  let hsl = g:ColorUtil().ConvertRGB2HSL(rgbtxt)
call forms#log("TestRGB2HSL hsl=".string(hsl))
  let rgb = g:ColorUtil().ConvertHSL2RGB(hsl[0], hsl[1], hsl[2])
call forms#log("TestRGB2HSL rgb=".string(rgb))

  let rgbtxt = "a000a0"
call forms#log("TestRGB2HSL rgbtxt=".rgbtxt)
  let hsl = g:ColorUtil().ConvertRGB2HSL(rgbtxt)
call forms#log("TestRGB2HSL hsl=".string(hsl))
  let h = hsl[0]
  let s = hsl[1]
  let l = hsl[2]
  let hs = printf("%f",(h*360))
  let ss = printf("%f",(s*100))
  let ls = printf("%f",(l*100))
call forms#log("TestRGB2HSL hsl=".hs." ".ss." ".ls)
  let rgb = g:ColorUtil().ConvertHSL2RGB(hsl[0], hsl[1], hsl[2])
call forms#log("TestRGB2HSL rgb=".string(rgb))

"iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
  " let rgbtxt = "DC4678"
  let rgbtxt = "OOFF33"
call forms#log("TestRGB2HSL rgbtxt=".rgbtxt)
  let hsl = g:ColorUtil().ConvertRGB2HSL(rgbtxt)
call forms#log("TestRGB2HSL hsl=".string(hsl))
  let h = hsl[0]
  let s = hsl[1]
  let l = hsl[2]
  let hs = printf("%f",(h*360))
  let ss = printf("%f",(s*100))
  let ls = printf("%f",(l*100))
call forms#log("TestRGB2HSL hsl=".hs." ".ss." ".ls)
  let rgb = g:ColorUtil().ConvertHSL2RGB(hsl[0], hsl[1], hsl[2])
call forms#log("TestRGB2HSL rgb=".string(rgb))
  let rgbnc = g:ColorUtil().ComplimentRGBusingHSL(rgbtxt)
call forms#log("TestRGB2HSL rgbnc=".string(rgbnc))
  let rn = float2nr(rgbnc[0])
  let gn = float2nr(rgbnc[1])
  let bn = float2nr(rgbnc[2])
  let a = printf('%02x%02x%02x',rn,gn,bn)
call forms#log("TestRGB2HSL rgbc=".a)

  let hsv = g:ColorUtil().ConvertRGB2HSV(rgbtxt)
call forms#log("TestRGB2HSL hsv=".string(hsv))
  let h = hsv[0]
  let s = hsv[1]
  let v = hsv[2]
  let hs = printf("%f",(h*360))
  let ss = printf("%f",(s*100))
  let vs = printf("%f",(v*100))
call forms#log("TestRGB2HSL hsv=".hs." ".ss." ".vs)
  let rgb = g:ColorUtil().ConvertHSV2RGB(hsv[0], hsv[1], hsv[2])
call forms#log("TestRGB2HSL rgb=".string(rgb))
  let rgbnc = g:ColorUtil().ComplimentRGBusingHSV(rgbtxt)
call forms#log("TestRGB2HSL rgbnc=".string(rgbnc))
  let rn = float2nr(rgbnc[0])
  let gn = float2nr(rgbnc[1])
  let bn = float2nr(rgbnc[2])
  let a = printf('%02x%02x%02x',rn,gn,bn)
call forms#log("TestRGB2HSL rgbc=".a)

endfunction




" text editor
map <Leader>t0 :call MakeFormw0()<CR>
function! MakeFormt0() 
call forms#log("MakeFormt0 TOP")
  let attrs = {
        \ 'init_text' : 'init text'
        \ }
  let texteditor = forms#newTextEditor(attrs)
  let b = forms#newBorder({ 'body': texteditor })
  let bg = forms#newBackground({ 'body': b} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction


" field editors within viewers and button
map <Leader>v1 :call MakeFormv1()<CR>
function! MakeFormv1() 
call forms#log("MakeFormv1 TOP")

  let attrs = {'size': 15 }

  let attrs['init_text'] = "oneone"
  let txtEditor11 = forms#newFixedLengthField(attrs)
  let b11 = forms#newBorder({ 'body': txtEditor11 })

  let attrs['init_text'] = "onetwo"
  let txtEditor12 = forms#newFixedLengthField(attrs)
  let b12 = forms#newBorder({ 'body': txtEditor12 })

  let vpoly1 = forms#newVPoly({ 'children': [b11, b12] })

  let viewer1 = forms#newViewer({'body': vpoly1 })

if 0
  function! G2Action(...) dict
call forms#log("Action.execute")
    call forms#AppendInput(27)
  endfunction
  let action = forms#newAction({ 'execute': function("G2Action")})
endif

  let label = forms#newLabel({'text': "Submit"})
  let button = forms#newButton({
                              \ 'tag': 'submit', 
                              \ 'body': label, 
                              \ 'action': g:forms#submitAction})
  let b = forms#newBorder({ 'body': button })

  let attrs['init_text'] = "twoone"
  let txtEditor21 = forms#newFixedLengthField(attrs)
  let b21 = forms#newBorder({ 'body': txtEditor21 })

  let attrs['init_text'] = "twotwo"
  let txtEditor22 = forms#newFixedLengthField(attrs)
  let b22 = forms#newBorder({ 'body': txtEditor22 })
  let vpoly2 = forms#newVPoly({ 'children': [b21, b22] })

  let viewer2 = forms#newViewer({'body': vpoly2 })

  let hpoly = forms#newHPoly({ 'children': [viewer1, b, viewer2], 'alignment': 'T' })
  let bg = forms#newBackground({ 'body': hpoly} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction


" field editors within viewers and button
map <Leader>v2 :call MakeFormv2()<CR>
function! MakeFormv2() 
call forms#log("MakeFormv2 TOP")

  let attrs = {'size': 15 }

  let attrs['init_text'] = "oneone"
  let txtEditor11 = forms#newFixedLengthField(attrs)
  let b11 = forms#newBorder({ 'body': txtEditor11 })

  let attrs['init_text'] = "onetwo"
  let txtEditor12 = forms#newFixedLengthField(attrs)
  let b12 = forms#newBorder({ 'body': txtEditor12 })

  let vpoly1 = forms#newVPoly({ 'children': [b11, b12] })

  let viewer1 = forms#newViewer({'body': vpoly1 })

if 0
  function! V2Action(...) dict
call forms#log("Action.execute")
    call forms#AppendInput(27)
  endfunction
  let action = forms#newAction({ 'execute': function("V2Action")})
endif

  let label = forms#newLabel({'text': "Submit"})
  let button = forms#newButton({ 
                              \ 'tag': 'submit',  
                              \ 'body': label,  
                              \ 'action': g:forms#submitAction})
  let b = forms#newBorder({ 'body': button })

  let attrs['init_text'] = "twoone"
  let txtEditor21 = forms#newFixedLengthField(attrs)
  let b21 = forms#newBorder({ 'body': txtEditor21 })

  let attrs['init_text'] = "twotwo"
  let txtEditor22 = forms#newFixedLengthField(attrs)
  let b22 = forms#newBorder({ 'body': txtEditor22 })
  let vpoly2 = forms#newVPoly({ 'children': [b21, b22] })

  let viewer2 = forms#newViewer({'body': vpoly2 })

  let hpoly = forms#newHPoly({ 'children': [viewer1, b, viewer2], 'alignment': 'T' })
  let bg = forms#newBackground({ 'body': hpoly} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction


" labels in deck (only first label visible)
map <Leader>v3 :call MakeFormv3()<CR>
function! MakeFormv3() 
call forms#log("MakeFormv3 TOP")
  let l1 = forms#newLabel({'text': "label one"})
  let l2 = forms#newLabel({'text': "label two"})
  let l3 = forms#newLabel({'text': "label three"})

  let deck = forms#newDeck({ 'children': [l1, l2, l3] })
  let bg = forms#newBackground({ 'body': deck} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction


" seleectlist and labels in deck 
map <Leader>v4 :call MakeFormv4()<CR>
function! MakeFormv4() 
call forms#log("MakeFormv4 TOP")
  let l1 = forms#newLabel({'text': "label one"})
  let l2 = forms#newLabel({'text': "label two"})
  let l3 = forms#newLabel({'text': "label three"})
  let l4 = forms#newLabel({'text': "label four"})

  let deck = forms#newDeck({ 'children': [l1, l2, l3, l4] })

  function! V4Action(...) dict
    let pos = a:1
call forms#log("V4Action.execute: " . pos)
    call self.deck.setCard(pos)
  endfunction
  let action = forms#newAction({ 'execute': function("V4Action")})
  let action['deck'] = deck

  let attrs = { 'mode': 'single',
              \ 'pos': 0,
              \ 'choices': [
              \ ["one", 1],
              \ ["two", 2],
              \ ["three", 3],
              \ ["four", 4]
              \ ], 'size': 4,
              \ 'on_selection_action': action
              \ }
  let slist = forms#newSelectList(attrs)
  let b = forms#newBorder({ 'body': slist, 'char': ' ' })

  let hpoly = forms#newHPoly({ 'children': [b, deck], 'alignment': 'T' })
  let bg = forms#newBackground({ 'body': hpoly} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction


" seleectlist and vertical labels in deck 
map <Leader>v5 :call MakeFormv5()<CR>
function! MakeFormv5() 
call forms#log("MakeFormv5 TOP")
  let l1 = forms#newVLabel({'text': "label one"})
  let bl1 = forms#newBorder({ 'body': l1 })
  let l2 = forms#newVLabel({'text': "label two"})
  let bl2 = forms#newBorder({ 'body': l2 })
  let l3 = forms#newVLabel({'text': "label three"})
  let bl3 = forms#newBorder({ 'body': l3 })

  let deck = forms#newDeck({ 'children': [bl1, bl2, bl3] })

  function! V5Action(...) dict
    let pos = a:1
call forms#log("V5Action.execute: " . pos)
    call self.deck.setCard(pos)
  endfunction
  let action = forms#newAction({ 'execute': function("V5Action")})
  let action['deck'] = deck

  let attrs = { 'mode': 'single',
          \ 'pos': 0,
          \ 'choices': [
          \ ["one", 1],
          \ ["two", 2],
          \ ["three", 3]
          \ ],
          \ 'on_selection_action': action
          \ }
  let slist = forms#newSelectList(attrs)
  let b = forms#newBorder({ 'body': slist })

  let hpoly = forms#newHPoly({ 'children': [b, deck], 'alignment': 'T' })
  let bg = forms#newBackground({ 'body': hpoly} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction


" label, buttons controling status and cancel button
" very informational
map <Leader>v6 :call ReSizeTestv6()<CR>
function! ReSizeTestv6() 
call forms#log("ReSizeTestv6 TOP")

  let attrs = { 'text': 'A Label: What is my Status', 'status': g:IS_ENABLED}
  let l = forms#newLabel(attrs)

  function! V6Action(...) dict
call forms#log("V6Action.execute")
    let glyph = self.glyph
    let lstatus = glyph.__status
call forms#log("V6Action.execute lstatus=" . lstatus)

    if lstatus == g:IS_ENABLED
      call glyph.setStatus(g:IS_DISABLED)
    elseif lstatus == g:IS_DISABLED
      call glyph.setStatus(g:IS_INVISIBLE)
    else
      call glyph.setStatus(g:IS_ENABLED)
    endif
  endfunction

  let statuschangelabel = forms#newAction({ 'execute': function("V6Action")})
  let statuschangelabel.glyph = l
  let attrs = { 'text': 'Change Label Status'}
  let slabel = forms#newLabel(attrs)
  let restatuslabel = forms#newButton({ 
                              \ 'tag': 'restatuslabel',  
                              \ 'body': slabel,  
                              \ 'action': statuschangelabel})


  let attrs = { 'text': 'Cancel'}
  let cancellabel = forms#newLabel(attrs)
  let cancelbutton = forms#newButton({
                              \ 'tag': 'cancel', 
                              \ 'body': cancellabel, 
                              \ 'action': g:forms#cancelAction})

  let statuschangecancel = forms#newAction({ 'execute': function("V6Action")})
  let statuschangecancel.glyph = cancelbutton
  let attrs = { 'text': 'Change Cancel Status'}
  let clabel = forms#newLabel(attrs)
  let restatuscancel = forms#newButton({ 
                              \ 'tag': 'restatuscancel',  
                              \ 'body': clabel,  
                              \ 'action': statuschangecancel})

  let vpoly = forms#newVPoly({ 'children': [l, restatuslabel, restatuscancel, cancelbutton] })

  let bg = forms#newBackground({ 'body': vpoly })
  let form = forms#newForm({'body': bg })
  call form.run()
endfunction


