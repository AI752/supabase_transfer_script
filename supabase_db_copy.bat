@echo off
setlocal enabledelayedexpansion

REM Supabase Database Copy Script for Windows
REM This script automates the process of copying a Supabase database from one project to another
REM Author: Generated for Supabase database duplication
REM Usage: supabase_db_copy.bat

REM Set error handling
set "ERRORLEVEL=0"

REM Colors for output (Windows 10+ supports ANSI colors)
set "RED=[91m"
set "GREEN=[92m"
set "YELLOW=[93m"
set "BLUE=[94m"
set "NC=[0m"

REM Function to print colored output
:print_status
echo %BLUE%[INFO]%NC% %~1
goto :eof

:print_success
echo %GREEN%[SUCCESS]%NC% %~1
goto :eof

:print_warning
echo %YELLOW%[WARNING]%NC% %~1
goto :eof

:print_error
echo %RED%[ERROR]%NC% %~1
goto :eof

REM Function to check if command exists
:command_exists
where %1 >nul 2>&1
if %errorlevel% equ 0 (
    exit /b 0
) else (
    exit /b 1
)

REM Function to check Docker status
:check_docker
docker info >nul 2>&1
if %errorlevel% neq 0 (
    call :print_error "Docker is not running. Please start Docker Desktop and try again."
    exit /b 1
)
call :print_success "Docker is running"
goto :eof

REM Function to check Supabase CLI login
:check_supabase_login
supabase status >nul 2>&1
if %errorlevel% neq 0 (
    call :print_warning "Supabase CLI not logged in. Attempting to login..."
    supabase login
    if %errorlevel% neq 0 (
        call :print_error "Failed to login to Supabase CLI. Please login manually and try again."
        exit /b 1
    )
)
call :print_success "Supabase CLI is logged in"
goto :eof

REM Function to install required packages
:install_requirements
call :print_status "Checking and installing required packages..."

REM Check if Chocolatey is installed
call :command_exists choco
if %errorlevel% neq 0 (
    call :print_status "Installing Chocolatey..."
    powershell -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
    if %errorlevel% neq 0 (
        call :print_error "Failed to install Chocolatey"
        exit /b 1
    )
) else (
    call :print_success "Chocolatey is already installed"
)

REM Install required packages
set "packages=curl wget git postgresql"
for %%p in (%packages%) do (
    call :command_exists %%p
    if !errorlevel! neq 0 (
        call :print_status "Installing %%p..."
        choco install %%p -y
        if !errorlevel! neq 0 (
            call :print_error "Failed to install %%p"
            exit /b 1
        )
    ) else (
        call :print_success "%%p is already installed"
    )
)

REM Install Supabase CLI if not present
call :command_exists supabase
if %errorlevel% neq 0 (
    call :print_status "Installing Supabase CLI..."
    choco install supabase -y
    if %errorlevel% neq 0 (
        call :print_error "Failed to install Supabase CLI"
        exit /b 1
    )
) else (
    call :print_success "Supabase CLI is already installed"
)

goto :eof

REM Function to validate database URL format
:validate_db_url
set "url=%~1"
set "name=%~2"

REM Basic validation - check if it starts with postgresql://
echo %url% | findstr /r "^postgresql://" >nul
if %errorlevel% neq 0 (
    call :print_error "Invalid %name% database URL format. Expected format: postgresql://username:password@host:port/database"
    exit /b 1
)
exit /b 0

REM Function to get user input
:get_database_urls
echo.
call :print_status "Please provide the database URLs for source and destination projects."
echo.
call :print_status "You can get these from your Supabase project dashboard:"
call :print_status "1. Go to your Supabase project"
call :print_status "2. Navigate to Settings → Database"
call :print_status "3. Copy the Connection string (URI format)"
call :print_status "4. Replace [YOUR-PASSWORD] with your actual database password"
echo.

REM Get source database URL
:get_source_url
echo %BLUE%SOURCE DATABASE%NC%
set /p "SOURCE_DB_URL=Enter SOURCE database URL (postgresql://username:password@host:port/database): "
call :validate_db_url "%SOURCE_DB_URL%" "source"
if %errorlevel% neq 0 goto :get_source_url

echo.

REM Get destination database URL
:get_target_url
echo %BLUE%DESTINATION DATABASE%NC%
set /p "TARGET_DB_URL=Enter DESTINATION database URL (postgresql://username:password@host:port/database): "
call :validate_db_url "%TARGET_DB_URL%" "destination"
if %errorlevel% neq 0 goto :get_target_url

echo.
call :print_status "Database URLs validated successfully"

REM Show summary
echo.
call :print_status "Summary of your configuration:"
echo   Source: %SOURCE_DB_URL%
echo   Destination: %TARGET_DB_URL%
echo.

REM Confirm before proceeding
set /p "confirm=Do you want to proceed with the database copy? (y/N): "
if /i not "%confirm%"=="y" (
    call :print_warning "Operation cancelled by user"
    exit /b 0
)
goto :eof

REM Function to create working directory
:create_working_dir
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "timestamp=%dt:~0,8%_%dt:~8,6%"
set "WORKING_DIR=supabase_copy_%timestamp%"

