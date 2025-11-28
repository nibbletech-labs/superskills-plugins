# Supabase CLI Troubleshooting Guide

Comprehensive solutions for common Supabase CLI errors and issues.

## Connection Issues

### "Connection refused"

**Symptoms:**
```
Error: connect ECONNREFUSED
```

**Causes & Solutions:**

1. **Project is paused**
   - Check Dashboard: Your project may have been paused due to inactivity
   - Solution: Restore project from Dashboard

2. **Wrong connection string**
   - Verify you're using the correct format for your use case
   - Direct: `postgresql://postgres.[REF]:[PASS]@db.[REF].supabase.co:5432/postgres`
   - Pooler: `postgresql://postgres.[REF]:[PASS]@aws-0-[REGION].pooler.supabase.com:5432/postgres`

3. **Firewall blocking connection**
   - Check if your network allows outbound connections on port 5432/6543
   - Try from a different network

4. **Docker not running (local development)**
   ```bash
   # Check Docker status
   docker ps
   # If Docker isn't running, start it first
   ```

### "Password authentication failed"

**Symptoms:**
```
FATAL: password authentication failed for user "postgres"
```

**Solutions:**

1. **Reset database password**
   - Dashboard → Settings → Database → Reset Database Password
   - Update your connection string with new password

2. **URL-encode special characters**
   ```bash
   # If password contains special chars like @, #, %, etc.
   # Encode them: @ = %40, # = %23, % = %25
   # Example: p@ssw#rd → p%40ssw%23rd
   ```

3. **Check username format**
   - Direct: `postgres`
   - Pooler: `postgres.[PROJECT-REF]`

### "Network is unreachable" / IPv6 Issues

**Symptoms:**
```
Error: connect ENETUNREACH
could not translate host name
```

**Solutions:**

1. **Use pooler connection (supports IPv4)**
   ```bash
   # Instead of direct connection (IPv6 only)
   # Use session pooler (port 5432) or transaction pooler (port 6543)
   postgresql://postgres.[REF]:[PASS]@aws-0-[REGION].pooler.supabase.com:5432/postgres
   ```

2. **Enable IPv4 add-on**
   - Dashboard → Settings → Add-ons → IPv4 Address
   - Required for direct connections in IPv4-only networks

3. **Check IPv6 support**
   ```bash
   # Test IPv6 connectivity
   ping6 google.com
   # Visit https://test-ipv6.com
   ```

### "SSL required" / SSL Errors

**Solutions:**

1. **Add sslmode parameter**
   ```bash
   postgresql://...?sslmode=require
   ```

2. **For local development**
   ```bash
   # Local doesn't require SSL
   postgresql://postgres:postgres@localhost:54322/postgres
   ```

## CLI Authentication Issues

### "Not logged in"

**Symptoms:**
```
Error: You need to be logged in to run this command
```

**Solution:**
```bash
supabase login
# Follow the prompts to authenticate
```

### "Project not linked"

**Symptoms:**
```
Error: Cannot find linked project
```

**Solution:**
```bash
supabase link --project-ref YOUR_PROJECT_REF
# Get project ref from Dashboard URL: supabase.com/dashboard/project/[PROJECT_REF]
```

### "Access token expired"

**Solution:**
```bash
supabase logout
supabase login
# Generate new token from Dashboard if needed
```

## Migration Issues

### "Permission denied for table"

**Symptoms:**
```
ERROR: permission denied for table _type
pg_dump: error: query failed
```

**Solution:**
```sql
-- Run in SQL Editor
GRANT ALL ON ALL TABLES IN SCHEMA graphql TO postgres, anon, authenticated, service_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA graphql TO postgres, anon, authenticated, service_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA graphql TO postgres, anon, authenticated, service_role;
```

### "Must be owner of table"

**Symptoms:**
```
ERROR: must be owner of table employees (SQLSTATE 42501)
```

**Causes:**
- Table created via Dashboard is owned by `supabase_admin`
- CLI migrations run as `postgres` role

**Solution:**
```sql
-- Transfer ownership
ALTER TABLE table_name OWNER TO postgres;

-- For all tables in public schema
DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN SELECT tablename FROM pg_tables WHERE schemaname = 'public'
    LOOP
        EXECUTE 'ALTER TABLE public.' || quote_ident(r.tablename) || ' OWNER TO postgres';
    END LOOP;
END $$;
```

### "Migration already applied"

**Symptoms:**
```
Error: Migration XXXXXXXXXX_name has already been applied
```

**Solutions:**

1. **Local: Reset database**
   ```bash
   supabase db reset
   ```

2. **Remote: Check migration status**
   ```bash
   supabase migration list
   ```

