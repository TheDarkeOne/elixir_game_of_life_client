defmodule Game do
  def run(starting_board, 0, _memory_pid) do
    starting_board
  end

  def run(starting_board, num_generations, memory_pid) do
    IO.puts("sending :progress #{num_generations} to memory_pid #{inspect memory_pid}")
    send(memory_pid, {:progress, num_generations})
    starting_board
    |> Board.advance()
    |> run(num_generations - 1, memory_pid)
  end
end