call :print_status "Creating working directory: %WORKING_DIR%"
if not exist "%WORKING_DIR%" mkdir "%WORKING_DIR%"
cd "%WORKING_DIR%"
call :print_success "Working directory created: %CD%"
goto :eof

REM Function to dump database
:dump_database
call :print_status "Starting database dump process..."

REM Dump roles
call :print_status "Dumping database roles..."
supabase db dump --db-url "%SOURCE_DB_URL%" -f roles.sql --role-only
if %errorlevel% neq 0 (
    call :print_error "Failed to dump roles"
    exit /b 1
)
call :print_success "Roles dumped successfully"

REM Dump schema
call :print_status "Dumping database schema..."
supabase db dump --db-url "%SOURCE_DB_URL%" -f schema.sql
if %errorlevel% neq 0 (
    call :print_error "Failed to dump schema"
    exit /b 1
)
call :print_success "Schema dumped successfully"

REM Dump data
call :print_status "Dumping database data..."
supabase db dump --db-url "%SOURCE_DB_URL%" -f data.sql --use-copy --data-only
if %errorlevel% neq 0 (
    call :print_error "Failed to dump data"
    exit /b 1
)
call :print_success "Data dumped successfully"

call :print_success "Database dump completed successfully"
goto :eof

REM Function to upload database
:upload_database
call :print_status "Starting database upload process..."

REM Check if dump files exist
for %%f in (roles.sql schema.sql data.sql) do (
    if not exist "%%f" (
        call :print_error "Dump file %%f not found. Please run the dump process first."
        exit /b 1
    )
)

call :print_status "Uploading database to destination..."
psql --single-transaction --variable ON_ERROR_STOP=1 --file roles.sql --file schema.sql --command "SET session_replication_role = replica" --file data.sql --dbname "%TARGET_DB_URL%"
if %errorlevel% neq 0 (
    call :print_error "Failed to upload database"
    exit /b 1
)
call :print_success "Database uploaded successfully"
goto :eof

REM Function to cleanup
:cleanup
call :print_status "Cleaning up temporary files..."
cd ..
if exist "%WORKING_DIR%" (
    rmdir /s /q "%WORKING_DIR%"
    call :print_success "Cleanup completed"
)
goto :eof

REM Function to show usage
:show_usage
echo Usage: %0 [OPTIONS]
echo.
echo Options:
echo   -h, --help     Show this help message
echo   -s, --source   Source database URL
echo   -t, --target   Target database URL
echo   -k, --keep     Keep temporary files after completion
echo.
echo Examples:
echo   %0
echo   %0 -s "postgresql://user:pass@host:port/db" -t "postgresql://user:pass@host:port/db"
echo.
goto :eof

REM Main function
:main
set "KEEP_FILES=false"
set "SOURCE_DB_URL="
set "TARGET_DB_URL="

REM Parse command line arguments
:parse_args
if "%~1"=="" goto :end_parse
if "%~1"=="-h" goto :show_usage
if "%~1"=="--help" goto :show_usage
if "%~1"=="-s" (
    set "SOURCE_DB_URL=%~2"
    shift
    shift
    goto :parse_args
)
if "%~1"=="--source" (
    set "SOURCE_DB_URL=%~2"
    shift
    shift
    goto :parse_args
)
if "%~1"=="-t" (
    set "TARGET_DB_URL=%~2"
    shift
    shift
    goto :parse_args
)
if "%~1"=="--target" (
    set "TARGET_DB_URL=%~2"
    shift
    shift
    goto :parse_args
)
if "%~1"=="-k" (
    set "KEEP_FILES=true"
    shift
    goto :parse_args
)
if "%~1"=="--keep" (
    set "KEEP_FILES=true"
    shift
    goto :parse_args
)
call :print_error "Unknown option: %~1"
call :show_usage
exit /b 1

:end_parse
echo ==========================================
echo     Supabase Database Copy Script
echo ==========================================
echo.

REM Install requirements
call :install_requirements

REM Check Docker
call :check_docker
if %errorlevel% neq 0 exit /b 1

REM Check Supabase CLI login
call :check_supabase_login
if %errorlevel% neq 0 exit /b 1

REM Always get database URLs interactively (command line args are for advanced users)
call :get_database_urls

REM Create working directory
call :create_working_dir

REM Perform database operations
call :dump_database
if %errorlevel% neq 0 exit /b 1

call :upload_database
if %errorlevel% neq 0 exit /b 1

call :print_success "Database copy process completed successfully!"
echo.
call :print_status "Summary:"
echo   - Source: %SOURCE_DB_URL%
echo   - Destination: %TARGET_DB_URL%
echo   - Working directory: %WORKING_DIR%

REM Cleanup unless keep flag is set
if "%KEEP_FILES%"=="false" (
    call :cleanup
) else (
    call :print_status "Temporary files kept in: %WORKING_DIR%"
)

echo.
call :print_success "All done! Your Supabase database has been successfully copied."
goto :eof

REM Run main function
call :main %* 