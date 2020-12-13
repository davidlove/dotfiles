#!/bin/bash

# Install links to the dotfiles directory for all tracked files

for x in .*; do
    if [ $x = '.' ] \
    || [ $x = '..' ] \
    || [ $x = '.git' ] \
    || [ $x = '.gitignore' ] \
    || [ $x = '.gitmodules' ] \
    || [ $x = 'README' ] \
    ; then
        continue
    fi
    SOURCE=$PWD/$x
    DEST=$HOME/$x
    if [[ -e $DEST && ! -L $DEST ]] || \
       [[ ! -L $DEST && "$(realpath $SOURCE)" != "$(readlink $DEST)" ]] ; then
        read -p "$DEST already exists, delete it? y/[n] > " RESPONSE
        if [ "$RESPONSE" == "y" ]; then
            rm -f $DEST
        else
            continue
        fi
    fi
    if [ -L $DEST ] && [ "$(realpath $SOURCE)" == "$(readlink $DEST)" ] ; then
        echo "$SOURCE -> $DEST"
    else
        cmd="ln -s $SOURCE $DEST"
        echo "$SOURCE -> $DEST"
        eval "$cmd"
    fi
done
for x in config/*; do
    SOURCE=$PWD/$x
    DEST=$HOME/.$x
    if [[ -e $DEST && ! -L $DEST ]] || \
       [[ ! -L $DEST && "$(realpath $SOURCE)" != "$(readlink $DEST)" ]] ; then
        read -p "$DEST already exists, delete it? y/[n] > " RESPONSE
        if [ "$RESPONSE" == "y" ]; then
            rm -f $DEST
        else
            continue
        fi
    fi
    if [ -L $DEST ] && [ "$(realpath $SOURCE)" == "$(readlink $DEST)" ] ; then
        echo "$SOURCE -> $DEST"
    else
        cmd="ln -s $SOURCE $DEST"
        echo "$SOURCE -> $DEST"
        eval "$cmd"
    fi
done
