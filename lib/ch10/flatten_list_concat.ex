# The simplest version is probably to use list concatenation. However, 
# this version ends up rebuilding the list at each step 
defmodule UsingConcat do
  def flatten([]), do: []
  def flatten([head | tail]), do: flatten(head) ++ flatten(tail)
  def flatten(head), do: [head]
end
