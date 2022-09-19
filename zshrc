# zmodload zsh/zprof

# [ ] TODO: set those in ansible
# [ ] TODO: oc completion broken

ZDOTDIR=${ZDOTDIR:-~/.zsh}

fpath+=(
    $ZDOTDIR/functions
)

for f (
    $ZDOTDIR/options.zsh
    $ZDOTDIR/plugins.zsh
    $ZDOTDIR/completion.zsh
    $ZDOTDIR/utils.zsh
    $ZDOTDIR/theme.zsh
    $ZDOTDIR/zshprivate
    $ZDOTDIR/conda.zsh
    $ZDOTDIR/aliases.zsh
    $ZDOTDIR/history.zsh
    ); do [ -f $f ] && source $f; done



# vim: set fdm=marker:
