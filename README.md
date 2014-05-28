# forms

Vim Forms TUI framework

# Introduction

Forms is a Vim TUI (Text User Interface) library. It allows for the creation
and display of text-based forms in both console Vim and GVim. Many of the
standard GUI widget types are supported by Forms such as labels, buttons,
menus and layout constructs. It supports navigation, selection and input with 
a keyboard, as well as, navigation and selection with a mouse.

A user can always stop a form with no side effects by entering <Esc>.
This is basically a "panic button"; the user wants out.
If the user is a couple of sub-forms deep in a presentation, each <Esc> 
entered pops the user out of the current form only.
Developers should be aware that a user might not take any of the actions
offered by a form and simply enter <Esc>. Such user action, <Esc>  
to exit Forms, should NOT be prevented by a forms developer.

The behavior of a form created with the Forms library differs from that of a
GUI form. Generally, a GUI form can be displayed and moved about anywhere on
the screen. On the other hand, a TUI form has to reside within the Vim/GVim
window; it can not be moved outside of the text area. In addition, when a form
is being displayed, it captures all user input, keyboard and mouse in that
window, so that there is no access to the underlying text until the form is
closed. In that sense, all Forms forms are like modal GUI forms.

Because a form must fit within a text window, it is sometimes the case that
the form's height and/or width is greater than that of the hosting window.
Form developer should be aware of this and strive to make their forms
smaller than expected window sizes. One approach is to break a large form
into a number of sub-forms.
In case a form is too big, an information form is displayed to the user
stating that fact along with a suggested size to enlarge the window to
so that the form will fit. If the window is too small even to display
the information form, an error message is output (via a thrown exception).

Why create Forms? I was working on a Scala project and wanted to use
Envim, a Vim plugin that allows one to run an ENSIME (Scala IDE support) 
process as a backend.
After using Envim a little, learning its code base, extending it and
offering the extensions to it author, I wondered how I might integrate
ENSIME's refactoring capabilities with Vim/Envim. If one had only a
couple of such capabilities, then make a unique key mapping per capability
might be an option. But, once one get 10 to 15 such refactoring capabilities,
10 to 15 key maps is rather less attractive. Whats more, some refactoring
operations takes one or more input parameters. So, my solution, was to
use or create a Vim forms library. Searching the Vim site I found nothing
that approached what I could call a forms library, so I built one.
Now, after I get this released, I will go back to Envim and add refactoring
capabilities. Then, I will go back to may original Scala project.

# Installation

## Download

A zip snapshot of the Forms library can be downloaded 
from 

    http://www.vim.org/scripts/script.php?script_id=4150

In your Vim home, normally $HOME/.vim in Unix, unzip/untar the file:

    # cd $HOME/.vim
    # unzip forms.zip

On a Windows system, vim home is normally $HOME/vimfiles.

    TODO how to unpack on Windows?

Forms is also available via git: 

    http://github.com/megaannum/forms

One can download a release from github and extract content.

If as a developer, one wants fixes as they appear, one can clone the 
github Forms repository and, as updates appear, copy the files
over to you Vim home location.

Vim has a number of third-party plugin managers. If you are using one
you can configure it to automatically download and install Forms.

## Dependency

