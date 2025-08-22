# PInstall Makefile
# Provides convenient commands for managing the pinstall project

.PHONY: help install test examples clean lint format check-deps setup

# Default target
help: ## Show this help message
	@echo "PInstall - Cross-Platform Package Installer"
	@echo "==========================================="
	@echo ""
	@echo "Available commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo ""

install: ## Install pinstall to /usr/local/bin (requires sudo)
	@echo "Installing pinstall to /usr/local/bin..."
	sudo cp pinstall /usr/local/bin/pinstall
	sudo chmod +x /usr/local/bin/pinstall
	@echo "✓ pinstall installed successfully"

install-user: ## Install pinstall to ~/.local/bin
	@echo "Installing pinstall to ~/.local/bin..."
	mkdir -p ~/.local/bin
	cp pinstall ~/.local/bin/pinstall
	chmod +x ~/.local/bin/pinstall
	@echo "✓ pinstall installed to ~/.local/bin"
	@echo "Note: Make sure ~/.local/bin is in your PATH"

test: ## Run the test suite
	@echo "Running pinstall test suite..."
	chmod +x test.sh
	./test.sh

examples: ## Show usage examples
	@echo "Showing pinstall examples..."
	chmod +x examples.sh
	./examples.sh

lint: ## Check shell scripts with shellcheck
	@echo "Linting shell scripts..."
	@if command -v shellcheck >/dev/null 2>&1; then \
		shellcheck pinstall install.sh examples.sh test.sh; \
		echo "✓ Linting completed"; \
	else \
		echo "⚠ shellcheck not found. Install it with: apt install shellcheck"; \
	fi

format: ## Format shell scripts with shfmt
	@echo "Formatting shell scripts..."
	@if command -v shfmt >/dev/null 2>&1; then \
		shfmt -w -i 4 pinstall install.sh examples.sh test.sh; \
		echo "✓ Formatting completed"; \
	else \
		echo "⚠ shfmt not found. Install it with: go install mvdan.cc/sh/v3/cmd/shfmt@latest"; \
	fi

check-deps: ## Check for required dependencies
	@echo "Checking dependencies..."
	@echo -n "curl: "; command -v curl >/dev/null 2>&1 && echo "✓" || echo "✗ (required)"
	@echo -n "tar: "; command -v tar >/dev/null 2>&1 && echo "✓" || echo "✗ (required)"
	@echo -n "gzip: "; command -v gzip >/dev/null 2>&1 && echo "✓" || echo "✗ (required)"
	@echo -n "unzip: "; command -v unzip >/dev/null 2>&1 && echo "✓" || echo "✗ (optional)"
	@echo -n "git: "; command -v git >/dev/null 2>&1 && echo "✓" || echo "✗ (optional)"
	@echo -n "shellcheck: "; command -v shellcheck >/dev/null 2>&1 && echo "✓" || echo "✗ (optional, for linting)"
	@echo -n "shfmt: "; command -v shfmt >/dev/null 2>&1 && echo "✓" || echo "✗ (optional, for formatting)"

setup: ## Setup development environment
	@echo "Setting up development environment..."
	chmod +x pinstall install.sh examples.sh test.sh
	@echo "✓ Made scripts executable"
	@if ! command -v shellcheck >/dev/null 2>&1; then \
		echo "Installing shellcheck..."; \
		if command -v apt >/dev/null 2>&1; then \
			sudo apt update && sudo apt install -y shellcheck; \
		elif command -v yum >/dev/null 2>&1; then \
			sudo yum install -y epel-release && sudo yum install -y ShellCheck; \
		elif command -v brew >/dev/null 2>&1; then \
			brew install shellcheck; \
		else \
			echo "⚠ Please install shellcheck manually"; \
		fi; \
	fi
	@echo "✓ Development environment setup completed"

clean: ## Clean temporary files and caches
	@echo "Cleaning temporary files..."
	rm -rf /tmp/pinstall*
	rm -rf ~/.cache/pinstall*
	@echo "✓ Cleanup completed"

release: ## Create a release package
	@echo "Creating release package..."
	mkdir -p release
	cp pinstall pinstall.ps1 install.sh install.ps1 config.yml README.md release/
	tar -czf release/pinstall-$(shell date +%Y%m%d).tar.gz -C release .
	@echo "✓ Release package created in release/"

validate-go: ## Validate Go installation
	@echo "Testing Go installation..."
	./pinstall --linux --ubuntu --x64 --app=go --ver=1.24.4 --dry-run || true

validate-node: ## Validate Node.js installation  
	@echo "Testing Node.js installation..."
	./pinstall --linux --ubuntu --x64 --app=node --ver=20.10.0 --dry-run || true

validate-all: validate-go validate-node ## Validate all supported applications

# Help is the default target
.DEFAULT_GOAL := help
