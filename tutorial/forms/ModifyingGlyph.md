# Modifying an Existing Glyph

In creating the example "Pallet Designer" there was the need for
a Glyph that could display both the RGB hex color, the Xterm 256
closest color equivalent and the color itself in the background.

In the Glyphs defined in the forms.vim file, such a Glyph does not
exist.

The approach taken was to create an instance of the Area Glyph,
tailor that instance by providing it with additional attributes
and methods and, then, use clones of that tailored instance
as the new display objects.

So, first create an instance of the Area Glyph:

    let colorblock = forms#newArea({'width': 6, 'height': 2})

The colorblock instance has a height of 2 and a width of 6, the
right size to hold both a 6 character hex String and a 1 to 3
character Xterm 256 Number.

Next, add attributes to this instance:

    let colorblock.__rgbtxt = "000000"
    let colorblock.__numbertxt = "0"
    let colorblock.__hiname = "ERROR_HIGHLIGHT_NOT_SET"

It has a new attributes to hold both the RGB hex String and the
Xterm 256 color number. Also, it has an attribute which will be
the name of the highlight that defines its background color.

Because there are new attributes which will be used to generate a highlight,
an 'init()' method is defined. Within the colorblock 'init()' method,
there is a call to its Prototype's 'init()' methods (a must) and then
the attributes are used to generate the highlight.

    function! colorblock.init(attrs) dict
      call call(g:forms#Area.init, [a:attrs], self)

      let ctermfg = "0"
      let guifg="#000000"
      execute ":hi ".self.__hiname." ctermfg=".ctermfg." ctermbg=".self.__numbertxt." guifg=".guifg." guibg=#".self.__rgbtxt
      return self
    endfunction

While the RGB text takes up the full width of the colorblock Glyph,
the Xterm 256 Number does not, so a method is defined that will
center the number in the colorblock when it is drawn:

    function! colorblock.setNumberText(numbertxt) dict
      let l = len(a:numbertxt)
      if l == 3
        let self.__numbertxt = " " . a:numbertxt
      elseif l == 2
        let self.__numbertxt = "  " . a:numbertxt
      else
        let self.__numbertxt = "   " . a:numbertxt
      endif
    endfunction

Because code that might call the "Pallet Designer" may want to get
the RGB and Xterm Number as a result, the colorblock needs to define
the 'addResults()' method adding the attribute values to the results
Dictionary:

    function! colorblock.addResults(results) dict
      " only add to results if its activitly being displayed, i.e.,
      " self.__matchId exisits
      if exists("self.__matchId")
        let nt = self.__numbertxt[1:]
        if nt[0] == ' '
          let nt = nt[1:]
        endif
        if nt[0] == ' '
          let nt = nt[1:]
        endif
        let a:results[self.__hiname] = [self.__rgbtxt, nt]
      endif
    endfunction

A clone of the colorblock Object may not always be displayed. When a Glyph
transitions from being displayed to not being displayed, the Viewer will
call its 'hide()' method. Generally, Glyphs that simply display characters
and do *not* define their own additional highlight colors, do not have
to define their own 'hide()' method. But, if a Glyph does highlighting
while being drawn, then when the Glyph is not to be drawn, its 'hide()'
method must delete its highlight.

    function! colorblock.hide() dict
      call GlyphDeleteHi(self)
    endfunction

As an aside, if one is using a Deck and a Card in the Deck highlights
as it draws, then it is import that that Card have a 'hide()'
method so that when the Card is no longer being drawn (no longer the
top Card), that its highlight can be removed.

Finally, the colorblock must have a 'draw()' method:

    function! colorblock.draw(allocation) dict
      call call(g:forms#Area.draw, [a:allocation], self)

      let a = a:allocation
      call forms#SetStringAt(self.__rgbtxt, a.line, a.column)
      call forms#SetStringAt(self.__numbertxt, a.line+1, a.column)
      call GlyphHilight(self, self.__hiname, a)
    endfunction

The 'draw()' method calls its Prototype's draw method which
saves the 'allocation' parameter and then draws the RGB hex String,
the Xterm Number and sets the color using the highlight for the given
allocation.


Lastly, this colorblock Object is used as the Prototype for a number of
specific 'blocks' each with their own highlight name:

    let oneblock = colorblock.clone().init({ 'hiname' : 'MOneHi' })


The colorblock is cloned and the new Object is initialized.

The colorblock block was defined and used in private code; it was not
created for general usage. As a result, somethings that a more
reusable Glyph might have are missing with the colorblock Object.
For instance, there is no 'reinit()' method defined since in the
"Pallet Designer" the blocks would never need it. Also, the 'init()'
code does no attribute value validation.

Such short cuts are quite alright as long as there is no expectation
that the developer or others might, at a later time, attempt reuse.

