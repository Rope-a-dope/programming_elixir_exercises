defmodule FlattenListJose do
  def flatten(list), do: do_flatten(list, [])

  def do_flatten([h | t], tail) when is_list(h) do
    do_flatten(h, do_flatten(t, tail))
  end

  def do_flatten([h | t], tail) do
    [h | do_flatten(t, tail)]
  end

  def do_flatten([], tail), do: tail
end
