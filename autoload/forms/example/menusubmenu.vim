
function! forms#example#menusubmenu#Make()
  function! M0Action(...) dict
  endfunction
  let action_one = forms#newAction({ 'execute': function("M0Action")})
  let action_one.name = 'ONE'

  let action_two = forms#newAction({ 'execute': function("M0Action")})
  let action_two.name = 'TWO'

  let group = forms#newButtonGroup({ 'member_type': 'forms#RadioButton'})

  let subattrs = {
        \ 'items' : [
        \ { 'type': 'label',
        \   'label': 'SubMenu'
        \ },
        \ { 'type': 'separator' },
        \ { 'type': 'button',
        \   'label': 'Button &One',
        \   'highlight': 0, 
        \   'action': action_one
        \ },
        \ { 'type': 'separator' },
        \ { 'type': 'button',
        \   'label': 'Button &Two',
        \   'highlight': 0, 
        \   'action': action_two
        \ }
        \ ]
        \ }
  let submenu = forms#newMenu(subattrs)

  let attrs = {
        \ 'items' : [
        \ { 'type': 'button',
        \   'label': 'Button &One',
        \   'highlight': 0, 
        \   'action': action_one
        \ },
        \ { 'type': 'separator' },
        \ { 'type': 'button',
        \   'label': 'Button &Two',
        \   'highlight': 0, 
        \   'action': action_two
        \ },
        \ { 'type': 'separator' },
        \ { 'type': 'checkbox',
        \   'tag': 'Stereo',
        \   'label': '&Stereo'
        \ },
        \ { 'type': 'checkbox',
        \   'tag': 'Woofer',
        \   'label': '&Woofer'
        \ },
        \ { 'type': 'separator' },
        \ { 'type': 'label',
        \   'label': 'Volume Control'
        \ },
        \ { 'type': 'radiobutton',
        \   'group': group,
        \   'tag': 'VolumeHigh',
        \   'label': '&High'
        \ },
        \ { 'type': 'radiobutton',
        \   'group': group,
        \   'tag': 'VolumeMedium',
        \   'selected': 1,
        \   'label': '&Medium'
        \ },
        \ { 'type': 'radiobutton',
        \   'group': group,
        \   'tag': 'VolumeLow',
        \   'label': '&Low'
        \ },
        \ { 'type': 'separator' },
        \ { 'type': 'menu',
        \   'menu': submenu,
        \   'label': 'Su&bMenu'
        \ }
        \ ]
        \ }
  let menu = forms#newMenu(attrs)

  let form = forms#newForm({'body': menu})
  call form.run()
endfunction
