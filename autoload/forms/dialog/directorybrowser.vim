
" ------------------------------------------------------------ 
" forms#dialog#directorybrowser#Make:
"  A form to browse file system and select directory.
"    The form has: 
"      Label (title)
"      VariableLengthField (file name)
"      SelectList 
"      Cancel and Open buttons
"    Example:
"       ┌───────────────────────────┐
"       │     Directory Browser     │
"       ├───────────────────────────┤
"       │┌─────────────────────────┐│
"       ││                         ││
"       │└─────────────────────────┘│
"       │┌─────────────────┐        │
"       ││../              │        │
"       ││build/           │        │
"       ││examples/        │        │
"       ││extra/           │        │
"       ││ivy/             │        │
"       ││lib/             │        │
"       ││other/           │        │
"       ││src/             │        │
"       ││tmp/             │        │
"       ││                 │        │
"       │└─────────────────┘        │
"       │                Cancel Open│
"       └───────────────────────────┘
"
"  parameters:
"     attrs: optional Dictionary
"             title: title (default Directory Browser)
"             dir: initial directory (default cwdir)
" ------------------------------------------------------------ 
" forms#dialog#directorybrowser#Make: {{{1
function! forms#dialog#directorybrowser#Make(...) 

  function! DBMakeChoices(dir) 
    let files = split(globpath(a:dir, "*"), '\n')
    let dotfiles = split(globpath(a:dir, ".*"), '\n')
    let dlist = []
    let cnt = 1
    for dotfile in dotfiles
      let index = strridx(dotfile, '/')+1
      let dirname = strpart(dotfile, index, len(dotfile)-index)
      if isdirectory(dotfile) && dirname != '.'
        call add(dlist, [dirname.'/', cnt])
      endif

      let cnt += 1
    endfor
    for file in files
      let index = strridx(file, '/')+1
      let dirname = strpart(file, index, len(file)-index)
      if isdirectory(file)
        call add(dlist, [dirname.'/', cnt])
      endif

      let cnt += 1
    endfor
    return dlist
  endfunction

  let title = 'Directory Browser'
  let initial_dir = getcwd()
  if a:0 != 0
    if ! type(a:1) == g:self#DICTIONARY_TYPE
      throw "Error: forms#dialog#directorybrowser#Make bad argument type: " .string(a:1)
    endif
    let dict = a:1
    if has_key(dict, 'title')
      let title = dict['title']
    endif
    if has_key(dict, 'dir')
      let initial_dir = dict['dir']
    endif
  endif

  let attrs = { 'text': title }
  let titleLabel = forms#newLabel(attrs)

  function! DBVLFAction(...) dict
    call self.acceptbutton.doSelect()
  endfunction
  let dnaction = forms#newAction({ 'execute': function("DBVLFAction")})

  let esize = 25
  let fn = forms#newVariableLengthField({
                                       \ 'tag': 'editor',
                                       \ 'size': esize,
                                       \ 'on_selection_action': dnaction
                                       \ })
  function! fn.purpose() dict
    return [
        \ "Use editor ot enter a filename.",
        \ "  Enter <CR> to accept the entered filename."
        \ ]
  endfunction
  let fnbox = forms#newBox({'body': fn})

  function! DBAction(...) dict
    let slist = self.slist
    let fn = self.fn
    let pos = slist.__selections[0][0]
    let [dirname,_] = slist.__choices[pos]

    let dir = self.dir
    let dir = simplify(dir . '/' . dirname)
    let self.dir = dir
    let choices = DBMakeChoices(dir) 
    let attrs = { 
          \ 'tag': 'selection',
          \ 'mode': 'single',
          \ 'pos': 0,
          \ 'choices': choices,
          \ 'size': slist.__size,
          \ 'on_selection_action': self
        \ }
    call slist.reinit(attrs)
    call fn.setText(dir)
    let fn.__pos = len(dir)
    call fn.adjustWinStart()
  endfunction
  let dbaction = forms#newAction({ 'execute': function("DBAction")})
  let dbaction.fn = fn

  let dir = getcwd()

  call fn.setText(initial_dir)
  let fn.__pos = len(initial_dir)
  call fn.adjustWinStart()

  let choices = DBMakeChoices(initial_dir) 

  " SelectList
  let ssize = 10
  let attrs = { 
          \ 'tag': 'selection',
          \ 'mode': 'single',
          \ 'choices': choices,
          \ 'size': ssize,
          \ 'on_selection_action': dbaction
          \ }
  let slist = forms#newSelectList(attrs)
  function! slist.purpose() dict
    return [
        \ "Navigate file system with select list.",
        \ "  Select ../ to move up a directory. Select a directory",
        \ "  name to enter that directory, Select a directory to enter",
        \ "  the directory into the editor."
        \ ]
  endfunction
  let dbaction.slist = slist
  let dbaction.dir = initial_dir
  let slistbox = forms#newBox({ 'body': slist} )
  
  " Bottom HPoly
  let hspaceB = forms#newHSpace({'size': 1})

  let attrs = { 'text': 'Cancel'}
  let cancellabel = forms#newLabel(attrs)
  let cancelbutton = forms#newButton({
                              \ 'tag': 'cancel', 
                              \ 'body': cancellabel, 
                              \ 'action': g:forms#cancelAction})
  function! cancelbutton.purpose() dict
    return [
        \ "Make no selection, cancel operation."
        \ ]
  endfunction
  let attrs = { 'text': 'Accept'}
  let acceptlabel = forms#newLabel(attrs)
  let acceptbutton = forms#newButton({
                              \ 'tag': 'accept', 
                              \ 'body': acceptlabel, 
                              \ 'action': g:forms#submitAction})
  function! acceptbutton.purpose() dict
    return [
        \ "Accept the directoryname in the editor."
        \ ]
  endfunction
  let dnaction.acceptbutton = acceptbutton

  let hpoly = forms#newHPoly({'children': [
                                \ cancelbutton, 
                                \ hspaceB, 
                                \ acceptbutton] })

  let vpoly = forms#newVPoly({'children': [
                                \ fnbox, 
                                \ slistbox, 
                                \ hpoly],
                                \ 'alignments': [[2,'R']]
                                \ })
  let topvpoly = forms#newVPoly({'children': [
                                \ titleLabel, 
                                \ vpoly],
                                \ 'mode': 'light',
                                \ 'alignment': 'C'
                                \ })

  " let b = forms#newBorder({ 'body': vpoly })
  let bg = forms#newBackground({ 'body': topvpoly })
  let form = forms#newForm({'body': bg })
  function! form.purpose() dict
    return [
        \ "Navigate the file system and select a directory.",
        \ "  Use editor to enter a directory name or the select list",
        \ "  to navigate the file system and make a directory selection.",
        \ "  Press Cancel to make no selection.",
        \ "  Press Open to make directory selection."
        \ ]
  endfunction
  let results = form.run()
  if type(results) == g:self#DICTIONARY_TYPE
    if results.accept 
      let rval = results.editor
      return rval
    endif
  endif
  return ''
endfunction

" forms#dialog#directorybrowser#MakeTest: {{{1
function! forms#dialog#directorybrowser#MakeTest() 
  call forms#AppendInput({'type': 'Sleep', 'time': 5})
  call forms#AppendInput({'type': 'Exit'})
  call forms#dialog#directorybrowser#Make() 
endfunction

"  Modelines: {{{1
" ================
" vim: ts=4 fdm=marker
