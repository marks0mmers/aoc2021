import day5
import gleeunit/should

const input = "0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2"

pub fn part_1_test() {
  let result = day5.part_1(input)
  result |> should.equal(5)
}

pub fn part_2_test() {
  let result = day5.part_2(input)
  result |> should.equal(12)
}
