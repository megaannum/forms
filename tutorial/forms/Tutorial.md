# Forms Tutorial

This is a tutorial covering the use of the VimL Forms library.

## Self

The Forms library is built upon the VimL Self library, a object prototype
system. To understand the Self library see the
[Self Tutorial](https://github.com/megaannum/self/blob/master/tutorial/self/Tutorial.md).

## Glyph Overview

The Glyph is the base Object for all Forms components.

Glyphs can be abstract or concrete.

Glyphs can be of kind: Leaf - no children, Mono - single child, Poly - list of children or Grid - list of lists of children.

A Glyph can be be interactive (have focus) or non-interactive. 
An interactive Glyph
response to keyboard and/or mouse events while a non-interactive Glyph
does not. Well, thats mostly true. All Glyph's respond to a right mouse click,
<RightMouse>, and displays context sensitive information in a popup.

TODO
For more detail see [Glyph Overview](https://github.com/megaannum/forms/blob/master/tutorial/forms/GlyphOverview.md)

## Code Structure

The code that generates a Form, generally, has the same structure.
The code is in a function which may or may not take arguments which
are used to tailor the Form. The code creates the components that
will make up the Form, This is followed by the Form creation and
call for the Form to run. When a Form stops running it will 
generate a return value. The default return value is 0 meaning that
the Form wants nothing to be done. Alternatively, a Form can return
a Dictionary of results; as keys Glyph tags and the associated values is 
determined by each Glyph. Lastly, the code in the function can do
something based upon the Form's returned results.

For more detail see [Code Structure](https://github.com/megaannum/forms/blob/master/tutorial/forms/CodeStructure.md)

## Label

A Label is a Leaf Glyph which takes a "text" attribute. Its size is one
character in height with a width equal to the number of its charaters.
It is a non-interactive Glyph.

For more detail see [Label](https://github.com/megaannum/forms/blob/master/tutorial/forms/Label.md)

## Layout Labels Horizontally

A HPoly is a kind of Poly and is used to layout its child Glyphs horizontally.
In this case, all of the child Glyphs will be Labels. Thus the height of 
the HPoly will be the maximum height of its child Glyphs and, since,
all Labels have a height of 1, the height of the HPoly is 1 character.
The width of the HPoly is the sum of the widths of its children.

For more detail see [Layout Labels Horizontally](https://github.com/megaannum/forms/blob/master/tutorial/forms/LayoutLabelsHorizontally.md)

## Alignment 

When a parent Glyph is to draw one of its child Glyph in a region and the
child Glyph is smaller than the region, either smaller in width or height
or both, then the parent Glyph must use an alignment to position the child 
Glyph. A horizontal alignment attribute can have discrete values: 'L', 'C' 
or 'R' or a Float value between 0.0 and 1.0. Similarly, a vertical alignment
attribute has discrete values: 'T', 'C' or 'B' or Float 0.0 to 1.0.

For more detail see [Alignment](https://github.com/megaannum/forms/blob/master/tutorial/forms/Alignment.md)

## Layout Labels Vertically with Alignment

A VPoly is a Poly that lays out its children vertically. A VPoly that contains
multiple Label Glyphs as children will have to align some of the Labels if
they have different sizes. By default, a VPoly aligns to the Left but
the default can be overridden for all children and/or on a case-by-case
basis.

For more detail see [Layout Labels Vertically](https://github.com/megaannum/forms/blob/master/tutorial/forms/LayoutLabelsVertically.md)

## Grid, Polys and Boxes

Forms lets Glyphs be surrounded by box drawing characters. This is useful
for organizing the presentation. Forms supports the "standard" ASCII 
box drawing characters: '+', '-' and '|'; as well as, UTF-8 characters
specifically designed for drawing boxes (they are actually called box 
drawing character!). 

For more detail see [Boxes Labels Vertically](https://github.com/megaannum/forms/blob/master/tutorial/forms/Boxes.md)

## Action

Associated with many interactive Glyphs are Actions. When you click a button,
its Action executes. When you enter <CR> on a line editor, its Action executes.
When a slider is moved, its Action executes. All interactive Glyphs with
Actions execute the Action provided by the developer or executes its
default Action, the NoOp-Action that does nothing.

For more detail see [Action](https://github.com/megaannum/forms/blob/master/tutorial/forms/Action.md)

## Command

Some interactive Glyphs can take a command String or an Action. When such
a Glyph is selected, an Event of type "Command" with additional attribute
with key "command" and value the command String is created and pre-pended
to the input queue. When the Viewer reads the next item from the input
queue, if its an inner Viewer, the Command Event is put back onto the
front of the input queue and the Viewer control "pops" up to its the
parent Viewer - which repeats the process - until it is the top-level
Viewer that removes the Command Event from the input queue. This
Viewer (it run() method) simply returns the Command Event to the 
calling Form run() method and it is this Form that then takes the
command String from the Event and, as the last thing it does before
exiting its run() method, executes the command.

For more detail see [Command](https://github.com/megaannum/forms/blob/master/tutorial/forms/Command.md)

## Button

A Button is an interactive Glyph. A Button can have an Action Object associated
with it or a command String. When it is selected (<CR>, <Space>
or <RightMouse>), if the Button has an  Action, that Action executes.
If the Button has a command, the Button creates an Event of type "Command"
with an additional entry of key "command" and value the Button's command
String and places the Command Event at the front of the input queue.

For more detail see [Button](https://github.com/megaannum/forms/blob/master/tutorial/forms/Button.md)

## More Code Structure  (return values)

When the Form run() method returns, it returns either 0, meaning no return
value or it returns a Dictionary of Glyph tags as the keys and the Glyph
result values. It is up to the code that originally launched

For more detail see [More Code Structure](https://github.com/megaannum/forms/blob/master/tutorial/forms/MoreCodeStructure.md)

## Submit Button

When a Button's Action creates an Event of type "Submit", Sub-Viewers that
read the Submit Event simply place it back on the input queue and pop up to
their parent Viewer. The top-level viewer, returns the Submit Event
to the Form that called the Viewer code. This Form then walks the Glyph
tree with a Dictionary requesting each Glyph add to the Dictionary its
tag as a key and its result value as the value associated with the key.
Not all Glyphs have to add a tag/result pair. Mostly, Editors, Radiobuttons,
ToggleButtons, Sliders, and other interactive Glyphs that maintain user
entered state are the ones that add such tag/result pairs.

TODO
For more detail see [Submit Button](https://github.com/megaannum/forms/blob/master/tutorial/forms/SubmitButton.md)

## Events (Submit Cancel)

Traditional forms can be: 

* Information which present some information to the user and have a Close Button,
* Binary, Yes and No Buttons, presenting the user with an option,
* Requesting information from the user with Cancel and Accept/Submit Buttons, et.

In each of these cases, the Buttons either generate a Submit Event or a Cancel Event and place the Event at the front of the input queue.

TODO
For more detail see [Events](https://github.com/megaannum/forms/blob/master/tutorial/forms/Events.md)

## Linking Glyphs

Sometimes two or more interactive Glyphs maybe linked, changing the value of one of them is reflected in the other(s). 

### Editor and Slider

Common example is a Line Editor
with a fixed width and a Slider that has resolution and size sufficient 
to display the values.

For more detail see [Linking Editor and Slider](https://github.com/megaannum/forms/blob/master/tutorial/forms/LinkingEditorSlider.md)

### SelectList and Deck 

Another useful linking is that of a SelectList and a Deck. A SelectList allows
on to choose a value from a list of values. A Deck is a Poly that is like
a deck of cards; only the selected, "top", Card is displayed. Each value
in the SelectList is associated with one card in the Deck. When a SelectList
value is selected, the associated Card is moved to the top of the Deck.

For more detail see [Linking SelectList and Deck](https://github.com/megaannum/forms/blob/master/tutorial/forms/LinkingSelectListDeck.md)

## Viewer

The Viewer is a Mono Glyph that handles keyboard and mouse events in
its 'run()' method.
Some such events it handles itself while other is passes down to the
descendent that currently has focus (if it exists).

For more detail see [Form](https://github.com/megaannum/forms/blob/master/tutorial/forms/Viewer.md)

## Form

The Form Glyph is a Viewer Glyph that is concerned with assuring that
it, the Form, can, in fact, be displayed (enough room in the window), 
save the current window state, 
runs its underlying Viewer, performs cleanup and restores
the previously saved window state.
It overrides the Viewer's 'run()' method to do these things, but in the
middle it does call the Viewer's version of the 'run()' method.

For more detail see [Form](https://github.com/megaannum/forms/blob/master/tutorial/forms/Form.md)

## Modifying an existing Glyph

TODO
For more detail see [Modifying Glyph](https://github.com/megaannum/forms/blob/master/tutorial/forms/ModifyingGlyph.md)

## Creating a new Glyph

TODO
For more detail see [Creating Glyph](https://github.com/megaannum/forms/blob/master/tutorial/forms/CreatingGlyph.md)   
