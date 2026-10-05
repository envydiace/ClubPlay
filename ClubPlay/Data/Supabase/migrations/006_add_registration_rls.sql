alter table public.weekly_game_registrations
enable row level security;

create policy "Members can read own registrations"
on public.weekly_game_registrations
for select
to authenticated
using (
    member_id = auth.uid()
);

create policy "Community organisers can read game registrations"
on public.weekly_game_registrations
for select
to authenticated
using (
    exists (
        select 1
        from public.weekly_football_games g
        join public.community_memberships cm
          on cm.community_id = g.community_id
        where g.id = weekly_game_registrations.game_id
          and cm.member_id = auth.uid()
          and cm.role = 'organiser'
    )
);

create policy "Members can create own registrations"
on public.weekly_game_registrations
for insert
to authenticated
with check (
    member_id = auth.uid()
);

create policy "Members can update own registrations"
on public.weekly_game_registrations
for update
to authenticated
using (
    member_id = auth.uid()
)
with check (
    member_id = auth.uid()
);

create policy "Organisers can update registrations in their community"
on public.weekly_game_registrations
for update
to authenticated
using (
    exists (
        select 1
        from public.weekly_football_games g
        join public.community_memberships cm
          on cm.community_id = g.community_id
        where g.id = weekly_game_registrations.game_id
          and cm.member_id = auth.uid()
          and cm.role = 'organiser'
    )
);

