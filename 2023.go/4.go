package main

import (
	"fmt"
	"math"
	"strconv"
	"strings"

	"golang.org/x/exp/slices"
)

type Card struct {
	onCard []int
	called []int
}

func parse(lines []string) []Card {
	cards := []Card{}

	for _, line := range lines {
		card := Card{
			make([]int, 0),
			make([]int, 0),
		}

		cl := strings.Split(line, ": ")

		numbers := strings.Split(cl[1], " | ")

		for _, n := range strings.Split(numbers[0], " ") {
			if n == "" {
				continue
			}
			num, err := strconv.Atoi(n)

			if err != nil {
				panic("Could not parse input")
			}

			card.onCard = append(card.onCard, num)
		}

		for _, n := range strings.Split(numbers[1], " ") {
			if n == "" {
				continue
			}
			num, err := strconv.Atoi(n)

			if err != nil {
				panic("Could not parse input")
			}

			card.called = append(card.called, num)
		}

		cards = append(cards, card)
	}

	return cards
}

func silver(cards []Card) int {
	pts := 0

	for _, card := range cards {
		matches := 0

		for _, n := range card.onCard {
			if slices.Contains(card.called, n) {
				matches++
			}
		}

		if matches > 0 {
			pts += int(math.Pow(2, float64(matches-1)))
		}
	}

	return pts
}

func gold(cards []Card) int {
	// pre-compute number of matches for each card
	matches := make(map[int]int)

	for i, card := range cards {
		for _, n := range card.onCard {
			if slices.Contains(card.called, n) {
				matches[i]++
			}
		}
	}

	totalCards := len(cards)

	hand := make(map[int]int)
	for i := range cards {
		hand[i] = 1
	}

	for {
		if len(hand) == 0 {
			break
		}

		newCards := make(map[int]int)
		for cardIx, ct := range hand {
			totalCards += ct * matches[cardIx]
			for i := 1; i <= matches[cardIx]; i++ {
				newCards[cardIx+i] += ct
			}
		}

		hand = newCards
	}

	return totalCards
}

func main() {
	parsed := parse(getInputLines("4"))

	fmt.Println(silver(parsed))
	fmt.Println(gold(parsed))
}
