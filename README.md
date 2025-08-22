# PInstall - Cross-Platform Package Installer

A simple, cross-platform package installer that works across Linux distributions, macOS, and Windows with automatic system detection and a comprehensive package repository.

## 🚀 Quick Start

### One-Line Installation

**Linux/macOS:**
```bash
curl -fsSL https://raw.githubusercontent.com/prince11jose/pinstall/main/install.sh | bash
```

**Windows (PowerShell as Administrator):**
```powershell
irm https://raw.githubusercontent.com/prince11jose/pinstall/main/install.ps1 | iex
```

### Basic Usage

```bash
# Auto-detect everything and install
pinstall --app=go --ver=1.24.4

# Search for available packages
pinstall --search=python

# Get detailed package information
pinstall --info=go

# List all available packages
pinstall --list

# Install with specific architecture
pinstall --app=node --ver=20.10.0 --x64

# Preview installation without executing
pinstall --app=docker --dry-run
```

## 📦 Repository System

PInstall includes a comprehensive package repository with metadata for popular development tools:

### Search Packages
```bash
pinstall --search=python    # Search for packages containing "python"
pinstall --search=container # Find containerization tools
pinstall --search=dev       # Find development tools
```

### Package Information
```bash
pinstall --info=go          # Detailed Go package information
pinstall --info=docker      # Docker package details and versions
pinstall --info=terraform   # Infrastructure tools info
```

### Available Categories
- **Development**: Programming languages (Go, Node.js, Python, Rust)
- **Containerization**: Docker, container tools
- **DevOps**: Kubernetes tools, deployment utilities
- **Infrastructure**: Terraform, cloud management tools
- **Version Control**: Git and related tools

## 🎯 Features

- **🔍 Package Discovery**: Search and explore available packages
- **🤖 Auto-Detection**: Automatically detects OS, distribution, and architecture
- **🚀 One-Line Install**: Install from any system with a single command
- **🔄 Cross-Platform**: Supports Linux (Ubuntu, Amazon Linux, CentOS, Debian), macOS, and Windows
- **📋 Dry Run**: Preview installations without making changes
- **🎨 Rich Output**: Colored output with clear status messages
- **📦 Repository Management**: Comprehensive package metadata and versioning
- **🔧 Environment Setup**: Automatic PATH and environment variable configuration

## 📱 Supported Applications

| Application | Description | Latest Version |
|------------|-------------|----------------|
| **Go** | Programming language | 1.24.4 |
| **Node.js** | JavaScript runtime | 22.8.0 |
| **Python** | Programming language | 3.12.1 |
| **Docker** | Container platform | 24.0.7 |
| **Git** | Version control | Latest |
| **kubectl** | Kubernetes CLI | 1.30.0 |
| **Terraform** | Infrastructure as Code | 1.9.7 |
| **Rust** | Programming language | 1.82.0 |

*View complete list with `pinstall --list`*

## 🖥️ Platform Support

### Linux Distributions
- Ubuntu (18.04+)
- Amazon Linux 2023
- CentOS/RHEL (7+)
- Debian (9+)

### Architectures
- x86_64 (x64)
- ARM64 (aarch64)
- x86 (32-bit)

### Operating Systems
- Linux (all supported distributions)
- macOS (Intel and Apple Silicon)
- Windows (PowerShell support)

## 📖 Usage Examples

### Package Discovery Workflow
```bash
# 1. Search for packages
pinstall --search=go
# Found: go, golang tools, development environments

# 2. Get detailed information
pinstall --info=go
# Shows: versions, platforms, homepage, license

# 3. Install with auto-detection
pinstall --app=go --ver=1.21.6

# 4. Verify installation
go version
```

### Advanced Installation Options
```bash
# Specify everything manually
pinstall --linux --ubuntu --x64 --app=go --ver=1.24.4

# Auto-detect OS/distro, specify architecture
pinstall --app=node --ver=20.10.0 --arm64

# Preview installation
pinstall --app=docker --dry-run

# Install latest LTS version
pinstall --app=node --ver=20.10.0  # LTS version
```

### Repository Management
```bash
# Update package repository
./repo-manager update

# Search packages locally
./repo-manager search kubernetes

# List packages by category
./repo-manager list --category=devops

# Show package details
./repo-manager info terraform
```

## 🔧 Manual Installation

If you prefer to install manually:

```bash
git clone https://github.com/prince11jose/pinstall.git
cd pinstall
chmod +x pinstall install.sh
./install.sh
```

## 🏗️ Command Reference

### Installation Commands
```bash
pinstall --app=<name> --ver=<version>    # Install specific version
pinstall --app=<name> --ver=<version> --dry-run  # Preview installation
```

### Search and Discovery
```bash
pinstall --search=<query>     # Search packages
pinstall --info=<package>     # Package details
pinstall --list              # List all packages
```

### System Options
```bash
--linux                      # Target Linux
--mac                        # Target macOS  
--ubuntu                     # Ubuntu distribution
--amzn2023                   # Amazon Linux 2023
--centos                     # CentOS distribution
--debian                     # Debian distribution
--x64                        # x86_64 architecture
--arm64                      # ARM64 architecture
--x86                        # x86 architecture
```

### Utility Options
```bash
--help                       # Show help
--dry-run                    # Preview without executing
```

## 🔒 Security Features

- Package integrity verification
- Secure download over HTTPS
- Official repository sources only
- No elevated privileges for user installations
- Transparent installation process

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'Add amazing feature'`
4. Push to branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

### Adding New Packages

Edit `repositories/packages.yml` to add new package definitions:

```yaml
my-package:
  name: "My Package"
  description: "Package description"
  homepage: "https://example.com"
  license: "MIT"
  category: "development"
  latest_version: "1.0.0"
  versions: ["1.0.0", "0.9.0"]
  platforms:
    linux:
      architectures: ["x64", "arm64"]
      # ... installation details
```

## 🐛 Troubleshooting

### Common Issues

**Permission denied:**
```bash
chmod +x pinstall
```

**Command not found after installation:**
```bash
source ~/.bashrc
# or restart your terminal
```

**Package not found:**
```bash
pinstall --search=<partial-name>  # Search for similar packages
pinstall --list                  # See all available packages
```

**Installation fails:**
```bash
pinstall --app=<name> --ver=<version> --dry-run  # Preview the installation
```

## 📊 Project Stats

- **🎯 Packages**: 50+ supported applications
- **🌍 Platforms**: Linux, macOS, Windows
- **🏗️ Architectures**: x64, ARM64, x86
- **📋 Distributions**: Ubuntu, Amazon Linux, CentOS, Debian
- **🔍 Repository**: Comprehensive package metadata
- **⚡ Performance**: Fast, lightweight installer

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Inspired by package managers like Homebrew, apt, and yum
- Built for developers who need cross-platform installations
- Community-driven package repository
