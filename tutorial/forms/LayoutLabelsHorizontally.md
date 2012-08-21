# Layout Labels Horizontally

A HPoly is a type of Poly that lays out its children Glyphs horizontally.
A Poly has a 'children' attribute which takes a List of Glyphs. The HPoly
being also a Poly also has the same 'children' attribute.

    let hpoly = forms#newHPoly({'children': [
                            \ glyph_child_one,
                            \ glyph_child_two,
                            \ glyph_child_three
                            \ ]})

In this case, the child Glyphs are all to be Labels.

    let attrs = {'text': 'Label One'}
    let labelOne = forms#newLabel(attrs)

    let attrs = {'text': 'Label Two'}
    let labelTwo = forms#newLabel(attrs)

    let attrs = {'text': 'Label Three'}
    let labelThree = forms#newLabel(attrs)

Creating a HPoly with these three Labels would be done as follows:

    let hpoly = forms#newHPoly({'children': [
                            \ labelOne,
                            \ labelTwo,
                            \ labelThree
                            \ ]})

If this were to be displayed, the text of the labels would be right next
to each other so one would not know that there were actually three labels
being presented. One way to make this distinction is to add two spaces
between each Label. To do this we use a HSpace Glyph. 

The HSpace is of type Space which takes a Number attribute called 'size',
the number of character cells the Space will occupy. In our case, we will
make the size 2 so that one can tell that there are three Labels.

    let hspace = forms#newHSpace({'size': 2})

So, the HPoly becomes:

    let hpoly = forms#newHPoly({'children': [
                            \ labelOne,
                            \ hspace,
                            \ labelTwo,
                            \ hspace,
                            \ labelThree
                            \ ]})

Notice that the hspace is used twice in the HPoly - it is a child of the
HPoly two times. A Space is a type of Glyph that is allowed to appear
more than once in a Glyph hierarchy as covered in the section 
[Glyph Overview](https://github.com/megaannum/forms/blob/master/tutorial/forms/GlyphOverview.md)

An alternate way of configuring the HPoly is to create a children list
and add each Label as it is create (and the HSpaces as appropriate):

    let children = []

    let hspace = forms#newHSpace({'size': 2})

    let attrs = {'text': 'Label One'}
    let labelOne = forms#newLabel(attrs)

    call add(children, labelOne)
    call add(children, hspace)

    let attrs = {'text': 'Label Two'}
    let labelTwo = forms#newLabel(attrs)

    call add(children, labelTwo)
    call add(children, hspace)

    let attrs = {'text': 'Label Three'}
    let labelThree = forms#newLabel(attrs)

    call add(children, labelThree)

Then, simply create the HPoly with the children List object:

    let hpoly = forms#newHPoly({'children': children})

The HPoly is now placed into the Form as its sole child Glyph, as
the value of the Form Glyph's 'body' attribute:

    let form = forms#newForm({'body': hpoly })

Then, the Form's 'run()' method is called:

    call form.run()

This code is placed into a function:

    function!  forms#tutorial#layout_labels_horizontally#Make()
      " label code
    endfunction

The full code can be found in: [Layout Labels Horizontally](https://github.com/megaannum/forms/blob/master/autoload/forms/tutorial/layout_labels_horizontally.vim)

To run the label code, source the layout_labels_horizontally.vim file and then enter

    :call forms#tutorial#layout_labels_horizontally#Make()

on the command line.
