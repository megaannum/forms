" ============================================================================
" util.vim
"
" File:          util.vim
" Summary:       color utilities (part of Forms Library)
" Author:        Richard Emberson <richard.n.embersonATgmailDOTcom>
" ============================================================================

"-------------------------------------------------------------------------------
" Forms Color Utilities: {{{1
"  Gets Color Utility object that has numerous support methods
"    This utility deals with rgb and xterm 256 and rxvtu 88 color values.
"    for eterm kconole see
"     https://github.com/vim-scripts/colorsupport.vim/commits/master
"     http://www.gnu-darwin.org/www001/src/ports/x11/eterm/work/Eterm-0.9.4/src/term.c.html
"  parameters: NONE
"-------------------------------------------------------------------------------

" ------------------------------------------------------------ 
" ParseRGB: {{{2
"  Parses arguments into List of Number
"  parameters:
"    rgb     : String rgb value "0fe012"
"              String rgb with '#' value "#0fe012"
"              List ["r","g", "b"] triplet of Strings ["0f","e0","12"]
"              List [rn,gn, bn] triplet of Numbers (0 <= n < 256)
"              List [rf,gf, bf] triplet of Floats (0.0 <= f < 256.0)
"              String r value "0f"
"              Number (0 <= n < 256) representing r value
"              Float (0.0 <= f < 256.0) representing r value
"    g       : optional 
"              String g value "e0"
"              Number (0 <= n < 256)
"              Float (0.0 <= f < 256.0)
"    b       : optional
"              String b value "12"
"              Number (0 <= n < 256)
"              Float (0.0 <= f < 256.0)
" ------------------------------------------------------------ 
function! forms#color#util#ParseRGB(rgb, ...)
"call forms#log("ParseRGB: TOP rgb=". string(a:rgb) . " a:0=" . a:0)
"let start = reltime()
  let needs_extra_args = g:self#IS_FALSE

  if type(a:rgb) == g:self#STRING_TYPE
    " remove hash
    let rgb = (a:rgb[0] == '#') ? a:rgb[1:] : a:rgb

    if len(rgb) == 2
      let rs = rgb
      let rn = str2nr(rs, 16)
      let needs_extra_args = g:self#IS_TRUE

    elseif len(rgb) == 6
      let rs = rgb[0:1]
      let gs = rgb[2:3]
      let bs = rgb[4:5]
      let rn = str2nr(rs, 16)
      let gn = str2nr(gs, 16)
      let bn = str2nr(bs, 16)

    else
      throw "forms#color#util.ParseRGB Bad String rgb value: ".  string(a:rgb)
    endif

  elseif type(a:rgb) == g:self#LIST_TYPE
    let rgb = a:rgb
    if len(rgb) != 3
      throw "forms#color#util.ParseRGB Bad List rgb value: ".  string(rgb)
    endif

    let rx = rgb[0]
    if type(rx) == g:self#NUMBER_TYPE
      let rn = rx
    elseif type(rx) == g:self#FLOAT_TYPE
      let rn = float2nr(rx)
    elseif type(rx) == g:self#STRING_TYPE
      let rs = rx
      let rn = str2nr(rs, 16)
    else
      throw "forms#color#util.ParseRGB Bad List r type: ".  string(rgb)
    endif

    let gx = rgb[1]
    if type(gx) == g:self#NUMBER_TYPE
      let gn = gx
    elseif type(gx) == g:self#FLOAT_TYPE
      let gn = float2nr(gx)
    elseif type(gx) == g:self#STRING_TYPE
      let gs = gx
      let gn = str2nr(gs, 16)
    else
      throw "forms#color#util.ParseRGB Bad List g type: " . string(rgb)
    endif

    let bx = rgb[2]
    if type(bx) == g:self#NUMBER_TYPE
      let bn = bx
    elseif type(bx) == g:self#FLOAT_TYPE
      let bn = float2nr(bx)
    elseif type(bx) == g:self#STRING_TYPE
      let bs = bx
      let bn = str2nr(bs, 16)
    else
      throw "forms#color#util.ParseRGB Bad List b type: " . string(rgb)
    endif

  elseif type(a:rgb) == g:self#NUMBER_TYPE
    let rn = a:rgb
    let needs_extra_args = g:self#IS_TRUE

  elseif type(a:rgb) == g:self#FLOAT_TYPE
    let rn = float2nr(a:rgb)
    let needs_extra_args = g:self#IS_TRUE

  else
    throw "forms#color#util.ParseRGB Bad rgb type: " . string(a:rgb)
  endif

  if needs_extra_args == g:self#IS_TRUE
    if a:0 != 2
      throw "forms#color#util.ParseRGB requires 2 additional arugments: a:0=".  a:0)
    endif

    let gx = a:1
    if type(gx) == g:self#NUMBER_TYPE
      let gn = gx
    elseif type(gx) == g:self#FLOAT_TYPE
      let gn = float2nr(gx)
    elseif type(gx) == g:self#STRING_TYPE
      let gs = gx
      let gn = str2nr(gs, 16)
    else
      throw "forms#color#util.ParseRGB Bad g type: ".  string(gx)
    endif

    let bx = a:2
    if type(bx) == g:self#NUMBER_TYPE
      let bn = bx
    elseif type(bx) == g:self#FLOAT_TYPE
      let bn = float2nr(bx)
    elseif type(bx) == g:self#STRING_TYPE
      let bs = bx
      let bn = str2nr(bs, 16)
    else
      throw "forms#color#util.ParseRGB Bad b type: " . string(bx)
    endif

  endif
