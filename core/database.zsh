# SmartZSH - Core Database Functions (SQLite3)

# Ensure the database directory exists
mkdir -p "$SMARTZSH_DATA_DIR"

# Function to execute an SQL command
# Usage: sz_db_exec "SQL_COMMAND" [param1] [param2]...
sz_db_exec() {
    local sql="$1"
    shift
    local params=("$@")
    local param_str=""

    # Build parameter string for sqlite3
    for p in "${params[@]}"; do
        param_str+=" \"${p}\""
    done

    # Execute SQL command
    # Using printf and eval to handle parameters safely with sqlite3
    # This is a common pattern for passing parameters to sqlite3 via shell
    eval "printf '%s\n' \"\$sql\" | sqlite3 -batch \"\$SMARTZSH_DB_PATH\" ${param_str}"
}

# Function to query data from SQLite
# Usage: sz_db_query "SQL_QUERY" [param1] [param2]...
# Returns results line by line to stdout
sz_db_query() {
    local sql="$1"
    shift
    local params=("$@")
    local param_str=""

    for p in "${params[@]}"; do
        param_str+=" \"${p}\""
    done

    eval "printf '%s\n' \"\$sql\" | sqlite3 -batch -column -header \"\$SMARTZSH_DB_PATH\" ${param_str}"
}

# Function to initialize database schema (called by install.sh)
# This function is primarily for internal use by the installer to ensure schema exists.
# It's included here for completeness but the actual schema creation is in install.sh
sz_db_init_schema() {
    # This function is a placeholder. The actual schema creation
    # is handled by the install.sh script for initial setup.
    # We can add schema migration logic here if needed for future updates.
    :
}
