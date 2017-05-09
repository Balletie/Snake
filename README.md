# Snake

Hello!

This is the source code of the bootable game Snake I have made. It is written in Assembly, using a tiny library 
called "bootlib" (see the LICENSE and README files in the bootlib directory), made by [Maarten de Vries](https://github.com/de-vri-es/) and [Maurice Bos](https://github.com/m-ou-se/)

You may do whatever you want to do with this, as long as it also complies with the License of the bootlib library!

Thank you and enjoy!

---
## Information about how the game works:

### The Snake:

The basis of the snake is a two-dimensional array, where each element of the array consists of an array of two elements,
the row and the column of one tile of the snake.

This array gets shifted down each time a specific time has been reached, for instance once every second. Then the top element's row
or column gets incremented or decremented, depending on the direction variable.

Here's a basic drawing, in which the direction of the snake's head is upwards:

[13][20]------->[12][20]

[13][21]------->[13][20]

[14][21]------->[13][21]

[15][21]------->[14][21]

### The Mouse:

The location of the mouse is generated using a Linear Congruential Pseudo-Random Number Generator. The modulo 40 or 24 (depending whether
we want the row or the column of the next mouse) will then be taken of this random number, to obtain a random location within the bounds
of the play field. The initial seed of the random number generator is the time at which the player decides to play, this way you will
always play a different game.
