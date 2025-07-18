#!/usr/bin/env pwsh

# Supabase Database Copy Script for Windows PowerShell
# This script automates the process of copying a Supabase database from one project to another
# Author: Generated for Supabase database duplication
# Usage: .\supabase_db_copy.ps1

param(
    [string]$SourceUrl,
    [string]$TargetUrl,
    [switch]$KeepFiles,
    [switch]$Help
)

# Set error action preference
$ErrorActionPreference = "Stop"

# Colors for output
$Red = "`e[91m"
$Green = "`e[92m"
$Yellow = "`e[93m"
$Blue = "`e[94m"
$NC = "`e[0m"

# Function to print colored output
function Write-Status {
    param([string]$Message)
    Write-Host "$Blue[INFO]$NC $Message"
}

function Write-Success {
    param([string]$Message)
    Write-Host "$Green[SUCCESS]$NC $Message"
}

function Write-Warning {
    param([string]$Message)
    Write-Host "$Yellow[WARNING]$NC $Message"
}

function Write-Error {
    param([string]$Message)
    Write-Host "$Red[ERROR]$NC $Message"
}

# Function to check if command exists
function Test-Command {
    param([string]$Command)
    return [bool](Get-Command $Command -ErrorAction SilentlyContinue)
}

# Function to check Docker status
function Test-Docker {
    try {
        docker info | Out-Null
        Write-Success "Docker is running"
        return $true
    }
    catch {
        Write-Error "Docker is not running. Please start Docker Desktop and try again."
        return $false
    }
}

# Function to check Supabase CLI login
function Test-SupabaseLogin {
    try {
        supabase status | Out-Null
        Write-Success "Supabase CLI is logged in"
        return $true
    }
    catch {
        Write-Warning "Supabase CLI not logged in. Attempting to login..."
        try {
            supabase login
            Write-Success "Supabase CLI is logged in"
            return $true
        }
        catch {
            Write-Error "Failed to login to Supabase CLI. Please login manually and try again."
            return $false
        }
    }
}

# Function to install required packages
function Install-Requirements {
    Write-Status "Checking and installing required packages..."
    
    # Check if Chocolatey is installed
    if (-not (Test-Command "choco")) {
        Write-Status "Installing Chocolatey..."
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        
        if (-not (Test-Command "choco")) {
            Write-Error "Failed to install Chocolatey"
            exit 1
        }
    } else {
        Write-Success "Chocolatey is already installed"
    }
    
    # Install required packages
    $packages = @("curl", "wget", "git")
    foreach ($package in $packages) {
        if (-not (Test-Command $package)) {
            Write-Status "Installing $package..."
            try {
                choco install $package -y --force
                if (-not (Test-Command $package)) {
                    Write-Error "Failed to install $package"
                    exit 1
                }
            } catch {
                Write-Error "Failed to install $package via Chocolatey. Please install manually."
                exit 1
            }
        } else {
            Write-Success "$package is already installed"
        }
    }
    
    # Handle PostgreSQL installation separately with better error handling
    if (-not (Test-Command "psql")) {
        Write-Status "Installing PostgreSQL..."
        try {
            # Try to clear any existing lock files
            $lockFile = "C:\ProgramData\chocolatey\lib\7db9f2ad6fec2664621a74decc94a26af08560d6"
            if (Test-Path $lockFile) {
                Write-Status "Clearing existing lock file..."
                Remove-Item $lockFile -Force -ErrorAction SilentlyContinue
            }
            
            choco install postgresql -y --force
            if (-not (Test-Command "psql")) {
                Write-Warning "PostgreSQL installation via Chocolatey failed. Trying alternative method..."
                
                # Alternative: Download PostgreSQL directly
                Write-Status "Downloading PostgreSQL directly..."
                $postgresUrl = "https://get.enterprisedb.com/postgresql/postgresql-15.4-1-windows-x64.exe"
                $installerPath = "$env:TEMP\postgresql-installer.exe"
                
                try {
                    Invoke-WebRequest -Uri $postgresUrl -OutFile $installerPath
                    Write-Status "PostgreSQL installer downloaded. Please install manually:"
                    Write-Status "1. Run: $installerPath"
                    Write-Status "2. Follow the installation wizard"
                    Write-Status "3. Add PostgreSQL to your PATH"
                    Write-Status "4. Restart this script"
                    
                    $confirm = Read-Host "Do you want to open the installer now? (y/N)"
                    if ($confirm -match "^[Yy]$") {
                        Start-Process $installerPath
                    }
                    exit 0
                } catch {
                    Write-Error "Failed to download PostgreSQL. Please install manually from: https://www.postgresql.org/download/windows/"
                    exit 1
                }
            }
        } catch {
            Write-Error "PostgreSQL installation failed. Please install manually from: https://www.postgresql.org/download/windows/"
            exit 1
        }
    } else {
        Write-Success "PostgreSQL is already installed"
    }
    
    # Install Supabase CLI if not present
    if (-not (Test-Command "supabase")) {
        Write-Status "Installing Supabase CLI..."
        choco install supabase -y
        if (-not (Test-Command "supabase")) {
            Write-Error "Failed to install Supabase CLI"
            exit 1
        }
    } else {
        Write-Success "Supabase CLI is already installed"
    }
}

