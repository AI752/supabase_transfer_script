#!/bin/bash

# Universal Supabase Database Copy Script
# This script works across Linux, macOS, and Windows (via WSL/Git Bash)
# Checks for required tools and prompts for installation if missing
# Author: Generated for Supabase database duplication
# Usage: ./supabase_db_copy_universal.sh

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to detect operating system
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [[ -f /etc/os-release ]]; then
            source /etc/os-release
            if [[ "$ID" == "ubuntu" ]] || [[ "$ID" == "debian" ]]; then
                OS="ubuntu"
            elif [[ "$ID" == "centos" ]] || [[ "$ID" == "rhel" ]] || [[ "$ID" == "fedora" ]]; then
                OS="rhel"
            else
                OS="linux"
            fi
        else
            OS="linux"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        OS="windows"
    else
        OS="unknown"
    fi
    
    print_success "Detected OS: $OS"
}

# Function to check and install curl
check_curl() {
    if ! command_exists curl; then
        print_warning "curl is not installed"
        read -p "Do you want to install curl? (y/N): " install_curl
        if [[ "$install_curl" =~ ^[Yy]$ ]]; then
            case $OS in
                "ubuntu"|"debian")
                    sudo apt-get update && sudo apt-get install -y curl
                    ;;
                "rhel"|"centos"|"fedora")
                    sudo yum install -y curl || sudo dnf install -y curl
                    ;;
                "macos")
                    if command_exists brew; then
                        brew install curl
                    else
                        print_error "Homebrew not found. Please install Homebrew first: https://brew.sh"
                        exit 1
                    fi
                    ;;
                "windows")
                    print_error "Please install curl manually on Windows"
                    print_status "Download from: https://curl.se/windows/"
                    exit 1
                    ;;
                *)
                    print_error "Please install curl manually for your OS"
                    exit 1
                    ;;
            esac
        else
            print_error "curl is required to continue"
            exit 1
        fi
    else
        print_success "curl is available"
    fi
}

# Function to check and install wget
check_wget() {
    if ! command_exists wget; then
        print_warning "wget is not installed"
        read -p "Do you want to install wget? (y/N): " install_wget
        if [[ "$install_wget" =~ ^[Yy]$ ]]; then
            case $OS in
                "ubuntu"|"debian")
                    sudo apt-get install -y wget
                    ;;
                "rhel"|"centos"|"fedora")
                    sudo yum install -y wget || sudo dnf install -y wget
                    ;;
                "macos")
                    if command_exists brew; then
                        brew install wget
                    else
                        print_error "Homebrew not found. Please install Homebrew first: https://brew.sh"
                        exit 1
                    fi
                    ;;
                "windows")
                    print_error "Please install wget manually on Windows"
                    print_status "Download from: https://eternallybored.org/misc/wget/"
                    exit 1
                    ;;
                *)
                    print_error "Please install wget manually for your OS"
                    exit 1
                    ;;
            esac
        else
            print_error "wget is required to continue"
            exit 1
        fi
    else
        print_success "wget is available"
    fi
}

# Function to check and install PostgreSQL client
check_postgresql() {
    if ! command_exists psql; then
        print_warning "PostgreSQL client is not installed"
        read -p "Do you want to install PostgreSQL client? (y/N): " install_psql
        if [[ "$install_psql" =~ ^[Yy]$ ]]; then
            case $OS in
                "ubuntu"|"debian")
                    sudo apt-get install -y postgresql-client
                    ;;
                "rhel"|"centos"|"fedora")
                    sudo yum install -y postgresql || sudo dnf install -y postgresql
                    ;;
                "macos")
                    if command_exists brew; then
                        brew install postgresql
                    else
                        print_error "Homebrew not found. Please install Homebrew first: https://brew.sh"
                        exit 1
                    fi
                    ;;
                "windows")
                    print_error "Please install PostgreSQL manually on Windows"
                    print_status "Download from: https://www.postgresql.org/download/windows/"
                    exit 1
                    ;;
                *)
                    print_error "Please install PostgreSQL client manually for your OS"
                    exit 1
                    ;;
            esac
        else
            print_error "PostgreSQL client is required to continue"
            exit 1
        fi
    else
        print_success "PostgreSQL client is available"
    fi
}

