#!/usr/bin/env zsh
# SmartZSH Logger

smartzsh_log() {
    local level="$1" message="$2"
    local log_levels=(error info debug)

    # Check if level is enabled
    local current_level=${log_levels[(i)${SMARTZSH_CONFIG[log_level]}]}
    local message_level=${log_levels[(i)$level]}

    [[ $message_level -le $current_level ]] || return 0

    echo "[SMARTZSH][$level] $message" >> "$SMARTZSH_DATA/log"
    [[ "$level" == "error" ]] && echo "[ERROR] $message" >&2
}
