# Making Bash a Little Better

## What is Readline?

Readline, at its core, is a text processor. It does *not* execute the commands you enter, but it *does* process the text that makes up the command before passing it to the actual command executor. So I suppose you could look at it like a CLI word processor. There is even a Vi mode and EMACS mode that use familiar keyboard shortcuts for navigation and actions.

## What Can Readline Do for Me?

Readline makes it easier to work with complex interactions on the command line. Presentaition, layout, and color are always at the top of my list to fix. There are also navigation options for current commands, searching, and history. Editing is a big deal for those who spend a lot of time with complex commands. These settings have quite a few ways they can be configured. Of course Readline also supports the two mega modes: macros and arguments! There is a lot here, so let's get into the weeds! 

### References
Firstly, read the [man pages](https://www.man7.org/linux/man-pages/man3/readline.3.html)  
Secondly, peruse the [readline library](https://tiswww.case.edu/php/chet/readline/rltop.html)  

### Interesting Items

Not an exaustive list, just the options that I like to play with. Default values are in shown italics.

| parameter | value | description |
| --- | --- | --- |
| colored-stats | (on\|*off*) | tab completion colorized according to file type |
| completion-display-width | (int\|*-1*) | columns to show for tab completion display |
| completion-ignore-case | (on\|*off*) | case sensitive tab completeion toggle |
| completion-map-case | (on\|*off*) | tab completion treats hypen and underscore equivalency |
| completion-prefix-display-length | (int\|*0*) | use elipses to denote matching prefixes longer than *int* |
| completion-query-items | (int\|*100*) | if possible matches exceed *int*, ask to display all |
| editing-mode | (*emacs*\|vi) | which set of key bindings to use |
| enable-keypad | (on\|*off*) | enable or disable the keypad |
| enable-meta-key | (*on*\|off) | enable meta key for 8-bit input |
| expand-tilde | (on\|*Off*) | expand tilde on tab completion |
| keyseq-timeout | (int\|*500*) | wait for more input in miliseconds before displaying results |
| mark-directories | (*On*\|off) | append slash to denote directories |
| match-hidden-files | (*On*\|off) | match dot files |
| page-completions | (*On*\|off) | use pager for completion choices |
| print-completions-horizontally | (*Off*\| on) | |
| show-all-if-ambiguous | (*Off*\|on) | show completions rather than ringing bell |
| show-all-if-unmodified | (*Off*\|on) | show completions rather than ringing bell if completions do not have a common prefix |
| show-mode-in-prompt | (*Off*\|on) | If you like the mode to display |
| visible-stats | (*Off*\|on) | Displays file type in completion suggestions |

## How Do I Get Started?

The good news is that if you are running Linux, you are already started. All you will have to do now is make sure the desired settings are put in the correct files, then start a new shell to test it out.

### Configurations

Readline is configured like anything else in Linux - with a **conf** file. This one is located at `/etc/inputrc` and can contain any of the options above plus many more. The basic syntax for setting an option looks like this:

```
set colored-stats off
set mark-directories on
```

### Testing Mode

What if you only want to try something out for a moment, then undo the change? Try setting something right from the CLI you are using! The setting will take immediate effect and it you don't like it, unset it or close that shell out to erase the setting. 

To set an option:
```
bind "set colored-stats on"
```
To remove that option:
```
bind -r "set colored-stats on"
```
To just set the inverse for that option:
```
bind "set colored-stats off"
```

# Finally

Of course I won't leave you without examples, so feel free to check out my readline configuration file [here](inputrc)
