#!/bin/sh

# Quick and dirty config hack for mkdocs pages.
#
# Created by Viliam Simko (viliam.simko@gmail.com)
# License: MIT
#
# Generates `pages:` section within `mkdocs.yml` file.
# The sections are ordered by filenames, however the section
# titles are taken either from the first H1 within a document
# or from the filename if H1 is missing.
#
# Limitations:
# - Using plain `sed` instead of a Markdown parser (only "# Section" syntax supported)
# - Inline markup (bold, italic, etc.) in headers not supported
# - Directories use their name as a sorting key as well as a section title.
# - Expects that the script is executed inside the project's root dir and the root dir contains `docs/` dir
# - Tested only on Linux Mint 18 (Ubuntu 16.04)

MKDOCSYML=$(realpath "$1")
[ -f "$MKDOCSYML" ] || {
    echo "Warning: Using default mkdocs.yml file because the parameter was not explicitly specified" > /dev/stderr
    MKDOCSYML='mkdocs.yml'
}

# Note:
# - STDOUT inside this function goes to `mkdocs.yml`
# - if you need to print some messages, use: `echo message >&2`
get_new_pages_config() {

    # These are all temporary files used in the transformation
    # You can debug them by running `$ DEBUG=1 ./fix-mkdocs-pages.sh`
    TMP=`mktemp /tmp/mkdocs.tmp.XXXXX`
    TREE="$TMP"_tree
    H1MAP="$TMP"_h1
    NAMEMAP="$TMP"_map
    NAMEMAP_NORM="$TMP"_norm
    INDENTATION="$TMP"_indent

    # TODO: make this as a CLI parameter
    DOCS_DIR='docs'
    cd "$DOCS_DIR"

    # get a list markdown files in form `./path/to/file.md`
    find . -name '*.md' |
        # extract subdirs in form of `./path/to`
        # at this point, there will be many subdirs duplicates
        sed -e 's/^\(\.\/.*\)\/\([^\/]*\.md\)/\1\n\1\/\2/' |
        # Section names need to be cleaned up
        sed -r '/\.md$/! {s/[-_]+/ /g}' > "$TREE"

    # extract H1 heading from files
    grep -e '^#[^#].*' -m 1 --include='*.md' -r ./ > "$H1MAP"

    # filenames `index.md` are special and need to be on top
    # trick: index.md -> !!!index.md
    sed -i 's/\/\(index.md\)/\/!!!\1/' "$TREE" "$H1MAP"

    # we need to sort both file before joining
    LC_ALL=C sort --ignore-case --unique --output="$TREE" "$TREE"
    LC_ALL=C sort --ignore-case --unique --output="$H1MAP" "$H1MAP"

    # this output goes directly to mkdocs.yml
    echo "pages: # Generated using $0 on $(date)"

    # joining on pathname (outer left join)
    # we get `path:# H1` after this operation
    join --ignore-case -a 1 -t: "$TREE" "$H1MAP" |
        # convert back: !!!index.md -> index.md
        sed 's/!!!//' |
        # convert `path:# H1` to `# H1: path`
        sed 's/\(.*\):\(#.*\)/\2: \1/' |
        # convert lines without H1 to `file: path`
        sed 's/^\([^#].*\)\/\(.*\).md/\2: \1\/\2.md/' |
        # let's remove the # char because it is not needed anymore
        sed 's/^#\s*//' > "$NAMEMAP"

    # here we compute the indentation levels by using `/` characters
    # the indentation is later prepended before every line
    sed \
        -e 's/[^/]//g' \
        -e 's/\//    /g' \
        -e 's/$/-/' "$NAMEMAP" > "$INDENTATION"

    # Here we normalize the section names
    cat "$NAMEMAP" |
        # Keeping only the filename from the whole path
        sed 's/^\..*\/\([^\/]*\)$/\1:/' |
        # First letter to uppercase
        sed 's/^./\U&/'  > "$NAMEMAP_NORM"

    # now preprending indentation to every line
    paste -d' ' "$INDENTATION" "$NAMEMAP_NORM"

    # clenup
    if [ -z "$DEBUG" ]; then
        # clenup if not debuging
        echo "$TMP"* | while read FNAME; do
            rm $FNAME
        done
    else
        # keeping tmp files for debugging
        # you need to delete them manually
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
get_new_pages_config | ./optimize-pages-tree.js >> "$MKDOCSYML"
echo done.
