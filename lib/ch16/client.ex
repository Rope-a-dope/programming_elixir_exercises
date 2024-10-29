defmodule Client1 do
  @interval 2000

  def start_link(next_pid) do
    spawn(__MODULE__, :receiver, [next_pid])
  end

  def receiver(next_pid) do
    receive do
      {:tick} ->
        IO.puts("Tick received by #{inspect(self())}")
        Process.sleep(@interval)
        send(next_pid, {:tick})
        receiver(next_pid)

      {:update_next, new_next_pid} ->
        IO.puts("Updating next client for #{inspect(self())} to #{inspect(new_next_pid)}")
        receiver(new_next_pid)
    end
  end
end

defmodule Ticker1 do
  def start do
    first_client = Client1.start_link(self())  # Self links back for now
    send(first_client, {:tick})
    first_client
  end

  def add_client(existing_client) do
    new_client = Client1.start_link(existing_client)
    send(existing_client, {:update_next, new_client})
    new_client
  end
end
