# More Code Structure

In this example, a Form will created that has a couple of interactive
Glyphs (editor, group of toggle buttons and group of radio buttons)
which can generate data for the user. Then if 'Cancel'
is selected (or &lt;Esc> is pressed) no results will be returned. But,
if 'Submit' is selected, a Dictionary holding the Glyph tag names
as keys and the associated values will be echo to the command line.

Note that all of the interactive Glyphs have tag attributes that
can be used to identify the result data.

As has been done before, create a Function to hold the Form code:

    function! forms#tutorial#results#Make()
    endfunction

At the top of the Form create some instructional text:

    let attrs = {'textlines': "Enter Text\nSelect Buttons\nClick Cancel or Submit"}
    let text = forms#newText(attrs)

Now create an editor. It is in a Box with arched corners just to outline
the size of the editor.

    let editor = forms#newFixedLengthField({'tag': 'editor', 'size': 15})
    let editorbox = forms#newBox({'body': editor, 'mode': 'light_arc'})

Create a ButtonGroup of type 'forms#ToggleButton' and associated three
ToggleButtons with it. Note that the second ToggleButton has its 
'selected' attribute set as '1', meaning that on Form start, it will be
the selected ToggleButton. The ToggleButton are each placed in Boxes
just to add definition. The Boxes are then added to an HPoly.

    let group = forms#newButtonGroup({'member_kind': 'forms#ToggleButton'})
    let l1 = forms#newLabel({'text': "ONE"})
    let tb1 = forms#newToggleButton({'tag': 'tbone', 
                                    \ 'body': l1, 
                                    \ 'group': group})
    let b1 = forms#newBox({ 'body': tb1} )

    let l2 = forms#newLabel({'text': "TWO"})
    let tb2 = forms#newToggleButton({'tag': 'tbtwo', 
                                    \ 'body': l2, 
                                    \ 'selected': 1, 
                                    \ 'group': group})
    let b2 = forms#newBox({ 'body': tb2} )
                  
    let l3 = forms#newLabel({'text': "THREE"})
    let tb3 = forms#newToggleButton({'tag': 'tbthree', 
                                    \ 'body': l3, 
                                    \ 'group': group})
    let b3 = forms#newBox({ 'body': tb3} )
    let hpolytb = forms#newHPoly({ 
                               \ 'children': [b1, b2, b3], 
                               \ 'alignment': 'C' })

Now, create a ButtonGroup of type 'forms#RadioButton' and associated three
RadioButtons with it. This code is very similar to the ToggleButton code.
Here, it is the third RadioButton that is set as selected.

    let group = forms#newButtonGroup({ 'member_kind': 'forms#RadioButton'})
    let rb1 = forms#newRadioButton({'tag': 'rbone', 
                                    \ 'group': group})
    let b1 = forms#newBox({ 'body': rb1 })
    let rb2 = forms#newRadioButton({'tag': 'rbtwo', 
                                    \ 'group': group})
    let b2 = forms#newBox({ 'body': rb2 })
    let rb3 = forms#newRadioButton({'tag': 'rbthree', 
                                    \ 'selected': 1, 
                                    \ 'group': group})
    let b3 = forms#newBox({ 'body': rb3 })
    let hpolyrb = forms#newHPoly({ 'children': [b1, b2, b3] })

At the bottom of the Form are the 'Cancel' and 'Submit' Buttons.

    let attrs = { 'text': 'Cancel'}
    let cancellabel = forms#newLabel(attrs)
    let cancelbutton = forms#newButton({
                                        \ 'tag': 'cancel',
                                        \ 'body': cancellabel,
                                        \ 'action': g:forms#cancelAction})
    let attrs = { 'text': 'Submit'}
    let submitlabel = forms#newLabel(attrs)
    let submitbutton = forms#newButton({
                                        \ 'tag': 'submit',
                                        \ 'body': submitlabel,
                                        \ 'action': g:forms#submitAction})

    let hspace = forms#newHSpace({'size': 2})
    let hpolybuttons = forms#newHPoly({'children': 
                              \ [cancelbutton, hspace, submitbutton]})

Now we are ready to place all of the components into a VPoly.
A VPoly by default does a 'left' alignment. The HPoly holding the
'Cancel' and 'Submit' Buttons has been explicitly given a 'right'
alignment.

    let vspace = forms#newHSpace({'size': 1})
    let vpoly = forms#newVPoly({'children': [
                              \ text, 
                              \ vspace, 
                              \ editorbox, 
                              \ vspace, 
                              \ hpolytb,
                              \ vspace, 
                              \ hpolyrb,
                              \ vspace, 
                              \ hpolybuttons
                              \ ],
                              \ 'alignments': [[8, 'R']]
                              \ })

Put a Border around everything and place the Border in a Background.

    let border = forms#newBorder({ 'body': vpoly, 'size': 2 })
    let bg = forms#newBackground({ 'body': border })

Create the form.
    let form = forms#newForm({'body': bg })
    function! form.purpose() dict
      return "This is Help associated with the More Code Structure Tutorial Form."
    endfunction

Now, we capture the return value from the Form 'run()' method and if
it is of type Dictionary, that is, if the 'Submit' Button was pressed,
then echo the results to the command line.

    let results = form.run()
    if type(results) == g:self#DICTIONARY_TYPE
      echo "" . string(results)
    endif

Note that the results are a Dictionary of Glyph tag names and values.
Normally, code would be present to take the results and execute other
code using those results.


The full code for this do-nothing Form can be found in: [Results](https://github.com/megaannum/forms/blob/master/autoload/forms/tutorial/results.vim)

This Results Form can be run by entering:

    :call forms#tutorial#results#Make()

on the command line.

