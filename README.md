# Simple-TSP-Solver-GUI-in-Processing
Small UI to see algorithmic output for a TSP (Travelling Salesman Problem) algorithm. Written in Processing 3 - Java. Useful if you think you can solve P = NP and want to write it out.

## Functions
There are only two functions you need to worry about: `updateCities()` and `resetConditions()`

`updateCities()` takes in two arguments: two `ArrayList` objects of Cities. A City is a class represented in the simple code. The first ArrayList contains cities that have not been used yet. The second ArrayList contains those which have been set. The way edges are represented are in the ArrayList. Adjacent entries in the second ArrayList `chosenCities` are considered to have an edge connecting them.

`resetConditions()` takes the previously mentioned ArrayList and performs a computation to see if the TSP algorithm is complete. It will then restart and keep track of the best distance found.

## GUI

On the top-left is a slider for the number of cities you wish to test. It ranges from 0-1000, but you can change that in the top of tsp.pde if you wish to go higher.

The top-right is self-explanatory: the number of cities being tested, the current path's distance, and the best found for the current number of cities. This best number will reset if the number of cities in the scrollbar is changed.

## Controls

Left and right keys can change the scrollbar by a certain percentage. You can also use your mouse to change the value. That's about it.

Have fun.