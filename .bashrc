alias less="less -N"
export GOPATH="${HOME}/go"
export PATH="/sbin:/usr/sbin:/usr/local/sbin:${PATH}:${GOPATH}/bin"

#                      29  for black, 31 red
#export PS1="\[\033[01;31m\]\[$(ppwd)\]\u@\h:\w\[\033[0m\]\n> "
#export PS1='• \[\e[0;32m\]\u@\H\[\e[m\]•\[\e[1;34m\] \w \[\e[m\]• \n• '

alias gitlog="git log --all --graph --decorate=full"


## powerline-shell https://github.com/b-ryan/powerline-shell
function _update_ps1() {
    PS1=$(powerline-shell $?)
}

if [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi

## powerline END
