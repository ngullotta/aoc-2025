package main

import (
	"os"
	"fmt"
	"bufio"
	"log"
	"math"
)

func main() {
	f, err := os.Open("data/3.txt")
	if err != nil {
		log.Fatalf("failed to open the input file: %v", err)
	}
	defer f.Close()

	var answer1 int64
	var answer2 int64

	scanner := bufio.NewScanner(f)
	for scanner.Scan() {
		line := scanner.Text()

		if len(line) < 2 {
			continue
		}

		answer1 += getJoltage(line, 2)
		answer2 += getJoltage(line, 12)
	}

	if err := scanner.Err(); err != nil {
		log.Fatalf("scanner error: %v", err)
	}

	fmt.Println(answer1)
	fmt.Println(answer2)
}

func getJoltage(line string, numBanks int) int64 {
	result := int64(0)
	start := 0

	for i := numBanks; i > 0; i-- {
		max := byte('0')
		end := len(line) - i

		for j := start; j <= end; j++ {
			if line[j] > max {
				max = line[j]
				start = j + 1
			}
		}

		result += int64(max - '0') * int64(math.Pow(10.0, float64(i - 1)))
	}

	return result
}
