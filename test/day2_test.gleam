import day2
import gleeunit/should

const input = "forward 5
down 5
forward 8
up 3
down 8
forward 2"

pub fn part_1_test() {
  let result = day2.part_1(input)
  result |> should.equal(150)
}

pub fn part_2_test() {
  let result = day2.part_2(input)
  result |> should.equal(900)
}
