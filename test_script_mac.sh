#!/bin/bash

# Test script for Supabase Database Copy Script (macOS)
# This script tests basic functionality without actually copying databases

echo "=========================================="
echo "    Supabase Database Copy Script Test (macOS)"
echo "=========================================="
echo

# Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ Error: This test script is for macOS only"
    exit 1
fi

echo "✅ macOS detected"

# Test if the main script exists
if [[ ! -f "supabase_db_copy_mac.sh" ]]; then
    echo "❌ Error: supabase_db_copy_mac.sh not found"
    exit 1
fi

echo "✅ Mac script found"

# Test if the script is executable
if [[ ! -x "supabase_db_copy_mac.sh" ]]; then
    echo "⚠️  Warning: Script is not executable, making it executable..."
    chmod +x supabase_db_copy_mac.sh
fi

echo "✅ Script is executable"

# Test help functionality
echo "Testing help functionality..."
if ./supabase_db_copy_mac.sh --help > /dev/null 2>&1; then
    echo "✅ Help functionality works"
else
    echo "❌ Help functionality failed"
fi

# Test script syntax
echo "Testing script syntax..."
if bash -n supabase_db_copy_mac.sh; then
    echo "✅ Script syntax is valid"
else
    echo "❌ Script syntax has errors"
    exit 1
fi

# Test if required commands are available (without installing)
echo "Testing for required commands..."
commands=("curl" "docker" "psql" "brew")
for cmd in "${commands[@]}"; do
    if command -v "$cmd" >/dev/null 2>&1; then
        echo "✅ $cmd is available"
    else
        echo "⚠️  $cmd is not available (will be installed by script)"
    fi
done

# Test Homebrew specifically
if command -v brew >/dev/null 2>&1; then
    echo "✅ Homebrew is available"
    brew_version=$(brew --version | head -n1)
    echo "   Version: $brew_version"
else
    echo "⚠️  Homebrew is not available (will be installed by script)"
fi

echo
echo "=========================================="
echo "    Test completed successfully!"
echo "=========================================="
echo
echo "The script is ready to use. Run it with:"
echo "  ./supabase_db_copy_mac.sh"
echo
echo "Or with database URLs:"
echo "  ./supabase_db_copy_mac.sh -s 'SOURCE_URL' -t 'TARGET_URL'" 