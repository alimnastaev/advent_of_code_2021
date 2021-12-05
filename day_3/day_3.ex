defmodule AOC_2021.Day3 do
  @input "input_3.txt"

  @initial_list_of_tuples [{"0", 0}, {"1", 0}]
  @acc [
    @initial_list_of_tuples,
    @initial_list_of_tuples,
    @initial_list_of_tuples,
    @initial_list_of_tuples,
    @initial_list_of_tuples,
    @initial_list_of_tuples,
    @initial_list_of_tuples,
    @initial_list_of_tuples,
    @initial_list_of_tuples,
    @initial_list_of_tuples,
    @initial_list_of_tuples,
    @initial_list_of_tuples
  ]

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
      fn <<first::binary-size(1)>> <>
           <<second::binary-size(1)>> <>
           <<third::binary-size(1)>> <>
           <<fourth::binary-size(1)>> <>
           <<fifth::binary-size(1)>> <>
           <<six::binary-size(1)>> <>
           <<seven::binary-size(1)>> <>
           <<eight::binary-size(1)>> <>
           <<nine::binary-size(1)>> <>
           <<ten::binary-size(1)>> <>
           <<eleven::binary-size(1)>> <>
           <<twelve::binary-size(1)>>,
         [
           o,
           t,
           th,
           fo,
           fi,
           si,
           se,
           ei,
           ni,
           te,
           el,
           tw
         ] ->
        [
          form_in_order(o, first),
          form_in_order(t, second),
          form_in_order(th, third),
          form_in_order(fo, fourth),
          form_in_order(fi, fifth),
          form_in_order(si, six),
          form_in_order(se, seven),
          form_in_order(ei, eight),
          form_in_order(ni, nine),
          form_in_order(te, ten),
          form_in_order(el, eleven),
          form_in_order(tw, twelve)
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
    Enum.reduce(list_of_tuples, {"", ""}, fn [{k1, _}, {k2, _}], {gm, ep} ->
      {gm <> k1, ep <> k2}
    end)
  end

  defp count({gm, ep}) do
    gm = Integer.parse(gm, 2) |> elem(0)
    ep = Integer.parse(ep, 2) |> elem(0)
    gm * ep
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
