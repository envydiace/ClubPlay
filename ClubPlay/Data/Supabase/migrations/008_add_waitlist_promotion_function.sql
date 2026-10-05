create or replace function public.promote_next_waitlisted_player(
    p_game_id uuid
)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
    promoted_registration_id uuid;
begin
    select id
    into promoted_registration_id
    from public.weekly_game_registrations
    where game_id = p_game_id
      and registration_status = 'waitlisted'
    order by registered_at asc
    limit 1;

    if promoted_registration_id is null then
        return null;
    end if;

    update public.weekly_game_registrations
    set
        registration_status = 'confirmed',
        updated_at = now()
    where id = promoted_registration_id;

    return promoted_registration_id;
end;
$$;
