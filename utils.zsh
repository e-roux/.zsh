function _update_IT_books() {
  _BOOKS=$HOME/Documents/Livres && [[ -d $_BOOKS ]] || mkdir -p "$_BOOKS"  && \
    find "$_BOOKS" -maxdepth 1 -type l -exec rm "{}" \; && \
    calibredb list -s series:=Informatique  -f formats --for-machine | \
    jq '.[] | (.formats)' | \
    jq -r '.[]' | \
    while read elt; do ln -nfs "$elt" "$_BOOKS"; done
}

# source:
# https://gist.github.com/cdown/1163649
urlencode() {
    # urlencode <string>

    old_lc_collate=$LC_COLLATE
    LC_COLLATE=C

    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:$i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) printf '%s' "$c" ;;
            *) printf '%%%02X' "'$c" ;;
        esac
    done

    LC_COLLATE=$old_lc_collate
}

urldecode() {
    # urldecode <string>

    local url_encoded="${1//+/ }"
    printf '%b' "${url_encoded//%/\\x}"
}

