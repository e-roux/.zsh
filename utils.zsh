function _update_IT_books() {
  _BOOKS=$HOME/Documents/Livres && [[ -d $_BOOKS ]] || mkdir -p "$_BOOKS"  && \
    find "$_BOOKS" -maxdepth 1 -type l -exec rm "{}" \; && \
    calibredb list -s series:=Informatique  -f formats --for-machine | \
    jq '.[] | (.formats)' | \
    jq -r '.[]' | \
    while read elt; do ln -nfs "$elt" "$_BOOKS"; done
}



