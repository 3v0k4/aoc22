package main

import (
  "fmt"
  "os"
  "strings"
  fp "path/filepath"
)

func main() {
    path, err := fp.Abs("./input1.txt"); if err != nil {
      panic(err)
    }

    data, err := os.ReadFile(path); if err != nil {
      panic(err)
    }

    rounds := strings.Split(string(data), "\n")

    fmt.Println(Score1(rounds))
    fmt.Println(Score2(rounds))
}

func Score1(rounds []string) int {
    var score []int
    for _, round := range rounds {
      switch round {
        case "A X":
          score = append(score, 3 + 1)

        case "A Y":
          score = append(score, 6 + 2)

        case "A Z":
          score = append(score, 0 + 3)

        case "B X":
          score = append(score, 0 + 1)

        case "B Y":
          score = append(score, 3 + 2)

        case "B Z":
          score = append(score, 6 + 3)

        case "C X":
          score = append(score, 6 + 1)

        case "C Y":
          score = append(score, 0 + 2)

        case "C Z":
          score = append(score, 3 + 3)

        default:
          score = append(score, 0)
      }
    }

    sum := 0
    for _, s := range score {
      sum += s
    }
    return sum
}

func Score2(rounds []string) int {
    score := []int{}

    for _, round := range rounds {
      switch round {
        case "A X":
          score = append(score, 0 + 3)

        case "A Y":
          score = append(score, 3 + 1)

        case "A Z":
          score = append(score, 6 + 2)

        case "B X":
          score = append(score, 0 + 1)

        case "B Y":
          score = append(score, 3 + 2)

        case "B Z":
          score = append(score, 6 + 3)

        case "C X":
          score = append(score, 0 + 2)

        case "C Y":
          score = append(score, 3 + 3)

        case "C Z":
          score = append(score, 6 + 1)

        default:
          score = append(score, 0)
      }
    }

    sum := 0
    for _, s := range score {
      sum += s
    }
    return sum
}
