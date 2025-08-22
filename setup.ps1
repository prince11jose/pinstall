# PInstall Self-Installer for Windows PowerShell
# This script installs the pinstall package manager itself on Windows

param(
    [switch]$System,
    [switch]$User,
    [switch]$Help
)

$RepoUrl = "https://raw.githubusercontent.com/prince11jose/pinstall/main"

function Write-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Blue
}

function Write-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
    exit 1
}

function Show-Usage {
    @"
PInstall Self-Installer for Windows

Usage: .\setup.ps1 [OPTIONS]

OPTIONS:
    -System         Install system-wide (requires admin privileges)
    -User           Install for current user (default)
    -Help           Show this help message

Examples:
    .\setup.ps1                    # Install for current user
    .\setup.ps1 -User             # Install for current user
    .\setup.ps1 -System           # Install system-wide (requires admin)

After installation, you can use:
    pinstall.ps1 -Win -X64 -App go -Ver 1.24.4
"@
}

function Test-AdminPrivileges {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Install-System {
    Write-Info "Installing pinstall system-wide..."
    
    if (-not (Test-AdminPrivileges)) {
        Write-Error "Administrator privileges required for system-wide installation. Run PowerShell as Administrator."
    }
    
    $systemPath = "$env:ProgramFiles\PInstall"
    $scriptPath = "$systemPath\pinstall.ps1"
    
    # Create directory
    if (-not (Test-Path $systemPath)) {
        New-Item -ItemType Directory -Path $systemPath -Force | Out-Null
    }
    
    # Download script
    try {
        Invoke-WebRequest -Uri "$RepoUrl/pinstall.ps1" -OutFile $scriptPath -UseBasicParsing
    }
    catch {
        Write-Error "Failed to download pinstall.ps1: $_"
    }
    
    # Add to system PATH
    $envPath = [Environment]::GetEnvironmentVariable("PATH", "Machine")
    if ($envPath -notlike "*$systemPath*") {
        $newPath = "$systemPath;$envPath"
        [Environment]::SetEnvironmentVariable("PATH", $newPath, "Machine")
        Write-Info "Added $systemPath to system PATH"
    }
    
    Write-Success "pinstall installed to $scriptPath"
    Write-Info "You can now use 'pinstall.ps1' from anywhere (after restarting your shell)"
}

function Install-User {
    Write-Info "Installing pinstall for current user..."
    
    $userPath = "$env:USERPROFILE\.local\bin"
    $scriptPath = "$userPath\pinstall.ps1"
    
    # Create directory
    if (-not (Test-Path $userPath)) {
        New-Item -ItemType Directory -Path $userPath -Force | Out-Null
    }
    
    # Download script
    try {
        Invoke-WebRequest -Uri "$RepoUrl/pinstall.ps1" -OutFile $scriptPath -UseBasicParsing
    }
    catch {
        Write-Error "Failed to download pinstall.ps1: $_"
    }
    
    # Add to user PATH
    $envPath = [Environment]::GetEnvironmentVariable("PATH", "User")
    if ($envPath -notlike "*$userPath*") {
        $newPath = "$userPath;$envPath"
        [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
        Write-Info "Added $userPath to user PATH"
    }
    
    Write-Success "pinstall installed to $scriptPath"
    Write-Info "You can now use 'pinstall.ps1' from anywhere (after restarting your shell)"
}

function Test-Installation {
    param([string]$ScriptPath)
    
    if (Test-Path $ScriptPath) {
        Write-Info "Verifying installation..."
        try {
            & powershell -Command "& '$ScriptPath' -Help" | Out-Null
            Write-Success "Installation verified successfully!"
            Write-Host ""
            Write-Info "Try it out:"
            Write-Host "    pinstall.ps1 -Help"
            Write-Host "    pinstall.ps1 -Win -X64 -App go -Ver 1.24.4"
        }
        catch {
            Write-Error "Installation verification failed: $_"
        }
    }
    else {
        Write-Error "Installation failed - pinstall.ps1 not found at $ScriptPath"
    }
}

function Main {
    $installType = "User"
    
    if ($System) { $installType = "System" }
    if ($User) { $installType = "User" }
    if ($Help) { Show-Usage; exit 0 }
    
    Write-Host "PInstall Self-Installer for Windows" -ForegroundColor Green
    Write-Host "===================================" -ForegroundColor Green
    Write-Host ""
    
    switch ($installType) {
        "System" {
            Install-System
            Test-Installation "$env:ProgramFiles\PInstall\pinstall.ps1"
        }
        "User" {
            Install-User
            Test-Installation "$env:USERPROFILE\.local\bin\pinstall.ps1"
        }
        default {
            Write-Error "Invalid installation type: $installType"
        }
    }
    
    Write-Host ""
    Write-Success "PInstall installation completed!"
    Write-Info "Visit https://github.com/prince11jose/pinstall for documentation and examples"
}

Main
