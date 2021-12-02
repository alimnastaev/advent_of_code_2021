defmodule AOC_2021.Day1 do
  @input "input.txt"

  def part_one_1 do
    [_, result] =
      @input
      |> list_of_numbers()
      |> Enum.reduce([0, 0], fn
        item, [0, result] -> [item, result]
        item, [last_item, result] when last_item < item -> [item, result + 1]
        item, [_, result] -> [item, result]
      end)

    result
  end

  def part_one_2 do
      @input
      |> list_of_numbers()
      |> Enum.to_list()
      |> do_job(0)
  end

  defp do_job([first | [second | _] = tail], result) when first < second,
    do: do_job(tail, result + 1)

  defp do_job([_ | [_ | _] = tail], result), do: do_job(tail, result)

  defp do_job([_ | _], result), do: result

  def part_two do
    [_, _, result] =
      @input
      |> list_of_numbers()
      |> Enum.chunk_every(3, 1, :discard)
      |> Enum.reduce([0, 0, 0], fn
        [first, second, third], [0, _window_sum, result] ->
          [first + second + third, second + third, result]

        [_first, second, third], [last_item, window_sum, result]
        when last_item < window_sum + third ->
          [window_sum + third, second + third, result + 1]

        [_first, second, third], [_, window_sum, result] ->
          [window_sum + third, second + third, result]
      end)

    result
  end

  defp list_of_numbers(input) do
    input
    |> File.stream!([], :line)
    |> Stream.map(fn line ->
      {integer, _} = Integer.parse(line)
      integer
    end)
  end
end

case System.argv() do
  ["--test"] ->
    ExUnit.start()

    defmodule AOC_2021.Day1Test do
      use ExUnit.Case

      @expected_part_one 1121
      @expected_part_two 1065

      test "tests" do
        response = fn _, _, _ ->
          [
            AOC_2021.Day1.part_one_1(),
            AOC_2021.Day1.part_one_2(),
            AOC_2021.Day1.part_two()
          ]
        end

        assert [@expected_part_one, @expected_part_one, @expected_part_two] ==
                 response.(1121, 1121, 1065)
      end
    end

  ["--run"] ->
    AOC_2021.Day1.part_one_1()
    |> IO.inspect(label: "\npart_one_1 \n")

    AOC_2021.Day1.part_one_2()
    |> IO.inspect(label: "\npart_one_2 \n")

    AOC_2021.Day1.part_two()
    |> IO.inspect(label: "\npart_two \n")

  _ ->
    IO.puts(:stderr, "\nplease specify --run or --test flag")
end
