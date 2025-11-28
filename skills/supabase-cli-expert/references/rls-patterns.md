# RLS Policy Patterns

Comprehensive Row Level Security patterns for Supabase, organized by use case with performance considerations.

## Core Concepts

### Policy Structure

```sql
CREATE POLICY "policy_name"
ON table_name
FOR operation           -- SELECT, INSERT, UPDATE, DELETE, ALL
TO role                 -- anon, authenticated, or custom role
USING (expression)      -- Filter existing rows (SELECT, UPDATE, DELETE)
WITH CHECK (expression) -- Validate new/modified rows (INSERT, UPDATE)
```

### Role Reference

| Role | Description |
|------|-------------|
| `anon` | Unauthenticated users (public access) |
| `authenticated` | Logged-in users |
| `service_role` | Backend/admin access (bypasses RLS) |

## User-Based Patterns

### Owner Access

Users can only access their own records:

```sql
-- Enable RLS
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;

-- Read own profile
CREATE POLICY "Users read own profile"
ON user_profiles FOR SELECT
TO authenticated
USING ((SELECT auth.uid()) = user_id);

-- Update own profile
CREATE POLICY "Users update own profile"
ON user_profiles FOR UPDATE
TO authenticated
USING ((SELECT auth.uid()) = user_id)
WITH CHECK ((SELECT auth.uid()) = user_id);

-- Insert own profile
CREATE POLICY "Users create own profile"
ON user_profiles FOR INSERT
TO authenticated
WITH CHECK ((SELECT auth.uid()) = user_id);

-- Delete own profile
CREATE POLICY "Users delete own profile"
ON user_profiles FOR DELETE
TO authenticated
USING ((SELECT auth.uid()) = user_id);
```

### Public Read, Owner Write

Common for content that's publicly viewable but only editable by owner:

```sql
-- Anyone can read
CREATE POLICY "Public read access"
ON posts FOR SELECT
TO anon, authenticated
USING (true);

-- Only owner can modify
CREATE POLICY "Owner write access"
ON posts FOR ALL
TO authenticated
USING ((SELECT auth.uid()) = author_id)
WITH CHECK ((SELECT auth.uid()) = author_id);
```

## Team/Organization Patterns

### Team Membership Access

Users can access resources belonging to their teams:

```sql
-- Create team membership lookup function (security definer for performance)
CREATE OR REPLACE FUNCTION private.user_team_ids()
RETURNS SETOF UUID
LANGUAGE sql
SECURITY DEFINER
STABLE
SET search_path = ''
AS $$
  SELECT team_id
  FROM public.team_members
  WHERE user_id = (SELECT auth.uid())
$$;

-- Team resources policy
CREATE POLICY "Team members access resources"
ON team_resources FOR ALL
TO authenticated
USING (team_id IN (SELECT private.user_team_ids()))
WITH CHECK (team_id IN (SELECT private.user_team_ids()));
```

### Role-Based Team Access

Different permissions based on team role:

```sql
-- Create role check function
CREATE OR REPLACE FUNCTION private.user_has_team_role(
  check_team_id UUID,
  required_role TEXT
)
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
    AND role = required_role
  )
$$;

-- Admins can manage team settings
CREATE POLICY "Team admins manage settings"
ON team_settings FOR ALL
TO authenticated
USING ((SELECT private.user_has_team_role(team_id, 'admin')))
WITH CHECK ((SELECT private.user_has_team_role(team_id, 'admin')));

-- Members can read, admins can write
CREATE POLICY "Team members read"
ON team_documents FOR SELECT
TO authenticated
USING (team_id IN (SELECT private.user_team_ids()));

CREATE POLICY "Team admins write"
ON team_documents FOR INSERT, UPDATE, DELETE
TO authenticated
USING ((SELECT private.user_has_team_role(team_id, 'admin')))
WITH CHECK ((SELECT private.user_has_team_role(team_id, 'admin')));
```

## Hierarchical Patterns

### Parent-Child Access

Access child records through parent ownership:

```sql
-- Users access projects they own
CREATE POLICY "Owner access projects"
ON projects FOR ALL
TO authenticated
USING ((SELECT auth.uid()) = owner_id)
WITH CHECK ((SELECT auth.uid()) = owner_id);

-- Users access tasks in projects they own
CREATE POLICY "Owner access project tasks"
ON tasks FOR ALL
TO authenticated
USING (
  project_id IN (
    SELECT id FROM projects
    WHERE owner_id = (SELECT auth.uid())
  )
)
WITH CHECK (
  project_id IN (
    SELECT id FROM projects
    WHERE owner_id = (SELECT auth.uid())
  )
);
```

### Multi-Level Hierarchy

For deeply nested structures, use security definer functions:

```sql
-- Check access at any level of org hierarchy
CREATE OR REPLACE FUNCTION private.user_can_access_org(check_org_id UUID)
RETURNS BOOLEAN
LANGUAGE sql
SECURITY DEFINER
STABLE
SET search_path = ''
AS $$
  WITH RECURSIVE org_tree AS (
    -- Start with user's direct org memberships
    SELECT org_id FROM public.org_members
    WHERE user_id = (SELECT auth.uid())

    UNION

    -- Add child organizations
    SELECT o.id FROM public.organizations o
    INNER JOIN org_tree ot ON o.parent_id = ot.org_id
  )
  SELECT EXISTS (SELECT 1 FROM org_tree WHERE org_id = check_org_id)
$$;

-- Apply to resources
CREATE POLICY "Org hierarchy access"
ON org_resources FOR ALL
TO authenticated
USING ((SELECT private.user_can_access_org(org_id)))
WITH CHECK ((SELECT private.user_can_access_org(org_id)));
```

