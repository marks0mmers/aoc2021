import gleam/bool
import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile
import utils

fn parse_input(input: String) {
  input
  |> string.split(",")
  |> list.map(string.trim(_))
  |> list.try_map(int.parse(_))
  |> result.map(list.fold(
    _,
    dict.from_list(list.range(0, 8) |> list.map(fn(key) { #(key, 0) })),
    fn(acc, fish) { dict.upsert(acc, fish, utils.dict_increment) },
  ))
}

fn simulate(fish: dict.Dict(Int, Int), days_remaining: Int) {
  use <- bool.guard(when: days_remaining == 0, return: fish)
  let new_fish = fish |> dict.get(0) |> result.unwrap(0)
  let fish =
    fish
    |> dict.map_values(fn(key, _) {
      case key {
        6 ->
          int.add(
            fish |> dict.get(0) |> result.unwrap(0),
            fish |> dict.get(7) |> result.unwrap(0),
          )
        n -> fish |> dict.get(n + 1) |> result.unwrap(0)
      }
    })
  let fish = fish |> dict.insert(8, new_fish)
  simulate(fish, days_remaining - 1)
}

pub fn part1(input: String) -> Int {
  let assert Ok(fish) = parse_input(input)
  simulate(fish, 80)
  |> dict.values()
  |> utils.sum()
}

pub fn part2(input: String) -> Int {
  let assert Ok(fish) = parse_input(input)
  simulate(fish, 256)
  |> dict.values()
  |> utils.sum()
}

pub fn main() {
  let assert Ok(input) = simplifile.read("data/day6.txt")
  io.println("Part 1: " <> part1(input) |> int.to_string())
  io.println("Part 2: " <> part2(input) |> int.to_string())
}
