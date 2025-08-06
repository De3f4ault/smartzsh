#!/usr/bin/env zsh
# SmartZSH Configuration Engine

# Save configuration
smartzsh_config_save() {
    local config_file="$SMARTZSH_CONFIG/user.conf"
    : > "$config_file"

    local key value
    for key value in ${(kv)SMARTZSH_CONFIG}; do
        echo "SMARTZSH_CONFIG[$key]='$value'" >> "$config_file"
    done
    smartzsh_log "info" "Configuration saved to $config_file"
}

# Show configuration
smartzsh_config_show() {
    local key value
    for key value in ${(kv)SMARTZSH_CONFIG}; do
        printf "%-20s %s\n" "$key" "$value"
    done
}
