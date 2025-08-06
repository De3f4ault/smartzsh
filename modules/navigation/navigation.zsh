# SmartZSH - Navigation Module (SQLite-backed)

# Function to update directory visit count in SQLite for 'z' functionality
sz_navigation_record_visit() {
    local path="$1"
    local timestamp=$(($(sz_timestamp)))

    # UPSERT: Insert if not exists, update if exists
    sz_db_exec "INSERT INTO directory_visits (path, visits, last_visit, created_at) VALUES (?, 1, ?, ?)
                ON CONFLICT(path) DO UPDATE SET visits = visits + 1, last_visit = ?;" \
                "$path" "$timestamp" "$timestamp" "$timestamp"
}

# Function for smart directory jumping (inspired by z.sh)
sz_z() {
    local search_term="$1"
    if [[ -z "$search_term" ]]; then
        # If no argument, list recent visits
        sz_db_query "SELECT path, visits, datetime(last_visit / 1000, 'unixepoch') FROM directory_visits ORDER BY last_visit DESC LIMIT 20;"
        return 0
    fi

    local target_path
    # Find the best match based on visits and recency
    target_path=$(sz_db_query "SELECT path FROM directory_visits WHERE path LIKE ? ORDER BY visits DESC, last_visit DESC LIMIT 1;" "%${search_term}%")

    if [[ -n "$target_path" && -d "$target_path" ]]; then
        builtin cd "$target_path"
    else
        echo "No matching directory found: $search_term" >&2
        return 1
    fi
}

# Function to add a bookmark
sz_bookmark_add() {
    local name="$1"
    local path="${2:-$PWD}"
    local description="$3"
    local timestamp=$(($(sz_timestamp)))

    sz_db_exec "INSERT INTO bookmarks (name, path, description, created_at, last_accessed) VALUES (?, ?, ?, ?, ?)
                ON CONFLICT(name) DO UPDATE SET path = ?, description = ?, last_accessed = ?;" \
                "$name" "$path" "$description" "$timestamp" "$timestamp" \
                "$path" "$description" "$timestamp"
    echo "Bookmark '$name' added/updated for '$path'."
}

# Function to jump to a bookmark
sz_bookmark_jump() {
    local name="$1"
    local path
    path=$(sz_db_query "SELECT path FROM bookmarks WHERE name = ? LIMIT 1;" "$name")

    if [[ -n "$path" && -d "$path" ]]; then
        builtin cd "$path"
        sz_db_exec "UPDATE bookmarks SET last_accessed = ? WHERE name = ?;" "$(($(sz_timestamp)))" "$name"
    else
        echo "Bookmark '$name' not found or path does not exist." >&2
        return 1
    fi
}

# Function to list bookmarks
sz_bookmark_list() {
    sz_db_query "SELECT name, path, description, datetime(last_accessed / 1000, 'unixepoch') FROM bookmarks ORDER BY name;"
}

# Function to delete a bookmark
sz_bookmark_delete() {
    local name="$1"
    sz_db_exec "DELETE FROM bookmarks WHERE name = ?;" "$name"
    echo "Bookmark '$name' deleted."
}

# Hook for directory visit tracking
_sz_navigation_chpwd() {
    sz_navigation_record_visit "$PWD"
}

# Add chpwd hook
sz_add_hook chpwd_functions "_sz_navigation_chpwd"

# Aliases
alias z='sz_z'
alias mark='sz_bookmark_add'
alias jump='sz_bookmark_jump'
alias bookmarks='sz_bookmark_list'
alias unmark='sz_bookmark_delete'
