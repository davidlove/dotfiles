#!/bin/bash

# Install links to the dotfiles directory for all tracked files

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd -P )"

if [ ! -d $HOME/.config ]; then
    CMD="mkdir $HOME/.config"
    echo "$CMD"
    eval "$CMD"
fi

for x in $DIR/.* $DIR/config/*; do
    basex=$(realpath "$x" --relative-to "$DIR")

    if [ $basex = '.' ] \
    || [ $basex = '..' ] \
    || [ $basex = '.git' ] \
    || [ $basex = '.gitignore' ] \
    || [ $basex = '.gitmodules' ] \
    || [ $basex = 'README' ] \
    ; then
        continue
    fi

    SOURCE=$x
    DEST=$HOME/$(echo $basex | sed 's:^config/:.config/:')
    if [ -e $DEST ] ; then
        if [ -L $DEST ] && [ "$(realpath $SOURCE)" == "$(readlink $DEST)" ] ; then
            echo "${SOURCE} already installed to ${DEST}"
            continue
        else
            if [ "$1" == "-d" ]; then
                RESPONSE="d"
            elif [ "$1" == '-b' ]; then
                RESPONSE="b"
            elif [ "$1" == '-n' ]; then
                RESPONSE="n"
            else
                read -p "$DEST already exists, [d]elete it, [b]ackup, or [n]o change (default) > " RESPONSE
            fi
            if [ "$RESPONSE" == "d" ]; then
                CMD="rm -rf $DEST"
                echo "$CMD"
                eval "$CMD"
            elif [ "$RESPONSE" == "b" ]; then
                CMD="mv -f $DEST $DEST.bak"
                echo "$CMD"
                eval "$CMD"
            else
                echo "Skipping $DEST"
                continue
            fi
        fi
    fi
    CMD="ln -s $SOURCE $DEST"
    echo "Installing link: $SOURCE -> $DEST"
    eval "$CMD"
done
