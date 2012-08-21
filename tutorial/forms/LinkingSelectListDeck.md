# SelectList and Deck 

A Deck Glyph, all by itself, is not very useful; the "top" child is
displayed and there is no mechanism for telling the Deck to display
a different child. To change what child, which Card of the Deck, is
displayed, some other Glyph must be used to call the Deck's 'setCard(n)'
method.

In this example, a SelectList will be wire to a Deck so that when the
SelectList's selection is changed, the Deck's Card is changed.

A SelectList is not the only way to select which of a Deck's children
to show. One could simply have a Button that, when clicked, cycles
through the children. Or, have one Button per Deck's child where
pressing Button 'n' would display child 'n'.


Here, the Deck will have four Text Objects as its children.

  let t1 = forms#newText({'textlines': "Card\nOne"})
  let t2 = forms#newText({'textlines': "Card\nTwo"})
  let t3 = forms#newText({'textlines': "Card\nThree"})
  let t4 = forms#newText({'textlines': "Card\nFour"})

Add the Text Objects to the Deck.

  let deck = forms#newDeck({'children': [t1, t2, t3, t4]})

Define a function that takes the current SelectList position and uses
that value to set the Deck's current Card:

  function! SelectListToDeckFunc(...) dict
    let pos = a:1
    call self.deck.setCard(pos)
  endfunction
  let action = forms#newAction({'execute': function("SelectListToDeckFunc")})
  let action['deck'] = deck

Define the SelectList's attributes. Its 'mode' is 'single' meaning that
only one item in the list can be selected at a time. The initial 
postion, 'pos', of the SelectList is '0'. The SelectList choices
are name/id pairs where the names are displayed and the ids are a
mechanism of creating a mapping to external data (which we do not use here).
The 'size' is the size of the choice display window; all choices displayed
at once since 'size' equals the number of 'choices'. Lastly, the
'on_selection_action' is set to the Action defined above:

  let attrs = { 'mode': 'single',
              \ 'pos': 0,
              \ 'choices': [
              \ ["one", 1],
              \ ["two", 2],
              \ ["three", 3],
              \ ["four", 4]
              \ ], 'size': 4,
              \ 'on_selection_action': action
              \ }
  let slist = forms#newSelectList(attrs)

To give a little space between the Deck and the SelectList, put the SelectList
in a Boarder of size 1.

  let b = forms#newBorder({'body': slist, 'char': ' '})

Put both the Deck and the Border into a HPoly.

  let hpoly = forms#newHPoly({'children': [b, deck], 'alignment': 'C' })

Use a Background to highlight the region of the Form.

  let bg = forms#newBackground({ 'body': hpoly})

The Background is now placed into the Form as its sole child Glyph, as
the value of the Form Glyph's 'body' attribute:

    let form = forms#newForm({'body': bg})

Then, the Form's 'run()' method is called:

    call form.run()

This code is placed into a function:

    function! forms#tutorial#selectlistdeck#Make()
      " SelectList and Deck code
    endfunction

The full code for the SelectList and Deck can be found in: [SelectList and Deck](https://github.com/megaannum/forms/blob/master/autoload/forms/tutorial/selectlist_deck.vim)

To run the label code, source the selectlist_deck.vim file and then enter

    :call forms#tutorial#selectlist_deck#Make()

on the command line.
