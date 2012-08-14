
" ------------------------------------------------------------ 
" forms#dialog#colorchooser#Make:
"  Color Chooser Dialog
"      buttons.
"    The form has: 
"      Sliders 
"      Field editors 
"      Spcialized TextAreas
"      Buttons submit and cancel
"    Example:
"       ┌───────────────────────────────────────────────────┐
"       │                    Color Chooser                  │
"       ├───────────────────────────────────────────────────┤
"       │  ┌────────────────────────────────┐ ┌───┐ ┌───┐   │
"       │R │                       ▉▉       │ │197│ │184│   │
"       │  └────────────────────────────────┘ └───┘ └───┘   │
"       │  ┌────────────────────────────────┐ ┌───┐ ┌──────┐│
"       │G │                           ▉▉   │ │230│ │      ││
"       │  └────────────────────────────────┘ └───┘ └──────┘│
"       │  ┌────────────────────────────────┐ ┌───┐ ┌──────┐│
"       │B │█                               │ │0  │ │c5e600││
"       │  └────────────────────────────────┘ └───┘ └──────┘│
"       ├───────────────────────────────────────────────────┤
"       │                                      Cancel Submit│
"       └───────────────────────────────────────────────────┘
"       
"  parameters: None
" ------------------------------------------------------------ 
" forms#dialog#colorchooser#Make: {{{1
function!  forms#dialog#colorchooser#Make()
  return forms#dialog#color#Make(0)
endfunction

" forms#dialog#colorchooser#MakeTest: {{{1
function! forms#dialog#colorchooser#MakeTest()
  call forms#AppendInput({'type': 'Sleep', 'time': 5})
  call forms#AppendInput({'type': 'Exit'})
  call forms#dialog#colorchooser#Make()
endfunction

"  Modelines: {{{1
" ================
" vim: ts=4 fdm=marker



