require AoCUtils

defmodule Day4 do
  def timekeeper(log, %{guard: g, asleep: a, timetable: tt}) do
    [_, mins, message] = String.split(log, [":", "] "])
    m = String.to_integer(mins)

    case message do
      "falls asleep" ->
        %{guard: g, asleep: m, timetable: tt}

      "wakes up" ->
        %{
          guard: g,
          asleep: nil,
          timetable:
            with {:ok, recs} <- Map.fetch(tt, g) do
              %{tt | g => Enum.concat([recs, a..(m - 1)])}
            else
              _ -> Map.put(tt, g, Enum.to_list(a..(m - 1)))
            end
        }

      "Guard #" <> x ->
        %{
          guard:
            x
            |> String.replace(~r{[^0-9]}, "")
            |> String.to_integer(),
          asleep: a,
          timetable: tt
        }
    end
  end

  def silver(input) do
    {agent, times} =
      input
      |> String.split("\n")
      |> Enum.sort()
      |> Enum.reduce(
        %{guard: nil, asleep: nil, timetable: %{}},
        &timekeeper/2
      )
      |> Map.fetch!(:timetable)
      |> Enum.max_by(fn {_, v} -> Enum.count(v) end)

    {max_time, _} =
      times
      |> AoCUtils.count_each()
      |> Enum.max_by(fn {_, v} -> v end)

    agent * max_time
  end

  def gold(input) do
    {agent, {minute, _}} =
      input
      |> String.split("\n")
      |> Enum.sort()
      |> Enum.reduce(
        %{guard: nil, asleep: nil, timetable: %{}},
        &timekeeper/2
      )
      |> Map.fetch!(:timetable)
      |> Enum.map(fn {k, v} ->
        {
          k,
          AoCUtils.count_each(v)
          |> Enum.max_by(fn {_, v} -> v end)
        }
      end)
      |> Enum.max_by(fn {_, {_, v}} -> v end)

    agent * minute
  end
end

AoCUtils.run_solutions('4', &Day4.silver/1, &Day4.gold/1)
