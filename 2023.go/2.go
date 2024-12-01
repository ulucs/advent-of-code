package main

import (
	"fmt"
	"strconv"
	"strings"
)

type Session struct {
	id    int
	games []Game
}

type Game struct {
	red   int
	green int
	blue  int
}

func parse(input []string) []Session {
	sessions := []Session{}

	for i, line := range input {
		games := []Game{}
		cleanLine := strings.Split(line, ": ")
		println(line)

		for _, gameLine := range strings.Split(cleanLine[1], "; ") {
			game := Game{0, 0, 0}
			colors := strings.Split(gameLine, ", ")

			for _, color := range colors {
				vals := strings.Split(color, " ")
				amount, err := strconv.Atoi(vals[0])

				if err != nil {
					panic("Could not parse input")
				}

				switch vals[1] {
				case "red":
					game.red = amount
				case "green":
					game.green = amount
				case "blue":
					game.blue = amount
				}
			}

			games = append(games, game)
		}

		fmt.Println(games)
		sessions = append(sessions, Session{
			i + 1,
			games,
		})
	}

	return sessions
}

func silver(input []Session) int {
	sum := 0

	for _, session := range input {
		possible := true
		for _, game := range session.games {
			if game.red > 12 || game.green > 13 || game.blue > 14 {
				possible = false
				break
			}
		}

		if possible {
			sum += session.id
		}
	}

	return sum
}

func gold(input []Session) int {
	sum := 0

	for _, session := range input {
		red := 0
		green := 0
		blue := 0

		for _, game := range session.games {
			red = maxInt(red, game.red)
			green = maxInt(green, game.green)
			blue = maxInt(blue, game.blue)
		}

		sum += red * green * blue
	}

	return sum
}

func main() {
	input := parse(getInputLines("2"))

	println(silver(input))
	println(gold(input))
}
