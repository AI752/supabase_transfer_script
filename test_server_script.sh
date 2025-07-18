#!/bin/bash

# Test script for Supabase Database Copy Script (Ubuntu Server)
# This script tests basic functionality without actually copying databases

echo "=========================================="
echo "    Supabase Database Copy Script Test (Server)"
echo "=========================================="
echo

# Check if we're on Ubuntu
if [[ ! -f /etc/os-release ]]; then
    echo "❌ Error: Cannot determine OS. This test is for Ubuntu servers."
    exit 1
fi

source /etc/os-release
if [[ "$ID" != "ubuntu" ]]; then
    echo "⚠️  Warning: This test is optimized for Ubuntu. You're running $ID"
fi

echo "✅ Ubuntu detected: $VERSION"

# Test if the main script exists
if [[ ! -f "supabase_db_copy_server.sh" ]]; then
    echo "❌ Error: supabase_db_copy_server.sh not found"
    exit 1
fi

echo "✅ Server script found"

# Test if the script is executable
if [[ ! -x "supabase_db_copy_server.sh" ]]; then
    echo "⚠️  Warning: Script is not executable, making it executable..."
    chmod +x supabase_db_copy_server.sh
fi

echo "✅ Script is executable"

# Test help functionality
echo "Testing help functionality..."
if ./supabase_db_copy_server.sh --help > /dev/null 2>&1; then
    echo "✅ Help functionality works"
else
    echo "❌ Help functionality failed"
fi

# Test script syntax
echo "Testing script syntax..."
if bash -n supabase_db_copy_server.sh; then
    echo "✅ Script syntax is valid"
else
    echo "❌ Script syntax has errors"
    exit 1
fi

# Test if required commands are available (without installing)
echo "Testing for required commands..."
commands=("curl" "wget" "psql" "docker" "git")
for cmd in "${commands[@]}"; do
    if command -v "$cmd" >/dev/null 2>&1; then
        echo "✅ $cmd is available"
    else
        echo "⚠️  $cmd is not available (will be installed by script)"
    fi
done

# Test Docker specifically
if command -v docker >/dev/null 2>&1; then
    echo "✅ Docker is available"
    docker_version=$(docker --version)
    echo "   Version: $docker_version"
    
    # Test if Docker daemon is running
    if docker info >/dev/null 2>&1; then
        echo "✅ Docker daemon is running"
    else
        echo "⚠️  Docker daemon is not running"
    fi
else
    echo "⚠️  Docker is not available (will be installed by script)"
fi

# Test PostgreSQL client
if command -v psql >/dev/null 2>&1; then
    echo "✅ PostgreSQL client is available"
    psql_version=$(psql --version)
    echo "   Version: $psql_version"
else
    echo "⚠️  PostgreSQL client is not available (will be installed by script)"
fi

# Test network connectivity
echo "Testing network connectivity..."
if curl -s --connect-timeout 5 https://www.google.com >/dev/null 2>&1; then
    echo "✅ Internet connectivity is available"
else
    echo "⚠️  Internet connectivity may be limited"
fi

# Test GitHub API access (for Supabase CLI download)
if curl -s --connect-timeout 5 https://api.github.com >/dev/null 2>&1; then
    echo "✅ GitHub API is accessible"
else
    echo "⚠️  GitHub API may not be accessible"
fi

echo
echo "=========================================="
echo "    Test completed successfully!"
echo "=========================================="
echo
echo "The script is ready to use. Run it with:"
echo "  ./supabase_db_copy_server.sh"
echo
echo "Or with database URLs:"
echo "  ./supabase_db_copy_server.sh -s 'SOURCE_URL' -t 'TARGET_URL'"
echo
echo "For headless servers (skip Docker check):"
echo "  ./supabase_db_copy_server.sh --no-docker"
echo
echo "To keep temporary files:"
echo "  ./supabase_db_copy_server.sh -k" 