# shellcheck disable=SC2034,SC2148

GIT_PS1_SHOWCOLORHINTS=1
GIT_PS1_SHOWDIRTYSTATE=1

PROMPT_COMMAND='_kube_ps1_update_cache;__git_ps1 "[\\u@\\h \\W] $(kube_ps1)" "\\$ "'
