# Life in SQL
This project is an implementation of Conway's Game of Life (or Life for short) in Structured Query Language (SQL).

## About Life
For information about the game, see [About Life](https://github.com/bshapka/life-in-x/blob/main/ABOUT_LIFE.md).
For information about tne creator of the game, see [About John Conway](https://github.com/bshapka/life-in-x/blob/main/ABOUT_CONWAY.md).

## Running the Project
The following is a set of recommended directions for running the project. Note that these directions assume an SQLite3 
binary exists and is associated with the shell command `sqlite3`. The project was developed and tested with version 3.32.3 
of SQLite. Compatibility with previous versions may exist but is not guaranteed.
* Start a shell session and navigate to the root directory of the project/cloned repo
* Run the command `sqlite3 life.db '.read initialize_state.sql'` to randomly generate an initial state
* Run the command `sqlite3 life.db '.read play.sql'` to first render the state and then update the state

Re-run `play.sql` using the above method as many times as you desire to render and update the state. Since no procedural
extension of SQL was used, there is no animation loop, and so the user must render and advance the state manually.

## Implementation Details
This section assumes basic familiarity with Life. If you are not familiar with Life but want to 
read this section, please read the section [About Life](https://github.com/bshapka/life-in-x/blob/main/ABOUT_LIFE.md), 
or consult a source like Wikipedia on the game.

All source files are well-documented, so explanations of or details about these files will not be supplied here. 
This project is largely an exploratory proof-of-concept, and SQL is not well-suited to implementing Life for various 
reasons. As such, the documentation in most scripts has a section called Additional Notes. These sections contain 
detailed explanations of each script at a level of detail that would generally not be supplied.

Common implementations of Life represent the state of a world as a 2D list of bits or booleans. Typically 
a live cell is truthy while a dead cell is falsy. While this approach is intuitive, dead calls don't need
to be stored, and doing so can have costs in terms of memory and storage.

An alternative approach is to store only the coordinates of live cells, requiring less memory and storage.

This implementation uses a toroidal grid. As such, objects that leave the screen on one edge will re-enter the screen 
with the same trajectory and velocity at the equivalent location on the opposing edge.
