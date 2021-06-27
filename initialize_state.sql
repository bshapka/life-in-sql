with recursive
    initial_state(n, x_coordinate, y_coordinate, state_size) as (
        values(
            0,
            abs(random() % cast((select value from config where key = 'MAX_X_COORDINATE') as integer)),
            abs(random() % cast((select value from config where key = 'MAX_Y_COORDINATE') as integer)),
            cast((select value from config where key = 'MAX_X_COORDINATE') as integer) *
            cast((select value from config where key = 'MAX_Y_COORDINATE') as integer) *
            cast((select value from config where key = 'DENSITY') as real)
        )
        union all
        select
            n + 1,
            abs(random() % cast((select value from config where key = 'MAX_X_COORDINATE') as integer)),
            abs(random() % cast((select value from config where key = 'MAX_Y_COORDINATE') as integer)),
            state_size
        from
            initial_state
        where
            n + 1 < state_size * 2
    )
insert into
    state
select distinct
    x_coordinate,
    y_coordinate
from
    initial_state
limit (select distinct state_size from initial_state);