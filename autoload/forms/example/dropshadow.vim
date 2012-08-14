
function! forms#example#dropshadow#Make()
  " ul
  let t = forms#newText({'textlines': [
                                    \ "Upper Left", 
                                    \ "Drop Shadow" 
                                    \ ]})
  let box = forms#newBox({ 'body': t} )
  let ds = forms#newDropShadow({ 'body': box, 'corner': 'ul'} )
  let bul = forms#newBorder({ 'body': ds, 'size': 2} )

  " ur
  let t = forms#newText({'textlines': [
                                    \ "Upper Right", 
                                    \ "Drop Shadow" 
                                    \ ]})
  let box = forms#newBox({ 'body': t} )
  let ds = forms#newDropShadow({ 'body': box, 'corner': 'ur'} )
  let bur = forms#newBorder({ 'body': ds, 'size': 2} )

  let hpolyu = forms#newHPoly({ 'children': [bul, bur] })
  
  " ll
  let t = forms#newText({'textlines': [
                                    \ "Lower Left", 
                                    \ "Drop Shadow" 
                                    \ ]})
  let box = forms#newBox({ 'body': t} )
  let ds = forms#newDropShadow({ 'body': box, 'corner': 'll'} )
  let bll = forms#newBorder({ 'body': ds, 'size': 2} )

  " lr
  let t = forms#newText({'textlines': [
                                    \ "Lower Right", 
                                    \ "Drop Shadow" 
                                    \ ]})
  let box = forms#newBox({ 'body': t} )
  let ds = forms#newDropShadow({ 'body': box, 'corner': 'lr'} )
  let blr = forms#newBorder({ 'body': ds, 'size': 2} )

  let hpolyl = forms#newHPoly({ 'children': [bll, blr] })

  let vpoly = forms#newVPoly({ 'children': [hpolyu, hpolyl] })

  let bg = forms#newBackground({ 'body': vpoly} )

  let form = forms#newForm({'body': bg})
  call form.run()
endfunction

function! forms#example#dropshadow#MakeTest()
  call forms#AppendInput({'type': 'Sleep', 'time': 5})
  call forms#AppendInput({'type': 'Exit'})
  call forms#example#dropshadow#Make()
endfunction