# Function to check and install Docker
check_docker() {
    if ! command_exists docker; then
        print_warning "Docker is not installed"
        read -p "Do you want to install Docker? (y/N): " install_docker
        if [[ "$install_docker" =~ ^[Yy]$ ]]; then
            case $OS in
                "ubuntu"|"debian")
                    curl -fsSL https://get.docker.com | sh
                    sudo usermod -aG docker $USER
                    print_warning "Docker installed. You may need to log out and back in for group changes to take effect."
                    print_status "Or run: newgrp docker"
                    ;;
                "rhel"|"centos"|"fedora")
                    sudo yum install -y docker || sudo dnf install -y docker
                    sudo systemctl start docker
                    sudo systemctl enable docker
                    sudo usermod -aG docker $USER
                    ;;
                "macos")
                    print_status "Please install Docker Desktop for macOS"
                    print_status "Download from: https://www.docker.com/products/docker-desktop/"
                    print_status "After installation, start Docker Desktop and run this script again"
                    exit 0
                    ;;
                "windows")
                    print_status "Please install Docker Desktop for Windows"
                    print_status "Download from: https://www.docker.com/products/docker-desktop/"
                    print_status "After installation, start Docker Desktop and run this script again"
                    exit 0
                    ;;
                *)
                    print_error "Please install Docker manually for your OS"
                    exit 1
                    ;;
            esac
        else
            print_error "Docker is required to continue"
            exit 1
        fi
    else
        print_success "Docker is available"
    fi
    
    # Check if Docker is running
    if ! docker info >/dev/null 2>&1; then
        print_error "Docker is not running"
        case $OS in
            "ubuntu"|"debian"|"rhel"|"centos"|"fedora")
                print_status "Starting Docker service..."
                sudo systemctl start docker
                ;;
            "macos"|"windows")
                print_status "Please start Docker Desktop and run this script again"
                exit 1
                ;;
        esac
    else
        print_success "Docker is running"
    fi
}

# Function to check and install Supabase CLI
check_supabase_cli() {
    if ! command_exists supabase; then
        print_warning "Supabase CLI is not installed"
        read -p "Do you want to install Supabase CLI? (y/N): " install_supabase
        if [[ "$install_supabase" =~ ^[Yy]$ ]]; then
            case $OS in
                "ubuntu"|"debian"|"rhel"|"centos"|"fedora"|"linux")
                    # Download and install Supabase CLI
                    local supabase_version=$(curl -s https://api.github.com/repos/supabase/cli/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
                    local download_url="https://github.com/supabase/cli/releases/download/${supabase_version}/supabase_linux_amd64.tar.gz"
                    
                    print_status "Downloading Supabase CLI version: $supabase_version"
                    curl -L "$download_url" -o supabase.tar.gz
                    tar -xzf supabase.tar.gz
                    sudo mv supabase /usr/local/bin/
                    rm supabase.tar.gz
                    ;;
                "macos")
                    if command_exists brew; then
                        brew install supabase/tap/supabase
                    else
                        print_error "Homebrew not found. Please install Homebrew first: https://brew.sh"
                        exit 1
                    fi
                    ;;
                "windows")
                    print_error "Please install Supabase CLI manually on Windows"
                    print_status "Download from: https://github.com/supabase/cli/releases"
                    exit 1
                    ;;
                *)
                    print_error "Please install Supabase CLI manually for your OS"
                    exit 1
                    ;;
            esac
        else
            print_error "Supabase CLI is required to continue"
            exit 1
        fi
    else
        print_success "Supabase CLI is available"
    fi
}

# Function to check all required tools
check_all_tools() {
    print_status "Checking required tools..."
    echo
    
    check_curl
    check_wget
    check_postgresql
    check_docker
    check_supabase_cli
    
    echo
    print_success "All required tools are available!"
}

