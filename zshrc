# zmodload zsh/zprof

# [ ] TODO: set those in ansible
# [ ] TODO: oc completion broken

ZDOTDIR=${ZDOTDIR:-~/.zsh}

fpath+=(
    $ZDOTDIR/functions
)
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
