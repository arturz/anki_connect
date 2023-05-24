defmodule Mix.Tasks.AnkiConnect do
  @moduledoc false

  @doc """
  Provides functionality to interact via a command-line interface (CLI) with AnkiConnect, a plugin for the Anki flashcard application.

  To use the AnkiConnect task, run the following command in your terminal:

  ```bash
  mix anki_connect <action> [params]
  ```

  where `<action>` is the action you want to perform and `[params]` are optional parameters required by the action.

  If a function expects a map with some keys, those keys should be written as parameters in the command line (preceded with `--` and with `_` replaced with `-`).

  For example:
  ```bash
  > mix anki_connect deck_names
  ["Current", "Current::English", "Default"]
  ```

  ```bash
  > mix anki_connect create_deck --deck='TEST DECK'
  1684945081956
  ```

  ```bash
  > mix anki_connect delete_decks --decks='["TEST DECK"]'
  Done.
  ```

  Let's assume that note with ID `1684946786121` has been already created.

  ```bash
  > mix anki_connect add_tags --notes='[1684946786121]' --tags='some tag'
  Done.
  ```

  ```bash
  > mix anki_connect add_tags --notes='[1684946786121]' --tags='other tag'
  Done.
  ```

  ```bash
  > mix anki_connect get_note_tags --note='1684946786121'
  ["other tag", "some tag"]
  ```

  ## Passing nested structures as parameters

  Maps and lists in the command line should be written as JSON encoded strings with keys in snake_case styling.
  For example, to add a note to a deck, you should run the following command:

  ```bash
  > mix anki_connect add_note --note='{"deck_name": "TEST DECK", "model_name": "Basic", "fields": {"Front": "front content", "Back": "back content"}}'
  1684946786121
  ```

  which is an equivalent to the following Elixir code:

  ```elixir
  AnkiConnect.add_note(%{
    note: %{
      deck_name: "TEST DECK",
      model_name: "Basic",
      fields: %{
        Front: "front content",
        Back: "back content"
      }
    }
  })
  ```

  Full list of available actions can be found in the [AnkiConnect module documentation](https://hexdocs.pm/anki_connect/AnkiConnect.html).
  """

  use Mix.Task

  alias AnkiConnect.Utils.MapUtils

  @shortdoc "Provides functionality to interact with AnkiConnect, a plugin for the Anki flashcard application."

  @impl Mix.Task
  @spec run(any()) :: no_return()
  def run([]) do
    IO.puts(@doc)
  end

  def run(["help"]), do: run([])

  def run(args) do
    Application.ensure_all_started(:anki_connect)

    {parsed, args, _invalid} =
      OptionParser.parse(args, switches: [], allow_nonexistent_atoms: true)

    [action | _] = args

    action = String.to_atom(action)

    available_actions = AnkiConnect.__info__(:functions)

    if Keyword.has_key?(available_actions, action) do
      params = get_params(parsed)

      if length(params) != available_actions[action] do
        IO.puts("""
        Action "#{action}" expects #{available_actions[action]} params.
        """)
      else
        run_action(action, params)
      end
    else
      IO.puts("""
      Action "#{action}" is not a valid action.
      Go to AnkiConnect module documentation to see the available actions.
      """)
    end
  end

  @spec get_params([{String.t() | atom(), any()}]) :: [map()]
  defp get_params(parsed) do
    parsed
    |> Enum.map(fn {key, value} ->
      case Jason.decode(value, keys: &MapUtils.camel_to_snake_case_atom/1) do
        {:ok, deserialized} -> {key, deserialized}
        {:error, _} -> {key, value}
      end
    end)
    |> then(fn
      [] -> []
      list -> [Map.new(list)]
    end)
  end

  @spec run_action(atom(), [map()]) :: no_return()
  defp run_action(action, params) do
    case apply(AnkiConnect, action, params) do
      {:ok, nil} ->
        IO.puts("Done.")

      {:ok, value} ->
        value |> inspect() |> IO.puts()

      {:error, value} ->
        IO.puts("Error: #{inspect(value)}")
    end
  end
end