3. **Force re-application (dangerous)**
   ```sql
   -- Only if you're certain
   DELETE FROM supabase_migrations.schema_migrations
   WHERE version = 'XXXXXXXXXX';
   ```

### "Relation does not exist"

**Symptoms:**
```
ERROR: relation "table_name" does not exist
```

**Causes:**
- Migration order issue
- Table created in different schema

**Solutions:**

1. **Check schema qualification**
   ```sql
   -- Be explicit about schema
   SELECT * FROM public.table_name;
   ```

2. **Check migration order**
   - Migrations run in timestamp order
   - Ensure dependent tables are created first

### "Type already exists"

**Symptoms:**
```
ERROR: type "status_type" already exists
```

**Solution:**
```sql
-- Make migration idempotent
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'status_type') THEN
        CREATE TYPE status_type AS ENUM ('active', 'inactive');
    END IF;
END $$;
```

## Edge Function Issues

### "Function not found"

**Symptoms:**
```
{"error":"Function not found"}
```

**Solutions:**

1. **Verify deployment**
   ```bash
   supabase functions list
   ```

2. **Check function name matches URL**
   - URL: `/functions/v1/hello-world`
   - Folder: `supabase/functions/hello-world/`

3. **Redeploy**
   ```bash
   supabase functions deploy hello-world
   ```

### "JWT required" / "Invalid JWT"

**Symptoms:**
```
{"error":"Invalid JWT"}
```

**Solutions:**

1. **Include Authorization header**
   ```bash
   curl -H "Authorization: Bearer YOUR_ANON_KEY" \
        https://[PROJECT].supabase.co/functions/v1/hello-world
   ```

2. **For public functions, disable JWT verification**
   ```bash
   supabase functions deploy hello-world --no-verify-jwt
   ```

3. **Or in config.toml**
   ```toml
   [functions.hello-world]
   verify_jwt = false
   ```

### "Function timeout"

**Causes:**
- Long-running operations
- Database query issues
- Infinite loops

**Solutions:**

1. **Optimize database queries**
   - Add indexes
   - Use efficient queries

2. **Check for infinite loops**
   - Review async/await usage
   - Check recursive calls

3. **Break into smaller functions**
   - Consider chunking work
   - Use background processing for long tasks

### "Import error" / Module not found

**Solutions:**

1. **Check import_map.json**
   ```json
   {
     "imports": {
       "@supabase/supabase-js": "https://esm.sh/@supabase/supabase-js@2"
     }
   }
   ```

2. **Use correct import syntax**
   ```typescript
   // Deno-style imports
   import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

   // Or use import map
   import { createClient } from "@supabase/supabase-js";
   ```

## Local Development Issues

### "Docker not running"

**Symptoms:**
```
Error: Cannot connect to Docker daemon
```

**Solutions:**

1. **Start Docker Desktop**
   - Ensure Docker Desktop is running

2. **Check Docker socket**
   ```bash
   docker info
   ```

3. **Restart Docker**
   ```bash
   # macOS
   killall Docker && open /Applications/Docker.app
   ```

### "Port already in use"

**Symptoms:**
```
Error: port 54321 is already in use
```

**Solutions:**

1. **Stop other Supabase instances**
   ```bash
   supabase stop
   ```

2. **Find and kill process**
   ```bash
   lsof -i :54321
   kill -9 [PID]
   ```

3. **Use different ports in config.toml**
   ```toml
   [api]
   port = 54321

   [db]
   port = 54322
   ```

### "Out of disk space"

**Symptoms:**
```
Error: no space left on device
```

**Solutions:**

1. **Clean Docker**
   ```bash
   docker system prune -a --volumes
   ```

2. **Remove old Supabase data**
   ```bash
   supabase stop --no-backup
   ```

## Debugging Commands

### General Diagnostics

```bash
# CLI version
supabase --version

# List linked projects
supabase projects list

# Check local status
supabase status

# Enable debug mode
supabase <command> --debug
```

### Database Diagnostics

```bash
# Check migrations
supabase migration list

# View database logs
supabase db logs

# Test connection
psql "CONNECTION_STRING" -c "SELECT 1"
```

### Function Diagnostics

```bash
# List functions
supabase functions list

# View logs
supabase functions logs function-name

# Serve locally with debugging
supabase functions serve --debug
```

## Getting Help

### Resources

- [Supabase Discord](https://discord.supabase.com)
- [GitHub Issues](https://github.com/supabase/cli/issues)
- [Documentation](https://supabase.com/docs)

### Reporting Issues

When reporting issues, include:
1. CLI version: `supabase --version`
2. OS and version
3. Full error message
4. Steps to reproduce
5. Debug output: `supabase <command> --debug`
