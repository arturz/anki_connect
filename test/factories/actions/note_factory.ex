defmodule AnkiConnect.Actions.NoteFactory do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      def get_note_params(deck_name: deck_name, model_name: model_name) do
        %{
          deck_name: deck_name,
          model_name: model_name,
          fields: %{
            Front: sequence("Front"),
            Back: sequence("Back")
          },
          tags: 1..3 |> Enum.map(fn _ -> sequence("tag") end)
        }
      end
    end
  end
end
