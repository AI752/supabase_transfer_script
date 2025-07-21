# Supabase Database Copy Script

This repository contains scripts to automate the process of copying a Supabase database from one project to another. It handles all the necessary installations, validations, and database operations with proper error handling.

## Available Scripts

### Universal Scripts (Recommended)
- **`supabase_db_copy_universal.sh`** - Linux (Ubuntu/CentOS/Fedora) - Checks and installs required tools
- **`supabase_db_copy_universal_mac.sh`** - macOS - Checks and installs required tools
- **`supabase_db_copy_universal.ps1`** - Windows PowerShell - Checks and installs required tools

### Legacy Scripts
- **`supabase_db_copy.sh`** - Ubuntu/Linux bash script (also works on macOS)
- **`supabase_db_copy_mac.sh`** - macOS-specific script
- **`supabase_db_copy.ps1`** - Windows PowerShell script (recommended for Windows)
- **`supabase_db_copy_simple.bat`** - Windows batch script (simplified, more reliable)
- **`supabase_db_copy.bat`** - Windows batch script (advanced version)

## Features

- ✅ **Automatic Installation**: Installs all required dependencies (Homebrew, Docker, PostgreSQL, Supabase CLI)
- ✅ **Validation**: Validates database URLs and checks system requirements
- ✅ **Error Handling**: Comprehensive error handling with colored output
- ✅ **Flexible Usage**: Supports both interactive and command-line modes
- ✅ **Cleanup**: Automatic cleanup of temporary files
- ✅ **Progress Tracking**: Clear progress indicators throughout the process

## Prerequisites

### System Requirements

#### For Linux (Ubuntu/CentOS/Fedora)
- **Operating System**: Ubuntu 18.04+, CentOS 7+, RHEL 7+, or Fedora 28+
- **Architecture**: x86_64 (64-bit)
- **Memory**: Minimum 2GB RAM (4GB recommended)
- **Storage**: At least 1GB free space for temporary files
- **Network**: Stable internet connection
- **Permissions**: Sudo access for package installation

#### For macOS
- **Operating System**: macOS 10.15 (Catalina) or later
- **Architecture**: Intel or Apple Silicon (M1/M2)
- **Memory**: Minimum 2GB RAM (4GB recommended)
- **Storage**: At least 1GB free space for temporary files
- **Network**: Stable internet connection
- **Permissions**: Administrator access for Homebrew installation

#### For Windows
- **Operating System**: Windows 10 or later
- **Architecture**: x64 (64-bit)
- **Memory**: Minimum 2GB RAM (4GB recommended)
- **Storage**: At least 1GB free space for temporary files
- **Network**: Stable internet connection
- **PowerShell**: Version 5.1 or later
- **Permissions**: Administrator access for Chocolatey installation

### Required Tools

The scripts will automatically check for and install these tools:

#### Core Tools
- **curl**: For downloading files and API requests
- **wget**: Alternative download tool
- **PostgreSQL Client**: For database operations (`psql` command)
- **Docker**: For Supabase CLI operations
- **Supabase CLI**: For database dumping and management

#### Platform-Specific Package Managers
- **Linux**: `apt-get` (Ubuntu/Debian), `yum`/`dnf` (CentOS/RHEL/Fedora)
- **macOS**: Homebrew
- **Windows**: Chocolatey

### Account Requirements

#### Supabase Account
- **Access**: Valid Supabase account with access to source and destination projects
- **Permissions**: Database access permissions for both projects
- **API Keys**: Not required (uses Supabase CLI authentication)

#### Database Access
- **Source Database**: Read access to all tables, schemas, and roles
- **Destination Database**: Write access to create tables, schemas, and roles
- **Network**: IP whitelist access to both databases
- **Credentials**: Valid database passwords for both projects

### Network Requirements

#### Internet Connectivity
- **Download Speed**: Minimum 1 Mbps for tool installation
- **Upload Speed**: Minimum 5 Mbps for database operations
- **Stability**: Reliable connection for large database transfers

#### Firewall/Proxy
- **Outbound**: Access to GitHub (for Supabase CLI), Docker Hub, and Supabase APIs
- **Inbound**: No special requirements
- **Corporate Networks**: May need proxy configuration for tool downloads

### Security Considerations

#### Authentication
- **Supabase CLI**: Will prompt for login during first run
- **Database URLs**: Contain sensitive credentials - keep secure
- **Temporary Files**: Automatically cleaned up unless `--keep` flag is used

#### Permissions
- **File System**: Read/write access to current directory
- **Network**: Outbound connections to database servers
- **System**: Package manager installation permissions

