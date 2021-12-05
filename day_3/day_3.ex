defmodule AOC_2021.Day3 do
  @input "input_3.txt"

  @initial_list_of_tuples [{?0, 0}, {?1, 0}]
  @acc List.duplicate(@initial_list_of_tuples, 12)

  def part_one do
    @input
    |> read_file()
    |> find_max_min_occ()
    |> to_gamma_epsilon()
    |> count()
  end

  defp find_max_min_occ(list_of_strings) do
    Enum.reduce(
      list_of_strings,
      @acc,
      fn <<first, second, third, fourth, fifth, six, seven, eight, nine, ten, eleven, twelve,
           _::binary>>,
         [i1, i2, i3, i4, i5, i6, i7, i8, i9, i10, i11, i12] ->
        [
          form_in_order(i1, first),
          form_in_order(i2, second),
          form_in_order(i3, third),
          form_in_order(i4, fourth),
          form_in_order(i5, fifth),
          form_in_order(i6, six),
          form_in_order(i7, seven),
          form_in_order(i8, eight),
          form_in_order(i9, nine),
          form_in_order(i10, ten),
          form_in_order(i11, eleven),
          form_in_order(i12, twelve)
        ]
      end
    )
  end

  defp form_in_order([{k1, v1}, {k2, v2}], item) when k1 == item do
    t = [{k1, v1 + 1}, {k2, v2}]
    [{k1, v1}, {k2, v2}] = t
    if v1 > v2, do: [{k1, v1}, {k2, v2}], else: Enum.reverse(t)
  end

  defp form_in_order([{k1, v1}, {k2, v2}], _item), do: [{k1, v1}, {k2, v2 + 1}]

  defp to_gamma_epsilon(list_of_tuples) do
    Enum.reduce(list_of_tuples, {[], []}, fn [{k1, _}, {k2, _}], {gm, ep} ->
      {[k1 | gm], [k2 | ep]}
    end)
  end

  defp count({gm, ep}) do
    gm = parse_to_string(gm)
    ep = parse_to_string(ep)

    gm * ep
  end

  defp parse_to_string(charlist) do
    charlist
    |> Enum.reverse()
    |> List.to_string()
    |> Integer.parse(2)
    |> elem(0)
  end

  defp read_file(input) do
    input
    |> File.read!()
    |> String.trim()
    |> String.split(["\n"])
  end
end

case System.argv() do
  ["--test"] ->
    ExUnit.start()

    defmodule AOC_2021.Day3Test do
      use ExUnit.Case

      @expected_part_one 3_901_196

      test "tests" do
        response = fn _ ->
          [
            AOC_2021.Day3.part_one()
          ]
        end

        assert [@expected_part_one] ==
                 response.(3_901_196)
      end
    end

  ["--run"] ->
    AOC_2021.Day3.part_one()
    |> IO.inspect(label: "\npart_one \n")

  _ ->
    IO.puts(:stderr, "\nplease specify --run or --test flag")
end
