create extension if not exists "pgcrypto";

create table public.profiles (
    id uuid primary key references auth.users(id) on delete cascade,
    full_name text not null,
    email text not null,
    created_at timestamptz not null default now()
);

create table public.communities (
    id uuid primary key default gen_random_uuid(),
    name text not null,
    created_at timestamptz not null default now(),
    created_by uuid not null references public.profiles(id)
);

create table public.community_memberships (
    id uuid primary key default gen_random_uuid(),
    member_id uuid not null references public.profiles(id) on delete cascade,
    community_id uuid not null references public.communities(id) on delete cascade,
    role text not null check (role in ('member', 'organiser')),
    joined_at timestamptz not null default now(),

    constraint unique_community_member
        unique (member_id, community_id)
);

create table public.weekly_football_games (
    id uuid primary key default gen_random_uuid(),
    community_id uuid not null references public.communities(id) on delete cascade,

    game_name text not null,
    venue_name text not null,

    kick_off_at timestamptz not null,
    finishes_at timestamptz not null,

    player_capacity integer not null check (player_capacity > 0),

    registration_opens_at timestamptz not null,
    registration_closes_at timestamptz not null,

    cancellation_deadline_hours integer not null default 2
        check (cancellation_deadline_hours >= 0),

    status text not null default 'draft'
        check (status in ('draft', 'published', 'closed', 'cancelled')),

    created_at timestamptz not null default now(),
    created_by uuid not null references public.profiles(id),

    constraint valid_game_time
        check (finishes_at > kick_off_at),

    constraint valid_registration_window
        check (
            registration_opens_at < registration_closes_at
            and registration_closes_at <= kick_off_at
        )
);

create table public.weekly_game_registrations (
    id uuid primary key default gen_random_uuid(),

    member_id uuid not null references public.profiles(id) on delete cascade,
    game_id uuid not null references public.weekly_football_games(id) on delete cascade,

    registration_status text not null
        check (
            registration_status in (
                'confirmed',
                'waitlisted',
                'cancelled'
            )
        ),

    attendance_status text not null default 'absent'
        check (
            attendance_status in (
                'absent',
                'present'
            )
        ),

    registered_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),

    constraint unique_member_game_registration
        unique (member_id, game_id)
);

create table public.member_bans (
    id uuid primary key default gen_random_uuid(),

    community_id uuid not null references public.communities(id) on delete cascade,
    member_id uuid not null references public.profiles(id) on delete cascade,
    source_game_id uuid not null references public.weekly_football_games(id),

    started_at timestamptz not null default now(),
    ends_at timestamptz not null,

    reason text not null default 'absence'
        check (reason in ('absence')),

    created_by uuid not null references public.profiles(id),

    created_at timestamptz not null default now(),

    constraint valid_ban_period
        check (ends_at > started_at)
);
