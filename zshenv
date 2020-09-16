# export WORKON_DIR=/opt/venvs
export PAGER=bat
export BAT_PAGER='less'
export BAT_STYLE='changes'
export BAT_THEME='Monokai Extended Light'

export NNN_BMS="D:~/Documents;d:~/Developpement;i:~/Images;v:~/Vidéos;m:~/Musique"
export NNN_OPTS="a"
export NNN_PLUG="p:preview-tui;z:autojump"


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
[ -x "$(which vivid)" ] && \
  export LS_COLORS=$(vivid generate solarized-light)
# Make Vi mode transitions faster (KEYTIMEOUT is in hundredths of a second)
export KEYTIMEOUT=1

export PYENV_ROOT=$HOME/.opt/pyenv
export PATH=$GOBIN:$PYENV_ROOT/bin:$HOME/.poetry/bin:$HOME/.cargo/bin:$HOME/.local/bin:$PATH
export ZDOTDIR=$HOME/.zsh

export PYENV_VIRTUALENV_DISABLE_PROMPT=1
