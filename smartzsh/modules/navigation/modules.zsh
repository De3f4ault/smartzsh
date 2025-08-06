#!/usr/bin/env zsh
# SmartZSH Navigation Module

# Module metadata
typeset -gA SMARTZSH_MODULE_INFO
SMARTZSH_MODULE_INFO[navigation:name]="Navigation"
SMARTZSH_MODULE_INFO[navigation:version]="1.0.0"
SMARTZSH_MODULE_INFO[navigation:description]="Basic directory navigation"
SMARTZSH_MODULE_INFO[navigation:deps]=""
SMARTZSH_MODULE_INFO[navigation:lazy]="true"
SMARTZSH_MODULE_INFO[navigation:trigger]="cd"

# Module initialization
smartzsh_navigation_init() {
    bindkey '^G' smartzsh_nav_cd
    smartzsh_log "debug" "Navigation module initialized"
}

# Module cleanup
smartzsh_navigation_cleanup() {
    bindkey -r '^G' 2>/dev/null
}

# Basic navigation function
smartzsh_nav_cd() {
    cd ~/
}

autoload -U smartzsh_nav_cd
