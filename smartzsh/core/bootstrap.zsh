#!/usr/bin/env zsh
# SmartZSH Core Bootstrap

# Global state management
typeset -gA SMARTZSH_STATE SMARTZSH_MODULES SMARTZSH_HOOKS SMARTZSH_CONFIG
typeset -ga SMARTZSH_LOAD_ORDER

# Load configuration
smartzsh_load_config() {
    local config_file
    for config_file in $SMARTZSH_CONFIG_FILES; do
        [[ -r "$config_file" ]] && source "$config_file"
    done

    # Set defaults
    SMARTZSH_CONFIG[profile]="${SMARTZSH_CONFIG[profile]:-minimal}"
    SMARTZSH_CONFIG[theme]="${SMARTZSH_CONFIG[theme]:-default}"
    SMARTZSH_CONFIG[log_level]="${SMARTZSH_CONFIG[log_level]:-info}"
}

# Load core components
smartzsh_load_core() {
    local core_files=(
        "utils.zsh"
        "logger.zsh"
        "performance.zsh"
        "hooks.zsh"
        "module-manager.zsh"
        "config.zsh"
    )

    local file
    for file in $core_files; do
        source "$SMARTZSH_HOME/core/$file"
    done
}

# Load modules based on profile
smartzsh_load_modules() {
    local profile_file="$SMARTZSH_HOME/profiles/${SMARTZSH_CONFIG[profile]}.zsh"
    [[ -r "$profile_file" ]] && source "$profile_file"

    local module
    for module in ${(s:,:)SMARTZSH_CONFIG[modules]}; do
        smartzsh_module_load "$module"
    done
}

# Initialize hooks
smartzsh_init_hooks() {
    autoload -Uz add-zsh-hook
    add-zsh-hook chpwd smartzsh_on_directory_change
    add-zsh-hook preexec smartzsh_on_command_start
    add-zsh-hook precmd smartzsh_on_command_end
}

# Performance reporting
smartzsh_performance_report() {
    local end_time=$(($(date +%s%N)/1000000))
    local load_time=$((end_time - SMARTZSH_START_TIME))

    if [[ "$SMARTZSH_CONFIG[log_level]" == "debug" || $load_time -gt 500 ]]; then
        smartzsh_log "info" "SmartZSH loaded in ${load_time}ms"
    fi
}

# Stub hooks for extensibility
smartzsh_on_directory_change() { :; }
smartzsh_on_command_start() { :; }
smartzsh_on_command_end() { :; }
