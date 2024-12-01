package main

import (
	"fmt"
	"math"
	"sort"
	"strconv"
	"strings"
)

type Range struct {
	start int
	end   int
}

type Conv2 struct {
	range_from Range
	range_to   Range
}

type Almanac struct {
	seeds     []Range
	conv_sets [][]Conv2
}

func areIntersecting(r1 Range, r2 Range) bool {
	return r1.start <= r2.end && r1.end >= r2.start
}

func conv(input Range, convs []Conv2) []Range {
	// fmt.Println("input range: ", input)
	ranges := []Range{}

	intersectingConvs := []Conv2{}
	for _, conv := range convs {
		if areIntersecting(input, conv.range_from) {
			intersectingConvs = append(intersectingConvs, conv)
		}
	}
	sort.Slice(intersectingConvs, func(i, j int) bool {
		return intersectingConvs[i].range_from.start < intersectingConvs[j].range_from.start
	})

	// fmt.Println("intersects with: ", intersectingConvs)

	for i, conv := range intersectingConvs {
		if i == 0 {
			if input.start < conv.range_from.start {
				ranges = append(ranges, Range{input.start, conv.range_from.start - 1})
			}
		}

		ranges = append(ranges, Range{(conv.range_to.start - conv.range_from.start + input.start), (conv.range_to.end - conv.range_from.end + input.end)})

		if i == len(intersectingConvs)-1 {
			if input.end > conv.range_from.end {
				ranges = append(ranges, Range{conv.range_from.end + 1, input.end})
			}
		}
	}

	if len(intersectingConvs) == 0 {
		ranges = append(ranges, input)
	}

	// fmt.Println("mapped to: ", ranges)
	return ranges
}

func convRanges(input []Range, convs []Conv2) []Range {
	ranges := []Range{}

	for _, r := range input {
		ranges = append(ranges, conv(r, convs)...)
	}

	return ranges
}

func parse(input string, seedRange bool) Almanac {
	almanac := Almanac{}

	types := strings.Split(input, "\n\n")

	// Parse seeds
	seeds := strings.Split(types[0], ": ")[1]

	if seedRange {
		splitSeeds := strings.Split(seeds, " ")
		for i := 0; i < len(splitSeeds); i += 2 {
			if splitSeeds[i] == "" || splitSeeds[i+1] == "" {
				continue
			}
			start, err1 := strconv.Atoi(splitSeeds[i])
			length, err2 := strconv.Atoi(splitSeeds[i+1])

			if err1 != nil || err2 != nil {
				panic("Could not parse input")
			}

			almanac.seeds = append(almanac.seeds, Range{start, start + length - 1})
		}
	} else {
		for _, seed := range strings.Split(seeds, " ") {
			if seed == "" {
				continue
			}
			num, err := strconv.Atoi(seed)

			if err != nil {
				panic("Could not parse input")
			}

			almanac.seeds = append(almanac.seeds, Range{num, num})
		}
	}

	// Parse conv sets
	for _, conv_set := range types[1:] {
		conv_set_defs := strings.Split(conv_set, "\n")[1:]
		convs := []Conv2{}

		for _, conv_def := range conv_set_defs {
			conv_def_parts := strings.Split(conv_def, " ")
			dest_start, e1 := strconv.Atoi(conv_def_parts[0])
			source_start, e2 := strconv.Atoi(conv_def_parts[1])
			range_len, e3 := strconv.Atoi(conv_def_parts[2])

			if e1 != nil || e2 != nil || e3 != nil {
				panic("Could not parse input")
			}

			convs = append(convs, Conv2{
				Range{source_start, source_start + range_len - 1},
				Range{dest_start, dest_start + range_len - 1},
			})
		}

		almanac.conv_sets = append(almanac.conv_sets, convs)
	}

	return almanac
}

func silver(almanac Almanac) int {
	min_loc := math.MaxInt
	seeds := almanac.seeds
	fmt.Println("seeds: ", seeds)

	for _, convs := range almanac.conv_sets {
		fmt.Println("convs: ", convs)
		seeds = convRanges(seeds, convs)
		fmt.Println("seeds: ", seeds)
	}

	return min_loc
}

func sample() string {
	return `seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4`
}

func main() {
	parsed := parse(sample(), false)
	parsedG := parse(sample(), true)

	fmt.Println("Silver:", silver(parsed))
	fmt.Println("Gold:", silver(parsedG))
}
