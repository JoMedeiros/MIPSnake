# MIPSnake :snake:

## Intro

This is a version of classic snake game for MIPS processor written in Assembly.

## How to use :apple:

To run the `.asm` file you can download a MIPS emulator. The MIPS Mars is
a free emulator made in java that you can download [here](http://courses.missouristate.edu/KenVollmar/mars/).

### MARS's bugs :bug:

There's a bug in the Mars MIPS emulator. You may fix it following the instructions in this [link](https://dtconfect.wordpress.com/2013/02/09/mars-mips-simulator-lockup-hackfix/).

### The road so far...

Currently the snake is moving, the program stops when it collides with the wall and that's it. The file `Snake.asm` has the most recent functional version of the "game". 

## TODO list

- [x] Simulate a queue structure (FIFO).
- [ ] Store the snake pixels positions int the queue.
- [x] Generate random "apple" using syscall.
- [x] Walls collision.
- [ ] Verify if the "apple" collides with the snake.

## Authors

- [Josivan](https://www.github.com/JoMedeiros)
- [Natalia ](https://github.com/bnatalha)

