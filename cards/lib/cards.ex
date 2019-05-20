defmodule Cards do
  @moduledoc """
    Functions that perform on a deck of cards.
  """

  @doc """
    Returns a list of 52 Playing Cards.
  """
  def create_deck do
    values = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]
    suits = ["Spade", "Club", "Diamond", "Heart"]

    for suit <- suits, val <- values do
      "#{val} of #{suit}"
    end    
  end


  @doc """
    Given a desired handsize, Returns a tuple. A list of cards in hand (via `hand_size`), and remaining cards in the deck.
  """
  def create_hand(hand_size) do
    Cards.create_deck 
    |> Cards.shuffle
    |> Cards.deal(hand_size)
  end

  @doc """
    Returns a bool, if a card is in a deck.
  """
  def contains?(deck, card) do
    Enum.member?(deck, card)
  end

  def deal(deck, hand_size) do
    Enum.split(deck, hand_size)
  end

  def load(filename) do
    case File.read(filename) do
      {:error, _} -> "File does not exist."
      {:ok, binary} -> :erlang.binary_to_term(binary)
    end
  end

  def save(deck, filename) do
    binary = :erlang.term_to_binary(deck)
    File.write(filename, binary)
  end

  def shuffle(deck) do
    Enum.shuffle(deck)
  end
end
