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
    if [ ! -e $DEST ] ; then
        cmd="ln -s $SOURCE $DEST"
        echo "$SOURCE -> $DEST"
        eval "$cmd"
    elif [ -L $DEST ] && [ "$(realpath $SOURCE)" == "$(readlink $DEST)" ] ; then
        echo "$SOURCE -> $DEST"
    else
        echo "* $DEST already exists"
    fi
done
for x in config/*; do
    SOURCE=$PWD/$x
    DEST=$HOME/.$x
    if [ ! -e $DEST ] ; then
        cmd="ln -s $SOURCE $DEST"
        echo "$SOURCE -> $DEST"
        eval "$cmd"
    elif [ -L $DEST ] && [ "$(realpath $SOURCE)" == "$(readlink $DEST)" ] ; then
        echo "$SOURCE -> $DEST"
    else
        echo "* $DEST already exists"
    fi
done
