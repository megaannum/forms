
" ------------------------------------------------------------ 
" forms#dialog#color#Make:
"  A form that display information and provides choice 
"      buttons.
"    The form has: 
"      Text 
"      Buttons for all choices
"    Example:
"       see forms#dialog#colorchooser#Make and
"           forms#dialog#palletdesigner#Make and
"       
"  parameters:
"     with_pallet : Boolean if 0 then Color Chooser else 
"                    Pallet Designer
" ------------------------------------------------------------ 
" forms#dialog#color#Make: {{{1
if ! exists("g:forms#dialog#color#tint1Init")
  let g:forms#dialog#color#tint1Init = 0.75
endif
if ! exists("g:forms#dialog#color#shade1Init")
  let g:forms#dialog#color#shade1Init = 0.0
endif
if ! exists("g:forms#dialog#color#tint2Init")
  let g:forms#dialog#color#tint2Init = 0.50
endif
if ! exists("g:forms#dialog#color#shade2Init")
  let g:forms#dialog#color#shade2Init = 0.0
endif
if ! exists("g:forms#dialog#color#tint3Init")
  let g:forms#dialog#color#tint3Init = 0.0
endif
if ! exists("g:forms#dialog#color#shade3Init")
  let g:forms#dialog#color#shade3Init =  0.33
endif
if ! exists("g:forms#dialog#color#tint4Init")
  let g:forms#dialog#color#tint4Init = 0.0
endif
if ! exists("g:forms#dialog#color#shade4Init")
  let g:forms#dialog#color#shade4Init =  0.66
endif

" Double Complimentary
if ! exists("g:forms#dialog#color#doubleComplimentaryShiftInit")
  let g:forms#dialog#color#doubleComplimentaryShiftInit =  30.0/360
endif
" Accented Analogic
if ! exists("g:forms#dialog#color#accentedAnalogicShiftInit")
  let g:forms#dialog#color#accentedAnalogicShiftInit =  30.0/360
endif
" Analogic
if ! exists("g:forms#dialog#color#analogicShiftInit")
  let g:forms#dialog#color#analogicShiftInit =  30.0/360
endif
" Split Complimentary
if ! exists("g:forms#dialog#color#splitComplimentaryShiftInit")
  let g:forms#dialog#color#splitComplimentaryShiftInit =  30.0/360
endif

function!  forms#dialog#color#Make(with_pallet)
  "........................................
  " Slider to Info
  "........................................
  function! CCSlider2InfoAction(...) dict
" call forms#log("CCSlider2InfoAction.execute: TOP")
    let rtxt = self.reditor.getText()
    let gtxt = self.geditor.getText()
    let btxt = self.beditor.getText()

    let rn = str2nr(rtxt, 10)
    let gn = str2nr(gtxt, 10)
    let bn = str2nr(btxt, 10)
" call forms#log("CCSlider2InfoAction: read   time=". reltimestr(reltime(start)))

    " let rhtxt = printf('%02x',rn)
    " let ghtxt = printf('%02x',gn)
    " let bhtxt = printf('%02x',bn)
    " let rgbtxt = rhtxt.ghtxt.bhtxt
    let rgbtxt = printf('%02x%02x%02x',rn,gn,bn)
" call forms#log("CCSlider2InfoAction.execute: rgbtxt=".rgbtxt)
    call self.rgbeditor.setText(rgbtxt)

    let n = forms#color#term#ConvertRGB_2_Int(rn,gn,bn)
" call forms#log("CCSlider2InfoAction.execute: n=".n)
    call self.neditor.setText(n)

    let hiname = 'XXHi'
    execute ":hi ".hiname." ctermbg=".n." guibg=#".rgbtxt
    if exists("self.palletaction")
      call self.palletaction.execute(rn, gn, bn)
    endif

  endfunction
  let slider2infoa = forms#newAction({ 'execute': function("CCSlider2InfoAction")})
  
  " the RGB text value was not a valid hex number, so reset the
  " rgb editor from the contents of the r, g, b editors
  function! CCResetRDBEditorFromOtherEditors(rgbeditor, reditor, geditor, beditor)
    let rtxt = a:reditor.getText()
    let gtxt = a:geditor.getText()
    let btxt = a:beditor.getText()
    let rn = str2nr(rtxt, 10)
    let gn = str2nr(gtxt, 10)
    let bn = str2nr(btxt, 10)
    let rgbtxt = printf('%02x%02x%02x',rn,gn,bn)
    call a:rgbeditor.setText(rgbtxt)
  endfunction

  "........................................
  " Info RGB editor to others
  "........................................
  function! CCRGBEditor2OthersAction(...) dict
    let rgbtxt = "".a:1
    if len(rgbtxt) != 6
      call CCResetRDBEditorFromOtherEditors(self.rgbeditor, self.reditor, self.geditor, self.beditor)
      return
    endif
    let r = rgbtxt[0:1]
    let g = rgbtxt[2:3]
    let b = rgbtxt[4:5]
    let rn = str2nr(r, 16)
    let gn = str2nr(g, 16)
    let bn = str2nr(b, 16)
    if printf('%02x',rn) != r
      call CCResetRDBEditorFromOtherEditors(self.rgbeditor, self.reditor, self.geditor, self.beditor)
      return
    endif
    if printf('%02x',gn) != g
      call CCResetRDBEditorFromOtherEditors(self.rgbeditor, self.reditor, self.geditor, self.beditor)
      return
    endif
    if printf('%02x',bn) != b
      call CCResetRDBEditorFromOtherEditors(self.rgbeditor, self.reditor, self.geditor, self.beditor)
      return
    endif

    let n = forms#color#term#ConvertRGB_2_Int(rn,gn,bn)
" call forms#log("CCSlider2InfoAction.execute: n=".n)
    call self.neditor.setText(n)

    let hiname = 'XXHi'
    execute ":hi ".hiname." ctermbg=".n." guibg=#".rgbtxt
    if exists("self.palletaction")
      call self.palletaction.execute(rn, gn, bn)
    endif

    try 
      call self.rhs.setRangeValue(rn)
    catch /.*/
    endtry
    try 
      call self.ghs.setRangeValue(gn)
    catch /.*/
    endtry
    try 
      call self.bhs.setRangeValue(bn)
    catch /.*/
    endtry

    call self.reditor.setText(rn)
    call self.geditor.setText(gn)
    call self.beditor.setText(bn)
  endfunction
  let rgbeditor2others = forms#newAction({ 'execute': function("CCRGBEditor2OthersAction")})

  " the number text value was not a valid number, so reset the
  " n editor from the contents of the r, g, b editors
  function! CCResetNEditorFromRGBEditors(rgbeditor, neditor)
    let rgbtxt = a:rgbeditor.getText()
    let rtxt = rgbtxt[0:1]
    let gtxt = rgbtxt[2:3]
    let btxt = rgbtxt[4:5]
    let rn = str2nr(rtxt, 16)
    let gn = str2nr(gtxt, 16)
    let bn = str2nr(btxt, 16)
    let n = forms#color#term#ConvertRGB_2_Int(rn,gn,bn)
    call a:neditor.setText(n)
  endfunction

  "........................................
  " Info N editor to others
  "........................................
  function! CCNEditor2OthersAction(...) dict
    let n = "".a:1
    let i = 0+n
    if len(string(i)) != len(a:1) 
      " not all of the argument is used to create number, so number
      " editor value is bad
      call CCResetNEditorFromRGBEditors(self.rgbeditor, self.neditor)
      return
    endif
    try
      let rgbtxt = forms#color#term#ConvertInt_2_RGB(n)
    catch /.*/
      " the number 'n' above could not be converted. reset the neditor
      " with value from rgbeditor
      call CCResetNEditorFromRGBEditors(self.rgbeditor, self.neditor)
      return
    endtry

    call self.rgbeditor.setText(rgbtxt)

    let hiname = 'XXHi'
    execute ":hi ".hiname." ctermbg=".n." guibg=#".rgbtxt

    let r = rgbtxt[0:1]
    let g = rgbtxt[2:3]
    let b = rgbtxt[4:5]
    let rn = str2nr(r, 16)
    let gn = str2nr(g, 16)
    let bn = str2nr(b, 16)

    if exists("self.palletaction")
      call self.palletaction.execute(rn, gn, bn)
    endif

    try 
      call self.rhs.setRangeValue(rn)
    catch /.*/
    endtry
    try 
      call self.ghs.setRangeValue(gn)
    catch /.*/
    endtry
    try 
      call self.bhs.setRangeValue(bn)
    catch /.*/
    endtry

    call self.reditor.setText(rn)
    call self.geditor.setText(gn)
    call self.beditor.setText(bn)
  endfunction
  let neditor2others = forms#newAction({ 'execute': function("CCNEditor2OthersAction")})
  
  "........................................
  " Slider side
  "........................................
  function! CCSliderAction(...) dict
    let value = "".a:1
" call forms#log("CCSliderAction.execute: value=" . value)
    call self.editor.setText(value)
    call self.slider2infoa.execute()
  endfunction

  function! CCEditorAction(...) dict
    let value = a:1 + 0
    try 
      call self.hslider.setRangeValue(value)
    catch /.*/
      let v = self.hslider.getRangeValue()
      call self.editor.setText(string(v))
      return
    endtry
    if string(value) != a:1
      call self.editor.setText(string(value))
    endif
    call self.slider2infoa.execute()
  endfunction

  "----

if has("gui_running")
  :hi CCRedHi    cterm=NONE guibg=#ff0000
  :hi CCGreenHi  cterm=NONE guibg=#00ff00
  :hi CCBlueHi   cterm=NONE guibg=#0000ff
else
  let n = forms#color#term#ConvertRGBTxt_2_Int("ff0000")
  execute "hi CCRedHi    cterm=NONE ctermbg=" . n
  let n = forms#color#term#ConvertRGBTxt_2_Int("00ff00")
  execute "hi CCGreenHi  cterm=NONE ctermbg=" . n
  let n = forms#color#term#ConvertRGBTxt_2_Int("0000ff")
  execute "hi CCBlueHi   cterm=NONE ctermbg=" . n
