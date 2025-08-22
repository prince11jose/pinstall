# PInstall - Cross-Platform Package Installer
# PowerShell version for Windows
# Author: MovingWalls Personal
# Version: 1.0.0

param(
    [switch]$Win,
    [switch]$X64,
    [switch]$Arm64,
    [switch]$X86,
    [string]$App,
    [string]$Ver,
    [switch]$Help
)

# Colors for output
$script:Red = "Red"
$script:Green = "Green"
$script:Yellow = "Yellow"
$script:Blue = "Blue"

# Global variables
$script:OS = ""
$script:Arch = ""
$script:Application = ""
$script:Version = ""
$script:InstallDir = ""
$script:TempDir = "$env:TEMP\pinstall"

# Function to print colored output
function Write-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor $script:Blue
}

function Write-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor $script:Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor $script:Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor $script:Red
    exit 1
}

# Function to show usage
function Show-Usage {
    @"
PInstall - Cross-Platform Package Installer (Windows)

Usage: .\pinstall.ps1 [OPTIONS]

OPTIONS:
    -Win                   Target Windows operating system
    -X64                   x86_64 architecture
    -Arm64                 ARM64 architecture
    -X86                   x86 architecture
    -App <name>            Application to install (go, node, python, docker, git)
    -Ver <version>         Version to install
    -Help                  Show this help message

Examples:
    .\pinstall.ps1 -Win -X64 -App go -Ver 1.24.4
    .\pinstall.ps1 -Win -Arm64 -App node -Ver 20.10.0
    .\pinstall.ps1 -Win -X64 -App python -Ver 3.12.0

Supported Applications:
    - go: Go programming language
    - node: Node.js runtime
    - python: Python interpreter
    - docker: Docker Desktop
    - git: Git for Windows
"@
}

# Function to parse command line arguments
function Parse-Args {
    param([string[]]$Args)
    
    for ($i = 0; $i -lt $Args.Length; $i++) {
        switch ($Args[$i]) {
            "--win" { $script:OS = "win" }
            "--x64" { $script:Arch = "x64" }
            "--arm64" { $script:Arch = "arm64" }
            "--x86" { $script:Arch = "x86" }
            { $_ -like "--app=*" } { $script:Application = ($_ -split "=")[1] }
            { $_ -like "--ver=*" } { $script:Version = ($_ -split "=")[1] }
            "--help" { Show-Usage; exit 0 }
            default { Write-Error "Unknown option: $_" }
        }
    }
    
    # Also handle PowerShell-style parameters
    if ($Win) { $script:OS = "win" }
    if ($X64) { $script:Arch = "x64" }
    if ($Arm64) { $script:Arch = "arm64" }
    if ($X86) { $script:Arch = "x86" }
    if ($App) { $script:Application = $App }
    if ($Ver) { $script:Version = $Ver }
    if ($Help) { Show-Usage; exit 0 }
}

# Function to validate arguments
function Test-Args {
    if (-not $script:OS) {
        Write-Error "Operating system not specified. Use -Win"
    }
    
    if (-not $script:Arch) {
        Write-Error "Architecture not specified. Use -X64, -Arm64, or -X86"
    }
    
    if (-not $script:Application) {
        Write-Error "Application not specified. Use -App <name>"
    }
    
    if (-not $script:Version) {
        Write-Error "Version not specified. Use -Ver <version>"
    }
}

# Function to detect system if not specified
function Get-SystemInfo {
    if (-not $script:OS) {
        $script:OS = "win"
    }
    
    if (-not $script:Arch) {
        switch ($env:PROCESSOR_ARCHITECTURE) {
            "AMD64" { $script:Arch = "x64" }
            "ARM64" { $script:Arch = "arm64" }
            "x86" { $script:Arch = "x86" }
            default { Write-Error "Unsupported architecture: $env:PROCESSOR_ARCHITECTURE" }
        }
    }
}

# Function to setup installation directory
function Initialize-InstallDir {
    $script:InstallDir = "$env:USERPROFILE\.local"
    
    if (-not (Test-Path $script:InstallDir)) {
        New-Item -ItemType Directory -Path $script:InstallDir -Force | Out-Null
    }
    
    if (-not (Test-Path "$script:InstallDir\bin")) {
        New-Item -ItemType Directory -Path "$script:InstallDir\bin" -Force | Out-Null
    }
    
    if (-not (Test-Path $script:TempDir)) {
        New-Item -ItemType Directory -Path $script:TempDir -Force | Out-Null
    }
}

