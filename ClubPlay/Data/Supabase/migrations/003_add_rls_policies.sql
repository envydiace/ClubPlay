create or replace function public.shares_community_with(
    target_member_id uuid
)
returns boolean
language sql
security definer
set search_path = public
stable
as $$
    select exists (
        select 1
        from public.community_memberships mine
        join public.community_memberships theirs
          on theirs.community_id = mine.community_id
        where mine.member_id = auth.uid()
          and theirs.member_id = target_member_id
    );
$$;

grant execute
on function public.shares_community_with(uuid)
to authenticated;

create policy "Community members can read shared member profiles"
on public.profiles
for select
to authenticated
using (
    id = auth.uid()
    or public.shares_community_with(id)
);
