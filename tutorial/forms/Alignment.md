# Alignment 

Most of the time with non-trivial Forms, the Glyph components of a Form
have horizontal and vertical alignment rules applied to how they are
draw with respect to other Glyphs.

First, how is an alignment specified. Generally, Glyphs that do
alignment on their children have a default alignment; if no
alignment value is specified as an attribute, the default alignment
value is used. 

Horizontal alignment is specified either with one of the characters:
'L', 'C' or 'R' ('left', 'center' or 'right' respectfully), or it can be specified
by a Float with value between 0.0 and 1.0 inclusive, where 0.0 is 'left',
0.5 is 'center' and 1.0 is 'right'.

Similarly, vertical alignment is specified with 'T', 'C' or 'B' ('top', 
'center' or 'bottom') or with a Float of range 0.0 to 1.0 inclusive where
0.0 is 'top', 0.5 is 'center' and 1.0 is 'bottom'.

When using a HPoly, the width of the HPoly is the sum of the widths of all
of the child Glyphs. 
The child Glyphs are laid out horizontally one right next to the other, abutting their siblings. 
The height of the HPoly is the height of the tallest child Glyph.  
So vertically, if
some of the children have lesser height than the HPoly height, 
there is the issue of how they should be aligned. 
By default, the HPoly alignment
for all children is 'T', top. This can be overridden per HPoly object
so that the default is 'C' or 'B' or the default can be given by a Float
between 0.0 and 1.0. In addition to having a default alignment that 
is applied to all children, a HPoly object can override this default
behavior on a child-by-child basis. For example, an HPoly might have
a default alignment of 'center' but for the first child it could be 'top'
and for the last child it could be 'bottom'.

    let hpoly = forms#newHPoly('children': [
                            \ child0,
                            \ child1,
                            \ child2,
                            \ child3
                            \ ],
                            \ 'alignment': 'C',
                            \ 'alignments': [[0,'T'], [3,'B']]
                            \ })

In the above, child0, ..., child3 are laid out horizontally right next to
each other: child0 next to child1 next to child2 next to child3.
But vertically, if the height of child0 is less than the HPoly's height
then child0 is aligned at the 'top'. Similarly, if the height of child3
is less than the HPoly height, it is aligned at the 'bottom'. The Glyphs
child1 and child2 are aligned using the default alignment which aligns them
in the 'center'.

With a VPoly, its height is the sum of the heights of all of its child
Glyphs while its width is the width of the widest child.
A VPoly's default alignment is 'L', left.
Analogously to the HPoly, a VPoly child Glyphs whose width is less than 
the width of the VPoly, must be aligned. Consider a VPoly where one wants
all children to be 'center' aligned except for the bottom must child
(think of an informational Form with a 'close' Button on the bottom right).

    let vpoly = forms#newVPoly('children': [
                            \ child0,
                            \ child1,
                            \ child2
                            \ ],
                            \ 'alignment': 'C',
                            \ 'alignments': [[2,'R']]
                            \ })

Here, child0 and child1 are 'center' aligned while child2 is aligned to
the 'right'.

The Grid Glyph takes a list of lists of children; rows and columns.
The width of any column is the width of the widest child Glyph in that column.
The heights of any row is the heights of the tallest child Glyph in that row.
The width of a Grid is the sum of the widths of its columns and its height is
the sum of the heights of its rows. In the case of a Grid, its default column
alignment is 'left' and it default row alignment is 'top'.
On a row-by-row basis, a given row's default alignment can be overridden.
The same is true for columns, any given column can have its default alignment
overridden. 
[TODO: Finally, any given cell in a Grid can have its own alignement overridden.]

As an example Grid, here there are 3 row and 3 columns. The default column
alignment is set to 'L' (the default alignment value) and the row alignment
is set to 'T' (again, the default value). Then, row 1 and 2 have their
alignments overridden; row 1 with alignment 'C' and row 2 with alignment
'R'. This is followed by the column alignment overridden for column 1 and 2
where column 1 is given a 'center' alignment and column 2 is given a 'bottom'
alignment:

    let grid = forms#newGrid({
                          \ 'nos_rows': 3,
                          \ 'nos_columns': 3,
                          \ 'halignment': 'L',
                          \ 'valignment': 'T',
                          \ 'halignments': [[1,'C'],[2,'R']],
                          \ 'valignments': [[1,'C'],[2,'B']],
                          \ 'data': [ ... ]
                          \ })

Another set of Glyphs that control alignment are the HAlign, VAlign and
HVAlign Mono Glyphs. As Mono Glyphs, they take a single child Glyph.
They also take a size attribute which is the minimum size for the layout;
for the HAlign it is 'width' attribute, for the VAlign it is the 'height'
attribute and for the HVAlign it is both the 'width' and 'height'
attributes. A child Glyph that is less than the specified size in that
dimension, requires alignment. As an example, with the HVAlign Glyph
whose width and height is larger than its child's dimensions, the child
can be, basically, positioned anywhere within its parents region 
(on character cell boundaries, of course)
if Float alignment values are used.

Why use alignment? There is a FixedLayout Glyph which allows one to
place all children at the exact position relative to it. This is true,
one could figure out the line/column position of all the child Glyphs,
their width and height so that no two child Glyphs overlap and you
are done. The problem is if you later (or worse, someone else) wants to
change one thing, change the text in a Label, add a space between
two Glyphs, etc., then one must re-calculate all positions over again.
With alignment using Grid, Poly, Mono Glyphs one simply makes a change
and everything is automatically laid out.
