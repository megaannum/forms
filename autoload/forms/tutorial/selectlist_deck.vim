
"---------------------------------------------------------------------------
" forms#tutorial#editor_slider#Make() 
"   Create a SelectList and Deck and wire them together
"     using an Action so that the SelectList controls which of the Deck's
"     Cards is showing.
"
"  parameters: None
"---------------------------------------------------------------------------
function! forms#tutorial#selectlist_deck#Make()
  let t1 = forms#newText({'textlines': "Card\nOne"})
  let t2 = forms#newText({'textlines': "Card\nTwo"})
  let t3 = forms#newText({'textlines': "Card\nThree"})
  let t4 = forms#newText({'textlines': "Card\nFour"})

  let deck = forms#newDeck({'children': [t1, t2, t3, t4]})

  function! V4Action(...) dict
    let pos = a:1
    call self.deck.setCard(pos)
  endfunction
  let action = forms#newAction({ 'execute': function("V4Action")})
  let action['deck'] = deck

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
  function! slist.purpose() dict
    return "Select item to change Deck top-of-card."
  endfunction
  let b = forms#newBorder({'body': slist, 'char': ' '})

  let hpoly = forms#newHPoly({'children': [b, deck], 
                              \ 'alignment': 'C' })
  let bg = forms#newBackground({ 'body': hpoly})

  let form = forms#newForm({'body': bg })
  function! form.purpose() dict
    return "This is Help associated with the SelectList/Deck Tutorial Form."
  endfunction

  call form.run()
endfunction
