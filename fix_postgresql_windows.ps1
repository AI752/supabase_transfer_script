# PostgreSQL Installation Fix for Windows
# This script helps resolve common PostgreSQL installation issues on Windows

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "    PostgreSQL Installation Fix" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Function to check if command exists
function Test-Command {
    param([string]$Command)
    return [bool](Get-Command $Command -ErrorAction SilentlyContinue)
}

# Function to print colored output
function Write-Status {
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
}

# Check if PostgreSQL is already installed
if (Test-Command "psql") {
    Write-Success "PostgreSQL is already installed and working!"
    $psqlVersion = & psql --version 2>$null
    Write-Host "Version: $psqlVersion" -ForegroundColor Gray
    exit 0
}

Write-Status "PostgreSQL not found. Starting installation process..."

# Step 1: Clear Chocolatey lock files
Write-Status "Step 1: Clearing Chocolatey lock files..."
$lockFiles = @(
    "C:\ProgramData\chocolatey\lib\7db9f2ad6fec2664621a74decc94a26af08560d6",
    "C:\ProgramData\chocolatey\lib\postgresql17",
    "C:\ProgramData\chocolatey\lib\postgresql"
)

foreach ($lockFile in $lockFiles) {
    if (Test-Path $lockFile) {
        try {
            Remove-Item $lockFile -Force -Recurse -ErrorAction SilentlyContinue
            Write-Success "Cleared lock file: $lockFile"
        } catch {
            Write-Warning "Could not clear lock file: $lockFile"
        }
    }
}

# Step 2: Try Chocolatey installation
Write-Status "Step 2: Attempting Chocolatey installation..."
try {
    choco install postgresql -y --force
    if (Test-Command "psql") {
        Write-Success "PostgreSQL installed successfully via Chocolatey!"
        exit 0
    }
} catch {
    Write-Warning "Chocolatey installation failed"
}

# Step 3: Manual download and installation
Write-Status "Step 3: Downloading PostgreSQL installer..."
$postgresUrl = "https://get.enterprisedb.com/postgresql/postgresql-15.4-1-windows-x64.exe"
$installerPath = "$env:TEMP\postgresql-installer.exe"

try {
    Write-Status "Downloading from: $postgresUrl"
    Invoke-WebRequest -Uri $postgresUrl -OutFile $installerPath -UseBasicParsing
    Write-Success "Download completed: $installerPath"
    
    Write-Host ""
    Write-Status "PostgreSQL installer downloaded successfully!"
    Write-Status "Please follow these steps:"
    Write-Host ""
    Write-Host "1. Run the installer:" -ForegroundColor White
    Write-Host "   $installerPath" -ForegroundColor Gray
    Write-Host ""
    Write-Host "2. During installation:" -ForegroundColor White
    Write-Host "   - Use default port (5432)" -ForegroundColor Gray
    Write-Host "   - Set a password for postgres user" -ForegroundColor Gray
    Write-Host "   - Keep default installation directory" -ForegroundColor Gray
    Write-Host "   - Check 'Add to PATH' option" -ForegroundColor Gray
    Write-Host ""
    Write-Host "3. After installation:" -ForegroundColor White
    Write-Host "   - Restart your terminal/PowerShell" -ForegroundColor Gray
    Write-Host "   - Run this script again to verify installation" -ForegroundColor Gray
    Write-Host ""
    
    $confirm = Read-Host "Do you want to open the installer now? (y/N)"
    if ($confirm -match "^[Yy]$") {
        Write-Status "Opening PostgreSQL installer..."
        Start-Process $installerPath
    }
    
} catch {
    Write-Error "Failed to download PostgreSQL installer"
    Write-Host ""
    Write-Status "Alternative installation methods:"
    Write-Host "1. Download manually from: https://www.postgresql.org/download/windows/" -ForegroundColor Gray
    Write-Host "2. Use winget: winget install PostgreSQL.PostgreSQL" -ForegroundColor Gray
    Write-Host "3. Use Scoop: scoop install postgresql" -ForegroundColor Gray
    Write-Host ""
    Write-Status "After installation, restart this script to verify."
}

Write-Host ""
Write-Status "Script completed. Please install PostgreSQL and run this script again to verify." 