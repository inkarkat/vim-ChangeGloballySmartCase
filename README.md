CHANGE GLOBALLY SMART CASE   
===============================================================================
_by Ingo Karkat_

DESCRIPTION
------------------------------------------------------------------------------

As an add-on to the ChangeGlobally.vim plugin ([vimscript #4321](http://www.vim.org/scripts/script.php?script_id=4321)), this plugin
implements a gC variant that uses a "smart case" substitution which covers
variations in upper-/lowercase ("maxSize" vs. "MaxSize") as well as different
coding styles like CamelCase and underscore\_notation ("maxSize", "MAX\_SIZE").

The gC command works just like built-in c, and after leaving insert mode
applies the local substitution to all other occurrences (according to the
SmartCase-rules) in the current line (in case of a small character change)
or, when entire line(s) where changed, to the rest of the buffer.
This is especially useful for variable renamings and all the other small
tactical edits that you're doing frequently. It is much faster than doing a
single change and repeating it, or building a :substitute command,
especially since you would have to repeat that for all text variants that
SmartCase covers.

USAGE
------------------------------------------------------------------------------

    [N]["x]gC{motion}       Like gc, but also substitute close textual variants
    {Visual}[N]["x]gC       of the changed text according to the SmartCase-rules:
                            - variations in upper-/lowercase
                              ("maxSize" vs. "MaxSize")
                            - different coding styles like CamelCase and
                              underscore_notation ("maxSize", "MAX_SIZE")

    ["x]gCC                 Like gcc, but with SmartCase-rules. It's probably
                            less useful than gC, but added for completeness.

    [N]["x]gX{motion}       Like gx, but also substitute close textual variants
    {Visual}[N]["x]gX       of the changed text according to the SmartCase-rules:
    ["x]gXX                 Like gxx, but with SmartCase-rules.

### EXAMPLE

Suppose you have a line like this, and you want to rename the type from
"NodeList" to "FooBarSet", and adapt the variable name, too:
```
function set nodeList(nodeList:NodeList):void; // Update node list.
```

With the cursor on the start of any of the "nodeList", type gCe, enter the
text "fooBarSet", then press <Esc>. The line will turn into
```
function set fooBarSet(fooBarSet:FooBarSet):void; // Update foo bar set.
```
You can now re-apply this substitution to other lines or a visual selection
via .

INSTALLATION
------------------------------------------------------------------------------

The code is hosted in a Git repo at
    https://github.com/inkarkat/vim-ChangeGloballySmartCase
You can use your favorite plugin manager, or "git clone" into a directory used
for Vim packages. Releases are on the "stable" branch, the latest unstable
development snapshot on "master".

This script is also packaged as a vimball. If you have the "gunzip"
decompressor in your PATH, simply edit the \*.vmb.gz package in Vim; otherwise,
decompress the archive first, e.g. using WinZip. Inside Vim, install by
sourcing the vimball or via the :UseVimball command.

    vim ChangeGloballySmartCase*.vmb.gz
    :so %

To uninstall, use the :RmVimball command.

### DEPENDENCIES

- Requires Vim 7.0 or higher.
- Requires the ingo-library.vim plugin ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)), version 1.021 or
  higher.
- ChangeGlobally.vim ([vimscript #4321](http://www.vim.org/scripts/script.php?script_id=4321)) plugin (version 1.30 or higher)
- SmartCase.vim ([vimscript #1359](http://www.vim.org/scripts/script.php?script_id=1359))
- repeat.vim ([vimscript #2136](http://www.vim.org/scripts/script.php?script_id=2136)) plugin (optional)
- visualrepeat.vim ([vimscript #3848](http://www.vim.org/scripts/script.php?script_id=3848)) plugin (version 2.00 or higher; optional)

CONFIGURATION
------------------------------------------------------------------------------

For a permanent configuration, put the following commands into your vimrc:

If you want to use different mappings, map your keys to the
<Plug>(ChangeGloballySmartCase...) and <Plug>(DeleteGloballySmartCase...)
mapping targets _before_ sourcing the script (e.g. in your vimrc):

    nmap <Leader>C <Plug>(ChangeGloballySmartCaseOperator)
    nmap <Leader>CC <Plug>(ChangeGloballySmartCaseLine)
    xmap <Leader>C <Plug>(ChangeGloballySmartCaseVisual)
    nmap <Leader>X <Plug>(DeleteGloballySmartCaseOperator)
    nmap <Leader>XX <Plug>(DeleteGloballySmartCaseLine)
    xmap <Leader>X <Plug>(DeleteGloballySmartCaseVisual)

CONTRIBUTING
------------------------------------------------------------------------------

Report any bugs, send patches, or suggest features via the issue tracker at
https://github.com/inkarkat/vim-ChangeGloballySmartCase/issues or email
(address below).

HISTORY
------------------------------------------------------------------------------

##### 1.30    12-Dec-2014
- Adapt to interface changes of ChangeGlobally.vim version 1.30
- ENH: Implement global delete (gX{motion}, gXX) as a specialization of an
  empty change.
  __You need to update to ingo-library ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)) version 1.021 and
  to ChangeGlobally.vim ([vimscript #4321](http://www.vim.org/scripts/script.php?script_id=4321)) version 1.30!__

##### 1.20    19-Nov-2013
- Adapt to interface changes of ChangeGlobally.vim version 1.20
- Use optional visualrepeat#reapply#VisualMode() for normal mode repeat of a
  visual mapping. When supplying a [count] on such repeat of a previous
  linewise selection, now [count] number of lines instead of [count] times the
  original selection is used.

##### 1.00    23-Nov-2012
- First published version.

##### 0.01    25-Sep-2012
- Started development.

------------------------------------------------------------------------------
Copyright: (C) 2012-2018 Ingo Karkat -
The [VIM LICENSE](http://vimdoc.sourceforge.net/htmldoc/uganda.html#license) applies to this plugin.

Maintainer:     Ingo Karkat <ingo@karkat.de>