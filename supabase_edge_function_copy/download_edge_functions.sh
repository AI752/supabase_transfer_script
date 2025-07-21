#!/usr/bin/env bash

# Supabase Edge Function Download Script
# Downloads all Edge Functions from a specified Supabase project
# Requirements: Supabase CLI installed and logged in

set -e

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

if ! command -v supabase &> /dev/null; then
  print_error "Supabase CLI not found. Please install it first."
  exit 1
fi

read -p "Enter SOURCE Supabase project ref (e.g. abcdefghijklmnop): " SOURCE_PROJECT

WORKDIR="downloaded_edge_functions_${SOURCE_PROJECT}_$(date +%s)"
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

print_status "Functions to download: $FUNCTIONS"

for FUNC in $FUNCTIONS; do
  print_status "Downloading function: $FUNC"
  supabase functions download "$FUNC" --project-ref "$SOURCE_PROJECT"
  print_success "Function $FUNC downloaded successfully."
done

cd ..
print_success "All functions downloaded from $SOURCE_PROJECT into $WORKDIR." 