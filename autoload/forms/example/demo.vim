
" ------------------------------------------------------------ 
" forms#example#demo#Make:
"  A form allowing user to run Forms example usages.
"    The form has: 
"      Label 
"      Text 
"      Button
"    Example:
"       ┌────────────────────────────┐
"       │Changing Fonts not supported│
"       │────────────────────────────│
"       │                       Close│
"       └────────────────────────────┘
"
"  parameters: None
" ------------------------------------------------------------ 
" forms#example#demo#Make: {{{1
function! forms#example#demo#Make()
" call forms#log("forms#example#demo#Make")

  let label = forms#newLabel({ 'text': 'Examples'})

  let info = forms#newText({'textlines': [
        \ "Click a button to run Form.", 
        \ "Remember, entering <ESC> lets you exit any Form.", 
        \ "Navigate using <Tab>, <S-Tab>, <C-P> and <C-N>.", 
        \ "Also, navigate using <LeftMouse> and <ScrollWheelUp/Down>.", 
        \ "Select a button using <CR>, <Space>, of <LeftMouse>", 
                                      \ ]})

  let children = []
  let vspace = forms#newVSpace({'size': 1})

  let FN = function("forms#example#dropshadow#Make")
  let g = s:MakeExample('DropShadow', FN)
  call add(children, g)
  call add(children, vspace)

  let FN = function("forms#example#frame#Make")
  let g = s:MakeExample('Frames', FN)
  call add(children, g)
  call add(children, vspace)

  let FN = function("forms#example#popdownlist#Make")
  let g = s:MakeExample('PopDownList', FN)
  call add(children, g)
  call add(children, vspace)

  let FN = function("forms#example#slider#Make")
  let g = s:MakeExample('Sliders', FN)
  call add(children, g)
  call add(children, vspace)

  let FN = function("forms#example#resize#Make")
  let g = s:MakeExample('ReSize', FN)
  call add(children, g)
  call add(children, vspace)

  let FN = function("forms#dialog#info#Make")
  let textlines = "Display some information.\nText can be on multiple lines." 
  let g = s:MakeExample('Information', FN, textlines)
  call add(children, g)

  let hpoly1 = forms#newHPoly({'children': children,
                                    \ 'alignment': 'C' })

  let children = []


  let FN = function("forms#dialog#input#Make")
  let textlines = "User should add requested input.\n\nCan be on multiple lines." 
  let g = s:MakeExample('GetInput', FN, textlines)
  call add(children, g)
  call add(children, vspace)

  let FN = function("forms#dialog#textsearch#Make")
  let g = s:MakeExample('TextSearch', FN, "Find Text", 1)
  call add(children, g)
  call add(children, vspace)

  let FN = function("forms#dialog#textsearch#Make")
  let g = s:MakeExample('TextSearch&Replace', FN, "Find and Replace Text", 0)
  call add(children, g)
  call add(children, vspace)

  let FN = function("forms#dialog#confirm#Make")
  let textlines = "User should pick one.\nCan be on multiple lines." 
  let choices = "Apple\nOrange\nPear\nPeach" 
  let def = 2

  let g = s:MakeExample('ConfirmChoice', FN, textlines, choices, def)
  call add(children, g)

  let hpoly2 = forms#newHPoly({'children': children,
                                    \ 'alignment': 'C' })

  let children = []

  let FN = function("forms#dialog#filebrowser#Make")
  let g = s:MakeExample('FileBrowser', FN)
  call add(children, g)
  call add(children, vspace)

  let FN = function("forms#dialog#directorybrowser#Make")
  let g = s:MakeExample('DirectoryBrowser', FN)
  call add(children, g)
  call add(children, vspace)

  let FN = function("forms#dialog#colorchooser#Make")
  let g = s:MakeExample('ColorChooser', FN)
  call add(children, g)
  call add(children, vspace)

  let FN = function("forms#dialog#palletdesigner#Make")
  let g = s:MakeExample('PalletDesigner', FN)
  call add(children, g)


  let hpoly3 = forms#newHPoly({'children': children,
                                    \ 'alignment': 'C' })

  let children = []

  let FN = function("forms#menu#MakeMenu")
  let g = s:MakeExample('MenuBar', FN, 'n')
  call add(children, g)
  call add(children, vspace)

  let FN = function("forms#menu#MakePopUp")
  let g = s:MakeExample('PopUp', FN, 'n')
  call add(children, g)
  call add(children, vspace)

  let FN = function("forms#example#boxchars#Make")
  let g = s:MakeExample('BoxChars', FN)
  call add(children, g)
  call add(children, vspace)

  let FN = function("forms#example#labels#Make")
  let g = s:MakeExample('Labels', FN)
  call add(children, g)
  call add(children, vspace)

  let FN = function("forms#example#editors#Make")
  let g = s:MakeExample('Editors', FN)
  call add(children, g)
  call add(children, vspace)

  let FN = function("forms#example#vlabels#Make")
  let g = s:MakeExample('VLabels', FN)
  call add(children, g)
  call add(children, vspace)

  let FN = function("forms#example#fixedlayout#Make")
  let g = s:MakeExample('FixedLayout', FN)
  call add(children, g)


  let hpoly4 = forms#newHPoly({'children': children,
                                    \ 'alignment': 'C' })

  let children = []

  let FN = function("forms#example#foureditors#Make")
  let g = s:MakeExample('FourEditors', FN)
  call add(children, g)
  call add(children, vspace)

  let FN = function("forms#example#texteditor#Make")
  let g = s:MakeExample('TextEditor', FN)
  call add(children, g)
  call add(children, vspace)

  let FN = function("forms#example#form1#Make")
  let g = s:MakeExample('FormOne', FN)
  call add(children, g)
  call add(children, vspace)

  let FN = function("forms#example#form2#Make")
  let g = s:MakeExample('FormTwo', FN)
  call add(children, g)
  call add(children, vspace)

  let FN = function("forms#example#deck1#Make")
  let g = s:MakeExample('DeckOne', FN)
  call add(children, g)
  call add(children, vspace)

  let FN = function("forms#example#deck2#Make")
  let g = s:MakeExample('DeckTwo', FN)
  call add(children, g)

  let hpoly5 = forms#newHPoly({'children': children,
                                    \ 'alignment': 'C' })

  let children = []

  let FN = function("forms#example#checkboxes#Make")
  let g = s:MakeExample('CheckBoxes', FN)
  call add(children, g)
  call add(children, vspace)

  let FN = function("forms#example#radiobuttons#Make")
  let g = s:MakeExample('RadioButtons', FN)
  call add(children, g)
  call add(children, vspace)

  let FN = function("forms#example#togglebuttons#Make")
  let g = s:MakeExample('ToggleButtons', FN)
  call add(children, g)
  call add(children, vspace)

  let FN = function("forms#example#selectlists#Make")
  let g = s:MakeExample('SelectLists', FN)
  call add(children, g)
  call add(children, vspace)

  let FN = function("forms#example#subform#Make")
  let g = s:MakeExample('SubForm', FN)
  call add(children, g)
  call add(children, vspace)

  let hpoly6 = forms#newHPoly({'children': children,
                                    \ 'alignment': 'C' })

  let children = []

  let FN = function("forms#example#longmenu#Make")
  let g = s:MakeExample('LongMenu', FN)
  call add(children, g)
  call add(children, vspace)

  let FN = function("forms#example#menusubmenu#Make")
  let g = s:MakeExample('Menu&SubMenu', FN)
  call add(children, g)
  call add(children, vspace)

  let FN = function("forms#example#editors2#Make")
  let g = s:MakeExample('VariableEditors', FN)
  call add(children, g)
  call add(children, vspace)

  let FN = function("forms#example#text#Make")
  let g = s:MakeExample('Text', FN)
  call add(children, g)
  call add(children, vspace)

  let FN = function("forms#example#labelsingrid#Make")
  let g = s:MakeExample('LabelsInGrid', FN)
  call add(children, g)
  call add(children, vspace)

  let hpoly7 = forms#newHPoly({'children': children,
                                    \ 'alignment': 'C' })

  let children = []

  let FN = function("forms#example#labels2#Make")
  let g = s:MakeExample('MoreLabels', FN)
  call add(children, g)
  call add(children, vspace)

  let FN = function("forms#example#labels3#Make")
  let g = s:MakeExample('AndMoreLabels', FN)
  call add(children, g)
  call add(children, vspace)

  let FN = function("forms#example#labelsaligned#Make")
  let g = s:MakeExample('AlignedLabels', FN)
  call add(children, g)
  call add(children, vspace)

  let FN = function("forms#example#labelvaligned#Make")
  let g = s:MakeExample('VAlignedLabel', FN)
  call add(children, g)
  call add(children, vspace)

  let hpoly8 = forms#newHPoly({'children': children,
                                    \ 'alignment': 'C' })

  let children = []

  let FN = function("forms#example#dotvimviewer#Make")
  let g = s:MakeExample('VimHomeViewer', FN)
  call add(children, g)
  call add(children, vspace)

  let FN = function("forms#example#runtimepathviewer#Make")
  let g = s:MakeExample('RuntimePathViewer', FN)
  call add(children, g)
  call add(children, vspace)

  let hpoly9 = forms#newHPoly({'children': children,
                                    \ 'alignment': 'C' })

  let hspace = forms#newHSpace({'size': 1})
  let vpoly = forms#newVPoly({ 'children': [
                                    \ label, 
                                    \ info, 
                                    \ hspace, 
                                    \ hpoly1, 
                                    \ hspace, 
                                    \ hpoly2, 
                                    \ hspace, 
                                    \ hpoly3, 
                                    \ hspace, 
                                    \ hpoly4, 
                                    \ hspace, 
                                    \ hpoly5, 
                                    \ hspace, 
                                    \ hpoly6, 
                                    \ hspace, 
                                    \ hpoly7, 
                                    \ hspace, 
                                    \ hpoly8, 
                                    \ hspace, 
                                    \ hpoly9], 
                                    \ 'alignment': 'C' })

  let b = forms#newBorder({ 'body': vpoly })
  let b = forms#newBox({ 'body': b })
  let bg = forms#newBackground({ 'body': b} )
  let form = forms#newForm({'body': bg })
  call form.run()
