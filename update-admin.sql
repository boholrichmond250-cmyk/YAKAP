-- Run ONCE in Supabase > SQL Editor if you already set up the database earlier.
-- Adds "Create administrator account" requests (the administrator approves them in Profile).
alter table public.profiles add column if not exists admin_request boolean default false;

create or replace function public.handle_new_user() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles(id, email, name, role, admin_request)
  values (new.id, new.email, coalesce(new.raw_user_meta_data->>'name', new.email),
    case when exists(select 1 from public.profiles where role = 'admin') then 'personnel' else 'admin' end,
    coalesce((new.raw_user_meta_data->>'want_admin')::boolean, false));
  return new;
end $$;
