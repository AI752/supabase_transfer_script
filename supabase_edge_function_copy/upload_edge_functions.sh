#!/usr/bin/env bash

# Supabase Edge Function Upload Script
# Uploads (deploys) all Edge Functions from the current directory to a specified Supabase project
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

read -p "Enter DESTINATION Supabase project ref (e.g. zyxwvutsrqponmlk): " DEST_PROJECT

# Find all function folders (each function is a folder with an index.ts or mod.ts)
FUNCTIONS=$(find . -maxdepth 1 -type d ! -name '.' ! -name '.git' | sed 's|^./||')

if [ -z "$FUNCTIONS" ]; then
  print_error "No function folders found in current directory."
  exit 1
fi

print_status "Functions to upload: $FUNCTIONS"

for FUNC in $FUNCTIONS; do
  if [ -f "$FUNC/index.ts" ] || [ -f "$FUNC/mod.ts" ]; then
    print_status "Deploying function: $FUNC"
    supabase functions deploy "$FUNC" --project-ref "$DEST_PROJECT"
    print_success "Function $FUNC deployed successfully."
  else
    print_status "Skipping $FUNC (no index.ts or mod.ts found)"
  fi

done

print_success "All functions deployed to $DEST_PROJECT." 