# Function to validate database URL format
function Test-DatabaseUrl {
    param(
        [string]$Url,
        [string]$Name
    )
    
    if ($Url -notmatch "^postgresql://[^:]+:[^@]+@[^:]+:[0-9]+/[^?]+") {
        Write-Error "Invalid $Name database URL format. Expected format: postgresql://username:password@host:port/database"
        return $false
    }
    return $true
}

# Function to get user input
function Get-DatabaseUrls {
    Write-Host ""
    Write-Status "Please provide the database URLs for source and destination projects."
    Write-Host ""
    Write-Status "You can get these from your Supabase project dashboard:"
    Write-Status "1. Go to your Supabase project"
    Write-Status "2. Navigate to Settings → Database"
    Write-Status "3. Copy the Connection string (URI format)"
    Write-Status "4. Replace [YOUR-PASSWORD] with your actual database password"
    Write-Host ""
    
    # Get source database URL
    do {
        Write-Host "$BlueSOURCE DATABASE$NC" -NoNewline
        $script:SourceUrl = Read-Host "`nEnter SOURCE database URL (postgresql://username:password@host:port/database)"
    } while (-not (Test-DatabaseUrl $SourceUrl "source"))
    
    Write-Host ""
    
    # Get destination database URL
    do {
        Write-Host "$BlueDESTINATION DATABASE$NC" -NoNewline
        $script:TargetUrl = Read-Host "`nEnter DESTINATION database URL (postgresql://username:password@host:port/database)"
    } while (-not (Test-DatabaseUrl $TargetUrl "destination"))
    
    Write-Host ""
    Write-Status "Database URLs validated successfully"
    
    # Show summary
    Write-Host ""
    Write-Status "Summary of your configuration:"
    Write-Host "  Source: $SourceUrl"
    Write-Host "  Destination: $TargetUrl"
    Write-Host ""
    
    # Confirm before proceeding
    $confirm = Read-Host "Do you want to proceed with the database copy? (y/N)"
    if ($confirm -notmatch "^[Yy]$") {
        Write-Warning "Operation cancelled by user"
        exit 0
    }
}

# Function to create working directory
function New-WorkingDirectory {
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $script:WorkingDir = "supabase_copy_$timestamp"
    
    Write-Status "Creating working directory: $WorkingDir"
    New-Item -ItemType Directory -Path $WorkingDir -Force | Out-Null
    Set-Location $WorkingDir
    Write-Success "Working directory created: $(Get-Location)"
}

