
function! forms#example#deck2#Make()
  let l1 = forms#newVLabel({'text': "label one"})
  let bl1 = forms#newBorder({ 'body': l1 })
  let l2 = forms#newVLabel({'text': "label two"})
  let bl2 = forms#newBorder({ 'body': l2 })
  let l3 = forms#newVLabel({'text': "label three"})
  let bl3 = forms#newBorder({ 'body': l3 })

  let deck = forms#newDeck({ 'children': [bl1, bl2, bl3] })

  function! V5Action(...) dict
    let pos = a:1
    call self.deck.setCard(pos)
  endfunction
  let action = forms#newAction({ 'execute': function("V5Action")})
  let action['deck'] = deck

  let attrs = { 'mode': 'single',
          \ 'pos': 0,
          \ 'choices': [
          \ ["one", 1],
          \ ["two", 2],
          \ ["three", 3]
          \ ],
          \ 'on_selection_action': action
          \ }
  let slist = forms#newSelectList(attrs)
  let b = forms#newBorder({ 'body': slist })

  let hpoly = forms#newHPoly({ 'children': [b, deck], 'alignment': 'T' })
  let bg = forms#newBackground({ 'body': hpoly} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction

function! forms#example#deck2#MakeTest()
  call forms#AppendInput({'type': 'Sleep', 'time': 5})
  call forms#AppendInput({'type': 'Exit'})
  call forms#example#deck2#Make()
endfunction
