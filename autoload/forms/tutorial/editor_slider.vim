
"---------------------------------------------------------------------------
" forms#tutorial#editor_slider#Make() 
"   Create a FixedLengthField editor and Slider and wire them together
"     using Actions.
"
"  parameters: None
"---------------------------------------------------------------------------
function! forms#tutorial#editor_slider#Make()

    function! SliderActionFunc(...) dict
      " convert the slider Number value to String
      let value = "".a:1
      " set the editor's text with that value
      call self.editor.setText(value)
    endfunction

    function! EditorActionFunc(...) dict
      " convert editor String value to Number
      let value = a:1 + 0
      " attempt to set the slider's value
      try
        call self.hslider.setRangeValue(value)
      catch /.*/
        " handle error here: editor value out of range
      endtry
    endfunction

    let slideraction = forms#newAction({'execute': function("SliderActionFunc")})
    let editoraction = forms#newAction({'execute': function("EditorActionFunc")})
    let attrs = {
              \ 'size' : 32,
              \ 'tag' : 'hslider',
              \ 'resolution' : 4,
              \ 'on_move_action' : slideraction,
              \ 'range' : [0,255]
              \ }
    let hslider = forms#newHSlider(attrs)

    let editor = forms#newFixedLengthField({
                                    \ 'size': 3,
                                    \ 'tag' : 'editor',
                                    \ 'on_selection_action' : editoraction,
                                    \ 'init_text': '0'})

    let slideraction.editor = editor
    let editoraction.hslider = hslider

    let labeleditor = forms#newLabel({'text': 'Editor'})
    let hpolyeditor = forms#newHPoly({'children': [
                            \ labeleditor,
                            \ editor
                            \ ], 
                            \ 'mode': 'light'})

    let labelslider = forms#newLabel({'text': 'Slider'})
    let hpolyslider = forms#newHPoly({'children': [
                            \ labelslider,
                            \ hslider
                            \ ], 
                            \ 'mode': 'light'})

    let vpoly = forms#newVPoly({'children': [
                            \ hpolyeditor,
                            \ hpolyslider
                            \ ],
                            \ 'alignment': 'C',
                            \ 'mode': 'double'})

    let form = forms#newForm({'body': vpoly })
    call form.run()

endfunction
