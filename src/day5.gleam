import gleam/bool
import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/option
import gleam/result
import gleam/string
import simplifile
import utils

type Point =
  #(Int, Int)

fn horizontal_vertical_points(
  points: #(Point, Point),
  all: List(Point),
  diagonal: Bool,
) -> List(Point) {
  let #(p1, p2) = points
  use <- bool.guard(when: p1 == p2, return: [p2, ..all])
  let #(x1, y1) = p1
  let #(x2, y2) = p2
  let dy = { y2 - y1 } / int.absolute_value(y2 - y1)
  let dx = { x2 - x1 } / int.absolute_value(x2 - x1)
  let next_points = horizontal_vertical_points(_, [p1, ..all], diagonal)
  case x1 == x2 {
    True -> {
      next_points(#(#(x1, y1 + dy), p2))
    }
    False -> {
      case y1 == y2 {
        True -> {
          next_points(#(#(x1 + dx, y1), p2))
        }
        False -> {
          use <- bool.guard(when: !diagonal, return: all)
          next_points(#(#(x1 + dx, y1 + dy), p2))
        }
      }
    }
  }
}

fn parse_input(input: String) {
  input
  |> string.split("\n")
  |> list.filter(utils.string_is_not_emtpy(_))
  |> list.try_map(fn(line) {
    use coords <- result.try(
      line
      |> string.split(" -> ")
      |> list.flat_map(string.split(_, ","))
      |> list.map(string.trim(_))
      |> list.try_map(int.parse(_)),
    )
    case coords {
      [x1, y1, x2, y2] -> {
        Ok(#(#(x1, y1), #(x2, y2)))
      }
      _ -> Error(Nil)
    }
  })
}

pub fn process_map(input: String, diagonal: Bool) -> Int {
  let assert Ok(vents) = parse_input(input)
  let map =
    vents
    |> list.fold(dict.new(), fn(acc, points) {
      horizontal_vertical_points(points, list.new(), diagonal)
      |> list.fold(acc, fn(acc, p) {
        dict.upsert(acc, p, fn(opt) {
          case opt {
            option.Some(x) -> x + 1
            option.None -> 1
          }
        })
      })
    })
  map |> dict.values() |> list.count(fn(val) { val > 1 })
}

pub fn part_1(input: String) -> Int {
  process_map(input, False)
}

pub fn part_2(input: String) -> Int {
  process_map(input, True)
}

pub fn main() {
  let assert Ok(input) = simplifile.read("data/day5.txt")
  io.println("Part 1: " <> part_1(input) |> int.to_string())
  io.println("Part 2: " <> part_2(input) |> int.to_string())
}
