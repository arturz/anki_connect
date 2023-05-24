defmodule AnkiConnect.Actions.DeckTest do
  use AnkiConnect.Case

  describe "create_deck/1, delete_decks/1 and deck_names/1" do
    test "user is able to create and delete deck" do
      deck_params = get_deck_params()

      create_deck(deck_params)

      assert {:ok, decks} = deck_names()

      assert deck_params.deck in decks

      delete_decks(%{
        decks: [deck_params.deck]
      })

      assert {:ok, decks} = deck_names()

      refute deck_params.deck in decks
    end
  end
end
