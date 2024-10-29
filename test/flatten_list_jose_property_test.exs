defmodule FlattenListJosePropertyTest do
  use ExUnit.Case
  use ExUnitProperties

  property("flattened list contains no nested lists") do
    check all(list <- list_of(term())) do
      assert FlattenListJose.flatten(list) == List.flatten(list)
    end
  end
end
