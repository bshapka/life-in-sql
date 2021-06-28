-- represents the state of the game
--
-- Additional Notes:
--
-- The records in this table correspond to the coordinates of live cells in the world at a given point in time. Note
-- that these coordinates are unique (having duplicate coordinates is redundant). Also note that only the coordinates
-- of live cells are stored. The reason for this is not specific to SQL implementations of Life, so no more will be said
-- about this choice here. Consult the README for a full explanation of why only live cells are stored.
--
create table state (
    x_coordinate integer not null, -- represents the x coordinate of a live cell in the game
    y_coordinate integer not null, -- represents the y coordinate of a live cell in the game
    primary key (x_coordinate, y_coordinate)
);