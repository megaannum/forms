
"---------------------------------------------------------------------------
" forms#tutorial#label#Make() 
"   Create a simple Label in a Form.
"
"  parameters: None
"---------------------------------------------------------------------------
function! forms#tutorial#label#Make()
  let attrs = {'text': 'My First Label'}
  let label = forms#newLabel(attrs)

  let form = forms#newForm({'body': label })
  function! form.purpose() dict
    return "This is Help associated with the Label Tutorial Form."
  endfunction

  call form.run()
endfunction
