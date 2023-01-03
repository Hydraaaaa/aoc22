package day3

import "core:fmt"
import "core:strings"
import "core:os"
import "core:thread"
import "core:simd"

part1 :: proc(input : string) -> int
{
	input := input

	priorities : [58]int = {27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,-1,-1,-1,-1,-1,-1,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26}

	sum := 0

	for line in strings.split_lines_iterator(&input)
	{
		group1 := line[:len(line) / 2]
		group2 := line[len(line) / 2:]

		loop:
		for char1 in group1
		{
			for char2 in group2
			{
				if char1 == char2
				{
					sum += priorities[char1 - 65]

					break loop
				}
			}
		}

	}

	return sum
}

part2 :: proc(input : string) -> int
{
	#no_bounds_check \
	{
		input := input

		sum := 0

		index := 0

		for index != len(input)
		{
			slicedInput := input[index:]

			indices : [3]int

			sliceIndex := 2

			for slicedInput[sliceIndex] != '\n'
			{
				sliceIndex += 2
			}

			sliceIndex += 1

			indices[0] = sliceIndex

			sliceIndex += 2

			for slicedInput[sliceIndex] != '\n'
			{
				sliceIndex += 2
			}

			sliceIndex += 1

			indices[1] = sliceIndex

			sliceIndex += 2

			for slicedInput[sliceIndex] != '\n'
			{
				sliceIndex += 2
			}

			sliceIndex += 1

			indices[2] = sliceIndex

			index += sliceIndex

			lines : [3]string = { slicedInput[:indices[0] - 1], slicedInput[indices[0]:indices[1] - 1], slicedInput[indices[1]:indices[2] - 1] }

			sets : [3]u64 = 0

			for char in lines[0] do sets[0] |= 1 << (u8(char) - 'A')
			for char in lines[1] do sets[1] |= 1 << (u8(char) - 'A')
			for char in lines[2] do sets[2] |= 1 << (u8(char) - 'A')

			value : u64 = simd.count_trailing_zeros(transmute(u64)(sets[0] & sets[1] & sets[2]))

			// currently value is 0 for A and 32 for a
			// a needs to be 1, A needs to be 27
			// Using the 32 bit, we can subtract any amount from A
			// We shift 32 bit to 1, then multiply by the desired amount, in this case we need to subtract 31
			// We can move A to 27 simply by adding 27 to the value
			// We then need to make sure we subtract 27 from 32 bit 1 values to offset this

			sum += int(value + 27 - ((value >> 5) & 1) * 58)
		}

		return sum
	}
}
