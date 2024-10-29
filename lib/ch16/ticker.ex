defmodule Ticker do
  @interval 2000   # 2 seconds
  @name     :ticker

  def start do
    pid = spawn(__MODULE__, :generator, [[], 0])
    :global.register_name(@name, pid)
  end

  def register(client_pid) do
    send :global.whereis_name(@name), { :register, client_pid }
  end

  def generator(clients, current_index) do
    receive do
      { :register, pid } ->
        IO.puts "registering #{inspect pid}"
        generator([pid | clients], current_index)
    after
      @interval ->
        case clients do
          [] ->
            IO.puts "No clients to send ticks to."
            generator(clients, current_index)
          _ ->
            client = Enum.at(clients, rem(current_index, length(clients)))
            IO.puts "tick to client #{inspect client}"
            send(client, { :tick })
            generator(clients, current_index + 1)
        end
    end
  end
end

defmodule Client do
  def start do
    pid = spawn(__MODULE__, :receiver, [])
    Ticker.register(pid)
  end

  def receiver do
    receive do
      { :tick } ->
        IO.puts "tock in client"
        receiver()
    end
  end
end
