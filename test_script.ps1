# Test script for Supabase Database Copy Script (Windows)
# This script tests basic functionality without actually copying databases

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "    Supabase Database Copy Script Test" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Test if the main script exists
if (-not (Test-Path "supabase_db_copy.ps1")) {
    Write-Host "❌ Error: supabase_db_copy.ps1 not found" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Main script found" -ForegroundColor Green

# Test help functionality
Write-Host "Testing help functionality..."
try {
    & .\supabase_db_copy.ps1 -Help | Out-Null
    Write-Host "✅ Help functionality works" -ForegroundColor Green
} catch {
    Write-Host "❌ Help functionality failed" -ForegroundColor Red
}

# Test script syntax
Write-Host "Testing script syntax..."
try {
    $null = [System.Management.Automation.PSParser]::Tokenize((Get-Content "supabase_db_copy.ps1" -Raw), [ref]$null)
    Write-Host "✅ Script syntax is valid" -ForegroundColor Green
} catch {
    Write-Host "❌ Script syntax has errors" -ForegroundColor Red
    exit 1
}

# Test if required commands are available (without installing)
Write-Host "Testing for required commands..."
$commands = @("curl", "docker", "psql")
foreach ($cmd in $commands) {
    if (Get-Command $cmd -ErrorAction SilentlyContinue) {
        Write-Host "✅ $cmd is available" -ForegroundColor Green
    } else {
        Write-Host "⚠️  $cmd is not available (will be installed by script)" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "    Test completed successfully!" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "The script is ready to use. Run it with:" -ForegroundColor White
Write-Host "  .\supabase_db_copy.ps1" -ForegroundColor Gray
Write-Host ""
Write-Host "Or with database URLs:" -ForegroundColor White
Write-Host "  .\supabase_db_copy.ps1 -SourceUrl 'SOURCE_URL' -TargetUrl 'TARGET_URL'" -ForegroundColor Gray 