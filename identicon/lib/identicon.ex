defmodule Identicon do
  @moduledoc """
  Indenticon will turn a string `input` into an "Identicon" symmetric image
  and save it to your computer as a .png. The resulting Identicon is a 250x250
  pixeled image, and is created with a 5x5 grid.
  https://en.wikipedia.org/wiki/Identicon
  """
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_values
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  @doc """
    Using Image's `pixel_map`, and the `egd` library, draw the content of `pixel_map`s coordinates
    and `color`.
  """
  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)
    Enum.each pixel_map, fn({top_left, bot_right}) ->
      :egd.filledRectangle(image, top_left, bot_right, fill)
    end
    :egd.render(image)
  end

  @doc """
    Given a `grid`, calculate a pixel_map, which contains coordinates we want to fill in.
    ## Examples:
      iex> Identicon.hash_input("yo")
      iex> |> Identicon.build_grid
      iex> |> Identicon.build_pixel_map
      %Identicon.Image{
        hex: [109, 0, 7, 229, 47, 122, 251, 125, 90, 6, 80, 176, 255, 184, 164], 
        color: nil, 
        grid: [
          {109, 0}, {0, 1}, {7, 2}, {0, 3}, {109, 4}, 
          {229, 5}, {47, 6}, {122, 7}, {47, 8}, {229, 9}, 
          {251, 10}, {125, 11}, {90, 12}, {125, 13}, {251, 14}, 
          {6, 15}, {80, 16}, {176, 17}, {80, 18}, {6, 19}, 
          {255, 20}, {184, 21}, {164, 22}, {184, 23}, {255, 24}
        ], 
        pixel_map: [{{0, 0}, {50, 50}}, {{50, 0}, {100, 50}}, {{100, 0}, {150, 50}}, {{150, 0}, {200, 50}}, {{200, 0}, {250, 50}}, {{0, 50}, {50, 100}}, {{50, 50}, {100, 100}}, {{100, 50}, {150, 100}}, {{150, 50}, {200, 100}}, {{200, 50}, {250, 100}}, {{0, 100}, {50, 150}}, {{50, 100}, {100, 150}}, {{100, 100}, {150, 150}}, {{150, 100}, {200, 150}}, {{200, 100}, {250, 150}}, {{0, 150}, {50, 200}}, {{50, 150}, {100, 200}}, {{100, 150}, {150, 200}}, {{150, 150}, {200, 200}}, {{200, 150}, {250, 200}}, {{0, 200}, {50, 250}}, {{50, 200}, {100, 250}}, {{100, 200}, {150, 250}}, {{150, 200}, {200, 250}}, {{200, 200}, {250, 250}}]}
  """
  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map = Enum.map grid, fn({_value, index}) ->
      hori_dist = rem(index, 5) * 50
      vert_dist = div(index, 5) * 50
      top_left_coordinate = {hori_dist, vert_dist}
      bottom_right_coordinate = {hori_dist+50, vert_dist+50}
      {top_left_coordinate, bottom_right_coordinate}
    end
    %Identicon.Image{image | pixel_map: pixel_map}
  end

  @doc """
    Given Image, Use enum.chunk to get every 3 elements by chunks.
    Then we will "mirror" the first 2 elements of those 3 elements, and
    append them to the end. This will result in a 5x5 grid.
  """
  def build_grid(%Identicon.Image{hex: hex_list} = image) do
    grid = 
      hex_list
      |> Enum.chunk_every(3)
      |> Enum.map(&mirror/1)
      |> List.flatten
      |> Enum.with_index
    %Identicon.Image{image | grid: grid}
  end

  @doc """
    For the 25 elements of our grid, pull out all odd values.
  """
  def filter_odd_values(%Identicon.Image{grid: grid} = image) do
    grid = Enum.filter grid, fn {value, _index} ->
      rem(value, 2) == 0
    end
    %Identicon.Image{image | grid: grid}
  end

  @doc """
    Given an `input`, md5 hash it, and return binary as list [16 elements]
  """
  def hash_input(input) do
    hex_list = :crypto.hash(:md5, input)    
    |> :binary.bin_to_list
    |> Enum.reverse() |> tl() |> Enum.reverse()
    %Identicon.Image{hex: hex_list}
  end

  @doc """
    Given a `row`, return a symmetric representation of `row`
    For example, given: [1,2,3], return [1,2,3,2,1]
  """
  def mirror(row) do
    row
    |> IO.inspect
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
          hex: [109, 0, 7, 229, 47, 122, 251, 125, 90, 6, 80, 176, 255, 184, 164]
        }

  """
  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    %Identicon.Image{image | color: {r, g, b}}
  end

  def save_image(image_file, filename) do
    File.write("#{filename}.png", image_file)
  end
end
