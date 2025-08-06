# SmartZSH - History Module (SQLite-backed)

# Zsh history configuration (still relevant for in-session history)
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history_session" # Use a separate session file
[ "$HISTSIZE" -lt 50000 ] && HISTSIZE=50000
[ "$SAVEHIST" -lt 10000 ] && SAVEHIST=10000

setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt share_history

# Function to record command to SQLite database
sz_history_record_command() {
    local command="$1"
    local exit_code="$2"
    local duration_ms="$3"
    local timestamp=$(($(sz_timestamp)))
    local cwd="$PWD"

    # Insert into SQLite
    sz_db_exec "INSERT INTO command_history (command, timestamp, cwd, exit_code, duration_ms) VALUES (?, ?, ?, ?, ?);" \
        "$command" "$timestamp" "$cwd" "$exit_code" "$duration_ms"
}

# Function to retrieve history from SQLite
# Usage: sz_history_search "keyword" [limit]
sz_history_search() {
    local keyword="$1"
    local limit="${2:-10}" # Default limit to 10
    local sql="SELECT command, datetime(timestamp / 1000, 'unixepoch'), cwd, exit_code, duration_ms FROM command_history WHERE command LIKE ? ORDER BY timestamp DESC LIMIT ?;"
    sz_db_query "$sql" "%${keyword}%" "$limit"
}

# Hooks for command recording
_sz_history_precmd() {
    # Store start time before command execution
    SMARTZSH_COMMAND_START_TIME=$(($(sz_timestamp)))
}

_sz_history_preexec() {
    # Capture command line before execution
    SMARTZSH_LAST_COMMAND="$1"
}

_sz_history_postcmd() {
    # Calculate duration and record to DB
    local end_time=$(($(sz_timestamp)))
    local duration_ms=$((end_time - SMARTZSH_COMMAND_START_TIME))
    sz_history_record_command "$SMARTZSH_LAST_COMMAND" "$?" "$duration_ms"
}

# Add hooks
sz_add_hook precmd_functions "_sz_history_precmd"
sz_add_hook preexec_functions "_sz_history_preexec"
sz_add_hook postcmd_functions "_sz_history_postcmd"

# Alias for searching history
alias hists='sz_history_search'