# Function to update PATH environment variable
function Update-Path {
    $binDir = "$script:InstallDir\bin"
    $currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
    
    if ($currentPath -notlike "*$binDir*") {
        $newPath = "$binDir;$currentPath"
        [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
        Write-Info "Updated PATH environment variable"
    }
}

# Function to set environment variables for specific apps
function Set-EnvironmentVars {
    param([string]$App, [string]$InstallPath)
    
    switch ($App) {
        "go" {
            [Environment]::SetEnvironmentVariable("GOROOT", $InstallPath, "User")
            [Environment]::SetEnvironmentVariable("GOPATH", "$env:USERPROFILE\go", "User")
            
            $currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
            $goPath = "$InstallPath\bin;$env:USERPROFILE\go\bin"
            if ($currentPath -notlike "*$goPath*") {
                $newPath = "$goPath;$currentPath"
                [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
            }
            Write-Info "Set Go environment variables"
        }
        "node" {
            [Environment]::SetEnvironmentVariable("NODE_HOME", $InstallPath, "User")
            
            $currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
            $nodePath = "$InstallPath\bin"
            if ($currentPath -notlike "*$nodePath*") {
                $newPath = "$nodePath;$currentPath"
                [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
            }
            Write-Info "Set Node.js environment variables"
        }
        "python" {
            [Environment]::SetEnvironmentVariable("PYTHON_HOME", $InstallPath, "User")
            
            $currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
            $pythonPath = "$InstallPath;$InstallPath\Scripts"
            if ($currentPath -notlike "*$pythonPath*") {
                $newPath = "$pythonPath;$currentPath"
                [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
            }
            Write-Info "Set Python environment variables"
        }
    }
}

# Function to install Go
function Install-Go {
    param([string]$Version)
    
    $archName = switch ($script:Arch) {
        "x64" { "amd64" }
        "arm64" { "arm64" }
        "x86" { "386" }
        default { Write-Error "Unsupported architecture for Go: $script:Arch" }
    }
    
    $filename = "go$Version.windows-$archName.zip"
    $downloadUrl = "https://golang.org/dl/$filename"
    $installPath = "$script:InstallDir\go-$Version"
    
    Write-Info "Downloading Go $Version for windows-$archName"
    
    try {
        Invoke-WebRequest -Uri $downloadUrl -OutFile "$script:TempDir\$filename" -UseBasicParsing
    }
    catch {
        Write-Error "Failed to download Go: $_"
    }
    
    Write-Info "Installing Go to $installPath"
    
    if (Test-Path $installPath) {
        Remove-Item -Path $installPath -Recurse -Force
    }
    
    Expand-Archive -Path "$script:TempDir\$filename" -DestinationPath $script:TempDir -Force
    Move-Item -Path "$script:TempDir\go" -Destination $installPath -Force
    
    # Create symlinks to current version
    $currentGoPath = "$script:InstallDir\go"
    if (Test-Path $currentGoPath) {
        Remove-Item -Path $currentGoPath -Force -ErrorAction SilentlyContinue
    }
    
    # Create junction point (Windows equivalent of symlink for directories)
    cmd /c "mklink /J `"$currentGoPath`" `"$installPath`""
    
    # Copy executables to bin directory
    Copy-Item -Path "$installPath\bin\*.exe" -Destination "$script:InstallDir\bin\" -Force
    
    Set-EnvironmentVars -App "go" -InstallPath $installPath
    Write-Success "Go $Version installed successfully"
}

# Function to install Node.js
function Install-Node {
    param([string]$Version)
    
    $archName = switch ($script:Arch) {
        "x64" { "x64" }
        "arm64" { "arm64" }
        "x86" { "x86" }
        default { Write-Error "Unsupported architecture for Node.js: $script:Arch" }
    }
    
    $filename = "node-v$Version-win-$archName.zip"
    $downloadUrl = "https://nodejs.org/dist/v$Version/$filename"
    $installPath = "$script:InstallDir\node-$Version"
    
    Write-Info "Downloading Node.js $Version for win-$archName"
    
    try {
        Invoke-WebRequest -Uri $downloadUrl -OutFile "$script:TempDir\$filename" -UseBasicParsing
    }
    catch {
        Write-Error "Failed to download Node.js: $_"
    }
    
    Write-Info "Installing Node.js to $installPath"
    
    if (Test-Path $installPath) {
        Remove-Item -Path $installPath -Recurse -Force
    }
    
    Expand-Archive -Path "$script:TempDir\$filename" -DestinationPath $script:TempDir -Force
    $extractedPath = "$script:TempDir\node-v$Version-win-$archName"
    Move-Item -Path $extractedPath -Destination $installPath -Force
    
    # Create junction point for current version
    $currentNodePath = "$script:InstallDir\node"
    if (Test-Path $currentNodePath) {
        Remove-Item -Path $currentNodePath -Force -ErrorAction SilentlyContinue
    }
    cmd /c "mklink /J `"$currentNodePath`" `"$installPath`""
    
    # Copy executables to bin directory
    Copy-Item -Path "$installPath\node.exe" -Destination "$script:InstallDir\bin\" -Force
    Copy-Item -Path "$installPath\npm*" -Destination "$script:InstallDir\bin\" -Force -Recurse
    
    Set-EnvironmentVars -App "node" -InstallPath $installPath
    Write-Success "Node.js $Version installed successfully"
}

# Function to install Python
function Install-Python {
    param([string]$Version)
    
    Write-Info "Installing Python $Version"
    
    $archName = switch ($script:Arch) {
        "x64" { "amd64" }
        "x86" { "win32" }
        default { Write-Error "Unsupported architecture for Python: $script:Arch" }
    }
    
    $majorMinor = $Version -replace '(\d+\.\d+).*', '$1'
    $filename = "python-$Version-$archName.exe"
    $downloadUrl = "https://www.python.org/ftp/python/$Version/$filename"
    $installPath = "$script:InstallDir\python-$Version"
    
    Write-Info "Downloading Python $Version for $archName"
    
    try {
        Invoke-WebRequest -Uri $downloadUrl -OutFile "$script:TempDir\$filename" -UseBasicParsing
    }
    catch {
        Write-Error "Failed to download Python: $_"
    }
    
    Write-Info "Installing Python to $installPath"
    
    # Install Python silently
    $installArgs = @(
        "/quiet",
        "InstallAllUsers=0",
        "PrependPath=0",
        "Include_test=0",
        "TargetDir=$installPath"
    )
    
    Start-Process -FilePath "$script:TempDir\$filename" -ArgumentList $installArgs -Wait
    
    Set-EnvironmentVars -App "python" -InstallPath $installPath
    Write-Success "Python $Version installed successfully"
}

# Function to install Docker Desktop
function Install-Docker {
    Write-Info "Installing Docker Desktop"
    
    $filename = "Docker Desktop Installer.exe"
    $downloadUrl = "https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe"
    
    Write-Info "Downloading Docker Desktop"
    
    try {
        Invoke-WebRequest -Uri $downloadUrl -OutFile "$script:TempDir\$filename" -UseBasicParsing
    }
    catch {
        Write-Error "Failed to download Docker Desktop: $_"
    }
    
    Write-Info "Installing Docker Desktop (this may take a while)"
    
    # Install Docker Desktop silently
    Start-Process -FilePath "$script:TempDir\$filename" -ArgumentList "install", "--quiet" -Wait
    
    Write-Success "Docker Desktop installed successfully"
    Write-Info "Please restart your computer to complete Docker Desktop installation"
}

# Function to install Git for Windows
function Install-Git {
    Write-Info "Installing Git for Windows"
    
    $archName = switch ($script:Arch) {
        "x64" { "64-bit" }
        "x86" { "32-bit" }
        default { Write-Error "Unsupported architecture for Git: $script:Arch" }
    }
    
    # Get latest Git version from GitHub API
    try {
        $latestRelease = Invoke-RestMethod -Uri "https://api.github.com/repos/git-for-windows/git/releases/latest"
        $version = $latestRelease.tag_name -replace 'v(.+)\.windows\.\d+', '$1'
        $filename = "Git-$($latestRelease.tag_name.TrimStart('v'))-$archName.exe"
        $downloadUrl = ($latestRelease.assets | Where-Object { $_.name -eq $filename }).browser_download_url
    }
    catch {
        Write-Error "Failed to get latest Git version: $_"
    }
    
    Write-Info "Downloading Git for Windows"
    
    try {
        Invoke-WebRequest -Uri $downloadUrl -OutFile "$script:TempDir\$filename" -UseBasicParsing
    }
    catch {
        Write-Error "Failed to download Git: $_"
    }
    
    Write-Info "Installing Git for Windows"
    
    # Install Git silently with default options
    Start-Process -FilePath "$script:TempDir\$filename" -ArgumentList "/SILENT" -Wait
    
    Write-Success "Git for Windows installed successfully"
}

# Main installation function
function Install-Application {
    switch ($script:Application) {
        "go" { Install-Go -Version $script:Version }
        "node" { Install-Node -Version $script:Version }
        "python" { Install-Python -Version $script:Version }
        "docker" { Install-Docker }
        "git" { Install-Git }
        default { Write-Error "Unsupported application: $script:Application" }
    }
}

# Cleanup function
function Remove-TempFiles {
    if (Test-Path $script:TempDir) {
        Remove-Item -Path $script:TempDir -Recurse -Force
        Write-Info "Cleaned up temporary files"
    }
}

# Main function
function Main {
    param([string[]]$Arguments)
    
    Write-Info "PInstall - Cross-Platform Package Installer (Windows)"
    
    Parse-Args -Args $Arguments
    Test-Args
    Get-SystemInfo
    Initialize-InstallDir
    
    Write-Info "Target: $script:OS $script:Arch"
    Write-Info "Installing: $script:Application version $script:Version"
    
    Install-Application
    Update-Path
    Remove-TempFiles
    
    Write-Success "Installation completed successfully!"
    Write-Info "Please restart your shell or reopen your terminal to use the installed application"
}

# Run main function if script is executed directly
if ($MyInvocation.InvocationName -ne '.') {
    Main -Arguments $args
}
