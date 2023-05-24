defmodule AnkiConnect.Factory do
  @moduledoc false

  import ExMachina, only: [sequence: 1]

  use AnkiConnect.Actions.DeckFactory
  use AnkiConnect.Actions.NoteFactory
end
