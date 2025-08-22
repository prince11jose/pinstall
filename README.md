# PInstall - Cross-Platform Package Installer

A universal package installer for various operating systems and architectures.

## Usage

```bash
# Install Go on Amazon Linux 2023 ARM64
curl -fsSL https://raw.githubusercontent.com/your-username/pinstall/main/install.sh | bash -s -- --linux --amzn2023 --arm64 --app=go --ver=1.24.4

# Install Go on Ubuntu ARM64
curl -fsSL https://raw.githubusercontent.com/your-username/pinstall/main/install.sh | bash -s -- --linux --ubuntu --arm64 --app=go --ver=1.24.4

# Install Go on Windows x64
curl -fsSL https://raw.githubusercontent.com/your-username/pinstall/main/install.ps1 | powershell -Command "& {[ScriptBlock]::Create((New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/your-username/pinstall/main/install.ps1')).Invoke('--win', '--x64', '--app=go', '--ver=1.24.4')}"
```

## Direct Script Usage

```bash
# Clone and use locally
git clone https://github.com/your-username/pinstall.git
cd pinstall

# Linux/macOS
./pinstall --linux --ubuntu --x64 --app=go --ver=1.24.4

# Windows
.\pinstall.ps1 --win --x64 --app=go --ver=1.24.4
```

## Supported Parameters

- `--linux` / `--win` / `--mac` - Operating system
- `--ubuntu` / `--amzn2023` / `--centos` / `--debian` - Linux distribution
- `--x64` / `--arm64` / `--x86` - Architecture
- `--app=<name>` - Application to install (go, node, python, docker, etc.)
- `--ver=<version>` - Version to install

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