Forms depends upon the Self Libaray, a prototype-based object system:
[VIM](http://www.vim.org/scripts/script.php?script_id=3072)
or 
[GitHup]( https://github.com/megaannum/self)

## Directory layout

After unpacking the Forms directory layout should look like:

    $HOME/.vim/
      autoload/
        forms.vim
        forms/
          menu.vim
          dialog/...
          examples/...
      doc/forms.vim
      plugin/forms.vim
      tutorial/forms/...

If a plugin manager is used, files/directories will be wherever the
plugin manager is configured to install things.

Here the autoload directory contains the basic Forms code in forms.vim
as well as a forms sub-directory. The forms sub-directory contains
the file menu.vim which has he the TUI menu and popup code that parallels 
the GVim menu and popup capability. In addition, there is is the dialog
sub-directory that contains dialogs forms used both by the menu/popup code
and the demonstration form. In the examples sub-directory is the
demonstration form and various example dialog forms.

The doc directory contains this documentation txt file forms.txt.

The plugin directory contains a forms.vim file that contains mapping
for launching the demonstration form as well as the menu and popup
forms.

## Intalling with vim-addon-manager (VAM)

For more information about vim-addon-manager, see [vim-addon-manager](https://github.com/MarcWeber/vim-addon-manager) and [Vim-addon-manager getting started](https://github.com/MarcWeber/vim-addon-manager/blob/master/doc/vim-addon-manager-getting-started.txt)

In your .vimrc, add self as shown below:

    fun SetupVAM()

      ...

      let g:vim_addon_manager = {}
      let g:vim_addon_manager.plugin_sources = {}

      ....

      let g:vim_addon_manager.plugin_sources['self'] = {'type': 'git', 'url': 'git://github.com/megaannum/self'}
      let g:vim_addon_manager.plugin_sources['forms'] = {'type': 'git', 'url': 'git://github.com/megaannum/forms'}


      let plugins = [
        \ 'self',
        \ 'forms'
        \ ]

      call vam#ActivateAddons(plugins,{'auto_install' : 0})

      ...

    endf
    call SetupVAM()


Now start Vim. You will be asked by vim-addon-manager 
if you would like to download and install the self plugin (no dependencies).

## Installing with pathogen

I do not use pathogen. An example usage would be welcome.

# Usage

The Forms library is just that, a library. One uses it to create and
enhance Vim scripts. That said, there are some demonstration examples.

Strictly speaking, the Forms library is a library and, so, there ought not
be any mappings. But, while developing Forms a number of examples were
created which, it turns out, were critical for uncovering bugs, missing
features in the implementation and usage issues. Two of the examples
might have general appeal, the menu and popup forms that mirror the
capability (and copy some of the support code of) the GVim menu and popup.
While power users will disdain the Forms menu and popup examples
as superfluous, covering Vim commands that are know by heart, so to
power users disdain the GVim menu/popup - so, the power user is not
the target user.  Rather, the same users that find the GVim menu/popup
useful will find the Forms menu/popup equally useful.
Here are the mappings for the menu and popup:

    nmap <Leader>m :call forms#menu#MakeMenu('n')<CR>
    vmap <Leader>m :call forms#menu#MakeMenu('v')<CR>
    nmap <Leader>p :call forms#menu#MakePopUp('n')<CR>
    vmap <Leader>p :call forms#menu#MakePopUp('v')<CR>

It should be noted that there are normal and visual mode mappings. 
That is because some capabilities of the menu/popup are enabled/disabled
depending upon mode, as well as, which command to ultimately execute
may depend upon mode.

There is also a mapping which launches a form that links to some 40 Forms
demonstration forms. The demonstration forms range from a simple box
drawing example to a file browser and color chooser:

    nmap <Leader>d :call forms#example#demo#Make()<CR>

If any of the demonstration forms do not display or function as one might
expect on your platform, then drop me a line - thanks.

One will observe that these mappings use the characters: 'm' 'p' and 'd'.
While the demo mapping can/should ultimately be commented out by
all but Forms developers, at least for the non-power user, having
a short, easy to remember, mnemonic mapping for menu and popup is certainly 
reasonable.

Also, there is the function 'forms#example#demo#MakeTest()' which displays
each of the demonstrations for 5 seconds using:

    :call forms#example#demo#MakeTest()

While this does not exercise any of the interactive demo; it simply renders
each in turn, it is good to see if anything causes error messages or
does not display at all. Its the beginning (maybe) of a more complete
Event driven tests. 

One can also, choose a 'light' or 'dark' colorscheme prior to running
the tests, just to see the differences.

# Supported Platforms

The Forms library ought to work on any platform where Vim has 256 colors
(or full RGB as with GVim) and a fixed width UTF-8 font which implements
the box drawing and block characters in a reasonable manner.

## Linux Vim
### Xterm

Forms was developed and extensively tested on a Linux Xterm platform.
As long as the Xterm is using the correct font, such as 

    -misc-fixed-medium-r-normal-*-20-*-*-*-*-*-iso10646-*

For console-base Vim running in an Xterm, the font used by Vim is the font
used by the Xterm. Running on my Linux systems I found the following
works to launch an Xterm appropriately configured:

    /usr/bin/xterm -g 80x30 -bg lightgrey -sl 1000 +si -fn \
       '-misc-fixed-medium-r-normal-*-20-*-*-*-*-*-iso10646-*'

If with say, the font 10x20, then you may not be able to render all of
the unicode characters, but it ought to still work.

There is support for 256, 88, 16 and 8 color Xterms though
the 256 looks best. In your .vimrc file add one of:

    if ($TERM == 'xterm')
        let &t_Co=256
    endif

or

    if ($TERM == 'xterm')
        let &t_Co=88
    endif

or

    if ($TERM == 'xterm')
        let &t_Co=16
    endif

or

    if ($TERM == 'xterm')
        let &t_Co=8
    endif

if you need help in getting the correct number of colors in Vim.


### urxvt256c

Forms simply works on the version of rxvt that supports Unicode and 256
colors, urxvt256c. 
Vim knows that  &t_Co == 256.

### urxvt

Forms works with 88 color verion of rxvt that supports Unicode, urxvt.
Vim knows that  &t_Co == 88.

### rxvt

Forms works with non-Unicode, 8 color rxvt.
Vim knows that  &t_Co == 8.

### Konsole

Forms works kconsole (though kconsole's UTF-8 9608 2588 FULL BLOCK
does not render correctly).
Add to .vimrc file:

    let &t_Co=256
    let g:FORMS_COLOR_TERM_KONSOLE = 1

### Eterm

Forms works eterm (well, I hope it works, no access to ETerm so could not test).
Add to .vimrc file:

    let &t_Co=256
    let g:FORMS_COLOR_TERM_ETERM = 1

### GVim

Some testing has been done on the Linux GVim platform and all of the
demonstration forms seem to work as expected.

## Mac GVim

No testing has been done on the Mac GVim configure. Feedback is welcome.

## Windows GVim

No testing has been done on the Windows GVim configure. Feedback is welcome.

## Vim

[Vim location](http://www.vim.org/scripts/script.php?script_id=4150)

## Tutorial

There is a Forms tutorial which can be accessed at [Forms tutorial](https://github.com/megaannum/forms/blob/master/tutorial/forms/Tutorial.md).

## Related works

[VFT - VIM Form Toolkit](http://www.vim.org/scripts/script.php?script_id=2160)
[Vimform : Simple text-based forms for vim](http://www.vim.org/scripts/script.php?script_id=3051)

## Acknowledgements and thanks

- Marc Weber: Initial release feedback identifying Vim 7.3 bug and
  let me debug it on one of his test machines.
- Andy Wokula: Feedback on help file syntax and GVim when font is latin1.
- Christian Brabandt: Feedback Slider+FieldEditor bugs and ergonomics, 
  FileBrowser filenames with embedded spaces, etc, and, of course,
  <S-Tab> does not work.
