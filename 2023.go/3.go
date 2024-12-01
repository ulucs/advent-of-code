package main

import (
	"fmt"
	"regexp"
	"strconv"
)

type Loc struct {
	x int
	y int
}

type NumLen struct {
	num int
	len int
}

type Schematic struct {
	numbers map[Loc]NumLen
	symbols map[Loc]string
}

func parse(schema []string) Schematic {
	numberRe := regexp.MustCompile(`\d+`)
	schematic := Schematic{
		make(map[Loc]NumLen),
		make(map[Loc]string),
	}

	for y, line := range schema {
		numbers := numberRe.FindAllString(line, -1)
		numberIdxs := numberRe.FindAllStringIndex(line, -1)

		for i, number := range numbers {
			n, err := strconv.Atoi(number)

			if err != nil {
				panic("Could not parse input")
			}

			schematic.numbers[Loc{
				numberIdxs[i][0],
				y,
			}] = NumLen{n, len(number)}
		}

		symbolsIdx := indexesAny(line, "%*#&$@/=+-")

		for _, symIx := range symbolsIdx {
			schematic.symbols[Loc{
				symIx,
				y,
			}] = string(line[symIx])
		}
	}

	return schematic
}

func silver(schema Schematic) int {
	sum := 0

	for loc, num := range schema.numbers {
		isAdjacent := false

		for y := loc.y - 1; y <= loc.y+1; y++ {
			for x := loc.x - 1; x <= loc.x+num.len; x++ {
				if schema.symbols[Loc{x, y}] != "" {
					isAdjacent = true
				}
			}
		}

		if isAdjacent {
			sum += num.num
		}

	}

	return sum
}

func gold(schema Schematic) int {
	stars := make(map[Loc]([]int))

	for loc, num := range schema.numbers {
		for y := loc.y - 1; y <= loc.y+1; y++ {
			for x := loc.x - 1; x <= loc.x+num.len; x++ {
				if schema.symbols[Loc{x, y}] == "*" {
					if stars[Loc{x, y}] == nil {
						stars[Loc{x, y}] = []int{}
					}
					stars[Loc{x, y}] = append(stars[Loc{x, y}], num.num)
				}
			}
		}
	}

	sum := 0

	for _, nums := range stars {
		if len(nums) == 2 {
			sum += nums[0] * nums[1]
		}
	}

	return sum
}

func sample() []string {
	return []string{
		"467..114..",
		"...*......",
		"..35..633.",
		"......#...",
		"617*......",
		".....+.58.",
		"..592.....",
		"......755.",
		"...$.*....",
		".664.598..",
	}
}

func main() {
	parsed := (parse(getInputLines("3")))

	fmt.Println(silver(parsed))
	fmt.Println(gold(parsed))
}
