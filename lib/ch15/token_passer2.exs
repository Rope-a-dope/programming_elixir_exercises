defmodule TokenPasser2 do
  @moduledoc """
  Making the Order Deterministic
  To make the order deterministic, introduce some mechanism to control the order of the messages,
  such as:

  Sequential Spawning: Ensure that the second process is spawned
  only after the first one has completed its task and sent its message.

  Explicit Order Handling: Explicitly wait for a particular message
  before spawning the next process. Here’s how to modify the program to do that:
  """
  def start do
    parent = self()

    # Spawn the first process and wait for its message
    spawn(fn -> send(parent, {:token, "fred"}) end)
    receive_token("fred")

    # Spawn the second process and wait for its message
    spawn(fn -> send(parent, {:token, "betty"}) end)
    receive_token("betty")
  end

  defp receive_token(expected_token) do
    receive do
      {:token, token} when token == expected_token ->
        IO.puts("Received token: #{token}")
    end
  end
end

TokenPasser2.start()
