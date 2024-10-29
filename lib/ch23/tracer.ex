defmodule Tracer do
  import IO.ANSI

  defmacro def(definition, do: content) do
    quote do
      # Print the function being defined in green text on a white background
      IO.puts IO.ANSI.format([:green_background, :white, " Defining: #{unquote(Macro.to_string(definition))}", :reset])

      Kernel.def(unquote(definition)) do
        unquote(content)
      end
    end
  end

  # New clause to handle guards
  defmacro def(definition, guards: guards, do: content) do
    quote do
      # Print the function being defined in green text on a white background
      IO.puts [unquote(definition), white(), green_background(), " Defining with guards: ", unquote(definition), reset()]

      Kernel.def(unquote(definition), guards: unquote(guards)) do
        unquote(content)
      end
    end
  end
end

defmodule Test do
  import Kernel, except: [def: 2]
  import Tracer, only: [def: 2]

  def puts_sum_three(a, b, c), do: IO.inspect(a + b + c)

  # Use the modified def to include guards
  def add_list(list) when is_list(list), do: Enum.reduce(list, 0, &(&1 + &2))

  def test_guard(a) when a > 0, do: IO.puts("Positive: #{a}")
end

Test.add_list([1, 2, 3])
Test.test_guard(-1)
