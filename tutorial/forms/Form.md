# Form

A Form Glyph is a kind of Viewer Glyph.

The Form Glyph's 'run()' method is responsible for:

* Saving Vim's current state,
* Making sure an appropriate font is used,
* Determining if the form can fit in the current window,
* Determining where to place in form in the window,
* Saving the current text in the window where the form will be rendered,
* Making sure that the area where the form will be rendered is "adequate"
   and if it is not making it "adequate",
* Doing a top-down size request of the Form's child,
* Calling the Form's Viewer's 'run()' method,
* Processing the Form's Viewer's 'run()' method return value,
* Restoring the original text in the window,
* Restoring the original font,
* Restoring the original Vim state, and, if appropriate, 
* Returning a value to the calling code.

## Saving Vim's current state,

During this part of the Form 'run()' method, the existing Vim
state is saved - specifically:

* Option values.
* The matches returned by 'getmatches()' then then 'clearmatches()' is 
   called.
* The value of '&mouse' is saved and then 'mouse' is set to 'a'.
* The value of '&wrap' is saved and then 'set nowrap' is executed.
* Both '&scrolloff' and '&sidescrolloff' are saved and then both are
   set to zero.

Then, if the Viewer Stack is empty, meaning that this is the top-level
Form, then the following are saved:

* Both '&syntax' and 'b:current_syntax' are saved and 'syntax' is set
   to empty and 'syntax clear' is executed.
* If 'gui_running' is true, then '&guifont' is save and then 'guifont'
   is set to the value of 'g:forms_gui_font' which has default value
   'Fixed 20'.
* The result of calling 'winsaveview()' is saved.
* And, finally, code is executed to make sure the undo list is not empty: 
   ' execute ":normal G$a "', and temp-file is gotten and the
   undo list is written to that file (using wundo).

## Can Window hold Form

By calling 'requestSize()' on the Form's child Glyph, the size of the
form to be rendered is gotten. This is a List containing the width and
height of the Form. It should be noted that **ALL** Forms are rectangular.
Next, the line at the top-of-the-window
is determined as well as the number of lines in the window and the 
number of columns. If the form can fit within the window, all is good.
If not, then if an error information Form can be displayed to the
user, then it is displayed. Otherwise, an exception is throw containing
the same message that the error Form would have displayed.

## Saving Current Text

A Form overwrites existing text so it is important to save the original
text in the window, if there is any, so that it can be restored when
the Form exits.

It is also important to provide a field of characters, whether part of
the original text or new lines of characters, so that when the Form
renders all of the Vim draw command are replacing or substituting over
existing text. If for some line/column positions there are characters
while for others the are none, it is more difficult to assure that
all of the Form renders correctly. Think of it as adding 
[Gesso](https://en.wikipedia.org/wiki/Gesso) over a canvas in order to
provide a uniform surface.

So, prior to rendering the Form, the area where the Form is to be
rendered must be saved and then all the lines must be at least the
width of the right side of the Form and no line should wrap.
There, one of Form's secret sauce is out.


## Initial Rendering of Form 

The Form must be rendered to the window. This is done by calling
the Form's child Glyph's 'draw(allocation)' passing it the top-level
Form allocation:

    let allocation = {
                    \ 'line': top_line_of_form,
                    \ 'column': left_column_of_form,
                    \ 'width': width_of_form,
                    \ 'height': height_of_form
                    \ }

As each descendent Glyph calls its children to draw, they pass down an
allocation Dictionary. If the parent Glyph has a single child Glyph and
they both have the same size and position, such as the Background Glyph,
then the same allocation can be passed from parent to child. But, 
generally and its safer, to pass down a copy. If the allocation
has to be modified by the parent to give to a child, the it is
important to make a copy. Each Glyph caches the allocation it receives
in its 'draw(allocation)' method. Many Glyph reuse this allocation
in other methods and a non-empty allocation is the means used to
determine if a Glyph has been rendered at least once.


## Calling 'run()' Method

A Form Glyph is a Viewer Glyph; the Form 'run()' method calls the Viewer 'run()'
method. The Viewer 'run()' method returns one of the following Event types:

* Exit: Character <Esc> maps to 'Exit' and Form returns empty Dictionary.
* ReSize: The size of the form has changed, the window text is recaptured and the Viewer 'run()' method is called again. 
* Command: A command to execute on the command-line, and an empty Dictionary is
returned.
* Submit: Form descendent Glyphs add tag/values to Dictionary returned.
* Cancel; Similar to 'Exit', the Form returns empty Dictionary.

## Returning Cleanup

Everything that was saved and set in preparation to call the Viewer 'run()'
method is now restored and unset. The original captured text is restored
to the window. If lines had to be added, they are removed. All of the
highlights attached to all of the Form's dependences are deleted.
If the Form's 'delete' attribute is 'true', then the child body of the Form
has its 'delete()' method call which enables Glyphs to do any Glyph
particular cleanup.

The original syntax settings are restored.

If the Viewer Stack is empty, then the original 'gui' font is restored.

The undo list is set using 'rundo' with the contents of the previously 
saved undo file. Also ":normal u" is executed to remove the space that
was originally inserted (making sure the undo list was not empty).

The view of the current window is restored by calling 'winrestview(saved_view)'.

If a command is to be executed, it is now evaluated.

And, finally, control is returned to the code that called the Form's 'run()' 
method with the Dictionary return value.
