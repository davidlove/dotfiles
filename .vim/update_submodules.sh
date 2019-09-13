#!/bin/bash

CMD="git submodule update --init --recursive --rebase"
echo "$CMD"
eval "$CMD"

