
function! forms#example#subform#Make()
  function! C8HelpAction(...) dict
    let nohelp = forms#newLabel({'text': "NO Help (return with <ESC>)"})
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

function! forms#example#subform#MakeTest()
  call forms#AppendInput({'type': 'Sleep', 'time': 5})
  call forms#AppendInput({'type': 'Exit'})
  call forms#example#subform#Make()
endfunction
