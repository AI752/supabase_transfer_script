#!/bin/bash

# Supabase Database Copy Script
# This script automates the process of copying a Supabase database from one project to another
# Author: Generated for Supabase database duplication
# Usage: ./supabase_db_copy.sh

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

# Function to check Docker status
check_docker() {
    if ! docker info >/dev/null 2>&1; then
        print_error "Docker is not running. Please start Docker Desktop and try again."
        exit 1
    fi
    print_success "Docker is running"
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

# Function to install required packages
install_requirements() {
    print_status "Checking and installing required packages..."
    
    # Detect operating system
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        print_status "macOS detected, using Homebrew..."
        
        # Check if Homebrew is installed
        if ! command_exists brew; then
            print_status "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            
            # Add Homebrew to PATH for this session
            if [[ -f "/opt/homebrew/bin/brew" ]]; then
                eval "$(/opt/homebrew/bin/brew shellenv)"
            elif [[ -f "/usr/local/bin/brew" ]]; then
                eval "$(/usr/local/bin/brew shellenv)"
            fi
            
            # Add to shell profile for future sessions
            if [[ -f "$HOME/.zprofile" ]]; then
                echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
            elif [[ -f "$HOME/.bash_profile" ]]; then
                echo 'eval "$(/usr/local/bin/brew shellenv)"' >> "$HOME/.bash_profile"
            fi
        else
            print_success "Homebrew is already installed"
        fi
        
        # Install required packages for macOS
        local packages=("curl" "wget" "postgresql")
        
        for package in "${packages[@]}"; do
            if ! command_exists "$package"; then
                print_status "Installing $package..."
                brew install "$package"
            else
                print_success "$package is already installed"
            fi
        done
        
    else
        # Linux (Ubuntu/Debian)
        print_status "Linux detected, using apt..."
        
        # Update package list
        sudo apt-get update
        
        # Install required packages
        local packages=("curl" "wget" "unzip" "postgresql-client")
        
        for package in "${packages[@]}"; do
            if ! command_exists "$package"; then
                print_status "Installing $package..."
                sudo apt-get install -y "$package"
            else
                print_success "$package is already installed"
            fi
        done
        
        # Install Homebrew if not present (for Supabase CLI)
        if ! command_exists brew; then
            print_status "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            
            # Add Homebrew to PATH for this session
            eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
            
            # Add to .bashrc for future sessions
            echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
        else
            print_success "Homebrew is already installed"
        fi
    fi
    
    # Install Supabase CLI if not present
    if ! command_exists supabase; then
        print_status "Installing Supabase CLI..."
        brew install supabase/tap/supabase
    else
        print_success "Supabase CLI is already installed"
    fi
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
    echo "  -s, --source   Source database URL"
    echo "  -t, --target   Target database URL"
    echo "  -k, --keep     Keep temporary files after completion"
    echo
    echo "Examples:"
    echo "  $0"
    echo "  $0 -s 'postgresql://user:pass@host:port/db' -t 'postgresql://user:pass@host:port/db'"
    echo
}

# Main function
main() {
    local KEEP_FILES=false
    local SOURCE_DB_URL=""
    local TARGET_DB_URL=""
    
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
            *)
                print_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done
    
    echo "=========================================="
    echo "    Supabase Database Copy Script"
    echo "=========================================="
    echo
    
    # Check if running as root
    if [[ $EUID -eq 0 ]]; then
        print_error "This script should not be run as root"
        exit 1
    fi
    
    # Install requirements
    install_requirements
    
    # Check Docker
    check_docker
    
    # Check Supabase CLI login
    check_supabase_login
    
    # Always get database URLs interactively (command line args are for advanced users)
    get_database_urls
    
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