defmodule Cards do
  @moduledoc """
  Functions that perform on a deck of cards.
  """
  def create_deck do
    ["2", "3", "4", "5", "6", "7", "8", "9", "K", "Q", "A"]
  end

  def shuffle(deck) do
    Enum.shuffle(deck)
  end

  def contains?(deck, card) do
    Enum.member?(deck, card)
  end
end
