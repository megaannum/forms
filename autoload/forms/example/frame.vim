
function! forms#example#frame#Make()

  " ul
  let t = forms#newText({'textlines': [
                                    \ "Upper Left", 
                                    \ "Frame"]})
  let box = forms#newBox({ 'body': t} )
  let ds = forms#newFrame({ 'body': box, 
                                \ 'corner': 'ul'} )
  let bul = forms#newBorder({ 'body': ds, 'size': 1} )

  " ur
  let t = forms#newText({'textlines': [
                                    \ "Upper Right", 
                                    \ "Frame" ]})
  let box = forms#newBox({ 'body': t} )
  let ds = forms#newFrame({ 'body': box, 
                                \ 'corner': 'ur'} )
  let bur = forms#newBorder({ 'body': ds, 'size': 1} )

  let hpolyu = forms#newHPoly({ 'children': [bul, bur] })
  
  " ll
  let t = forms#newText({'textlines': [
                                    \ "Lower Left", 
                                    \ "Frame" ]})
  let box = forms#newBox({ 'body': t} )
  let ds = forms#newFrame({ 'body': box, 
                                \ 'corner': 'll'} )
  let bll = forms#newBorder({ 'body': ds, 'size': 1} )

  " lr
  let t = forms#newText({'textlines': [
                                    \ "Lower Right", 
                                    \ "Frame" ]})
  let box = forms#newBox({ 'body': t} )
  let ds = forms#newFrame({ 'body': box, 
                                \ 'corner': 'lr'} )
  let blr = forms#newBorder({ 'body': ds, 'size': 1} )

  let hpolyl = forms#newHPoly({ 'children': [bll, blr] })

  let vpoly = forms#newVPoly({ 'children': [hpolyu, hpolyl] })

  let bg = forms#newBackground({ 'body': vpoly} )

  let form = forms#newForm({'body': bg})
  call form.run()
endfunction

