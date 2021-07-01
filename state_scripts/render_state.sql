-- renders the world represented by state
--
-- Additional Notes:
--
-- The world is rendered as a single text field called world. The number of records is equal to config['HEIGHT'],
-- while the length of each field is equal to config['WIDTH']. If you are unfamiliar with config['SETTING']
-- notation, see the Additional Notes section of initialize_state.sql.
--
-- First we declare two recursive CTEs, one called x_dim and one called y_dim. The CTE x_dim generates all of the
-- natural numbers in the interval [0, config['WIDTH']). The CTE y_dim generates all of the natural numbers
-- in the interval [0, config['HEIGHT']). We then generate our coordinate set/plane by cross joining (i.e.
-- taking the Cartesian product) of x_dim and y_dim.
--
-- Now that we have our coordinate space, we check each coordinate in the space to see if the coordinate corresponds
-- to a live cell. Recall that state contains only the coordinates of live cells. As such, a coordinate in the plane
-- corresponds to a live cell if and only if that coordinate exists in state. A coordinate is adjusted for a toroidal grid
-- by taking the x_coordinate and y_coordinate modulo config['WIDTH'] and config['HEIGHT'] respectively.
-- The absolute value is then taken due to how SQLite calculates modulo (we want non-negative values only since we are using
-- a coordinate system whose components are natural numbers). We check for the existence of this adjusted coordinate in
-- state. If the adjusted coordinate exists, we render a character for a live cell, and if the adjusted coordinate does
-- not exist, we render a character for a dead cell.
--
-- At this point we have every coordinate in the plane mapped to a character for either a live cell or a dead cell.
-- However, this result is not the familiar xy plane we desire. Instead, this result has config['WIDTH']
-- * config['HEIGHT'] rows and 1 column. We use the group_concat function as a last step to render the
-- familiar grid. By using group_concat and grouping on y_coordinate, we effectively take each row (distinct
-- y_coordinate) and concatenate together all of the column values for that row. For example, suppose we have a 3 x 3
-- world with coordinates [(0, 0), (0, 1), (0, 2), (1, 0), (1, 1), (1, 2), (2, 0), (2, 1), (2, 2)]. Suppose state
-- contains the following coordinates [(1, 0), (1, 1), (1, 2)]. Then before applying group_concat, our data will look
-- like this (let 0 be the dead character, and 1 be the live character):
--
-- 0
-- 0
-- 0
-- 1
-- 1
-- 1
-- 0
-- 0
-- 0
--
-- After applying group_concat, our data will be in the following desired grid form:
--
-- 000
-- 111
-- 000
--
with recursive x_dim (coordinate, upper_limit) as (
        values(
            0,
            cast((select config.value from config where config.key = 'WIDTH') as integer)
        )
        union all
        select
            x_dim.coordinate + 1,
            x_dim.upper_limit
        from
            x_dim
        where
            x_dim.coordinate + 1 < x_dim.upper_limit
    ),
 y_dim (coordinate, upper_limit) as (
        values(
            0,
            cast((select config.value from config where config.key = 'HEIGHT') as integer)
        )
        union all
        select
            y_dim.coordinate + 1,
            y_dim.upper_limit
        from
            y_dim
        where
            y_dim.coordinate + 1 < y_dim.upper_limit
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
cross join
    y_dim
group by
    y_dim.coordinate;