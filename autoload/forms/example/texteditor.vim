
function! forms#example#texteditor#Make()
  let attrs = {
        \ 'init_text' : 'init text'
        \ }
  let texteditor = forms#newTextEditor(attrs)
  let b = forms#newBorder({ 'body': texteditor })
  let bg = forms#newBackground({ 'body': b} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction

function! forms#example#texteditor#MakeTest()
  call forms#AppendInput({'type': 'Sleep', 'time': 5})
  call forms#AppendInput({'type': 'Exit'})
  call forms#example#texteditor#Make()
endfunction
