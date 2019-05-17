defmodule Cards do
  @moduledoc """
  Documentation for Cards.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Cards.hello()
      :world

  """
  def create_deck do
    ["2", "3", "4", "5", "6", "7", "8", "9", "K", "Q", "A"]
  end

  def shuffle(deck) do
    Enum.shuffle(deck)
  end
end
