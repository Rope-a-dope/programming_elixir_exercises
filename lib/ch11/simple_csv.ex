defmodule SimpleCSV do
  def read(filename) do
    file = filename |> File.open!()
    headers = file |> IO.read(:line) |> read_headers()

    result =
      file
      |> IO.stream(:line)
      |> Enum.map(&create_one_row(headers, &1))

    File.close(file)
    result
  end

  defp read_headers(hdr_line) do
    hdr_line |> from_csv_and_map(&String.to_atom(&1))
  end

  defp create_one_row(headers, row_csv) do
    row = row_csv |> from_csv_and_map(&maybe_convert_numbers(&1))
    Enum.zip(headers, row)
  end

  defp from_csv_and_map(row_csv, mapper) do
    row_csv
    |> String.trim()
    |> String.split(~r{,\s*})
    |> Enum.map(mapper)
  end

  defp maybe_convert_numbers(value) do
    cond do
      Regex.match?(~r{^\d+$}, value) -> String.to_integer(value)
      Regex.match?(~r{^\d+\.\d+$}, value) -> String.to_float(value)
      <<?:::utf8, name::binary>> = value -> String.to_atom(name)
      true -> value
    end
  end
end
