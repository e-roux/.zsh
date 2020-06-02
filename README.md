# ZSH

## Startup

 There are five startup files that zsh will read commands from:

`$ZDOTDIR/.zshenv`
`$ZDOTDIR/.zprofile
`$ZDOTDIR/.zshrc
`$ZDOTDIR/.zlogin
`$ZDOTDIR/.zlogout

 If ZDOTDIR is not set, then the value of HOME is used; this is the usual case. See http://zsh.sourceforge.net/Intro/intro_3.html

## Completion

See https://github.com/zsh-users/zsh-completions/blob/master/zsh-completions-howto.org

Completion widgets are defined by the -C option to the zle builtin command provided by the zsh/zle module

Old system: `compctl` replaced by [`compinit`](http://zsh.sourceforge.net/Doc/Release/Completion-System.html). 
