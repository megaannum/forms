
" two editors in borders in fixed layout
function! forms#example#fixedlayout#Make()
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

