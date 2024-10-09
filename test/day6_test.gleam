import day6
import gleeunit/should

const input = "3,4,3,1,2"

pub fn part1_test() {
  let result = day6.part1(input)
  result |> should.equal(5934)
}

pub fn part2_test() {
  let result = day6.part2(input)
  result |> should.equal(26_984_457_539)
}
