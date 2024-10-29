defprotocol Caesar do
  @doc "Encrypts a string with a given shift."
  def encrypt(data, shift)

  @doc "Applies the ROT13 cipher to a string."
  def rot13(data)
end

defimpl Caesar, for: BitString do
  def encrypt(<<char, rest::binary>>, shift) when char in ?a..?z do
    <<(rem(char - ?a + shift, 26) + ?a)::utf8>> <> encrypt(rest, shift)
  end

  def encrypt(<<char, rest::binary>>, shift) when char in ?A..?Z do
    <<(rem(char - ?A + shift, 26) + ?A)::utf8>> <> encrypt(rest, shift)
  end

  def encrypt(<<char, rest::binary>>, shift) do
    <<char>> <> encrypt(rest, shift)
  end

  def encrypt(<<>>, _shift), do: ""

  def rot13(string), do: encrypt(string, 13)
end

defimpl Caesar, for: List do
  def encrypt(list, shift) do
    list |> Enum.map(&shift_char(&1, shift))
  end

  def rot13(list), do: encrypt(list, 13)

  defp shift_char(char, shift) when char in ?a..?z do
    rem(char - ?a + shift, 26) + ?a
  end

  defp shift_char(char, shift) when char in ?A..?Z do
    rem(char - ?A + shift, 26) + ?A
  end

  defp shift_char(char, _shift), do: char
end

# Testing with binaries (strings)
IO.puts(Caesar.encrypt("Hello World", 3)) # "Khoor Zruog"
IO.puts(Caesar.rot13("Hello World"))      # "Uryyb Jbeyq"

# Testing with lists
IO.inspect(Caesar.encrypt(~c"hello world", 3)) # ~c"khoor zruog"
IO.inspect(Caesar.rot13(~c"hello world"))      # ~"uryyb jbeyq"