# Function to dump database
function Dump-Database {
    Write-Status "Starting database dump process..."
    
    # Dump roles
    Write-Status "Dumping database roles..."
    try {
        supabase db dump --db-url $SourceUrl -f roles.sql --role-only
        Write-Success "Roles dumped successfully"
    }
    catch {
        Write-Error "Failed to dump roles"
        exit 1
    }
    
    # Dump schema
    Write-Status "Dumping database schema..."
    try {
        supabase db dump --db-url $SourceUrl -f schema.sql
        Write-Success "Schema dumped successfully"
    }
    catch {
        Write-Error "Failed to dump schema"
        exit 1
    }
    
    # Dump data
    Write-Status "Dumping database data..."
    try {
        supabase db dump --db-url $SourceUrl -f data.sql --use-copy --data-only
        Write-Success "Data dumped successfully"
    }
    catch {
        Write-Error "Failed to dump data"
        exit 1
    }
    
    Write-Success "Database dump completed successfully"
}

# Function to upload database
function Upload-Database {
    Write-Status "Starting database upload process..."
    
    # Check if dump files exist
    $files = @("roles.sql", "schema.sql", "data.sql")
    foreach ($file in $files) {
        if (-not (Test-Path $file)) {
            Write-Error "Dump file $file not found. Please run the dump process first."
            exit 1
        }
    }
    
    Write-Status "Uploading database to destination..."
    try {
        psql --single-transaction --variable ON_ERROR_STOP=1 --file roles.sql --file schema.sql --command "SET session_replication_role = replica" --file data.sql --dbname $TargetUrl
        Write-Success "Database uploaded successfully"
    }
    catch {
        Write-Error "Failed to upload database"
        exit 1
    }
}

# Function to cleanup
function Remove-TemporaryFiles {
    Write-Status "Cleaning up temporary files..."
    Set-Location ..
    if (Test-Path $WorkingDir) {
        Remove-Item -Path $WorkingDir -Recurse -Force
        Write-Success "Cleanup completed"
    }
}

# Function to show usage
function Show-Usage {
    Write-Host "Usage: .\supabase_db_copy.ps1 [OPTIONS]"
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  -SourceUrl     Source database URL"
    Write-Host "  -TargetUrl     Target database URL"
    Write-Host "  -KeepFiles     Keep temporary files after completion"
    Write-Host "  -Help          Show this help message"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  .\supabase_db_copy.ps1"
    Write-Host "  .\supabase_db_copy.ps1 -SourceUrl 'postgresql://user:pass@host:port/db' -TargetUrl 'postgresql://user:pass@host:port/db'"
    Write-Host ""
}

# Main function
function Main {
    # Show help if requested
    if ($Help) {
        Show-Usage
        exit 0
    }
    
    Write-Host "=========================================="
    Write-Host "    Supabase Database Copy Script"
    Write-Host "=========================================="
    Write-Host ""
    
    # Install requirements
    Install-Requirements
    
    # Check Docker
    if (-not (Test-Docker)) {
        exit 1
    }
    
    # Check Supabase CLI login
    if (-not (Test-SupabaseLogin)) {
        exit 1
    }
    
    # Always get database URLs interactively (command line args are for advanced users)
    Get-DatabaseUrls
    
    # Create working directory
    New-WorkingDirectory
    
    # Perform database operations
    Dump-Database
    Upload-Database
    
    Write-Success "Database copy process completed successfully!"
    Write-Host ""
    Write-Status "Summary:"
    Write-Host "  - Source: $SourceUrl"
    Write-Host "  - Destination: $TargetUrl"
    Write-Host "  - Working directory: $WorkingDir"
    
    # Cleanup unless keep flag is set
    if (-not $KeepFiles) {
        Remove-TemporaryFiles
    } else {
        Write-Status "Temporary files kept in: $WorkingDir"
    }
    
    Write-Host ""
    Write-Success "All done! Your Supabase database has been successfully copied."
}

# Run main function
Main 