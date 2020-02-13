export GOROOT="/usr/local/go"
export GOPATH="${HOME}/go"
export PATH="/sbin:/usr/sbin:/usr/local/sbin:${PATH}:${GOPATH}/bin:${GOROOT}/bin"
export Videos="/var/lib/Videos"
export LANG=en_US.UTF-8

#                      29  for black, 31 red
#export PS1="\[\033[01;31m\]\[$(ppwd)\]\u@\h:\w\[\033[0m\]\n> "
#export PS1='• \[\e[0;32m\]\u@\H\[\e[m\]•\[\e[1;34m\] \w \[\e[m\]• \n• '

## powerline-shell https://github.com/b-ryan/powerline-shell
function _update_ps1() {
    ext_code=$?
    export KUBE_PS_CONTEXT="$(kubectl config current-context 2>/dev/null)"
    KUBE_PS_NAMESPACE="$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)"
    KUBE_PS_NAMESPACE="${KUBE_PS_NAMESPACE:-default}"
    if [[ $KUBE_PS_CONTEXT == "" ]]
    then
        KUBE_PS_NAMESPACE=""
    fi
    export KUBE_PS_NAMESPACE
    PS1=$(powerline-shell $ext_code)
}

if [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi

function _disable_kubectx_prompt() {
    export KUBECONFIG=/invalid/path/to/kubeconfig
}

function _enable_kubectx_prompt() {
    unset KUBECONFIG #return it to default behaviour
}
## powerline END

mkdir -p $HOME/.completion.d

KUBECTL_VERSION=
MINIKUBE_VERSION=
HELM_VERSION=
GARDENCTL_VERSION=
KIND_VERSION=
KUBECTL_V=$(kubectl version --client --short | grep -o "v[0-9].*[0-9]")
MINIKUBE_V=$(minikube version | grep -o "v[0-9].*[0-9]")
HELM_V=$(helm version --client --short | grep -o "v[0-9].*[0-9]")
GARDENCTL_V=$(gardenctl version | awk "NR==2" | grep -o "[0-9].*[0-9]")
KIND_V=$(kind version -q)
if [[ x${KUBECTL_VERSION}x != x${KUBECTL_V}x ]]
then
    sed -i "s/^KUBECTL_VERSION=$KUBECTL_VERSION$/KUBECTL_VERSION=$KUBECTL_V/g" $HOME/.bashrc.local
    kubectl completion bash >$HOME/.completion.d/kubectl
fi

if [[ x${MINIKUBE_VERSION}x != x${MINIKUBE_V}x ]]
then
    sed -i "s/^MINIKUBE_VERSION=$MINIKUBE_VERSION$/MINIKUBE_VERSION=$MINIKUBE_V/g" $HOME/.bashrc.local
    minikube completion bash >$HOME/.completion.d/minikube
fi

if [[ x${HELM_VERSION}x != x${HELM_V}x ]]
then
    sed -i "s/^HELM_VERSION=$HELM_VERSION$/HELM_VERSION=$HELM_V/g" $HOME/.bashrc.local
    helm completion bash >$HOME/.completion.d/helm
fi

if [[ x${GARDENCTL_VERSION}x != x${GARDENCTL_V}x ]]
then
    sed -i "s/^GARDENCTL_VERSION=$GARDENCTL_VERSION$/GARDENCTL_VERSION=$GARDENCTL_V/g" $HOME/.bashrc.local
    cd $HOME
    gardenctl completion bash > $HOME/.completion.d/gardenctl
    cd - &>/dev/null
fi

if [[ x${KIND_VERSION}x != x${KIND_V}x ]]
then
    sed -i "s/^KIND_VERSION=$KIND_VERSION$/KIND_VERSION=$KIND_V/g" $HOME/.bashrc.local
    kind completion bash >$HOME/.completion.d/kind
fi

function gardenctl() {
    local _GARDENCTL=$(which gardenctl)
    if [[ x$1x == xtargetx && $2 =~ (garden|seed|shoot) ]]
    then
        _OUTPUT_=$(${_GARDENCTL} $@ | grep KUBECONFIG) && export $_OUTPUT_
        unset _OUTPUT_
    else
        ${_GARDENCTL} $@
    fi
}


alias xpaste="xclip -sel col -o"
alias xcopy="xclip -sel col"
alias temperature="sensors|grep '^Core.*?°C' -P"
alias k='kubectl'
alias ks='kubectl -n kube-system '
alias kg='kubectl -n garden '
alias цд="cd"
alias лс="ls"
alias лл="ll"
alias пвд="pwd"
alias g='gardenctl'
alias watch='watch -d -c '

complete -o default -F __start_kubectl k
complete -o default -F __start_kubectl ks
complete -o default -F __start_kubectl kg
complete -o default -F __start_gardenctl g
source $HOME/.completion.d/kubectl
source $HOME/.completion.d/minikube
source $HOME/.completion.d/helm
source $HOME/.completion.d/gardenctl
source $HOME/.completion.d/kind

complete -C '/usr/local/bin/aws_completer' aws
