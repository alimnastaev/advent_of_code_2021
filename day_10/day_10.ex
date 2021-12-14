defmodule AOC_2021.Day10 do
  @moduledoc """
  --- Day 10: Syntax Scoring ---
  https://adventofcode.com/2021/day/10
  """

  @input "input_10.txt"

  @matches ["()", "[]", "{}", "<>"]

  @corrupted_points %{
    ")" => 3,
    "]" => 57,
    "}" => 1197,
    ">" => 25137
  }
  @incompleted_points %{
    "(" => 1,
    "[" => 2,
    "{" => 3,
    "<" => 4
  }

  def part_one_and_part_two do
    [corrupted_result, incompleted_result] =
      @input
      |> read_file()
      |> parse_lines()
      |> count_scores()

    [part_one_score: corrupted_result, part_two_score: incompleted_result]
  end

  defp parse_lines(lines) do
    Enum.reduce(lines, [{:incompleted, [], 0}, {:corrupted, 0}], fn line, result ->
      run_check(line, "", result)
    end)
  end

  defp count_scores([{:incompleted, incompleted, length}, corrupted: corrupted_result]) do
    incompleted_result =
      incompleted
      |> Enum.sort()
      |> Enum.fetch!(div(length, 2))

    [corrupted_result, incompleted_result]
  end

  # Opening and Closing (just to make runs faster)
  defp run_check("{}" <> rest, stack, result), do: run_check(rest, stack, result)
  defp run_check("[]" <> rest, stack, result), do: run_check(rest, stack, result)
  defp run_check("()" <> rest, stack, result), do: run_check(rest, stack, result)
  defp run_check("<>" <> rest, stack, result), do: run_check(rest, stack, result)

  # Opening
  defp run_check("{" <> rest, stack, result), do: run_check(rest, "{" <> stack, result)
  defp run_check("[" <> rest, stack, result), do: run_check(rest, "[" <> stack, result)
  defp run_check("(" <> rest, stack, result), do: run_check(rest, "(" <> stack, result)
  defp run_check("<" <> rest, stack, result), do: run_check(rest, "<" <> stack, result)

  # Closing
  defp run_check(
         <<input_first_char::binary-size(1)>> <> rest,
         <<stack_first_char::binary-size(1)>> <> stack,
         result
       )
       when (stack_first_char <> input_first_char) in @matches do
    run_check(rest, stack, result)
  end

  # Corrupted
  defp run_check(
         <<input_first_char::binary-size(1)>> <> _rest,
         <<stack_first_char::binary-size(1)>> <> _stack,
         [incompleted, {:corrupted, corrupted}] = _result
       )
       when (stack_first_char <> input_first_char) not in @matches do
    [incompleted, {:corrupted, corrupted + Map.get(@corrupted_points, input_first_char)}]
  end

  # Incompleted
  defp run_check(<<>>, stack, [{:incompleted, incompleted, length}, corrupted] = _result)
       when stack != "" do
    [{:incompleted, incompleted ++ [count_incompleted(stack)], length + 1}, corrupted]
  end

  # Valid
  defp run_check("", "", result), do: result

  defp count_incompleted(stack) do
    stack
    |> String.graphemes()
    |> Enum.reduce(0, fn l, acc -> acc * 5 + Map.get(@incompleted_points, l) end)
  end

  defp read_file(file) do
    file
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end

case System.argv() do
  ["--test"] ->
    ExUnit.start()

    defmodule AOC_2021.Day10Test do
      use ExUnit.Case

      @result [part_one_score: 319_233, part_two_score: 1_118_976_874]

      test "tests" do
        assert AOC_2021.Day10.part_one_and_part_two() == @result
      end
    end

  ["--run"] ->
    AOC_2021.Day10.part_one_and_part_two()
    |> IO.inspect(label: "\nresult \n")

  _ ->
    IO.puts(:stderr, "\nplease specify --run or --test flag")
end