### Performance Requirements

#### Database Size Considerations
- **Small Databases** (< 100MB): Should complete in 5-10 minutes
- **Medium Databases** (100MB - 1GB): Should complete in 10-30 minutes
- **Large Databases** (> 1GB): May take 30+ minutes, consider using `--keep` flag

#### Resource Usage
- **CPU**: Moderate usage during dump/upload operations
- **Memory**: Scales with database size, 2-4GB recommended
- **Disk**: Temporary storage equal to database size
- **Network**: Bandwidth usage proportional to database size

## Installation

### Universal Scripts (Recommended)

#### For Linux (Ubuntu/CentOS/Fedora)
```bash
# Download the universal Linux script
wget https://raw.githubusercontent.com/your-repo/supabase_db_copy_universal.sh
chmod +x supabase_db_copy_universal.sh
```

#### For macOS
```bash
# Download the universal macOS script
curl -o supabase_db_copy_universal_mac.sh https://raw.githubusercontent.com/your-repo/supabase_db_copy_universal_mac.sh
chmod +x supabase_db_copy_universal_mac.sh
```

#### For Windows
```powershell
# Download the universal Windows PowerShell script
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/your-repo/supabase_db_copy_universal.ps1" -OutFile "supabase_db_copy_universal.ps1"
```

### Legacy Scripts

#### For Ubuntu/Linux
```bash
# Download the legacy Linux script
wget https://raw.githubusercontent.com/your-repo/supabase_db_copy.sh
chmod +x supabase_db_copy.sh
```

#### For macOS
```bash
# Download the legacy Mac-specific script
curl -o supabase_db_copy_mac.sh https://raw.githubusercontent.com/your-repo/supabase_db_copy_mac.sh
chmod +x supabase_db_copy_mac.sh
```

#### For Windows
```powershell
# Download the legacy PowerShell script
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/your-repo/supabase_db_copy.ps1" -OutFile "supabase_db_copy.ps1"
```

## Usage

### Universal Scripts (Recommended)

#### For Linux (Ubuntu/CentOS/Fedora)

**Interactive Mode (Default)**:
```bash
./supabase_db_copy_universal.sh
```

**Command Line Mode (Advanced)**:
```bash
./supabase_db_copy_universal.sh -s "postgresql://user:pass@host:port/db" -t "postgresql://user:pass@host:port/db"
```

**Skip Docker Check (for headless servers)**:
```bash
./supabase_db_copy_universal.sh --no-docker
```

**Keep Temporary Files**:
```bash
./supabase_db_copy_universal.sh -k
```

#### For macOS

**Interactive Mode (Default)**:
```bash
./supabase_db_copy_universal_mac.sh
```

**Command Line Mode (Advanced)**:
```bash
./supabase_db_copy_universal_mac.sh -s "postgresql://user:pass@host:port/db" -t "postgresql://user:pass@host:port/db"
```

**Skip Docker Check**:
```bash
./supabase_db_copy_universal_mac.sh --no-docker
```

**Keep Temporary Files**:
```bash
./supabase_db_copy_universal_mac.sh -k
```

#### For Windows

**Interactive Mode (Default)**:
```powershell
.\supabase_db_copy_universal.ps1
```

**Command Line Mode (Advanced)**:
```powershell
.\supabase_db_copy_universal.ps1 -SourceUrl "postgresql://user:pass@host:port/db" -TargetUrl "postgresql://user:pass@host:port/db"
```

**Skip Docker Check**:
```powershell
.\supabase_db_copy_universal.ps1 -NoDocker
```

**Keep Temporary Files**:
```powershell
.\supabase_db_copy_universal.ps1 -KeepFiles
```

### Legacy Scripts

#### For Ubuntu/Linux

**Interactive Mode (Default)**:
```bash
./supabase_db_copy.sh
```

**Command Line Mode (Advanced)**:
```bash
./supabase_db_copy.sh -s "postgresql://user:pass@host:port/db" -t "postgresql://user:pass@host:port/db"
```

**Options**:
- `-h, --help`: Show help message
- `-s, --source`: Source database URL (for advanced users)
- `-t, --target`: Target database URL (for advanced users)
- `-k, --keep`: Keep temporary files after completion

#### For macOS

**Interactive Mode (Default)**:
```bash
./supabase_db_copy_mac.sh
```

**Command Line Mode (Advanced)**:
```bash
./supabase_db_copy_mac.sh -s "postgresql://user:pass@host:port/db" -t "postgresql://user:pass@host:port/db"
```

