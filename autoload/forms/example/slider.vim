
function! forms#example#slider#Make()
  function! S2HSliderAction(...) dict
    let value = "".a:1
    call self.editor.setText(value)
  endfunction

  function! S2EditorAction(...) dict
    let value = a:1 + 0
    try 
      call self.hslider.setRangeValue(value)
    catch /.*/
" call forms#log("S2EditorAction.execute: exception=" . v:exception)
    endtry
  endfunction

  let hsa1 = forms#newAction({ 'execute': function("S2HSliderAction")})
  let ea1 = forms#newAction({ 'execute': function("S2EditorAction")})
  let attrs = {
            \ 'size' : 2,
            \ 'on_move_action' : hsa1,
            \ 'range' : [0,10]
            \ }
  let hs1 = forms#newHSlider(attrs)
  let ea1.hslider = hs1
  let b1 = forms#newBox({ 'body': hs1} )
  let sp1 = forms#newHSpace({ 'size': 1} )
  let e1 = forms#newFixedLengthField({
                                  \ 'size': 2, 
                                  \ 'on_selection_action' : ea1,
                                  \ 'init_text': '0'})
  let hsa1.editor = e1
  let hpoly1 = forms#newHPoly({ 'children': [b1, sp1, e1], 'alignment': 'C' })

  let hsa2 = forms#newAction({ 'execute': function("S2HSliderAction")})
  let ea2 = forms#newAction({ 'execute': function("S2EditorAction")})
  let attrs = {
            \ 'size' : 2,
            \ 'resolution' : 2,
            \ 'on_move_action' : hsa2,
            \ 'range' : [0,10]
            \ }
  let hs2 = forms#newHSlider(attrs)
  let ea2.hslider = hs2
  let b2 = forms#newBox({ 'body': hs2} )
  let sp2 = forms#newHSpace({ 'size': 1} )
  let e2 = forms#newFixedLengthField({
                                  \ 'size': 2, 
                                  \ 'on_selection_action' : ea2,
                                  \ 'init_text': '0'})
  let hsa2.editor = e2
  let hpoly2 = forms#newHPoly({ 'children': [b2, sp2, e2], 'alignment': 'C' })

  let hsa3 = forms#newAction({ 'execute': function("S2HSliderAction")})
  let ea3 = forms#newAction({ 'execute': function("S2EditorAction")})
  let attrs = {
            \ 'size' : 3,
            \ 'resolution' : 2,
            \ 'on_move_action' : hsa3,
            \ 'range' : [0,10]
            \ }
  let hs3 = forms#newHSlider(attrs)
  let ea3.hslider = hs3
  let b3 = forms#newBox({ 'body': hs3} )
  let sp3 = forms#newHSpace({ 'size': 1} )
  let e3 = forms#newFixedLengthField({
                                  \ 'size': 2, 
                                  \ 'on_selection_action' : ea3,
                                  \ 'init_text': '0'})
  let hsa3.editor = e3
  let hpoly3 = forms#newHPoly({ 'children': [b3, sp3, e3], 'alignment': 'C' })

  let hsa4 = forms#newAction({ 'execute': function("S2HSliderAction")})
  let ea4 = forms#newAction({ 'execute': function("S2EditorAction")})
  let attrs = {
            \ 'size' : 5,
            \ 'resolution' : 2,
            \ 'on_move_action' : hsa4,
            \ 'range' : [0,10]
            \ }
  let hs4 = forms#newHSlider(attrs)
  let ea4.hslider = hs4
  let b4 = forms#newBox({ 'body': hs4} )
  let sp4 = forms#newHSpace({ 'size': 1} )
  let e4 = forms#newFixedLengthField({
                                  \ 'size': 2, 
                                  \ 'on_selection_action' : ea4,
                                  \ 'init_text': '0'})
  let hsa4.editor = e4
  let hpoly4 = forms#newHPoly({ 'children': [b4, sp4, e4], 'alignment': 'C' })

  let hsa5 = forms#newAction({ 'execute': function("S2HSliderAction")})
  let ea5 = forms#newAction({ 'execute': function("S2EditorAction")})
  let attrs = {
            \ 'size' : 5,
            \ 'resolution' : 3,
            \ 'on_move_action' : hsa5,
            \ 'range' : [0,20]
            \ }
  let hs5 = forms#newHSlider(attrs)
  let ea5.hslider = hs5
  let b5 = forms#newBox({ 'body': hs5} )
  let sp5 = forms#newHSpace({ 'size': 1} )
  let e5 = forms#newFixedLengthField({
                                  \ 'size': 2, 
                                  \ 'on_selection_action' : ea5,
                                  \ 'init_text': '0'})
  let hsa5.editor = e5
  let hpoly5 = forms#newHPoly({ 'children': [b5, sp5, e5], 'alignment': 'C' })

  let hsa6 = forms#newAction({ 'execute': function("S2HSliderAction")})
  let ea6 = forms#newAction({ 'execute': function("S2EditorAction")})
  let attrs = {
            \ 'size' : 5,
            \ 'resolution' : 4,
            \ 'on_move_action' : hsa6,
            \ 'range' : [0,32]
            \ }
  let hs6 = forms#newHSlider(attrs)
  let ea6.hslider = hs6
  let b6 = forms#newBox({ 'body': hs6} )
  let sp6 = forms#newHSpace({ 'size': 1} )
  let e6 = forms#newFixedLengthField({
                                  \ 'size': 2, 
                                  \ 'on_selection_action' : ea6,
                                  \ 'init_text': '0'})
  let hsa6.editor = e6
  let hpoly6 = forms#newHPoly({ 'children': [b6, sp6, e6], 'alignment': 'C' })

  let vpolyh = forms#newVPoly({ 'children': [
                                  \ hpoly1, 
                                  \ hpoly2, 
                                  \ hpoly3, 
                                  \ hpoly4,
                                  \ hpoly5,
                                  \ hpoly6
                                  \ ] })

  "....................

  let vsa1 = forms#newAction({ 'execute': function("S2HSliderAction")})
  let vea1 = forms#newAction({ 'execute': function("S2EditorAction")})
  let attrs = {
            \ 'size' : 2,
            \ 'on_move_action' : vsa1,
            \ 'range' : [0,10]
            \ }
  let vs1 = forms#newVSlider(attrs)
  let vea1.hslider = vs1
  let b1 = forms#newBox({ 'body': vs1} )
  let sp1 = forms#newVSpace({ 'size': 1} )
  let e1 = forms#newFixedLengthField({
                                  \ 'size': 2, 
                                  \ 'on_selection_action' : vea1,
                                  \ 'init_text': '0'})
  let vsa1.editor = e1
  let vpoly1 = forms#newVPoly({ 'children': [b1, sp1, e1], 'alignment': 'C' })

  let vsa2 = forms#newAction({ 'execute': function("S2HSliderAction")})
  let vea2 = forms#newAction({ 'execute': function("S2EditorAction")})
  let attrs = {
            \ 'size' : 2,
            \ 'resolution' : 2,
            \ 'on_move_action' : vsa2,
            \ 'range' : [0,10]
            \ }
  let vs2 = forms#newVSlider(attrs)
  let vea2.hslider = vs2
  let b2 = forms#newBox({ 'body': vs2})
  let sp2 = forms#newVSpace({ 'size': 1})
  let e2 = forms#newFixedLengthField({
                                  \ 'size': 2, 
                                  \ 'on_selection_action' : vea2,
                                  \ 'init_text': '0'})
  let vsa2.editor = e2
  let vpoly2 = forms#newVPoly({ 'children': [b2, sp2, e2], 'alignment': 'C' })

  let vsa3 = forms#newAction({ 'execute': function("S2HSliderAction")})
  let vea3 = forms#newAction({ 'execute': function("S2EditorAction")})
  let attrs = {
            \ 'size' : 3,
            \ 'resolution' : 2,
            \ 'on_move_action' : vsa3,
            \ 'range' : [0,10]
            \ }
  let vs3 = forms#newVSlider(attrs)
  let vea3.hslider = vs3
  let b3 = forms#newBox({ 'body': vs3})
  let sp3 = forms#newVSpace({ 'size': 1})
  let e3 = forms#newFixedLengthField({
                                  \ 'size': 2, 
                                  \ 'on_selection_action' : vea3,
                                  \ 'init_text': '0'})
  let vsa3.editor = e3
  let vpoly3 = forms#newVPoly({ 'children': [b3, sp3, e3], 'alignment': 'C' })

  let vsa4 = forms#newAction({ 'execute': function("S2HSliderAction")})
  let vea4 = forms#newAction({ 'execute': function("S2EditorAction")})
  let attrs = {
            \ 'size' : 5,
            \ 'resolution' : 2,
            \ 'on_move_action' : vsa4,
            \ 'range' : [0,10]
            \ }
  let vs4 = forms#newVSlider(attrs)
  let vea4.hslider = vs4
  let b4 = forms#newBox({ 'body': vs4})
  let sp4 = forms#newVSpace({ 'size': 1})
  let e4 = forms#newFixedLengthField({
                                  \ 'size': 2, 
                                  \ 'on_selection_action' : vea4,
                                  \ 'init_text': '0'})
  let vsa4.editor = e4
  let vpoly4 = forms#newVPoly({ 'children': [b4, sp4, e4], 'alignment': 'C' })

  let vsa5 = forms#newAction({ 'execute': function("S2HSliderAction")})
  let vea5 = forms#newAction({ 'execute': function("S2EditorAction")})
  let attrs = {
            \ 'size' : 5,
            \ 'resolution' : 3,
            \ 'on_move_action' : vsa5,
            \ 'range' : [0,20]
            \ }
  let vs5 = forms#newVSlider(attrs)
  let vea5.hslider = vs5
  let b5 = forms#newBox({ 'body': vs5})
  let sp5 = forms#newVSpace({ 'size': 1})
  let e5 = forms#newFixedLengthField({
                                  \ 'size': 2, 
                                  \ 'on_selection_action' : vea5,
                                  \ 'init_text': '0'})
  let vsa5.editor = e5
  let vpoly5 = forms#newVPoly({ 'children': [b5, sp5, e5], 'alignment': 'C' })

  let vsa6 = forms#newAction({ 'execute': function("S2HSliderAction")})
  let vea6 = forms#newAction({ 'execute': function("S2EditorAction")})
  let attrs = {
            \ 'size' : 5,
            \ 'resolution' : 4,
            \ 'on_move_action' : vsa6,
            \ 'range' : [0,32]
            \ }
  let vs6 = forms#newVSlider(attrs)
  let vea6.hslider = vs6
  let b6 = forms#newBox({ 'body': vs6})
  let sp6 = forms#newVSpace({ 'size': 1})
  let e6 = forms#newFixedLengthField({
                                  \ 'size': 2, 
                                  \ 'on_selection_action' : vea6,
                                  \ 'init_text': '0'})
  let vsa6.editor = e6
  let vpoly6 = forms#newVPoly({ 'children': [b6, sp6, e6], 'alignment': 'C' })

  "....................
  let hpoly = forms#newHPoly({ 'children': [
                                      \ vpolyh, 
                                      \ vpoly1, 
                                      \ vpoly2, 
                                      \ vpoly3, 
                                      \ vpoly4, 
                                      \ vpoly5, 
                                      \ vpoly6], 
                                      \ 'alignment': 'C' })

  let b = forms#newBorder({ 'body': hpoly })
  let bg = forms#newBackground({ 'body': b} )
  let form = forms#newForm({'body': bg })
  call form.run()
endfunction

function! forms#example#slider#MakeTest()
  call forms#AppendInput({'type': 'Sleep', 'time': 5})
  call forms#AppendInput({'type': 'Exit'})
  call forms#example#slider#Make()
endfunction
