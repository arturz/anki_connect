defmodule AnkiConnect.Actions.DeckFactory do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      def get_deck_params do
        %{
          deck: sequence("deck")
        }
      end
    end
  end
end
