# Life in SQL
This project is an implementation of Conway's Game of Life (or Life for short) in Structured Query Language (SQL).

## About the code
The source code of this project was written in SQL, specifically the SQLite dialect. **No procedural extension of SQL was
used.** Here is a high-level summary of the components:
* The script `create_config.sql` creates the table `config` (used to hold configuration settings)
* The script `initialize_config.sql` empties and then loads `config`
* The script `create_state.sql` creates the table `state` (used to hold the current state of the world)
* The script `initialize_state.sql` empties `state`, then uses `config` to load `state` with random data
* The script `render_state.sql` renders the contents of `state` in grid form
* The script `update_state.sql` replaces the data in `state` with data corresponding to the next state of the world
* The script `play.sql` runs `render_state.sql` and `update_state.sql` in that order
* The file `play.db` is a SQLite3 database file that is the intended target for all of the above scripts

All scripts are extensively documented in their source files, so those details won't be repeated here. This project is
largely an exploratory proof-of-concept, and SQL is not well-suited to implementing Life for various reasons. As such,
the documentation in most scripts has a section called Additional Notes. These sections contain detailed explanations
of each script at a level of detail that would typically not be supplied.

### Implementation Details
This sub-section assumes basic familiarity with Life. If you are not familiar with Life but want to 
read this section, please read the section [About Life](#about-life) below, or consult a source like 
Wikipedia on the game.

Common implementations of Life (including the first release of this project) represent the state of 
a world as a 2D list of bits or booleans. Typically a live cell is truthy while a dead cell is falsy. 
While this approach is intuitive, dead calls don't need to be tracked, and doing so can have storage and memory costs.

An alternative approach is to store only the coordinates of live cells, requiring less memory and storage.

This implementation uses a toroidal grid. As such, objects that leave the screen on one edge will re-enter the screen 
with the same trajectory and velocity at the equivalent location on the opposing edge.

### Running the Project
The following is a set of recommended directions for running the project. Note that these directions assume an SQLite3 
binary exists and is associated with the shell command `sqlite3`. The project was developed and tested with version 3.32.3 
of SQLite. Compatibility with previous versions is not guaranteed.
* Start a shell session and navigate to the root directory of the project/cloned repo
* Run the command `sqlite3 life.db '.read initialize_state.sql` to randomly generate an initial state
* Run the command `sqlite3 life.db '.read play.sql` first render the state and then update the state to the next state

Re-run `play.sql` using the above method as many times as you desire to render and update the state. Since no procedural
extension of SQL was used, there is no animation loop, and hence the user must render and advance the state manually. 

Porting the code to another type of database system would likely be fairly quick and easy, but this has not been tested.

## About Life
Life is a cellular automation created by the English mathematician John Conway. As a cellular automation, 
Life has the following elements:
* A two-dimensional grid of cells, where each cell in the grid has an attribute called a state
* A set of states that a cell can be in
* A transition function that maps a cell's state and the states of its neighbours to a new state

For Life in particular:
* A cell can be in one of two states: dead or live
* The transition function consists of the following rules:
    * If a cell is live and has 2 or 3 live neighbours, the cell's next state is live
    * If a cell is dead but has 3 live neighbours, the cell's next state is live
    * All other cells have a next state of dead
    
Note that for Life, a cell's neighbours are defined using the 
[Moore neighbourhood](https://en.wikipedia.org/wiki/Moore_neighborhood) definition.

The game is played by setting an initial state, and then repeatedly applying the rules of the game 
to generate successive states.

Life is interesting for several reasons:
* Emergence: repeated application of simple rules to a simple initial state can result in very 
complex and intricate future states
* Undecidability: no algorithm can take two states and determine if application of the rules
to one of the states will yield the other state
* Turing completeness: the game can theoretically simulate any Turing machine
* Self-similarity: the game can be implemented in itself 
(see [Life in Life](https://www.youtube.com/watch?v=xP5-iIeKXE8))

## About John Conway
John Horton Conway (1937 – 2020) was an English mathematician. Born in Liverpool, Conway resolved 
at the young age of 11 to become a mathematician at Cambridge. He graduated with his Ph.D. from 
Cambridge in 1964, and he retired in 2013. In addition to his long and influential career as 
a researcher, Conway was lauded for being a kind and eccentric character and a gifted expositor of 
mathematics. For a full account of Conway’s life, see the book Genius at Play: The Curious Mind of 
John Horton Conway by Siobhan Roberts. Conway passed away on Saturday, April 11, 2020, from 
COVID-19. He was 82.