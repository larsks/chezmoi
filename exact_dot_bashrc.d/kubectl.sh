#!/bin/bash

# shellcheck disable=SC1090
. <(kubectl completion bash)

alias k=kubectl
complete -o default -F __start_kubectl k

_rebuild_kubeconfig() {
	local _kubeconfigs

	[[ -f $HOME/.kube/rebuild-kubeconfig/disable ]] && return

	# shellcheck disable=SC2086
	readarray -t _kubeconfigs < <(find $HOME/.kube/configs -name default -prune -o -type f -print)
	printf -v KUBECONFIG "%s:" "$HOME/.kube/configs/default" "${_kubeconfigs[@]}"
	export KUBECONFIG
}

_rebuild_kubeconfig

[[ $PROMPT_COMMAND =~ _rebuild_kubeconfig ]] || PROMPT_COMMAND="_rebuild_kubeconfig;${PROMPT_COMMAND:-:}"
