import gleam/bool
import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile
import utils

type Board =
  Dict(Int, #(Int, Int, Bool))

//const tlbr_coords = [#(0, 0), #(1, 1), #(2, 2), #(3, 3), #(4, 4)]

//const trbl_coords = [#(0, 4), #(1, 3), #(2, 2), #(3, 1), #(4, 0)]

type Game {
  Bingo(numbers: List(Int), boards: List(Board))
}

fn parse_board(input: String) -> Board {
  input
  |> string.split("\n")
  |> list.index_fold(dict.new(), fn(acc, line, row) {
    line
    |> string.split(" ")
    |> list.map(string.trim(_))
    |> list.filter_map(int.parse(_))
    |> list.index_fold(acc, fn(acc, num, col) {
      acc |> dict.insert(num, #(col, row, False))
    })
  })
}

fn winning(board: Board) -> Bool {
  let horizontal =
    board
    |> dict.fold(dict.new(), fn(acc, _, value) {
      let #(x, _, has_been_called) = value
      use <- bool.guard(when: !has_been_called, return: acc)
      acc |> dict.upsert(x, utils.dict_increment)
    })
    |> dict.values()
    |> list.any(fn(count) { count == 5 })

  let vertical =
    board
    |> dict.fold(dict.new(), fn(acc, _, value) {
      let #(_, y, has_been_called) = value
      use <- bool.guard(when: !has_been_called, return: acc)
      acc
      |> dict.upsert(y, utils.dict_increment)
    })
    |> dict.values()
    |> list.any(fn(count) { count == 5 })

  bool.or(horizontal, vertical)
}

fn play_number(game: Game, number: Int) -> List(Board) {
  game.boards
  |> list.map(dict.map_values(_, fn(key, value: #(Int, Int, Bool)) {
    case key == number {
      True -> #(value.0, value.1, True)
      False -> value
    }
  }))
}

fn parse_game(input: String) {
  use #(numbers, rest) <- result.try(input |> string.split_once("\n\n"))
  use numbers <- result.map(
    numbers |> string.split(",") |> list.try_map(int.parse(_)),
  )
  let boards =
    rest
    |> string.split("\n\n")
    |> list.map(parse_board(_))
  Bingo(numbers, boards)
}

fn find_first_winner(game: Game) -> #(Board, Int) {
  case game.numbers {
    [current, ..rest] -> {
      // set each game board with new number
      let new_boards = game |> play_number(current)
      let game = Bingo(numbers: rest, boards: new_boards)
      // check if any boards win
      list.find(game.boards, winning(_))
      |> result.map(fn(board) { #(board, current) })
      // or else find winner of next state
      |> result.lazy_unwrap(fn() { find_first_winner(game) })
    }
    [] -> panic as "Game Over!"
  }
}

fn finish(game: Game) -> #(Board, Int) {
  case game.numbers {
    [] -> panic as "Game Over"
    [current, ..rest] -> {
      let new_boards = game |> play_number(current)
      let game = Bingo(numbers: rest, boards: new_boards)
      let winning = list.filter(game.boards, winning(_))
      case winning {
        [board] -> #(board, current)
        _ -> finish(game)
      }
    }
  }
}

fn find_last_winner(game: Game) -> #(Board, Int) {
  case game.numbers {
    [] -> panic as "Game Over!"
    [current, ..rest] -> {
      let new_boards =
        game
        |> play_number(current)
        |> list.filter(fn(board) { !winning(board) })
      let game = Bingo(numbers: rest, boards: new_boards)
      case game.boards {
        [] -> panic as "Impossible!"
        [_] -> finish(game)
        [_, ..] -> find_last_winner(game)
      }
    }
  }
}

fn calculate_score(board: Board, num_won: Int) {
  let sum_of_remaining =
    board
    |> dict.filter(fn(_, value) { !value.2 })
    |> dict.keys()
    |> utils.sum()
  sum_of_remaining * num_won
}

pub fn part1(input: String) -> Int {
  let assert Ok(game) = parse_game(input)
  let #(winning_board, number_won) = find_first_winner(game)
  calculate_score(winning_board, number_won)
}

pub fn part2(input: String) -> Int {
  let assert Ok(game) = parse_game(input)
  let #(winning_board, number_won) = find_last_winner(game)
  calculate_score(winning_board, number_won)
}

pub fn main() {
  let assert Ok(input) = simplifile.read("data/day4.txt")
  io.println("Part 1: " <> part1(input) |> int.to_string())
  io.println("Part 2: " <> part2(input) |> int.to_string())
}
