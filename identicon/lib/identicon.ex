defmodule Identicon do
  @moduledoc """
  Indenticon will turn a string `input` into an "Identicon" symmetric image.
  https://en.wikipedia.org/wiki/Identicon
  """
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
  end

  @doc """
    Given Image, Use enum.chunk to get every 3 elements by chunks.
    Then we will "mirror" the first 2 elements of those 3 elements, and
    append them to the end. This will result in a 5x5 grid.
  """
  def build_grid(%Identicon.Image{hex: hex_list}) do
    hex_list
    |> Enum.chunk(3)
    |> Enum.map(&mirror/1)
  end

  @doc """
    Given an `input`, md5 hash it, and return binary as list [16 elements]
  """
  def hash_input(input) do
    hex_list = :crypto.hash(:md5, input)    
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex_list}
  end

  @doc """
    Given a `row`, return a symmetric representation of `row`
    For example, given: [1,2,3], return [1,2,3,2,1]
  """
  def mirror(row) do
    [first, second | _tail] = row
    row ++ [second, first]
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
