#!/usr/bin/env zsh
# SmartZSH - Intelligent Terminal Framework
# Main entry point and loader

# Performance tracking
declare -g SMARTZSH_START_TIME=$(($(date +%s%N)/1000000))

# Core paths
export SMARTZSH_HOME="${${(%):-%x}:A:h}"
export SMARTZSH_CACHE="$HOME/.cache/smartzsh"
export SMARTZSH_DATA="$HOME/.local/share/smartzsh"
export SMARTZSH_CONFIG="$HOME/.config/smartzsh"

# Create required directories
mkdir -p "$SMARTZSH_CACHE" "$SMARTZSH_DATA" "$SMARTZSH_CONFIG"

# Version and metadata
export SMARTZSH_VERSION="1.0.0"
export SMARTZSH_BUILD_DATE="$(date -Iseconds)"

# Configuration files
typeset -ga SMARTZSH_CONFIG_FILES=(
    "$SMARTZSH_HOME/config/defaults.conf"
    "$SMARTZSH_CONFIG/user.conf"
)

# Load core system
source "$SMARTZSH_HOME/core/bootstrap.zsh"

# Initialize SmartZSH
smartzsh_init() {
    smartzsh_load_config
    smartzsh_load_core
    smartzsh_load_modules
    smartzsh_init_hooks
    smartzsh_performance_report
}

# Auto-initialize unless explicitly disabled
if [[ "$SMARTZSH_AUTO_INIT" != "false" ]]; then
    smartzsh_init
fi