endif


  "----
  let rhsa = forms#newAction({ 'execute': function("CCSliderAction")})
  let rhsa.slider2infoa = slider2infoa
  let rea = forms#newAction({ 'execute': function("CCEditorAction")})
  let rea.slider2infoa = slider2infoa

  let rlabel = forms#newLabel({'text': "R"})
  let rsp = forms#newVLine({ 'size': 3})
  function! rsp.draw(allocation) dict
" call forms#log("rsp.draw" .  string(a:allocation))
    call GlyphHilight(self, "CCRedHi", a:allocation)

    let p = self._prototype
    call call(p.draw, [a:allocation], self)
  endfunction
  let attrs = {
            \ 'size' : 32,
            \ 'tag' : 'red_slider',
            \ 'resolution' : 4,
            \ 'on_move_action' : rhsa,
            \ 'range' : [0,255]
            \ }
  let rhs = forms#newHSlider(attrs)
  function! rhs.purpose() dict
    return [
          \ "Adjust the Red component value from 0 to 255."
          \ ]
  endfunction
  let rea.hslider = rhs
  let rgbeditor2others.rhs = rhs
  let neditor2others.rhs = rhs
  let rhsb = forms#newBox({ 'body': rhs} )
  let hsp = forms#newHSpace({ 'size': 1} )
  let reditor = forms#newFixedLengthField({
                                  \ 'size': 3, 
                                  \ 'tag' : 'red_editor',
                                  \ 'on_selection_action' : rea,
                                  \ 'init_text': '0'})
  let rea.editor = reditor
  function! reditor.purpose() dict
    return [
          \ "Edit the Red component value from 0 to 255."
          \ ]
  endfunction
  let slider2infoa.reditor = reditor
  let rgbeditor2others.reditor = reditor
  let neditor2others.reditor = reditor
  let rhsa.editor = reditor 
  let reditorbox = forms#newBox({ 'body': reditor} )
  let rhpoly = forms#newHPoly({ 'children': [
                                  \ rlabel, 
                                  \ rsp, 
                                  \ rhsb, 
                                  \ hsp, 
                                  \ reditorbox
                                  \ ], 
                                  \ 'alignment': 'C' })

  "----
  let ghsa = forms#newAction({ 'execute': function("CCSliderAction")})
  let ghsa.slider2infoa = slider2infoa
  let gea = forms#newAction({ 'execute': function("CCEditorAction")})
  let gea.slider2infoa = slider2infoa

  let glabel = forms#newLabel({'text': "G"})
  let gsp = forms#newVLine({ 'size': 3})
  function! gsp.draw(allocation) dict
    call GlyphHilight(self, "CCGreenHi", a:allocation)
    let p = self._prototype
    call call(p.draw, [a:allocation], self)
  endfunction
  let attrs = {
            \ 'size' : 32,
            \ 'tag' : 'green_slider',
            \ 'resolution' : 4,
            \ 'on_move_action' : ghsa,
            \ 'range' : [0,255]
            \ }
  let ghs = forms#newHSlider(attrs)
  function! ghs.purpose() dict
    return [
          \ "Adjust the Green component value from 0 to 255."
          \ ]
  endfunction
  let rgbeditor2others.ghs = ghs
  let neditor2others.ghs = ghs
  let gea.hslider = ghs
  let ghsb = forms#newBox({ 'body': ghs} )
  let hsp = forms#newHSpace({ 'size': 1} )
  let geditor = forms#newFixedLengthField({
                                  \ 'size': 3, 
                                  \ 'tag' : 'green_editor',
                                  \ 'on_selection_action' : gea,
                                  \ 'init_text': '0'})
  let gea.editor = geditor
  function! geditor.purpose() dict
    return [
          \ "Edit the Green component value from 0 to 255."
          \ ]
  endfunction
  let slider2infoa.geditor = geditor
  let rgbeditor2others.geditor = geditor
  let neditor2others.geditor = geditor
  let ghsa.editor = geditor 
  let geditorbox = forms#newBox({ 'body': geditor} )
  let ghpoly = forms#newHPoly({ 'children': [
                                  \ glabel, 
                                  \ gsp, 
                                  \ ghsb, 
                                  \ hsp, 
                                  \ geditorbox
                                  \ ], 
                                  \ 'alignment': 'C' })

  "----
  let bhsa = forms#newAction({ 'execute': function("CCSliderAction")})
  let bhsa.slider2infoa = slider2infoa
  let bea = forms#newAction({ 'execute': function("CCEditorAction")})
  let bea.slider2infoa = slider2infoa

  let blabel = forms#newLabel({'text': "B"})
  let bsp = forms#newVLine({ 'size': 3})
  function! bsp.draw(allocation) dict
    call GlyphHilight(self, "CCBlueHi", a:allocation)
    let p = self._prototype
    call call(p.draw, [a:allocation], self)
  endfunction
  let attrs = {
            \ 'size' : 32,
            \ 'tag' : 'blue_slider',
            \ 'resolution' : 4,
            \ 'on_move_action' : bhsa,
            \ 'range' : [0,255]
            \ }
  let bhs = forms#newHSlider(attrs)
  function! bhs.purpose() dict
    return [
          \ "Adjust the Blue component value from 0 to 255."
          \ ]
  endfunction
  let rgbeditor2others.bhs = bhs
  let neditor2others.bhs = bhs
  let bea.hslider = bhs
  let bhsb = forms#newBox({ 'body': bhs} )
  let hsp = forms#newHSpace({ 'size': 1} )
  let beditor = forms#newFixedLengthField({
                                  \ 'size': 3, 
                                  \ 'tag' : 'blue_editor',
                                  \ 'on_selection_action' : bea,
                                  \ 'init_text': '0'})
  let bea.editor = beditor
  function! beditor.purpose() dict
    return [
          \ "Edit the Blue component value from 0 to 255."
          \ ]
  endfunction
  let slider2infoa.beditor = beditor
  let rgbeditor2others.beditor = beditor
  let neditor2others.beditor = beditor
  let bhsa.editor = beditor 
  let beditorbox = forms#newBox({ 'body': beditor} )
  let bhpoly = forms#newHPoly({ 'children': [
                                  \ blabel, 
                                  \ bsp, 
                                  \ bhsb, 
                                  \ hsp, 
                                  \ beditorbox
                                  \ ], 
                                  \ 'alignment': 'C' })


  let slidersVPoly = forms#newVPoly({ 'children': [
                                      \ rhpoly, 
                                      \ ghpoly, 
                                      \ bhpoly], 
                                      \ 'alignment': 'L' })
  "....................
  
  let attrs = {'size': 1}
  let hspace = forms#newHSpace(attrs)

  "....................
  " Info side
  "....................
  let neditor = forms#newFixedLengthField({
                                  \ 'size': 3, 
                                  \ 'tag' : 'number_editor',
                                  \ 'on_selection_action': neditor2others,
                                  \ 'init_text': '0'})
  let neditor2others.neditor = neditor
  function! neditor.purpose() dict
    return [
          \ "Edit the Xterm 256 color number value from 0 to 255."
          \ ]
  endfunction
  let slider2infoa.neditor = neditor
  let rgbeditor2others.neditor = neditor
  let neditorb = forms#newBox({ 'body': neditor} )

  let attrs = {'height': 1, 'width': 6}
  let colorspace = forms#newArea(attrs)
  let slider2infoa.colorspace = colorspace
  let neditor2others.colorspace = colorspace
  let rgbeditor2others.colorspace = colorspace

  function! colorspace.draw(allocation) dict
" call forms#log("colorspace.draw")
    " TODO: This has to be done once, registering group name with allocation
    " Changing the attributes of group does not require calling this again.
    if exists("self.__hiname")
      call GlyphHilight(self, self.__hiname, a:allocation)
    endif
    let p = self._prototype
    call call(p.draw, [a:allocation], self)
  endfunction
if 0
  function! colorspace.setHi(hiname) dict
    if exists("self.__hiname")
      if self.__hiname != a:hiname
        let self.__hiname = a:hiname
        call forms#ViewerRedrawListAdd(self) 
      endif
    else
        let self.__hiname = a:hiname
        call forms#ViewerRedrawListAdd(self) 
    endif
  endfunction