endfunction

function! RunAction(...) dict
  if exists("self.args")
    call call(self.FN, self.args)
  else
    call self.FN()
  endif
  " in case the form/dialog added (submit,cancel, etc.) to the 
  " inputlist
  call forms#ClearInputList()
endfunction

function! s:MakeExample(title, FN, ...)

  let label = forms#newLabel({ 'text': a:title})
  let action = forms#newAction({ 'execute': function("RunAction")})
  let action.FN = a:FN
  if a:0 > 0
    let action.args = a:000
  endif
  let button = forms#newButton({
                                \ 'body': label, 
                                \ 'action': action})

  let vpoly = forms#newVPoly({ 'children': [
                                    \ button], 
                                    \ 'alignment': 'C' })
  return vpoly
endfunction

" forms#example#demo#MakeTest: {{{1
function! forms#example#demo#MakeTest()
  call forms#example#dropshadow#MakeTest()
  call forms#example#frame#MakeTest()
  call forms#example#popdownlist#MakeTest()
  call forms#example#slider#MakeTest()
  call forms#example#resize#MakeTest()
  call forms#dialog#info#MakeTest()
  call forms#dialog#input#MakeTest()
  call forms#dialog#textsearch#MakeTest()
  " call forms#dialog#textsearch#MakeTest()
  call forms#dialog#confirm#MakeTest()
  call forms#dialog#filebrowser#MakeTest()
  call forms#dialog#colorchooser#MakeTest()
  call forms#dialog#palletdesigner#MakeTest()
  call forms#menu#MakeMenuTest()
  call forms#menu#MakePopUpTest()
  call forms#example#boxchars#MakeTest()
  call forms#example#labels#MakeTest()
  call forms#example#editors#MakeTest()
  call forms#example#vlabels#MakeTest()
  call forms#example#fixedlayout#MakeTest()
  call forms#example#foureditors#MakeTest()
  call forms#example#texteditor#MakeTest()
  call forms#example#form1#MakeTest()
  " currently a duplicate of form1
  " call forms#example#form2#MakeTest()
  call forms#example#deck1#MakeTest()
  call forms#example#deck2#MakeTest()
  call forms#example#checkboxes#MakeTest()
  call forms#example#radiobuttons#MakeTest()
  call forms#example#togglebuttons#MakeTest()
  call forms#example#selectlists#MakeTest()
  call forms#example#subform#MakeTest()
  call forms#example#longmenu#MakeTest()
  call forms#example#menusubmenu#MakeTest()
  call forms#example#editors2#MakeTest()
  call forms#example#text#MakeTest()
  call forms#example#labelsingrid#MakeTest()
  call forms#example#labels2#MakeTest()
  call forms#example#labels3#MakeTest()
  call forms#example#labelsaligned#MakeTest()
  call forms#example#labelvaligned#MakeTest()
endfunction

"  Modelines: {{{1
" ================
" vim: ts=4 fdm=marker
