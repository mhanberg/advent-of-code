defmodule AdventOfCode2019.Day12 do
  def part1(args, steps) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn moon ->
      [_, xp, yp, zp] =
        Regex.run(
          ~r/<x=(-?\d+), y=(-?\d+), z=(-?\d+)>/,
          moon
        )

      {{String.to_integer(xp), String.to_integer(yp), String.to_integer(zp)}, {0, 0, 0}}
    end)
    |> run(steps)
    |> calculate_total_energy(0)
  end

  def part2(xes, yes, zes) do
    [cycle1, cycle2, cycle3] =
      [xes, yes, zes]
      |> Enum.map(&Enum.sort/1)
      |> Enum.map(&Task.async(fn -> run2(&1, &1, 1) end))
      |> Enum.map(&Task.await(&1, :infinity))

    Utils.lcm(cycle1, cycle2)
    |> Utils.lcm(cycle3)
  end

  defp run2(moons, initial, steps) do
    moons =
      moons
      |> calculate_velocities(4)
      |> calculate_positions(4)
      |> Enum.sort()

    if moons == initial do
      steps
    else
      run2(moons, initial, steps + 1)
    end
  end

  defp run(moons, 0), do: moons

  defp run(moons, steps) do
    moons
    |> calculate_velocities(4)
    |> calculate_positions(4)
    |> run(steps - 1)
  end

  defp calculate_total_energy([], sum), do: sum

  defp calculate_total_energy([{{x, y, z}, {vx, vy, vz}} | moons], sum) do
    calculate_total_energy(
      moons,
      (abs(x) + abs(y) + abs(z)) * (abs(vx) + abs(vy) + abs(vz)) + sum
    )
  end

  defp calculate_velocities(moons, 0), do: moons

  defp calculate_velocities([{pos, vel} | moons], count) do
    new_moon_velocity =
      Enum.reduce(
        moons,
        vel,
        fn {cpos, _}, acc_vel -> accelerate(pos, cpos) + acc_vel end
      )

    new_moon = [{pos, new_moon_velocity}]

    calculate_velocities(moons ++ new_moon, count - 1)
  end

  defp calculate_positions([moon | moons], 0), do: moons ++ [moon]

  defp calculate_positions([{pos, vel} | moons], count) do
    calculate_positions(moons ++ [{pos + vel, vel}], count - 1)
  end

  defp accelerate(p, p2) when p < p2, do: 1
  defp accelerate(p, p2) when p == p2, do: 0
  defp accelerate(_, _), do: -1
end
