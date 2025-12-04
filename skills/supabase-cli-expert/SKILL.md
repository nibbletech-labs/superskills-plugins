---
name: supabase-cli-expert
displayName: Supabase CLI Expert
description: Expert guidance for Supabase CLI operations including database connections, migrations, RLS policies, Edge Functions, and troubleshooting.
category: database
tags: [supabase, cli, migrations, rls, edge-functions, postgresql]
icon: database
author: nibbletech-labs
version: 1.0.0
---

# Supabase CLI Expert

## Overview

This skill provides expert-level guidance for the Supabase CLI, covering the complete workflow from project setup through production deployment. It encodes best practices for connection management, migration strategies, RLS policy optimization, and common troubleshooting patterns.

## Quick Reference

### Essential Commands

```bash
# Installation
brew install supabase/tap/supabase  # macOS
npm install supabase --save-dev      # via npm

# Authentication & Project Setup
supabase login                       # Authenticate with access token
supabase link --project-ref <ref>    # Link to remote project
supabase start                       # Start local development stack
supabase stop                        # Stop local stack (preserves data)
supabase stop --no-backup            # Stop and reset all data

# Database Operations
supabase db reset                    # Reset local DB and apply migrations
supabase db push                     # Push migrations to remote
supabase db pull                     # Pull remote schema as migration
supabase db diff -f <name>           # Generate migration from local changes
supabase migration new <name>        # Create empty migration file
supabase migration list              # List applied migrations

# Edge Functions
supabase functions serve             # Serve all functions locally
supabase functions deploy            # Deploy all functions
supabase functions deploy <name>     # Deploy specific function

# Branching (Pro/Team plans)
supabase branches list               # List all branches
supabase branches create <name>      # Create development branch
```

## Connection Management

### Understanding Connection Types

Supabase provides multiple connection methods. Selecting the correct one is critical:

| Connection Type | Port | IPv4/IPv6 | Use Case |
|-----------------|------|-----------|----------|
| **Direct** | 5432 | IPv6 only* | Migrations, schema changes, pg_dump |
| **Session Pooler** | 5432 | Both | Persistent apps needing IPv4 |
| **Transaction Pooler** | 6543 | Both | Serverless, edge functions |
| **Dedicated Pooler** | varies | IPv6* | High-performance (paid plans) |

*IPv4 available with add-on

### Connection String Formats

```bash
# Direct connection (IPv6, for migrations)
postgresql://postgres.[PROJECT-REF]:[PASSWORD]@db.[PROJECT-REF].supabase.co:5432/postgres

# Session pooler (IPv4 compatible, persistent connections)
postgresql://postgres.[PROJECT-REF]:[PASSWORD]@aws-0-[REGION].pooler.supabase.com:5432/postgres

# Transaction pooler (IPv4 compatible, serverless - NOTE: port 6543)
postgresql://postgres.[PROJECT-REF]:[PASSWORD]@aws-0-[REGION].pooler.supabase.com:6543/postgres
```

### Connection Validation Workflow

When setting up or troubleshooting connections, follow this checklist:

1. **Verify CLI is logged in:**
   ```bash
   supabase projects list
   # Should show your projects without error
   ```

2. **Confirm project is linked:**
   ```bash
   supabase link --project-ref <project-id>
   # Get project-id from dashboard URL
   ```

3. **Test database connectivity:**
   ```bash
   # Using psql with your connection string
   psql "postgresql://..." -c "SELECT 1"
   ```

4. **Check for IPv6 issues:**
   - If connection fails, try session pooler (port 5432) instead of direct
   - Transaction pooler (port 6543) also supports IPv4
   - Consider IPv4 add-on for direct connections

5. **Validate password:**
   - Reset in Dashboard: Settings > Database > Database password
   - Special characters may need URL encoding

### Common Connection Errors

**"Connection refused":**
- Project may be paused (check Dashboard)
- Firewall blocking connection
- Wrong connection string format

