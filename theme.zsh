# pure theme
#
# https://github.com/zsh-users/zsh/blob/master/Functions/Prompts/promptinit

if [[ ! -e $ZDOTDIR/modules/zsh-async ]]; then
  git clone --quiet --depth=1 https://github.com/mafredri/zsh-async.git $ZDOTDIR/modules/zsh-async
  zcompile $ZDOTDIR/modules/zsh-async/async.zsh
fi

if [[ ! -e $ZDOTDIR/modules/pure ]]; then
  git clone --quiet --depth=1 https://github.com/sindresorhus/pure.git $ZDOTDIR/modules/pure
  zcompile $ZDOTDIR/modules/pure/pure.zsh
fi

# https://github.com/sindresorhus/pure#options
PURE_CMD_MAX_EXEC_TIME=10

PURE_GIT_DOWN_ARROW="📥"
PURE_GIT_STASH_SYMBOL="📝"
PURE_GIT_UP_ARROW="📤"

PURE_PROMPT_SYMBOL="❯"
PURE_PROMPT_VICMD_SYMBOL="❮" 

# https://github.com/sindresorhus/pure#zstyle-options
zstyle ":prompt:pure:git:*" color green
zstyle ":prompt:pure:git:dirty" color magenta
zstyle ":prompt:pure:git:stash" show yes
zstyle ":prompt:pure:prompt:*" color cyan
zstyle ":prompt:pure:virtualenv" color yellow

source $ZDOTDIR/modules/pure/pure.zsh