**Options**:
- `-h, --help`: Show help message
- `-s, --source`: Source database URL (for advanced users)
- `-t, --target`: Target database URL (for advanced users)
- `-k, --keep`: Keep temporary files after completion

#### For Windows

**PowerShell Script (Recommended)**:
```powershell
.\supabase_db_copy.ps1
```

**Command Line Mode (Advanced)**:
```powershell
.\supabase_db_copy.ps1 -SourceUrl "postgresql://user:pass@host:port/db" -TargetUrl "postgresql://user:pass@host:port/db"
```

**Options**:
- `-SourceUrl`: Source database URL (for advanced users)
- `-TargetUrl`: Target database URL (for advanced users)
- `-KeepFiles`: Keep temporary files after completion
- `-Help`: Show help message

**Batch Script (Simplified)**:
```cmd
supabase_db_copy_simple.bat
```

**Batch Script (Advanced)**:
```cmd
supabase_db_copy.bat -s "postgresql://user:pass@host:port/db" -t "postgresql://user:pass@host:port/db"
```

## Getting Database URLs

### From Supabase Dashboard

1. Go to your Supabase project dashboard
2. Navigate to **Settings** → **Database**
3. Copy the **Connection string** (URI format)
4. Replace `[YOUR-PASSWORD]` with your actual database password

### Example Database URLs

```
postgresql://postgres:your_password@db.abcdefghijklmnop.supabase.co:5432/postgres
```

## What the Scripts Do

### Universal Scripts (Recommended)

All universal scripts perform the same core operations:

1. **OS Detection**: Automatically detects your operating system
2. **Tool Checking**: Checks for all required tools (curl, wget, PostgreSQL, Docker, Supabase CLI)
3. **Installation Prompts**: Asks before installing any missing tools
4. **Package Management**: Uses appropriate package managers for each OS
   - **Linux**: `apt-get` (Ubuntu/Debian), `yum`/`dnf` (CentOS/RHEL/Fedora)
   - **macOS**: Homebrew (installs if missing)
   - **Windows**: Chocolatey (installs if missing)
5. **Database Operations**:
   - Tests database connections
   - Dumps database roles (`roles.sql`)
   - Dumps database schema (`schema.sql`) 
   - Dumps database data (`data.sql`)
   - Uploads all data to destination database
6. **Cleanup**: Removes temporary files (unless `--keep` flag is used)

### Legacy Scripts

#### For Ubuntu/Linux
1. **System Check**: Verifies Ubuntu/Linux environment
2. **Dependency Installation**: 
   - Updates package list
   - Installs required packages (curl, wget, unzip, postgresql-client)
   - Installs Homebrew if not present
   - Installs Supabase CLI if not present
3. **Docker Check**: Ensures Docker is running
4. **Supabase Login**: Handles Supabase CLI authentication
5. **Database Operations**: Same as universal scripts
6. **Cleanup**: Removes temporary files

#### For macOS
1. **System Check**: Verifies macOS environment
2. **Dependency Installation**: 
   - Installs Homebrew if not present
   - Installs required packages (curl, wget, postgresql)
   - Installs Supabase CLI if not present
3. **Docker Check**: Ensures Docker is running
4. **Supabase Login**: Handles Supabase CLI authentication
5. **Database Operations**: Same as universal scripts
6. **Cleanup**: Removes temporary files

#### For Windows
1. **System Check**: Verifies Windows environment
2. **Dependency Installation**: 
   - Installs Chocolatey if not present
   - Installs required packages (curl, wget, git, postgresql)
   - Installs Supabase CLI if not present
3. **Docker Check**: Ensures Docker is running
4. **Supabase Login**: Handles Supabase CLI authentication
5. **Database Operations**: Same as universal scripts
6. **Cleanup**: Removes temporary files

## Troubleshooting

### Common Issues

**Docker not running**:
```bash
# Start Docker Desktop or Docker service
sudo systemctl start docker
```

**Supabase CLI login issues**:
```bash
# Manual login
supabase login
```

**Permission denied**:
```bash
# Make script executable
chmod +x supabase_db_copy.sh
```

**Database connection issues**:
- Verify your database URLs are correct
- Ensure your database passwords are correct
- Check that your IP is whitelisted in Supabase

### Error Messages

- `[ERROR] Docker is not running`: Start Docker Desktop
- `[ERROR] Invalid database URL format`: Check your database URL format
- `[ERROR] Failed to dump roles/schema/data`: Check your source database connection
- `[ERROR] Failed to upload database`: Check your destination database connection
- `[ERROR] Failed to install postgresql`: Run the PostgreSQL fix script (Windows only)

