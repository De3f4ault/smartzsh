#!/usr/bin/env zsh
# SmartZSH Hooks System

smartzsh_trigger_hook() {
    local event="$1"
    shift

    local hook
    for hook in "${SMARTZSH_HOOKS[$event][@]}"; do
        $hook "$@"
    done
}

smartzsh_hook_register() {
    local event="$1" hook="$2"
    SMARTZSH_HOOKS[$event]+=("$(typeset -f $hook)")
}
