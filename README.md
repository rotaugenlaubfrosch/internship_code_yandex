# internship_code_yandex
This little bash script generates a table with the dimensions X * Y (based on user input) with cells that are either alive or dead.
Every cell interacts with its 8 neighbors. Here are the rules:

1) A living cell with fewer than two living neighbors dies.
2) A living cell with two or three living neighbors survives.
3) A living cell with more than three living neighbors dies.
4) A dead cell with three living neighbors is reborn.

The script randomly generates the starting scene (probability of living cell is P=.5).

Demo:

![Alt Text](https://media.giphy.com/media/v1FhrluofXk1KoUQ4O/giphy.gif)

https://media.giphy.com/media/v1FhrluofXk1KoUQ4O/giphy.gif
