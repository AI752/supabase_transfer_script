# Supabase Edge Function Copy Guide

This guide explains how to copy (move) all Supabase Edge Functions from one project to another, **even if the projects are in different Supabase accounts**.

## Prerequisites
- [Supabase CLI](https://supabase.com/docs/guides/cli) installed
- Access to both source and destination Supabase accounts
- The script: `supabase_edge_function_copy.sh` (in this folder)

## Step 1: Get Project Refs (IDs)
You need the **project ref** for both the source and destination projects.

- **From the Dashboard:**
  - Go to your project in the Supabase dashboard.
  - The URL will look like: `https://app.supabase.com/project/<project-ref>/...`
  - Or, go to **Settings → General** to see the Project Reference.
- **Using the CLI:**
  ```bash
  supabase projects list
  ```

## Step 2: Log In to Both Accounts

The Supabase CLI can only be logged in to one account at a time. To copy functions between projects in different accounts, you need to:

1. **Download functions from the source account/project:**
   - Log in to the source account:
     ```bash
     supabase login
     ```
   - Run the script and let it download the functions (it will also try to deploy, but you can skip/fail this step for now).
   - The downloaded functions will be in a temporary folder.

2. **Log in to the destination account/project:**
   - Log out (optional):
     ```bash
     supabase logout
     ```
   - Log in to the destination account:
     ```bash
     supabase login
     ```
   - Re-run the script, or manually deploy the downloaded functions to the destination project using:
     ```bash
     supabase functions deploy <function_name> --project-ref <destination_project_ref>
     ```

**Tip:** You can also copy the downloaded function folders from the temp directory and deploy them after switching accounts.

## Step 3: Run the Script

```bash
cd supabase_edge_function_copy
./supabase_edge_function_copy.sh
```
- Enter the source project ref (from the source account)
- Enter the destination project ref (from the destination account)

If you get a permissions error during deploy, switch CLI login to the destination account and re-run the deploy step.

## Troubleshooting
- **Permissions:** Make sure you have access to both projects in their respective accounts.
- **Account switching:** The CLI only works with one account at a time. Download with the source account, then deploy with the destination account.
- **Function overwrites:** If a function with the same name exists in the destination, it will be overwritten.

## Example Workflow
1. Log in to the source account and run the script to download functions.
2. Log in to the destination account and re-run the script (or deploy manually) to upload functions.

---

For more details, see the main project README or the [Supabase CLI docs](https://supabase.com/docs/guides/cli). 