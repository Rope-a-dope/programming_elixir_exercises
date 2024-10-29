# This version is more efficient, as it picks successive head values 
# from a list, adding them to `result`. It is also tail recursive. 
# The trick is that we have to unnest the head if the head itself is a 
# list. 
defmodule FlattenListDave do
  def flatten(list), do: _flatten(list, [])

  defp _flatten([], result), do: Enum.reverse(result)

  # The following two function heads deal with the head 
  # being a list 
  defp _flatten([[h | []] | tail], result) do
    _flatten([h | tail], result)
  end

  defp _flatten([[h | t] | tail], result) do
    _flatten([h, t | tail], result)
  end

  # Otherwise the head is not, and we can collect it 
  defp _flatten([head | tail], result) do
    _flatten(tail, [head | result])
  end
end
