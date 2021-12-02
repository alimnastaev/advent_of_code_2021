defmodule AOC_2021.Day2 do
  @input "input.txt"

  def part_one do
    [horizontal, depth] =
      @input
      |> list_of_strings()
      |> Enum.reduce([0, 0], &do_job/2)

    horizontal * depth
  end

  defp do_job("forward " <> n, [horizontal, depth]) do
    n = String.to_integer(n)
    [horizontal + n, depth]
  end

  defp do_job("down " <> n, [horizontal, depth]) do
    n = String.to_integer(n)
    [horizontal, depth + n]
  end

  defp do_job("up " <> n, [horizontal, depth]) do
    n = String.to_integer(n)
    [horizontal, depth - n]
  end

  defp list_of_strings(input) do
    input
    |> File.read!()
    |> String.trim()
    |> String.split(["\n"])
  end
end

case System.argv() do
  ["--test"] ->
    ExUnit.start()

    defmodule AOC_2021.Day1Test do
      use ExUnit.Case

      @expected_part_one 1_813_801

      test "tests" do
        response = fn _ ->
          [
            AOC_2021.Day2.part_one()
          ]
        end

        assert [@expected_part_one] ==
                 response.(1_813_801)
      end
    end

  ["--run"] ->
    AOC_2021.Day2.part_one()
    |> IO.inspect(label: "\npart_one \n")

  _ ->
    IO.puts(:stderr, "\nplease specify --run or --test flag")
end
