#!/bin/env zsh

# XDG configuration home
[[ -z $XDG_CONFIG_HOME ]] && {
  export XDG_CONFIG_HOME=$HOME/.config
}

# XDG data home
[[ -z $XDG_DATA_HOME ]] && {
  export XDG_DATA_HOME=$HOME/.local/share
}

# zsh {{{1
export SHELL='/bin/zsh'
export TERM=screen-256color
export ZDOTDIR=$HOME/.zsh
# Make Vi mode transitions faster (KEYTIMEOUT is in hundredths of a second)
export KEYTIMEOUT=1
# 1}}}

# PATH {{{2
if [ $(uname) = "Darwin" ]; then
    # BSD specific
    export CLICOLOR=1
    export HOMEBREW_NO_ANALYTICS=1

    export PATH="/opt/homebrew/sbin:/opt/homebrew/bin:$PATH"

    # https://man7.org/linux/man-pages/man1/hash.1p.html
    hash -r
fi

function _check_and_add_to_path() {

    path_to_be_checked=$(eval "realpath -q $1")

    [ $? = 1 ] && return

    case ":${PATH}:" in
    *:"$path_to_be_checked":*) ;;

    *)
        export PATH="$path_to_be_checked:$PATH"
        ;;
    esac
}

command -v brew &>/dev/null 2>&1 && {
    _check_and_add_to_path "$(brew --prefix)/opt/make/libexec/gnubin"
    _check_and_add_to_path $HOME/.local/bin
    _check_and_add_to_path /opt/go/bin
    _check_and_add_to_path $GOBIN
    _check_and_add_to_path $RBENV_ROOT/shims
    _check_and_add_to_path $RBENV_ROOT/bin
    _check_and_add_to_path $PYENV_ROOT/shims
    _check_and_add_to_path $PYENV_ROOT/bin
    _check_and_add_to_path $HOME/.cargo/bin
}
# 2}}}

# ghq {{{2
command -v ghq &>/dev/null 2>&1 && {
    export GHQ_ROOT=$HOME/development
}
# 2}}}

# vivid {{{2
command -v vivid &>/dev/null 2>&1 && {
    export LS_COLORS=$(vivid generate solarized-light)
}
# 2}}}

# bat {{{2
command -v bat &>/dev/null 2>&1 && {
    export BAT_PAGER='less'
    export BAT_STYLE='changes'
    export BAT_THEME='Solarized (light)'
    # bat can be used as a colorizing pager for man
    # See https://github.com/sharkdp/bat#man
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
    export PAGER=bat
}
# 2}}}

# nnn {{{2
export NNN_BMS="D:~/Documents;d:~/development;v:~/Movies;m:~/Music;p:~/Pictures;"
export NNN_OPTS="ade" #
export NNN_FCOLORS="c1e2272e006033f7c6d6abc4"
export NNN_PLUG="d:downloader;p:preview-tui;z:autojump"
# 2}}}

# alacritty {{{2
command -v alacritty &>/dev/null 2>&1 && {
    export WINIT_X11_SCALE_FACTOR=1.666
}
# 2}}}

# 1}}}

# vim {{{1
export EDITOR='nvim'
export GIT_EDITOR='nvim'
# 1}}}

# python {{{1
export PYENV_ROOT=$HOME/.opt/pyenv
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

# Install pkg only in virtualenv
export PIP_REQUIRE_VIRTUALENV=true

# Apache Airflow
export AIRFLOW_HOME=$HOME/.local/share/airflow
export AIRFLOW__CORE__LOAD_DEFAULT_CONNECTIONS=False
export AIRFLOW__CORE__LOAD_EXAMPLES=False
# 1}}}

# ruby {{{1
export RBENV_ROOT=$HOME/.opt/rbenv
# 1}}}

# go {{{1
# https://golang.org/cmd/go/#hdr-Environment_variables
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
# 1}}}

# vim: set fdm=marker ts=2 shiftwidth=2:
