# Migration Templates

Common migration patterns for Supabase projects. Copy and adapt these templates for your needs.

## Table Creation

### Basic Table with Timestamps

```sql
CREATE TABLE IF NOT EXISTS public.users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email TEXT UNIQUE NOT NULL,
    full_name TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Auto-update updated_at
CREATE OR REPLACE FUNCTION public.update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_users_updated_at
    BEFORE UPDATE ON public.users
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updated_at();

-- Enable RLS
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
```

### Table with Foreign Key

```sql
CREATE TABLE IF NOT EXISTS public.posts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    author_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    content TEXT,
    status TEXT DEFAULT 'draft' CHECK (status IN ('draft', 'published', 'archived')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index for foreign key lookups
CREATE INDEX idx_posts_author_id ON public.posts(author_id);

-- Enable RLS
ALTER TABLE public.posts ENABLE ROW LEVEL SECURITY;
```

### Join Table (Many-to-Many)

```sql
CREATE TABLE IF NOT EXISTS public.user_teams (
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    team_id UUID NOT NULL REFERENCES public.teams(id) ON DELETE CASCADE,
    role TEXT DEFAULT 'member' CHECK (role IN ('member', 'admin', 'owner')),
    joined_at TIMESTAMPTZ DEFAULT NOW(),
    PRIMARY KEY (user_id, team_id)
);

-- Indexes for lookups from both sides
CREATE INDEX idx_user_teams_user ON public.user_teams(user_id);
CREATE INDEX idx_user_teams_team ON public.user_teams(team_id);

-- Enable RLS
ALTER TABLE public.user_teams ENABLE ROW LEVEL SECURITY;
```

## Column Modifications

### Add Column

```sql
-- Simple column
ALTER TABLE public.users
ADD COLUMN IF NOT EXISTS phone TEXT;

-- Column with default
ALTER TABLE public.users
ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT true;

-- Column with constraint
ALTER TABLE public.users
ADD COLUMN IF NOT EXISTS age INTEGER CHECK (age >= 0 AND age <= 150);

-- Rollback:
-- ALTER TABLE public.users DROP COLUMN phone;
```

### Modify Column

```sql
-- Change type
ALTER TABLE public.users
ALTER COLUMN age TYPE SMALLINT;

-- Add NOT NULL (ensure no nulls exist first)
UPDATE public.users SET status = 'active' WHERE status IS NULL;
ALTER TABLE public.users
ALTER COLUMN status SET NOT NULL;

-- Change default
ALTER TABLE public.users
ALTER COLUMN is_active SET DEFAULT false;

-- Remove default
ALTER TABLE public.users
ALTER COLUMN is_active DROP DEFAULT;
```

### Rename Column

```sql
ALTER TABLE public.users
RENAME COLUMN full_name TO display_name;
```

## Index Management

### Create Indexes

```sql
-- B-tree index (default, good for equality and range)
CREATE INDEX IF NOT EXISTS idx_users_email ON public.users(email);

-- Partial index (only indexes matching rows)
CREATE INDEX IF NOT EXISTS idx_active_users ON public.users(email)
WHERE is_active = true;

-- Composite index
CREATE INDEX IF NOT EXISTS idx_posts_author_status
ON public.posts(author_id, status);

-- GIN index (for array/jsonb contains)
CREATE INDEX IF NOT EXISTS idx_posts_tags ON public.posts USING GIN(tags);

-- Unique index
CREATE UNIQUE INDEX IF NOT EXISTS idx_users_email_unique
ON public.users(email);
```

### Drop Index

```sql
DROP INDEX IF EXISTS idx_users_email;
```

## RLS Policy Migrations

### Basic CRUD Policies

```sql
-- Enable RLS
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- SELECT: Users read own data
CREATE POLICY "Users read own profile"
ON public.profiles FOR SELECT
TO authenticated
USING ((SELECT auth.uid()) = user_id);

-- INSERT: Users create own profile
CREATE POLICY "Users create own profile"
ON public.profiles FOR INSERT
TO authenticated
WITH CHECK ((SELECT auth.uid()) = user_id);

-- UPDATE: Users update own profile
CREATE POLICY "Users update own profile"
ON public.profiles FOR UPDATE
TO authenticated
USING ((SELECT auth.uid()) = user_id)
WITH CHECK ((SELECT auth.uid()) = user_id);

-- DELETE: Users delete own profile
CREATE POLICY "Users delete own profile"
ON public.profiles FOR DELETE
TO authenticated
USING ((SELECT auth.uid()) = user_id);
```

### Drop and Replace Policy

```sql
-- Drop old policy
DROP POLICY IF EXISTS "old_policy_name" ON public.table_name;

-- Create new policy
CREATE POLICY "new_policy_name"
ON public.table_name FOR SELECT
TO authenticated
USING (new_condition);
```

## Function Migrations

### Security Definer Function

