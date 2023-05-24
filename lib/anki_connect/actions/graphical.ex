defmodule AnkiConnect.Actions.Graphical do
  @moduledoc """
  Graphical actions.

  All functions are delegated inside `AnkiConnect` module, so you should import them from there.
  """

  import AnkiConnect.Client

  @doc """
  Invokes the *Card Browser* dialog and searches for a given query. Returns an array of identifiers of the cards that were found.

  Query syntax is [documented here](https://docs.ankiweb.net/searching.html).

  ### Sample result:
  ```
  {:ok, [1494723142483, 1494703460437, 1494703479525]}
  ```
  """
  @spec gui_browse(%{query: String.t()}) :: {:ok, [integer()]} | {:error, any()}
  def gui_browse(%{query: query}) do
    api("guiBrowse", %{query: query})
  end

  @doc """
  Finds the open instance of the *Card Browser* dialog and returns an array of identifiers of the notes that are selected.

  Returns an empty list if the browser is not open.

  ### Sample result:
  ```
  {:ok, [1494723142483, 1494703460437, 1494703479525]}
  ```
  """
  @spec gui_selected_notes() :: {:ok, [integer()]} | {:error, any()}
  def gui_selected_notes do
    api("guiSelectedNotes")
  end

  @doc """
  Invokes the *Add Cards* dialog, presets the note using the given deck and model, with the provided field values and tags.

  Invoking it multiple times closes the old window and *reopen the window* with the new provided values.

  Audio, video, and picture files can be embedded into the fields via the `audio`, `video`, and `picture` keys, respectively. Refer to the documentation of `add_note` and `store_media_file` for an explanation of these fields.

  The result is the ID of the note which would be added, if the user chose to confirm the *Add Cards* dialogue.

  ### Sample param:
  ```
  %{
    note: %{
      deck_name: "Default",
      model_name: "Cloze",
      fields: %{
        Text: "The capital of Romania is {{c1::Bucharest}}",
        Extra: "Romania is a country in Europe"
      },
      tags: ["countries"],
      picture: [%{
        url: "https://upload.wikimedia.org/wikipedia/commons/thumb/1/13/EU-Romania.svg/285px-EU-Romania.svg.png",
        filename: "romania.png",
        fields: ["Extra"]
      }]
    }
  }
  ```

  ### Sample result:
  ```
  {:ok, 1496198395707}
  ```
  """
  @spec gui_add_cards(%{note: map()}) :: {:ok, [integer()]} | {:error, any()}
  def gui_add_cards(%{note: note}) do
    api("guiAddCards", %{note: note})
  end

  @doc """
  Opens the *Edit* dialog with a note corresponding to given note ID.

  The dialog is similar to the *Edit Current* dialog, but:
  - has a Preview button to preview the cards for the note
  - has a Browse button to open the browser with these cards
  - has Previous/Back buttons to navigate the history of the dialog
  - has no bar with the Close button
  """
  @spec gui_edit_note(%{note: map()}) :: {:ok, nil} | {:error, any()}
  def gui_edit_note(%{note: note}) do
    api("guiEditNote", %{note: note})
  end

  @doc """
  Returns information about the current card or error if not in review mode.

  ### Sample result:
  ```
  {:ok, %{
    "answer" => "back content",
    "question" => "front content",
    "deckName" => "Default",
    "modelName" => "Basic",
    "fieldOrder" => 0,
    "fields" => %{
      "Front" => %{"value" => "front content", "order" => 0},
      "Back" => %{"value" => "back content", "order" => 1}
    },
    "template" => "Forward",
    "cardId" => 1498938915662,
    "buttons" => [1, 2, 3],
    "nextReviews" => ["<1m", "<10m", "4d"]
  }}
  ```
  """
  @spec gui_current_card() :: {:ok, map()} | {:error, any()}
  def gui_current_card do
    case api("guiCurrentCard") do
      {:ok, nil} -> {:error, "Not in review mode"}
      {:ok, result} -> {:ok, result}
    end
  end

  @doc """
  Starts or resets the timerStarted value for the current card.

  This is useful for deferring the start time to when it is displayed via the API, allowing the recorded time taken to answer the card to be more accurate when calling guiAnswerCard.
  """
  @spec gui_start_card_timer() :: {:ok, nil} | {:error, any()}
  def gui_start_card_timer do
    api("guiStartCardTimer")
  end

  @doc """
  Shows question text for the current card. Returns error if not in review mode.
  """
  @spec gui_show_question() :: {:ok, nil} | {:error, any()}
  def gui_show_question do
    case api("guiShowQuestion") do
      {:ok, true} -> {:ok, nil}
      {:ok, false} -> {:error, "Not in review mode"}
    end
  end

  @doc """
  Shows answer text for the current card. Returns error if not in review mode.
  """
  @spec gui_show_answer() :: {:ok, nil} | {:error, any()}
  def gui_show_answer do
    case api("guiShowAnswer") do
      {:ok, true} -> {:ok, nil}
      {:ok, false} -> {:error, "Not in review mode"}
    end
  end

  @doc """
  Answers the current card.

  Note that the answer for the current card must be displayed before before any answer can be accepted by Anki.
  """
  @spec gui_answer_card(%{ease: integer()}) :: {:ok, nil} | {:error, any()}
  def gui_answer_card(%{ease: ease}) do
    case api("guiAnswerCard", %{ease: ease}) do
      {:ok, true} -> {:ok, nil}
      {:ok, false} -> {:error, "Failed answering the current card"}
    end
  end

  @doc """
  Opens the *Deck Overview* dialog for the deck with the given name.

  Returns error if failed.
  """
  @spec gui_deck_overview(%{name: String.t()}) :: {:ok, nil} | {:error, any()}
  def gui_deck_overview(%{name: name}) do
    case api("guiDeckOverview", %{name: name}) do
      {:ok, true} -> {:ok, nil}
      {:ok, false} -> {:error, "Failed opening the deck overview"}
    end
  end

  @doc """
  Opens the *Deck Browser* dialog.
  """
  @spec gui_deck_browser() :: {:ok, nil} | {:error, any()}
  def gui_deck_browser do
    api("guiDeckBrowser")
  end

  @doc """
  Starts review for the deck with the given name. Returns error if failed.
  """
  @spec gui_deck_review(%{name: String.t()}) :: {:ok, nil} | {:error, any()}
  def gui_deck_review(%{name: name}) do
    case api("guiDeckReview", %{name: name}) do
      {:ok, true} -> {:ok, nil}
      {:ok, false} -> {:error, "Failed opening the deck review"}
    end
  end

  @doc """
  Schedules a request to gracefully close Anki.

  This operation is asynchronous, so it will return immediately and won’t wait until the Anki process actually terminates.
  """
  @spec gui_exit_anki() :: {:ok, nil} | {:error, any()}
  def gui_exit_anki do
    api("guiExitAnki")
  end

  @doc """
  Requests a database check.

  It returns immediately without waiting for the check to complete. Therefore, the action will always return `{:ok, nil}` even if errors are detected during the database check.
  """
  @spec gui_check_database() :: {:ok, nil} | {:error, any()}
  def gui_check_database do
    api("guiCheckDatabase")
  end
end
