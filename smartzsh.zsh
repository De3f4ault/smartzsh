#!/usr/bin/env zsh
# SmartZSH - Main entry point

# Performance tracking start time
SMARTZSH_START_TIME=$(($(date +%s%N)/1000000))

# Core Paths
export SMARTZSH_HOME="${SMARTZSH_HOME:-${${(%):-%x}:A:h}}"
export SMARTZSH_CORE="$SMARTZSH_HOME/core"
export SMARTZSH_MODULES="$SMARTZSH_HOME/modules"
export SMARTZSH_THEMES="$SMARTZSH_HOME/themes"
export SMARTZSH_BIN="$SMARTZSH_HOME/bin"
export SMARTZSH_DATA_DIR="$SMARTZSH_HOME/data"
export SMARTZSH_DB_PATH="$SMARTZSH_DATA_DIR/smartzsh.sqlite" # Define DB path globally

# Load essential core components
source "$SMARTZSH_CORE/bootstrap.zsh"
source "$SMARTZSH_CORE/config.zsh"
source "$SMARTZSH_CORE/hooks.zsh"
source "$SMARTZSH_CORE/database.zsh" # NEW: Load database functions
source "$SMARTZSH_CORE/module-manager.zsh"

# Load user configuration to override defaults
if [[ -f "$SMARTZSH_CONFIG_DIR/user.zsh" ]]; then
  source "$SMARTZSH_CONFIG_DIR/user.zsh"
fi

# Load the user-selected theme
if [[ -f "$SMARTZSH_THEMES/$SMARTZSH_THEME.zsh" ]]; then
  source "$SMARTZSH_THEMES/$SMARTZSH_THEME.zsh"
fi

# The module manager starts the loading process
smartzsh_init_modules
