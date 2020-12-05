defmodule AdventOfCode.Day04 do
  defmodule InputParser do
    import NimbleParsec
    import Utils, only: [range: 2]

    defcombinator :ecl,
                  ignore(string("ecl"))
                  |> ignore(string(":"))
                  |> choice([
                    string("amb"),
                    string("blu"),
                    string("brn"),
                    string("gry"),
                    string("grn"),
                    string("hzl"),
                    string("oth")
                  ])
                  |> unwrap_and_tag(:ecl)

    defcombinator :pid,
                  ignore(string("pid"))
                  |> ignore(string(":"))
                  |> ascii_string([?0..?9], 9)
                  |> unwrap_and_tag(:pid)

    defcombinator :eyr,
                  ignore(string("eyr"))
                  |> ignore(string(":"))
                  |> choice(range(2020, 2030))
                  |> unwrap_and_tag(:eyr)

    defcombinator :byr,
                  ignore(string("byr"))
                  |> ignore(string(":"))
                  |> choice(range(1920, 2002))
                  |> unwrap_and_tag(:byr)

    defcombinator :iyr,
                  ignore(string("iyr"))
                  |> ignore(string(":"))
                  |> choice(range(2010, 2020))
                  |> unwrap_and_tag(:iyr)

    defcombinator :hcl,
                  ignore(string("hcl"))
                  |> ignore(string(":"))
                  |> string("#")
                  |> ascii_string([?0..?9, ?a..?f], 6)
                  |> reduce({Enum, :join, []})
                  |> unwrap_and_tag(:hcl)

    defcombinator :height_in_cm,
                  choice(range(150, 193))
                  |> string("cm")

    defcombinator :height_in_inch,
                  choice(range(59, 76))
                  |> string("in")

    defcombinator :hgt,
                  ignore(string("hgt"))
                  |> ignore(string(":"))
                  |> choice([
                    parsec(:height_in_cm),
                    parsec(:height_in_inch)
                  ])
                  |> reduce({Enum, :join, []})
                  |> unwrap_and_tag(:hgt)

    defcombinator :cid,
                  ignore(string("cid"))
                  |> ignore(string(":"))
                  |> integer(min: 1)
                  |> unwrap_and_tag(:cid)

    defcombinator :entry,
                  choice([
                    parsec(:ecl),
                    parsec(:pid),
                    parsec(:eyr),
                    parsec(:byr),
                    parsec(:iyr),
                    parsec(:hcl),
                    ignore(parsec(:cid)),
                    parsec(:hgt)
                  ])

    new_line = string("\n")
    space = string(" ")

    white_space = choice([new_line, space])

    separator_entry = concat(ignore(white_space), parsec(:entry))

    defparsec :passport,
              parsec(:entry)
              |> times(separator_entry, min: 0, max: 7)
              |> tag(:passport)
  end

  @required_entries Enum.sort(~w[ecl pid eyr hcl byr iyr hgt]a)

  # this part doesnt work with the updated parser used for part 2
  def part1(args) do
    args
    |> String.split("\n\n")
    |> Stream.map(&InputParser.passport/1)
    |> Stream.filter(fn {status, _, _, _, _, _} -> status == :ok end)
    |> Stream.map(&elem(IO.inspect(&1), 1))
    |> Stream.map(fn [passport: passport] ->
      passport
      |> Keyword.keys()
      |> Enum.sort()
      |> required_entries_present?()
      |> increment_count()
    end)
    |> Enum.sum()
  end

  def part2(args) do
    args
    |> String.split("\n\n")
    |> Stream.map(&InputParser.passport(&1, debug: true))
    |> Stream.filter(fn {status, _, _, _, _, _} -> status == :ok end)
    |> Stream.map(&elem(&1, 1))
    |> Stream.map(fn [passport: passport] ->
      passport
      |> Keyword.keys()
      |> Enum.sort()
      |> required_entries_present?()
      |> increment_count()
    end)
    |> Enum.sum()
  end

  defp required_entries_present?(keys_in_passport) do
    @required_entries == keys_in_passport
  end

  defp increment_count(yes?) do
    if yes? do
      1
    else
      0
    end
  end
end
