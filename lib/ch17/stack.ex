defmodule StackServer do
  @server Stack.Server
  # Client API

  @doc """
  Starts the stack server with the given initial stack.
  """
  def start_link(initial_stack) do
    GenServer.start_link(@server, initial_stack, name: @server)
  end

  @doc """
  Pops the top element from the stack.
  """
  def pop do
    GenServer.call(@server, :pop)
  end

  @doc """
  Pushes a new element onto the top of the stack.
  """
  def push(value) do
    GenServer.cast(@server, {:push, value})
  end

end
