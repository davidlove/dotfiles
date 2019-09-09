#!/bin/bash

git submodule deinit pack/mypackages/start/${1}
git rm pack/mypackages/start/${1}
rm -Rf ../.git/modules/vim/pack/mypackages/start/${1}
