
" ------------------------------------------------------------ 
" forms#dialog#textsearch#Make:
"  A form to search or search-and-replace text.
"    The form has: 
"      Label (title)
"      VariableLengthField (find and replace)
"      ToggleButtons (match)
"      RadioButtons (Up/Down)
"      Find, Replace, and Close buttons
"    Example:
"       ┌──────────────────────────────────────────────┐
"       │                  Text Search                 │
"       ├──────────────────────────────────────────────┤
"       │   Find what:thix                  Find next  │
"       │Replace with:                      Replace    │
"       │                                   Replace All│
"       │[ ]Match whole word only Direction Close      │
"       │[X]Match case            ( )Up                │
"       │                         (*)Down              │
"       └──────────────────────────────────────────────┘

"  parameters:
"     title    : title of dialog
"     findonly : if true (1) then search only otherwise
"                  find and replace.
"     initial_text: optional initial search text
" ------------------------------------------------------------ 
" map <Leader>v8 :call forms#dialog#textsearch#Make('Text Search', 0, 'thix')<CR>
" forms#dialog#textsearch#Make: {{{1
function!  forms#dialog#textsearch#Make(title, findonly, ...) 
  function! V8Action(...) dict
    call self.findbutton.doSelect()
  endfunction
  let we_action = forms#newAction({ 'execute': function("V8Action")})

  let children = []
  let label = forms#newLabel({ 'text': 'Find what:' })
  call add(children, label)

  let we = forms#newVariableLengthField({
                                       \ 'tag': 'what_editor',
                                       \ 'size': 10,
                                       \ 'on_selection_action': we_action
                                       \ })
  function! we.purpose() dict
    return [
        \ "Enter the string that is to be searched for."
        \ ]
  endfunction
  if a:0 > 0 && a:1 != ''
    call we.setText(a:1)
  endif

  call add(children, we)
  let thpoly = forms#newHPoly({'children': children })

  let children = []
  call add(children, thpoly)


  if ! a:findonly
    " optional
    let rwchildren = []
    let label = forms#newLabel({ 'text': 'Replace with:' })
    call add(rwchildren, label)

    let re = forms#newVariableLengthField({
                                         \ 'tag': 'replace_editor',
                                         \ 'size': 10,
                                         \ 'on_selection_action': we_action
                                         \ })
    function! re.purpose() dict
      return [
          \ "Enter the string that is to replace the search string."
          \ ]
    endfunction

    call add(rwchildren, re)

    let mhpoly = forms#newHPoly({'children': rwchildren })
    call add(children, mhpoly)
  endif

  let mvpoly = forms#newVPoly({'children': children,
                              \ 'alignment': 'R'})

  " match whole word only
  let cbmw = forms#newCheckBox({'tag': 'match_word'})
  function! cbmw.purpose() dict
    return [
        \ "Should the search command match whole word only."
        \ ]
  endfunction
  let lmw = forms#newLabel({'text': "Match whole word only"})
  let hpolymw = forms#newHPoly({'children': [cbmw, lmw] })

  " match case
  let cbmc = forms#newCheckBox({'tag': 'match_case', 'selected': 1 })
  function! cbmc.purpose() dict
    return [
        \ "Should the search command match on case or be case independent."
        \ ]
  endfunction
  let lmc = forms#newLabel({'text': "Match case"})
  let hpolymc = forms#newHPoly({'children': [cbmc, lmc] })

  let tbsvpoly = forms#newVPoly({'children': [hpolymw, hpolymc] })

  " Direction
  let ld = forms#newLabel({'text': "Direction"})
  let group = forms#newButtonGroup({ 'member_type': 'forms#RadioButton'})

  let rbdu = forms#newRadioButton({'tag': 'dir_up', 'group': group})
  function! rbdu.purpose() dict
    return [
        \ "Search from current postion Up the text."
        \ ]
  endfunction
  let ldu = forms#newLabel({'text': "Up"})
  let polydu = forms#newHPoly({'children': [rbdu, ldu] })

  let rbdd = forms#newRadioButton({'tag': 'dir_down', 
                                  \ 'selected': 1,
                                  \ 'group': group})
  function! rbdd.purpose() dict
    return [
        \ "Search from current postion Down the text."
        \ ]
  endfunction
  let ldd = forms#newLabel({'text': "Down"})
  let polydd = forms#newHPoly({'children': [rbdd, ldd] })

  let dvpoly = forms#newVPoly({'children': [ld, polydu, polydd] })

  let hspace = forms#newHSpace({'size': 1})

  " Match checkboxes and Direction
  let bhpoly = forms#newHPoly({'children': [tbsvpoly, hspace, dvpoly] })

  " left side
  let vspace = forms#newVSpace({'size': 1})
  let lvpoly = forms#newVPoly({'children': [mvpoly, vspace, bhpoly] })
  
  " right side
  let children = []
  let attrs = { 'text': 'Find next'}
  let findlabel = forms#newLabel(attrs)
  let findbutton = forms#newButton({
                              \ 'tag': 'find', 
                              \ 'body': findlabel, 
                              \ 'action': g:forms#submitAction})
  function! findbutton.purpose() dict
    return [
        \ "Find the next search match."
        \ ]
  endfunction
  call add(children, findbutton)
  let we_action.findbutton = findbutton

  if ! a:findonly
    " optional
    let attrs = { 'text': 'Replace'}
    let replacelabel = forms#newLabel(attrs)
    let replacebutton = forms#newButton({
                                \ 'tag': 'replace', 
                                \ 'body': replacelabel, 
                                \ 'action': g:forms#submitAction})
    function! replacebutton.purpose() dict
      return [
          \ "Find and replace the next search match."
          \ ]
    endfunction
    call add(children, replacebutton)

    " optional
    let attrs = { 'text': 'Replace All'}
    let replacealllabel = forms#newLabel(attrs)
    let replaceallbutton = forms#newButton({
                                \ 'tag': 'replaceall', 
                                \ 'body': replacealllabel, 
                                \ 'action': g:forms#submitAction})
    function! replaceallbutton.purpose() dict
      return [
          \ "Find and replace all of the search matches."
          \ ]
    endfunction
    call add(children, replaceallbutton)
  endif

  let attrs = { 'text': 'Close'}
  let closelabel = forms#newLabel(attrs)
  let closebutton = forms#newButton({
                              \ 'tag': 'close', 
                              \ 'body': closelabel, 
                              \ 'action': g:forms#cancelAction})
  function! closebutton.purpose() dict
    return [
        \ "Close the Form and take no action."
        \ ]
  endfunction
  call add(children, closebutton)

  let rvpoly = forms#newVPoly({'children': children })

  let hspace = forms#newHSpace({'size': 1})
  let hpoly = forms#newHPoly({'children': [
                                \ lvpoly, 
                                \ hspace, 
                                \ rvpoly] })


  " let box = forms#newBox({ 'body': hpoly })
  " let bg = forms#newBackground({ 'body': box })
  let attrs = { 'text': a:title }
  let titlelabel = forms#newLabel(attrs)
  let topvpoly = forms#newVPoly({'children': [
                                \ titlelabel, 
                                \ hpoly],
                                \ 'alignment': 'C',
                                \ 'mode': 'light'
                                \ })
  let bg = forms#newBackground({ 'body': topvpoly })
  let form = forms#newForm({'body': bg })
  function! form.purpose() dict
    return [
        \ "Create a search term and search command."
        \ ]
  endfunction
  let results = form.run()
  if type(results) == g:self#DICTIONARY_TYPE
    let sterm = results.what_editor

    if results.match_word
      let sterm = '\<'.sterm.'\>'
    endif
    if results.match_case
      let sterm = sterm.'\C'
    else
      let sterm = sterm.'\c'
    endif

    if a:findonly
      " Find
      if results.find 
        if results.dir_down 
          return '/'.sterm
        else
          return '?'.sterm
        endif
      else
        return ''
      endif
    else
      " Find and Replace
      if results.find 
        if results.dir_down 
          return '/'.sterm
        else
          return '?'.sterm
        endif
      elseif results.replace
        return 's/'.sterm.'/'.results.replace_editor.'/'
      elseif results.replaceall
        return 'g/'.sterm.'/s//'.results.replace_editor.'/g'
      else
        return ''
      endif
    endif
  endif
  return ''
endfunction

"  Modelines: {{{1
" ================
" vim: ts=4 fdm=marker
