package day2

import "core:fmt"
import "core:strings"
import "core:os"
import "core:thread"

part1 :: proc(input : string) -> int
{
	input := input

	POINT_OFFSET :: 87
	MATCH_OFFSET :: 88 - 65

	points := 0

	for line in strings.split_lines_iterator(&input)
	{
		points += int(line[2] - POINT_OFFSET)

		if line[0] == line[2] - MATCH_OFFSET
		{
			points += 3
		}
		else
		{
			switch line[0]
			{
				case 'A':
				if line[2] == 'Y'
				{
					points += 6
				}
				case 'B':
				if line[2] == 'Z'
				{
					points += 6
				}
				case 'C':
				if line[2] == 'X'
				{
					points += 6
				}
			}
		}
	}

	return points
}

NUM_THREADS :: 4

part2_thread_data :: struct
{
	input : ^string,
	offset : int,
	points : int,
}

part2_thread :: proc(data : rawptr)
{
	data := transmute(^part2_thread_data)data

	array : [9]int = {3, 4, 8, 1, 5, 9, 2, 6, 7}

	for i : int = data.offset * 4; i < len(data.input); i += NUM_THREADS * 4
	{
		data.points += array[(data.input[i] - 65) * 3 + (data.input[i + 2] - 88)]
	}
}

part2_threaded :: proc(input : ^string) -> int
{
	threads : [NUM_THREADS]^thread.Thread
	threadData : [NUM_THREADS]part2_thread_data

	for i in 0 ..< NUM_THREADS
	{
		threadData[i] = part2_thread_data{input, i, 0}

		threads[i] = thread.create_and_start_with_data(&threadData[i], part2_thread)
	}

	points := 0

	for i in 0 ..< NUM_THREADS
	{
		thread.join(threads[i])
		points += threadData[i].points
	}

	return points
}

part2 :: proc(input : ^string) -> int
{
	#no_bounds_check \
	{
		points := 0

		array : [9]int = {3, 4, 8, 1, 5, 9, 2, 6, 7}

		for i := 0; i < len(input); i += 4
		{
			points += array[(input[i] - 65) * 3 + (input[i + 2] - 88)]
		}

		return points
	}
}

