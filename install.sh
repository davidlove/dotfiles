#!/bin/bash

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
    if [ ! -e $HOME/$x ] ; then
        cmd="ln -s $PWD/$x $HOME/$x"
        echo "$cmd"
        eval "$cmd"
    else
        echo "$PWD/$x already exists"
    fi
done
