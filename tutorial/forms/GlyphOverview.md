# Glyph Overview

Many of the ideas used in developing Forms are derived from Mark Linton's
InterViews C++ library which was developed at Stanford University and
Silicon Graphics and the Java port of InterViews called Biscotti which was
developed at Fujitsu Research Labs. For performance reasons, some limitations
were taken with Vim Forms. Specifically, Glyph size and location in the
window are static; there in no pick traversal; the size-request and allocation
process does not support minimum/maximum ranges - only the 'natural' value;
clipping rectangles are not supported; and, generally, a glyph can only appear
in one position in a tree of glyphs. The character nature of the underlying
Vim text-based editor imposed additional limitations such as the draw
traversal did not permit transforming size or rotation; resolution is at the
character level rather than pixel; and colors were drawn per character with
variation based only upon background versus foreground.

Out of the box, Vim's Dictionary, Functions and Dictionary function have
no notion of class or object inheritance. The Forms library is built
upon the Vim Self library which provides a prototype-base object
inheritance framework (Self.vim is the Forms library's sole dependency).

At the base of the Glyph inheritance tree is the Glyph (forms#Glyph) which
has the Self Object Prototype as its prototype. The Glyph prototype has
methods that define the behavior of all derived Glyph types as well as
inheriting the Self Object's methods. When the term Glyph is used, much
of the time it refers to an object that is based upon the Glyph Prototype.

Some Glyphs are primarily involved with controlling the layout and display 
of the Glyph tree in a window, some are informational while others are
designed to interact with the user (i.e., accept user input).

## Glyph 
Base Object from which all other Forms Glyphs inherit.
There are four direct, sub-types of Glyph. They are all in a sense
container Glyphs, nodes in a Glyph tree, that contain other Glyphs.

## Leaf
A Leaf is a "container" Glyph that contains no children, they
are leaf nodes in a Glyph tree. 

* NullGlyph
    Does nothing - no size, no display.
* HLine
    Horizontal "line" of a given background character (default '').
    Height is 1 character.
* VLine
    Vertical "line" of a given background character (default '').
    Width is 1 character.
* Area
    A region of a given background character (default '').
* HSpace
    A region of a given horizontal size drawing a 
    background character (default '').
* VSpace
    A region of a given vertical size drawing a 
    background character (default '').
* Label
    A (horizontal) text label.
* VLabel
    A vertical text label.
* Text
    Multiple lines of text.
* CheckBox
    A checkbox "[X]" or "[ ]".
* RadioButton
    A radiobutton "(*)" or "( )" can belong to a button group.
* FixedLengthField
    A line editor with fixed number of characters.
* VariableLengthField
    A line editor with a variable number of characters.
* TextEditor
    Simple multi-line text editor.
* TextBlock
    Similar to Text but all lines must be the same length.
* SelectList
    A list of selections.
* PopDownList
    A pop down list of selections in a menu.
* HSlider
    A horizontal slider.
* VSlider
    A vertical slider.

## Mono
A Glyph that contains a single child, its body Glyph. Most Mono
Glyphs implement a single behavior and delegate all others to its
child. 

* Box
    Draws a box around child.
* Border
    Draws a border of a character around child (default ' ').
* DropShadow
    Draws a drop shadow (a primitive 3D effect).
* Frame
    Draws inset/outset frame (a primitive 3D effect).
* Background
    Draws a background for child Glyphs 
    (default character ' ', uses highlight "BackgroundHi")
* MinWidth
    Child appears to have a width of at least given size.
* MinHeight
    Child appears to have a height of at least given size.
* MinSize
    Child appears to have a width and height of at least given size.
* HAlign
    Align child horizontally (default Left)
* VAlign
    Align child vertically (default Top)
* HVAlign
    Align child horizontally and vertically (default Left and Top)
* Button
    A button with an associated action.
* ToggleButton
    A toggle button with a select state.
* Viewer
    Event handling Glyph that maps events forwarding them to the
    child Glyph with current focus and manages redraws.
* Form
    A top-level Viewer and the top Glyph in any Glyph tree 
    application. Forms also manage the preparation for displaying
    their child Glyphs and the cleanup/redraw of the original window
    content when the Form is finished.

## Poly
A Poly Glyph has any number of child Glyphs stored in a list.
Polymorphic methods such as 'draw()' or 'requestSize()' are called
on child Glyphs by traversing the list sequentially.

* HPoly
    Child Glyphs are draw horizontally. 
    Provides for a common vertical alignment policy which can be 
    overridden on a per child basis.
* VPoly
    Child Glyphs are draw vertically..
    Provides for a common horizontal alignment policy which can be 
    overridden on a per child basis.
* Deck
    A single Child Glyph is drawn based upon which is selected - like
    a deck of cards. In a sense, they are draw in the Z-axis but only
    the top Glyph appears.
    Provides for a common horizontal and vertical alignment policy.
* FixedLayout
    Child Glyphs have a fixed (x,y) position within the FixedLayout
    Glyph. It is up to the developer to make sure that the child Glyphs
    do not overlap.
* MenuBar
    Child Glyphs (labels for Menus) are draw at the top of the window. 
* Menu
    A vertical display of menu items.

## Grid
A table of child Glyphs with rows and columns.

* Grid
    Single object of type Grid. Allows for common row-based or
    column-base alignment policy which can be overridden on a
    cell basis.


## Events

There are two types of input events. The first type is simply the
Character or Number returned by calling Vim's 'getchar()' function.
These are called "character" events. A Viewer examine all such
character events and map some of them into the second type of event
supported by Forms, a Dictionary object or object event that must
have a 'type' key whose value is one of a set of allowed names. As an
example, a &lt;LeftMouse> Number returned by 'getchar()' is converted
into a Dictionary event object of type 'NewFocus' where the Dictionary
also has entries for the line and column (v:mouse_line and
v:mouse_column). Some object events are generated by the Forms
runtime system. An example of such an object event is a ReSize event
which is generated when a Glyph actually changes its size (normally, a
very rare occurrence). More common runtime generated event objects are
the Cancel and Submit events which are, generally, generated by a
"close" and an "accept" button.

A user interacts with a form by sending events to the form. Such 
events are generated by the keyboard and mouse. Events are
read by the Viewer with current focus, mapped by that Viewer
and then forwarded to the Viewer's child Glyph that has focus.
If a Viewer has no child Glyphs that accept focus, then all events
are ignored (except the &lt;Esc> character which will pop the user out
of the current Viewer/Form).

If a Glyph consumes an input event, it might require redrawing (such
as adding a character to an editor). In this case, the Glyph registers
itself with a viewer-redraw-list and when control is returned to the
Viewer, the Glyph is redrawn.

Sometimes a Glyph will consume an event and an action will be
triggered. For example, a left mouse click or keyboard &lt;CR> entry
on a button will cause the action associated with that button to
execute.

## Defining a new Glyph

A new Glyph variant is created by cloning an existing Glyph and then
tailoring its methods or adding new methods/attributes. Once this
new variant is defined additional instances of it can be created by
simply cloning it.

The clone() method takes an optional argument, a String that defines
its type name. As a rule of thumb, if the new object being created is
a clone from of an object that itself was cloned with a type name
argument, then the developer may add clone with a new type name.
Generally, this is done if the new object variant has well defined
characteristics and usages making it potentially the prototype object
of many objects. On the other hand, if the new object only make minor
modifications in the methods/attributes of its prototype and/or will
only be used locally and not have general applicability, then cloning
without defining a new type (without passing into the clone() method a
new type name) is a reasonable approach.

An additional point concerning cloning and type name, objects created
with a type name are expected to exist before and after any particular
form is generated, used, and deleted; while object created via clone
without a type name have a life time that only spans that of the form
in which they are used.

## Life Cycle

### Initializing
After a Glyph is cloned, it is initialized. For most of the Forms
library, Glyphs have a "constructor", and associated function that
takes a Dictionary of attributes and returns a newly cloned and
initialized object. As an example, the Label Glyph has the following
function

    function! forms#newLabel(attrs)
      return forms#loadLabelPrototype().clone().init(a:attrs)
    endfunction

The Label prototype is cloned and the clone is then initialized.
            
### Tree
For any Glyph to be useful it must be placed into a Glyph tree
and that tree ultimately used as the body of Form.
            
### Form
The Form holding the Glyph is started by calling its 'run()' method.
This method will return a Dictionary of Glyph tag/values if the Form
had a Submit button that was invoked. The Form might instead, simply
execute a Vim command and the 'run()' method returns nothing
(actually, it will return 0). If the Form had a Cancel or Close
button that was pushed or the user typed &lt;Esc>, then, again, nothing
is returned.
            
### Size, Drawing and Allocation
The first thing that happens to a Glyph in a running Form is for the
Glyph's 'requestSize()' method to be called. The Glyph is telling
the Form how big it would like to be; number of characters of width
and height. Bubbling up the Glyph tree is the total size request for
the Form. This is then used to position the form in the window and
for the initial, top-down draw traversal.  During this traversal,
all Glyphs are given their allocation which is the line/column
position as well as their allowed width/height.  All (well, most)
Glyphs should save this allocation as it will be needed for other
operations (such as, when a Glyph is asked to redraw itself or,
Glyphs with focus, are asked to render their hotspot).
            
### Cancel or Submit
A Form is finished by selecting a Close/Cancel or Submit button.
Circumstance will dictate the names of the button (its up to the 
developer to provide them). 
          
When a Form is to finish with no side effects, a Close/Cancel button
issues a 'Cancel' event.  The active Form then stops running and
control is returned to either a parent Form or, if there is no
parent Form, control is returned to the code that originally
launched the Form. When a Form stops because of a 'Cancel' event,
the Form returns nothing (by default 0).  At this point, the
launching code should respond to the user's desire to do nothing in
an appropriate manner.

When a Form stops because a 'Submit' event was generated (by a
Submit/Accept/Do-Action button or action), then the Form returns a
Dictionary that holds Glyph tag/value pairs generated by walking the
Form Glyph tree. This will hold all data and selections entered by
the user on the Form. It is for the launching code to extract the
desired data and take whatever action is appropriate.  Developers
should remember that if a Glyph is not given a tag-name at
initialization, then one is automatically generated and an
automatically generated tag-name will certainly be different each
time the Form is run. So, it behoves the developer to pick their own
meaningful tag-names for Glyphs that will return "application" data.

Finally, a user can always enter &lt;Esc> to stop running a Form.
Remember, a Form is a Viewer. If focus is in the Form's Viewer and
not a child Viewer of the Form, then entering &lt;Esc> is the same as
pressing Close/Cancel button. Most of the time this will be the
case; a Form will only have one Viewer - itself. But if a Form has
one or more child Viewers, then entering &lt;Esc> when focus is in a
child Viewer will simply pop the user out to the next higher
enclosing Viewer. If the Form has 4 nested Viewers and focus is in
the bottom most Viewer, it will take entering &lt;Esc> four times to
exist the Form.
          
### Delete
After a Form stops running, it and all of its child Glyphs are
deleted freeing up memory. One side effect of this is that if the
user tries to re-invoke the Form, the Form has to be allocated and
initialized all over again. For many Forms this is not much of an
issue. But for Forms that are large, complex and/or deeply nested
there is be a noticeable delay in re-rendering the Form. The example
menu Form is an example of a Form that a user might wish to use over
again in a given Vim session and it is certainly large, complex and
deeply nested. So, to make its re-display faster, a developer at
Form initialization can instruct the Form not to delete itself and
its child Glyphs. Of course, the developer must have some global
variable that references the Form after its is initially created,
but after that, it can simply be re-run in order for it to be
re-displayed.

I understand that all of this discussion about Glyphs is far to deep for the
general user but much too shallow for a developer. Writing detailed developer
documentation is an example of a Catch22 situation. I will await feedback. 
