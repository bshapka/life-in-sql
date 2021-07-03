-- updates state according to the rules of the game
--
-- Additional Notes:
--
-- First we create a table for holding the data from state that has been updated according to the rules of the game.
-- We call this table next_state. We construct this table so that it has the same fields as state but is empty.
--
-- Next we declare a CTE called neighbours which takes each coordinate in state and generates its neighbours. The
-- neighbourhood around a given coordinate is defined to be the the Moore neighbourhood around that coordinate. In other
-- words, the neighbourhood around a given coordinate is the 8 closest other coordinates. To generate these neighbours
-- for each coordinate in state, we define a recursive CTE called offset. Offset generates a 3 x 1 result set containing
-- the numbers [-1, 0, 1]. By cross joining offset to itself, we get a 9 x 2 Cartesian product of offsets. We remove
-- the tuple (0, 0) for a reason that will be established soon. Each offset is a tuple that we can add to a coordinate
-- in a component-wise (x with x and y with y) manner to translate the coordinate. Hence we remove (0, 0) because
-- adding that to a coordinate would just result in the original coordinate (and we are trying to generate neighbours).
-- Note that here the term "offset" refers to an element of the Cartesian product of the offset CTE with itself, and not
-- to the actual offset CTE. Next, we cross join the cross-joined offsets to state. This will associate every coordinate
-- in state with each of the 8 offsets. Then we add coordinates and offsets in the manner described above to translate
-- all coordinates. We call this set of translated coordinates the neighbours.
--
-- In addition to x and y coordinates translated using offsets, neighbours includes two other critical fields. The first
-- field checks to see if the translated coordinate exists in state. The second field counts how many times a translated
-- coordinate occurs in neighbours. The rules of the game dictate that a cell is live if it occurs 3 times in the
-- neighbours or if it occurs 2 times in the neighbours and it is in the current state. So we filter neighbours according
-- to these rules to get the next state (see the where clause of neighbours).
--
-- The final steps are quite simple. We insert all records from neighbours into next_state. Recall that neighbours has
-- a where clause that discards records not desired for the next_state. We clear state so that it is ready to hold the
-- next state from next_state. We then insert all records from next_state into state. We then drop next_state.
--
create temporary table next_state as select * from state where 1 = 2;

with neighbours as (
    with recursive offset (n) as (
        values (-1)
        union all
        select
            n + 1
        from
            offset
        where
            n + 1 < 2
    )
    select
        state.x_coordinate + x_offset.n as x_coordinate,
        state.y_coordinate + y_offset.n as y_coordinate,
        case
        when exists (
            select
                1
            from
                state s0
            where
                s0.x_coordinate = state.x_coordinate + x_offset.n
                and s0.y_coordinate = state.y_coordinate + y_offset.n
        )
        then
            1
        else
            0
        end as exists_in_state,
        count(*) as cnt
    from
        state
    cross join
        offset as x_offset
    cross join
        offset as y_offset
    where
        not (x_offset.n = 0 and y_offset.n = 0)
    group by
        state.x_coordinate + x_offset.n,
        state.y_coordinate + y_offset.n
)
insert into
    next_state
select
    neighbours.x_coordinate,
    neighbours.y_coordinate
from
    neighbours
where
    neighbours.cnt = 3
   or (neighbours.cnt = 2 and neighbours.exists_in_state = 1);

delete from state;
insert into state select * from next_state;
drop table next_state;