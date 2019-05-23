defmodule Identicon do
  @moduledoc """
  Indenticon will turn a string `input` into an "Identicon" symmetric image.
  https://en.wikipedia.org/wiki/Identicon
  """
  def main(input) do
    input
    |> hash_input
  end

  @doc """
    Given an `input`, md5 hash it, and return binary as list
  """
  def hash_input(input) do
    :crypto.hash(:md5, input)    
    |> :binary.bin_to_list
  end
end