endif
  let hiname = 'XXHi'
  execute ":hi ".hiname." ctermbg=16 guibg=#000000"
  let colorspace.__hiname = hiname

  let colorspaceb = forms#newBox({ 'body': colorspace} )

  let rgbeditor = forms#newFixedLengthField({
                                  \ 'size': 6, 
                                  \ 'tag' : 'rgb_editor',
                                  \ 'on_selection_action': rgbeditor2others,
                                  \ 'init_text': '0'})
  let rgbeditor2others.rgbeditor = rgbeditor
  function! rgbeditor.purpose() dict
    return [
          \ "Edit the RGB Hex number value from 000000 to ffffff.",
          \ "  Entered value must be a valid 6 character Hex number ",
          \ "  [0-9a-fA-F]\{6}."
          \ ]
  endfunction
  let slider2infoa.rgbeditor = rgbeditor
  let neditor2others.rgbeditor = rgbeditor
  let rgbeditorb = forms#newBox({ 'body': rgbeditor} )

  let infoVPoly = forms#newVPoly({ 'children': [
                                      \ neditorb, 
                                      \ colorspaceb, 
                                      \ rgbeditorb], 
                                      \ 'alignment': 'L' })

  "....................

  let hpoly = forms#newHPoly({ 'children': [
                                      \ slidersVPoly, 
                                      \ hspace, 
                                      \ infoVPoly], 
                                      \ 'alignment': 'C' })
  
  "....................
  let cancellabel = forms#newLabel({'text': "Cancel"})
  let cancelbutton = forms#newButton({
                              \ 'tag': 'cancel', 
                              \ 'body': cancellabel, 
                              \ 'action': g:forms#cancelAction})
  let hspace = forms#newHSpace({'size': 1})
  let label = forms#newLabel({'text': "Submit"})
  let submitbutton = forms#newButton({
                              \ 'tag': 'submit', 
                              \ 'body': label, 
                              \ 'action': g:forms#submitAction})
  let buttonhpoly = forms#newHPoly({ 'children': [
                                      \ cancelbutton, 
                                      \ hspace, 
                                      \ submitbutton], 
                                      \ 'alignment': 'T' })
  "....................
  if ! a:with_pallet
    let title = forms#newLabel({'text': "Color Chooser"})
    let topvpoly = forms#newVPoly({ 'children': [
                                        \ title, 
                                        \ hpoly, 
                                        \ buttonhpoly], 
                                        \ 'mode': 'light',
                                        \ 'alignments': [[0,'C']],
                                        \ 'alignment': 'R' })
  else
    function! CCConvertInitText(txt)
      if type(a:txt) == g:self#STRING_TYPE
        return a:txt
      elseif type(a:txt) == g:self#NUMBER_TYPE
        return "".a:txt
      elseif type(a:txt) == g:self#FLOAT_TYPE
        return printf('%4.2f', a:txt)
      else
        throw "Bad initial value for Tint or Shade: " . string(a:txt)
      endif
    endfunction

    let s:tint1Init = CCConvertInitText(g:forms#dialog#color#tint1Init)
    let s:shade1Init = CCConvertInitText(g:forms#dialog#color#shade1Init)
    let s:tint2Init = CCConvertInitText(g:forms#dialog#color#tint2Init)
    let s:shade2Init = CCConvertInitText(g:forms#dialog#color#shade2Init)
    let s:tint3Init = CCConvertInitText(g:forms#dialog#color#tint3Init)
    let s:shade3Init = CCConvertInitText(g:forms#dialog#color#shade3Init)
    let s:tint4Init = CCConvertInitText(g:forms#dialog#color#tint4Init)
    let s:shade4Init = CCConvertInitText(g:forms#dialog#color#shade4Init)


    "....................
    function! CCSchemeAction(...) dict
      let pos = self.popdownlist.__pos
" call forms#log("CCSchemeAction.execute: " . pos)
      call self.deck.setCard(pos)

      let rgbtxt = self.rgbeditor.getText()
      let r = rgbtxt[0:1]
      let g = rgbtxt[2:3]
      let b = rgbtxt[4:5]
      let rn = str2nr(r, 16)
      let gn = str2nr(g, 16)
      let bn = str2nr(b, 16)
      call self.palletaction.execute(rn, gn, bn)
    endfunction
    let comboboxaction = forms#newAction({ 'execute': function("CCSchemeAction")})
    let comboboxaction.rgbeditor = rgbeditor

    let attrs = {
        \ 'choices' : [
        \   ["Monochromatic", 0],
        \   ["Complimentary", 1],
        \   ["Split Complimentary", 2],
        \   ["Analogic", 3],
        \   ["Accented Analogic", 4],
        \   ["Triadic", 5],
        \   ["Double Complimentary", 6]
        \ ],
        \ 'on_selection_action': comboboxaction
        \ }
    let popdownlist = forms#newPopDownList(attrs)
    function! popdownlist.purpose() dict
      return [
          \ "Select the Color Scheme with given values:",
          \ "  Monochromatic, Complimentary, Split Complimentary",
          \ "  Analogic,  Accented Analogic, Triadic and",
          \ "  Double Complimentary."
          \ ]
    endfunction
    let comboboxaction.popdownlist = popdownlist
    "....................

    " called by rgbeditor, neditor, and slider to info actions
    function! CCDeckAction(...) dict
" call forms#log("CCDeckAction.execute: ")
      let rn = a:1
      let gn = a:2
      let bn = a:3
      let pos = self.deck.getCard()
" call forms#log("CCDeckAction.execute: pos=".pos)
      call self.palletactions[pos].execute(rn, gn, bn)
    endfunction
    let deckaction = forms#newAction({ 'execute': function("CCDeckAction")})
    let deckaction.palletactions = []
    let neditor2others.palletaction = deckaction
    let rgbeditor2others.palletaction = deckaction
    let slider2infoa.palletaction = deckaction
    let comboboxaction.palletaction = deckaction

    " called by tint and shade editors
    function! CCAdjustersAction(...) dict
" call forms#log("CCAdjustersAction.execute: ")
      let pos = self.deck.getCard()
" call forms#log("CCAdjustersAction.execute: pos=".pos)
      let rgbtxt = self.rgbeditor.getText()
      let r = rgbtxt[0:1]
      let g = rgbtxt[2:3]
      let b = rgbtxt[4:5]
      let rn = str2nr(r, 16)
      let gn = str2nr(g, 16)
      let bn = str2nr(b, 16)
      call self.palletactions[pos].execute(rn, gn, bn)
    endfunction
    let adjusteraction = forms#newAction({ 'execute': function("CCAdjustersAction")})
    let adjusteraction.rgbeditor = rgbeditor
    let adjusteraction.palletactions = []

    
    let hspace = forms#newHLine({'size': 6})
    let tintlabel = forms#newLabel({'text': "Tint"})
    let shadelabel = forms#newLabel({'text': "Shade"})

    " One
    "  '0.25:1',      0.75:0,0
    let label1 = forms#newLabel({'text': "One"})
    let tint1editor = forms#newFixedLengthField({
                                  \ 'size': 5, 
                                  \ 'tag' : 'tint1_editor',
                                  \ 'on_selection_action': adjusteraction,
                                  \ 'init_text': s:tint1Init})
    function! tint1editor.purpose() dict
      return [
            \ "Tint editor One value range 0.0 to 1.0.",
            \ "Closer to 1.0, closer to White."
            \ ]
    endfunction
    let shade1editor = forms#newFixedLengthField({
                                  \ 'size': 5, 
                                  \ 'tag' : 'shade1_editor',
                                  \ 'on_selection_action': adjusteraction,
                                  \ 'init_text': s:shade1Init})
    function! shade1editor.purpose() dict
      return [
            \ "Shade editor One value range 0.0 to 1.0.",
            \ "Closer to 1.0, closer to Black."
            \ ]
    endfunction
    " Two
    "  '0.5:1',       0.5:0.0
    let label2 = forms#newLabel({'text': "Two"})
    let tint2editor = forms#newFixedLengthField({
                                  \ 'size': 5, 
                                  \ 'tag' : 'tint2_editor',
                                  \ 'on_selection_action': adjusteraction,
                                  \ 'init_text': s:tint2Init})
    function! tint2editor.purpose() dict
      return [
            \ "Tint editor Two value range 0.0 to 1.0.",
            \ "Closer to 1.0, closer to White."
            \ ]
    endfunction
    let shade2editor = forms#newFixedLengthField({
                                  \ 'size': 5, 
                                  \ 'tag' : 'shade2_editor',
                                  \ 'on_selection_action': adjusteraction,
                                  \ 'init_text': s:shade2Init})
    function! shade2editor.purpose() dict
      return [
            \ "Shade editor Two value range 0.0 to 1.0.",
            \ "Closer to 1.0, closer to Black."
            \ ]
    endfunction
    " Three
    "  '0.666:0.666', 0.33: -0.33
    let label3 = forms#newLabel({'text': "Three"})
    let tint3editor = forms#newFixedLengthField({
                                  \ 'size': 5, 
                                  \ 'tag' : 'tint3_editor',
                                  \ 'on_selection_action': adjusteraction,
                                  \ 'init_text': s:tint3Init})
    function! tint3editor.purpose() dict
      return [
            \ "Tint editor Three value range 0.0 to 1.0.",
            \ "Closer to 1.0, closer to White."
            \ ]
    endfunction
    let shade3editor = forms#newFixedLengthField({
                                  \ 'size': 5, 
                                  \ 'tag' : 'shade3_editor',
                                  \ 'on_selection_action': adjusteraction,
                                  \ 'init_text': s:shade3Init})
    
    function! shade3editor.purpose() dict
      return [
            \ "Shade editor Three value range 0.0 to 1.0.",
            \ "Closer to 1.0, closer to Black."
            \ ]
    endfunction
    " Four
    "  '0.666:0.333', 0.33: -0.66
    let label4 = forms#newLabel({'text': "Four"})
    let tint4editor = forms#newFixedLengthField({
                                  \ 'size': 5, 
                                  \ 'tag' : 'tint4_editor',
                                  \ 'on_selection_action': adjusteraction,
                                  \ 'init_text': s:tint4Init})
    function! tint4editor.purpose() dict
      return [
            \ "Tint editor Four value range 0.0 to 1.0.",
            \ "Closer to 1.0, closer to White."
            \ ]
    endfunction
    let shade4editor = forms#newFixedLengthField({
                                  \ 'size': 5, 
                                  \ 'tag' : 'shade4_editor',
                                  \ 'on_selection_action': adjusteraction,
                                  \ 'init_text': s:shade4Init})
    function! shade4editor.purpose() dict
      return [
            \ "Shade editor Four value range 0.0 to 1.0.",
            \ "Closer to 1.0, closer to Black."
            \ ]
    endfunction

    let adjustergrid = forms#newGrid({ 
                          \ 'nos_rows': 5, 
                          \ 'nos_columns': 3, 
                          \ 'halignment': 'L', 
                          \ 'valignment': 'T', 
                          \ 'data': [
                            \ [0, 0, hspace],
                            \ [0, 1, tintlabel],
                            \ [0, 2, shadelabel],
                            \ [1, 0, label1],
                            \ [1, 1, tint1editor],
                            \ [1, 2, shade1editor],
                            \ [2, 0, label2],
                            \ [2, 1, tint2editor],
                            \ [2, 2, shade2editor],
                            \ [3, 0, label3],
                            \ [3, 1, tint3editor],
                            \ [3, 2, shade3editor],
                            \ [4, 0, label4],
                            \ [4, 1, tint4editor],
                            \ [4, 2, shade4editor]
                            \ ] 
                          \ })
    "....................
   
  
    let colorblock = forms#newArea({'width': 6, 'height': 2})
    let colorblock.__rgbtxt = "000000"
    let colorblock.__numbertxt = "0"
    let colorblock.__hiname = "ERROR_HIGHLIGHT_NOT_SET"

    function! colorblock.init(attrs) dict
      call call(g:forms#Area.init, [a:attrs], self)

      let ctermfg = "0"
      let guifg="#000000"
      execute ":hi ".self.__hiname." ctermfg=".ctermfg." ctermbg=".self.__numbertxt." guifg=".guifg." guibg=#".self.__rgbtxt
      return self
    endfunction

    function! colorblock.setNumberText(numbertxt) dict
      let l = len(a:numbertxt)
      if l == 3
        let self.__numbertxt = " " . a:numbertxt
      elseif l == 2
        let self.__numbertxt = "  " . a:numbertxt
      else
        let self.__numbertxt = "   " . a:numbertxt
      endif
    endfunction

    function! colorblock.addResults(results) dict
      " only add to results if its activitly being displayed, i.e.,
      " self.__matchId exisits
      if exists("self.__matchId")
        let nt = self.__numbertxt[1:]
        if nt[0] == ' '
          let nt = nt[1:]
        endif
        if nt[0] == ' '
          let nt = nt[1:]
        endif
        let a:results[self.__hiname] = [self.__rgbtxt, nt]
      endif
    endfunction

    function! colorblock.hide() dict
      call GlyphDeleteHi(self)
    endfunction

    function! colorblock.draw(allocation) dict
"" call forms#log("colorblock.draw: TOP ". self.__hiname)
      call call(g:forms#Area.draw, [a:allocation], self)

      let a = a:allocation
      call forms#SetStringAt(self.__rgbtxt, a.line, a.column)
      call forms#SetStringAt(self.__numbertxt, a.line+1, a.column)
      call GlyphHilight(self, self.__hiname, a)
    endfunction



    function! CCBlockAdjuster(block,rn,gn,bn)
" call forms#log("CCBlockAdjuster.execute: TOP")
      let block = a:block
      if exists("block.tinteditor")
        let tinttxt = block.tinteditor.getText()
        let tintf = str2float(tinttxt)
        let shadetxt = block.shadeeditor.getText()
        let shadef = str2float(shadetxt)
        let [rn1,gn1,bn1] = forms#color#util#TintRGB(tintf, a:rn, a:gn, a:bn)
        let [rn1,gn1,bn1] = forms#color#util#ShadeRGB(shadef, rn1, gn1, bn1)
      else
        let [rn1,gn1,bn1] = [a:rn, a:gn, a:bn]
      endif

      let n1 = forms#color#term#ConvertRGB_2_Int(rn1,gn1,bn1)
      let rgbtxt1 = printf('%02x%02x%02x',rn1,gn1,bn1)
      if((0.5*rn1+gn1+0.3*bn1)>220)
        let ctermfg = "0"
        let guifg="#000000"
      else
        let ctermfg = "255"
        let guifg="#ffffff"
      endif

      let hiname = block.__hiname
      execute ":hi ".hiname." ctermfg=".ctermfg." ctermbg=".n1." guifg=".guifg." guibg=#".rgbtxt1
      let block.__rgbtxt = rgbtxt1
      call block.setNumberText(n1)
if empty(block.__allocation)
" call forms#log("CCBlockAdjuster.execute: EMPTY: ".hiname)
endif
      call forms#ViewerRedrawListAdd(block) 
" call forms#log("CCBlockAdjuster.execute: BOTTOM")
    endfunction


    " called by deckaction
    function! CCDeckRowAction(...) dict
" call forms#log("CCDeckRowAction.execute: TOP")
      let rn = a:1
      let gn = a:2
      let bn = a:3

      for block in self.blocks
        call CCBlockAdjuster(block, rn, gn, bn)
      endfor
" call forms#log("CCDeckRowAction.execute: BOTTOM")
    endfunction


    " Monochromatic Card --------------------------------------------
    let oneblock = colorblock.clone().init({ 'hiname' : 'MOneHi' })
    let oneblock.tinteditor = tint1editor
    let oneblock.shadeeditor = shade1editor

    let twoblock = colorblock.clone().init({ 'hiname' : 'MTwoHi' })
    let twoblock.tinteditor = tint2editor
    let twoblock.shadeeditor = shade2editor

    let baseblock = colorblock.clone().init({ 'hiname' : 'MBaseHi'})

    let threeblock = colorblock.clone().init({ 'hiname' : 'MThreeHi' })
    let threeblock.tinteditor = tint3editor
    let threeblock.shadeeditor = shade3editor

    let fourblock = colorblock.clone().init({ 'hiname' : 'MFourHi' })
    let fourblock.tinteditor = tint4editor
    let fourblock.shadeeditor = shade4editor

    let monochromaticdraction = forms#newAction({ 'execute': function("CCDeckRowAction")})
    let monochromaticdraction.blocks = [
                                 \ oneblock,
                                 \ twoblock,
                                 \ baseblock,
                                 \ threeblock,
                                 \ fourblock
                                 \ ]


    " called by deckaction
    function! CCMonochromaticAction(...) dict
" call forms#log("CCMonochromaticAction.execute: TOP")
      let rn = a:1
      let gn = a:2
      let bn = a:3

      call self.draction.execute(rn, gn, bn)
" call forms#log("CCMonochromaticAction.execute: BOTTOM")
    endfunction

    let monochromaticaction = forms#newAction({ 'execute': function("CCMonochromaticAction")})
    let monochromaticaction.draction = monochromaticdraction


    call add(deckaction.palletactions, monochromaticaction)
    call add(adjusteraction.palletactions, monochromaticaction)

    let vspace = forms#newVSpace({'size': 1})
    let monochromhpoly = forms#newHPoly({ 'children': [
                                        \ oneblock, 
                                        \ vspace, 
                                        \ twoblock, 
                                        \ vspace, 
                                        \ baseblock, 
                                        \ vspace, 
                                        \ threeblock, 
                                        \ vspace, 
                                        \ fourblock], 
                                        \ 'alignment': 'C' })


    " Complimentary Card --------------------------------------------
    
    " mono
    let cmoneblock = colorblock.clone().init({ 'hiname' : 'CMOneHi' })
    let cmoneblock.tinteditor = tint1editor
    let cmoneblock.shadeeditor = shade1editor

    let cmtwoblock = colorblock.clone().init({ 'hiname' : 'CMTwoHi' })
    let cmtwoblock.tinteditor = tint2editor
    let cmtwoblock.shadeeditor = shade2editor

    let cmbaseblock = colorblock.clone().init({ 'hiname' : 'CMBaseHi'})

    let cmthreeblock = colorblock.clone().init({ 'hiname' : 'CMThreeHi' })
    let cmthreeblock.tinteditor = tint3editor
    let cmthreeblock.shadeeditor = shade3editor

    let cmfourblock = colorblock.clone().init({ 'hiname' : 'CMFourHi' })
    let cmfourblock.tinteditor = tint4editor
    let cmfourblock.shadeeditor = shade4editor

    let cmmonochromaticdraction = forms#newAction({ 'execute': function("CCDeckRowAction")})
    let cmmonochromaticdraction.blocks = [
                                      \ cmoneblock,
                                      \ cmtwoblock,
                                      \ cmbaseblock,
                                      \ cmthreeblock,
                                      \ cmfourblock
                                      \ ]

    " comp
    let cconeblock = colorblock.clone().init({ 'hiname' : 'CCOneHi' })
    let cconeblock.tinteditor = tint1editor
    let cconeblock.shadeeditor = shade1editor

    let cctwoblock = colorblock.clone().init({ 'hiname' : 'CCTwoHi' })
    let cctwoblock.tinteditor = tint2editor
    let cctwoblock.shadeeditor = shade2editor

    let ccbaseblock = colorblock.clone().init({ 'hiname' : 'CCBaseHi'})

    let ccthreeblock = colorblock.clone().init({ 'hiname' : 'CCThreeHi' })
    let ccthreeblock.tinteditor = tint3editor
    let ccthreeblock.shadeeditor = shade3editor

    let ccfourblock = colorblock.clone().init({ 'hiname' : 'CCFourHi' })
    let ccfourblock.tinteditor = tint4editor
    let ccfourblock.shadeeditor = shade4editor

    let ccdraction = forms#newAction({ 'execute': function("CCDeckRowAction")})
    let ccdraction.blocks = [
                                      \ cconeblock,
                                      \ cctwoblock,
                                      \ ccbaseblock,
                                      \ ccthreeblock,
                                      \ ccfourblock
                                      \ ]

    function! CCComplimentaryAction(...) dict
