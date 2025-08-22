#!/bin/bash

# PInstall Self-Installer
# This script installs the pinstall package manager itself

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

REPO_URL="https://raw.githubusercontent.com/prince11jose/pinstall/main"

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

show_usage() {
    cat << EOF
PInstall Self-Installer

Usage: $0 [OPTIONS]

OPTIONS:
    --system        Install system-wide to /usr/local/bin (requires sudo)
    --user          Install to ~/.local/bin (default)
    --help          Show this help message

Examples:
    $0                    # Install to ~/.local/bin
    $0 --user            # Install to ~/.local/bin
    $0 --system          # Install to /usr/local/bin (requires sudo)

After installation, you can use:
    pinstall --linux --ubuntu --x64 --app=go --ver=1.24.4
EOF
}

install_system() {
    print_info "Installing pinstall system-wide to /usr/local/bin..."
    
    if ! command -v sudo >/dev/null 2>&1; then
        print_error "sudo is required for system-wide installation"
    fi
    
    curl -fsSL "$REPO_URL/pinstall" -o /tmp/pinstall
    sudo mv /tmp/pinstall /usr/local/bin/pinstall
    sudo chmod +x /usr/local/bin/pinstall
    
    print_success "pinstall installed to /usr/local/bin/pinstall"
    print_info "You can now use 'pinstall' from anywhere"
}

install_user() {
    print_info "Installing pinstall to ~/.local/bin..."
    
    mkdir -p "$HOME/.local/bin"
    curl -fsSL "$REPO_URL/pinstall" -o "$HOME/.local/bin/pinstall"
    chmod +x "$HOME/.local/bin/pinstall"
    
    print_success "pinstall installed to ~/.local/bin/pinstall"
    
    # Check if ~/.local/bin is in PATH
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        print_warning "~/.local/bin is not in your PATH"
        print_info "Add the following to your ~/.bashrc or ~/.zshrc:"
        echo ""
        echo "    export PATH=\"\$HOME/.local/bin:\$PATH\""
        echo ""
        print_info "Or run: echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.bashrc"
        print_info "Then restart your shell or run: source ~/.bashrc"
    else
        print_info "You can now use 'pinstall' from anywhere"
    fi
}

verify_installation() {
    local install_path="$1"
    
    if [[ -f "$install_path" && -x "$install_path" ]]; then
        print_info "Verifying installation..."
        if "$install_path" --help >/dev/null 2>&1; then
            print_success "Installation verified successfully!"
            echo ""
            print_info "Try it out:"
            echo "    pinstall --help"
            echo "    pinstall --linux --ubuntu --x64 --app=go --ver=1.24.4"
        else
            print_error "Installation verification failed"
        fi
    else
        print_error "Installation failed - pinstall not found at $install_path"
    fi
}

main() {
    local install_type="user"
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --system)
                install_type="system"
                shift
                ;;
            --user)
                install_type="user"
                shift
                ;;
            --help)
                show_usage
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                ;;
        esac
    done
    
    echo -e "${GREEN}PInstall Self-Installer${NC}"
    echo "======================"
    echo ""
    
    # Check for curl
    if ! command -v curl >/dev/null 2>&1; then
        print_error "curl is required but not installed. Please install curl and try again."
    fi
    
    case "$install_type" in
        "system")
            install_system
            verify_installation "/usr/local/bin/pinstall"
            ;;
        "user")
            install_user
            verify_installation "$HOME/.local/bin/pinstall"
            ;;
        *)
            print_error "Invalid installation type: $install_type"
            ;;
    esac
    
    echo ""
    print_success "PInstall installation completed!"
    print_info "Visit https://github.com/prince11jose/pinstall for documentation and examples"
}

main "$@"
