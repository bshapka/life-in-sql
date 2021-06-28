-- clears the config table, then loads it with configuration data
--
-- Descriptions:
--
-- WIDTH: The width (horizontal dimension) of the rectangular area for rendering state. Units are characters.
-- HEIGHT: The height (vertical dimension) of the rectangular area for rendering state. Units are characters.
-- DENSITY: The fraction of cells in the initial state of area WIDTH * HEIGHT that are live
--
-- Additional Notes:
--
-- SQL lacks the graphical capabilities of other languages for obvious reasons, so approaches for rendering the state of
-- the game are somewhat limited. However, rendering the state via SQL is not unlike other languages in that the
-- dimensions of the plane to be rendered must be specified, hence the desire for storing WIDTH and HEIGHT.
--
delete from config;
insert into config (key, value) values ("WIDTH", "100");
insert into config (key, value) values ("HEIGHT", "50");
insert into config (key, value) values ("DENSITY", "0.075");