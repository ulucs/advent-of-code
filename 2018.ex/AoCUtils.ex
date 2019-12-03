defmodule AoCUtils do
  def get_input(day) do
    Application.ensure_all_started(:inets)
    Application.ensure_all_started(:ssl)

    session_cookie =
      File.read!("../session.cookie")
      |> String.to_charlist()

    {:ok, {{'HTTP/1.1', 200, 'OK'}, _headers, body}} =
      :httpc.request(
        :get,
        {'https://adventofcode.com/2018/day/' ++ day ++ '/input',
         [{'Cookie', 'session=' ++ session_cookie}]},
        [],
        []
      )

    body
    |> List.to_string()
    |> String.replace_suffix("\n", "")
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

  def list_red([first | tail], f) do
    [first | list_red(tail, first, f)]
  end

  def list_red([], _acc, _f) do
    []
  end

  def list_red([first | tail], acc, f) do
    fx = f.(first, acc)
    [fx | list_red(tail, fx, f)]
  end

  def run_solutions(day, f1) do
    IO.puts("Solution for the first star:")

    get_input(day)
    |> f1.()
    |> IO.inspect()
  end

  def run_solutions(day, f1, f2) do
    inp = get_input(day)

    IO.puts('Day' ++ day)
    IO.puts("########\n")

    IO.puts("Solution for the first star:")

    inp
    |> f1.()
    |> IO.inspect()

    IO.puts("\nSolution for the second star:")

    get_input(day)
    |> f2.()
    |> IO.inspect()
  end
end
