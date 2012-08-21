# Boxes

The simplest way to draw a box around a Glyph is to use the Box Glyph.
The Box Glyph is a Mono Glyph thus having a child Glyph. It also has
an attribute, 'mode',  which indicates what type of box to draw.
The supported UTF-8 box drawing characters that are support by 
Forms have the following 'mode' names:

* light:  single line box
* heavy:  single heavy line box
* double: double lines box
* light_arc: single line box but corners are arcs
* light_double_dash: single dashed line box 
* light_double_dash_arc: double dashed lines box
* heavy_double_dash: heavy double dashed lines box
* light_triple_dash: triple line box
* light_triple_dash_arc: triple dashed line box but corners are arcs
* heavy_triple_dash: heavy triple dash lined box
* light_quadruple_dash: light four dashed line box
* light_quadruple_dash_arc: light four dashed line box but corners are arcs
* heavy_quadruple_dash: heavy four dashed line box
* block: character blocks used to make box 
* semi_block: character blocks used to make box but corners empty
* triangle_block: box having triangle corners

The Box Glyph has a default 'mode' of 'light'.

Since box drawing characters are simply characters, the size of a Box Glyph
is the size of its child Glyph with size width and height plus the size of
the box characters, that is, width + 2 and height + 2.

While putting a box around a Glyph or a grouping of Glyphs is useful, it
is sometime required/desired to place separate boxes around a number
of Glyphs but not have each box being separate, rather having them merge
together. The Poly's HPoly and VPoly support this as does the Grid Glyph.

In these cases, the default behavior if the 'mode' attribute is not explicitly
set is to not draw any box. If the Glyphs are in box-mode, the 'mode'
is set, then boxes are draw around all child Glyphs but only a single 
character appear between any two neighboring child Glyphs.

In the case of a HPoly in box-mode, its height is what its height would be
if it were not in box-mode plus 2, while its width is its non-box-mode
width plus 2 for the lines at both ends plus the number of internal box lines
being drawn (which depends upon the number of child Glyphs).

A VPoly has similar size considerations when in box-mode.

For a Grid Glyph, since it is kind of like a combined HPoly and VPoly,
its size is increased both in width and height by 2 plus for width, the
number of its columns minus 1 and for height the number of its rows
minus 1.

Now, for both the HPoly and VPoly and for the Grid Glyphs it would be
possible to have a larger selection of how box drawing characters are
combined, but that level of support would be a much more complicated
API. For instance, for a Grid, the exterior horizontal box characters
would be heavy dashed, the exterior vertical could be single while the
interior lines could be double dashed. Its possible to find the correct
joiner characters to make this all work, but at this point it does
not seem worth it.


