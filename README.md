# Life in SQL
This project is an implementation of Conway's Game of Life (or Life for short) in Structured Query Language (SQL).

## About the code
The source code of this project was written in SQL (specifically the SQLite dialect).

Here is a high-level summary of the resources:
TODO

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

TODO

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