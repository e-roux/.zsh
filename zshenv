# export WORKON_DIR=/opt/venvs
export PAGER=bat
export BAT_PAGER='less'
export BAT_STYLE='changes'
export BAT_THEME='Monokai Extended Light'


export SPACESHIP_VI_MODE_PREFIX=""
# export SPACESHIP_VI_MODE_SUFFIX=
export SPACESHIP_VI_MODE_INSERT="❯"
export SPACESHIP_VI_MODE_NORMAL="❮"
export SPACESHIP_VI_MODE_COLOR="green"

export EDITOR='vim'
export GIT_EDITOR='vim'
export SHELL='/bin/zsh'
# https://golang.org/cmd/go/#hdr-Environment_variables
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin

export TERM=xterm-256color

# Make Vi mode transitions faster (KEYTIMEOUT is in hundredths of a second)
export KEYTIMEOUT=1

export PYENV_ROOT=$HOME/.opt/pyenv
export PATH=$GOBIN:$PYENV_ROOT/bin:$HOME/.poetry/bin:$HOME/.local/bin:$PATH
export ZDOTDIR=$HOME/.zsh