"call forms#log("ParseRGB: time=". reltimestr(reltime(start)))

  return [rn,gn,bn]
endfunction

" ------------------------------------------------------------ 
" TintRGB: {{{2
"  Brighten rgb color returns Number triplet
"  sat/val      brighten/darken
"  '0.25:1',      0.75:0,0
"  '0.5:1',       0.5:0.0
"  '0.666:0.666', 0.33: -0.33
"  '0.666:0.333', 0.33: -0.66
"  '0.5:0.75',    0.5: -0.25
"  '0.25:0.87'    0.75: -0.13
" brighten 
" adjust saturation
" 1.0      0
" 0.5     50
" 0.0    100
"  parameters:
"    adjust : Float used to brighten or darken rgb color 
"              value must be between 0 <= adujst <= 1
"              if value < 0 treated as value = 0
"              if value > 1 treated as value = 1
"              zero values unchanged
"              positive values brighten
"    rn    : Parameters accepted by ParseRGB
"    gn    : Parameters accepted by ParseRGB
"    bn    : Parameters accepted by ParseRGB
" ------------------------------------------------------------ 
function! forms#color#util#TintRGB(adjust, rn, gn, bn) 
  let adjust = a:adjust
  let rn = a:rn
  let gn = a:gn
  let bn = a:bn

  if adjust <= 0.0
    return [rn,gn,bn]
  elseif adjust >= 1.0
    return [255,255,255]
  else
    " float2nr drops part after decimal point
    let rn = float2nr(rn + ((256 - rn) * adjust))
    let gn = float2nr(gn + ((256 - gn) * adjust))
    let bn = float2nr(bn + ((256 - bn) * adjust))
    return [rn,gn,bn]
  endif
endfunction

" ------------------------------------------------------------ 
" ShadeRGB: {{{2
"  Darken rgb color returns Number triplet
"  sat/val      brighten/darken
"  '0.5:1',       0.5:0.0
"  '0.25:1',      0.75:0,0
"  '0.666:0.666', 0.33: -0.33
"  '0.666:0.333', 0.33: -0.66
"  '0.5:0.75',    0.5: -0.25
"  '0.25:0.87'    0.75: -0.13
" darken 
" adjust value
"  1.0    100
"  0.5     50
"  0.0      0
"  parameters:
"    adjust : Float used to brighten or darken rgb color 
"              value must be between 0 <= adujst <= 1
"              if value < 0 treated as value = 0
"              if value > 1 treated as value = 1
"              negative values darken
"              zero values unchanged
"              positive values brighten
"    rgb    : Parameters accepted by ParseRGB
" ------------------------------------------------------------ 
function! forms#color#util#ShadeRGB(adjust, rn, gn, bn) 
  let adjust = a:adjust
  let rn = a:rn
  let gn = a:gn
  let bn = a:bn

  if adjust <= 0.0
    return [rn,gn,bn]
  elseif adjust >= 1.0
    return [0,0,0]
  else
    let f = 1.0 - adjust
    " float2nr drops part after decimal point
    let rn = float2nr(rn * f)
    let gn = float2nr(gn * f)
    let bn = float2nr(bn * f)
    return [rn,gn,bn]
  endif
