# Editor and Slider

To link or wire together two interactive Glyphs it is require that when
one Glyph's value changes that change is reflected in the other Glyph.
First define actions that will be used by the Glyphs to call and
communicate their new value with the other Glyph.

    function! SliderActionFunc(...) dict
      " convert the slider Number value to String
      let value = "".a:1
      " set the editor's text with that value
      call self.editor.setText(value)
    endfunction

    function! EditorActionFunc(...) dict
      " convert editor String value to Number
      let value = a:1 + 0
      " attempt to set the slider's value
      try
        call self.hslider.setRangeValue(value)
      catch /.*/
        " handle error here: editor value out of range
      endtry
    endfunction

    let slideraction = forms#newAction({'execute': function("SliderActionFunc")})
    let editoraction = forms#newAction({'execute': function("EditorActionFunc")})

Now create the Slider. Give it a range of 0 to 255; 256 distinct values.
This requires a size of 32 when the Slider's resolution is 4.
A resolution of 4 means 8 possible positions per character cell.
It is the maximum resolution.
  
    resolution      positions per character cell
       1              1
       2              2
       3              4
       4              8

The total number of positions of the Slider is 8 * 32 == 256 (very good).

Resolutions 2, 3 and 4 are only available when using UTF-8 character
sets. With simply latin1/ASCII only resolution 1 is available.

So, the HSlider is made with:

    let attrs = {
              \ 'size' : 32,
              \ 'tag' : 'hslider',
              \ 'resolution' : 4,
              \ 'on_move_action' : slideraction,
              \ 'range' : [0,255]
              \ }
    let hslider = forms#newHSlider(attrs)

The editor must be sized to hold up to 3 characters, the width of 100 - 255:

    let editor = forms#newFixedLengthField({
                                    \ 'size': 3,
                                    \ 'tag' : 'editor',
                                    \ 'on_selection_action' : editoraction,
                                    \ 'init_text': '0'})

Now wire together the Actions with their target Glyphs:

    let slideraction.editor = editor
    let editoraction.hslider = hslider

In layout associate the editor's Label with the editor. This is done
by telling the HPoly to draw boxes around them.


    let labeleditor = forms#newLabel({'text': 'Editor'})
    let hpolyeditor = forms#newHPoly({'children': [
                            \ labeleditor,
                            \ editor
                            \ ], 
                            \ 'mode': 'light'})

The Slider and its Label will also have boxes around them:

    let labelslider = forms#newLabel({'text': 'Slider'})
    let hpolyslider = forms#newHPoly({'children': [
                            \ labelslider,
                            \ hslider
                            \ ], 
                            \ 'mode': 'light'})

Now put the editor HPoly above the Slider HPoly with a double around them
all:

    let vpoly = forms#newVPoly({'children': [
                            \ hpolyeditor,
                            \ hpolyslider
                            \ ],
                            \ 'alignment': 'C',
                            \ 'mode': 'double'})

In this example, rather than use HSpace and VSpace to separate the
components of the HPoly and VPoly, boxes are used. The Boxes have the
additional benefit of visually linking the Labels with their interactive
Glyphs.

The VPoly is now placed into the Form as its sole child Glyph, as
the value of the Form Glyph's 'body' attribute:

    let form = forms#newForm({'body': vpoly })

Then, the Form's 'run()' method is called:

    call form.run()

This code is placed into a function:

    function! forms#tutorial#editor_slider#Make()
      " label code
    endfunction

The full code for the Label can be found in: [Editor Slider](https://github.com/megaannum/forms/blob/master/autoload/forms/tutorial/editor_slider.vim)

To run the label code, source the editor_slider.vim file and then enter

    :call forms#tutorial#editor_slider#Make()

on the command line.