## Status-Based Patterns

### Published/Draft Content

```sql
-- Published content is public, drafts are owner-only
CREATE POLICY "Public reads published"
ON articles FOR SELECT
TO anon, authenticated
USING (
  status = 'published'
  OR (SELECT auth.uid()) = author_id
);

-- Only owner can modify
CREATE POLICY "Author modifies own"
ON articles FOR UPDATE, DELETE
TO authenticated
USING ((SELECT auth.uid()) = author_id);

-- Author creates with any status
CREATE POLICY "Author creates"
ON articles FOR INSERT
TO authenticated
WITH CHECK ((SELECT auth.uid()) = author_id);
```

### Soft Delete Pattern

```sql
-- Exclude soft-deleted records
CREATE POLICY "Hide deleted records"
ON records FOR SELECT
TO authenticated
USING (
  deleted_at IS NULL
  AND (SELECT auth.uid()) = owner_id
);

-- Allow soft delete (update deleted_at)
CREATE POLICY "Owner soft delete"
ON records FOR UPDATE
TO authenticated
USING ((SELECT auth.uid()) = owner_id)
WITH CHECK (
  (SELECT auth.uid()) = owner_id
  AND (deleted_at IS NULL OR deleted_at = OLD.deleted_at OR deleted_at = NOW())
);
```

## Time-Based Patterns

### Temporal Access

```sql
-- Access only current/future events
CREATE POLICY "Access active events"
ON events FOR SELECT
TO authenticated
USING (
  end_date >= CURRENT_DATE
  AND (is_public OR organizer_id = (SELECT auth.uid()))
);

-- Lock editing after event starts
CREATE POLICY "Edit before event"
ON events FOR UPDATE
TO authenticated
USING (
  organizer_id = (SELECT auth.uid())
  AND start_date > NOW()
);
```

## Admin Patterns

### App Metadata Admin Check

```sql
-- Check admin status from JWT app_metadata
CREATE POLICY "Admin full access"
ON sensitive_data FOR ALL
TO authenticated
USING (
  (SELECT (auth.jwt() -> 'app_metadata' ->> 'role')) = 'admin'
);
```

### Database Role Admin

```sql
-- Create admin check function
CREATE OR REPLACE FUNCTION private.is_admin()
RETURNS BOOLEAN
LANGUAGE sql
SECURITY DEFINER
STABLE
SET search_path = ''
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.user_roles
    WHERE user_id = (SELECT auth.uid())
    AND role = 'admin'
  )
$$;

-- Admin bypass with user access
CREATE POLICY "Admin or owner access"
ON resources FOR ALL
TO authenticated
USING (
  (SELECT private.is_admin())
  OR (SELECT auth.uid()) = owner_id
)
WITH CHECK (
  (SELECT private.is_admin())
  OR (SELECT auth.uid()) = owner_id
);
```

## Performance Optimization

### Index Critical Columns

```sql
-- Always index columns used in RLS policies
CREATE INDEX idx_profiles_user_id ON profiles(user_id);
CREATE INDEX idx_team_members_user_id ON team_members(user_id);
CREATE INDEX idx_team_members_team_id ON team_members(team_id);
CREATE INDEX idx_team_members_composite ON team_members(user_id, team_id);
```

### Wrap Functions in SELECT

```sql
-- SLOW: Function called per row
USING (auth.uid() = user_id)

-- FAST: Function result cached
USING ((SELECT auth.uid()) = user_id)
```

### Use STABLE Functions

```sql
CREATE FUNCTION private.get_user_teams()
RETURNS SETOF UUID
LANGUAGE sql
SECURITY DEFINER
STABLE  -- Tells Postgres result won't change within statement
SET search_path = ''
AS $$
  SELECT team_id FROM team_members WHERE user_id = (SELECT auth.uid())
$$;
```

### Avoid Joins in Policies

```sql
-- SLOW: Join in policy
USING (
  EXISTS (
    SELECT 1 FROM team_members tm
    WHERE tm.team_id = resources.team_id  -- Join!
    AND tm.user_id = (SELECT auth.uid())
  )
)

-- FAST: Pre-filter into set
USING (
  team_id IN (
    SELECT team_id FROM team_members
    WHERE user_id = (SELECT auth.uid())
  )
)
```

### Consolidate Policies

Multiple permissive policies use OR logic and all must be evaluated:

```sql
-- SLOW: Multiple policies
CREATE POLICY "policy_a" ON data USING (condition_a);
CREATE POLICY "policy_b" ON data USING (condition_b);

-- FAST: Single consolidated policy
CREATE POLICY "combined" ON data USING (condition_a OR condition_b);
```

## Testing RLS

### Test as Different Roles

```sql
-- Test as authenticated user
SET request.jwt.claim.sub = 'user-uuid-here';
SET request.jwt.claim.role = 'authenticated';
SELECT * FROM protected_table;

-- Test as anonymous
SET request.jwt.claim.role = 'anon';
SELECT * FROM protected_table;

-- Reset
RESET request.jwt.claim.sub;
RESET request.jwt.claim.role;
```

### Verify Policy Behavior

```sql
-- Check what policies exist
SELECT * FROM pg_policies WHERE tablename = 'your_table';

-- Explain query to see RLS impact
EXPLAIN (ANALYZE, BUFFERS) SELECT * FROM protected_table;
```
