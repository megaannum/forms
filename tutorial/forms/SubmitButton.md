# Submit Button

A 'Submit' Event tells the Form to gather up all of the Glyph tag/value
pairs in a Dictionary and return the Dictionary. For most dialog
like Forms, there will be a 'cancel' or 'close' (or some similar name) 
Button. For those
Forms that wish to give the user the option of entering information
and then having the code that created and launched the Form to
get that information, there will also be an 'accept' or 'submit'
Button. A developer is, of course, free to have their Form directly
set (and get) values from VimL variables defined outside of the
scope of the Form, but that will lead to a tight binding between
the code exterior to the Form and code that makes up the Form.
This would make the Form more brittle and increase potential errors
reducing reuse (IMO).

A Submit Button is created by making a Button where its action is
the Forms Submit Action:

    let label = forms#newLabel({'text': "Submit"})
    let button = forms#newButton({
                             \ 'tag': 'submit',
                             \ 'body': label,
                             \ 'action': g:forms#submitAction})

In this case, the Button's 'tag' is called 'submit'.

The above Action is a global defined in the Forms code as:

    function! FormsSubmitAction(...) dict
        call forms#AppendInput({ 'type': 'Submit' })
    endfunction

    let g:forms#submitAction = forms#newAction({ 'execute': function("FormsSubmitAction")})

One can see that the Action's 'execute' attribute is the Function
'FormsSubmitAction' which adds a 'Submit' Event to the front of
the Forms Input Queue.

In this example, let us have two CheckBoxes:

    let cb1 = forms#newCheckBox({'tag': 'cbone'})
    let cb2 = forms#newCheckBox({'tag': 'cbtwo'})

These have tags that identify them.

Also, assume that there is a 'Close' Button:

    let label = forms#newLabel({'text': "Close"})
    let button = forms#newButton({
                             \ 'tag': 'close',
                             \ 'body': label,
                             \ 'action': g:forms#cancelAction})

If the Submit Button is selected, then a 'Submit' Event is place at the
front. In the Viewer 'run()' method  there ia a loop that reads
input Events/Characters and processes them. The part of that loop
that handles a 'Submit' Event follows:

    elseif type == 'Submit'
      if forms#ViewerStackDepth() > 1
        call self.unGetChar(event)
        break
      else
        return event
      endif

Notice that if the current Viewer is not a top-level Viewer, then
the 'Submit' Event it placed back on the front of the Input Queue,
the read loop is exited and control is returned to the next higher
Viewer. This continues until the Viewer Stack is empty, one is at
the top-level Viewer, at which point the Viewer 'run()' method
returns the 'Submit' Event to the Form 'run()' method that had
originally called the Viewer's method.

The Form 'run()' method has the code that calls its ProtoType Object
'run()' method, the Viewer 'run()' method and then processes 
any returned value:

    " call Form prototype run() method
    let p = g:forms#Form._prototype
    let rval = call(p.run, [], self)

In the Form 'run()' code that handles the Viewer's 'run()' method 
returned value:

    let results = {}
    ....
    elseif rval.type == 'Submit'
      call self.generateResults(self.__body, results)
      return results

If the return value is an Event of 'type' 'Submit', that is, a 'Submit'
Event, then the 'generateResults()' method is called which directly
in turn calls the Function forms#GenerateResults():

  function! forms#GenerateResults(glyph, results)
    let nodeType = a:glyph.nodeType()
    if nodeType == g:LEAF_NODE
      call a:glyph.addResults(a:results)

    elseif nodeType == g:MONO_NODE
      call a:glyph.addResults(a:results)

      call forms#GenerateResults(a:glyph.getBody(), a:results)

    elseif nodeType == g:POLY_NODE
      call a:glyph.addResults(a:results)

      for child in a:glyph.children()
        call forms#GenerateResults(child, a:results)
      endfor

    elseif nodeType == g:GRID_NODE
      call a:glyph.addResults(a:results)

      for minor in a:glyph.major()
        for child in minor
          call forms#GenerateResults(child, a:results)
        endfor
      endfor

    else
      throw "Unknown glyph nodeType " . nodeType
    endif
  endfunction

Note that this code recursively walks the Glyph tree visiting
each child Glyph and calling each child Glyph's 'addResults()'
method. Now, the base Glyph, the Glyph Prototype Object has
a 'addResults()' that does nothing:

    function! FORMS_GLYPH_addResults(results) dict
    endfunction
    let g:forms#Glyph.addResults = function("FORMS_GLYPH_addResults")

It adds nothing to the Dictionary results object. So, while the
'GenerateResults()' walks the tree for most Glyphs in the tree, nothing
is added to the 'results' Dictionary. This is understood when on
considers that passive Glyphs such as a Label for formating/layout
Glyphs such as Mono or Poly Glyph would generally not have anything
interesting to return to the calling code. On the other hand,
Glyphs that maintain state entered by the user, do add values to the
'results' Dictionary.

In this example code, both CheckBoxes will add to the 'results'
object:

    function! FORMS_CHECKBOX_addResults(results) dict
      let tag = self.getTag()
      let a:results[tag] = self.__selected
    endfunction
    let g:forms#CheckBox.addResults = function("FORMS_CHECKBOX_addResults")

They both get their respective 'tag' as a Dictionary key and 
whether or not they have been selected as the associated value.
In addtion, the 'Submit' and 'Close' Buttons also have 'addResults()'
methods:

    function! FORMS_BUTTON_addResults(results) dict
      let tag = self.getTag()
      let a:results[tag] = self.__selected
    endfunction
    let g:forms#RadioButton.addResults = function("FORMS_BUTTON_addResults")

If the example Form only had the two CheckBoxes and the 'Submit' and
'Close' Buttons then the 'results' Dictionary might contain the following:

    { 'submit': 1, 'close': 0, 'cbone' : 0, 'cbtwo' : 0 }

The 'Submit' Button was pushed, value == 1, and neither CheckBoxes
were selected, values == 0.
If the CheckBox with tag 'cbone' was selected when the 'Submit'
Button was selected the 'results' would contain:

    { 'submit': 1, 'close': 0, 'cbone' : 1, 'cbtwo' : 0 }

If both CheckBoxes were selected:

    { 'submit': 1, 'close': 0, 'cbone' : 1, 'cbtwo' : 1 }

Importantly, the 'results' Dictionary only contains data if a
'Submit' Event occurred. A 'Cancel' event generated by the 'Close'
Button will return an empty Dictionary. So, in the above case, one 
will never encounter the following:

    { 'submit': 0, 'close': 1, 'cbone' : 0, 'cbtwo' : 0 }

Because this means that the 'Close' Button was selected, but the
'Close' Button generates a 'Cancel' Event and a 'Cancel' Event
will only return an empty Dictionary.



