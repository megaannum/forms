
function! forms#example#popdownlist#Make()
  let attrs = {
        \ 'choices' : [
        \   ["ONE", 1],
        \   ["TWO", 2],
        \   ["THREE", 3]
        \ ],
        \ 'pos' : 2
        \ }
  let popdownlist1 = forms#newPopDownList(attrs)
  let box1 = forms#newBox({ 'body': popdownlist1 })

  let attrs = {
        \ 'choices' : [
        \   ["ONE", 1],
        \   ["TWO", 2],
        \   ["THREE", 3],
        \   ["FOUR", 4],
        \   ["FIVE", 5],
        \   ["SIX", 6],
        \   ["SEVEN", 7],
        \   ["EIGHT", 8],
        \   ["NINE", 9],
        \   ["TEN", 10]
        \ ],
        \ 'size' : 4,
        \ 'pos' : 8
        \ }
  let popdownlist2 = forms#newPopDownList(attrs)
  let box2 = forms#newBox({ 'body': popdownlist2 })

  let hpoly = forms#newHPoly({'children': [box1, box2],
                           \ 'alignment': 'C' })

  let border = forms#newBorder({ 'body': hpoly, 'size': 2 })
  let bg = forms#newBackground({ 'body': border} )
  let form = forms#newForm({'body': bg })
  call form.run()
endfunction

function! forms#example#popdownlist#MakeTest()
  call forms#AppendInput({'type': 'Sleep', 'time': 5})
  call forms#AppendInput({'type': 'Exit'})
  call forms#example#popdownlist#Make()
endfunction
