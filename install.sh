#!/usr/bin/env zsh
# SmartZSH - Unified Installation Script

set -e

SMARTZSH_HOME="${ZDOTDIR:-$HOME}/.smartzsh"
SMARTZSH_CONFIG_DIR="${ZDOTDIR:-$HOME}/.config/smartzsh"
SMARTZSH_PROFILES_DIR="$SMARTZSH_HOME/profiles"
SMARTZSH_DATA_DIR="$SMARTZSH_HOME/data"
SMARTZSH_DB_PATH="$SMARTZSH_DATA_DIR/smartzsh.sqlite"

echo "🚀 Installing SmartZSH..."

# 1. Clone the repository or update if it exists
if [[ -d "$SMARTZSH_HOME" ]]; then
    echo "SmartZSH directory already exists. Updating..."
    git -C "$SMARTZSH_HOME" pull --ff-only
else
    git clone https://github.com/De3f4ault/smartzsh.git "$SMARTZSH_HOME"
fi

# 2. Create user configuration and data directories
mkdir -p "$SMARTZSH_CONFIG_DIR" "$SMARTZSH_DATA_DIR"

# 3. Create initial user config
if [[ ! -f "$SMARTZSH_CONFIG_DIR/user.zsh" ]]; then
    echo "Creating initial user configuration file..."
    cp "$SMARTZSH_PROFILES_DIR/ultimate.zsh" "$SMARTZSH_CONFIG_DIR/user.zsh"
    echo "# SmartZSH User Configuration" >> "$SMARTZSH_CONFIG_DIR/user.zsh"
    echo "# Customize your setup here." >> "$SMARTZSH_CONFIG_DIR/user.zsh"
    echo "SMARTZSH_THEME=\"default\"" >> "$SMARTZSH_CONFIG_DIR/user.zsh"
    echo "SMARTZSH_CONFIG[modules]+=(analytics)" >> "$SMARTZSH_CONFIG_DIR/user.zsh" # Enable analytics by default
fi

# 4. Initialize SQLite database and schema
if [[ ! -f "$SMARTZSH_DB_PATH" ]]; then
    echo "Initializing SmartZSH SQLite database..."
    # Ensure sqlite3 is available
    if ! command -v sqlite3 &> /dev/null; then
        echo "Error: sqlite3 command not found. Please install sqlite3 to use SmartZSH's full features."
        exit 1
    fi
    # Create tables
    sqlite3 "$SMARTZSH_DB_PATH" <<EOF
CREATE TABLE IF NOT EXISTS command_history (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    command TEXT NOT NULL,
    timestamp INTEGER NOT NULL,
    cwd TEXT NOT NULL,
    exit_code INTEGER,
    duration_ms INTEGER
);

CREATE TABLE IF NOT EXISTS directory_visits (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    path TEXT NOT NULL UNIQUE,
    visits INTEGER DEFAULT 1,
    last_visit INTEGER NOT NULL,
    created_at INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS bookmarks (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,
    path TEXT NOT NULL,
    description TEXT,
    created_at INTEGER NOT NULL,
    last_accessed INTEGER NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_command_timestamp ON command_history(timestamp);
CREATE INDEX IF NOT EXISTS idx_directory_path ON directory_visits(path);
CREATE INDEX IF NOT EXISTS idx_bookmark_name ON bookmarks(name);
EOF
    echo "SQLite database initialized at $SMARTZSH_DB_PATH"
fi

# 5. Update .zshrc to source the framework
if ! grep -q "smartzsh.zsh" "${ZDOTDIR:-$HOME}/.zshrc"; then
    echo "Adding SmartZSH to ~/.zshrc..."
    echo "" >> "${ZDOTDIR:-$HOME}/.zshrc"
    echo "# SmartZSH Framework" >> "${ZDOTDIR:-$HOME}/.zshrc"
    echo "export SMARTZSH_HOME=\"\$HOME/.smartzsh\"" >> "${ZDOTDIR:-$HOME}/.zshrc"
    echo "source \"\$SMARTZSH_HOME/smartzsh.zsh\"" >> "${ZDOTDIR:-$HOME}/.zshrc"
else
    echo "SmartZSH is already sourced in ~/.zshrc."
fi

echo "✅ Installation complete. Please restart your terminal or run 'source ~/.zshrc'."
