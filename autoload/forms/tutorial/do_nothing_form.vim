
"---------------------------------------------------------------------------
" forms#tutorial#do_nothing_form#Make() 
"   A Form that does nothing: no display, no event handling
"
"  parameters: None
"---------------------------------------------------------------------------
function! forms#tutorial#do_nothing_form#Make() 
    let body = forms#newNullGlyph({})

    let form = forms#newForm({'body': body})
    function! form.purpose() dict
      return "This is Help associated with the Null Glyph Tutorial Form."
    endfunction

    call form.run()
endfunction