" call forms#log("CCComplimentaryAction.execute: TOP")
      let rn = a:1
      let gn = a:2
      let bn = a:3

      call self.cmmonochromaticdraction.execute(rn, gn, bn)

      let [rn,gn,bn] = forms#color#util#ComplimentRGBusingHSV(rn, gn, bn)
      call self.ccdraction.execute(rn, gn, bn)

" call forms#log("CCComplimentaryAction.execute: BOTTOM")
    endfunction
    let complimentaryaction = forms#newAction({ 'execute': function("CCComplimentaryAction")})
    let complimentaryaction.cmmonochromaticdraction = cmmonochromaticdraction
    let complimentaryaction.ccdraction = ccdraction

    call add(deckaction.palletactions, complimentaryaction)
    call add(adjusteraction.palletactions, complimentaryaction)

    let vspace = forms#newVSpace({'size': 1})
    let cmonochromhpoly = forms#newHPoly({ 'children': [
                                        \ cmoneblock, 
                                        \ vspace, 
                                        \ cmtwoblock, 
                                        \ vspace, 
                                        \ cmbaseblock, 
                                        \ vspace, 
                                        \ cmthreeblock, 
                                        \ vspace, 
                                        \ cmfourblock], 
                                        \ 'alignment': 'C' })
    let ccomplimenthpoly = forms#newHPoly({ 'children': [
                                        \ cconeblock, 
                                        \ vspace, 
                                        \ cctwoblock, 
                                        \ vspace, 
                                        \ ccbaseblock, 
                                        \ vspace, 
                                        \ ccthreeblock, 
                                        \ vspace, 
                                        \ ccfourblock], 
                                        \ 'alignment': 'C' })

    let complimentbpoly = forms#newVPoly({ 'children': [
                                        \ cmonochromhpoly, 
                                        \ hspace, 
                                        \ ccomplimenthpoly], 
                                        \ 'alignment': 'C' })
    
    " Split Complimentary Card --------------------------------------
    
    " mono
    let scmoneblock = colorblock.clone().init({ 'hiname' : 'SCMOneHi' })
    let scmoneblock.tinteditor = tint1editor
    let scmoneblock.shadeeditor = shade1editor

    let scmtwoblock = colorblock.clone().init({ 'hiname' : 'SCMTwoHi' })
    let scmtwoblock.tinteditor = tint2editor
    let scmtwoblock.shadeeditor = shade2editor

    let scmbaseblock = colorblock.clone().init({ 'hiname' : 'SCMBaseHi'})

    let scmthreeblock = colorblock.clone().init({ 'hiname' : 'SCMThreeHi' })
    let scmthreeblock.tinteditor = tint3editor
    let scmthreeblock.shadeeditor = shade3editor

    let scmfourblock = colorblock.clone().init({ 'hiname' : 'SCMFourHi' })
    let scmfourblock.tinteditor = tint4editor
    let scmfourblock.shadeeditor = shade4editor

    let scmmonochromaticdraction = forms#newAction({ 'execute': function("CCDeckRowAction")})
    let scmmonochromaticdraction.blocks = [
                                      \ scmoneblock,
                                      \ scmtwoblock,
                                      \ scmbaseblock,
                                      \ scmthreeblock,
                                      \ scmfourblock
                                      \ ]
   
    " s1comp
    let s1cconeblock = colorblock.clone().init({ 'hiname' : 'S1CCOneHi' })
    let s1cconeblock.tinteditor = tint1editor
    let s1cconeblock.shadeeditor = shade1editor

    let s1cctwoblock = colorblock.clone().init({ 'hiname' : 'S1CCTwoHi' })
    let s1cctwoblock.tinteditor = tint2editor
    let s1cctwoblock.shadeeditor = shade2editor

    let s1ccbaseblock = colorblock.clone().init({ 'hiname' : 'S1CCBaseHi'})

    let s1ccthreeblock = colorblock.clone().init({ 'hiname' : 'S1CCThreeHi' })
    let s1ccthreeblock.tinteditor = tint3editor
    let s1ccthreeblock.shadeeditor = shade3editor

    let s1ccfourblock = colorblock.clone().init({ 'hiname' : 'S1CCFourHi' })
    let s1ccfourblock.tinteditor = tint4editor
    let s1ccfourblock.shadeeditor = shade4editor

    let s1ccdraction = forms#newAction({ 'execute': function("CCDeckRowAction")})
    let s1ccdraction.blocks = [
                                      \ s1cconeblock,
                                      \ s1cctwoblock,
                                      \ s1ccbaseblock,
                                      \ s1ccthreeblock,
                                      \ s1ccfourblock
                                      \ ]

    " s2comp
    let s2cconeblock = colorblock.clone().init({ 'hiname' : 'S2CCOneHi' })
    let s2cconeblock.tinteditor = tint1editor
    let s2cconeblock.shadeeditor = shade1editor

    let s2cctwoblock = colorblock.clone().init({ 'hiname' : 'S2CCTwoHi' })
    let s2cctwoblock.tinteditor = tint2editor
    let s2cctwoblock.shadeeditor = shade2editor

    let s2ccbaseblock = colorblock.clone().init({ 'hiname' : 'S2CCBaseHi'})

    let s2ccthreeblock = colorblock.clone().init({ 'hiname' : 'S2CCThreeHi' })
    let s2ccthreeblock.tinteditor = tint3editor
    let s2ccthreeblock.shadeeditor = shade3editor

    let s2ccfourblock = colorblock.clone().init({ 'hiname' : 'S2CCFourHi' })
    let s2ccfourblock.tinteditor = tint4editor
    let s2ccfourblock.shadeeditor = shade4editor

    let s2ccdraction = forms#newAction({ 'execute': function("CCDeckRowAction")})
    let s2ccdraction.blocks = [
                                      \ s2cconeblock,
                                      \ s2cctwoblock,
                                      \ s2ccbaseblock,
                                      \ s2ccthreeblock,
                                      \ s2ccfourblock
                                      \ ]

    function! SCCComplimentaryAction(...) dict
