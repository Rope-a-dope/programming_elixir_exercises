defmodule Stack.Impl do

  def push(stack, value), do: [value | stack]

  def pop([]), do: {:error, "Cannot pop from an empty stack"}
  def pop([head | tail]), do: {head, tail}

end