endfunction


" ------------------------------------------------------------ 
" BrightnessRGB: {{{2
"  Brighten or darken rgb color returns Number triplet
"  sat/val      brighten/darken
"  '0.5:1',       0.5:0.0
"  '0.25:1',      0.75:0,0
"  '0.666:0.666', 0.33: -0.33
"  '0.666:0.333', 0.33: -0.66
"  '0.5:0.75',    0.5: -0.25
"  '0.25:0.87'    0.75: -0.13
"  parameters:
"    adjust : Float used to brighten or darken rgb color 
"              value must be between -1 <= adujst <= 1
"              negative values darken
"              zero values unchanged
"              positive values brighten
"    rgb    : Parameters accepted by ParseRGB
" ------------------------------------------------------------ 
function! forms#color#util#BrightnessRGBXX(adjust, rgb, ...) 
" call forms#log("BrightnessRGB: TOP rgb=". string(a:rgb)." a:0=".a:0)
  if a:0 == 0
    let [rn,gn,bn] = forms#color#util#ParseRGB(a:rgb)
  elseif a:0 == 2
    let [rn,gn,bn] = forms#color#util#ParseRGB(a:rgb, a:000[0], a:000[1])
  else
      throw "forms#color#util.BrightnessRGB: Wrong number of additional arguments: " . a:0
  endif
endfunction

function! forms#color#util#BrightnessRGB(adjust, rn, gn, bn) 
  let adjust = a:adjust
  let rn = a:rn
  let gn = a:gn
  let bn = a:bn

  if adjust >= 0
    " brighten 
    " adjust saturation
    " 1.0      0
    " 0.5     50
    " 0.0    100
    let rn = float2nr(rn + ((255 - rn) * adjust))
    let gn = float2nr(gn + ((255 - gn) * adjust))
    let bn = float2nr(bn + ((255 - bn) * adjust))
  else
    " darken 
    " adjust value
    " -1.0     0
    " -0.5    50
    " -0.0   100
    let f = adjust + 1.0
    let rn = float2nr(rn * f)
    let gn = float2nr(gn * f)
    let bn = float2nr(bn * f)
  endif

  return [rn,gn,bn]
endfunction

" ------------------------------------------------------------ 
" MergerRGBs: {{{2
"  Take "average" of two rgb strings
"    Returns List rgb-average of parameter.
"  parameters:
"    rgb1 : Parameters accepted by ParseRGB
"    rgb2 : Parameters accepted by ParseRGB
" ------------------------------------------------------------ 
function! forms#color#util#MergerRGBs(rgb1, rgb2) 
" call forms#log("MergerRGBs: TOP rgb1=". a:rgb1)
" call forms#log("MergerRGBs: TOP rgb2=". a:rgb2)
  let [rn1,gn1,bn1] = forms#color#util#ParseRGB(a:rgb1)
  let [rn2,gn2,bn2] = forms#color#util#ParseRGB(a:rgb2)

  let rn = (rn1+rn2)/2
  let gn = (gn1+gn2)/2
  let bn = (bn1+bn2)/2

  return [rn, gn, bn]
endfunction

" ------------------------------------------------------------ 
" ShiftHue: {{{2
"  Shift hue by given adjustment
"  parameters:
"    shift : -0.5 <= float <= 0.5
"    hue   : hue to be adjusted
" ------------------------------------------------------------ 
function! forms#color#util#ShiftHue(shift, hue) 
" let hues = printf("%f",a:hue)
" call forms#log("ShiftHue: TOP hue=". hues)
  let hc = a:hue + a:shift
  if (hc >= 1.0) 
    let hc -= 1.0
  elseif (hc < 0.0) 
    let hc += 1.0
  endif
  return hc
endfunction

" ------------------------------------------------------------ 
" ConvertRGB2HSL: {{{2
"  Converts an rgb String HSL triplet [h,s,l]
"     with values 0.0 <= v <= 1.0
"  parameters:
"    rn  : red Number
"    gn  : green Number
"    bn  : blue Number
" ------------------------------------------------------------ 
function! forms#color#util#ConvertRGB2HSL(rn, gn, bn) 
  let rn = a:rn
  let gn = a:gn
  let bn = a:bn