" call forms#log("SCCComplimentaryAction.execute: TOP")
      let rn = a:1
      let gn = a:2
      let bn = a:3

      call self.scmmonochromaticdraction.execute(rn, gn, bn)

      let shift = g:forms#dialog#color#splitComplimentaryShiftInit
      let [rgb1,rgb2] = forms#color#util#SplitComplimentaryRGBusingHSV(shift, rn, gn, bn)
      let [rn1,gn1,bn1] = rgb1
      let [rn2,gn2,bn2] = rgb2

      " split 1
      call self.s1ccdraction.execute(rn1, gn1, bn1)

      " split 2
      call self.s2ccdraction.execute(rn2, gn2, bn2)

" call forms#log("SCCComplimentaryAction.execute: BOTTOM")
    endfunction
    let scomplimentaryaction = forms#newAction({ 'execute': function("SCCComplimentaryAction")})
    let scomplimentaryaction.scmmonochromaticdraction = scmmonochromaticdraction
    let scomplimentaryaction.s1ccdraction = s1ccdraction
    let scomplimentaryaction.s2ccdraction = s2ccdraction

    call add(deckaction.palletactions, scomplimentaryaction)
    call add(adjusteraction.palletactions, scomplimentaryaction)

    let vspace = forms#newVSpace({'size': 1})
    let scmonochromhpoly = forms#newHPoly({ 'children': [
                                        \ scmoneblock, 
                                        \ vspace, 
                                        \ scmtwoblock, 
                                        \ vspace, 
                                        \ scmbaseblock, 
                                        \ vspace, 
                                        \ scmthreeblock, 
                                        \ vspace, 
                                        \ scmfourblock], 
                                        \ 'alignment': 'C' })
    let s1ccomplimenthpoly = forms#newHPoly({ 'children': [
                                        \ s1cconeblock, 
                                        \ vspace, 
                                        \ s1cctwoblock, 
                                        \ vspace, 
                                        \ s1ccbaseblock, 
                                        \ vspace, 
                                        \ s1ccthreeblock, 
                                        \ vspace, 
                                        \ s1ccfourblock], 
                                        \ 'alignment': 'C' })
    let s2ccomplimenthpoly = forms#newHPoly({ 'children': [
                                        \ s2cconeblock, 
                                        \ vspace, 
                                        \ s2cctwoblock, 
                                        \ vspace, 
                                        \ s2ccbaseblock, 
                                        \ vspace, 
                                        \ s2ccthreeblock, 
                                        \ vspace, 
                                        \ s2ccfourblock], 
                                        \ 'alignment': 'C' })

    let scomplimentbpoly = forms#newVPoly({ 'children': [
                                        \ scmonochromhpoly, 
                                        \ hspace, 
                                        \ s1ccomplimenthpoly, 
                                        \ hspace, 
                                        \ s2ccomplimenthpoly], 
                                        \ 'alignment': 'C' })
    
    " Analogic Card -------------------------------------------------
    
    " mono
    let acmoneblock = colorblock.clone().init({ 'hiname' : 'ACMOneHi' })
    let acmoneblock.tinteditor = tint1editor
    let acmoneblock.shadeeditor = shade1editor

    let acmtwoblock = colorblock.clone().init({ 'hiname' : 'ACMTwoHi' })
    let acmtwoblock.tinteditor = tint2editor
    let acmtwoblock.shadeeditor = shade2editor

    let acmbaseblock = colorblock.clone().init({ 'hiname' : 'ACMBaseHi'})

    let acmthreeblock = colorblock.clone().init({ 'hiname' : 'ACMThreeHi' })
    let acmthreeblock.tinteditor = tint3editor
    let acmthreeblock.shadeeditor = shade3editor

    let acmfourblock = colorblock.clone().init({ 'hiname' : 'ACMFourHi' })
    let acmfourblock.tinteditor = tint4editor
    let acmfourblock.shadeeditor = shade4editor

    let acmmonochromaticdraction = forms#newAction({ 'execute': function("CCDeckRowAction")})
    let acmmonochromaticdraction.blocks = [
                                      \ acmoneblock,
                                      \ acmtwoblock,
                                      \ acmbaseblock,
                                      \ acmthreeblock,
                                      \ acmfourblock
                                      \ ]
   
    " a1comp
    let a1cconeblock = colorblock.clone().init({ 'hiname' : 'A1CCOneHi' })
    let a1cconeblock.tinteditor = tint1editor
    let a1cconeblock.shadeeditor = shade1editor

    let a1cctwoblock = colorblock.clone().init({ 'hiname' : 'A1CCTwoHi' })
    let a1cctwoblock.tinteditor = tint2editor
    let a1cctwoblock.shadeeditor = shade2editor

    let a1ccbaseblock = colorblock.clone().init({ 'hiname' : 'A1CCBaseHi'})

    let a1ccthreeblock = colorblock.clone().init({ 'hiname' : 'A1CCThreeHi' })
    let a1ccthreeblock.tinteditor = tint3editor
    let a1ccthreeblock.shadeeditor = shade3editor

    let a1ccfourblock = colorblock.clone().init({ 'hiname' : 'A1CCFourHi' })
    let a1ccfourblock.tinteditor = tint4editor
    let a1ccfourblock.shadeeditor = shade4editor

    let a1ccdraction = forms#newAction({ 'execute': function("CCDeckRowAction")})
    let a1ccdraction.blocks = [
                                      \ a1cconeblock,
                                      \ a1cctwoblock,
                                      \ a1ccbaseblock,
                                      \ a1ccthreeblock,
                                      \ a1ccfourblock
                                      \ ]

    " a2comp
    let a2cconeblock = colorblock.clone().init({ 'hiname' : 'A2CCOneHi' })
    let a2cconeblock.tinteditor = tint1editor
    let a2cconeblock.shadeeditor = shade1editor

    let a2cctwoblock = colorblock.clone().init({ 'hiname' : 'A2CCTwoHi' })
    let a2cctwoblock.tinteditor = tint2editor
    let a2cctwoblock.shadeeditor = shade2editor

    let a2ccbaseblock = colorblock.clone().init({ 'hiname' : 'A2CCBaseHi'})

    let a2ccthreeblock = colorblock.clone().init({ 'hiname' : 'A2CCThreeHi' })
    let a2ccthreeblock.tinteditor = tint3editor
    let a2ccthreeblock.shadeeditor = shade3editor

    let a2ccfourblock = colorblock.clone().init({ 'hiname' : 'A2CCFourHi' })
    let a2ccfourblock.tinteditor = tint4editor
    let a2ccfourblock.shadeeditor = shade4editor

    let a2ccdraction = forms#newAction({ 'execute': function("CCDeckRowAction")})
    let a2ccdraction.blocks = [
                                      \ a2cconeblock,
                                      \ a2cctwoblock,
                                      \ a2ccbaseblock,
                                      \ a2ccthreeblock,
                                      \ a2ccfourblock
                                      \ ]

    function! ACCComplimentaryAction(...) dict
