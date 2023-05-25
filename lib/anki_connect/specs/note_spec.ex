defmodule AnkiConnect.Specs.NoteSpec do
  @doc """
  Includes type specs for note.
  """

  alias AnkiConnect.Specs.FileSpec

  @typedoc """
  Notes passed to `AnkiConnect.Actions.Note.add_note/1` and `AnkiConnect.Actions.Note.add_notes/1` functions follow this spec.

  ## Options

  The `duplicate_scope` member inside `options` can be used to specify the scope for which duplicates are checked. A value of `"deck"` will only check for duplicates in the target deck; any other value will check the entire collection.

  The `duplicate_scope_options` map can be used to specify some additional settings:
  - `duplicate_scope_options.deck_name` will specify which deck to use for checking duplicates in. If `nil`, the target deck will be used.
  - `duplicate_scope_options.check_children` will change whether or not duplicate cards are checked in child decks. The default value is `false`.
  - `duplicate_scope_options.check_all_models` specifies whether duplicate checks are performed across all note types. The default value is `false`.

  ## Saving media

  Anki-Connect can download audio, video, and picture files and embed them in newly created notes.
  To do this, you need to specify the `audio`, `video`, and `picture` fields in the note with a list of files (refer to `AnkiConnect.Specs.FileSpec` for syntax).
  """
  @type t() :: %{
          deck_name: String.t(),
          model_name: String.t(),
          fields: %{
            Front: String.t(),
            Back: String.t()
          },
          options:
            %{
              allow_duplicate: boolean() | nil,
              duplicate_scope: String.t() | nil,
              duplicate_scope_options:
                %{
                  deck_name: String.t() | nil,
                  check_children: boolean() | nil,
                  check_all_models: boolean() | nil
                }
                | nil
            }
            | nil,
          tags: [String.t()] | nil,
          audio: [FileSpec.t()] | nil,
          video: [FileSpec.t()] | nil,
          picture: [FileSpec.t()] | nil
        }
end
