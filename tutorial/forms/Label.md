# Tutorial: Label

A Label is a simple, non-iteractive Glyph that takes a single attribute, 'text'
which is the String to be displayed. A Label prototype is a Leaf Glyph, thus,
a Label has no Glyph children.

All Glyphs with constructor functions, functions that look like:

    let glyph = forms#newGlyphName(attrs)

where "GlyphName" is the name of the Glyph type to create, take as a
parameter a Dictionary of attribute names and values. In the case of
a Label Glyph, there is only the 'text' attribute:

    let attrs = {'text': 'My First Label'}
    let label = forms#newLabel(attrs)

an alternate way of writting this is:

    let label = forms#newLabel({'text': 'My First Label'})

The Label is now placed into the Form as its sole child Glyph, as
the value of the Form Glyph's 'body' attribute:

    let form = forms#newForm({'body': label })

Then, the Form's 'run()' method is called:

    call form.run()

This code is placed into a function:

    function! forms#tutorial#label#Make()
      " label code
    endfunction

The full code for the Label can be found in: [Label](https://github.com/megaannum/forms/blob/master/autoload/forms/tutorial/label.vim)

To run the label code, source the label.vim file and then enter

    :call forms#tutorial#label#Make()

on the command line.

