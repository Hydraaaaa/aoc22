package day1

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

CALORIE_SUM_COUNT :: 3

CompareCalorieSum :: proc(calorieSum : int, highestCalorieSums : ^[CALORIE_SUM_COUNT]int)
{
	if calorieSum <= highestCalorieSums^[0]
	{
		return
	}

	for i in 1 ..< len(highestCalorieSums)
	{
		if calorieSum > highestCalorieSums^[i]
		{
			highestCalorieSums[i - 1] = highestCalorieSums[i]

			if i == len(highestCalorieSums) - 1
			{
				highestCalorieSums[i] = calorieSum
			}
		}
		else
		{
			highestCalorieSums[i - 1] = calorieSum

			return
		}
	}
}

day1 :: proc(input : string) -> int
{
	input := input

	calorieSum := 0
	highestCalorieSums : [CALORIE_SUM_COUNT]int = {0 ..< CALORIE_SUM_COUNT = 0}

	// Fastest solution
	index := strings.index(input, "\n")

	for index != len(input)
	{
		slicedString := input[index:]

		sliceIndex := 0

		for slicedString[sliceIndex] != '\n'
		{
			sliceIndex += 1
		}

		sliceIndex += 1

		index += sliceIndex

		line := slicedString[:sliceIndex]

		if line[0] == '\n'
		{
			CompareCalorieSum(calorieSum, &highestCalorieSums)
			calorieSum = 0
		}
		else
		{
			calories, ok := strconv.parse_int(line)
			calorieSum += calories
		}
	}

	//index := strings.index(input, "\n")

	//for true
	//{
	//	newIndex := strings.index(input[index:], "\n")

	//	if newIndex == -1
	//	{
	//		break
	//	}

	//	newIndex += index + 1

	//	line := input[index:newIndex]

	//	if line[0] == '\n'
	//	{
	//		CompareCalorieSum(calorieSum, &highestCalorieSums)
	//		calorieSum = 0
	//	}
	//	else
	//	{
	//		calories, ok := strconv.parse_int(line)
	//		calorieSum += calories
	//	}

	//	index = newIndex
	//}

	// Broken Solution
	//lines := strings.split_lines(input)

	//for line in lines
	//{
	//	if len(line) == 0
	//	{
	//		CompareCalorieSum(calorieSum, &highestCalorieSums)
	//		calorieSum = 0
	//	}
	//	else
	//	{
	//		calories, ok := strconv.parse_int(line)
	//		calorieSum += calories
	//	}
	//}

	// Simple Solution
	//for line in strings.split_lines_iterator(&input)
	//{
	//	if len(line) == 0
	//	{
	//		CompareCalorieSum(calorieSum, &highestCalorieSums)
	//		calorieSum = 0
	//	}
	//	else
	//	{
	//		calories, ok := strconv.parse_int(line)
	//		calorieSum += calories
	//	}
	//}

	CompareCalorieSum(calorieSum, &highestCalorieSums)

	sum := 0

	for i in 0 ..< CALORIE_SUM_COUNT
	{
		sum += highestCalorieSums[i]
	}

	return sum
}
