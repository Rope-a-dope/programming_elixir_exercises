defmodule ProgrammingElixirExercisesTest do
  use ExUnit.Case
  doctest ProgrammingElixirExercises

  test "greets the world" do
    assert ProgrammingElixirExercises.hello() == :world
  end
end
