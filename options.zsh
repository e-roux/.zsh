#----------------------------------------
# Use vi keybindings
bindkey -v

# for jj and jk binding important
export KEYTIMEOUT=20
bindkey -M viins 'jj' vi-cmd-mode
bindkey -M viins 'jk' vi-cmd-mode

HISTSIZE=1000   # Shell history and file
SAVEHIST=1000
HISTFILE=~/.zsh/.zsh_history

HELPDIR=/usr/share/zsh/help

# Remove lines from the history list startiçng with space
setopt histignorespace
setopt histignorealldups sharehistory

# IGNOREEOF forces the user to type exit or logout, instead of just pressing ^D.
# in zsh, set with ignoreeof
setopt ignoreeof

#
# https://github.com/zsh-users/zsh/tree/master/Functions/Zle
#
# Enable Ctrl-x-e to edit command line
autoload -U edit-command-line
zle -N edit-command-line
bindkey ^e edit-command-line

# Allows "surroundings" to be changed: parentheses, brackets and quotes.
autoload -Uz surround
zle -N delete-surround surround
zle -N add-surround surround
zle -N change-surround surround
bindkey -a cs change-surround
bindkey -a ds delete-surround
bindkey -a ys add-surround
bindkey -M visual S add-surround
# Cursor 
# Change cursor shape for different vi modes.
# https://unix.stackexchange.com/a/496878
function zle-keymap-select {
    if [[ ${KEYMAP} == vicmd ]] ||
        [[ $1 = 'block' ]]; then
        echo -ne '\e[1 q'

    elif [[ ${KEYMAP} == main ]] ||
        [[ ${KEYMAP} == viins ]] ||
        [[ ${KEYMAP} = '' ]] ||
        [[ $1 = 'beam' ]]; then
        echo -ne '\e[5 q'
    fi
}
zle -N zle-keymap-select

# Use beam shape cursor on startup.
# echo -ne 'Starting zsh'

# Use beam shape cursor for each new prompt.
_fix_cursor() {
    echo -ne '\e[5 q'
}

precmd_functions+=(_fix_cursor)

