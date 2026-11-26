-- ============================================================
-- YAKAP Claim System - database setup (run ONCE, whole file)
-- Supabase > SQL Editor > New query > paste all > Run
-- Safe to run again: it will not duplicate anything.
-- ============================================================

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  email text,
  name text,
  role text not null default 'personnel' check (role in ('admin','personnel')),
  created_at timestamptz default now()
);

create table if not exists public.claims (
  id bigint generated always as identity primary key,
  year int not null,
  month int not null check (month between 0 and 11),
  month_to int,
  registered int not null default 0,
  transmitted int not null default 0,
  returned int not null default 0,
  denied int not null default 0,
  errs int not null default 0,
  net numeric not null default 0,
  created_by uuid default auth.uid(),
  created_at timestamptz default now()
);
alter table public.claims add column if not exists month_to int;
alter table public.claims add column if not exists errs int not null default 0;

create table if not exists public.error_denied (
  id bigint generated always as identity primary key,
  year int not null,
  month int not null check (month between 0 and 11),
  month_to int,
  kind text not null check (kind in ('error','denied')),
  n int not null check (n > 0),
  created_by uuid default auth.uid(),
  created_at timestamptz default now()
);

create or replace function public.is_admin() returns boolean
language sql security definer set search_path = public as $$
  select exists(select 1 from public.profiles where id = auth.uid() and role = 'admin');
$$;

-- The FIRST account created becomes the administrator; everyone after is personnel.
create or replace function public.handle_new_user() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles(id, email, name, role)
  values (new.id, new.email, coalesce(new.raw_user_meta_data->>'name', new.email),
    case when exists(select 1 from public.profiles where role = 'admin') then 'personnel' else 'admin' end);
  return new;
end $$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users
for each row execute function public.handle_new_user();

create or replace function public.delete_my_account() returns void
language sql security definer set search_path = public, auth as $$
  delete from auth.users where id = auth.uid();
$$;
grant execute on function public.delete_my_account() to authenticated;

alter table public.profiles enable row level security;
alter table public.claims enable row level security;
alter table public.error_denied enable row level security;

drop policy if exists "profiles read" on public.profiles;
drop policy if exists "profiles admin update" on public.profiles;
drop policy if exists "profiles admin delete" on public.profiles;
create policy "profiles read" on public.profiles for select to authenticated
  using (id = auth.uid() or public.is_admin());
create policy "profiles admin update" on public.profiles for update to authenticated
  using (public.is_admin()) with check (public.is_admin());
create policy "profiles admin delete" on public.profiles for delete to authenticated
  using (public.is_admin());

drop policy if exists "claims read" on public.claims;
drop policy if exists "claims admin insert" on public.claims;
drop policy if exists "claims admin update" on public.claims;
drop policy if exists "claims admin delete" on public.claims;
create policy "claims read" on public.claims for select to authenticated using (true);
create policy "claims admin insert" on public.claims for insert to authenticated with check (public.is_admin());
create policy "claims admin update" on public.claims for update to authenticated using (public.is_admin()) with check (public.is_admin());
create policy "claims admin delete" on public.claims for delete to authenticated using (public.is_admin());

drop policy if exists "ed read" on public.error_denied;
drop policy if exists "ed admin insert" on public.error_denied;
drop policy if exists "ed admin update" on public.error_denied;
drop policy if exists "ed admin delete" on public.error_denied;
create policy "ed read" on public.error_denied for select to authenticated using (true);
create policy "ed admin insert" on public.error_denied for insert to authenticated with check (public.is_admin());
create policy "ed admin update" on public.error_denied for update to authenticated using (public.is_admin()) with check (public.is_admin());
create policy "ed admin delete" on public.error_denied for delete to authenticated using (public.is_admin());