# Function to check Supabase CLI login
check_supabase_login() {
    if ! supabase status >/dev/null 2>&1; then
        print_warning "Supabase CLI not logged in. Attempting to login..."
        supabase login
        if [ $? -ne 0 ]; then
            print_error "Failed to login to Supabase CLI. Please login manually and try again."
            exit 1
        fi
    fi
    print_success "Supabase CLI is logged in"
}

# Function to validate database URL format
validate_db_url() {
    local url="$1"
    local name="$2"
    
    if [[ ! "$url" =~ ^postgresql://[^:]+:[^@]+@[^:]+:[0-9]+/[^?]+ ]]; then
        print_error "Invalid $name database URL format. Expected format: postgresql://username:password@host:port/database"
        return 1
    fi
    return 0
}

# Function to get user input
get_database_urls() {
    echo
    print_status "Please provide the database URLs for source and destination projects."
    echo
    print_status "You can get these from your Supabase project dashboard:"
    print_status "1. Go to your Supabase project"
    print_status "2. Navigate to Settings → Database"
    print_status "3. Copy the Connection string (URI format)"
    print_status "4. Replace [YOUR-PASSWORD] with your actual database password"
    echo
    
    # Get source database URL
    while true; do
        echo -e "${BLUE}SOURCE DATABASE${NC}"
        read -p "Enter SOURCE database URL (postgresql://username:password@host:port/database): " SOURCE_DB_URL
        if validate_db_url "$SOURCE_DB_URL" "source"; then
            break
        fi
    done
    
    echo
    
    # Get destination database URL
    while true; do
        echo -e "${BLUE}DESTINATION DATABASE${NC}"
        read -p "Enter DESTINATION database URL (postgresql://username:password@host:port/database): " TARGET_DB_URL
        if validate_db_url "$TARGET_DB_URL" "destination"; then
            break
        fi
    done
    
    echo
    print_status "Database URLs validated successfully"
    
    # Show summary
    echo
    print_status "Summary of your configuration:"
    echo "  Source: $SOURCE_DB_URL"
    echo "  Destination: $TARGET_DB_URL"
    echo
    
    # Confirm before proceeding
    read -p "Do you want to proceed with the database copy? (y/N): " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        print_warning "Operation cancelled by user"
        exit 0
    fi
}

# Function to create working directory
create_working_dir() {
    local timestamp=$(date +"%Y%m%d_%H%M%S")
    WORKING_DIR="supabase_copy_${timestamp}"
    
    print_status "Creating working directory: $WORKING_DIR"
    mkdir -p "$WORKING_DIR"
    cd "$WORKING_DIR"
    print_success "Working directory created: $(pwd)"
}

# Function to dump database
dump_database() {
    print_status "Starting database dump process..."
    
    # Dump roles
    print_status "Dumping database roles..."
    if supabase db dump --db-url "$SOURCE_DB_URL" -f roles.sql --role-only; then
        print_success "Roles dumped successfully"
    else
        print_error "Failed to dump roles"
        exit 1
    fi
    
    # Dump schema
    print_status "Dumping database schema..."
    if supabase db dump --db-url "$SOURCE_DB_URL" -f schema.sql; then
        print_success "Schema dumped successfully"
    else
        print_error "Failed to dump schema"
        exit 1
    fi
    
    # Dump data
    print_status "Dumping database data..."
    if supabase db dump --db-url "$SOURCE_DB_URL" -f data.sql --use-copy --data-only; then
        print_success "Data dumped successfully"
    else
        print_error "Failed to dump data"
        exit 1
    fi
    
    print_success "Database dump completed successfully"
}

# Function to upload database
upload_database() {
    print_status "Starting database upload process..."
    
    # Check if dump files exist
    for file in roles.sql schema.sql data.sql; do
        if [[ ! -f "$file" ]]; then
            print_error "Dump file $file not found. Please run the dump process first."
            exit 1
        fi
    done
    
    print_status "Uploading database to destination..."
    if psql \
        --single-transaction \
        --variable ON_ERROR_STOP=1 \
        --file roles.sql \
        --file schema.sql \
        --command 'SET session_replication_role = replica' \
        --file data.sql \
        --dbname "$TARGET_DB_URL"; then
        print_success "Database uploaded successfully"
    else
        print_error "Failed to upload database"
        exit 1
    fi
}

# Function to cleanup
cleanup() {
    print_status "Cleaning up temporary files..."
    cd ..
    if [[ -d "$WORKING_DIR" ]]; then
        rm -rf "$WORKING_DIR"
        print_success "Cleanup completed"
    fi
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -s, --source   Source database URL (for advanced users)"
    echo "  -t, --target   Target database URL (for advanced users)"
    echo "  -k, --keep     Keep temporary files after completion"
    echo "  --no-docker    Skip Docker check (for headless servers)"
    echo
    echo "Examples:"
    echo "  $0"
    echo "  $0 -s 'postgresql://user:pass@host:port/db' -t 'postgresql://user:pass@host:port/db'"
    echo "  $0 --no-docker"
    echo
}

# Function to test database connection
test_connection() {
    local url="$1"
    local name="$2"
    
    print_status "Testing $name database connection..."
    if timeout 10 psql "$url" -c "SELECT 1;" >/dev/null 2>&1; then
        print_success "$name database connection successful"
        return 0
    else
        print_error "Failed to connect to $name database"
        print_status "Please check your database URL and network connectivity"
        return 1
    fi
}

# Main function
main() {
    local KEEP_FILES=false
    local SOURCE_DB_URL=""
    local TARGET_DB_URL=""
    local SKIP_DOCKER_CHECK=false
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_usage
                exit 0
                ;;
            -s|--source)
                SOURCE_DB_URL="$2"
                shift 2
                ;;
            -t|--target)
                TARGET_DB_URL="$2"
                shift 2
                ;;
            -k|--keep)
                KEEP_FILES=true
                shift
                ;;
            --no-docker)
                SKIP_DOCKER_CHECK=true
                shift
                ;;
            *)
                print_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done
    
    echo "=========================================="
    echo "    Universal Supabase Database Copy Script"
    echo "=========================================="
    echo
    
    # Check if running as root
    if [[ $EUID -eq 0 ]]; then
        print_error "This script should not be run as root"
        exit 1
    fi
    
    # Detect OS
    detect_os
    
    # Check all required tools
    check_all_tools
    
    # Check Docker (unless skipped)
    if [[ "$SKIP_DOCKER_CHECK" == false ]]; then
        check_docker
    else
        print_warning "Docker check skipped"
    fi
    
    # Check Supabase CLI login
    check_supabase_login
    
    # Get database URLs
    if [[ -z "$SOURCE_DB_URL" ]] || [[ -z "$TARGET_DB_URL" ]]; then
        get_database_urls
    else
        # Validate provided URLs
        if ! validate_db_url "$SOURCE_DB_URL" "source"; then
            exit 1
        fi
        if ! validate_db_url "$TARGET_DB_URL" "destination"; then
            exit 1
        fi
        
        print_status "Using provided database URLs"
        print_status "Source: $SOURCE_DB_URL"
        print_status "Destination: $TARGET_DB_URL"
        echo
        
        # Test connections
        if ! test_connection "$SOURCE_DB_URL" "source"; then
            exit 1
        fi
        if ! test_connection "$TARGET_DB_URL" "destination"; then
            exit 1
        fi
        
        # Confirm before proceeding
        read -p "Do you want to proceed with the database copy? (y/N): " confirm
        if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
            print_warning "Operation cancelled by user"
            exit 0
        fi
    fi
    
    # Create working directory
    create_working_dir
    
    # Perform database operations
    dump_database
    upload_database
    
    print_success "Database copy process completed successfully!"
    echo
    print_status "Summary:"
    echo "  - Source: $SOURCE_DB_URL"
    echo "  - Destination: $TARGET_DB_URL"
    echo "  - Working directory: $WORKING_DIR"
    
    # Cleanup unless keep flag is set
    if [[ "$KEEP_FILES" == false ]]; then
        cleanup
    else
        print_status "Temporary files kept in: $WORKING_DIR"
    fi
    
    echo
    print_success "All done! Your Supabase database has been successfully copied."
}

# Trap to handle cleanup on script exit
trap cleanup EXIT

# Run main function with all arguments
main "$@" 