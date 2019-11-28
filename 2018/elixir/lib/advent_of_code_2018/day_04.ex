defmodule AdventOfCode2018.Day04 do
  def part1(args) do
    new_sums_totals =
      args
      |> parse_data()
      |> process_log()

    {id, %{"totals" => totals}} =
      new_sums_totals
      |> Enum.max_by(fn {_k, v} ->
        Map.fetch!(v, "duration")
      end)

    {sleepiest_minute, _} =
      totals
      |> Enum.max_by(fn {_k, v} -> v end)

    String.to_integer(id) * sleepiest_minute
  end

  def part2(args) do
    new_sums_totals =
      args
      |> parse_data()
      |> process_log()

    new_sums_totals
    |> Map.keys()

    {id, sleepiest_minute, _} =
      new_sums_totals
      |> Enum.reduce([], fn {k, v}, acc ->
        {sleepiest_minute, times} =
          Map.fetch!(v, "totals")
          |> Enum.max_by(fn {_k, v} -> v end)

        [{k, sleepiest_minute, times} | acc]
      end)
      |> Enum.max_by(fn {_k, _sm, t} -> t end)

    String.to_integer(id) * sleepiest_minute
  end

  defp parse_data(args) do
    args
    |> Stream.map(fn entry ->
      Regex.named_captures(
        ~r/^\[(?<timestamp>.{16})\]\s(?<note>.*)$/,
        entry
      )
    end)
    |> Stream.map(fn entry ->
      deconstructed_timestamp =
        Regex.named_captures(~r/^(?<date>.*)\s(?<time>.*$)/, entry["timestamp"])

      deconstructed_note = Regex.named_captures(~r/^Guard #(?<id>\d+).*$/, entry["note"])

      entry
      |> Map.put("date", deconstructed_timestamp["date"])
      |> Map.put("time", deconstructed_timestamp["time"])
      |> Map.put("id", deconstructed_note["id"])
    end)
    |> Enum.sort_by(fn entry -> Map.fetch(entry, "timestamp") end)
  end

  defp process_log(log) do
    [latest_entry | the_rest] = log

    process_entry(latest_entry, the_rest, Map.new(), {})
  end

  defp process_entry(
         %{"note" => "falls asleep", "time" => time},
         [latest_entry | the_rest],
         sums_totals,
         {:id, id}
       ) do
    process_entry(latest_entry, the_rest, sums_totals, {:id, id, :time, time})
  end

  defp process_entry(
         %{"note" => "wakes up", "time" => end_time},
         [latest_entry | the_rest],
         sums_totals,
         {:id, id, :time, start_time}
       ) do
    start_sleep_at = start_time |> String.split(":") |> List.last() |> String.to_integer()
    end_sleep_at = end_time |> String.split(":") |> List.last() |> String.to_integer()

    sleep_duration = end_sleep_at - start_sleep_at

    for_this_id = Map.fetch!(sums_totals, id)

    for_this_id =
      for_this_id
      |> Map.update!("duration", fn old_total -> old_total + sleep_duration end)

    new_totals =
      start_sleep_at..(end_sleep_at - 1)
      |> Enum.reduce(Map.fetch!(for_this_id, "totals"), fn x, acc ->
        Map.update!(acc, x, fn old -> old + 1 end)
      end)

    for_this_id =
      for_this_id
      |> Map.put("totals", new_totals)

    new_sums_totals =
      sums_totals
      |> Map.put(id, for_this_id)

    process_entry(latest_entry, the_rest, new_sums_totals, {:id, id})
  end

  defp process_entry(
         %{"id" => id, "note" => "Guard" <> _},
         [latest_entry | the_rest],
         sums_totals,
         _
       ) do
    initial_totals =
      0..59
      |> Enum.reduce(Map.new(), fn x, acc -> Map.put(acc, x, 0) end)

    new_sums_totals =
      sums_totals
      |> Map.put_new(id, %{"duration" => 0, "totals" => initial_totals})

    process_entry(latest_entry, the_rest, new_sums_totals, {:id, id})
  end

  defp process_entry(%{"time" => end_time}, [], sums_totals, {:id, id, :time, start_time}) do
    start_sleep_at = start_time |> String.split(":") |> List.last() |> String.to_integer()
    end_sleep_at = end_time |> String.split(":") |> List.last() |> String.to_integer()

    sleep_duration = end_sleep_at - start_sleep_at

    for_this_id = Map.fetch!(sums_totals, id)

    for_this_id =
      for_this_id
      |> Map.update!("duration", fn old_total -> old_total + sleep_duration end)

    new_totals =
      start_sleep_at..(end_sleep_at - 1)
      |> Enum.reduce(Map.fetch!(for_this_id, "totals"), fn x, acc ->
        Map.update!(acc, x, fn old -> old + 1 end)
      end)

    for_this_id =
      for_this_id
      |> Map.put("totals", new_totals)

    sums_totals
    |> Map.put(id, for_this_id)
  end
end
