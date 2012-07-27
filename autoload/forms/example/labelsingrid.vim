
function! forms#example#labelsingrid#Make()
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

