
"---------------------------------------------------------------------------
" forms#tutorial#layout_labels_horizontally#Make() 
"   Create a row of 3 Labels in a form.
"
"  parameters: None
"---------------------------------------------------------------------------
function! forms#tutorial#layout_labels_horizontally#Make()
    let attrs = {'text': 'Label One'}
    let labelOne = forms#newLabel(attrs)

    let attrs = {'text': 'Label Two'}
    let labelTwo = forms#newLabel(attrs)

    let attrs = {'text': 'Label Three'}
    let labelThree = forms#newLabel(attrs)

    let hspace = forms#newHSpace({'size': 2})

    let hpoly = forms#newHPoly({'children': [
                            \ labelOne,
                            \ hspace,
                            \ labelTwo,
                            \ hspace,
                            \ labelThree
                            \ ]})

    let form = forms#newForm({'body': hpoly })
    function! form.purpose() dict
      return "This is Help associated with the\nHorizontal Layout Label Tutorial Form."
    endfunction

    call form.run()
endfunction
