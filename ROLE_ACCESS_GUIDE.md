# CONTINUUM — Role Access Guide

## Roles and permissions

| Role | Module access | Add / edit | Delete records | Settings & Data |
|---|---|---:|---:|---:|
| Administrator | All six modules | Yes | Yes | Yes |
| Manager | All six modules | Yes | No | No |
| Inventory Staff | Inventory | Yes | No | No |
| Production Staff | Planning, Production | Yes | No | No |
| Quality Staff | Quality, Process & Inspection | Yes | No | No |
| Dispatch Staff | Dispatch | Yes | No | No |

Dashboard is available to all roles. Maintenance and machine breakdown actions are part of the Production module.

## Supabase setup

1. Confirm `supabase-schema.sql` has already been run.
2. Run the updated `supabase-role-security-migration.sql` in Supabase SQL Editor.
3. The migration adds `Manager` to the allowed role values and applies module-aware read/write policies to `manufacturing_records`.
4. Create a separate test user through Supabase Authentication for each staff role.
5. Add each test user to the correct workspace membership using a trusted administrator workflow, and assign one of the role names shown above.
6. Sign in with each test account and complete the role checks in `QA_CHECKLIST.md`.

## Assigning a role for a test account

Use Supabase SQL Editor as the project owner/admin. First find the authenticated user's UUID in Authentication → Users and the workspace UUID from the existing workspace. Then use a scoped update like this, replacing the example UUID values and role:

```sql
update public.workspace_members
set role = 'Inventory Staff'
where workspace_id = 'YOUR-WORKSPACE-UUID'::uuid
  and user_id = 'YOUR-AUTH-USER-UUID'::uuid;
```

Allowed values: `Administrator`, `Manager`, `Inventory Staff`, `Production Staff`, `Quality Staff`, `Dispatch Staff`.

Do not add membership-management permissions to browser clients and do not place a Supabase service-role key in frontend JavaScript. Employee invitation, deactivation and self-service role management are not included in this build.

## Important LocalStorage limitation

The role-aware UI hides unauthorized modules and actions, and the SQL migration protects cloud `manufacturing_records`. However, this version still stores day-to-day module records in browser LocalStorage. LocalStorage is shared by users of the same browser profile and can be inspected or modified by that browser user. Therefore these UI controls are useful for a classroom demonstration, but they are not a complete secure multi-user boundary until module records are moved to server-backed storage and tested end-to-end.
