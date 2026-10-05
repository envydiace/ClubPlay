alter table public.communities enable row level security;
alter table public.community_memberships enable row level security;

create policy "Members can read communities they belong to"
on public.communities
for select
to authenticated
using (
    exists (
        select 1
        from public.community_memberships cm
        where cm.community_id = communities.id
        and cm.member_id = auth.uid()
    )
);

create policy "Users can read own memberships"
on public.community_memberships
for select
to authenticated
using (member_id = auth.uid());
