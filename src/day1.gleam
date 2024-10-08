import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile
import utils

pub fn part_1(input: String) -> Int {
  string.split(input, on: "\n")
  |> list.filter_map(int.parse(_))
  |> list.window_by_2()
  |> list.count(fn(a) { a.0 < a.1 })
}

pub fn part_2(input: String) -> Int {
  string.split(input, on: "\n")
  |> list.filter_map(int.parse(_))
  |> list.window(3)
  |> list.window_by_2()
  |> list.count(fn(a) {
    let #(left, right) = a
    utils.sum(left) < utils.sum(right)
  })
}

pub fn main() {
  let assert Ok(input) = simplifile.read("data/day1.txt")
  io.println("Part 1: " <> part_1(input) |> int.to_string())
  io.println("Part 2: " <> part_2(input) |> int.to_string())
}
