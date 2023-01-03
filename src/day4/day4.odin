package day4

import "core:fmt"
import "core:strings"
import "core:strconv"

part1 :: proc(input : string) -> int
{
	lines := strings.split_lines(input)

	count := 0

	for line in lines
	{
		valueStrings := strings.split_multi(line, {",", "-"})

		if len(valueStrings) != 4
		{
			continue
		}

		values : [4]int

		for str, i in valueStrings
		{
			ok : bool
			values[i], ok = strconv.parse_int(str)
		}

		if values[0] <= values[2] &&
		   values[1] >= values[3]
		{
			count += 1
		}
		else if values[2] <= values[0] &&
		        values[3] >= values[1]
		{
			count += 1
		}
	}

	return count
}

part2 :: proc(input : string) -> int
{
	input := input

	count := 0

	for line in strings.split_lines_iterator(&input)
	{
		valueStrings := strings.split_multi(line, {",", "-"})

		if len(valueStrings) != 4
		{
			continue
		}

		values : [4]int

		for str, i in valueStrings
		{
			ok : bool
			values[i], ok = strconv.parse_int(str)
		}

		count += int(values[0] >= values[2] && values[0] <= values[3] || values[2] >= values[0] && values[2] <= values[1])
	}

	return count
}
