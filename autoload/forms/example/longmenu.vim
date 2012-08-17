
function! forms#example#longmenu#Make()
  function! M0Action(...) dict
  endfunction
  let action_one = forms#newAction({ 'execute': function("M0Action")})
  let action_one.name = 'ONE'

  let action_two = forms#newAction({ 'execute': function("M0Action")})
  let action_two.name = 'TWO'

  let group = forms#newButtonGroup({ 'member_kind': 'forms#RadioButton'})

  let items = []

  call add(items, { 
        \ 'type': 'button',
        \ 'label': 'Button &One',
        \ 'highlight': 0, 
        \ 'action': action_one
        \ })
  call add(items, {'type': 'separator' })
  call add(items, { 
        \ 'type': 'button',
        \ 'label': 'Button &Two',
        \ 'highlight': 0, 
        \ 'action': action_two
        \ })
  call add(items, {'type': 'separator' })
  call add(items, { 
        \ 'type': 'checkbox',
        \ 'tag': 'Stereo',
        \ 'label': '&Stereo'
        \ })
  call add(items, { 
        \ 'type': 'checkbox',
        \ 'tag': 'Woofer',
        \ 'label': '&Woofer'
        \ })
  call add(items, {'type': 'separator' })
  call add(items, { 
        \ 'type': 'label',
        \ 'label': 'Volume Control'
        \ })
  call add(items, { 
        \ 'type': 'radiobutton',
        \ 'group': group,
        \ 'tag': 'VolumeHigh',
        \ 'label': '&High'
        \ })
  call add(items, { 
        \ 'type': 'radiobutton',
        \ 'group': group,
        \ 'tag': 'VolumeMedium',
        \ 'selected': 1,
        \ 'label': '&Medium'
        \ })
  call add(items, { 
        \ 'type': 'radiobutton',
        \ 'group': group,
        \ 'tag': 'VolumeLow',
        \ 'label': '&Low'
        \ })

  let cnt = 0
  while cnt < 15
    call add(items, { 
          \ 'type': 'button',
          \ 'label': 'Button '.cnt,
          \ 'action': action_one
          \ })

    let cnt += 1
  endwhile
  call add(items, { 
        \ 'type': 'button',
        \ 'label': '&Button '.cnt,
        \ 'action': action_one
        \ })

  let attrs = {'items' : items,
              \ 'size': 13
              \ }
  let menu = forms#newMenu(attrs)

  let form = forms#newForm({'body': menu})
  call form.run()
endfunction

function! forms#example#longmenu#MakeTest()
  call forms#AppendInput({'type': 'Sleep', 'time': 5})
  call forms#AppendInput({'type': 'Exit'})
  call forms#example#longmenu#Make()
endfunction
