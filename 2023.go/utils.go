package main

import (
	"fmt"
	"io/ioutil"
	"net/http"
	"os"
	"strings"
)

func getInput(day string) string {
	client := &http.Client{}

	cookie, err := os.ReadFile("../session.cookie")
	var nv = strings.Split(string(cookie), "=")

	if err != nil {
		fmt.Println(err)
		panic("Could not read session cookie")
	}

	req, err := http.NewRequest("GET", "https://adventofcode.com/2023/day/"+day+"/input", nil)

	if err != nil {
		fmt.Println(err)
		panic("Could not create request")
	}

	req.AddCookie(&http.Cookie{
		Name:  "session",
		Value: nv[1],
	})

	resp, err := client.Do(req)

	if err != nil {
		fmt.Println(err)
		panic("Could not get response")
	}

	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body)

	return strings.Trim(string(body), "\n ")
}

func getInputLines(day string) []string {
	return strings.Split(getInput(day), "\n")
}

func minInt(a int, b int) int {
	if a < b {
		return a
	}

	return b
}

func maxInt(a, b int) int {
	if a > b {
		return a
	}
	return b
}

func indexesAny(str string, chars string) []int {
	indexes := []int{}

	for i, char := range str {
		if strings.Contains(chars, string(char)) {
			indexes = append(indexes, i)
		}
	}

	return indexes
}
