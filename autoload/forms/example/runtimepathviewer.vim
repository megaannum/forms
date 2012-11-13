
function! s:FnameEscape(fname)
  return exists('*fnameescape')
          \ ? fnameescape(a:fname)
          \ : escape(a:fname, " \t\n*?[{`$\\%#'\"|!<")
endfunc

function! s:GetVimRuntimePaths() 
  return split(&runtimepath, ',')
endfunc

function! forms#example#runtimepathviewer#Make()
  call forms#version()
  let g:forms_log_enabled = 1

  let trees = []
  let paths = s:GetVimRuntimePaths()
" call forms#log("paths=". string(paths))
  for path in paths
" call forms#log("path=". path)
    let pathlist = split(path, '/')
    let node = forms#CreateNode()
    call node.init(pathlist, 0)
    let tree = forms#CreateTree(node)
    call add(trees, tree)
  endfor

  let forest = forms#CreateForest()

  " returns list of [name, isleaf] pairs
  function! Generate_sub_path_info(path) dict
    let l:path = '/' . join(a:path, '/')
" call forms#log("Generate_sub_path_info path=". string(l:path))
    let files = split(globpath(l:path, "*"), "\n")
" call forms#log("Generate_sub_path_info files=". string(files))
    let rval = []
    for file in files
      let isleaf = !isdirectory(file)
      let idx = strridx(file, '/')
      let name = strpart(file, idx+1)
      call add(rval, [name, isleaf])
    endfor
    return rval
  endfunction
  let forest.generateSubPathInfo = function("Generate_sub_path_info")

  function! Has_sub_path_info(path) dict
    let l:path = '/' . join(a:path, '/')
" call forms#log("Has_sub_path_info path=". string(l:path))
    let files = split(globpath(l:path, "*"), "\n")
" call forms#log("Has_sub_path_info files=". string(files))
    let rval = 0
    for file in files
      if isdirectory(file)
        let rval = 1
        break
      endif
    endfor
    return rval
  endfunction
  let forest.hasSubPathInfo = function("Has_sub_path_info")

  function! Path_to_string(path) dict
    return '/' . join(a:path, '/')
  endfunction
  let forest.pathToString = function("Path_to_string")


  function! ForestOnOpenAction(tree, node) dict
    call forms#log("OPEN: ". a:node.name)
    call self.nv.setNode(a:tree, a:node, 1)
  endfunction
  let fooa = forms#newAction({ 'execute': function("ForestOnOpenAction")})

  function! ForestOnCloseAction(tree, node) dict
    call forms#log("CLOSE: ". a:node.name)
    let [found, parent_node] = a:node.getParent(a:tree)
    if found
      call self.nv.setNode(a:tree, parent_node, 1)
    else
      " no parent, must be at top
      call self.nv.setNode(a:tree, a:node, 1)
    endif
  endfunction
  let foca = forms#newAction({ 'execute': function("ForestOnCloseAction")})

  function! ForestOnSelectionAction(tree, node) dict
    call forms#log("SELECT: ". a:node.name)
  endfunction
  let fosa = forms#newAction({ 'execute': function("ForestOnSelectionAction")})

  for tree in trees
    call forest.addTree(tree)
  endfor

  let height = 20 
  let attrs = { 'width': 30,
              \ 'height': height,
              \ 'forest': forest,
              \ 'content_order': 'non-leaf-only',
              \ 'on_open_action': fooa,
              \ 'on_close_action': foca,
              \ 'on_selection_action': fosa
              \ }
  let fv = forms#newForestViewer(attrs)
  let fvbox = forms#newBox({ 'body': fv } )



  function! NodeOnOpenAction(tree, node) dict
call forms#log("NODE OPEN: ". a:node.name)
    call self.fv.setNode(a:tree, a:node)
  endfunction
  let nooa = forms#newAction({ 'execute': function("NodeOnOpenAction")})

  function! NodeOnCloseAction(tree, node) dict
call forms#log("NODE CLOSE: ". a:node.name)
   call self.fv.setNode(a:tree, a:node)
  endfunction
  let noca = forms#newAction({ 'execute': function("NodeOnCloseAction")})

  function! NodeOnSelectionAction(tree, node) dict
call forms#log("NODE SELECT: ". a:node.name)
  endfunction
  let nosa = forms#newAction({ 'execute': function("NodeOnSelectionAction")})

  let attrs = { 'width': 30,
              \ 'height': height,
              \ 'node': node,
              \ 'tree': tree,
              \ 'top_node_full_name': 0,
              \ 'on_open_action': nooa,
              \ 'on_close_action': noca,
              \ 'on_selection_action': nosa
              \ }
  let nv = forms#newNodeViewer(attrs)
  let nvbox = forms#newBox({ 'body': nv } )


  let fooa.nv = nv
  let foca.nv = nv
  let fosa.nv = nv

  let nooa.fv = fv
  let noca.fv = fv
  let nosa.fv = fv


  let hpoly = forms#newHPoly({ 'children': [fvbox, nvbox] })

  let bg = forms#newBackground({ 'body': hpoly} )

  let form = forms#newForm({'body': bg })
  call form.run()
endfunction

function! forms#example#runtimepathviewer#MakeTest()
  call forms#AppendInput({'type': 'Sleep', 'time': 5})
  call forms#AppendInput({'type': 'Exit'})
  call forms#example#runtimepathviewer#Make()
endfunction
