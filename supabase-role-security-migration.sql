-- CONTINUUM role-based authorization hardening (v2)
-- Run this AFTER supabase-schema.sql in Supabase SQL Editor.
-- Roles: Administrator, Manager, Inventory Staff, Production Staff,
-- Quality Staff and Dispatch Staff.

-- Extend the existing membership role constraint safely.
do $$
begin
  if exists (
    select 1 from pg_constraint
    where conname = 'workspace_members_role_check'
      and conrelid = 'public.workspace_members'::regclass
  ) then
    alter table public.workspace_members drop constraint workspace_members_role_check;
  end if;
  alter table public.workspace_members
    add constraint workspace_members_role_check
    check (role in ('Administrator','Manager','Inventory Staff','Production Staff','Quality Staff','Dispatch Staff'));
end $$;

-- Read access is limited to the modules assigned to each staff role.
create or replace function public.can_view_module(target_workspace uuid, target_module text)
returns boolean
language sql
stable
security definer
set search_path=''
as $$
  select exists (
    select 1
    from public.workspace_members m
    where m.workspace_id = target_workspace
      and m.user_id = (select auth.uid())
      and m.active = true
      and (
        m.role in ('Administrator','Manager')
        or (m.role = 'Inventory Staff' and target_module = 'inventory')
        or (m.role = 'Production Staff' and target_module in ('planning','production'))
        or (m.role = 'Quality Staff' and target_module in ('quality','inspection'))
        or (m.role = 'Dispatch Staff' and target_module = 'dispatch')
      )
  );
$$;

-- Edit access follows the same module map. Manager can edit all modules,
-- but only Administrator can delete records or manage workspace membership.
create or replace function public.can_edit_module(target_workspace uuid, target_module text)
returns boolean
language sql
stable
security definer
set search_path=''
as $$
  select public.can_view_module(target_workspace, target_module);
$$;

revoke all on function public.can_view_module(uuid,text) from public;
revoke all on function public.can_edit_module(uuid,text) from public;
grant execute on function public.can_view_module(uuid,text) to authenticated;
grant execute on function public.can_edit_module(uuid,text) to authenticated;

-- Replace broad workspace-wide read/write policies with module-aware policies.
drop policy if exists "Members view records" on public.manufacturing_records;
drop policy if exists "Members add records" on public.manufacturing_records;
drop policy if exists "Members update records" on public.manufacturing_records;
drop policy if exists "Admins delete records" on public.manufacturing_records;
drop policy if exists "Authorized roles view module records" on public.manufacturing_records;
drop policy if exists "Authorized roles add module records" on public.manufacturing_records;
drop policy if exists "Authorized roles update module records" on public.manufacturing_records;
drop policy if exists "Only administrators delete records" on public.manufacturing_records;

create policy "Authorized roles view module records"
on public.manufacturing_records for select to authenticated
using (public.can_view_module(workspace_id,module));

create policy "Authorized roles add module records"
on public.manufacturing_records for insert to authenticated
with check (
  public.can_edit_module(workspace_id,module)
  and created_by = (select auth.uid())
);

create policy "Authorized roles update module records"
on public.manufacturing_records for update to authenticated
using (public.can_edit_module(workspace_id,module))
with check (public.can_edit_module(workspace_id,module));

create policy "Only administrators delete records"
on public.manufacturing_records for delete to authenticated
using (public.is_workspace_admin(workspace_id));

-- Activity history is append-only. Workspace members can read the activity feed;
-- no UPDATE or DELETE permissions are granted.
revoke update, delete on public.activity_logs from authenticated;
grant select, insert on public.activity_logs to authenticated;

-- Membership changes are not exposed to browser clients. A trusted server-side
-- invitation/role-management function is required; never use a service-role key
-- in frontend JavaScript.
revoke insert, update, delete on public.workspace_members from authenticated;
grant select on public.workspace_members to authenticated;
