#!/bin/bash

# PInstall Examples
# This script demonstrates various usage examples of pinstall

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_example() {
    echo -e "${BLUE}Example:${NC} $1"
    echo -e "${YELLOW}Command:${NC} $2"
    echo ""
}

echo -e "${GREEN}PInstall Usage Examples${NC}"
echo "======================="
echo ""

print_example "Simple usage - auto-detects everything" \
    "./pinstall --app=go --ver=1.24.4"

print_example "Install Node.js - auto-detection" \
    "./pinstall --app=node --ver=20.10.0"

print_example "Install Python - auto-detection" \
    "./pinstall --app=python --ver=3.12.0"

print_example "Manual specification (if needed)" \
    "./pinstall --linux --ubuntu --arm64 --app=go --ver=1.24.4"

print_example "Specify only architecture" \
    "./pinstall --x64 --app=node --ver=20.10.0"

print_example "Install Docker - auto-detection" \
    "./pinstall --app=docker --ver=latest"

echo -e "${GREEN}Remote Installation Examples${NC}"
echo "============================"
echo ""

print_example "Remote install Go - auto-detection" \
    "curl -fsSL https://raw.githubusercontent.com/prince11jose/pinstall/main/install.sh | bash -s -- --app=go --ver=1.24.4"

print_example "Remote install Node.js - auto-detection" \
    "curl -fsSL https://raw.githubusercontent.com/prince11jose/pinstall/main/install.sh | bash -s -- --app=node --ver=20.10.0"

echo -e "${GREEN}Windows PowerShell Examples${NC}"
echo "=========================="
echo ""

print_example "Install Go on Windows x64" \
    ".\pinstall.ps1 -Win -X64 -App go -Ver 1.24.4"

print_example "Install Node.js on Windows ARM64" \
    ".\pinstall.ps1 -Win -Arm64 -App node -Ver 20.10.0"

print_example "Remote install via PowerShell" \
    "irm https://raw.githubusercontent.com/prince11jose/pinstall/main/install.ps1 | iex; pinstall-remote -Win -X64 -App go -Ver 1.24.4"

echo -e "${GREEN}Auto-detection Examples${NC}"
echo "======================="
echo ""

print_example "Let pinstall auto-detect your system" \
    "./pinstall --app=go --ver=1.24.4"

print_example "Specify only app and version (auto-detect everything else)" \
    "./pinstall --app=node --ver=20.10.0"

echo ""
echo -e "${BLUE}Note:${NC} The repository is now available at https://github.com/prince11jose/pinstall"
