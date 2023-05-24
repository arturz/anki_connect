defmodule AnkiConnect.Actions.Deck do
  @moduledoc """
  Deck actions.

  All functions are delegated inside `AnkiConnect` module, so you should import them from there.
  """

  import AnkiConnect.Client

  @doc """
  Gets the complete list of deck names for the current user.

  ### Sample result:
  ```
  {:ok, ["Default"]}
  ```
  """
  @spec deck_names() :: {:ok, [String.t()]} | {:error, any()}
  def deck_names do
    api("deckNames")
  end

  @doc """
  Gets the complete list of deck names and their respective IDs for the current user.

  ### Sample result:
  ```
  {:ok, %{"Default" => 1}}
  ```
  """
  @spec deck_names_and_ids() :: {:ok, map()} | {:error, any()}
  def deck_names_and_ids do
    api("deckNamesAndIds")
  end

  @doc """
  Accepts an array of card IDs and returns an object with each deck name as a key, and its value an array of the given cards which belong to it.

  ### Sample param:
  ```
  %{
    cards: [1502298036657, 1502298033753, 1502032366472]
  }
  ```

  ### Sample result:
  ```
  {:ok, %{
    "Default" => [1502032366472],
    "Japanese::JLPT N3" => [1502298036657, 1502298033753]
  }}
  ```
  """
  @spec get_decks(%{cards: [integer()]}) :: {:ok, map()} | {:error, any()}
  def get_decks(%{cards: cards}) do
    api("getDecks", %{cards: cards})
  end

  @doc """
  Creates a new empty deck. Will not overwrite a deck that exists with the same name.

  ### Sample param:
  ```
  %{
    deck: "Japanese::Tokyo"
  }
  ```

  ### Sample result:
  ```
  {:ok, nil}
  ```
  """
  @spec create_deck(%{deck: String.t()}) :: {:ok, nil} | {:error, any()}
  def create_deck(%{deck: deck}) do
    api("createDeck", %{deck: deck})
  end

  @doc """
  Moves cards with the given IDs to a different deck, creating the deck if it doesn’t exist yet.

  ### Sample param:
  ```
  %{
    cards: [1502098034045, 1502098034048, 1502298033753],
    deck: "Japanese::JLPT N3"
  }
  ```

  ### Sample result:
  ```
  {:ok, nil}
  ```
  """
  @spec change_deck(%{cards: [integer()], deck: String.t()}) :: {:ok, nil} | {:error, any()}
  def change_deck(%{cards: cards, deck: deck}) do
    api("createDeck", %{cards: cards, deck: deck})
  end

  @doc """
  Deletes decks with the given names.

  Warning: this will not only delete the decks, but also all the cards contained in those decks.

  ### Sample param:
  ```
  %{
    decks: ["Japanese::JLPT N5", "Easy Spanish"],
  }
  ```

  ### Sample result:
  ```
  {:ok, nil}
  ```
  """
  @spec delete_decks(%{decks: [String.t()]}) :: {:ok, nil} | {:error, any()}
  def delete_decks(%{decks: decks}) do
    api("deleteDecks", %{decks: decks, cards_too: true})
  end

  @doc """
  Gets the configuration group object for the given deck.

  ### Sample param:
  ```
  %{
    deck: "Default"
  }
  ```

  ### Sample result:
  ```
  {:ok, %{
    "lapse" => %{
      "leechFails" => 8,
      "delays" => [10],
      "minInt" => 1,
      "leechAction" => 0,
      "mult" => 0
    },
    "dyn" => false,
    "autoplay" => true,
    "mod" => 1502970872,
    "id" => 1,
    "maxTaken" => 60,
    "new" => %{
      "bury" => true,
      "order" => 1,
      "initialFactor" => 2500,
      "perDay" => 20,
      "delays" => [1, 10],
      "separate" => true,
      "ints" => [1, 4, 7]
    },
    "name" => "Default",
    "rev" => %{
      "bury" => true,
      "ivlFct" => 1,
      "ease4" => 1.3,
      "maxIvl" => 36500,
      "perDay" => 100,
      "minSpace" => 1,
      "fuzz" => 0.05
    },
    "timer" => 0,
    "replayq" => true,
    "usn" => -1
  }}
  ```
  """
  @spec get_deck_config(%{deck: String.t()}) :: {:ok, map()} | {:error, any()}
  def get_deck_config(%{deck: deck}) do
    api("getDeckConfig", %{deck: deck})
  end

  @doc """
  Saves the given configuration group.

  ### Sample param:
  ```
  %{
    config: %{
      dyn: false,
      id: 1,
      autoplay: true,
      lapse: %{
        delays: [10],
        leech_action: 0,
        leech_fails: 8,
        minInt: 1,
        mult: 0
      },
      max_taken: 60,
      mod: 1502970872,
      name: "Default",
      new: %{
        bury: true,
        delays: [1, 10],
        initial_factor: 2500,
        ints: [1, 4, 7],
        order: 1,
        per_day: 20,
        separate: true
      },
      rev: %{
        bury: true,
        ease4: 1.3,
        fuzz: 0.05,
        ivlFct: 1,
        max_ivl: 36500,
        min_space: 1,
        per_day: 100
      },
      replayq: true,
      timer: 0,
      usn: -1
    }
  }
  ```

  ### Sample result:
  ```
  {:ok, nil}
  ```
  """
  @spec save_deck_config(%{config: map()}) :: {:ok, nil} | {:error, any()}
  def save_deck_config(deck_config) do
    case api("saveDeckConfig", deck_config) do
      {:ok, true} -> {:ok, nil}
      {:ok, false} -> {:error, "Invalid configuration group ID"}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Changes the configuration group for the given decks to the one with the given ID.

  ### Sample param:
  ```
  %{
    decks: ["Default"],
    config_id: 1
  }
  ```

  ### Sample result:
  ```
  {:ok, nil}
  ```
  """
  @spec set_deck_config_id(%{decks: [String.t()], config_id: integer()}) ::
          {:ok, nil} | {:error, any()}
  def set_deck_config_id(%{decks: decks, config_id: config_id}) do
    case api("setDeckConfigId", %{decks: decks, config_id: config_id}) do
      {:ok, true} -> {:ok, nil}
      {:ok, false} -> {:error, "Given configuration group or any of the given decks do not exist"}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Creates a new configuration group with the given name.

  Clones from the group with the given ID, or from the default group if this is unspecified. Returns the ID of the new configuration group.

  ### Sample param:
  ```
  %{
    name: "Copy of Default",
    clone_from: 1
  }
  ```

  ### Sample result:
  ```
  {:ok, 1502972374573}
  ```
  """
  @spec clone_deck_config_id(%{name: String.t(), clone_from: integer()}) ::
          {:ok, integer()} | {:error, any()}
  def clone_deck_config_id(%{name: name, clone_from: clone_from}) do
    case api("cloneDeckConfigId", %{name: name, clone_from: clone_from}) do
      {:ok, false} -> {:error, "The specified group to clone from does not exist"}
      {:ok, config_id} -> {:ok, config_id}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Removes the configuration group with the given ID.

  ### Sample param:
  ```
  %{
    config_id: 1502972374573
  }
  ```

  ### Sample result:
  ```
  {:ok, nil}
  ```
  """
  @spec remove_deck_config_id(%{config_id: integer()}) :: {:ok, nil} | {:error, any()}
  def remove_deck_config_id(%{config_id: config_id}) do
    case api("removeDeckConfigId", %{config_id: config_id}) do
      {:ok, true} ->
        {:ok, nil}

      {:ok, false} ->
        {:error,
         "Attempting to remove either the default configuration group (ID = 1) or a configuration group that does not exist"}

      {:error, error} ->
        {:error, error}
    end
  end

  @doc """
  Gets statistics such as total cards and cards due for the given decks.

  ### Sample param:
  ```
  %{
    decks: ["Japanese::JLPT N5", "Easy Spanish"]
  }
  ```

  ### Sample result:
  ```
  {:ok, %{
    "1651445861967" => %{
      "deck_id" => 1651445861967,
      "name" => "Japanese::JLPT N5",
      "new_count" => 20,
      "learn_count" => 0,
      "review_count" => 0,
      "total_in_deck" => 1506
    },
    "1651445861960" => %{
        "deck_id" => 1651445861960,
        "name" => "Easy Spanish",
        "new_count" => 26,
        "learn_count" => 10,
        "review_count" => 5,
        "total_in_deck" => 852
    }
  }}
  ```
  """
  @spec get_deck_stats(%{decks: [String.t()]}) :: {:ok, map()} | {:error, any()}
  def get_deck_stats(%{decks: decks}) do
    api("getDeckStats", %{decks: decks})
  end
end
