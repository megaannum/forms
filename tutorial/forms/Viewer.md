# Viewer

A Viewer is a Mono Glyph. Its primary purpose is to handle keyboard and
mouse events. It does this in its 'run()' method.

At the top of the Viewer 'run()' method its child tree of Glyphs is
walked and a list is formed of Glyphs that can accept focus and the
first Glyph in that list is the Glyph that currently has focus.

Also, the Viewer is pushed onto the Forms' Viewer Stack. Some events
are handled differently if the Viewer is the only Viewer in the
Stack or not. Also, when a &ltLeftMouse> click occurs outside of the
current Viewer, but still within the boundaries of the Form, then
Viewers are popped off the Viewer Stack until a Viewer is found
that contains the line/column position of the mouse click and it
becomes the active Viewer.

The Viewer Event Loop reads events from the global event Input Queue.
The Function to get the next event is shown below:

    function! forms#GetInput()
      return empty(s:inputlist) ? getchar() : remove(s:inputlist, 0)
    endfunction

If the 's:inputlist' is empty, then the Viewer waits until a character
is ready to be returned by the Vim Function 'getchar()'. If the
's:inputlist' is not empty, the first event is remove from it and
returned.

The Viewer Event Loop determines what to do with the Event based
upon what it is and its value. An event could be a String/Number
return by 'getchar()' or it could be a Dictionary Event which,
at minimum, has a 'type' attribute. For example, the 'Cancel' Event
has a 'type' attribute with value 'Cancel' and the 'Submit' Event
has a 'type' of 'Submit'.

The following is a list of the Event types:

* Exit
  - Action: exit current viewer, if top viewer, no results data
  - Also used as top-of-stack return value for Viewer
  - The character &ltEsc> is mapped to Exit
* Cancel 
  - Action: exit form, no results data
  - Also used as top-of-stack return value for Viewer
* Command
  - Action: exit form, no result data, and execute command
* Context 
  - Action: generate context help Form with application specific help/info
     and developer tools
  - Data: optional Point [line, column]
  - The character &ltRightMouse> is mapped to Context
* Drag
  - Action: none
  - The character &ltLeftDrag> is mapped to Drag
* Release
  - Action: none
  - The character &ltLeftRelease> is mapped to Release
* NewFocus
  - Action: find new focus based upon mouse coordinates
  - The character &ltLeftMouse> is mapped to NewFocus
  - Also, if a Viewer is the target of a Select Event, it is mapped
    to NewFocus
* NextFocus
  - Action: go to next focus
  - The characters &ltTab>, &ltC-n> and &ltDown> is mapped to NextFocus
  - The mouse &ltScrollWheelDown> event is mapped to NextFocus
* PrevFocus
  - Action: go to previous focus
  - The characters &ltS-Tab>, &ltC-p> and &ltUp> is mapped to PrevFocus
      (Note: could not test S-Tab on my system.)
  - The mouse &ltScrollWheelUp> event is mapped to PrevFocus
* FirstFocus
  - Action: go to first focus glyph
  - The character &ltHome> is mapped to FirstFocus
* LastFocus
  - Action: go to last focus glyph
  - The character &ltEnd> is mapped to LastFocus
* ReDraw
  - Action: redraw Form in window
* ReDrawAll
  - Action: redraw complete form 
* ReFocus
  - Action: View creates a list of glyphs that can get focus
    this event tells viewer to regenerate that list
* ReSize
  - Action: Form does a requestedSize call on its body because a child has
    changed size or gone from invisible to visible
* Select 
  - Action: change focus and possibly glyph specific sub-selection
  - Data: Point [line, column]
* SelectDouble
  - Action: a left mouse double click occured
  - Data: Point [line, column]
  - The mouse &lt2-LeftMouse> event is mapped to SelectDouble
* Sleep
  - Action: Viewer Event handling sleeps for given time.
  - Data: time: Number (e.g., 10) or String (Number+'m' e.g., 200m)
  - Used for visual testing
* Submit
  - Action: exit form with result data
  - Data: results from form
  - Also used as top-of-stack return value for Viewer

Special Key Types

* Down
  - Produced by down key and viewer maps ScrollWheelDown to Down
* Up
  - Produced by up key and viewer maps ScrollWheelUp to Up
* Left  S-Left  C-Left
* Right S-Right C-Right 
* ScrollWheelDown S-ScrollWheelDown C-ScrollWheelDown 
* ScrollWheelUp S-ScrollWheelUp C-ScrollWheelUp 
* Space
  - Mapped to Select
* CR
  - Mapped to Select
* Del
  - Generally, erase character in editor
* BS 
  - Generally, move over character in editor


When the Event Loop exits, the Viewer is popped of the Viewer Stack
and the 'run()' method returns.


It is possible to have a Viewer none of whose descendant Glyphs can
accept focus. In that case, its is a display-only Viewer and the
only thing a user can do is enter &ltEsc> to exit the Viewer or
enter &ltCtrl-H> which will provide context-sensitive-help.
