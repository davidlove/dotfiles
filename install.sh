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
    if [ -e $DEST ] ; then
        if [ -L $DEST ] && [ "$(realpath $SOURCE)" == "$(readlink $DEST)" ] ; then
            echo "${SOURCE} already installed"
            continue
        else
            read -p "$DEST already exists, delete it? y/[n] > " RESPONSE
            if [ "$RESPONSE" == "y" ]; then
                rm -rf $DEST
            else
                continue
            fi
        fi
    fi
    cmd="ln -s $SOURCE $DEST"
    echo "Installing link: $SOURCE -> $DEST"
    eval "$cmd"
done
for x in config/*; do
    SOURCE=$PWD/$x
    DEST=$HOME/.$x
    if [ -e $DEST ] ; then
        if [ -L $DEST ] && [ "$(realpath $SOURCE)" == "$(readlink $DEST)" ] ; then
            echo "${SOURCE} already installed"
            continue
        else
            read -p "$DEST already exists, delete it? y/[n] > " RESPONSE
            if [ "$RESPONSE" == "y" ]; then
                rm -rf $DEST
            else
                continue
            fi
        fi
    fi
    cmd="ln -s $SOURCE $DEST"
    echo "Installing link: $SOURCE -> $DEST"
    eval "$cmd"
done
