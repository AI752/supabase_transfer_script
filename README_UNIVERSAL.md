# Universal Supabase Database Copy Script

A single, cross-platform script that automatically checks for required tools and prompts for installation if missing. Works on Linux, macOS, and Windows (via WSL/Git Bash).

## 🚀 Quick Start

1. **Download the script**:
   ```bash
   wget https://raw.githubusercontent.com/your-repo/supabase_db_copy_universal.sh
   chmod +x supabase_db_copy_universal.sh
   ```

2. **Run the script**:
   ```bash
   ./supabase_db_copy_universal.sh
   ```

3. **The script will**:
   - Detect your operating system
   - Check for required tools (curl, wget, PostgreSQL, Docker, Supabase CLI)
   - Prompt you to install missing tools
   - Guide you through the database copy process

## ✨ Features

- ✅ **Cross-Platform**: Works on Linux, macOS, and Windows (via WSL/Git Bash)
- ✅ **Auto-Detection**: Automatically detects your operating system
- ✅ **Tool Checking**: Checks for all required tools and prompts for installation
- ✅ **Smart Installation**: Uses appropriate package managers for each OS
- ✅ **Interactive Prompts**: Asks before installing any tools
- ✅ **Error Handling**: Comprehensive error handling with colored output
- ✅ **Flexible Usage**: Supports both interactive and command-line modes

## 🔧 Required Tools

The script checks for and can install:

- **curl**: For downloading files
- **wget**: Alternative download tool
- **PostgreSQL Client**: For database operations
- **Docker**: For Supabase CLI operations
- **Supabase CLI**: For database dumping

## 🖥️ Supported Operating Systems

### Linux
- **Ubuntu/Debian**: Uses `apt-get`
- **CentOS/RHEL/Fedora**: Uses `yum` or `dnf`
- **Other Linux**: Manual installation guidance

### macOS
- Uses **Homebrew** for package management
- Provides Docker Desktop installation guidance

### Windows
- Works via **WSL** or **Git Bash**
- Provides manual installation guidance for tools

## 📖 Usage

### Interactive Mode (Default)
```bash
./supabase_db_copy_universal.sh
```

### Command Line Mode
```bash
./supabase_db_copy_universal.sh -s "postgresql://user:pass@host:port/db" -t "postgresql://user:pass@host:port/db"
```

### Skip Docker Check
```bash
./supabase_db_copy_universal.sh --no-docker
```

### Keep Temporary Files
```bash
./supabase_db_copy_universal.sh -k
```

## ⚙️ Options

- `-h, --help`: Show help message
- `-s, --source`: Source database URL
- `-t, --target`: Target database URL
- `-k, --keep`: Keep temporary files after completion
- `--no-docker`: Skip Docker check (for headless servers)

## 🔍 What the Script Does

1. **OS Detection**: Identifies your operating system
2. **Tool Checking**: Checks for all required tools
3. **Installation Prompts**: Asks before installing missing tools
4. **Package Management**: Uses appropriate package managers
5. **Database Operations**: Performs the actual database copy
6. **Cleanup**: Removes temporary files

## 🛠️ Installation Examples

### Ubuntu/Debian
```bash
# The script will automatically use:
sudo apt-get update
sudo apt-get install -y curl wget postgresql-client
```

### CentOS/RHEL/Fedora
```bash
# The script will automatically use:
sudo yum install -y curl wget postgresql
# or
sudo dnf install -y curl wget postgresql
```

### macOS
```bash
# The script will automatically use:
brew install curl wget postgresql supabase/tap/supabase
```

## 📋 Getting Database URLs

1. Go to your Supabase project dashboard
2. Navigate to **Settings** → **Database**
3. Copy the **Connection string** (URI format)
4. Replace `[YOUR-PASSWORD]` with your actual database password

Example:
```
postgresql://postgres:your_password@db.abcdefghijklmnop.supabase.co:5432/postgres
```

## 🔧 Troubleshooting

### Common Issues

**Permission denied**:
```bash
chmod +x supabase_db_copy_universal.sh
```

**Homebrew not found (macOS)**:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**Docker not running**:
- **Linux**: `sudo systemctl start docker`
- **macOS/Windows**: Start Docker Desktop

**Database connection issues**:
- Verify your database URLs are correct
- Ensure your database passwords are correct
- Check that your IP is whitelisted in Supabase

### Error Messages

- `[ERROR] curl is not installed`: The script will prompt for installation
- `[ERROR] Docker is not running`: Start Docker or use `--no-docker`
- `[ERROR] Invalid database URL format`: Check your database URL format
- `[ERROR] Failed to connect to database`: Check network connectivity and credentials

## 🔒 Security Notes

- Database URLs contain sensitive information (passwords)
- The script creates temporary files with database content
- Temporary files are automatically cleaned up unless `-k` flag is used
- Never share your database URLs or temporary files

## 📝 Example Output

```
==========================================
    Universal Supabase Database Copy Script
==========================================

[SUCCESS] Detected OS: ubuntu
[INFO] Checking required tools...

[SUCCESS] curl is available
[SUCCESS] wget is available
[SUCCESS] PostgreSQL client is available
[SUCCESS] Docker is available
[SUCCESS] Docker is running
[SUCCESS] Supabase CLI is available
[SUCCESS] Supabase CLI is logged in

[SUCCESS] All required tools are available!

[INFO] Please provide the database URLs for source and destination projects.

SOURCE DATABASE
Enter SOURCE database URL (postgresql://username:password@host:port/database): postgresql://postgres:password@db.source.supabase.co:5432/postgres

DESTINATION DATABASE
Enter DESTINATION database URL (postgresql://username:password@host:port/database): postgresql://postgres:password@db.target.supabase.co:5432/postgres

[INFO] Database URLs validated successfully
[INFO] Testing source database connection...
[SUCCESS] source database connection successful
[INFO] Testing destination database connection...
[SUCCESS] destination database connection successful
[INFO] Creating working directory: supabase_copy_20241201_143022
[SUCCESS] Working directory created: /home/user/supabase_copy_20241201_143022
[INFO] Starting database dump process...
[SUCCESS] Database dump completed successfully
[INFO] Starting database upload process...
[SUCCESS] Database uploaded successfully
[SUCCESS] Database copy process completed successfully!

[SUCCESS] All done! Your Supabase database has been successfully copied.
```

## 🆘 Support

For issues or questions:
1. Check the troubleshooting section above
2. Run the script with `--help` for usage information
3. Create an issue in the repository with your OS and error details 