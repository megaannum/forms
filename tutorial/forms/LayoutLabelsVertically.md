# Layout Labels Vertially

A VPoly is a type of Poly that lays out its children Glyphs vertically.
A Poly has a 'children' attribute which takes a List of Glyphs. The VPoly
being also a Poly also has the same 'children' attribute.

    let vpoly = forms#newVPoly({'children': [
                            \ glyph_child_one,
                            \ glyph_child_two,
                            \ glyph_child_three
                            \ ]})

In this case, the child Glyphs are all to be Labels.

    let attrs = {'text': 'Top label is longer that all the reset'}
    let labelOne = forms#newLabel(attrs)

    let attrs = {'text': 'Middle Label'}
    let labelTwo = forms#newLabel(attrs)

    let attrs = {'text': 'Bottom Label'}
    let labelThree = forms#newLabel(attrs)

The first label, labelOne is wider than all the reset and so the VPoly
with have the same width as labelOne.

Creating a VPoly with these three Labels would be done as follows:

    let vpoly = forms#newVPoly({'children': [
                            \ labelOne,
                            \ labelTwo,
                            \ labelThree
                            \ ]})

If this were to be displayed, the text of the labels would one right
above the next; rather cluttered. So, one can add a VSpace between
each Label to give them some separation.

The VSpace is of type Space which takes a Number attribute called 'size',
the number of character cells the Space will occupy. In our case, we will
make the size 1 to give some vertical separation.

    let vspace = forms#newVSpace({'size': 1})

So, the VPoly becomes:

    let vpoly = forms#newVPoly({'children': [
                            \ labelOne,
                            \ vspace,
                            \ labelTwo,
                            \ vspace,
                            \ labelThree
                            \ ]})


As an addition, we would like to have the default alignment for the VPoly
to be 'center', for the second Label to be 'left' aligned and the
bottom Label to be 'right' aligned.

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

The VPoly is now placed into the Form as its sole child Glyph, as
the value of the Form Glyph's 'body' attribute:

    let form = forms#newForm({'body': vpoly })

Then, the Form's 'run()' method is called:

    call form.run()

This code is placed into a function:

    function!  forms#tutorial#layout_labels_vertically#Make()
      " label code
    endfunction

The full code can be found in: [Layout Labels Vertially](https://github.com/megaannum/forms/blob/master/autoload/forms/tutorial/layout_labels_vertically.vim)

To run the label code, source the layout_labels_vertically.vim file and then enter

    :call forms#tutorial#layout_labels_vertically#Make()

on the command line.
