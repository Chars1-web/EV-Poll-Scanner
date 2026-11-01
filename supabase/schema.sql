create extension if not exists pgcrypto;

create table if not exists public.sports_events (
  id uuid primary key default gen_random_uuid(),
  external_id text,
  sport_key text not null,
  league_name text,
  home_name text not null,
  away_name text not null,
  starts_at timestamptz,
  event_status text not null default 'scheduled',
  source_name text not null,
  source_updated_at timestamptz,
  created_at timestamptz not null default now(),
  unique (source_name, external_id)
);

create table if not exists public.poll_forecasts (
  id uuid primary key default gen_random_uuid(),
  event_id uuid references public.sports_events(id) on delete cascade,
  source_name text not null,
  source_poll_id text,
  outcome_label text not null,
  probability numeric(6,5) not null check (probability >= 0 and probability <= 1),
  sample_size integer check (sample_size is null or sample_size >= 0),
  captured_at timestamptz not null default now(),
  source_url text,
  is_demo boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists public.event_results (
  id uuid primary key default gen_random_uuid(),
  event_id uuid not null references public.sports_events(id) on delete cascade,
  outcome_label text not null,
  is_final boolean not null default false,
  source_name text not null,
  verified_at timestamptz,
  created_at timestamptz not null default now(),
  unique (event_id, outcome_label, source_name)
);

create table if not exists public.data_imports (
  id uuid primary key default gen_random_uuid(),
  source_name text not null,
  import_type text not null check (import_type in ('schedule','poll','result')),
  status text not null default 'pending' check (status in ('pending','success','failed')),
  records_seen integer not null default 0,
  records_imported integer not null default 0,
  error_message text,
  started_at timestamptz not null default now(),
  completed_at timestamptz
);

create index if not exists sports_events_start_idx on public.sports_events(starts_at);
create index if not exists sports_events_sport_idx on public.sports_events(sport_key);
create index if not exists poll_forecasts_event_idx on public.poll_forecasts(event_id, captured_at desc);
create index if not exists event_results_event_idx on public.event_results(event_id, is_final);

alter table public.sports_events enable row level security;
alter table public.poll_forecasts enable row level security;
alter table public.event_results enable row level security;
alter table public.data_imports enable row level security;

-- No public write policies are created. Add narrowly scoped policies after
-- deciding whether imports are admin-only or user-owned. Keep service-role
-- credentials on the server and never expose them in browser code.
