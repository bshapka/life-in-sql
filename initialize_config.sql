-- clears the config table, then loads it with configuration data
--
-- Descriptions:
--
-- MAX_X_COORDINATE: The largest x coordinate possible for rendering the state. Units are characters.
-- MAX_Y_COORDINATE: The largest y coordinate possible for rendering the state Units are characters.
-- DENSITY: The fraction of cells in the initial state of area (MAX_X_COORDINATE + 1) * (MAX_Y_COORDINATE + 1) that are
-- live
--
-- Additional Notes:
--
-- SQL lacks the graphical capabilities of other languages for obvious reasons, so approaches for rendering the state of
-- the game are somewhat limited. However, rendering the state via SQL is not unlike other languages in that the
-- dimensions of the plane to be rendered must be specified, hence the desire for storing MAX_X|Y_COORDINATE.
--
delete from config;
insert into config (key, value) values ("MAX_X_COORDINATE", "100");
insert into config (key, value) values ("MAX_Y_COORDINATE", "50");
insert into config (key, value) values ("DENSITY", "0.075");