defmodule Calculate do
  def calculate(expression) do
    {n1, rest} = parse_number(expression)
    rest = skip_spaces(rest)
    {op, rest} = parse_operator(rest)
    rest = skip_spaces(rest)
    {n2, []} = parse_number(rest)
    op.(n1, n2)
  end

  defp parse_number(expression), do: _parse_number({0, expression})

  defp _parse_number({value, [digit | rest]}) when digit in ?0..?9 do
    _parse_number({value * 10 + digit - ?0, rest})
  end

  defp _parse_number(result), do: result

  defp skip_spaces([?\s  | rest]), do: skip_spaces(rest)

  defp skip_spaces(rest), do: rest

  defp parse_operator([?+ | rest]), do: {&{&1 + &2}, rest}

  defp parse_operator([?- | rest]), do: {&(&1 - &2), rest}

  defp parse_operator([?* | rest]), do: {&(&1 * &2), rest}

  defp parse_operator([?/ | rest]), do: {&div(&1, &2), rest}
end
