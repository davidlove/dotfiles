#!/bin/bash

CMD="git submodule update --init --recursive --checkout"
echo "$CMD"
eval "$CMD"

