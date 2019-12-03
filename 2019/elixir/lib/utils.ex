defmodule Utils do
  def input_to_ints(file) do
    file
    |> input_to_list()
    |> Stream.map(&String.to_integer/1)
  end

  def read!(file) do
    "priv/#{file}"
    |> File.read!()
  end

  def input_to_list(file) do
    "priv/#{file}"
    |> File.stream!()
    |> Stream.map(&String.trim/1)
  end

  def input_split_by(file, split_by, mapper \\ fn x -> x end) do
    "priv/#{file}"
    |> File.read!()
    |> String.split(split_by, trim: true)
    |> Enum.map(&String.trim/1)
    |> Enum.map(mapper)
  end
end
