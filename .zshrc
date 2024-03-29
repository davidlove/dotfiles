# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory extendedglob notify
unsetopt autocd beep nomatch
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename "$HOME/.zshrc"

autoload -Uz compinit
compinit
# End of lines added by compinstall

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$PATH:$HOME/bin"
fi

# set PATH to include anaconda3 if it exists
if [ -d "$HOME/anaconda3/bin" ] ; then
    PATH="$HOME/anaconda3/bin:$PATH"
fi

if [ -e "$HOME/.bash_aliases"  ]; then
    source "$HOME/.bash_aliases"
fi
if [ -e "$HOME/.bash_ssh"  ]; then
    source "$HOME/.bash_ssh"
fi
if [ -e "$HOME/.bash_spark"  ]; then
    source "$HOME/.bash_spark"
fi

autoload -U colors && colors

setopt correct

export EDITOR=$(which vim)

bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char
bindkey "^[[2~" overwrite-mode

# Adapted from code found at <https://gist.github.com/1712320>.

setopt prompt_subst
autoload -U colors && colors # Enable colors in prompt

# Modify the colors and symbols in these variables as desired.
GIT_PROMPT_SYMBOL="%{$fg[blue]%}"
GIT_PROMPT_PREFIX="%{$fg[green]%}[%{$reset_color%}"
GIT_PROMPT_SUFFIX="%{$fg[green]%}]%{$reset_color%}"
GIT_PROMPT_AHEAD="%{$fg[magenta]%}ANUM%{$reset_color%}"
GIT_PROMPT_BEHIND="%{$fg[cyan]%}BNUM%{$reset_color%}"
GIT_PROMPT_MERGING="%{$fg_bold[magenta]%}Merging%{$reset_color%}"
GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%}Un%{$reset_color%}"
GIT_PROMPT_MODIFIED="%{$fg_bold[yellow]%}Mo%{$reset_color%}"
GIT_PROMPT_STAGED="%{$fg_bold[green]%}St%{$reset_color%}"

# Show Git branch/tag, or name-rev if on detached head
parse_git_branch() {
  (git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD) 2> /dev/null
}

# Show different symbols as appropriate for various Git repository states
parse_git_state() {

  # Compose this value via multiple conditional appends.
  local GIT_STATE=""

  local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
  if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_MERGING
  fi

  if ! git diff --cached --quiet 2> /dev/null; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_STAGED
  fi

  if ! git diff --quiet 2> /dev/null; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_MODIFIED
  fi

  if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
    GIT_STATE=$GIT_STATE$GIT_PROMPT_UNTRACKED
  fi

  if [[ -n $GIT_STATE ]]; then
    echo "$GIT_PROMPT_PREFIX$GIT_STATE$GIT_PROMPT_SUFFIX"
  fi

}

# SHow ahead & behind of master branch
parse_git_remote() {
  local GIT_STATE=""

  local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_AHEAD" -gt 0 ]; then
    GIT_STATE=$GIT_STATE${GIT_PROMPT_AHEAD//NUM/$NUM_AHEAD}
  fi

  local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
  if [ "$NUM_BEHIND" -gt 0 ]; then
    GIT_STATE=$GIT_STATE${GIT_PROMPT_BEHIND//NUM/$NUM_BEHIND}
  fi

  if [[ -n $GIT_STATE ]]; then
    echo "%{$reset_color%}|$GIT_STATE"
  fi

}

# If inside a Git repository, print its branch and state
git_prompt_string() {
  local git_where="$(parse_git_branch)"
  [ -n "$git_where" ] && echo "$GIT_PROMPT_SYMBOL$(parse_git_state)$GIT_PROMPT_PREFIX%{$fg[yellow]%}${git_where#(refs/heads/|tags/)}$(parse_git_remote)$GIT_PROMPT_SUFFIX"
}

PROMPT="[%{$fg[green]%}%n@%m %{$fg[cyan]%}%*%{$reset_color%}]%# "

# Set the right-hand prompt
# RPS1='$(git_prompt_string)[%{$fg_bold[red]%}%~%{$reset_color%}]'
RPS1='$(git_prompt_string)[%{$fg_bold[red]%}%~%{$reset_color%}]'

# ls colors on OS X
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

# Linux config
if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]
then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
if [ -f /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh ]
then
    source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
fi
# brew config
if type brew &>/dev/null; then
    source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    source $(brew --prefix)/share/zsh-history-substring-search/zsh-history-substring-search.zsh

    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

    autoload -Uz compinit
    compinit
fi

## Conda zsh completion
#fpath+=$(dirname $(readlink $HOME/.zshrc))/conda-zsh-completion
#compinit conda

# direnv config
if [ -x "$(command -v direnv)" ]; then
    eval "$(direnv hook zsh)"
fi

# pyenv config
if [ -x "$(command -v pyenv)" ]; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
fi

# Choosing a pager
if [ -x "$(command -v most)" ]; then
    export PAGER='most'
elif [ -x "$(command -v less)" ]; then
    export PAGER='less'
else
    export PAGER='more'
fi

if [ -e "$HOME/.extra_zshrc"  ]; then
    source "$HOME/.extra_zshrc"
fi
