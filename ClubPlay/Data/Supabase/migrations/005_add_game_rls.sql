alter table public.weekly_football_games
enable row level security;

create policy "Community members can read games"
on public.weekly_football_games
for select
to authenticated
using (
    exists (
        select 1
        from public.community_memberships cm
        where cm.community_id = weekly_football_games.community_id
        and cm.member_id = auth.uid()
    )
);

create policy "Organisers can create games"
on public.weekly_football_games
for insert
to authenticated
with check (
    exists (
        select 1
        from public.community_memberships cm
        where cm.community_id = weekly_football_games.community_id
        and cm.member_id = auth.uid()
        and cm.role = 'organiser'
    )
);

create policy "Organisers can update games"
on public.weekly_football_games
for update
to authenticated
using (
    exists (
        select 1
        from public.community_memberships cm
        where cm.community_id = weekly_football_games.community_id
        and cm.member_id = auth.uid()
        and cm.role = 'organiser'
    )
)
with check (
    exists (
        select 1
        from public.community_memberships cm
        where cm.community_id = weekly_football_games.community_id
        and cm.member_id = auth.uid()
        and cm.role = 'organiser'
    )
);
