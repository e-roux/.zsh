
[[ -d $ZDOTDIR/modules ]] || mkdir -p $ZDOTDIR/modules

function zcompile-many() {
    local f
    for f; do zcompile -R -- "$f".zwc "$f"; done
}

if [[ ! -e $ZDOTDIR/modules/zsh-syntax-highlighting ]]; then
    git clone --quiet --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git $ZDOTDIR/modules/zsh-syntax-highlighting
    zcompile-many $ZDOTDIR/modules/zsh-syntax-highlighting/{zsh-syntax-highlighting.zsh,highlighters/*/*.zsh}
fi

if [[ ! -e $ZDOTDIR/modules/zsh-autosuggestions ]]; then
    git clone --quiet --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git $ZDOTDIR/modules/zsh-autosuggestions
    zcompile-many $ZDOTDIR/modules/zsh-autosuggestions/{zsh-autosuggestions.zsh,src/**/*.zsh}
fi

if [[ ! -e $ZDOTDIR/modules/zsh-z ]]; then
    git clone --quiet --depth=1 https://github.com/agkozak/zsh-z.git $ZDOTDIR/modules/zsh-z
    zcompile $ZDOTDIR/modules/zsh-z/_zshz
fi

if [[ ! -e $ZDOTDIR/modules/fzf ]]; then
    git clone --quiet --depth=1 https://github.com/junegunn/fzf.git $ZDOTDIR/modules/fzf
    zcompile-many $ZDOTDIR/modules/fzf/shell/*.zsh
fi

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#839496"

source $ZDOTDIR/modules/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZDOTDIR/modules/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZDOTDIR/modules/zsh-z/zsh-z.plugin.zsh
source $ZDOTDIR/modules/fzf/shell/key-bindings.zsh
source $ZDOTDIR/modules/fzf/shell/completion.zsh


