# Example project

This is an example blog post for testing purposes.

## Code

Here is some example code which should be syntax highlighted:

```c
int main(void) {
	int long_line = (255 >> (0x08 | 0x01)) & 0x00;
	return long_line;
}
```

Good to see that it works as intended.

## Math

Math equations can also be rendered nicely as you can see below:

$$
y = a_1 x + a_2 x^2 \\\
a_1, a_2 \in \mathbb{R}
$$

## More code

Here's some terminal output:

```sh
$ make upload
avr-gcc -mmcu=attiny85 main.c -Wall -Wextra -pedantic -o main.hex
avrdude -c arduino -p attiny85 -P /dev/ttyUSB0 -b 19200 -U flash:w:main.hex
```

## Table

Here's a beautiful table.

First	| Second	| Third		| Fourth
 :----- | :-------- | :-------- | :-----
natural	| integer	| rational	| complex
\\( \mathbb\{N\} \\)	| \\( \mathbb\{Z\} \\)	| \\( \mathbb\{Q\} \\)	| \\( \mathbb\{C\} \\)
This row includes some longer text	| I don't exactly know what it could be	| But it's good content for testing | This way I get pretty long lines here
`printf`	| `nmap`	| `swipl` | `clang++`

I hope you enjoyed this test blog post.
