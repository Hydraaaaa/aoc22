package main

import "core:fmt"
import "core:time"
import "core:os"

import "day8"

main :: proc() {
	data, ok := os.read_entire_file("src/day8/input")

	if !ok {
		fmt.println("Failed")
		return
	}

	dataString := string(data)

	defer delete(data)

	timer: time.Stopwatch

	RUN_COUNT :: 1

	fastest, slowest: time.Duration

	for i in 0 ..< RUN_COUNT {
		prevTime: time.Duration = time.stopwatch_duration(timer)

		result: int

		time.stopwatch_start(&timer)

		result = day8.part2old(dataString)

		time.stopwatch_stop(&timer)

		currentDuration := time.stopwatch_duration(timer) - prevTime

		fmt.println("Old:", result)

		result = day8.part2(dataString)

		fmt.println("New:", result)

		if i == 0 {
			fastest = time.stopwatch_duration(timer)
			slowest = time.stopwatch_duration(timer)
		} else {
			if currentDuration < fastest {
				fastest = currentDuration
			}

			if currentDuration > slowest {
				slowest = currentDuration
			}
		}
	}

	// fmt.println("TOTAL:", time.stopwatch_duration(timer), "over", RUN_COUNT, "runs")
	// fmt.println("AVERAGE:", time.stopwatch_duration(timer) / RUN_COUNT)
	// fmt.println("SLOWEST:", slowest)
	// fmt.println("FASTEST:", fastest)
}
