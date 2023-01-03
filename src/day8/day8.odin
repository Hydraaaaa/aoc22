package day8

import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:math"

part1 :: proc(input : string) -> int
{
	gridWidth := strings.index_byte(input, '\n')
	gridHeight := (len(input) - 1) / gridWidth

	visibleCount := gridWidth * 2 + gridHeight * 2 - 4

	for y in 1 ..< gridHeight - 1
	{
		for x in 1 ..< gridWidth - 1
		{
			yIndex := y * (gridWidth + 1)

			height := input[x + yIndex]

			visible := true

			for i := x - 1; i > -1; i -= 1
			{
				if input[i + yIndex] >= height
				{
					visible = false
					break
				}
			}

			if visible
			{
				visibleCount += 1
				continue
			}

			visible = true

			for i := x + 1; i < gridWidth; i += 1
			{
				if input[i + yIndex] >= height
				{
					visible = false
					break
				}
			}

			if visible
			{
				visibleCount += 1
				continue
			}

			visible = true

			for i := y - 1; i > -1; i -= 1
			{
				if input[x + i * (gridWidth + 1)] >= height
				{
					visible = false
					break
				}
			}

			if visible
			{
				visibleCount += 1
				continue
			}

			visible = true

			for i := y + 1; i < gridHeight; i += 1
			{
				if input[x + i * (gridWidth + 1)] >= height
				{
					visible = false
					break
				}
			}

			if visible
			{
				visibleCount += 1
				continue
			}
		}
	}

	return visibleCount
}

part2 :: proc(input : string) -> int
{
	gridWidth := strings.index_byte(input, '\n')
	gridHeight := (len(input) - 1) / gridWidth

	scores : []int = make([]int, (gridWidth - 2) * (gridHeight - 2))
	defer delete(scores)

	for i in 0 ..< len(scores)
	{
		scores[i] = 1
	}

	// heights 1-9, 0 = 1, etc
	prevIndices : [9]int

	bestScenicScore := 0

	inputWidth := gridWidth + 1 // Factoring in newline on each line
	scoreWidth := gridWidth - 2 // Bordering indices excluded

	for y in 0 ..< gridHeight - 2
	{
		prevIndices = {0 ..< 9 = 0}

		scoreYIndex := y * scoreWidth

		for x in 0 ..< scoreWidth
		{
			height := input[x + 1 + (y + 1) * inputWidth] - '0'
			heightIndex := height - 1

			if (x == 51 && y == 77)
			{
				fmt.println(height)
			}

			if height == 0
			{
				continue
			}

			// Add to scenic score at current index
			scores[x + scoreYIndex] *= x - prevIndices[heightIndex]

			if (x == 51 && y == 77)
			{
				fmt.println("FIRST:", x, "-", prevIndices[heightIndex], "=", scores[x + scoreYIndex])
			}

			//if (scores[x + scoreYIndex] > bestScenicScore)
			//{
			//	bestScenicScore = scores[x + scoreYIndex]
			//}

			// Add to scenic score at previous indices
			for i in 0 ..< height
			{
				// We only want to modify a previous tree if we're referencing it from its height
				if (i == 8 ||
				    prevIndices[i] != prevIndices[i + 1])
				{
					fmt.print(i, "~", prevIndices[i])
					fmt.print(" :", scores[prevIndices[i] + y * scoreWidth])

					scores[prevIndices[i] + scoreYIndex] *= x - prevIndices[i]

					fmt.println(" *", x - prevIndices[i], "=", scores[prevIndices[i] + y * scoreWidth])

					if (scores[prevIndices[i] + scoreYIndex] > bestScenicScore)
					{
						bestScenicScore = scores[prevIndices[i] + y * scoreWidth]
					}
				}

				prevIndices[i] = x
			}
		}
	}

	//for x in 0 ..< gridWidth - 2
	//{
	//	prevIndices = {0 ..< 9 = 1}

	//	for y in 0 ..< gridHeight - 2
	//	{
	//		height := input[x + 1 + (y + 1) * (gridWidth + 1)] - '0'

	//		if height == 0
	//		{
	//			continue
	//		}

	//		fmt.print(x)
	//		fmt.print(",", y)
	//		fmt.print(": [")
	//		fmt.print(x + prevIndices[height - 1] * (gridWidth - 2))
	//		fmt.print("]:", scores[x + prevIndices[height - 1] * (gridWidth - 2)])
	//		fmt.print(", [")
	//		fmt.print(x + y * (gridWidth - 2))
	//		fmt.print("]:", scores[x + y * (gridWidth - 2)], "*=", x - prevIndices[height - 1])

	//		if (input[x + 1 + (prevIndices[height - 1] + 1) * (gridWidth + 1)] - '0' == height)
	//		{
	//			scores[x + prevIndices[height - 1] * (gridWidth - 2)] *= y - prevIndices[height - 1]
	//		}

	//		scores[x + y * (gridWidth - 2)] *= y - prevIndices[height - 1]

	//		if (x + prevIndices[height - 1] * (gridWidth - 2) == 128)
	//		{
	//			fmt.print(" =", scores[x + prevIndices[height - 1] * (gridWidth - 2)])
	//			fmt.println(",", scores[x + y * (gridWidth - 2)])

	//			fmt.println(height, "PrevIndices:", prevIndices[height - 1])
	//		}

	//		if (scores[x + prevIndices[height - 1] * (gridWidth - 2)] > bestScenicScore)
	//		{
	//			bestScenicScore = scores[x + prevIndices[height - 1] * (gridWidth - 2)]
	//		}

	//		for i in 0 ..< height
	//		{
	//			prevIndices[i] = y
	//		}
	//	}
	//}

	return bestScenicScore
}

part2old :: proc(input : string) -> int
{
	gridWidth := strings.index_byte(input, '\n')
	gridHeight := (len(input) - 1) / gridWidth

	bestScenicScore := 0

	for y in 1 ..< gridHeight - 1
	{
		for x in 1 ..< gridWidth - 1
		{
			yIndex := y * (gridWidth + 1)

			height := input[x + yIndex]

			scenicScore := 1

			directionalTrees := 0

			for i := x - 1; i > -1; i -= 1
			{
				directionalTrees += 1

				if input[i + yIndex] >= height
				{
					break
				}
			}

			scenicScore *= directionalTrees
			directionalTrees = 0

			for i := x + 1; i < gridWidth; i += 1
			{
				directionalTrees += 1

				if input[i + yIndex] >= height
				{
					break
				}
			}

			scenicScore *= directionalTrees
			directionalTrees = 0

			//for i := y - 1; i > -1; i -= 1
			//{
			//	directionalTrees += 1

			//	if input[x + i * (gridWidth + 1)] >= height
			//	{
			//		break
			//	}
			//}

			//scenicScore *= directionalTrees
			//directionalTrees = 0

			//for i := y + 1; i < gridHeight; i += 1
			//{
			//	directionalTrees += 1

			//	if input[x + i * (gridWidth + 1)] >= height
			//	{
			//		break
			//	}
			//}

			//scenicScore *= directionalTrees
			//directionalTrees = 0

			if scenicScore > bestScenicScore
			{
				bestScenicScore = scenicScore
				fmt.println(x, y, x * y, height - '0')
			}
		}
	}

	return bestScenicScore
}
