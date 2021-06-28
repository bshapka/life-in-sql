-- clears the state table, then loads it with random coordinates subject to constraints acquired from config entries
--
-- Additional Notes:
--
-- First state is cleared of all data. Then a recursive CTE is used to generate a random initial data set for state, and
-- this is inserted into the table. Note that the notation config['SETTING'] means "the value field of the record in config
-- with key = 'SETTING'". Recall that since config.key is the primary key of config, config['SETTING'] either specifies
-- NULL (if 'SETTING' does not exist in config.key) or a single non-NULL value (if 'SETTING' exists in config.key).
--
-- By construction, the data generated for the initial state adheres to the following conditions:
--
-- 1) x_coordinate is a random integer in the interval [0, config['WIDTH'])
-- 2) y_coordinate is a random integer in the interval [0, config['HEIGHT'])
-- 3) The size of the initial state is the floor of
--    config['WIDTH'] * config['HEIGHT'] * config['DENSITY']
--
-- Note that the CTE generates twice as many records than actually desired (see the where clause of the CTE), and then
-- the desired number of records are taken (see the limit clause of the outer select statement). This is done because
-- we require the records in the initial state to be distinct. In fact, non-distinct initial states are not possible
-- because the primary key of state is (state.x_coordinate, state.y_coordinate). However, the random() function has
-- no memory, so it is possible (though quite unlikely) that its use will result in at least one duplicate record. So to
-- address this, we generate twice as many records as desired, and then select distinct records from this generated
-- set of records using a limit equal to our actual desired number of records. In theory, this approach could result
-- in an initial state size that is smaller than the desired initial state size. This would occur if more than half of
-- the records in the generated state are duplicates. Needless to say, this is extraordinarily unlikely.
--
delete from state;

with recursive initial_state(n, x_coordinate, y_coordinate, state_size) as (
    values(
        0,
        abs(random() % cast((select value from config where key = 'WIDTH') as integer)),
        abs(random() % cast((select value from config where key = 'HEIGHT') as integer)),
        cast(
            cast((select value from config where key = 'WIDTH') as integer) *
            cast((select value from config where key = 'HEIGHT') as integer) *
            cast((select value from config where key = 'DENSITY') as real)
            as integer
        )
    )
    union all
    select
        n + 1,
        abs(random() % cast((select value from config where key = 'WIDTH') as integer)),
        abs(random() % cast((select value from config where key = 'HEIGHT') as integer)),
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