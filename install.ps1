# PInstall Remote Installation Script for Windows
# This script downloads and executes the main pinstall PowerShell script

param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Arguments
)

# Default repository URL - update this to your actual repository
$RepoUrl = "https://raw.githubusercontent.com/prince11jose/pinstall/main"

function Write-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Blue
}

function Write-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor Green
}

function Write-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
    exit 1
}

# Create temporary directory
$TempDir = "$env:TEMP\pinstall-remote"
if (-not (Test-Path $TempDir)) {
    New-Item -ItemType Directory -Path $TempDir -Force | Out-Null
}

# Download the main pinstall PowerShell script
Write-Info "Downloading pinstall.ps1 script..."
try {
    Invoke-WebRequest -Uri "$RepoUrl/pinstall.ps1" -OutFile "$TempDir\pinstall.ps1" -UseBasicParsing
}
catch {
    Write-Error "Failed to download pinstall.ps1: $_"
}

Write-Info "Executing pinstall.ps1 with arguments: $($Arguments -join ' ')"

# Execute the script with all passed arguments
try {
    & "$TempDir\pinstall.ps1" @Arguments
}
catch {
    Write-Error "Failed to execute pinstall.ps1: $_"
}

# Cleanup
Remove-Item -Path $TempDir -Recurse -Force -ErrorAction SilentlyContinue

Write-Success "Remote installation completed!"
