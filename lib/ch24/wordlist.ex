defmodule WordList do
  def load_words(file) do
    File.stream!(file)
    |> Stream.map(&extract_word/1)
    |> Enum.into(MapSet.new())  # Use a Set for faster lookups
  end

  defp extract_word(word_with_suffix) do
    word_with_suffix
    |> String.trim()
    |> String.split("/")  # Split on '/'
    |> List.first()       # Take the first part (the actual word)
  end
end


defmodule ROT13Words do
  alias Ceasar
  def find_pairs(word_list) do
    word_list
    |> Enum.filter(&MapSet.member?(word_list, Caesar.rot13(&1)))
  end
end

# Main program
defmodule Main do
  def run do
    rot13_pairs = "en_US.dic" |> WordList.load_words() |> ROT13Words.find_pairs()

    IO.inspect(rot13_pairs, label: "Words where ROT13(word) is also a word")
  end
end

Main.run()