" call forms#log("ACCComplimentaryAction.execute: TOP")
      let rn = a:1
      let gn = a:2
      let bn = a:3

      call self.acmmonochromaticdraction.execute(rn, gn, bn)

      let shift = g:forms#dialog#color#analogicShiftInit
      let [rgb1,rgb2] = forms#color#util#AnalogicRGBusingHSV(shift, rn, gn, bn)
      let [rn1,gn1,bn1] = rgb1
      let [rn2,gn2,bn2] = rgb2

      " analogic 1
      call self.a1ccdraction.execute(rn1, gn1, bn1)

      " analogic 2
      call self.a2ccdraction.execute(rn2, gn2, bn2)

" call forms#log("ACCComplimentaryAction.execute: BOTTOM")
    endfunction
    let acomplimentaryaction = forms#newAction({ 'execute': function("ACCComplimentaryAction")})
    let acomplimentaryaction.acmmonochromaticdraction = acmmonochromaticdraction
    let acomplimentaryaction.a1ccdraction = a1ccdraction
    let acomplimentaryaction.a2ccdraction = a2ccdraction

    call add(deckaction.palletactions, acomplimentaryaction)
    call add(adjusteraction.palletactions, acomplimentaryaction)

    let vspace = forms#newVSpace({'size': 1})
    let acmonochromhpoly = forms#newHPoly({ 'children': [
                                        \ acmoneblock, 
                                        \ vspace, 
                                        \ acmtwoblock, 
                                        \ vspace, 
                                        \ acmbaseblock, 
                                        \ vspace, 
                                        \ acmthreeblock, 
                                        \ vspace, 
                                        \ acmfourblock], 
                                        \ 'alignment': 'C' })
    let a1ccomplimenthpoly = forms#newHPoly({ 'children': [
                                        \ a1cconeblock, 
                                        \ vspace, 
                                        \ a1cctwoblock, 
                                        \ vspace, 
                                        \ a1ccbaseblock, 
                                        \ vspace, 
                                        \ a1ccthreeblock, 
                                        \ vspace, 
                                        \ a1ccfourblock], 
                                        \ 'alignment': 'C' })
    let a2ccomplimenthpoly = forms#newHPoly({ 'children': [
                                        \ a2cconeblock, 
                                        \ vspace, 
                                        \ a2cctwoblock, 
                                        \ vspace, 
                                        \ a2ccbaseblock, 
                                        \ vspace, 
                                        \ a2ccthreeblock, 
                                        \ vspace, 
                                        \ a2ccfourblock], 
                                        \ 'alignment': 'C' })

    let acomplimentbpoly = forms#newVPoly({ 'children': [
                                        \ acmonochromhpoly, 
                                        \ hspace, 
                                        \ a1ccomplimenthpoly, 
                                        \ hspace, 
                                        \ a2ccomplimenthpoly], 
                                        \ 'alignment': 'C' })
    
    " Accented Analogic ---------------------------------------------
    
    " mono
    let aacmoneblock = colorblock.clone().init({ 'hiname' : 'AACMOneHi' })
    let aacmoneblock.tinteditor = tint1editor
    let aacmoneblock.shadeeditor = shade1editor

    let aacmtwoblock = colorblock.clone().init({ 'hiname' : 'AACMTwoHi' })
    let aacmtwoblock.tinteditor = tint2editor
    let aacmtwoblock.shadeeditor = shade2editor

    let aacmbaseblock = colorblock.clone().init({ 'hiname' : 'AACMBaseHi'})

    let aacmthreeblock = colorblock.clone().init({ 'hiname' : 'AACMThreeHi' })
    let aacmthreeblock.tinteditor = tint3editor
    let aacmthreeblock.shadeeditor = shade3editor

    let aacmfourblock = colorblock.clone().init({ 'hiname' : 'AACMFourHi' })
    let aacmfourblock.tinteditor = tint4editor
    let aacmfourblock.shadeeditor = shade4editor

    let aacmmonochromaticdraction = forms#newAction({ 'execute': function("CCDeckRowAction")})
    let aacmmonochromaticdraction.blocks = [
                                      \ aacmoneblock,
                                      \ aacmtwoblock,
                                      \ aacmbaseblock,
                                      \ aacmthreeblock,
                                      \ aacmfourblock
                                      \ ]
   
    " aa1comp
    let aa1cconeblock = colorblock.clone().init({ 'hiname' : 'AA1CCOneHi' })
    let aa1cconeblock.tinteditor = tint1editor
    let aa1cconeblock.shadeeditor = shade1editor

    let aa1cctwoblock = colorblock.clone().init({ 'hiname' : 'AA1CCTwoHi' })
    let aa1cctwoblock.tinteditor = tint2editor
    let aa1cctwoblock.shadeeditor = shade2editor

    let aa1ccbaseblock = colorblock.clone().init({ 'hiname' : 'AA1CCBaseHi'})

    let aa1ccthreeblock = colorblock.clone().init({ 'hiname' : 'AA1CCThreeHi' })
    let aa1ccthreeblock.tinteditor = tint3editor
    let aa1ccthreeblock.shadeeditor = shade3editor

    let aa1ccfourblock = colorblock.clone().init({ 'hiname' : 'AA1CCFourHi' })
    let aa1ccfourblock.tinteditor = tint4editor
    let aa1ccfourblock.shadeeditor = shade4editor

    let aa1ccdraction = forms#newAction({ 'execute': function("CCDeckRowAction")})
    let aa1ccdraction.blocks = [
                                      \ aa1cconeblock,
                                      \ aa1cctwoblock,
                                      \ aa1ccbaseblock,
                                      \ aa1ccthreeblock,
                                      \ aa1ccfourblock
                                      \ ]

    " aa2comp
    let aa2cconeblock = colorblock.clone().init({ 'hiname' : 'AA2CCOneHi' })
    let aa2cconeblock.tinteditor = tint1editor
    let aa2cconeblock.shadeeditor = shade1editor

    let aa2cctwoblock = colorblock.clone().init({ 'hiname' : 'AA2CCTwoHi' })
    let aa2cctwoblock.tinteditor = tint2editor
    let aa2cctwoblock.shadeeditor = shade2editor

    let aa2ccbaseblock = colorblock.clone().init({ 'hiname' : 'AA2CCBaseHi'})

    let aa2ccthreeblock = colorblock.clone().init({ 'hiname' : 'AA2CCThreeHi' })
    let aa2ccthreeblock.tinteditor = tint3editor
    let aa2ccthreeblock.shadeeditor = shade3editor

    let aa2ccfourblock = colorblock.clone().init({ 'hiname' : 'AA2CCFourHi' })
    let aa2ccfourblock.tinteditor = tint4editor
    let aa2ccfourblock.shadeeditor = shade4editor

    let aa2ccdraction = forms#newAction({ 'execute': function("CCDeckRowAction")})
    let aa2ccdraction.blocks = [
                                      \ aa2cconeblock,
                                      \ aa2cctwoblock,
                                      \ aa2ccbaseblock,
                                      \ aa2ccthreeblock,
                                      \ aa2ccfourblock
                                      \ ]

    " comp
    let aacconeblock = colorblock.clone().init({ 'hiname' : 'AACCOneHi' })
    let aacconeblock.tinteditor = tint1editor
    let aacconeblock.shadeeditor = shade1editor

    let aacctwoblock = colorblock.clone().init({ 'hiname' : 'AACCTwoHi' })
    let aacctwoblock.tinteditor = tint2editor
    let aacctwoblock.shadeeditor = shade2editor

    let aaccbaseblock = colorblock.clone().init({ 'hiname' : 'AACCBaseHi'})

    let aaccthreeblock = colorblock.clone().init({ 'hiname' : 'AACCThreeHi' })
    let aaccthreeblock.tinteditor = tint3editor
    let aaccthreeblock.shadeeditor = shade3editor

    let aaccfourblock = colorblock.clone().init({ 'hiname' : 'AACCFourHi' })
    let aaccfourblock.tinteditor = tint4editor
    let aaccfourblock.shadeeditor = shade4editor

    let aaccdraction = forms#newAction({ 'execute': function("CCDeckRowAction")})
    let aaccdraction.blocks = [
                                      \ aacconeblock,
                                      \ aacctwoblock,
                                      \ aaccbaseblock,
                                      \ aaccthreeblock,
                                      \ aaccfourblock
                                      \ ]

    function! AACCComplimentaryAction(...) dict
" call forms#log("AACCComplimentaryAction.execute: TOP")
      let rn = a:1
      let gn = a:2
      let bn = a:3

      call self.aacmmonochromaticdraction.execute(rn, gn, bn)

      let shift = g:forms#dialog#color#accentedAnalogicShiftInit
      let [rgb1,rgb2] = forms#color#util#AnalogicRGBusingHSV(shift, rn, gn, bn)
      let [rn1,gn1,bn1] = rgb1
      let [rn2,gn2,bn2] = rgb2
      " analogic 1
      call self.aa1ccdraction.execute(rn1, gn1, bn1)
      " analogic 2
      call self.aa2ccdraction.execute(rn2, gn2, bn2)

      " comp
      let [rn,gn,bn] = forms#color#util#ComplimentRGBusingHSV(rn, gn, bn)
      call self.aaccdraction.execute(rn, gn, bn)

