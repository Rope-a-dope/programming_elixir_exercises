defmodule Explain do
  defmacro explain(do: expr) do
    parse_expression(expr)
  end

  # Parse the expression based on operator precedence
  defp parse_expression({operator, _, [lhs, rhs]}) when operator in [:+, :-] do
    lhs_expr = parse_expression(lhs)
    rhs_expr = parse_expression(rhs)
    op_description = operator_description(operator)

    quote do
      IO.puts "#{unquote(lhs_expr)} #{unquote(op_description)} #{unquote(rhs_expr)}"
    end
  end

  defp parse_expression({operator, _, [lhs, rhs]}) when operator in [:*, :/] do
    lhs_expr = parse_expression(lhs)
    rhs_expr = parse_expression(rhs)
    op_description = operator_description(operator)

    quote do
      IO.puts "#{unquote(lhs_expr)} #{unquote(op_description)} #{unquote(rhs_expr)}"
    end
  end

  # Base case: return numbers or variables as-is
  defp parse_expression(value) when is_number(value), do: value

  # Helper function to get the operator description
  defp operator_description(operator) do
    case operator do
      :+ -> "add"
      :- -> "subtract"
      :* -> "multiply"
      :/ -> "divide"
    end
  end
end
