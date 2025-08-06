#!/bin/bash
# SmartZSH Installation Script

SMARTZSH_REPO="https://github.com/yourusername/smartzsh.git"
SMARTZSH_HOME="$HOME/.smartzsh"
SMARTZSH_RC_LINE='source "$HOME/.smartzsh/smartzsh.zsh"'

info() { echo -e "\033[0;34m[INFO]\033[0m $1"; }
success() { echo -e "\033[0;32m[SUCCESS]\033[0m $1"; }
error() { echo -e "\033[0;31m[ERROR]\033[0m $1"; exit 1; }

check_requirements() {
    info "Checking requirements..."
    command -v zsh &> /dev/null || error "ZSH is required"
    command -v git &> /dev/null || error "Git is required"
    local zsh_version=$(zsh --version | cut -d' ' -f2)
    [[ "$(printf '%s\n' "5.8" "$zsh_version" | sort -V | head -n1)" == "5.8" ]] || {
        info "ZSH 5.8+ recommended (found $zsh_version)"
    }
    success "Requirements satisfied"
}

install_smartzsh() {
    info "Installing SmartZSH..."
    [[ -d "$SMARTZSH_HOME" ]] && {
        mv "$SMARTZSH_HOME" "$SMARTZSH_HOME.backup.$(date +%s)"
        info "Backed up existing installation"
    }
    git clone "$SMARTZSH_REPO" "$SMARTZSH_HOME" || error "Failed to clone repository"
    chmod +x "$SMARTZSH_HOME/bin/sz"
    success "SmartZSH installed to $SMARTZSH_HOME"
}

setup_shell_integration() {
    info "Setting up shell integration..."
    local path_line='export PATH="$HOME/.smartzsh/bin:$PATH"'
    if ! grep -Fxq "$SMARTZSH_RC_LINE" "$HOME/.zshrc" 2>/dev/null; then
        echo -e "\n# SmartZSH\n$path_line\n$SMARTZSH_RC_LINE" >> "$HOME/.zshrc"
        success "Added SmartZSH to .zshrc"
    else
        info "SmartZSH already configured in .zshrc"
    fi
}

initial_configuration() {
    info "Running initial configuration..."
    mkdir -p "$HOME/.config/smartzsh" "$HOME/.cache/smartzsh" "$HOME/.local/share/smartzsh"
    [[ ! -f "$HOME/.config/smartzsh/user.conf" ]] &&
        cp "$SMARTZSH_HOME/config/user.conf.example" "$HOME/.config/smartzsh/user.conf"
    success "Created default configuration"
}

main() {
    check_requirements
    install_smartzsh
    setup_shell_integration
    initial_configuration
    success "SmartZSH installation complete! Run: source ~/.zshrc"
}

case "$1" in
    --uninstall)
        info "Uninstalling SmartZSH..."
        rm -rf "$SMARTZSH_HOME"
        grep -v "$SMARTZSH_RC_LINE" "$HOME/.zshrc" > "/tmp/zshrc.tmp" && mv "/tmp/zshrc.tmp" "$HOME/.zshrc"
        success "SmartZSH uninstalled"
        ;;
    *) main "$@" ;;
esac
