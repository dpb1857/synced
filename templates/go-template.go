package main

import (
	"bufio"
	"flag"
	"fmt"
	"os"
	"strconv"
	"strings"
)

// Utilities

func StringSliceRepr(s []string) string {

	quoteParts := func(s_slice []string) []string {
		var collect []string
		for _, s := range s_slice {
			collect = append(collect, "'"+s+"'")
		}
		return collect
	}

	return "[" + strings.Join(quoteParts(s), ",") + "]"
}

func contains(word string, s_list []string) bool {
	for _, s := range s_list {
		if word == s {
			return true
		}
	}
	return false
}

// REPL

var HelpMessage = `
h, help   - help message
q, quit - quit
`

func convertArgs(args []string) (int, int, string) {

	var err error
	var errmsg string
	var x, y int

	if len(args) < 2 {
		errmsg = "Not enough arguments"
	} else {
		x, err = strconv.Atoi(args[0])
		if err != nil {
			errmsg = "Could not convert input: " + args[0]
		}
		y, err = strconv.Atoi(args[1])
		if err != nil {
			errmsg = "Could not convert input: " + args[1]
		}
	}

	return x, y, errmsg
}

func repl(width int, height int, numMines int) {

	input := bufio.NewScanner(os.Stdin)

	getCmd := func() (string, []string) {
		fields := strings.Fields(input.Text())
		if len(fields) > 0 {
			return fields[0], fields[1:]
		}
		return "", []string{}
	}

	for input.Scan() {
		cmd, args := getCmd()
		if contains(cmd, []string{"c", "cmd"}) {
			x, y, errmsg := convertArgs(args)
			if errmsg == "" {
				fmt.Printf("processing with args (x,y) = (%d, %d)\n", x, y)
			} else {
				fmt.Println(errmsg)
			}
		} else if contains(cmd, []string{"q", "quit"}) {
			return
		} else {
			fmt.Println(HelpMessage)
		}
	}
}

func main() {

	var width = flag.Int("width", 10, "width of grid")
	var height = flag.Int("height", 5, "height of grid")
	var mines = flag.Int("mines", 15, "number of mines")
	flag.Parse()

	fmt.Printf("width: %d, height: %d, mines: %d\n", *width, *height, *mines)
	repl(*width, *height, *mines)
}
