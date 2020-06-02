# export WORKON_DIR=/opt/venvs
export BAT_PAGER='less'
export BAT_STYLE='grid,changes'
export BAT_THEME='Monokai Extended Light'


export SPACESHIP_VI_MODE_PREFIX=""
# export SPACESHIP_VI_MODE_SUFFIX=
export SPACESHIP_VI_MODE_INSERT="❯"
export SPACESHIP_VI_MODE_NORMAL="❮"
export SPACESHIP_VI_MODE_COLOR="green"

export EDITOR=vim
# https://golang.org/cmd/go/#hdr-Environment_variables
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PAGER=bat

export TERM=xterm-256color

export PYENV_ROOT=$HOME/.opt/pyenv
export PATH=$GOBIN:$PYENV_ROOT/bin:$HOME/.local/bin:$PATH
export ZDOTDIR=$HOME/.zsh
