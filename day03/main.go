package main

import (
  "fmt"
  "os"
  "bufio"
  fp "path/filepath"
)

func main() {
    path, err := fp.Abs("./input1.txt"); if err != nil {
      panic(err)
    }

    {
      data, err := os.Open(path); if err != nil {
        panic(err)
      }

      sum := 0
      scanner := bufio.NewScanner(data)
      for scanner.Scan() {
        ruck := scanner.Text()
        first := ruck[0:(len(ruck)/2)]
        second := ruck[(len(ruck)/2):]
        common := findCommon(first, second)
        prio := calculatePriority(common)
        sum += prio
      }
      fmt.Println(sum)
    }

    data, err := os.Open(path); if err != nil {
      panic(err)
    }

    {
      sum := 0
      scanner := bufio.NewScanner(data)
      for scanner.Scan() {
        first := scanner.Text()
        scanner.Scan()
        second := scanner.Text()
        scanner.Scan()
        third := scanner.Text()
        common := findCommon3(first, second, third)
        prio := calculatePriority(common)
        sum += prio
      }
      fmt.Println(sum)
    }
}

func findCommon(first, second string) string {
  for _, c1 := range first {
    for _, c2 := range second {
      if c1 == c2 {
        return string(c1)
      }
    }
  }

  panic("No common found")
}

func findCommon3(first, second, third string) string {
  for _, c1 := range first {
    for _, c2 := range second {
      for _, c3 := range third {
        if c1 == c2 && c2 == c3 {
          return string(c1)
        }
      }
    }
  }

  panic("No common found")
}

func calculatePriority(common string) int {
  try := int(common[0]) - 96
  if try < 0 {
    return int(common[0]) - 38
  } else {
    return try
  }
}
