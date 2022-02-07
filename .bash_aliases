# Bash aliases for David Love

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac

# General aliases
case "${machine}" in
    Linux)    alias ls='ls -F --color=always';;
    Mac)      alias ls='ls -F';;
esac
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias la='ls -aF'
alias ld='ls -dF'
alias ll='ls -lhF'
alias lla='ls -alhF'
alias lt='ls -lhFt'
alias lta='ls -alhFt'
alias l='ls'
alias df='df -h'
alias du='du -sh'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias prog="ps aux | grep "
alias gr='grep -Hn --color=auto'
alias g='git'

# Compound clear and directory view commands
alias cl='CLEARMARK="\e[33;1;40m ------------------------------------------------------------------------------ \e[0m"; echo -e $CLEARMARK; clear;'
alias cls='clear; LOCATION="\e[36;1;40m $PWD \e[0m"; echo -e $LOCATION; ls -F'
alias cla='clear; LOCATION="\e[36;1;40m $PWD \e[0m"; echo -e $LOCATION; ls -aF'
alias cll='clear; LOCATION="\e[36;1;40m $PWD \e[0m"; echo -e $LOCATION; ls -lhF'
alias clla='clear; LOCATION="\e[36;1;40m $PWD \e[0m"; echo -e $LOCATION; ls -alhF'

# Permissions aliases
alias 700='chmod 700'
alias 600='chmod 600'
alias 400='chmod 400'
alias 644='chmod 644'

# Todo.sh
alias t='todo.sh -at'
alias ctl='clear; todo.sh ls'
alias vt='vim ${HOME}/todo/todo.txt'

# TMUX
# From: https://stackoverflow.com/a/49001088
tmux_create_default () {
    # Use -d to allow the rest of the function to run
    tmux new-session -d -s default -n 'GTOP' 'gtop'
    tmux new-window
    # -d to prevent current window from changing
    # tmux new-window -d -n Win2
    # -d to detach any other client (which there shouldn't be,
    # since you just created the session).
    tmux attach-session -d -t default
}
alias ta='tmux attach -t default || tmux_create_default'


# Python aliases
alias ipy='ipython'
alias ipy2='ipython2'
alias nb='jupyter notebook --no-browser'
alias jl='jupyter lab --no-browser'
alias ca='conda activate'

# Build jupyter slides
function jupyter-slides() { jupyter nbconvert "${1}" --to slides --post serve; rm -f $(basename "${1}" .ipynb).slides.html ; }

# Get real name of user
function realname() { echo $(getent passwd $1 | cut -d: -f 5); }

# Fixes pytest to run with pythonw
if [ $machine == 'Mac' ]
then
    alias pytest='echo "* Using: $(which pythonw)"; pythonw -m pytest'
fi

# For fun: a function to uncompress Git objects
zlibd() (printf "\x1f\x8b\x08\x00\x00\x00\x00\x00" | cat - "$@" | gzip -dc)

