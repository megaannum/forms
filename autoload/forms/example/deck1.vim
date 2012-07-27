
function! forms#example#deck1#Make()
  let l1 = forms#newLabel({'text': "label one"})
  let l2 = forms#newLabel({'text': "label two"})
  let l3 = forms#newLabel({'text': "label three"})
  let l4 = forms#newLabel({'text': "label four"})

  let deck = forms#newDeck({ 'children': [l1, l2, l3, l4] })

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
  let b = forms#newBorder({ 'body': slist, 'char': ' ' })

  let hpoly = forms#newHPoly({ 'children': [b, deck], 'alignment': 'T' })
  let bg = forms#newBackground({ 'body': hpoly} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction

