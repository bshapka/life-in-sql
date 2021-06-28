-- updates state according to the rules of the game
--
-- Additional Notes:
--
-- First we create a table for holding the data from state that has been updated according to the rules of the game.
-- We call this table next_state. We construct this table so that it has the same fields as state but is empty.
--
-- Next we declare a CTE called candidates which takes each coordinate in state and generates its region. The region around
-- a coordinate is defined here to be the union of a) the Moore neighbourhood around the coordinate and b) the coordinate
-- itself. In other words, the region around a coordinate is the coordinate itself plus the 8 closest other coordinates.
-- To generate these regions for each coordinate in state, we define a recursive CTE called offset. Offset generates a
-- 3 x 1 result set containing the numbers [-1, 0, 1]. By cross joining offset to itself, we get a 9 x 2 Cartesian product
-- of offsets. Each offset is a tuple that we can add to a coordinate in a component-wise (x with x and y with y) manner to
-- translate the coordinate. Note that here the term "offset" refers to an element of the Cartesian product of the offset
-- CTE with itself, and not to the actual offset CTE. Next, we cross join the cross-joined offsets to state. This will
-- associate every coordinate in state with each of the 9 offsets. Then we add coordinates and offsets in the manner
-- described above to translate all coordinates. We call this set of translated coordinates the candidates.
--
-- In addition to x and y coordinates translated using offsets, candidates includes two other critical fields. The first
-- field checks to see if the translated coordinate exists in state. The second field counts how many times a translated
-- coordinate occurs in candidates. The rules of the game dictate that a cell is live if it occurs 3 times in the
-- candidates or if it occurs 4 times in the candidates and it is in the current state. So we filter candidates according
-- to these rules to get the next state (see the where clause of candidates).
--
-- The final steps are quite simple. We insert all records from candidates into next_state. Recall that candidates has
-- a where clause that discards records not desired for the next_state. We clear state so that it is ready to hold the
-- next state from next_state. We then insert all records from next_state into state. We then drop next_state.
--
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
    cross join
        offset as x_offset
    cross join
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