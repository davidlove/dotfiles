#!/bin/bash

# Install links to the dotfiles directory for all tracked files

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd -P )"

if [ ! -d $HOME/.config ]; then
    CMD="mkdir $HOME/.config"
    echo "$CMD"
    eval "$CMD"
fi

for x in "$DIR"/.* "$DIR"/config/*; do
    basex=$(realpath "$x" --relative-to "$DIR")

    if [ "$basex" = '.' ] \
    || [ "$basex" = '..' ] \
    || [ "$basex" = '.git' ] \
    || [ "$basex" = '.gitignore' ] \
    || [ "$basex" = '.gitmodules' ] \
    || [ "$basex" = 'README' ] \
    ; then
        continue
    fi

    SOURCE="$x"
    DEST="$HOME/$(echo ${basex} | sed 's:^config/:.config/:')"
    if [ -e "$DEST" ] ; then
        if [ -L "$DEST" ]; then
            REALSOURCE=`realpath "${SOURCE}"`
            REALDEST=`readlink "$DEST"`
            if  [ "$REALSOURCE" == "$REALDEST" ] ; then
                echo "'${SOURCE}' already installed to '${DEST}'"
                continue
            fi
        fi
        if [ "$1" == "-r" ]; then
            RESPONSE="r"
        elif [ "$1" == '-b' ]; then
            RESPONSE="b"
        elif [ "$1" == '-s' ]; then
            RESPONSE="s"
        else
            read -p "'$DEST' already exists, [r]eplace it, [b]ackup then replace, or [s]kip it (default) > " RESPONSE
        fi
        if [ "$RESPONSE" == "r" ]; then
            CMD="rm -rf '$DEST'"
            echo "$CMD"
            eval "$CMD"
        elif [ "$RESPONSE" == "b" ]; then
            CMD="mv -f '$DEST' '$DEST.bak'"
            echo "$CMD"
            eval "$CMD"
        else
            echo "Skipping '$DEST'"
            continue
        fi
    fi
    CMD="ln -s '$SOURCE' '$DEST'"
    echo "Installing link: '$SOURCE' -> '$DEST'"
    eval "$CMD"
done
