SmartZSH
SmartZSH is a modular, performance-optimized ZSH framework inspired by Oh My Zsh.
Installation
curl -fsSL get.smartzsh.dev | bash
source ~/.zshrc

Usage
sz --help          # Show help
sz module list     # List modules
sz module enable git  # Enable git module
sz config set theme default  # Set theme
sz doctor          # Check installation
sz benchmark       # Measure startup time

Features

Modular architecture with lazy loading
Basic navigation, git, and completion modules
Performance optimization with caching
CLI management tool (sz)

More features coming in future phases!
