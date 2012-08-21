# Command

## Basics

Some interactive Glyphs can take either an Action or a Command.
A Command is a String that is executed on the command line.
Since the command line is not available while running a Forms Form, 
when the Forms run-time system encounters a command, control is 
passed up to the top-level Viewer which, in fact, is also the top-level
Form and, as part of this Form exiting its 'run()' method, the
command String is executed.

A Glyph that can have a Command has a 'command' attribute. Generally, such
a Glyph at any one time can support either an Action or a Command; never
both at the same time. When such a Glyph has an Action and the Glyph is
selected, the Action executes and control is returned to the calling 
Viewer. However, as described above, with a Command, the flow is different.
The Glyph places a 'Command' Event at the front of the Input Queue and
the Viewer then gets the next Event, sees that its a 'Command' Event and,
if its not the top-level Viewer, it places the 'Command' Event back on
the front of the Input Queue and the Viewer exits returning control
to the next higher Viewer. This stops at the top-level Viewer (which 
is actually a Form - remember a Form is a sub-type of Viewer) and
it is this top-level Viewer/Form that extracts the command String
from the 'Command' Event and executes it.

## Simple Command-line

The following is a Button which, when selected, cause Vim so save the
buffers it was working on and exit.

    let label = forms#newLabel({'text': 'Save-Exit'})
    let attrs = { 'body': label,
                \ 'command': ':wqa'
                \ }
    let button = forms#newButton(attrs)

## Call Function

The following is adapted from the menu.vim example code. Here, a Button
when selected will launch Forms' FileBrowser dialog (which will be a 
sub-Form) and, it the FileBrowser returns a filename, then the 'e', edit, 
command is executed giving the command that filename.

    function! BrowserAction(title, cmd)
      " call Forms' FileBrowser dialog
      let f = forms#dialog#filebrowser#Make(a:title)
      if f != ''
        execute ':'.a:cmd." ".f
      endif
    endfunction

    let label = forms#newLabel({'text': 'Edit File'})
    let attrs = { 'body': label,
                \ 'command': ":call BrowserAction('Edit File', 'e')"
                \ }
    let button = forms#newButton(attrs)

Using techniques like these, all of the GVim MenuBar and Popup Menu 
have been duplicated with the Forms library.

