# Creating a new Glyph

## Minimum Methods

Since there already exists the 'null' Glyph (g:forms#NullGlyph)
that has no size and draws nothing, any Glyph a developer might
define needs to have both a size and renders something.

* requestedSize()
  This method returns the size, List containing width and height, that
the Glyph would like to occupy when drawn. 

* draw(allocation) 
  Draw the Glyph at the location and size given by the Dictionary 'allocation'. 
The allocation contains the key/values for 'line', 'column', 'width', 
and 'height'. A 'draw()' method generally follows this template:

        function SomeGlyph.draw(allocation) dict
          let self.__allocation = a:allocation
          if self.__status != g:IS_INVISIBLE
            " Code to draw Glyph
          endif

          " For interactive Glyphs
          if self.__status == g:IS_DISABLED
            " Code to 'color' the Glyph as "disabled"
            " A "disabled" is one that can not accept focus
            call AugmentGlyphHilight(self, "DisableHi", a)
          endif
        endfunction

It is *critically* important when rendering a Glyph, that the Forms library
can and does use multi-byte characters, UTF-8; that some character
drawing commands will screw things up. It is best to rely on the 
existing Character and String drawing functions:

    forms#SetCharAt(chr, line, column)
    forms#SetHCharsAt(chr, nos, line, column)
    forms#SetVCharsAt(chr, nos, line, column)
    forms#SetStringAt(str, line, column)
    forms#SubString(str, start, ...)

See the bottom of the forms.vim code for usage.

## Has Attributes

If the new Glyph has any additional attributes, then it is also important
to define the methods:

* init(attrs) 
  While the Self Prototype 'init()' method will match attributes with their 
intended values in the attrs Dictionary, a Glyph might wish to define its
own 'init()', which, of course, would call its Prototype's 'init()',
in order to check the values of the attributes have been set to and
make sure that all attributes that need to be set are set.

        function SomeGlyph.init(attrs) dict
          " call Prototype init method
          call call(self.__prototype.init, [a:attrs], self)
          " check attribute values, throw exception if bad
          ...
          return self
        endfunction
  
Very important, remember that the 'init()' method returns 'self'.

* reinit(attrs) 
  A Glyph's 'reinit()' method is called if one wishes to change one or more
attribute values. This is a safe but expensive way of changing a Glyph's
attributes. This approach should be used is some fundamental aspect of a
Glyph, some attribute that one expects to be constant, needs to be changed.
Consider the Label's 'reinit()' method which changes the Label's text:

        function! FORMS_LABEL_reinit(attrs) dict
          let oldText = self.__text
          let self.__text = ''

          call call(g:forms#Leaf.reinit, [a:attrs], self)

          if oldText != self.__text
            call forms#PrependUniqueInput({'type': 'ReSize'})
          else
            call forms#ViewerRedrawListAdd(self)
          endif
        endfunction

Generally, the text associated with a Label is expected not to change.
In the above, the old value of the text is saved and then the Label's
'init()' method is called. Upon its return, there are two possiblities:

- The size (number of characters) in the new text is different from
the size of the old text. In this case, the size of the Label has changed.
This requires that the whole Form be re-size, an expensive operation.
This is triggered by adding a 'ReSize' Event to the Input Queue. The
'ReSize' Event is *not* handled by the Viewer's event loop but rather
the Form's event loop. The Form must restore the existing text, figure
out how big the Form with the new Label text must be, save the existing
text, and then re-enter the Viewer event loop redrawing the whole Form in
the process.

- The second possibility is that the size of the old and new text is the
same, so all that is required is for the Label to be redraw. This happens
by adding the Label to the Viewer's Redraw List. After the Viewer
event loop handles every Event, it checks its Redraw List to see if any
Glyph or Glyphs need to be redrawn and, if so, those Glyphs and no other
Glyphs are redrawn.

## Interactive

To go further, the developer must decide if the new Glyph is to be interactive
or not and whether it will have children or not.


If the new Glyph is interactive, it can get and lose (a Viewer's Event 
handling) focus; it has a 'hotspot' and may display a 'flash' if 
cursor movement within it exceed its boundaries; it probably will 
have user entered data which can be added to the 'results' Dictionary
when the Form is exiting due to a 'Submit' Event; and it handles both
characters and Events. So, an interactive Glyph needs to define the methods:

* canFocus() 
  A Glyph can be enabled, disabled or invisible. If the Glyph is enabled, then
and only then can it have focus, so the 'canFocus()' method should look like:

        function SomeGlyph.canFocus() dict
          return (self.__status == g:IS_ENABLED)
        endfunction

* gainFocus()
  Sometimes a Glyph needs to take some action when it first gains focus.
This method is used to tell the Glyph it has gained focus.

* loseFocus() 
  Notify the Glyph that it has lost focus. This needs to be defined only if
the Glyph will take some action upon losing focus.

* hotspot()   
  Draw the hotspot associated with the Glyph.

* flash()
  This method is called if there has been some input error or cursor motion 
error.

* addResults(resutls): 
  An interactive Glyph generally has user entered data. This method is called
while the Form is handling an 'Submit' Event to enter the Glyph's data into
the 'results' Dictionary;

        function! SomeGlyph(results) dict
          let tag = self.getTag()
          let a:results[tag] = self.__some_data
        endfunction

  If the Glyph has multiple chunks of data, the value entered into the
'results' should be a ordered List of those chunks.

* handleChar(nr)
  Handles the Number returned from 'getchar()' when Glyph has focus.

* handleEvent(event)
  Handles the Event returned from Input Queue when Glyph has focus.

In many cases, the result of handling a Character or Event is for the
Glyph to add itself to the Viewers Redraw List. On some occasions, the
Glyph will call its 'flash()' method when the entered data is invalid
or results in a bad cursor (bad hotspot) position.

In addition, the developer might wish to add context specific usage information
to the Glyph which allows user to quick see how to use the Glyph, thus
the 'usage()' method should be defined:

* usage() 
  A Generic description of how a user interacts with the Glyph possible 
including what keyboard and mouse events are handled.

## Non-Interactive

When a Glyph is non-interactive, none of the above methods needs to be 
defined.

## Number of Children

Any new Glyph must have as a Prototype ancestor either: Leaf, Mono, Poly
or Grid; one should *never* derive directly from the Glyph Prototype.
When deriving from Mono, Poly or Grid, many methods must be structured
so that they call the Glyph's Prototype's corresponding method (unless
one wishes to duplicate or replace all of the code).



