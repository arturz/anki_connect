defmodule AnkiConnect.Services.AddNotesFromFile do
  @moduledoc """
  Provides functionality to upload notes from a given text file to Anki.
  """

  import AnkiConnect, only: [add_notes: 1]
  import AnkiConnect.Utils.MapUtils

  @default_model_name "Basic"
  @default_regex "-\s+(.*)\s+-\s+(.*)"

  @type note :: {String.t(), String.t()}

  @doc """
  Uploads notes from a given text file to Anki.

  ## Parameters
  * `file` - path to the file with notes
  * `deck` - name of the deck to which the notes should be added
  * `model` [optional] - name of the model to which the notes should be added, by default `Basic`
  * `regex` [optional] - regex used to parse the file

  Default regex is `-\\s+(.*)\\s+-\\s+(.*)` which means that the file should contain lines in the following format:
  ```
  - back - front
  ```
  where `back` and `front` are the back and front of the note respectively.

  ## Example
  File content:
  ```
  - subsidiary - filia
  - pageant - widowisko
  - indispensable - niezbędny
  - out-of-the-way - odległy
  ```

  ```bash
  > mix anki_connect add_notes_from_file --file="words.md" --deck="TEST DECK"
  [1684955655336, 1684955655337, 1684955655338, 1684955655339]
  ```
  """
  @spec add_notes_from_file(%{
          file: String.t(),
          deck: String.t(),
          model: String.t() | nil,
          regex: String.t() | nil
        }) :: {:ok, nil} | {:error, String.t()}
  def add_notes_from_file(%{file: filename, deck: deck} = param) do
    model = Map.get(param, :model, @default_model_name)
    regex = Map.get(param, :regex, @default_regex)
    options = Map.get(param, :options)

    compiled_regex = Regex.compile!(regex)

    notes =
      File.stream!(filename)
      |> Stream.map(&parse_line(&1, compiled_regex))
      |> Enum.to_list()

    duplicates = find_duplicates(notes)

    if length(duplicates) > 0 do
      Enum.each(duplicates, fn {back, duplicates} ->
        IO.puts("Duplicated notes: #{back} -> #{inspect(duplicates)}")
      end)

      {:error, "Duplicated notes found"}
    else
      formatted_notes =
        Enum.map(notes, fn {back, front} ->
          %{
            deck_name: deck,
            model_name: model,
            fields: %{Back: back, Front: front}
          }
          |> maybe_add_field(:options, options)
        end)

      add_notes(%{
        notes: formatted_notes
      })
    end
  end

  @spec parse_line(String.t(), Regex.t()) :: note()
  defp parse_line(line, compiled_regex) do
    line
    |> String.trim()
    |> then(&Regex.run(compiled_regex, &1))
    |> then(fn [_, back, front] -> {back, front} end)
  end

  @spec find_duplicates([note()]) :: [{String.t(), [String.t()]}]
  defp find_duplicates(notes) do
    notes
    |> Enum.group_by(fn {back, _} -> back end)
    |> Enum.filter(fn {_, notes} -> length(notes) > 1 end)
    |> Enum.map(fn {back, notes} -> {back, Enum.map(notes, fn {_, front} -> front end)} end)
  end
end
