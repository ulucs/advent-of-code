defmodule AoCUtils do
  def get_input(day) do
    Application.ensure_all_started(:inets)
    Application.ensure_all_started(:ssl)

    {:ok, {{'HTTP/1.1', 200, 'OK'}, _headers, body}} =
      :httpc.request(
        :get,
        {'https://adventofcode.com/2018/day/' ++ day ++ '/input',
         [
           {
             'Cookie',
             'session=53616c7465645f5f4e6b2c8d3a18585ce674464c0154d6b8498b0dc87051709919ef22817a65511c73b48ec6b9dce69b'
           }
         ]},
        [],
        []
      )

    body
    |> List.to_string()
    |> String.trim()
  end

  def count_each(list) do
    list
    |> Enum.reduce(%{}, &add_count/2)
  end

  def add_count(item, map) do
    with {:ok, ct} <- Map.fetch(map, item) do
      %{map | item => ct + 1}
    else
      _ ->
        Map.put(map, item, 1)
    end
  end

  def run_solutions(day, f1) do
    IO.puts("Solution for the first star:")

    get_input(day)
    |> f1.()
    |> IO.inspect()
  end

  def run_solutions(day, f1, f2) do
    IO.puts("Solution for the first star:")

    get_input(day)
    |> f1.()
    |> IO.inspect()

    IO.puts("")
    IO.puts("Solution for the second star:")

    get_input(day)
    |> f2.()
    |> IO.inspect()
  end
end