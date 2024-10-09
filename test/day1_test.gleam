import day1
import gleeunit/should

const input = "199
200
208
210
200
207
240
269
260
263
"

pub fn part1_test() {
  let result = day1.part1(input)
  result |> should.equal(7)
}

pub fn part2_test() {
  let result = day1.part2(input)
  result |> should.equal(5)
}
