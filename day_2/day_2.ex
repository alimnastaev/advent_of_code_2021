defmodule AOC_2021.Day2 do
  @input "input.txt"

  def part_one do
    [horizontal, depth] =
      @input
      |> list_of_strings()
      |> Enum.reduce([0, 0], &do_job/2)

    horizontal * depth
  end

  defp do_job("forward " <> n, [h, d]), do: [h + String.to_integer(n), d]

  defp do_job("down " <> n, [h, d]), do: [h, d + String.to_integer(n)]

  defp do_job("up " <> n, [h, d]), do: [h, d - String.to_integer(n)]

  def part_two do
    [horizontal, depth, _aim] =
      @input
      |> list_of_strings()
      |> Enum.reduce([0, 0, 0], &do_job_two/2)

    horizontal * depth
  end

  defp do_job_two("forward " <> n, [h, d, 0]), do: [h + String.to_integer(n), d, 0]

  defp do_job_two("forward " <> n, [h, d, aim]) do
    n = String.to_integer(n)
    [h + n, d + n * aim, aim]
  end

  defp do_job_two("down " <> n, [h, d, aim]) do
    n = String.to_integer(n)
    [h, d, aim + n]
  end

  defp do_job_two("up " <> n, [h, d, aim]) do
    n = String.to_integer(n)
    [h, d, aim - n]
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
      @expected_part_two 1_960_569_556

      test "tests" do
        response = fn _, _ ->
          [
            AOC_2021.Day2.part_one(),
            AOC_2021.Day2.part_two()
          ]
        end

        assert [@expected_part_one, @expected_part_two] ==
                 response.(1_813_801, 1_960_569_556)
      end
    end

  ["--run"] ->
    AOC_2021.Day2.part_one()
    |> IO.inspect(label: "\npart_one \n")

    AOC_2021.Day2.part_two()
    |> IO.inspect(label: "\npart_two \n")

  _ ->
    IO.puts(:stderr, "\nplease specify --run or --test flag")
end
