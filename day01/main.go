package main

import (
  "fmt"
  "os"
  "cmp"
  "strings"
  "strconv"
  "slices"
  fp "path/filepath"
)

func main() {
    path, err := fp.Abs("./input1.txt"); if err != nil {
      panic(err)
    }

    data, err := os.ReadFile(path); if err != nil {
      panic(err)
    }

    groups := strings.Split(string(data), "\n\n")

    elves := make([]int, len(groups))
    for i, group := range groups {
      for _, cals := range strings.Split(group, "\n") {
        c, _ := strconv.Atoi(cals)
        elves[i] += c
      }
    }

    slices.SortStableFunc(elves, func(a, b int) int {
      return -cmp.Compare(a, b)
    })

    fmt.Println(elves[0])

    sum := 0
    for _, c := range elves[0:3] {
      sum += c
    }
    fmt.Println(sum)
}