**"Password authentication failed":**
- Password was reset - get new one from Dashboard
- Special characters not URL-encoded
- Using wrong user (should be `postgres.[PROJECT-REF]` for pooler)

**"SSL required":**
- Add `?sslmode=require` to connection string

## Database Migrations

### Migration Workflow

```
Local Development → Test Locally → Push to Staging → Push to Production
```

### Creating Migrations

**Method 1: Write SQL directly**
```bash
supabase migration new create_users_table
# Edit: supabase/migrations/<timestamp>_create_users_table.sql
```

**Method 2: Diff from Dashboard changes**
```bash
# Make changes in local Studio (localhost:54323)
supabase db diff -f descriptive_name
# Review generated migration
supabase db reset  # Test migration works
```

**Method 3: Pull from remote**
```bash
supabase db pull
# Creates migration capturing remote schema
```

### Migration Best Practices

1. **Always test locally first:**
   ```bash
   supabase db reset  # Applies all migrations fresh
   ```

2. **Use idempotent statements:**
   ```sql
   -- Good: Won't fail if already exists
   CREATE TABLE IF NOT EXISTS users (...);
   ALTER TABLE users ADD COLUMN IF NOT EXISTS email TEXT;

   -- Bad: Fails on second run
   CREATE TABLE users (...);
   ```

3. **Never modify deployed migrations:**
   - Create new migration to alter schema
   - Only exception: fixing syntax before first deploy

4. **Handle data migrations carefully:**
   ```sql
   -- Use transactions for data changes
   BEGIN;
   UPDATE users SET status = 'active' WHERE status IS NULL;
   COMMIT;
   ```

5. **Include rollback comments:**
   ```sql
   -- Migration: Add verified column
   ALTER TABLE users ADD COLUMN verified BOOLEAN DEFAULT false;

   -- Rollback (for reference, execute manually if needed):
   -- ALTER TABLE users DROP COLUMN verified;
   ```

### Deploying Migrations

```bash
# To staging/production
supabase db push

# With seed data (use sparingly in production)
supabase db push --include-seed

# Check migration status
supabase migration list
```

## Row Level Security (RLS)

### RLS Quick Setup

```sql
-- 1. Enable RLS on table
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- 2. Create policies
CREATE POLICY "Users read own data"
ON profiles FOR SELECT
TO authenticated
USING ((SELECT auth.uid()) = user_id);

CREATE POLICY "Users update own data"
ON profiles FOR UPDATE
TO authenticated
USING ((SELECT auth.uid()) = user_id)
WITH CHECK ((SELECT auth.uid()) = user_id);
```

### Performance-Optimized Patterns

**Always wrap auth functions in SELECT:**
```sql
-- FAST: Cached per-statement
USING ((SELECT auth.uid()) = user_id)

-- SLOW: Called per-row
USING (auth.uid() = user_id)
```

**Add indexes for policy columns:**
```sql
CREATE INDEX idx_profiles_user_id ON profiles(user_id);
```

**Use security definer functions for complex lookups:**
```sql
-- Create function in private schema
CREATE FUNCTION private.user_has_role(required_role TEXT)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM user_roles
    WHERE user_id = (SELECT auth.uid())
    AND role = required_role
  );
END;
$$;

-- Use in policy
CREATE POLICY "Admins can view all"
ON sensitive_data FOR SELECT
TO authenticated
USING ((SELECT private.user_has_role('admin')));
```

**Avoid joins in policies - use IN/ANY instead:**
```sql
-- SLOW: Joins source to target
USING (user_id IN (
  SELECT user_id FROM team_members
  WHERE team_members.team_id = teams.id  -- join!
))

-- FAST: No join, filters into set
USING (team_id IN (
  SELECT team_id FROM team_members
  WHERE user_id = (SELECT auth.uid())  -- no join
))
```

### Common RLS Patterns

