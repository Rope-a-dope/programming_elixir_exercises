defmodule SpawnLink1 do
  @moduledoc """
  Does It Matter That You Weren’t Waiting for the Notification?
  No, it doesn’t matter: The parent process doesn’t need to be waiting for the notification
  at the exact time the child process exits. In Elixir, messages sent to a process are stored
  in its mailbox until they are explicitly received. The message sent by the child process remains
  in the parent’s mailbox until the parent wakes up and processes it.

  Handling Exit Signals: If the child process had crashed (exited abnormally), the parent process
  would receive an {:EXIT, pid, reason} message because of the spawn_link/1. Since the child exited
  normally in this example (exit(:normal)), there is no EXIT message sent to the parent in this case.

  What Happens in Other Scenarios?
  If the child exits abnormally (e.g., exit(:some_reason)): The parent will receive an
  {:EXIT, pid, :some_reason} message due to the link, unless it’s trapping exits.
  """
  def start do
    parent = self()

    # Spawn a linked process
    spawn_link(fn ->
      send(parent, {:message, "Hello from the child process"})
      exit(:normal)
      #exit(:abnormal) # abnormal exit
    end)

    # Sleep for 500 milliseconds
    :timer.sleep(500)

    # Receive and trace any messages
    receive_messages()
  end

  defp receive_messages do
    receive do
      message ->
        IO.puts("Received: #{inspect(message)}")
        receive_messages()
    after
      1000 -> IO.puts("No more messages.")
    end
  end
end

SpawnLink.start()
