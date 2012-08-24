# Code Structure

To create a Form, one starts with the Function that will encapsulate the code:

    function! forms#tutorial#do_nothing_form#Make() 
        " form code
    endfunction

The Function is defined so that it can be reloaded using the '!'
character at the end of 'function'. This is useful during development
so that you can reload the code without having to exit/re-enter Vim.

It is also possible to do the same by explicitly deleting the
function using 'delfunction' and then re-sourcing the file.

A Form Glyph is a Viewer Glyph which, in turn, is a Mono Glyph, so
the Form Glyph during construction must be passed a child Glyph. In this
case, we will pass it the Null Glyph. The Null Glyph does nothing; it 
is a Leaf Glyph with no size and draw nothing in the window,

    function! forms#tutorial#do_nothing_form#Make() 
        let body = forms#newNullGlyph({})
        " more form code
    endfunction

An empty Dictionary is passed as the argument to create the Null Glyph
since it has no attributes (strictly speaking, the Null Glyph does
have the attributes that any Self object has, such as a 'tag', but
it has no attributes that actually are needed to define its 
behavior - it has none, or its display - it has none).

This body Glyph is then passed into the Form constructor as its
child Glyph:

    function! forms#tutorial#do_nothing_form#Make() 
        let body = forms#newNullGlyph({})
        let form = forms#newForm({'body': body})
        " more form code
    endfunction

Once a Form is create, its 'run()' method must be called in order for it
to be displayed and handle user input:

    function! forms#tutorial#do_nothing_form#Make() 
        let body = forms#newNullGlyph({})
        let form = forms#newForm({'body': body})
        call form.run()
    endfunction

So, the Form is running. Of course, since its body is a Null Glyph,
nothing is displayed.

The fact that the Null Glyph handles no Events, its a non-interactive
Glyph, can not get (Event) focus, does not mean that all user input
is ignored by the Form. There are some user character/mouse inputs
that the Form its self responses to. 

One such character, in particular, is very relevant for this Form and that 
is the &lt;Esc> character. To stop this Form from running, since it has 
no explicit 'close' or 'submit' Button, is to press the &lt;Esc> key.

The &lt;Cntl-H> keyboard entry is also handled by the Form. It the way of
invoking context-sensitive-help from the keyboard. Any 'purpose' information
associated with the Form will be displayed in an information dialog.

Additionally, the Form responds to a &lt;RightMouse> click. Like the keyboard
&lt;Cntl-H>, this will display Form context-sensitive-help. If
the mouse click was over an interactive Glyph, a Glyph that can have 
focus, then, both Glyph usage Help is displayed and any purpose Help 
associated with the Glyph is also displayed.
In this case, since the do-nothing Form has no footprint in the window,
it has now width or height, it can not be the target of a mouse click.

The full code for this do-nothing Form can be found in: [Do Nothing Form](https://github.com/megaannum/forms/blob/master/autoload/forms/tutorial/do_nothing_form.vim)

This do-nothing Form can be run by entering:

    :call forms#tutorial#do_nothing_form#Make()

on the command line.

