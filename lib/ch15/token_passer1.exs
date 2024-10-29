defmodule TokenPasser1 do
  @moduledoc """
  Determinism of Message Order
  In Theory: The order in which the replies are received is not deterministic.
  The receive block in Elixir will handle messages as they arrive in the process mailbox.
  Since the two processes are spawned concurrently and run independently,
  there is no guarantee of the order in which the messages will arrive.

  In Practice: The order is generally not deterministic either.
  The timing of the messages depends on several factors,
  including how the operating system schedules the processes
  and the speed of the individual processes.
  """

  def start do
    parent = self()

    # Spawn two processes, each will receive a unique token
    spawn(fn -> send(parent, {:token, "fred"}) end)
    spawn(fn -> send(parent, {:token, "betty"}) end)

    # Receive the tokens
    receive_token()
    receive_token()
  end

  defp receive_token do
    receive do
      {:token, token} ->
        IO.puts("Received token: #{token}")
    end
  end
end

TokenPasser1.start()