```sql
-- Create in private schema for RLS helper functions
CREATE SCHEMA IF NOT EXISTS private;

CREATE OR REPLACE FUNCTION private.is_team_member(check_team_id UUID)
RETURNS BOOLEAN
LANGUAGE sql
SECURITY DEFINER
STABLE
SET search_path = ''
AS $$
    SELECT EXISTS (
        SELECT 1 FROM public.team_members
        WHERE team_id = check_team_id
        AND user_id = (SELECT auth.uid())
    )
$$;

-- Grant execute to authenticated role
GRANT EXECUTE ON FUNCTION private.is_team_member(UUID) TO authenticated;
```

### Trigger Function

```sql
CREATE OR REPLACE FUNCTION public.on_user_created()
RETURNS TRIGGER
SECURITY DEFINER
SET search_path = ''
AS $$
BEGIN
    INSERT INTO public.profiles (user_id, email)
    VALUES (NEW.id, NEW.email);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION public.on_user_created();
```

## Enum/Type Migrations

### Create Enum

```sql
-- Create type
CREATE TYPE public.status_type AS ENUM ('pending', 'active', 'archived');

-- Use in table
ALTER TABLE public.items
ADD COLUMN status public.status_type DEFAULT 'pending';
```

### Add Value to Enum

```sql
-- Add new value (cannot be done in transaction)
ALTER TYPE public.status_type ADD VALUE 'suspended' AFTER 'active';
```

## Storage Bucket Setup

```sql
-- Create storage bucket
INSERT INTO storage.buckets (id, name, public)
VALUES ('avatars', 'avatars', true)
ON CONFLICT (id) DO NOTHING;

-- Storage policies
CREATE POLICY "Public avatar access"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'avatars');

CREATE POLICY "Users upload own avatar"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = (SELECT auth.uid()::text)
);

CREATE POLICY "Users update own avatar"
ON storage.objects FOR UPDATE
TO authenticated
USING (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = (SELECT auth.uid()::text)
);

CREATE POLICY "Users delete own avatar"
ON storage.objects FOR DELETE
TO authenticated
USING (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = (SELECT auth.uid()::text)
);
```

## Seed Data

### Development Seed (supabase/seed.sql)

```sql
-- Only run in development/testing
-- Check environment or use IF NOT EXISTS patterns

-- Insert test users
INSERT INTO public.users (id, email, full_name)
VALUES
    ('d0d54eb7-5f5d-4c2c-9f6a-2c3d4e5f6a7b', 'alice@example.com', 'Alice Smith'),
    ('e1e65fc8-6g6e-5d3d-0g7b-3d4e5f6g7b8c', 'bob@example.com', 'Bob Jones')
ON CONFLICT (id) DO NOTHING;

-- Insert test data
INSERT INTO public.posts (author_id, title, content, status)
SELECT
    'user-uuid-here',
    'Test Post ' || generate_series,
    'Content for test post ' || generate_series,
    CASE WHEN generate_series % 2 = 0 THEN 'published' ELSE 'draft' END
FROM generate_series(1, 10)
ON CONFLICT DO NOTHING;
```

## Data Migrations

### Backfill Column

```sql
-- Add column
ALTER TABLE public.users
ADD COLUMN IF NOT EXISTS slug TEXT;

-- Backfill data
UPDATE public.users
SET slug = LOWER(REPLACE(full_name, ' ', '-'))
WHERE slug IS NULL;

-- Make NOT NULL after backfill
ALTER TABLE public.users
ALTER COLUMN slug SET NOT NULL;

-- Add unique constraint
ALTER TABLE public.users
ADD CONSTRAINT users_slug_unique UNIQUE (slug);
```

### Split Table

```sql
-- Create new table
CREATE TABLE IF NOT EXISTS public.user_settings (
    user_id UUID PRIMARY KEY REFERENCES public.users(id) ON DELETE CASCADE,
    theme TEXT DEFAULT 'light',
    notifications_enabled BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Migrate data
INSERT INTO public.user_settings (user_id, theme, notifications_enabled)
SELECT id, theme, notifications_enabled
FROM public.users
ON CONFLICT (user_id) DO NOTHING;

-- Remove old columns (after verifying migration)
-- ALTER TABLE public.users DROP COLUMN theme;
-- ALTER TABLE public.users DROP COLUMN notifications_enabled;
```

## Idempotent Patterns

Always write migrations that can be run multiple times safely:

```sql
-- Tables
CREATE TABLE IF NOT EXISTS ...

-- Columns
ALTER TABLE ... ADD COLUMN IF NOT EXISTS ...

-- Indexes
CREATE INDEX IF NOT EXISTS ...

-- Policies
DROP POLICY IF EXISTS "policy_name" ON table_name;
CREATE POLICY "policy_name" ...

-- Functions
CREATE OR REPLACE FUNCTION ...

-- Triggers (must drop first)
DROP TRIGGER IF EXISTS trigger_name ON table_name;
CREATE TRIGGER trigger_name ...

-- Data (use ON CONFLICT)
INSERT INTO ... ON CONFLICT DO NOTHING;
INSERT INTO ... ON CONFLICT (key) DO UPDATE SET ...;
```
