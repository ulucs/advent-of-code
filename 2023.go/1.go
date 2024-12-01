package main

import (
	"fmt"
	"strconv"
	"strings"
)

func silver(input []string) int {
	sum := 0

	for _, line := range input {
		i1 := strings.IndexAny(line, "0123456789")
		i2 := strings.LastIndexAny(line, "0123456789")

		n1, err1 := strconv.Atoi(string(line[i1 : i1+1]))
		n2, err2 := strconv.Atoi(string(line[i2 : i2+1]))

		if err1 != nil || err2 != nil {
			fmt.Println(line[i1:i1+1], line[i2-1:i2])
			panic("Could not parse input")
		}

		sum += n1*10 + n2
	}

	return sum
}

func getDigit(line string) int {
	digits := map[string]int{
		"one":   1,
		"two":   2,
		"three": 3,
		"four":  4,
		"five":  5,
		"six":   6,
		"seven": 7,
		"eight": 8,
		"nine":  9,
	}

	strIdx := len(line)
	strVal := 0
	for k, v := range digits {
		idx := strings.Index(line, k)
		if idx != -1 && idx < strIdx {
			strIdx = idx
			strVal = v
		}
	}

	dgtIdx := strings.IndexAny(line, "123456789")

	if strIdx != -1 && dgtIdx == -1 || strIdx < dgtIdx {
		return strVal
	} else {
		dgt, err := strconv.Atoi(string(line[dgtIdx : dgtIdx+1]))
		if err != nil {
			panic("Could not parse input")
		}
		return dgt
	}
}

func getLastDigit(line string) int {
	digits := map[string]int{
		"one":   1,
		"two":   2,
		"three": 3,
		"four":  4,
		"five":  5,
		"six":   6,
		"seven": 7,
		"eight": 8,
		"nine":  9,
	}

	strIdx := -1
	strVal := 0
	for k, v := range digits {
		idx := strings.LastIndex(line, k)
		if idx != -1 && idx > strIdx {
			strIdx = idx
			strVal = v
		}
	}

	dgtIdx := strings.LastIndexAny(line, "123456789")

	if strIdx != -1 && dgtIdx == -1 || strIdx > dgtIdx {
		return strVal
	} else {
		dgt, err := strconv.Atoi(string(line[dgtIdx : dgtIdx+1]))
		if err != nil {
			panic("Could not parse input")
		}
		return dgt
	}
}

func gold(input []string) int {
	sum := 0

	for _, line := range input {
		n1 := getDigit(line)
		n2 := getLastDigit(line)

		sum += n1*10 + n2
	}

	return sum
}

func main() {
	fmt.Println(silver(getInputLines("1")))
	fmt.Println(gold(getInputLines("1")))
}
