# Source conda configuration
# Base environment automatically activated with auto_activate_base
# https://docs.conda.io/projects/conda/en/latest/configuration.html

command -v brew &>/dev/null 2>&1 && {

    BREW_PREFIX=$(brew --prefix)
    __conda_setup="$('${BREW_PREFIX}/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "${BREW_PREFIX}/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
            . "${BREW_PREFIX}/Caskroom/miniconda/base/etc/profile.d/conda.sh"
        else
            export PATH="${BREW_PREFIX}/Caskroom/miniconda/base/bin:$PATH"
        fi
    fi
    unset __conda_setup
}
