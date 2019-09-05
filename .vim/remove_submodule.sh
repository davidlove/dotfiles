#!/bin/bash

git submodule deinit vim/pack/mypackages/start/${1}
git rm vim/pack/mypackages/start/${1}
rm -Rf .git/modules/vim/pack/mypackages/start/${1}
