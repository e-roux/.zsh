#!/bin/env zsh

#======================================================================
# zsh {{{1
#======================================================================
export SHELL='/bin/zsh'

export ZDOTDIR=$HOME/.zsh

# Make Vi mode transitions faster (KEYTIMEOUT is in hundredths of a second)
export KEYTIMEOUT=1

export PURE_GIT_DOWN_ARROW="📥"
export PURE_GIT_STASH_SYMBOL="📝"
export PURE_GIT_UP_ARROW="📤"
# 1}}}
#======================================================================
# vim {{{1
#======================================================================
export EDITOR='vim'
export GIT_EDITOR='vim'
# 1}}}
#======================================================================
# python {{{1
#======================================================================
export PYENV_ROOT=$HOME/.opt/pyenv
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

# Install pkg only in virtualenv
export PIP_REQUIRE_VIRTUALENV=true

# Apache Airflow
export AIRFLOW_HOME=$HOME/.local/share/airflow
export AIRFLOW__CORE__LOAD_DEFAULT_CONNECTIONS=False
export AIRFLOW__CORE__LOAD_EXAMPLES=False
# 1}}}
#======================================================================
# ruby {{{1
#======================================================================
export RBENV_ROOT=$HOME/.opt/rbenv
# 1}}}
#======================================================================
# go {{{1
#======================================================================
# https://golang.org/cmd/go/#hdr-Environment_variables
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
# 1}}}
#======================================================================
# PATH {{{1
#======================================================================
function _check_and_add_to_path() {
  path_to_be_checked=$(eval "realpath $1")

    case ":${PATH}:" in
        *:"$path_to_be_checked":*)
            ;;
        *)
            export PATH="$path_to_be_checked:$PATH"
            ;;
    esac
}
_check_and_add_to_path $HOME/.arkade/bin
_check_and_add_to_path $HOME/.local/bin
_check_and_add_to_path /opt/go/bin
_check_and_add_to_path $GOBIN
_check_and_add_to_path $RBENV_ROOT/shims
_check_and_add_to_path $RBENV_ROOT/bin
_check_and_add_to_path $PYENV_ROOT/shims
_check_and_add_to_path $PYENV_ROOT/bin
_check_and_add_to_path $HOME/.cargo/bin

# export PATH=$HOME/.arkade/bin:$HOME/.local/bin:$GOBIN:$RBENV_ROOT/shims:$RBENV_ROOT/bin:$PYENV_ROOT/shims:$PYENV_ROOT/bin:$HOME/.cargo/bin:/opt/go/bin:$PATH
# 1}}}
#======================================================================
# ghq {{{1
#======================================================================
command -v ghq &>/dev/null 2>&1 && {
    export GHQ_ROOT=$HOME/development
}
#======================================================================
# vivid {{{1
#======================================================================
command -v vivid &>/dev/null 2>&1 && {
    export LS_COLORS=$(vivid generate solarized-light)
}
# 1}}}
#======================================================================
# bat {{{1
#======================================================================
command -v bat &>/dev/null 2>&1 && {
    export BAT_PAGER='less'
    export BAT_STYLE='changes'
    export BAT_THEME='Monokai Extended Light'
    # bat can be used as a colorizing pager for man
    # See https://github.com/sharkdp/bat#man
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
    export PAGER=bat
}
# 1}}}
#======================================================================
# nnn {{{1
#======================================================================
export NNN_BMS="D:~/Documents;d:~/development;i:~/Images;v:~/Vidéos;m:~/Musique"
export NNN_OPTS="a"
export NNN_PLUG="d:downloader;p:preview-tui;z:autojump"
# 1}}}
#======================================================================
# alacritty {{{1
#======================================================================
export WINIT_X11_SCALE_FACTOR=1.666
# 1}}}
#======================================================================

# vim: fdm=marker
