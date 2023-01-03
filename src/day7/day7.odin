package day7

import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:math"

Dir :: struct
{
	name : string,
	parent : ^Dir,
	subdirs : []Dir,
	filesize : int,
}

part1 :: proc(input : string) -> int
{
	lines := strings.split_lines(input)

	rootDir : Dir
	
	rootDir.parent = nil

	currentDir : ^Dir = &rootDir

	dirIndices : u64 = 0

	outputLines := 0
	dirCount := 0

	for line, index in lines
	{
		if len(line) == 0
		{
			break
		}

		// User command
		if line[0] == '$'
		{
			// Resolve all the output lines read up to this line
			if outputLines > 0
			{
				currentDir.subdirs = make([]Dir, dirCount)

				subdirIndex := 0

				for i in 0 ..< outputLines
				{
					if dirIndices >> u32(i) & 1 == 1
					{
						currentDir.subdirs[subdirIndex].name = lines[index + i - outputLines][4:]
						currentDir.subdirs[subdirIndex].parent = currentDir

						subdirIndex += 1
					}
				}

				dirIndices = 0
				outputLines = 0
				dirCount = 0
			}

			// cd
			if line[2] == 'c'
			{
				if line[5] == '.'
				{
					currentDir = currentDir.parent
				}
				else
				{
					subdirName : string = line[5:]

					for i in 0 ..< len(currentDir.subdirs)
					{
						if currentDir.subdirs[i].name == subdirName
						{
							currentDir = &currentDir.subdirs[i]
							break
						}
					}
				}
			}
		}
		else
		{
			if line[0] == 'd'
			{
				dirIndices += 1 << u32(outputLines)

				dirCount += 1
			}
			else
			{
				numEndIndex := strings.index_byte(line, ' ')

				filesize, _ := strconv.parse_int(line[:numEndIndex])

				currentDir.filesize += filesize
			}

			outputLines += 1
		}
	}

	SearchRecursively :: proc(dir : ^Dir, total : int) -> (int, int)
	{
		total := total

		for i in 0 ..< len(dir.subdirs)
		{
			a, b := SearchRecursively(&dir.subdirs[i], total)

			dir.filesize += a
			total = b
		}

		if dir.filesize <= 100000
		{
			total += dir.filesize
		}

		return dir.filesize, total
	}

	_, total := SearchRecursively(&rootDir, 0)

	return total
}

part2 :: proc(input : string) -> int
{
	lines := strings.split_lines(input)

	rootDir : Dir
	
	rootDir.parent = nil

	currentDir : ^Dir = &rootDir

	dirIndices : u64 = 0

	outputLines := 0
	dirCount := 0

	for line, index in lines
	{
		if len(line) == 0
		{
			break
		}

		// User command
		if line[0] == '$'
		{
			// Resolve all the output lines read up to this line
			if outputLines > 0
			{
				currentDir.subdirs = make([]Dir, dirCount)

				subdirIndex := 0

				for i in 0 ..< outputLines
				{
					if dirIndices >> u32(i) & 1 == 1
					{
						currentDir.subdirs[subdirIndex].name = lines[index + i - outputLines][4:]
						currentDir.subdirs[subdirIndex].parent = currentDir

						subdirIndex += 1
					}
				}

				dirIndices = 0
				outputLines = 0
				dirCount = 0
			}

			// cd
			if line[2] == 'c'
			{
				if line[5] == '.'
				{
					currentDir = currentDir.parent
				}
				else
				{
					subdirName : string = line[5:]

					for i in 0 ..< len(currentDir.subdirs)
					{
						if currentDir.subdirs[i].name == subdirName
						{
							currentDir = &currentDir.subdirs[i]
							break
						}
					}
				}
			}
		}
		else
		{
			if line[0] == 'd'
			{
				dirIndices += 1 << u32(outputLines)

				dirCount += 1
			}
			else
			{
				numEndIndex := strings.index_byte(line, ' ')

				filesize, _ := strconv.parse_int(line[:numEndIndex])

				currentDir.filesize += filesize
			}

			outputLines += 1
		}
	}

	SearchRecursively :: proc(dir : ^Dir, total : int) -> (int, int)
	{
		total := total

		for i in 0 ..< len(dir.subdirs)
		{
			a, b := SearchRecursively(&dir.subdirs[i], total)

			dir.filesize += a
			total = b
		}

		if dir.filesize <= 100000
		{
			total += dir.filesize
		}

		return dir.filesize, total
	}


	usedSpace, total := SearchRecursively(&rootDir, 0)

	requiredSpace := 30_000_000 - (70_000_000 - usedSpace)

	FindFileRecursively :: proc(dir : ^Dir, target : int) -> int
	{
		closest : int = ---

		if dir.filesize > target
		{
			closest = dir.filesize
		}
		else
		{
			closest = 999_999_999
		}

		for i in 0 ..< len(dir.subdirs)
		{
			subClosest := FindFileRecursively(&dir.subdirs[i], target)

			if subClosest - target < closest - target
			{
				closest = subClosest
			}
		}

		return closest
	}

	return FindFileRecursively(&rootDir, requiredSpace)
}
