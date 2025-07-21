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
FUNCTIONS=$(supabase functions list --project-ref "$SOURCE_PROJECT" | awk 'NR>1 {print $1}')

if [ -z "$FUNCTIONS" ]; then
  print_error "No functions found in source project."
  cd ..
  rm -rf "$WORKDIR"
  exit 1
fi

print_status "Functions to copy: $FUNCTIONS"

for FUNC in $FUNCTIONS; do
  print_status "Downloading function: $FUNC"
  supabase functions download "$FUNC" --project-ref "$SOURCE_PROJECT"
  print_status "Deploying function: $FUNC to target project"
  supabase functions deploy "$FUNC" --project-ref "$TARGET_PROJECT"
  print_success "Function $FUNC copied successfully."
done

cd ..
rm -rf "$WORKDIR"
print_success "All functions copied from $SOURCE_PROJECT to $TARGET_PROJECT." 