" call forms#log("ConvertRGB2HSL: rn,gn,bn=".rn.",".gn.",".bn)
  let rf = (0.0 + rn)/255
  let gf = (0.0 + gn)/255
  let bf = (0.0 + bn)/255
  
  let minn = min([rn,gn,bn])
  let maxn = max([rn,gn,bn])

  let minf = (0.0 + minn)/255
  let maxf = (0.0 + maxn)/255
  let delf = maxf - minf
" let mins = printf("%f",minf)
" let maxs = printf("%f",maxf)
" call forms#log("ConvertRGB2HSL: min,max=".mins.",".maxs)

  let l = (maxf + minf)/2.0

  if delf == 0
    let h = 0.0
    let s = 0.0
  else
      if l < 0.5
        let s = delf/(maxf + minf)
      else
        let s = delf/(2 - maxf - minf)
      endif

      if rn == maxn
        let h = ((gf - bf)/delf) + ((gf < bf)? 6 : 0)
      elseif gn == maxn
        let h = ((bf - rf)/delf) + 2
      else 
        let h = ((rf - gf)/delf) + 4
      endif

      let h = h / 6
if 0
      let delfhalf = delf/2
      
      let dr = (((maxf - rf)/6) + delfhalf)/delf
      let dg = (((maxf - gf)/6) + delfhalf)/delf
      let db = (((maxf - bf)/6) + delfhalf)/delf

      if rn == maxn
        let h = db - dg
      elseif gn == maxn
        let h = 0.3333333 + dr - db
      else
        let h = 0.6666666 + dg - dr
      endif

      if h < 0
        let h += 1
      elseif h > 1 
        let h -= 1
      endif
endif
  endif
  return [h,s,l]
endfunction

" ------------------------------------------------------------ 
" ReduceHSL: {{{2
"  Generates HSL triplets one for each pair of Floats in List.
"  parameters:
"    h           : hue
"    s           : saturation
"    l           : value
"    adjustments : List of List of Float pair to be applied to s and l
" ------------------------------------------------------------ 
function! forms#color#util#ReduceHSL(h,s,l, adjustments) 
  let r = []
  for adj in a:adjustments
    let sadj = a[0]
    let vadj = a[1]
    call add(r, [a:h, a:s * sadj, a:l * vadj])
  endfor
  return r
endfunction

" ------------------------------------------------------------ 
" ConvertHSL2RGB: {{{2
"  Converts HSL Float triplet to RGB Float triplet 
"  parameters:
"    h           : hue
"    s           : saturation
"    l           : value
" ------------------------------------------------------------ 
function! forms#color#util#ConvertHSL2RGB(h,s,l) 
"let hstr = printf("%f",a:h)
"let sstr = printf("%f",a:s)
"let lstr = printf("%f",a:l)
" call forms#log("ConvertHSL2RGB: TOP h,s,l=". hstr.",".sstr.",".lstr)
  let h = a:h
  let s = a:s
  let l = a:l

  if s == 0.0
" call forms#log("ConvertHSL2RGB: IF")
    let r = 255.0 * l
    let g = 255.0 * l
    let b = 255.0 * l
  else
" call forms#log("ConvertHSL2RGB: ELSE")
    if l < 0.5
      let v2 = l * (1 + s)
    else
      let v2 = (l + s) - (s * l)
    endif

    " let v1 = l - v2
    let v1 = 2 * l - v2

    function! Hue2RGB(v1, v2, vh)
      let vh = a:vh
      if vh < 0
        let vh += 1
      elseif vh > 1
        let vh -= 1
      endif

      if (6 * vh) < 1
        return a:v1 + (a:v2 - a:v1) * 6 * vh
      elseif (2 * vh) < 1
        return a:v2
      elseif (3 * vh) < 2
        return a:v1 + (a:v2 - a:v1) * (0.6666666 - vh) * 6
      else
        return a:v1
      endif
    endfunction

    let r = 255 * Hue2RGB(v1, v2, h + 0.3333333)
    let g = 255 * Hue2RGB(v1, v2, h)
    let b = 255 * Hue2RGB(v1, v2, h - 0.3333333)

  endif
  return [r,g,b]
endfunction

