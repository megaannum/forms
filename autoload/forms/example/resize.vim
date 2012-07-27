
function! forms#example#resize#Make()

  let attrs = { 'text': 'A Label: What is my Status', 'status': g:IS_ENABLED}
  let l = forms#newLabel(attrs)

  function! V6Action(...) dict
    let glyph = self.glyph
    let lstatus = glyph.__status

    if lstatus == g:IS_ENABLED
      call glyph.setStatus(g:IS_DISABLED)
    elseif lstatus == g:IS_DISABLED
      call glyph.setStatus(g:IS_INVISIBLE)
    else
      call glyph.setStatus(g:IS_ENABLED)
    endif
  endfunction

  let statuschangelabel = forms#newAction({ 'execute': function("V6Action")})
  let statuschangelabel.glyph = l
  let attrs = { 'text': 'Change Label Status'}
  let slabel = forms#newLabel(attrs)
  let restatuslabel = forms#newButton({ 
                              \ 'tag': 'restatuslabel',  
                              \ 'body': slabel,  
                              \ 'action': statuschangelabel})


  let attrs = { 'text': 'Cancel'}
  let cancellabel = forms#newLabel(attrs)
  let cancelbutton = forms#newButton({
                              \ 'tag': 'cancel', 
                              \ 'body': cancellabel, 
                              \ 'action': g:forms#cancelAction})

  let statuschangecancel = forms#newAction({ 'execute': function("V6Action")})
  let statuschangecancel.glyph = cancelbutton
  let attrs = { 'text': 'Change Cancel Status'}
  let clabel = forms#newLabel(attrs)
  let restatuscancel = forms#newButton({ 
                              \ 'tag': 'restatuscancel',  
                              \ 'body': clabel,  
                              \ 'action': statuschangecancel})

  let vpoly = forms#newVPoly({ 'children': [l, restatuslabel, restatuscancel, cancelbutton] })

  let border = forms#newBorder({ 'body': vpoly, 'size': 2 })
  let bg = forms#newBackground({ 'body': border })
  let form = forms#newForm({'body': bg })
  call form.run()
endfunction


