import gleam/dict
import gleam/dynamic
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/pair
import gleam/result
import gleam/string
import simplifile
import utils

pub fn part_1(input: String) -> Int {
  let lines =
    input
    |> string.split("\n")
    |> list.filter(utils.string_is_not_emtpy(_))

  let #(gamma, epsilon) =
    lines
    |> list.fold(dict.new(), fn(acc, line) {
      line
      |> string.to_graphemes()
      |> list.index_fold(acc, fn(acc, char, i) {
        case int.parse(char) {
          Ok(num) ->
            acc
            |> dict.upsert(i, fn(val) {
              case val {
                Some(val) -> val + num
                None -> num
              }
            })
          _ -> panic as { "invalid char: " <> char }
        }
      })
    })
    |> dict.fold(#("", ""), fn(acc, _, val) {
      case val * 2 < list.length(lines) {
        True -> #(acc.0 <> "0", acc.1 <> "1")
        False -> #(acc.0 <> "1", acc.1 <> "0")
      }
    })

  let assert Ok(gamma) = int.base_parse(gamma, 2)
  let assert Ok(epsilon) = int.base_parse(epsilon, 2)
  gamma * epsilon
}

fn gas_rating(lines: List(#(String, String)), inverse: Bool) -> Result(Int, Nil) {
  case lines {
    [#(_, line)] -> int.base_parse(line, 2)
    [] -> Error(Nil)
    all -> {
      use count <- result.try(
        list.try_fold(all, 0, fn(acc, line) {
          use tuple <- result.try(string.pop_grapheme(line.0))
          use num <- result.map(int.parse(tuple.0))
          num + acc
        }),
      )
      let common = case count * 2 < list.length(lines) {
        True -> utils.ternary(inverse, "1", "0")
        False -> utils.ternary(inverse, "0", "1")
      }

      let filtered =
        lines
        |> list.filter_map(fn(line) {
          let assert Ok(#(first, rest)) = line.0 |> string.pop_grapheme()
          utils.ternary(first == common, Ok(#(rest, line.1)), Error(Nil))
        })

      gas_rating(filtered, inverse)
    }
  }
}

pub fn part_2(input: String) -> Int {
  let lines =
    input
    |> string.split("\n")
    |> list.filter(utils.string_is_not_emtpy(_))

  case
    result.all([
      gas_rating(list.zip(lines, lines), False),
      gas_rating(list.zip(lines, lines), True),
    ])
  {
    Ok([oxygen, co2]) -> oxygen * co2
    _ -> panic as "failed to get ratings"
  }
}

pub fn main() {
  let assert Ok(input) = simplifile.read("data/day3.txt")
  io.println("Part 1: " <> part_1(input) |> int.to_string())
  io.println("Part 2: " <> part_2(input) |> int.to_string())
}
