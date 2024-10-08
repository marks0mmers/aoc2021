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

pub fn part_1_test() {
  let result = day1.part_1(input)
  result |> should.equal(7)
}

pub fn part_2_test() {
  let result = day1.part_2(input)
  result |> should.equal(5)
}
