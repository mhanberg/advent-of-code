defmodule Day8 do
  def eval(key, "inc", delta, value, ">", operand2, registers) when value > operand2 do
    Map.put(registers, key, (registers[key] + delta))
  end
  def eval(key, "inc", delta, value, "<", operand2, registers) when value < operand2 do
    Map.put(registers, key, (registers[key] + delta))
  end
  def eval(key, "inc", delta,  value, ">=", operand2, registers) when value >= operand2 do
    Map.put(registers, key, (registers[key] + delta))
  end
  def eval(key, "inc", delta,  value, "<=", operand2, registers) when value <= operand2 do
    Map.put(registers, key, (registers[key] + delta))
  end
  def eval(key, "inc", delta,  value, "==", operand2, registers) when value == operand2 do
    Map.put(registers, key, (registers[key] + delta))
  end
  def eval(key, "inc", delta,  value, "!=", operand2, registers) when value != operand2 do
    Map.put(registers, key, (registers[key] + delta))
  end

  def eval(key, "dec", delta, value, ">", operand2, registers) when value > operand2 do
    Map.put(registers, key, (registers[key] - delta))
  end
  def eval(key, "dec", delta, value, "<", operand2, registers) when value < operand2 do
    Map.put(registers, key, (registers[key] - delta))
  end
  def eval(key, "dec", delta,  value, ">=", operand2, registers) when value >= operand2 do
    Map.put(registers, key, (registers[key] - delta))
  end
  def eval(key, "dec", delta,  value ,"<=", operand2, registers) when value <= operand2 do
    Map.put(registers, key, (registers[key] - delta))
  end
  def eval(key, "dec", delta,  value, "==", operand2, registers) when value == operand2 do
    Map.put(registers, key, (registers[key] - delta))
  end
  def eval(key, "dec", delta, value, "!=", operand2, registers) when value != operand2 do
    Map.put(registers, key, (registers[key] - delta))
  end

  def eval(_k, _op, _d,  _v, _c, _op2, registers) do
    registers
  end
end

registers = File.read!("day8_input.txt")
  |> String.split(~r{\n}, trim: true)
  |> Enum.map(fn(x) -> x |> String.split |> List.first end)
  |> Enum.uniq
  |> Enum.reduce(%{}, fn(x, acc) -> Map.put(acc, x, 0) end)

{new_registers, max_all_time} =File.read!("day8_input.txt")
  |> String.split(~r{\n}, trim: true)
  |> Enum.reduce({registers, 0}, fn(x, {acc, acc2}) ->
      [key, op, delta, _iff, op1, comp, op2] = String.split(x)
      {_k, v} = Enum.max_by(acc, fn({_key, value}) -> value end)
      acc2 = Enum.max( [acc2, v])
      {Day8.eval(key, op, String.to_integer(delta), acc[op1], comp, String.to_integer(op2), acc), acc2}
    end)

new_registers
  |> Enum.max_by(fn({_key, value}) -> value end)
  |> IO.inspect

IO.puts max_all_time