### PowerShell Execution Policy Issues

If you get "running scripts is disabled" error:

1. **Quick fix (recommended)**:
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

2. **Or use the fix script**:
   ```powershell
   .\fix_powershell_execution.ps1
   ```

3. **Or bypass for current session**:
   ```powershell
   .\run_powershell_script.ps1
   ```

4. **Alternative: Use batch script instead**:
   ```cmd
   .\supabase_db_copy_simple.bat
   ```

### Windows PostgreSQL Issues

If you encounter PostgreSQL installation issues on Windows:

1. **Run the PostgreSQL fix script**:
   ```powershell
   .\fix_postgresql_windows.ps1
   ```

2. **Manual installation alternatives**:
   - Download from: https://www.postgresql.org/download/windows/
   - Use winget: `winget install PostgreSQL.PostgreSQL`
   - Use Scoop: `scoop install postgresql`

3. **After manual installation**:
   - Restart your terminal/PowerShell
   - Run the main script again

## Security Notes

- Database URLs contain sensitive information (passwords)
- The script creates temporary files with database content
- Temporary files are automatically cleaned up unless `--keep` flag is used
- Never share your database URLs or temporary files

## Example Output

```
==========================================
    Supabase Database Copy Script
==========================================

[INFO] Checking and installing required packages...
[SUCCESS] curl is already installed
[SUCCESS] wget is already installed
[SUCCESS] unzip is already installed
[SUCCESS] postgresql-client is already installed
[SUCCESS] Homebrew is already installed
[SUCCESS] Supabase CLI is already installed
[SUCCESS] Docker is running
[SUCCESS] Supabase CLI is logged in

[INFO] Please provide the database URLs for source and destination projects.

Enter SOURCE database URL (postgresql://username:password@host:port/database): postgresql://postgres:password@db.source.supabase.co:5432/postgres
Enter DESTINATION database URL (postgresql://username:password@host:port/database): postgresql://postgres:password@db.target.supabase.co:5432/postgres

[INFO] Database URLs validated successfully
[INFO] Creating working directory: supabase_copy_20241201_143022
[SUCCESS] Working directory created: /home/user/supabase_copy_20241201_143022
[INFO] Starting database dump process...
[INFO] Dumping database roles...
[SUCCESS] Roles dumped successfully
[INFO] Dumping database schema...
[SUCCESS] Schema dumped successfully
[INFO] Dumping database data...
[SUCCESS] Data dumped successfully
[SUCCESS] Database dump completed successfully
[INFO] Starting database upload process...
[INFO] Uploading database to destination...
[SUCCESS] Database uploaded successfully
[SUCCESS] Database copy process completed successfully!

[INFO] Summary:
  - Source: postgresql://postgres:password@db.source.supabase.co:5432/postgres
  - Destination: postgresql://postgres:password@db.target.supabase.co:5432/postgres
  - Working directory: supabase_copy_20241201_143022
[INFO] Cleaning up temporary files...
[SUCCESS] Cleanup completed

[SUCCESS] All done! Your Supabase database has been successfully copied.
```

## Edge Function Migration (NEW)

You can also copy all Supabase Edge Functions from one project to another using the new script:

### For Linux/macOS

```bash
cd supabase_edge_function_copy
./supabase_edge_function_copy.sh
```

- The script will prompt for the source and target project IDs (project refs).
- It will download all edge functions from the source project and deploy them to the target project using the Supabase CLI.
- Requirements: Supabase CLI installed and logged in.

## How to Get Source and Destination Project Refs for Edge Functions

To copy edge functions between Supabase projects, you need the **project ref** (ID) for both the source and destination projects. Here's how to find them:

1. **From the Supabase Dashboard:**
   - Go to your Supabase project dashboard.
   - In the URL, you'll see a string like `https://app.supabase.com/project/<project-ref>/...`. The `<project-ref>` is your project ID (e.g., `abcdefghijklmnop`).
   - Or, go to **Settings** → **General**. The **Project Reference** is shown at the top.

2. **Using the Supabase CLI:**
   - Run:
     ```bash
     supabase projects list
     ```
   - This will list all your projects and their refs (IDs).

**Example:**
- Source Project Ref: `abcdefghijklmnop`
- Destination Project Ref: `zyxwvutsrqponmlk`

You will be prompted to enter these refs when running the edge function copy script.

## Contributing

Feel free to submit issues and enhancement requests!

## License

This script is provided as-is for educational and development purposes. 