" ------------------------------------------------------------ 
" ShiftHueRGBusingHSL: {{{2
"  ShiftHues rgb returns rgb triplet using HSL
"  parameters:
"    shift : -0.5 <= float <= 0.5
"    rn  : red Number
"    gn  : green Number
"    bn  : blue Number
" ------------------------------------------------------------ 
function! forms#color#util#ShiftHueRGBusingHSL(shift, rn, gn, bn) 
  let hsl = forms#color#util#ConvertRGB2HSL(a:rn, a:gn, a:bn)

  let h = hsl[0]
  let s = hsl[1]
  let l = hsl[2]
  let hc = forms#color#util#ShiftHue(a:shift, h)
  return forms#color#util#ConvertHSL2RGB(hc,s,l)
endfunction

" ------------------------------------------------------------ 
" ComplimentRGBusingHSL: {{{2
"  Returns HSL compliment of RGB Float triplet
"  parameters:
"    rn  : red Number
"    gn  : green Number
"    bn  : blue Number
" ------------------------------------------------------------ 
function! forms#color#util#ComplimentRGBusingHSL(rn, gn, bn) 
  let shift = 180.0/360
  return forms#color#util#ShiftHueRGBusingHSL(shift, a:rgb, a:000)
endfunction

" ------------------------------------------------------------ 
" AnalogicRGBusingHSL: {{{2
"  Returns HSL analogic values (+30,-30) of pair of RGB Float triplet
"  parameters:
"    rn  : red Number
"    gn  : green Number
"    bn  : blue Number
" ------------------------------------------------------------ 
function! forms#color#util#AnalogicRGBusingHSL(rn, gn, bn) 
  let hsl = forms#color#util#ConvertRGB2HSL(a:rn, a:gn, a:bn)
  let h = hsl[0]
  let s = hsl[1]
  let l = hsl[2]
  let shift = 30.0/360
  let hc1 = forms#color#util#ShiftHue(shift, h)
  let hc2 = forms#color#util#ShiftHue(-shift, h)
  return [forms#color#util#ConvertHSL2RGB(hc1,s,l), forms#color#util#ConvertHSL2RGB(hc2,s,l)]
endfunction

" ------------------------------------------------------------ 
" SplitComplimentaryRGBusingHSL: {{{2
"  Returns HSL split complimentary values 
"  (180+30,180-30) of pair of RGB Float triplet
"  parameters:
"    rn  : red Number
"    gn  : green Number
"    bn  : blue Number
" ------------------------------------------------------------ 
function! forms#color#util#SplitComplimentaryRGBusingHSL(rn, gn, bn) 
  let hsl = forms#color#util#ConvertRGB2HSL(a:rn, a:gn, a:bn)
  let h = hsl[0]
  let s = hsl[1]
  let v = hsl[2]
  let half = 180.0/360
  let shift = 30.0/360
  let hc2 = forms#color#util#ShiftHue(half-shift, h)
  let hc1 = forms#color#util#ShiftHue(half+shift, h)
  return [forms#color#util#ConvertHSL2RGV(hc1,s,v), forms#color#util#ConvertHSL2RGV(hc2,s,v)]
endfunction

" ------------------------------------------------------------ 
" TriadicRGBusingHSL: {{{2
"  Returns HSL triadic values 
"  (180+60,180-60) of pair of RGB Float triplet
"  parameters:
"    rn  : red Number
"    gn  : green Number
"    bn  : blue Number
" ------------------------------------------------------------ 
function! forms#color#util#TriadicRGBusingHSL(rn, gn, bn) 
  let hsl = forms#color#util#ConvertRGB2HSL(a:rn, a:gn, a:bn)
  let h = hsl[0]
  let s = hsl[1]
  let v = hsl[2]
  let half = 180.0/360
  let shift = 60.0/360
  let hc2 = forms#color#util#ShiftHue(half-shift, h)
  let hc1 = forms#color#util#ShiftHue(half+shift, h)
  return [forms#color#util#ConvertHSL2RGV(hc1,s,v), forms#color#util#ConvertHSL2RGV(hc2,s,v)]
endfunction

" ------------------------------------------------------------ 
" ConvertRGB2HSV: {{{2
"  Converts an rgb values HSV Float triplet
"  parameters:
"    rn  : red Number
"    gn  : green Number
"    bn  : blue Number
" ------------------------------------------------------------ 
function! forms#color#util#ConvertRGB2HSV(rn, gn, bn) 
  let rn = a:rn
  let gn = a:gn
  let bn = a:bn

  let rf = (0.0 + rn)/255
  let gf = (0.0 + gn)/255
  let bf = (0.0 + bn)/255

  if rf < gf
    if rf < bf
      let x = rf
    else
      let x = bf
    endif
  else
    if gf < bf
      let x = gf
    else
      let x = bf
    endif
  endif

  if rf > gf
    if rf > bf
      let val = rf
    else
      let val = bf
    endif
  else
    if gf > bf
      let val = gf
    else
      let val = bf
    endif
  endif

  if x == val
    return [0.0, 0.0, val]
  else

    if rf == x
      let f = gf-bf
      let i = 3
    elseif gf == x
      let f = bf-rf
      let i = 5
    else
      let f = rf-gf
      let i = 1
    endif

    let d = val - x
    let hue = (i - f/d) / 6
    let sat = d/val

    return [hue,sat,val]
  endif
endfunction


" ReduceHSV: {{{2
"  Generates HSV triplets one for each pair of Floats in List.
"  parameters:
"    h           : hue
"    s           : saturation
"    v           : value
"    adjustments : List of List of Float pair to be applied to s and v
" ------------------------------------------------------------ 
function! forms#color#util#ReduceHSV(h,s,v, adjustments) 
  let r = []
  for adj in a:adjustments
    let sadj = a[0]
    let vadj = a[1]
    call add(r, [a:h, a:s * sadj, a:v * vadj])
  endfor
  return r
endfunction

" ------------------------------------------------------------ 
" ConvertHSV2RGB: {{{2
"  Converts HSV Float triplet to RGB Float triplet
"  parameters:
"    h : hue
"    s : saturation
"    v : value
" ------------------------------------------------------------ 
function! forms#color#util#ConvertHSV2RGB(h,s,v) 
"let hstr = printf("%f",a:h)
"let sstr = printf("%f",a:s)
"let vstr = printf("%f",a:v)
"call forms#log("ConvertHSV2RGB: TOP h,s,v=". hstr.",".sstr.",".vstr)
  let h = a:h
  let s = a:s
  let v = a:v

  let i = floor(h*6)
  let f = h * 6 - i
  let p = v * (1 - s)
  let q = v * (1 - f*s) 
  let t = v * (1 - (1-f)*s)

  let im = float2nr(i) % 6
  if im == 0
    let r = v
    let g = t
    let b = p
  elseif im == 1
    let r = q
    let g = v
    let b = p
  elseif im == 2
    let r = p
    let g = v
    let b = t
  elseif im == 3
    let r = p
    let g = q
    let b = v
  elseif im == 4
    let r = t
    let g = p
    let b = v
  else
    let r = v
    let g = p
    let b = q
  endif
  let offset = 0.000000000001
  return [
          \ float2nr((r * 255)+offset), 
          \ float2nr((g * 255)+offset), 
          \ float2nr((b * 255)+offset)]
endfunction

" ------------------------------------------------------------ 
" ShiftHueRGBusingHSV: {{{2
"  ShiftHues rgb returns RGB Float triplet using HSV
"  parameters:
"    shift : -0.5 <= float <= 0.5
"    rn  : red Number
"    gn  : green Number
"    bn  : blue Number
" ------------------------------------------------------------ 
function! forms#color#util#ShiftHueRGBusingHSV(shift, rn, gn, bn) 
" call forms#log("ShiftHueRGBusingHSV: TOP rgbstr=". a:rgb)
  let hsl = forms#color#util#ConvertRGB2HSV(a:rn, a:gn, a:bn)
  let h = hsl[0]
  let s = hsl[1]
  let l = hsl[2]
  let hc = forms#color#util#ShiftHue(a:shift, h)
  return forms#color#util#ConvertHSV2RGB(hc,s,l)
endfunction

" ------------------------------------------------------------ 
" ComplimentRGBusingHSV: {{{2
"  Returns HSV compliment of RGB Float triplet
"  parameters:
"    rn  : red Number
"    gn  : green Number
"    bn  : blue Number
" ------------------------------------------------------------ 
function! forms#color#util#ComplimentRGBusingHSV(rn, gn, bn) 
  let shift = 180.0/360
  return forms#color#util#ShiftHueRGBusingHSV(shift, a:rn, a:gn, a:bn)
endfunction

" ------------------------------------------------------------ 
" AnalogicRGBusingHSV: {{{2
"  Returns HSV analogic values shifted (for example: +30,-30) 
"     of pair of RGB Float triplet
"  parameters:
"    shift  : Float how much to shift hue + and -.
"               Should be from 0.0 to 0.5
"    rn     : red Number
"    gn     : green Number
"    bn     : blue Number
" ------------------------------------------------------------ 
function! forms#color#util#AnalogicRGBusingHSV(shift, rn, gn, bn) 
  let hsl = forms#color#util#ConvertRGB2HSV(a:rn, a:gn, a:bn)
  let h = hsl[0]
  let s = hsl[1]
  let v = hsl[2]
  let hc1 = forms#color#util#ShiftHue(a:shift, h)
  let hc2 = forms#color#util#ShiftHue(-a:shift, h)
  return [forms#color#util#ConvertHSV2RGB(hc1,s,v), forms#color#util#ConvertHSV2RGB(hc2,s,v)]
endfunction

" ------------------------------------------------------------ 
" SplitComplimentaryRGBusingHSV: {{{2
"  Returns HSV split complimentary values 
"  (for example: 180+30,180-30) of pair of RGB Float triplet
"  parameters:
"    shift  : Float how much to shift hue + and -.
"               Should be from 0.0 to 0.5
"    rn     : red Number
"    gn     : green Number
"    bn     : blue Number
" ------------------------------------------------------------ 
function! forms#color#util#SplitComplimentaryRGBusingHSV(shift, rn, gn, bn) 
  let hsl = forms#color#util#ConvertRGB2HSV(a:rn, a:gn, a:bn)
  let h = hsl[0]
  let s = hsl[1]
  let v = hsl[2]
  let half = 180.0/360
  let hc2 = forms#color#util#ShiftHue(half-a:shift, h)
  let hc1 = forms#color#util#ShiftHue(half+a:shift, h)
  return [forms#color#util#ConvertHSV2RGB(hc1,s,v), forms#color#util#ConvertHSV2RGB(hc2,s,v)]
endfunction

" ------------------------------------------------------------ 
" TriadicRGBusingHSV: {{{2
"  Returns HSV triadic values 
"  (+120,-120) of pair of RGB Float triplet
"  parameters:
"    rn  : red Number
"    gn  : green Number
"    bn  : blue Number
" ------------------------------------------------------------ 
function! forms#color#util#TriadicRGBusingHSV(rn, gn, bn) 
  let hsl = forms#color#util#ConvertRGB2HSV(a:rn, a:gn, a:bn)
  let h = hsl[0]
  let s = hsl[1]
  let v = hsl[2]
  let third = 120.0/360
  let hc2 = forms#color#util#ShiftHue(-third, h)
  let hc1 = forms#color#util#ShiftHue(+third, h)
  return [forms#color#util#ConvertHSV2RGB(hc1,s,v), forms#color#util#ConvertHSV2RGB(hc2,s,v)]
endfunction

" ------------------------------------------------------------ 
" DoubleContrastRGBusingHSV: {{{2
"  Returns RGB triple of values.
"  (for example: -30,180,180-30) of triplets of RGB Float triplet
"  parameters:
"    shift  : Float how much to shift hue and compliment.
"               Should be from 0.0 to 0.5
"    rn     : red Number
"    gn     : green Number
"    bn     : blue Number
" ------------------------------------------------------------ 
function! forms#color#util#DoubleContrastRGBusingHSV(shift, rn, gn, bn) 
  let hsl = forms#color#util#ConvertRGB2HSV(a:rn, a:gn, a:bn)
  let h = hsl[0]
  let s = hsl[1]
  let v = hsl[2]
  let minus = -a:shift
  let minusHue = forms#color#util#ShiftHue(minus, h)
  let half = 180.0/360
  let halfHue = forms#color#util#ShiftHue(half, h)
  let halfminus = half - a:shift
  let halfminusHue = forms#color#util#ShiftHue(halfminus, h)
  return [
          \ forms#color#util#ConvertHSV2RGB(minusHue,s,v), 
          \ forms#color#util#ConvertHSV2RGB(halfHue,s,v), 
          \ forms#color#util#ConvertHSV2RGB(halfminusHue,s,v)]
endfunction

" ================
"  Modelines: {{{1
" ================
" vim: ts=4 fdm=marker
