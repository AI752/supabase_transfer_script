# Supabase Database Copy Script

This repository contains scripts to automate the process of copying a Supabase database from one project to another. It handles all the necessary installations, validations, and database operations with proper error handling.

## Available Scripts

- **`supabase_db_copy.sh`** - Ubuntu/Linux bash script (also works on macOS)
- **`supabase_db_copy_mac.sh`** - macOS-specific script
- **`supabase_db_copy.ps1`** - Windows PowerShell script (recommended for Windows)
- **`supabase_db_copy.bat`** - Windows batch script

## Features

- ✅ **Automatic Installation**: Installs all required dependencies (Homebrew, Docker, PostgreSQL, Supabase CLI)
- ✅ **Validation**: Validates database URLs and checks system requirements
- ✅ **Error Handling**: Comprehensive error handling with colored output
- ✅ **Flexible Usage**: Supports both interactive and command-line modes
- ✅ **Cleanup**: Automatic cleanup of temporary files
- ✅ **Progress Tracking**: Clear progress indicators throughout the process

## Prerequisites

### For Ubuntu/Linux
- Ubuntu/Linux system
- Internet connection
- Docker Desktop (will be installed if not present)
- Supabase account with access to source and destination projects

### For macOS
- macOS 10.15 (Catalina) or later
- Internet connection
- Docker Desktop (will be installed if not present)
- Supabase account with access to source and destination projects

### For Windows
- Windows 10 or later
- PowerShell 5.1 or later (for PowerShell script)
- Internet connection
- Docker Desktop (will be installed if not present)
- Supabase account with access to source and destination projects

## Installation

### For Ubuntu/Linux

1. **Download the script**:
   ```bash
   wget https://raw.githubusercontent.com/your-repo/supabase_db_copy.sh
   ```

2. **Make it executable**:
   ```bash
   chmod +x supabase_db_copy.sh
   ```

### For macOS

1. **Download the Mac-specific script** (recommended):
   ```bash
   curl -o supabase_db_copy_mac.sh https://raw.githubusercontent.com/your-repo/supabase_db_copy_mac.sh
   chmod +x supabase_db_copy_mac.sh
   ```

2. **Or use the Linux script** (also works on macOS):
   ```bash
   curl -o supabase_db_copy.sh https://raw.githubusercontent.com/your-repo/supabase_db_copy.sh
   chmod +x supabase_db_copy.sh
   ```

### For Windows

1. **Download the PowerShell script** (recommended):
   ```powershell
   # Download the PowerShell script
   Invoke-WebRequest -Uri "https://raw.githubusercontent.com/your-repo/supabase_db_copy.ps1" -OutFile "supabase_db_copy.ps1"
   ```

2. **Or download the batch script**:
   ```cmd
   # Download the batch script
   curl -o supabase_db_copy.bat https://raw.githubusercontent.com/your-repo/supabase_db_copy.bat
   ```

## Usage

### For Ubuntu/Linux

#### Interactive Mode (Default)

Run the script and it will prompt you for the database URLs:

```bash
./supabase_db_copy.sh
```

The script will:
1. Install required dependencies
2. Prompt you for source database URL
3. Prompt you for destination database URL
4. Show a summary and ask for confirmation
5. Perform the database copy operation

#### Command Line Mode (Advanced)

You can also provide the database URLs as command line arguments:

```bash
./supabase_db_copy.sh -s "postgresql://user:pass@host:port/db" -t "postgresql://user:pass@host:port/db"
```

#### Options

- `-h, --help`: Show help message
- `-s, --source`: Source database URL (for advanced users)
- `-t, --target`: Target database URL (for advanced users)
- `-k, --keep`: Keep temporary files after completion

### For macOS

#### Interactive Mode (Default)

Run the Mac-specific script and it will prompt you for the database URLs:

```bash
./supabase_db_copy_mac.sh
```

Or use the Linux script (also works on macOS):

```bash
./supabase_db_copy.sh
```

The script will:
1. Install required dependencies (Homebrew, PostgreSQL, etc.)
2. Prompt you for source database URL
3. Prompt you for destination database URL
4. Show a summary and ask for confirmation
5. Perform the database copy operation

#### Command Line Mode (Advanced)

You can also provide the database URLs as command line arguments:

```bash
./supabase_db_copy_mac.sh -s "postgresql://user:pass@host:port/db" -t "postgresql://user:pass@host:port/db"
```

#### Options

- `-h, --help`: Show help message
- `-s, --source`: Source database URL (for advanced users)
- `-t, --target`: Target database URL (for advanced users)
- `-k, --keep`: Keep temporary files after completion

### For Windows

#### PowerShell Script (Recommended)

**Interactive Mode**:
```powershell
.\supabase_db_copy.ps1
```

**Command Line Mode** (Advanced):
```powershell
.\supabase_db_copy.ps1 -SourceUrl "postgresql://user:pass@host:port/db" -TargetUrl "postgresql://user:pass@host:port/db"
```

**Options**:
- `-SourceUrl`: Source database URL (for advanced users)
- `-TargetUrl`: Target database URL (for advanced users)
- `-KeepFiles`: Keep temporary files after completion
- `-Help`: Show help message

#### Batch Script

**Interactive Mode**:
```cmd
supabase_db_copy.bat
```

**Command Line Mode** (Advanced):
```cmd
supabase_db_copy.bat -s "postgresql://user:pass@host:port/db" -t "postgresql://user:pass@host:port/db"
```

**Options**:
- `-h, --help`: Show help message
- `-s, --source`: Source database URL (for advanced users)
- `-t, --target`: Target database URL (for advanced users)
- `-k, --keep`: Keep temporary files after completion

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

## What the Script Does

### For Ubuntu/Linux
1. **System Check**: Verifies Ubuntu/Linux environment
2. **Dependency Installation**: 
   - Updates package list
   - Installs required packages (curl, wget, unzip, postgresql-client)
   - Installs Homebrew if not present
   - Installs Supabase CLI if not present
3. **Docker Check**: Ensures Docker is running
4. **Supabase Login**: Handles Supabase CLI authentication
5. **Database Operations**:
   - Dumps database roles (`roles.sql`)
   - Dumps database schema (`schema.sql`) 
   - Dumps database data (`data.sql`)
   - Uploads all data to destination database
6. **Cleanup**: Removes temporary files

### For macOS
1. **System Check**: Verifies macOS environment
2. **Dependency Installation**: 
   - Installs Homebrew if not present
   - Installs required packages (curl, wget, postgresql)
   - Installs Supabase CLI if not present
3. **Docker Check**: Ensures Docker is running
4. **Supabase Login**: Handles Supabase CLI authentication
5. **Database Operations**:
   - Dumps database roles (`roles.sql`)
   - Dumps database schema (`schema.sql`) 
   - Dumps database data (`data.sql`)
   - Uploads all data to destination database
6. **Cleanup**: Removes temporary files

### For Windows
1. **System Check**: Verifies Windows environment
2. **Dependency Installation**: 
   - Installs Chocolatey if not present
   - Installs required packages (curl, wget, git, postgresql)
   - Installs Supabase CLI if not present
3. **Docker Check**: Ensures Docker is running
4. **Supabase Login**: Handles Supabase CLI authentication
5. **Database Operations**:
   - Dumps database roles (`roles.sql`)
   - Dumps database schema (`schema.sql`) 
   - Dumps database data (`data.sql`)
   - Uploads all data to destination database
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

## Contributing

Feel free to submit issues and enhancement requests!

## License

This script is provided as-is for educational and development purposes. 