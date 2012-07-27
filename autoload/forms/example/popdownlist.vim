
function! forms#example#popdownlist#Make()
  let attrs = {
        \ 'choices' : [
        \   ["ONE", 1],
        \   ["TWO", 2],
        \   ["THREE", 3]
        \ ]
        \ }
  let popdownlist = forms#newPopDownList(attrs)

  let box = forms#newBox({ 'body': popdownlist })
  let border = forms#newBorder({ 'body': box, 'size': 2 })
  let bg = forms#newBackground({ 'body': border} )
  let form = forms#newForm({'body': bg })
  call form.run()
endfunction

