defmodule Identicon do
  @moduledoc """
  Indenticon will turn a string `input` into an "Identicon" symmetric image.
  https://en.wikipedia.org/wiki/Identicon
  """
  def main(input) do
    input
    |> hash_input
    |> pick_color
  end

  @doc """
    Given an `input`, md5 hash it, and return binary as list
  """
  def hash_input(input) do
    hex_list = :crypto.hash(:md5, input)    
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex_list}
  end

  @doc """
    Given an `image`, we will derive RGB values from the first 3 values
    of the `hex_list` value stored under the `hex` key.
    Returns RGB value under `color`, and an image `hex_list`.

    ## Examples:
        iex> image = Identicon.hash_input("yo")
        iex> Identicon.pick_color(image)
        %Identicon.Image{
          color: {109, 0, 7},
          hex: [109, 0, 7, 229, 47, 122, 251, 125, 90, 6, 80, 176, 255, 184, 164, 209]
        }

  """
  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    %Identicon.Image{image | color: {r, g, b}}
  end
end
