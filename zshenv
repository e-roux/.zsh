# export WORKON_DIR=/opt/venvs
export BAT_PAGER='less'
export BAT_STYLE='grid,changes'
export BAT_THEME='Monokai Extended'


export SPACESHIP_VI_MODE_PREFIX=""
# export SPACESHIP_VI_MODE_SUFFIX=
export SPACESHIP_VI_MODE_INSERT="❯"
export SPACESHIP_VI_MODE_NORMAL="❮"
export SPACESHIP_VI_MODE_COLOR="green"

# https://github.com/denysdovhan/spaceship-prompt
export SPACESHIP_PROMPT_ORDER=(
  time          # Time stamps section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  package       # Package version
  node          # Node.js section
  ruby          # Ruby section
  golang        # Go section
  docker        # Docker section
  venv          # virtualenv section
  conda         # conda virtualenv section
  pyenv         # Pyenv section
  kubectl       # Kubectl context section
  exec_time     # Execution time
  line_sep      # Line break
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  vi_mode       # Vi-mode indicator
)

export EDITOR=vim
export GOPATH=$HOME/go
export PAGER=bat

export TERM=xterm-256color

export PATH=$GOPATH/bin:$PATH
export ZDOTDIR=$HOME/.zsh