" call forms#log("AACCComplimentaryAction.execute: BOTTOM")
    endfunction
    let aacomplimentaryaction = forms#newAction({ 'execute': function("AACCComplimentaryAction")})
    let aacomplimentaryaction.aacmmonochromaticdraction = aacmmonochromaticdraction
    let aacomplimentaryaction.aa1ccdraction = aa1ccdraction
    let aacomplimentaryaction.aa2ccdraction = aa2ccdraction
    let aacomplimentaryaction.aaccdraction = aaccdraction

    call add(deckaction.palletactions, aacomplimentaryaction)
    call add(adjusteraction.palletactions, aacomplimentaryaction)

    let vspace = forms#newVSpace({'size': 1})
    let aacmonochromhpoly = forms#newHPoly({ 'children': [
                                        \ aacmoneblock, 
                                        \ vspace, 
                                        \ aacmtwoblock, 
                                        \ vspace, 
                                        \ aacmbaseblock, 
                                        \ vspace, 
                                        \ aacmthreeblock, 
                                        \ vspace, 
                                        \ aacmfourblock], 
                                        \ 'alignment': 'C' })
    let aa1ccomplimenthpoly = forms#newHPoly({ 'children': [
                                        \ aa1cconeblock, 
                                        \ vspace, 
                                        \ aa1cctwoblock, 
                                        \ vspace, 
                                        \ aa1ccbaseblock, 
                                        \ vspace, 
                                        \ aa1ccthreeblock, 
                                        \ vspace, 
                                        \ aa1ccfourblock], 
                                        \ 'alignment': 'C' })
    let aa2ccomplimenthpoly = forms#newHPoly({ 'children': [
                                        \ aa2cconeblock, 
                                        \ vspace, 
                                        \ aa2cctwoblock, 
                                        \ vspace, 
                                        \ aa2ccbaseblock, 
                                        \ vspace, 
                                        \ aa2ccthreeblock, 
                                        \ vspace, 
                                        \ aa2ccfourblock], 
                                        \ 'alignment': 'C' })
    let aaccomplimenthpoly = forms#newHPoly({ 'children': [
                                        \ aacconeblock, 
                                        \ vspace, 
                                        \ aacctwoblock, 
                                        \ vspace, 
                                        \ aaccbaseblock, 
                                        \ vspace, 
                                        \ aaccthreeblock, 
                                        \ vspace, 
                                        \ aaccfourblock], 
                                        \ 'alignment': 'C' })

    let aacomplimentbpoly = forms#newVPoly({ 'children': [
                                        \ aacmonochromhpoly, 
                                        \ hspace, 
                                        \ aa1ccomplimenthpoly, 
                                        \ hspace, 
                                        \ aa2ccomplimenthpoly, 
                                        \ hspace, 
                                        \ aaccomplimenthpoly], 
                                        \ 'alignment': 'C' })
    
    
    " Triadic Card --------------------------------------------------
    
    " mono
    let tmoneblock = colorblock.clone().init({ 'hiname' : 'TMOneHi' })
    let tmoneblock.tinteditor = tint1editor
    let tmoneblock.shadeeditor = shade1editor

    let tmtwoblock = colorblock.clone().init({ 'hiname' : 'TMTwoHi' })
    let tmtwoblock.tinteditor = tint2editor
    let tmtwoblock.shadeeditor = shade2editor

    let tmbaseblock = colorblock.clone().init({ 'hiname' : 'TMBaseHi'})

    let tmthreeblock = colorblock.clone().init({ 'hiname' : 'TMThreeHi' })
    let tmthreeblock.tinteditor = tint3editor
    let tmthreeblock.shadeeditor = shade3editor

    let tmfourblock = colorblock.clone().init({ 'hiname' : 'TMFourHi' })
    let tmfourblock.tinteditor = tint4editor
    let tmfourblock.shadeeditor = shade4editor

    let tmmonochromaticdraction = forms#newAction({ 'execute': function("CCDeckRowAction")})
    let tmmonochromaticdraction.blocks = [
                                      \ tmoneblock,
                                      \ tmtwoblock,
                                      \ tmbaseblock,
                                      \ tmthreeblock,
                                      \ tmfourblock
                                      \ ]
   
    " t1comp
    let t1cconeblock = colorblock.clone().init({ 'hiname' : 'T1CCOneHi' })
    let t1cconeblock.tinteditor = tint1editor
    let t1cconeblock.shadeeditor = shade1editor

    let t1cctwoblock = colorblock.clone().init({ 'hiname' : 'T1CCTwoHi' })
    let t1cctwoblock.tinteditor = tint2editor
    let t1cctwoblock.shadeeditor = shade2editor

    let t1ccbaseblock = colorblock.clone().init({ 'hiname' : 'T1CCBaseHi'})

    let t1ccthreeblock = colorblock.clone().init({ 'hiname' : 'T1CCThreeHi' })
    let t1ccthreeblock.tinteditor = tint3editor
    let t1ccthreeblock.shadeeditor = shade3editor

    let t1ccfourblock = colorblock.clone().init({ 'hiname' : 'T1CCFourHi' })
    let t1ccfourblock.tinteditor = tint4editor
    let t1ccfourblock.shadeeditor = shade4editor

    let t1ccdraction = forms#newAction({ 'execute': function("CCDeckRowAction")})
    let t1ccdraction.blocks = [
                                      \ t1cconeblock,
                                      \ t1cctwoblock,
                                      \ t1ccbaseblock,
                                      \ t1ccthreeblock,
                                      \ t1ccfourblock
                                      \ ]

    " t2comp
    let t2cconeblock = colorblock.clone().init({ 'hiname' : 'T2CCOneHi' })
    let t2cconeblock.tinteditor = tint1editor
    let t2cconeblock.shadeeditor = shade1editor

    let t2cctwoblock = colorblock.clone().init({ 'hiname' : 'T2CCTwoHi' })
    let t2cctwoblock.tinteditor = tint2editor
    let t2cctwoblock.shadeeditor = shade2editor

    let t2ccbaseblock = colorblock.clone().init({ 'hiname' : 'T2CCBaseHi'})

    let t2ccthreeblock = colorblock.clone().init({ 'hiname' : 'T2CCThreeHi' })
    let t2ccthreeblock.tinteditor = tint3editor
    let t2ccthreeblock.shadeeditor = shade3editor

    let t2ccfourblock = colorblock.clone().init({ 'hiname' : 'T2CCFourHi' })
    let t2ccfourblock.tinteditor = tint4editor
    let t2ccfourblock.shadeeditor = shade4editor

    let t2ccdraction = forms#newAction({ 'execute': function("CCDeckRowAction")})
    let t2ccdraction.blocks = [
                                      \ t2cconeblock,
                                      \ t2cctwoblock,
                                      \ t2ccbaseblock,
                                      \ t2ccthreeblock,
                                      \ t2ccfourblock
                                      \ ]

    function! TCCComplimentaryAction(...) dict
" call forms#log("TCCComplimentaryAction.execute: TOP")
      let rn = a:1
      let gn = a:2
      let bn = a:3

      call self.tmmonochromaticdraction.execute(rn, gn, bn)

      let [rgb1,rgb2] = forms#color#util#TriadicRGBusingHSV(rn, gn, bn)
      let [rn1,gn1,bn1] = rgb1
      let [rn2,gn2,bn2] = rgb2
      " triadic 1
      call self.t1ccdraction.execute(rn1, gn1, bn1)
      " triadic 2
      call self.t2ccdraction.execute(rn2, gn2, bn2)

" call forms#log("TCCComplimentaryAction.execute: BOTTOM")
    endfunction
    let tcomplimentaryaction = forms#newAction({ 'execute': function("TCCComplimentaryAction")})
    let tcomplimentaryaction.tmmonochromaticdraction = tmmonochromaticdraction
    let tcomplimentaryaction.t1ccdraction = t1ccdraction
    let tcomplimentaryaction.t2ccdraction = t2ccdraction

    call add(deckaction.palletactions, tcomplimentaryaction)
    call add(adjusteraction.palletactions, tcomplimentaryaction)

    let vspace = forms#newVSpace({'size': 1})
    let tcmonochromhpoly = forms#newHPoly({ 'children': [
                                        \ tmoneblock, 
                                        \ vspace, 
                                        \ tmtwoblock, 
                                        \ vspace, 
                                        \ tmbaseblock, 
                                        \ vspace, 
                                        \ tmthreeblock, 
                                        \ vspace, 
                                        \ tmfourblock], 
                                        \ 'alignment': 'C' })
    let t1ccomplimenthpoly = forms#newHPoly({ 'children': [
                                        \ t1cconeblock, 
                                        \ vspace, 
                                        \ t1cctwoblock, 
                                        \ vspace, 
                                        \ t1ccbaseblock, 
                                        \ vspace, 
                                        \ t1ccthreeblock, 
                                        \ vspace, 
                                        \ t1ccfourblock], 
                                        \ 'alignment': 'C' })
    let t2ccomplimenthpoly = forms#newHPoly({ 'children': [
                                        \ t2cconeblock, 
                                        \ vspace, 
                                        \ t2cctwoblock, 
                                        \ vspace, 
                                        \ t2ccbaseblock, 
                                        \ vspace, 
                                        \ t2ccthreeblock, 
                                        \ vspace, 
                                        \ t2ccfourblock], 
                                        \ 'alignment': 'C' })

    let tcomplimentbpoly = forms#newVPoly({ 'children': [
                                        \ tcmonochromhpoly, 
                                        \ hspace, 
                                        \ t1ccomplimenthpoly, 
                                        \ hspace, 
                                        \ t2ccomplimenthpoly], 
                                        \ 'alignment': 'C' })
    
    " Double Complimentary Card -------------------------------------
    
    " mono
    let dcmoneblock = colorblock.clone().init({ 'hiname' : 'DCMOneHi' })
    let dcmoneblock.tinteditor = tint1editor
    let dcmoneblock.shadeeditor = shade1editor

    let dcmtwoblock = colorblock.clone().init({ 'hiname' : 'DCMTwoHi' })
    let dcmtwoblock.tinteditor = tint2editor
    let dcmtwoblock.shadeeditor = shade2editor

    let dcmbaseblock = colorblock.clone().init({ 'hiname' : 'DCMBaseHi'})

    let dcmthreeblock = colorblock.clone().init({ 'hiname' : 'DCMThreeHi' })
    let dcmthreeblock.tinteditor = tint3editor
    let dcmthreeblock.shadeeditor = shade3editor

    let dcmfourblock = colorblock.clone().init({ 'hiname' : 'DCMFourHi' })
    let dcmfourblock.tinteditor = tint4editor
    let dcmfourblock.shadeeditor = shade4editor

    let dcmmonochromaticdraction = forms#newAction({ 'execute': function("CCDeckRowAction")})
    let dcmmonochromaticdraction.blocks = [
                                      \ dcmoneblock,
                                      \ dcmtwoblock,
                                      \ dcmbaseblock,
                                      \ dcmthreeblock,
                                      \ dcmfourblock
                                      \ ]

    " minus
    let dmoneblock = colorblock.clone().init({ 'hiname' : 'DMOneHi' })
    let dmoneblock.tinteditor = tint1editor
    let dmoneblock.shadeeditor = shade1editor

    let dmtwoblock = colorblock.clone().init({ 'hiname' : 'DMTwoHi' })
    let dmtwoblock.tinteditor = tint2editor
    let dmtwoblock.shadeeditor = shade2editor

    let dmbaseblock = colorblock.clone().init({ 'hiname' : 'DMBaseHi'})

    let dmthreeblock = colorblock.clone().init({ 'hiname' : 'DMThreeHi' })
    let dmthreeblock.tinteditor = tint3editor
    let dmthreeblock.shadeeditor = shade3editor

    let dmfourblock = colorblock.clone().init({ 'hiname' : 'DMFourHi' })
    let dmfourblock.tinteditor = tint4editor
    let dmfourblock.shadeeditor = shade4editor

    let dmdraction = forms#newAction({ 'execute': function("CCDeckRowAction")})
    let dmdraction.blocks = [
                                      \ dmoneblock,
                                      \ dmtwoblock,
                                      \ dmbaseblock,
                                      \ dmthreeblock,
                                      \ dmfourblock
                                      \ ]

    " comp
    let dconeblock = colorblock.clone().init({ 'hiname' : 'DCOneHi' })
    let dconeblock.tinteditor = tint1editor
    let dconeblock.shadeeditor = shade1editor

    let dctwoblock = colorblock.clone().init({ 'hiname' : 'DCTwoHi' })
    let dctwoblock.tinteditor = tint2editor
    let dctwoblock.shadeeditor = shade2editor

    let dcbaseblock = colorblock.clone().init({ 'hiname' : 'DCBaseHi'})

    let dcthreeblock = colorblock.clone().init({ 'hiname' : 'DCThreeHi' })
    let dcthreeblock.tinteditor = tint3editor
    let dcthreeblock.shadeeditor = shade3editor

    let dcfourblock = colorblock.clone().init({ 'hiname' : 'DCFourHi' })
    let dcfourblock.tinteditor = tint4editor
    let dcfourblock.shadeeditor = shade4editor

    let dcdraction = forms#newAction({ 'execute': function("CCDeckRowAction")})
    let dcdraction.blocks = [
                                      \ dconeblock,
                                      \ dctwoblock,
                                      \ dcbaseblock,
                                      \ dcthreeblock,
                                      \ dcfourblock
                                      \ ]

    " comp-minus
    let dc_moneblock = colorblock.clone().init({ 'hiname' : 'DC_MOneHi' })
    let dc_moneblock.tinteditor = tint1editor
    let dc_moneblock.shadeeditor = shade1editor

    let dc_mtwoblock = colorblock.clone().init({ 'hiname' : 'DC_MTwoHi' })
    let dc_mtwoblock.tinteditor = tint2editor
    let dc_mtwoblock.shadeeditor = shade2editor

    let dc_mbaseblock = colorblock.clone().init({ 'hiname' : 'DC_MBaseHi'})

    let dc_mthreeblock = colorblock.clone().init({ 'hiname' : 'DC_MThreeHi' })
    let dc_mthreeblock.tinteditor = tint3editor
    let dc_mthreeblock.shadeeditor = shade3editor

    let dc_mfourblock = colorblock.clone().init({ 'hiname' : 'DC_MFourHi' })
    let dc_mfourblock.tinteditor = tint4editor
    let dc_mfourblock.shadeeditor = shade4editor

    let dc_mdraction = forms#newAction({ 'execute': function("CCDeckRowAction")})
    let dc_mdraction.blocks = [
                                      \ dc_moneblock,
                                      \ dc_mtwoblock,
                                      \ dc_mbaseblock,
                                      \ dc_mthreeblock,
                                      \ dc_mfourblock
                                      \ ]

    function! DCCComplimentaryAction(...) dict
" call forms#log("DCCComplimentaryAction.execute: TOP")
      let rn = a:1
      let gn = a:2
      let bn = a:3

      call self.dcmmonochromaticdraction.execute(rn, gn, bn)

      let shift = g:forms#dialog#color#doubleComplimentaryShiftInit
      let [m,c,cm] = forms#color#util#DoubleContrastRGBusingHSV(shift, rn, gn, bn)
      let [mrn,mgn,mbn] = m
      let [crn,cgn,cbn] = c
      let [cmrn,cmgn,cmbn] = cm

      " minus
      call self.dmdraction.execute(mrn, mgn, mbn)
      " comp
      call self.dcdraction.execute(crn, cgn, cbn)
      " comp-minus
      call self.dc_mdraction.execute(cmrn, cmgn, cmbn)

" call forms#log("DCCComplimentaryAction.execute: BOTTOM")
    endfunction
    let dcomplimentaryaction = forms#newAction({ 'execute': function("DCCComplimentaryAction")})
    let dcomplimentaryaction.dcmmonochromaticdraction = dcmmonochromaticdraction
    let dcomplimentaryaction.dmdraction = dmdraction
    let dcomplimentaryaction.dcdraction = dcdraction
    let dcomplimentaryaction.dc_mdraction = dc_mdraction

    call add(deckaction.palletactions, dcomplimentaryaction)
    call add(adjusteraction.palletactions, dcomplimentaryaction)

    let vspace = forms#newVSpace({'size': 1})
    let dcmonochromhpoly = forms#newHPoly({ 'children': [
                                        \ dcmoneblock, 
                                        \ vspace, 
                                        \ dcmtwoblock, 
                                        \ vspace, 
                                        \ dcmbaseblock, 
                                        \ vspace, 
                                        \ dcmthreeblock, 
                                        \ vspace, 
                                        \ dcmfourblock], 
                                        \ 'alignment': 'C' })
    let dmomplimenthpoly = forms#newHPoly({ 'children': [
                                        \ dmoneblock, 
                                        \ vspace, 
                                        \ dmtwoblock, 
                                        \ vspace, 
                                        \ dmbaseblock, 
                                        \ vspace, 
                                        \ dmthreeblock, 
                                        \ vspace, 
                                        \ dmfourblock], 
                                        \ 'alignment': 'C' })
    let dcomplimenthpoly = forms#newHPoly({ 'children': [
                                        \ dconeblock, 
                                        \ vspace, 
                                        \ dctwoblock, 
                                        \ vspace, 
                                        \ dcbaseblock, 
                                        \ vspace, 
                                        \ dcthreeblock, 
                                        \ vspace, 
                                        \ dcfourblock], 
                                        \ 'alignment': 'C' })
    let dc_monochromhpoly = forms#newHPoly({ 'children': [
                                        \ dc_moneblock, 
                                        \ vspace, 
                                        \ dc_mtwoblock, 
                                        \ vspace, 
                                        \ dc_mbaseblock, 
                                        \ vspace, 
                                        \ dc_mthreeblock, 
                                        \ vspace, 
                                        \ dc_mfourblock], 
                                        \ 'alignment': 'C' })

    let dcomplimentbpoly = forms#newVPoly({ 'children': [
                                        \ dcmonochromhpoly, 
                                        \ hspace, 
                                        \ dmomplimenthpoly, 
                                        \ hspace, 
                                        \ dcomplimenthpoly, 
                                        \ hspace, 
                                        \ dc_monochromhpoly], 
                                        \ 'alignment': 'C' })


    "....................
    let deck = forms#newDeck({ 'children': [
                                      \ monochromhpoly, 
                                      \ complimentbpoly, 
                                      \ scomplimentbpoly, 
                                      \ acomplimentbpoly, 
                                      \ aacomplimentbpoly, 
                                      \ tcomplimentbpoly, 
                                      \ dcomplimentbpoly]
                                      \ })

    let deckaction.deck = deck 
    let comboboxaction.deck = deck
    let adjusteraction.deck = deck

    "....................
    let vspace = forms#newVSpace({'size': 1})
    let pallethpoly = forms#newHPoly({ 'children': [
                                        \ adjustergrid, 
                                        \ vspace, 
                                        \ deck], 
                                        \ 'alignment': 'T' })

    let hspace = forms#newHSpace({'size': 1})
    let ivpoly = forms#newVPoly({ 'children': [
                                        \ popdownlist, 
                                        \ hspace, 
                                        \ pallethpoly], 
                                        \ 'alignment': 'C' })

    let title = forms#newLabel({'text': "Pallet Designer"})
    let topvpoly = forms#newVPoly({ 'children': [
                                        \ title, 
                                        \ hpoly, 
                                        \ ivpoly, 
                                        \ buttonhpoly], 
                                        \ 'mode': 'light',
                                        \ 'alignments': [[0,'C']],
                                        \ 'alignment': 'C' })

  endif

  let b = forms#newBorder({ 'body': topvpoly })
  let bg = forms#newBackground({ 'body': b} )
  let form = forms#newForm({'body': bg })
  if a:with_pallet
    function! form.purpose() dict
      return [
          \ "Pallet Designer allows one to select a color and then see",
          \ "  various tints and shades of the color along with associated",
          \ "  colors with their tints and shades.",
          \ "  Use the color selector to find a base color and then the",
          \ "  PopDownList to select the associated colors.",
          \ "  The tint and shade editors (One through Four) can be used",
          \ "  to alter tint and shade values."
          \ ]
    endfunction
  else
    function! form.purpose() dict
      return [
          \ "Color Chooser allows one to select a color. This can be done",
          \ "  using the RGB sliders and editors, as well as with the hex",
          \ "  RDB editor and Xterm 256 editor.",
          \ "  This can also be used to find the Xterm color number that",
          \ "  is closest to a given RGB value."
          \ ]
    endfunction
  endif

  let results = form.run()
  if type(results) == g:self#DICTIONARY_TYPE
" call forms#log("ColorChooser: results=" . string(results))
    return results
  endif
endfunction

"  Modelines: {{{1
" ================
" vim: ts=4 fdm=marker
