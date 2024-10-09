import day3
import gleeunit/should

const input = "00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010"

pub fn part1_test() {
  let result = day3.part1(input)
  result |> should.equal(198)
}

pub fn part2_test() {
  let result = day3.part2(input)
  result |> should.equal(230)
}
