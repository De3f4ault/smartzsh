#!/usr/bin/env bash

# Create SmartZSH directory structure
set -e

ROOT_DIR="smartzsh"

# Main files
mkdir -p "$ROOT_DIR"
touch "$ROOT_DIR/smartzsh.zsh"
touch "$ROOT_DIR/install.sh"

# Binary
mkdir -p "$ROOT_DIR/bin"
touch "$ROOT_DIR/bin/sz"
chmod +x "$ROOT_DIR/bin/sz"

# Core system
mkdir -p "$ROOT_DIR/core"
for file in bootstrap.zsh module-manager.zsh config.zsh hooks.zsh performance.zsh logger.zsh utils.zsh ai.zsh; do
  touch "$ROOT_DIR/core/$file"
done

# Modules
MODULES=(
  navigation history aliases git completions 
  environment files system development visual analytics
)
for module in "${MODULES[@]}"; do
  mkdir -p "$ROOT_DIR/modules/$module"
done

# Themes
mkdir -p "$ROOT_DIR/themes"
for theme in default.zsh minimal.zsh powerline.zsh tokyo-night.zsh; do
  touch "$ROOT_DIR/themes/$theme"
done

# Profiles
mkdir -p "$ROOT_DIR/profiles"
for profile in developer.zsh sysadmin.zsh minimal.zsh data-scientist.zsh; do
  touch "$ROOT_DIR/profiles/$profile"
done

# Data directories
mkdir -p "$ROOT_DIR/data/learning"
mkdir -p "$ROOT_DIR/data/cache"
mkdir -p "$ROOT_DIR/data/stats"

# Config
mkdir -p "$ROOT_DIR/config"
touch "$ROOT_DIR/config/defaults.conf"
touch "$ROOT_DIR/config/user.conf.example"

# Documentation
mkdir -p "$ROOT_DIR/docs"
for doc in README.md MODULES.md API.md PERFORMANCE.md; do
  touch "$ROOT_DIR/docs/$doc"
done

# Tests
mkdir -p "$ROOT_DIR/tests/core"
mkdir -p "$ROOT_DIR/tests/modules"
mkdir -p "$ROOT_DIR/tests/integration"

# Add basic README content
cat > "$ROOT_DIR/docs/README.md" << 'EOF'
# SmartZSH

The intelligent ZSH framework that learns from your workflow.

## Features
- AI-powered command suggestions
- Context-aware automation
- Modular architecture
- Performance optimized
EOF

# Make install.sh executable
chmod +x "$ROOT_DIR/install.sh"

echo "✅ SmartZSH directory structure created at: $ROOT_DIR"
tree -a "$ROOT_DIR"
