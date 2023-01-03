package day6

import "core:fmt"
import "core:strings"
import "core:strconv"

part1 :: proc(input : string) -> int
{
	activeChars : u32 = ---

	loop:
	for i in 3 ..< len(input)
	{
		activeChars = 0

		activeChars += 1 << (input[i] - 'a')

		fmt.println("Add", u32(1 << (input[i] - 'a')))

		for j in 1 ..< 4
		{
			fmt.println("COMPARE")
			for k : u8 = 0; k < 32; k += 1
			{
				fmt.print((activeChars >> k) & 1)
			}

			fmt.println("\nAGAINST")

			for k : u8 = 0; k < 32; k += 1
			{
				fmt.print(u32(((1 << (input[i - j] - 'a')) >> k) & 1))
			}

			fmt.println()

			if activeChars & (1 << (input[i - j] - 'a')) == (1 << (input[i - j] - 'a'))
			{
				fmt.println(input[i - 3:i+1], "is duplicate")
				continue loop
			}

			activeChars += 1 << (input[i - j] - 'a')
		}

		return i + 1
	}

	return -1
}

part2 :: proc(input : string) -> int
{
	LETTER_COUNT :: 14

	activeChars : u32 = ---

	i := LETTER_COUNT - 1

	loop:
	for true
	{
		activeChars = 0

		activeChars += 1 << (input[i] - 'a')

		for j in 1 ..< LETTER_COUNT
		{
			if (activeChars >> (input[i - j] - 'a') & 1 == 1)
			{
				i += 1
				continue loop
			}

			activeChars += 1 << (input[i - j] - 'a')
		}

		return i + 1
	}

	return -1
}
