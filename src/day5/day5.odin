package day5

import "core:fmt"
import "core:strings"
import "core:strconv"

part1 :: proc(input : string) -> int
{
	NUM_STACKS :: 9

	lines := strings.split_lines(input)

	crateStacks : [NUM_STACKS][NUM_STACKS * 8]u8
	stackHeights : [NUM_STACKS]int = {0 ..< NUM_STACKS = -1}

	for i in 0 ..< 8
	{
		inverseIndex := 8 - i - 1
		
		for j in 0 ..< NUM_STACKS
		{
			crateStacks[j][inverseIndex] = lines[i][j * 4 + 1]

			if crateStacks[j][inverseIndex] != ' ' && stackHeights[j] == -1
			{
				stackHeights[j] = inverseIndex + 1
			}
		}
	}

	for i in 10 ..< len(lines) - 1
	{
		stringValues := strings.split_multi(lines[i][5:], {" from ", " to "})

		values : [3]int

		values[0], _ = strconv.parse_int(stringValues[0])
		values[1], _ = strconv.parse_int(stringValues[1])
		values[2], _ = strconv.parse_int(stringValues[2])

		values[1] -= 1
		values[2] -= 1

		for j in 0 ..< values[0]
		{
			crateStacks[values[2]][stackHeights[values[2]]] = crateStacks[values[1]][stackHeights[values[1]] - 1]
			crateStacks[values[1]][stackHeights[values[1]] - 1] = ' '
			stackHeights[values[2]] += 1
			stackHeights[values[1]] -= 1
		}
	}

	for i in 0 ..< NUM_STACKS
	{
		fmt.print(rune(crateStacks[i][stackHeights[i] - 1]))
	}

	fmt.print("\n")

	return 0
}

part2 :: proc(input : string) -> int
{
	NUM_STACKS :: 9

	lines := strings.split_lines(input)

	crateStacks : [NUM_STACKS][NUM_STACKS * 8]u8
	stackHeights : [NUM_STACKS]int = {0 ..< NUM_STACKS = -1}

	for i in 0 ..< 8
	{
		inverseIndex := 8 - i - 1
		
		for j in 0 ..< NUM_STACKS
		{
			crateStacks[j][inverseIndex] = lines[i][j * 4 + 1]

			if crateStacks[j][inverseIndex] != ' ' && stackHeights[j] == -1
			{
				stackHeights[j] = inverseIndex
			}
		}
	}

	for i in 10 ..< len(lines) - 1
	{
		stringValues := strings.split_multi(lines[i][5:], {" from ", " to "})

		values : [3]int

		values[0], _ = strconv.parse_int(stringValues[0])
		values[1], _ = strconv.parse_int(stringValues[1])
		values[2], _ = strconv.parse_int(stringValues[2])

		values[1] -= 1
		values[2] -= 1

		stackHeights[values[2]] += values[0]

		for j in 0 ..< values[0]
		{
			crateStacks[values[2]][stackHeights[values[2]] - j] = crateStacks[values[1]][stackHeights[values[1]] - j]
			crateStacks[values[1]][stackHeights[values[1]] - j] = ' '
		}

		stackHeights[values[1]] -= values[0]
	}

	for i in 0 ..< NUM_STACKS
	{
		fmt.print(rune(crateStacks[i][stackHeights[i]]))
	}

	fmt.print("\n")

	return 0
}
