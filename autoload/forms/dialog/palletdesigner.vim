
" ------------------------------------------------------------ 
" forms#dialog#palletdesigner#Make:
"  Pallet Designer Dialog
"      buttons.
"    The form has: 
"      Sliders 
"      Field editors 
"      Spcialized TextAreas
"      Deck
"      Buttons submit and cancel
"    Example:
"       ┌───────────────────────────────────────────────────┐
"       │                  Pallet Designer                  │
"       ├───────────────────────────────────────────────────┤
"       │  ┌────────────────────────────────┐ ┌───┐ ┌───┐   │
"       │R │█                               │ │0  │ │44 │   │
"       │  └────────────────────────────────┘ └───┘ └───┘   │
"       │  ┌────────────────────────────────┐ ┌───┐ ┌──────┐│
"       │G │                        ▉▉      │ │205│ │      ││
"       │  └────────────────────────────────┘ └───┘ └──────┘│
"       │  ┌────────────────────────────────┐ ┌───┐ ┌──────┐│
"       │B │                           ▉▉   │ │230│ │00cde6││
"       │  └────────────────────────────────┘ └───┘ └──────┘│
"       ├───────────────────────────────────────────────────┤
"       │                Accented Analogic                  │
"       │                                                   │
"       │      Tint Shade c0f3f9 80e6f3 00cde6 00899a 00454e│
"       │One   0.75 0.00   159    117     44     30     23  │
"       │Two   0.50 0.00                                    │
"       │Three 0.00 0.33  c0d6f9 80adf3 005ae6 003c9a 001e4e│
"       │Four  0.00 0.66   153    111     26     24     17  │
"       │                                                   │
"       │                 c0f9e3 80f3c6 00e68c 009a5d 004e2f│
"       │                  158    122     42     29     22  │
"       │                                                   │
"       │                 f9c6c0 f38c80 e61900 9a1000 4e0800│
"       │                  223    210    160     88     52  │
"       ├───────────────────────────────────────────────────┤
"       │                   Cancel Submit                   │
"       └───────────────────────────────────────────────────┘
"       
"  parameters: None
" ------------------------------------------------------------ 
" forms#dialog#palletdesigner#Make: {{{1
function!  forms#dialog#palletdesigner#Make()
  return forms#dialog#color#Make(1)
endfunction

" forms#dialog#palletdesigner#MakeTest: {{{1
function! forms#dialog#palletdesigner#MakeTest()
  call forms#AppendInput({'type': 'Sleep', 'time': 5})
  call forms#AppendInput({'type': 'Exit'})
  call forms#dialog#palletdesigner#Make()
endfunction

"  Modelines: {{{1
" ================
" vim: ts=4 fdm=marker


