import gleam/bool
import gleam/list
import gleam/string

pub fn sum(list: List(Int)) -> Int {
  list.fold(list, 0, fn(acc, x) { acc + x })
}

pub fn string_is_not_emtpy(input: String) {
  input
  |> string.is_empty()
  |> bool.negate()
}

pub fn ternary(cond: Bool, true: value, false: value) -> value {
  case cond {
    True -> true
    False -> false
  }
}
