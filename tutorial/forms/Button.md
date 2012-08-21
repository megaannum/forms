# Button

A Button is an interactive Mono Glyph. Most of the time, one would simply
create a Label and use that as the Button's child Glyph but, in fact, any Glyph
can be a Button's child, even another Button. But something to understand
is that if a Button is within a Button, the inner Button will never receive
any input Events (or characters). This is because when a Viewer's 'run()'
method first starts, it walks its child tree of Glyphs recording each
descendent that is interactive; each descendent that can receive 
Events; each descendent that can gain focus. During this Glyph tree walk,
if a container Glyph (Mono, Poly or Grid) can accept focus, the tree
walker does not descend into the container Glyph's children. Thus
in the case of a Button within a Button, the outer Button will receive 
the Events when it has focus and the inner one never will (unless the
outer Button decides to pass them along of course).

So, what else  might make a reasonable child Glyph for a Button? One could
certainly put a Label in a Box and then add the Box to the Button.
Images and bitmaps are not supported by Forms so, while most GUI libraries
support Button with those child types, the Forms library does not.

