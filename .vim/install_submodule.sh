#!/bin/bash

github_repo=${1}
plugin_name=$(echo ${github_repo} |sed 's:.*/\(.*\)\.git:\1:' | sed -E 's:\.?-?vim\.?-?::')
cmd="git submodule add ${github_repo} pack/mypackages/start/${plugin_name}"
echo "$cmd"
eval "$cmd"

