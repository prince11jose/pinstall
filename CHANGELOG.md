# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-08-22

### Added
- Initial release of PInstall
- Cross-platform support for Linux, macOS, and Windows
- Support for multiple architectures (x64, ARM64, x86)
- Support for installing Go, Node.js, Python, Docker, and Git
- Automatic system detection
- Environment variable configuration
- Remote installation via curl/PowerShell
- Comprehensive test suite
- CI/CD pipeline with GitHub Actions
- Shell script linting and formatting
- Makefile for easy project management
- Configuration file for application definitions
- Examples and documentation

### Supported Applications
- **Go**: All versions, cross-platform
- **Node.js**: All LTS versions, cross-platform  
- **Python**: Distribution package manager installation
- **Docker**: Docker Desktop for Windows/macOS, Docker CE for Linux
- **Git**: Git for Windows, package manager for Linux/macOS

### Supported Platforms
- **Linux**: Ubuntu, Amazon Linux 2023, CentOS, Debian
- **macOS**: Intel and Apple Silicon
- **Windows**: PowerShell support

### Features
- Automatic architecture detection
- Version management and multiple version support
- Clean installation and environment setup
- PATH and environment variable management
- Temporary file cleanup
- Comprehensive error handling
- Colored terminal output
- Dry-run capabilities (planned)

## [Unreleased]

### Planned
- Support for additional applications (kubectl, terraform, helm, etc.)
- Version listing and management
- Uninstall functionality
- Configuration file customization
- Package verification and checksums
- Parallel downloads
- Progress bars for downloads
- Package caching
- Custom installation directories
- Package dependencies resolution
