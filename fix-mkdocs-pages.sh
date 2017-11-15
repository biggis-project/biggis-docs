#!/bin/sh

# Quick and dirty config hack for mkdocs pages.
#
# Created by Viliam Simko (viliam.simko@gmail.com)
# License: MIT
#
# Generated `pages:` section within mkdocs.yml
# The sections are ordered by filenames, however the section
# titles are taken either from the first H1 from the document
# or from the filename if H1 is missing.
#
# Limitations:
# - Using plain sed instead of Markdown parser (only "# Section" syntax supported)
# - Directories use their name as a sorting key and as a section title.
# - Tested only on Linux Mint 18 (Ubuntu 16.04)

MKDOCSYML=$(realpath "$1")
[ -f "$MKDOCSYML" ] || {
    echo "Error: mkdocs.yml file not specified"
    exit 1
}

get_new_pages_config() {

    TMP=`mktemp /tmp/mkdocs.tmp.XXXXX`
    TREE="$TMP"_tree
    H1MAP="$TMP"_h1
    NAMEMAP="$TMP"_map
    NAMEMAP_NORM="$TMP"_norm
    INDENTATION="$TMP"_indent

    DOCS_DIR='docs'
    cd "$DOCS_DIR"

    find . -name '*.md' | sed -e 's/^\(\.\/.*\)\/\([^\/]*\.md\)/\1\n\1\/\2/' >"$TREE"
    grep -e '^#[^#].*' -m 1 --include='*.md' -r ./ >"$H1MAP"

    sed -i 's/\/\(index.md\)/\/!!!\1/' "$TREE" "$H1MAP"

    LC_ALL=C sort --ignore-case --unique --output="$TREE" "$TREE"
    LC_ALL=C sort --ignore-case --unique --output="$H1MAP" "$H1MAP"

    echo "pages: # Generated using $0 on $(date)"

    join --ignore-case -a 1 -t: "$TREE" "$H1MAP" |
    sed -e 's/!!!//' \
        -e 's/\(.*\):\(#.*\)/\2: \1/' \
        -e 's/^\([^#].*\)\/\(.*\).md/\2: \1\/\2.md/' \
        -e 's/^#\s*//' > "$NAMEMAP"

    sed -e 's/\.\///' \
        -e 's/[^/]//g' \
        -e 's/\//    /g' \
        -e 's/$/-/' -e 's/^/    /' "$NAMEMAP" > "$INDENTATION"

    sed -e 's/^\..*\/\([^\/]*\)$/\1:/' \
        -e 's/^./\U&/' "$NAMEMAP" > "$NAMEMAP_NORM"

    paste -d' ' "$INDENTATION" "$NAMEMAP_NORM"

    #
    # clenup
    if [ -z "$DEBUG" ]; then
        echo "$TMP"* | while read FNAME; do
            rm $FNAME
        done
    else
        echo "$TREE" >&2
        echo "$H1MAP" >&2
        echo "$NAMEMAP" >&2
        echo "$NAMEMAP_NORM" >&2
        echo "$INDENTATION" >&2
    fi
}

# removing "pages:" section from the config file
sed -i -e '/^pages:/,/^[a-z_]*:/{/^[a-z_]*:/b;d;}' "$MKDOCSYML"
sed -i -e '/^pages:/d' "$MKDOCSYML"

# add new "pages:" section at the end
get_new_pages_config >> "$MKDOCSYML"
echo done
