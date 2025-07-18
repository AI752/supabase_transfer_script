# Quick Start Guide

## For Ubuntu/Linux Users

1. **Download and run the script**:
   ```bash
   wget https://raw.githubusercontent.com/your-repo/supabase_db_copy.sh
   chmod +x supabase_db_copy.sh
   ./supabase_db_copy.sh
   ```

2. **The script will guide you through the process**:
   - It will install any missing dependencies
   - Prompt you for your source database URL
   - Prompt you for your destination database URL
   - Show a summary and ask for confirmation
   - Perform the database copy

## For macOS Users

1. **Download and run the Mac-specific script** (recommended):
   ```bash
   curl -o supabase_db_copy_mac.sh https://raw.githubusercontent.com/your-repo/supabase_db_copy_mac.sh
   chmod +x supabase_db_copy_mac.sh
   ./supabase_db_copy_mac.sh
   ```

2. **Or use the Linux script** (also works on macOS):
   ```bash
   curl -o supabase_db_copy.sh https://raw.githubusercontent.com/your-repo/supabase_db_copy.sh
   chmod +x supabase_db_copy.sh
   ./supabase_db_copy.sh
   ```

3. **The script will guide you through the process**:
   - It will install Homebrew and required dependencies
   - Prompt you for your source database URL
   - Prompt you for your destination database URL
   - Show a summary and ask for confirmation
   - Perform the database copy

## For Windows Users

1. **Download and run the PowerShell script** (recommended):
   ```powershell
   Invoke-WebRequest -Uri "https://raw.githubusercontent.com/your-repo/supabase_db_copy.ps1" -OutFile "supabase_db_copy.ps1"
   .\supabase_db_copy.ps1
   ```

2. **Or use the batch script**:
   ```cmd
   curl -o supabase_db_copy.bat https://raw.githubusercontent.com/your-repo/supabase_db_copy.bat
   supabase_db_copy.bat
   ```

3. **The script will guide you through the process** just like the Linux version

## Getting Your Database URLs

1. Go to your Supabase project dashboard
2. Navigate to **Settings** → **Database**
3. Copy the **Connection string** (URI format)
4. Replace `[YOUR-PASSWORD]` with your actual database password

Example:
```
postgresql://postgres:your_password@db.abcdefghijklmnop.supabase.co:5432/postgres
```

## What Happens Next

The script will:
1. ✅ Install all required dependencies
2. ✅ Check Docker is running
3. ✅ Handle Supabase CLI login
4. ✅ Dump your source database (roles, schema, data)
5. ✅ Upload everything to your destination database
6. ✅ Clean up temporary files

## Troubleshooting

- **Docker not running**: Start Docker Desktop
- **Permission denied**: Make sure you're not running as root (Linux) or administrator (Windows)
- **Database connection issues**: Verify your URLs and passwords are correct

## Need Help?

- Run `./supabase_db_copy.sh --help` (Linux) or `.\supabase_db_copy.ps1 -Help` (Windows)
- Check the full [README.md](README.md) for detailed documentation 