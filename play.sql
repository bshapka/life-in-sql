create temporary table next_state as select * from state where 1 = 2;

with candidates as (
    with recursive offset (n) as (
        values (
            -1
        )
        union all
        select
            n + 1
        from
            offset
        where
            n + 1 < 2
    )
    select
        x_coordinate + x_offset.n as x_coordinate,
        y_coordinate + y_offset.n as y_coordinate,
        case
        when exists (
            select
                1
            from
                state s0
            where
                s0.x_coordinate = x_coordinate + x_offset.n
                and s0.y_coordinate = y_coordinate + y_offset.n
        )
        then
            1
        else
            0
        end as exists_in_state,
        count(*) as cnt
    from state
             join
         offset as x_offset
             join
         offset as y_offset
    group by x_coordinate + x_offset.n,
             y_coordinate + y_offset.n
)
insert into
    next_state
select
    candidates.x_coordinate,
    candidates.y_coordinate
from
    candidates
where
    cnt = 3 or (cnt = 4 and exists_in_state = 1);

delete from state;
insert into state select * from next_state;
drop table next_state;

with recursive x_dim (coordinate, upper_limit) as (
        values(
            0,
            cast((select value from config where key = 'MAX_X_COORDINATE') as integer)
        )
        union all
        select
            coordinate + 1,
            upper_limit
        from
            x_dim
        where
            coordinate + 1 <= upper_limit
    ),
 y_dim (coordinate, upper_limit) as (
        values(
            0,
            cast((select value from config where key = 'MAX_Y_COORDINATE') as integer)
        )
        union all
        select
            coordinate + 1,
            upper_limit
        from
            y_dim
        where
            coordinate + 1 <= upper_limit
    )
select
    group_concat(
        case
        when exists (
            select 1 from
                state
            where
                abs(state.x_coordinate % (select distinct x_dim.upper_limit from x_dim)) = x_dim.coordinate
                and abs(state.y_coordinate % (select distinct y_dim.upper_limit from y_dim)) = y_dim.coordinate
        )
        then
            '*'
        else
            ' '
        end,
        ''
    ) as world
from
    x_dim
join
    y_dim
group by
    y_dim.coordinate