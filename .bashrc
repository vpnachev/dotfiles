export GOPATH="${HOME}/go"
export PATH="/sbin:/usr/sbin:/usr/local/sbin:${PATH}:${GOPATH}/bin"
export Videos="/var/lib/Videos"

#                      29  for black, 31 red
#export PS1="\[\033[01;31m\]\[$(ppwd)\]\u@\h:\w\[\033[0m\]\n> "
#export PS1='• \[\e[0;32m\]\u@\H\[\e[m\]•\[\e[1;34m\] \w \[\e[m\]• \n• '

## powerline-shell https://github.com/b-ryan/powerline-shell
function _update_ps1() {
    PS1=$(powerline-shell $?)
}

if [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi

## powerline END

mkdir -p $HOME/.completion.d

KUBECTL_VERSION=
MINIKUBE_VERSION=
HELM_VERSION=
GARDENCTL_VERSION=
KUBECTL_V=$(kubectl version --client --short | grep -o "v[0-9].*[0-9]")
MINIKUBE_V=$(minikube version | grep -o "v[0-9].*[0-9]")
HELM_V=$(helm version --client --short | grep -o "v[0-9].*[0-9]")
GARDENCTL_V=$(gardenctl version | awk "NR==2" | grep -o "[0-9].*[0-9]")

if [[ x${KUBECTL_VERSION}x != x${KUBECTL_V}x ]]
then
    sed -i "s/^KUBECTL_VERSION=$KUBECTL_VERSION$/KUBECTL_VERSION=$KUBECTL_V/g" $HOME/.bashrc.custom
    kubectl completion bash >$HOME/.completion.d/kubectl
fi

if [[ x${MINIKUBE_VERSION}x != x${MINIKUBE_V}x ]]
then
    sed -i "s/^MINIKUBE_VERSION=$MINIKUBE_VERSION$/MINIKUBE_VERSION=$MINIKUBE_V/g" $HOME/.bashrc.custom
    minikube completion bash >$HOME/.completion.d/minikube
fi

if [[ x${HELM_VERSION}x != x${HELM_V}x ]]
then
    sed -i "s/^HELM_VERSION=$HELM_VERSION$/HELM_VERSION=$HELM_V/g" $HOME/.bashrc.custom
    helm completion bash >$HOME/.completion.d/helm
fi

if [[ x${GARDENCTL_VERSION}x != x${GARDENCTL_V}x ]]
then
    sed -i "s/^GARDENCTL_VERSION=$GARDENCTL_VERSION$/GARDENCTL_VERSION=$GARDENCTL_V/g" $HOME/.bashrc.custom
    cd $HOME
    gardenctl completion
    mv gardenctl_completion.sh $HOME/.completion.d/gardenctl
    cd - &>/dev/null
fi

source $HOME/.completion.d/kubectl
source $HOME/.completion.d/minikube
source $HOME/.completion.d/helm
source $HOME/.completion.d/gardenctl

alias xpaste="xclip -sel col -o"
alias xcopy="xclip -sel col"
alias temperature="sensors | grep '^Core.*?°C' -P"
alias цд="cd"
alias лс="ls"
alias лл="ll"
alias пвд="pwd"
