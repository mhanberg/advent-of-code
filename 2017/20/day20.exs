defmodule Day20 do
  def move_particles(particles) do
    unless Enum.any?(particles, fn {_, %{moving_closer?: moving_closer?}} -> moving_closer? end) do
      particles
    else
      particles =
        particles
        |> Enum.map(fn {key, particle} ->
          new_vx = particle["vx"] + particle["ax"]
          new_vy = particle["vy"] + particle["ay"]
          new_vz = particle["vz"] + particle["az"]

          new_px = particle["px"] + new_vx
          new_py = particle["py"] + new_vy
          new_pz = particle["pz"] + new_vz

          {key,
           %{
             particle
             | "vx" => new_vx,
               "vy" => new_vy,
               "vz" => new_vz,
               "px" => new_px,
               "py" => new_py,
               "pz" => new_pz,
               :moving_closer? =>
                 position(new_px, new_py, new_pz) <=
                   position(particle["px"], particle["py"], particle["pz"])
           }}
        end)

      move_particles(particles)
    end
  end

  defp position(px, py, pz), do: abs(px) + abs(py) + abs(pz)

  defp integerize(particle) do
    %{
      particle
      | "vx" => particle["vx"] |> String.to_integer(),
        "vy" => particle["vy"] |> String.to_integer(),
        "vz" => particle["vz"] |> String.to_integer(),
        "ax" => particle["ax"] |> String.to_integer(),
        "ay" => particle["ay"] |> String.to_integer(),
        "az" => particle["az"] |> String.to_integer(),
        "px" => particle["px"] |> String.to_integer(),
        "py" => particle["py"] |> String.to_integer(),
        "pz" => particle["pz"] |> String.to_integer()
    }
  end

  def part1() do
    File.read!("./20/day20_input.txt")
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.map(fn {particle, idx} ->
      {idx,
       Regex.named_captures(
         ~r/p=<(?<px>-?\d+),(?<py>-?\d+),(?<pz>-?\d+)>, v=<(?<vx>-?\d+),(?<vy>-?\d+),(?<vz>-?\d+)>, a=<(?<ax>-?\d+),(?<ay>-?\d+),(?<az>-?\d+)>/,
         particle
       )
       |> integerize()
       |> Map.put(:moving_closer?, true)}
    end)
    |> move_particles()
    |> Enum.min_by(fn {_, %{"ax" => ax, "ay" => ay, "az" => az}} ->
      position(ax, ay, az)
    end)
    |> elem(0)
  end

  def move_particles2(particles) do
    unless Enum.any?(particles, fn {_, %{moving_closer?: moving_closer?}} -> moving_closer? end) do
      particles
    else
      particles =
        particles
        |> Enum.map(fn {key, particle} ->
          new_vx = particle["vx"] + particle["ax"]
          new_vy = particle["vy"] + particle["ay"]
          new_vz = particle["vz"] + particle["az"]

          new_px = particle["px"] + new_vx
          new_py = particle["py"] + new_vy
          new_pz = particle["pz"] + new_vz

          {key,
           %{
             particle
             | "vx" => new_vx,
               "vy" => new_vy,
               "vz" => new_vz,
               "px" => new_px,
               "py" => new_py,
               "pz" => new_pz,
               :moving_closer? =>
                 position(new_px, new_py, new_pz) <=
                   position(particle["px"], particle["py"], particle["pz"])
           }}
        end)

      set =
        MapSet.new(
          Enum.map(particles, fn {_, particle} ->
            {particle["px"], particle["py"], particle["pz"]}
          end)
        )

      particles =
        particles
        |> Enum.reject(fn {key, particle} ->
          Enum.count(particles, fn {_, p} ->
            particle["px"] == p["px"] && particle["py"] == p["py"] && particle["pz"] == p["pz"]
          end) > 1
        end)

      move_particles2(particles)
    end
  end

  def part2() do
    File.read!("./20/day20_input.txt")
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.map(fn {particle, idx} ->
      {idx,
       Regex.named_captures(
         ~r/p=<(?<px>-?\d+),(?<py>-?\d+),(?<pz>-?\d+)>, v=<(?<vx>-?\d+),(?<vy>-?\d+),(?<vz>-?\d+)>, a=<(?<ax>-?\d+),(?<ay>-?\d+),(?<az>-?\d+)>/,
         particle
       )
       |> integerize()
       |> Map.put(:moving_closer?, true)}
    end)
    |> move_particles2()
    |> length()
  end
end

Day20.part1() |> IO.inspect()
Day20.part2() |> IO.inspect()
