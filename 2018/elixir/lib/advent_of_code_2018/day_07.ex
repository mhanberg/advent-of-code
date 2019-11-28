defmodule AdventOfCode2018.Day07 do
  @penalty (System.get_env("PENALTY") || "0") |> String.to_integer()
  @step_duration Enum.map(Enum.zip(?A..?Z, 1..26), fn {x, y} ->
                   {to_string([x]) |> String.to_atom(), y + @penalty}
                 end)
  @workers (System.get_env("WORKERS") || "2") |> String.to_integer()

  def part1(args) do
    parse(args)
    |> sort()
  end

  def part2(args) do
    parse(args)
    |> tick()
  end

  defp parse(args) do
    args
    |> Stream.map(fn instruction ->
      %{"requisite" => requisite, "desired_step" => desired_step} =
        Regex.named_captures(
          ~r/Step (?<requisite>.) must be finished before step (?<desired_step>.) can begin\./,
          instruction
        )

      {requisite, desired_step}
    end)
    |> (&(Stream.flat_map(&1, fn x -> Tuple.to_list(x) end)
          |> Stream.uniq()
          |> Enum.reduce(
            Enum.reduce(&1, Map.new(), fn {req, instruction}, acc ->
              Map.update(acc, instruction, [req], fn x -> [req | x] end)
            end),
            fn x, acc -> Map.put_new(acc, x, []) end
          ))).()
  end

  defp tick(req_chart) do
    tick([], req_chart, 0)
  end

  defp tick(_, empty_rec_chart, time) when map_size(empty_rec_chart) == 0, do: time - 1

  defp tick(workers, req_chart, time) do
    workers = Enum.map(workers, fn {ins, t} -> {ins, t - 1} end)
    {done, still_working} = Enum.split_with(workers, fn {_ins, t} -> t == 0 end)

    req_chart = Enum.reduce(done, req_chart, fn {ins, 0}, acc -> remove_requisite(acc, ins) end)

    available = available_steps(req_chart, still_working)

    work_to_delegate = @workers - Enum.count(still_working)

    just_started =
      available
      |> Enum.split(work_to_delegate)
      |> elem(0)
      |> Enum.reduce([], fn x, acc ->
        [{x, @step_duration[String.to_atom(x)]} | acc]
      end)

    all_working = just_started ++ still_working

    tick(all_working, req_chart, time + 1)
  end

  defp sort(req_chart) do
    available = available_steps(req_chart)

    sort(available, [], req_chart)
  end

  defp sort([], done, _), do: done |> Enum.reverse() |> Enum.join()

  defp sort([next | _rest], done, req_chart) do
    req_chart = remove_requisite(req_chart, next)

    available = available_steps(req_chart)

    sort(available, [next | done], req_chart)
  end

  defp available_steps(req_chart, workers \\ []) do
    req_chart
    |> Stream.filter(fn {_, reqs} -> reqs |> Enum.empty?() end)
    |> Stream.map(fn {k, _v} -> k end)
    |> Stream.reject(fn ins -> Enum.any?(workers, fn {i, _} -> ins == i end) end)
    |> Enum.sort()
  end

  defp remove_requisite(req_chart, req) do
    req_chart
    |> Map.keys()
    |> Enum.reduce(req_chart, fn k, acc ->
      Map.update!(acc, k, fn reqs -> List.delete(reqs, req) end)
    end)
    |> Map.delete(req)
  end
end
