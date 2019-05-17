defmodule Cards do
  @moduledoc """
  Functions that perform on a deck of cards.
  """
  def create_deck do
    values = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]
    suits = ["Spade", "Club", "Diamond", "Heart"]

    # Worse approach (solution 1):
    # cards = for val <- values do
    #   for suit <- suits do
    #     "#{val} of #{suit}"
    #   end
    # end
    # List.flatten(cards)

    # Better approach, (solution 2):
    for suit <- suits, val <- values do
      "#{val} of #{suit}"
    end
    
  end

  def shuffle(deck) do
    Enum.shuffle(deck)
  end

  def contains?(deck, card) do
    Enum.member?(deck, card)
  end
end
