import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile
import utils

type Command {
  Forward(amount: Int)
  Down(amount: Int)
  Up(amount: Int)
}

fn parse_command(line: String) -> Command {
  let assert Ok(#(direction, amount)) = string.split_once(line, " ")
  let assert Ok(amount) = int.parse(amount)

  case direction {
    "forward" -> Forward(amount)
    "up" -> Up(amount)
    "down" -> Down(amount)
    _ -> panic as "invalid direction"
  }
}

fn parse_commands(input: String) -> List(Command) {
  input
  |> string.split("\n")
  |> list.filter(utils.string_is_not_emtpy(_))
  |> list.map(parse_command(_))
}

pub fn part_1(input: String) -> Int {
  let traveled_tuple =
    parse_commands(input)
    |> list.fold(#(0, 0), fn(acc, cmd) {
      case cmd {
        Down(amt) -> #(acc.0, acc.1 + amt)
        Forward(amt) -> #(acc.0 + amt, acc.1)
        Up(amt) -> #(acc.0, acc.1 - amt)
      }
    })
  traveled_tuple.0 * traveled_tuple.1
}

pub fn part_2(input: String) -> Int {
  let #(pos, depth, _) =
    parse_commands(input)
    |> list.fold(#(0, 0, 0), fn(acc, cmd) {
      let #(pos, depth, aim) = acc
      case cmd {
        Forward(amt) -> #(pos + amt, depth + amt * aim, aim)
        Down(amt) -> #(pos, depth, aim + amt)
        Up(amt) -> #(pos, depth, aim - amt)
      }
    })
  pos * depth
}

pub fn main() {
  let assert Ok(input) = simplifile.read("data/day2.txt")
  io.println("Part 1: " <> part_1(input) |> int.to_string())
  io.println("Part 2: " <> part_2(input) |> int.to_string())
}
