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

# vim: set fdm=marker ts=2 shiftwidth=2:
