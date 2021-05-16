# PYENV
export PYENV_ROOT=$HOME/.opt/pyenv
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
export PYENV_ROOT=$HOME/.opt/pyenv

# Install pkg only in virtualenv
export PIP_REQUIRE_VIRTUALENV=true

export RBENV_ROOT=$HOME/.opt/rbenv

export SHELL='/bin/zsh'
export ZDOTDIR=$HOME/.zsh

export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$HOME/.arkade/bin:$HOME/.local/bin:$GOBIN:$RBENV_ROOT/shims:$RBENV_ROOT/bin:$PYENV_ROOT/shims:$PYENV_ROOT/bin:$HOME/.cargo/bin:/opt/go/bin:$PATH
source "$HOME/.cargo/env"
# export WORKON_DIR=/opt/venvs
# https://golang.org/cmd/go/#hdr-Environment_variables
# bat can be used as a colorizing pager for man
# See https://github.com/sharkdp/bat#man
#
# Make Vi mode transitions faster (KEYTIMEOUT is in hundredths of a second)
#
# GHQ_ROOT is for testing of ghq

export BAT_PAGER='less'
export BAT_STYLE='changes'
export BAT_THEME='Monokai Extended Light'
export EDITOR='vim'
export GHQ_ROOT=$HOME/development
export GIT_EDITOR='vim'
export KEYTIMEOUT=1

command -v vivid &>/dev/null 2>&1 && \
    export LS_COLORS=$(vivid generate solarized-light)

command -v bat &>/dev/null 2>&1 && \
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"

export NNN_BMS="D:~/Documents;d:~/development;i:~/Images;v:~/Vidéos;m:~/Musique"
export NNN_OPTS="a"
export NNN_PLUG="d:downloader;p:preview-tui;z:autojump"
export PAGER=bat
export PURE_GIT_DOWN_ARROW="📥"
export PURE_GIT_STASH_SYMBOL="📝"
export PURE_GIT_UP_ARROW="📤"

# alacritty
export WINIT_X11_SCALE_FACTOR=1.666

export AIRFLOW_HOME=$HOME/.local/share/airflow
export AIRFLOW__CORE__LOAD_DEFAULT_CONNECTIONS=False
export AIRFLOW__CORE__LOAD_EXAMPLES=False
