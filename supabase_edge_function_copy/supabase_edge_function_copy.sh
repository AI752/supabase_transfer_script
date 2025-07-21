#!/usr/bin/env bash

# Supabase Edge Function Copy Script
# Copies all Edge Functions from one Supabase project to another
# Requirements: Supabase CLI installed and logged in

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

function print_status() {
  echo -e "${YELLOW}[INFO]${NC} $1"
}
function print_success() {
  echo -e "${GREEN}[SUCCESS]${NC} $1"
}
function print_error() {
  echo -e "${RED}[ERROR]${NC} $1" >&2
}

# Check for supabase CLI
if ! command -v supabase &> /dev/null; then
  print_error "Supabase CLI not found. Please install it first."
  exit 1
fi

# Prompt for source and target project IDs
read -p "Enter SOURCE Supabase project ref (e.g. abcdefghijklmnop): " SOURCE_PROJECT
read -p "Enter TARGET Supabase project ref (e.g. zyxwvutsrqponmlk): " TARGET_PROJECT

# Create a temp directory for function code
WORKDIR="edge_functions_tmp_$(date +%s)"
mkdir "$WORKDIR"
cd "$WORKDIR"

print_status "Listing functions in source project..."

# Get the function list and parse it properly
FUNCTION_OUTPUT=$(supabase functions list --project-ref "$SOURCE_PROJECT")
echo "$FUNCTION_OUTPUT"

# Extract function names from the NAME column (3rd column after the |)
# Skip header and separator lines, extract names from table format
FUNCTIONS=$(echo "$FUNCTION_OUTPUT" | grep -E '^\s*[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}' | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}' | grep -v "^$")

if [ -z "$FUNCTIONS" ]; then
  print_error "No functions found in source project."
  cd ..
  rm -rf "$WORKDIR"
  exit 1
fi

print_status "Functions to copy:"
echo "$FUNCTIONS"

for FUNC in $FUNCTIONS; do
  if [ -z "$FUNC" ] || [ "$FUNC" = "ID" ]; then
    print_error "Skipping invalid function identifier: '$FUNC'"
    continue
  fi
  
  print_status "Downloading function: $FUNC"
  if ! supabase functions download "$FUNC" --project-ref "$SOURCE_PROJECT"; then
    print_error "Failed to download function: $FUNC"
    print_status "Trying with --debug flag..."
    supabase functions download "$FUNC" --project-ref "$SOURCE_PROJECT" --debug
    continue
  fi
  
  print_status "Deploying function: $FUNC to target project"
  if ! supabase functions deploy "$FUNC" --project-ref "$TARGET_PROJECT"; then
    print_error "Failed to deploy function: $FUNC"
    print_status "Trying with --debug flag..."
    supabase functions deploy "$FUNC" --project-ref "$TARGET_PROJECT" --debug
    continue
  fi
  
  print_success "Function $FUNC copied successfully."
done

cd ..
rm -rf "$WORKDIR"
print_success "All functions copied from $SOURCE_PROJECT to $TARGET_PROJECT." 