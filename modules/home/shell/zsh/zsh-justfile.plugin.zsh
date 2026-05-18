_justfile_comp() {
    if [[ -f "Justfile" ]];
    then
        local opts
        opts="`just --summary`"
        reply=(${(s: :)opts})
    fi
}

compctl -K _justfile_comp just
