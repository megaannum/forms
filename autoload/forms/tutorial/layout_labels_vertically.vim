
"---------------------------------------------------------------------------
" forms#tutorial#layout_labels_vertically#Make() 
"   Create a row of 3 Labels in a form.
"
"  parameters: None
"---------------------------------------------------------------------------
function! forms#tutorial#layout_labels_vertically#Make()
    let attrs = {'text': 'Top label is longer that all the reset'}
    let labelOne = forms#newLabel(attrs)

    let attrs = {'text': 'Middle Label'}
    let labelTwo = forms#newLabel(attrs)

    let attrs = {'text': 'Bottom Label'}
    let labelThree = forms#newLabel(attrs)

    let vspace = forms#newVSpace({'size': 1})

    " Make default alignment 'center'
    " Then override for labelTwo aligning 'L'
    " and for labelThree aligning 'R'
    let vpoly = forms#newVPoly({'children': [
                            \ labelOne,
                            \ vspace,
                            \ labelTwo,
                            \ vspace,
                            \ labelThree
                            \ ],
                            \ 'alignment':'C',
                            \ 'alignments': [[2,'L'], [4,'R']]
                              })

    let form = forms#newForm({'body': vpoly })
    function! form.purpose() dict
      return "This is Help associated with the\nVertical Layout Label Tutorial Form."
    endfunction

    call form.run()
endfunction
