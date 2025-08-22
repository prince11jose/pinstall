#!/bin/bash

# PInstall Remote Installation Script
# This script downloads and executes the main pinstall script

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default repository URL - update this to your actual repository
REPO_URL="https://raw.githubusercontent.com/prince11jose/pinstall/main"

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

# Check if curl is available
if ! command -v curl >/dev/null 2>&1; then
    print_error "curl is required but not installed. Please install curl and try again."
fi

# Create temporary directory
TEMP_DIR="/tmp/pinstall-remote"
mkdir -p "$TEMP_DIR"

# Download the main pinstall script
print_info "Downloading pinstall script..."
curl -fsSL "$REPO_URL/pinstall" -o "$TEMP_DIR/pinstall"

# Make it executable
chmod +x "$TEMP_DIR/pinstall"

print_info "Executing pinstall with arguments: $*"

# If no OS/arch arguments provided, let pinstall auto-detect
if [[ $# -eq 0 ]]; then
    print_error "No arguments provided. Usage: bash install.sh --app=<name> --ver=<version> [other options]"
fi

# Check if required arguments are present
has_app=false
has_ver=false
for arg in "$@"; do
    case $arg in
        --app=*) has_app=true ;;
        --ver=*) has_ver=true ;;
    esac
done

if [[ "$has_app" == false ]]; then
    print_error "Missing required argument: --app=<name>"
fi

if [[ "$has_ver" == false ]]; then
    print_error "Missing required argument: --ver=<version>"
fi

# Execute the script with all passed arguments
"$TEMP_DIR/pinstall" "$@"

# Cleanup
rm -rf "$TEMP_DIR"

print_success "Remote installation completed!"
