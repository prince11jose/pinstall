# PInstall - Cross-Platform Package Installer

A universal package installer for various operating systems and architectures.

## 🚀 Installation

### Method 1: Direct Remote Usage (Recommended)
No installation needed! Use pinstall directly via curl:

```bash
# Simple usage - auto-detects OS, distribution, and architecture
curl -fsSL https://raw.githubusercontent.com/prince11jose/pinstall/main/install.sh | bash -s -- --app=go --ver=1.24.4

# Advanced usage - specify OS and architecture manually
curl -fsSL https://raw.githubusercontent.com/prince11jose/pinstall/main/install.sh | bash -s -- --linux --ubuntu --arm64 --app=go --ver=1.24.4

# Windows PowerShell - auto-detects architecture
irm https://raw.githubusercontent.com/prince11jose/pinstall/main/install.ps1 | iex -ArgumentList "-App", "go", "-Ver", "1.24.4"
```

### Method 2: Install pinstall locally for repeated use

#### Option A: Quick Setup (Recommended)
```bash
# Linux/macOS - Install to ~/.local/bin
curl -fsSL https://raw.githubusercontent.com/prince11jose/pinstall/main/setup.sh | bash

# Linux/macOS - Install system-wide (requires sudo)
curl -fsSL https://raw.githubusercontent.com/prince11jose/pinstall/main/setup.sh | bash -s -- --system

# Windows PowerShell - Install for current user
irm https://raw.githubusercontent.com/prince11jose/pinstall/main/setup.ps1 | iex

# Windows PowerShell - Install system-wide (requires admin)
# Run PowerShell as Administrator, then:
irm https://raw.githubusercontent.com/prince11jose/pinstall/main/setup.ps1 | iex -ArgumentList "-System"
```

#### Option B: Manual installation
```bash
# Download and install to ~/.local/bin
mkdir -p ~/.local/bin
curl -fsSL https://raw.githubusercontent.com/prince11jose/pinstall/main/pinstall -o ~/.local/bin/pinstall
chmod +x ~/.local/bin/pinstall

# Add to PATH (add this to your ~/.bashrc or ~/.zshrc)
export PATH="$HOME/.local/bin:$PATH"

# Now use it anywhere - auto-detection
pinstall --app=go --ver=1.24.4

# Or specify manually if needed
pinstall --linux --ubuntu --x64 --app=go --ver=1.24.4
```

#### Option C: Clone the repository
```bash
# Clone and use locally
git clone https://github.com/prince11jose/pinstall.git
cd pinstall

# Use directly
./pinstall --linux --ubuntu --x64 --app=go --ver=1.24.4

# Or install using make
make install-user  # Install to ~/.local/bin
# OR
sudo make install  # Install to /usr/local/bin
```

### Method 3: Clone the repository
```bash
# Clone and use locally
git clone https://github.com/prince11jose/pinstall.git
cd pinstall

# Use directly - auto-detection
./pinstall --app=go --ver=1.24.4

# Or specify manually
./pinstall --linux --ubuntu --x64 --app=go --ver=1.24.4

# Or install using make
make install-user  # Install to ~/.local/bin
# OR
sudo make install  # Install to /usr/local/bin
```

## 📖 Quick Start Examples

### Remote Installation (No setup required)
```bash
# Simple usage - auto-detects your system
curl -fsSL https://raw.githubusercontent.com/prince11jose/pinstall/main/install.sh | bash -s -- --app=go --ver=1.24.4

# Install Node.js - auto-detection
curl -fsSL https://raw.githubusercontent.com/prince11jose/pinstall/main/install.sh | bash -s -- --app=node --ver=20.10.0

# Manual specification if needed
curl -fsSL https://raw.githubusercontent.com/prince11jose/pinstall/main/install.sh | bash -s -- --linux --ubuntu --arm64 --app=go --ver=1.24.4

# Windows - auto-detects architecture
irm https://raw.githubusercontent.com/prince11jose/pinstall/main/install.ps1 | iex -ArgumentList "-App", "go", "-Ver", "1.24.4"
```

### Local Installation (After installing pinstall)
```bash
# Simple usage - auto-detects OS, distribution, and architecture
pinstall --app=go --ver=1.24.4
pinstall --app=node --ver=20.10.0
pinstall --app=python --ver=3.12.0
pinstall --app=docker --ver=latest

# Manual specification if needed
pinstall --linux --ubuntu --x64 --app=go --ver=1.24.4
```

## Supported Parameters

**Required:**
- `--app=<name>` - Application to install (go, node, python, docker, git)
- `--ver=<version>` - Version to install

**Optional (auto-detected if not specified):**
- `--linux` / `--win` / `--mac` - Operating system
- `--ubuntu` / `--amzn2023` / `--centos` / `--debian` - Linux distribution
- `--x64` / `--arm64` / `--x86` - Architecture

## Supported Applications

- Go
- Node.js
- Python
- Docker
- Git
- And more...

## Features

- Cross-platform support (Linux, Windows, macOS)
- Multiple architecture support (x64, ARM64, x86)
- Automatic environment variable setup
- Version management
- Clean installation and uninstallation
