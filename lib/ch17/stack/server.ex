defmodule Stack.Server do
  use GenServer
  alias Stack.Impl

  def init(initial_stack) do
    { :ok, initial_stack }
  end

  def handle_call(:pop, _from, stack) do
    case Impl.pop(stack) do
      {:error, _reason} = error ->
        {:reply, error, stack}  # Return the error without modifying the stack

      {head, tail} ->
        {:reply, head, tail}  # Return the head and the new stack
    end
  end

  def handle_cast({:push, value}, _stack) when is_number(value) and value < 10 do
      System.halt(1)  # Terminate with a non-zero exit code if the value is less than 10
  end

  def handle_cast({:push, value}, stack) do
    {:noreply, [value | stack]}
  end

  def terminate(reason, state) do
    IO.puts("Terminating stack server.")
    IO.puts("Reason: #{inspect(reason)}")
    IO.puts("Final state: #{inspect(state)}")
  end
end
