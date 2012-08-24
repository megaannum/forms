# Action

The Action Object is not a Glyph. It is a clone of the Self Object
prototype:

    let g:forms#Action = self#LoadObjectPrototype().clone('forms#Action')

with 1) an additional attribute 'execute':

    function! ActionNoOp(...) dict
    endfunction
    let g:forms#Action.__execute = function("ActionNoOp")

which is of type FuncRef and default value, 'ActionNoOp', is a function
that does nothing and 2) an additional method, 'execute', that calls
the 'execute' attribute FuncRef:

    function! g:forms#Action.execute(...) dict
        call call(self.__execute, a:000, self)
    endfunction

The 'execute' method takes an unspecified number or arguments.
The Action constructor function is given by:

    function! forms#newAction(attrs)
        return forms#loadActionPrototype().clone().init(a:attrs)
    endfunction

To create a clone of this Action Object one would do the following:

    function! MyActionFunc(...) dict
        " application specific code goes here
    endfunction

    let my_action = forms#newAction({'execute': function("MyActionFunc")})

The code within the Action's execute function commonly does one of the
following:

* Put Event in Input Queue
* Create and run new Sub-Form
* Wiring data/actions between Glyphs

## Put Event in Input Queue

A 'close'/'cancel' or 'accept'/'submit' Buttons result in the current Form
returning to the code that originally launched it. It is the Actions associated
with those Buttons that hold the code that causes the Form to return.
The Action's code prepend an Event to the Input Queue. In the case of
a 'close'/'cancel' Button, it is a 'Cancel' Event that is added to the queue.
While for 'accept'/'submit' Buttons it is a 'Submit'

Because the Events 'Cancel' and 'Submit' are common use cases, there are
Actions that implement the behavior. For the 'Cancel' Event there is:

    function! FormsCancelAction(...) dict
        call forms#AppendInput({ 'type': 'Cancel' })
    endfunction

    let g:forms#cancelAction = forms#newAction({ 'execute': function("FormsCancelAction")})

and for the 'Submit' Event there is:

    function! FormsSubmitAction(...) dict
        call forms#AppendInput({ 'type': 'Submit' })
    endfunction

    let g:forms#submitAction = forms#newAction({ 'execute': function("FormsSubmitAction")})

Any Button that wants such an Action can just use these pre-defined ones:

    let cancellabel = forms#newLabel({ 'text': 'Close'})
    let cancelbutton = forms#newButton({
        \ 'body': cancellabel, 
        \ 'action': g:forms#cancelAction})

When the 'cancelbutton' is pressed, the 'Cancel' Event is placed at the
front of the Input Queue. When the current Viewer gets the next Event
(or input character from getchar()) to process, the 'Cancel' Event
is returned and the Form containing the Viewer exits returning control 
either to the parent Form or the code that launched the top-most Form.

## Create and run new Sub-Form

Another common case is for a Button when pressed to launch a sub-Form.
That is how a MenuBar launches a Menu, a Menu launches a sub-Menu, and,
in general, how an active Form would launch a sub-Form:

    function! LaunchSubFormFunc(...) dict
        " code to create Form's body
        let body = ...
        let form = forms#newFrom({'body', body})
        call form.run()
    endfunction
    let subformAction  = forms#newAction({ 'execute': function("LaunchSubFormFunc")})

    let subformlabel = forms#newLabel({ 'text': 'Make Sub-Form'})
    let subformbutton = forms#newButton({
        \ 'body': subformlabel, 
        \ 'action': subformAction})

Here, when the 'subformbutton' is selected (with a mouse 'Select' Event or
a keyboard &ltCR>/&ltSpace>), the 'LaunchSubFormFunc' is called
and a new sub-Form is run. When the sub-Form stops running, exits its 'run()'
method, control is returned to the 'LaunchSubFormFunc' function, which in 
this case, simply exits and control is returned to the Form/Viewer that
originally passed the 'Select' Event (or keyboard &ltCR>/&ltSpace>) to the Button.

The Event/Action model is pretty simple to follow.

## Wiring data/actions between Glyphs

The last example of a common Action use case is the linking of two interactive
Glyphs. Consider a HSlider and a FixedLengthField editor. If the HSlider is
moved we want the editor to reflect the HSlider's value and if a new value
is entered into the editor we want the HSlider to jump to that new value.
Of course, when we say value, we mean a Number in the range supported by
the HSlider and the editor must be sized so that it can display the largest
value in the HSlider's range. It is also important that since the HSlider's
value is aways a Number, that the text entered into the editor is converted
to a Number.

First we define the Functions that will be used as Action 'execute'
attributes:

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

Now create Actions for these two Functions:

    let slideraction = forms#newAction({'execute': function("SliderActionFunc")})
    let editoraction = forms#newAction({'execute': function("EditorActionFunc")})


The HSlider is created passing in the 'slideraction' Action as 
the 'on_move_action' attribute value:

    let attrs = {
              \ 'size' : 32,
              \ 'tag' : 'hslider',
              \ 'resolution' : 4,
              \ 'on_move_action' : slideraction,
              \ 'range' : [0,255]
              \ }
    let hslider = forms#newHSlider(attrs)

and the FixedLengthField editor is created passing in the 'editoraction'
Action as the 'on_selection_action' attribute value:

    let editor = forms#newFixedLengthField({
                                    \ 'size': 3,
                                    \ 'tag' : 'editor',
                                    \ 'on_selection_action' : editoraction,
                                    \ 'init_text': '0'})

Now, one more thing must be done, the 'editoraction' Action must be given
the HSlider as an attribute and the 'slideraction' must be given the
editor as an attribute:

    let slideraction.editor = editor
    let editoraction.hslider = hslider

Now the FixedLengthField editor and HSlider are wired together.

One cautionary note, it is important when wiring together two or more
interactive components that the act of setting the value in one component
does not trigger it to set the value in the originating component; you
will quickly run out of stack space.