For comprehensive RLS patterns including team-based access, hierarchical permissions, and time-based policies, see `references/rls-patterns.md`.

## Edge Functions

### Development Workflow

```bash
# Start local Supabase (includes functions runtime)
supabase start

# Serve specific function with hot reload
supabase functions serve hello-world

# Serve without JWT verification (for webhooks)
supabase functions serve hello-world --no-verify-jwt
```

### Function Structure

```
supabase/functions/
├── _shared/              # Shared code (underscore = not deployed)
│   ├── cors.ts
│   └── supabaseClient.ts
├── hello-world/
│   └── index.ts
└── import_map.json       # Shared dependencies
```

### Basic Function Template

```typescript
import "jsr:@supabase/functions-js/edge-runtime.d.ts";

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
};

Deno.serve(async (req: Request) => {
  // Handle CORS preflight
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  try {
    const { name } = await req.json();
    const data = { message: `Hello ${name}!` };

    return new Response(JSON.stringify(data), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    });
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 400,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    });
  }
});
```

### Deployment

```bash
# Deploy all functions
supabase functions deploy

# Deploy specific function
supabase functions deploy hello-world

# Deploy without JWT verification
supabase functions deploy hello-world --no-verify-jwt
```

### Function Configuration (config.toml)

```toml
[functions.hello-world]
verify_jwt = false  # For webhooks

[functions.protected-function]
verify_jwt = true   # Default
```

## Branching (Preview Environments)

### Branch Workflow

Branches create isolated database copies for testing schema changes:

```bash
# Create a branch
supabase branches create feature-auth

# List branches
supabase branches list

# The branch gets its own project_ref for testing
# Use branch credentials in your test environment

# When ready, merge to production
supabase branches merge <branch-id>

# Or delete if not needed
supabase branches delete <branch-id>
```

### Important Notes

- Branches apply all migrations from main project
- Production data does NOT carry over (fresh DB)
- Each branch has unique connection credentials
- Branches incur additional costs (check pricing)

## Troubleshooting

### Diagnostic Commands

```bash
# Check CLI version
supabase --version

# Verify login status
supabase projects list

# Check local services status
supabase status

# View function logs (production)
supabase functions logs <function-name> --project-ref <ref>

# View database logs
supabase db logs --project-ref <ref>
```

### Common Issues

**"Permission denied on db pull":**
```sql
-- Run in SQL Editor to fix graphql permissions
GRANT ALL ON ALL TABLES IN SCHEMA graphql TO postgres, anon, authenticated, service_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA graphql TO postgres, anon, authenticated, service_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA graphql TO postgres, anon, authenticated, service_role;
```

**"Must be owner of table" on db push:**
```sql
-- Reassign table ownership
ALTER TABLE table_name OWNER TO postgres;
```

**Edge Function timeout:**
- Check for infinite loops
- Optimize database queries
- Consider breaking into smaller functions

**Migration conflicts:**
```bash
# Reset branch to specific version
supabase branches reset <branch-id> --migration-version <version>

# Or reset local completely
supabase db reset
```

### Getting Help

```bash
# Built-in help
supabase --help
supabase <command> --help

# Debug mode for detailed output
supabase <command> --debug
```

## Resources

### scripts/
- `validate_connection.sh` - Validates Supabase connection setup and diagnoses common issues

### references/
- `rls-patterns.md` - Comprehensive RLS policy patterns and performance optimization
- `migration-templates.md` - Common migration patterns and templates
- `troubleshooting-guide.md` - Detailed error messages and solutions

### External Documentation
- [Supabase CLI Reference](https://supabase.com/docs/reference/cli)
- [Database Migrations Guide](https://supabase.com/docs/guides/deployment/database-migrations)
- [RLS Performance Guide](https://supabase.com/docs/guides/database/postgres/row-level-security#rls-performance-recommendations)
- [Edge Functions Guide](https://supabase.com/docs/guides/functions)
