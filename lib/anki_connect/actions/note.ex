defmodule AnkiConnect.Actions.Note do
  @moduledoc """
  Note actions.

  All functions are delegated inside `AnkiConnect` module, so you should import them from there.
  """

  import AnkiConnect.Client
  import AnkiConnect.Utils.MapUtils

  alias AnkiConnect.Specs.NoteSpec

  @doc """
  Creates a note using the given deck and model, with the provided field values and tags.

  Returns the identifier of the created note created on success, and error on failure.

  Refer to `AnkiConnect.Specs.NoteSpec` for information about the `note` key.

  ### Sample param:
  ```
  %{
    note: %{
      deck_name: "Default",
      model_name: "Basic",
      fields: %{
        Front: "front content",
        Back: "back content"
      },
      options: %{
        allow_duplicate: false,
        duplicate_scope: "deck",
        duplicate_scope_options: %{
          deck_name: "Default",
          check_children: false,
          check_all_models: false
        }
      },
      tags: ["yomichan"],
      audio: [%{
        url: "https://assets.languagepod101.com/dictionary/japanese/audiomp3.php?kanji=猫&kana=ねこ",
        filename: "yomichan_ねこ_猫.mp3",
        skip_hash: "7e2c2f954ef6051373ba916f000168dc",
        fields: ["Front"]
      }],
      video: [%{
        url: "https://cdn.videvo.net/videvo_files/video/free/2015-06/small_watermarked/Contador_Glam_preview.mp4",
        filename: "countdown.mp4",
        skip_hash: "4117e8aab0d37534d9c8eac362388bbe",
        fields: ["Back"]
      }],
      picture: [%{
        url: "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c7/A_black_cat_named_Tilly.jpg/220px-A_black_cat_named_Tilly.jpg",
        filename: "black_cat.jpg",
        skip_hash: "8d6e4646dfae812bf39651b59d7429ce",
        fields: ["Back"]
      }]
    }
  }
  ```

  ### Sample result:
  ```
  {:ok, 1496198395707}
  ```
  """
  @spec add_note(%{
          note: NoteSpec.t()
        }) :: {:ok, integer()} | {:error, any()}
  def add_note(%{note: %{deck_name: deck_name, model_name: model_name, fields: fields} = note}) do
    options = Map.get(note, :options)
    tags = Map.get(note, :tags)
    audio = Map.get(note, :audio)
    picture = Map.get(note, :picture)
    video = Map.get(note, :video)

    new_note =
      %{
        deck_name: deck_name,
        model_name: model_name,
        fields: fields
      }
      |> maybe_add_field(:options, options)
      |> maybe_add_field(:tags, tags)
      |> maybe_add_field(:audio, audio)
      |> maybe_add_field(:picture, picture)
      |> maybe_add_field(:video, video)

    api("addNote", %{
      note: new_note
    })
  end

  @doc """
  Creates multiple notes using the given deck and model, with the provided field values and tags.

  Returns an array of identifiers of the created notes (notes that could not be created will have a `nil` identifier).

  Refer to `AnkiConnect.Specs.NoteSpec` for information about the `notes` list elements.

  ### Sample param:
  ```
  %{
    notes: [
      %{
        deck_name: "Default",
        model_name: "Basic",
        fields: %{
          Front: "front content",
          Back: "back content"
        },
        tags: [
          "yomichan"
        ],
        audio: [
          %{
            url: "https://assets.languagepod101.com/dictionary/japanese/audiomp3.php?kanji=猫&kana=ねこ",
            filename: "yomichan_ねこ_猫.mp3",
            skip_hash: "7e2c2f954ef6051373ba916f000168dc",
            fields: [
              "Front"
            ]
          }
        ],
        video: [
          %{
            url: "https://cdn.videvo.net/videvo_files/video/free/2015-06/small_watermarked/Contador_Glam_preview.mp4",
            filename: "countdown.mp4",
            skip_hash: "4117e8aab0d37534d9c8eac362388bbe",
            fields: [
              "Back"
            ]
          }
        ],
        picture: [
          %{
            url: "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c7/A_black_cat_named_Tilly.jpg/220px-A_black_cat_named_Tilly.jpg",
            filename: "black_cat.jpg",
            skip_hash: "8d6e4646dfae812bf39651b59d7429ce",
            fields: [
              "Back"
            ]
          }
        ]
      }
    ]
  }
  ```

  ### Sample result:
  ```
  {:ok, [1496198395707, nil]}
  ```
  """
  @spec add_notes(%{notes: [NoteSpec.t()]}) :: {:ok, [integer() | nil]} | {:error, any()}
  def add_notes(%{notes: notes}) do
    api("addNotes", %{notes: notes})
  end

  @doc """
  Accepts an array of objects which define parameters for candidate notes (see `AnkiConnect.Actions.Note.add_note/1`) and returns an array of booleans indicating whether or not the parameters at the corresponding index could be used to create a new note.

  ### Sample param:
  ```
  %{
    notes: [
      {
        deck_name: "Default",
        model_name: "Basic",
        fields: {
          Front: "front content",
          Back: "back content"
        },
        tags: [
          "yomichan"
        ]
      }
    ]
  }
  ```

  ### Sample result:
  ```
  {:ok, [true]}
  ```
  """
  @spec can_add_notes(%{notes: [NoteSpec.t()]}) :: {:ok, [boolean()]} | {:error, any()}
  def can_add_notes(%{notes: notes}) do
    api("canAddNotes", %{notes: notes})
  end

  @doc """
  Modify the fields of an existing note.

  You can also include `audio`, `video`, or `picture` files which will be added to the note with an optional `audio`, `video`, or `picture` property. Please see the documentation for `add_note` for an explanation of objects in the `audio`, `video`, or `pictur`e array.

  *Warning: You must not be viewing the note that you are updating on your Anki browser, otherwise the fields will not update. See [this issue](https://github.com/FooSoft/anki-connect/issues/82) for further details.*

  ### Sample param:
  ```
  %{
    note: {
      id: 1514547547030,
      fields: {
        Front: "new front content",
        Back: "new back content"
      },
      audio: [{
        url: "https://assets.languagepod101.com/dictionary/japanese/audiomp3.php?kanji=猫&kana=ねこ",
        filename: "yomichan_ねこ_猫.mp3",
        skipHash: "7e2c2f954ef6051373ba916f000168dc",
        fields: [
          "Front"
        ]
      }]
    }
  }
  ```

  ### Sample result:
  ```
  {:ok, nil}
  ```
  """
  @spec update_note_fields(%{note: NoteSpec.t()}) :: {:ok, nil} | {:error, any()}
  def update_note_fields(%{note: note}) do
    api("updateNoteFields", %{note: note})
  end

  @doc """
  Modify the fields and/or tags of an existing note.

  In other words, combines `update_note_fields` and `update_note_tags`.
  Please see their documentation for an explanation of all properties.

  Either fields or tags property can be omitted without affecting the other. Thus valid requests to `update_note_fields` also work with `update_note`. The note must have the `fields` property in order to update the optional audio, video, or picture objects.

  If neither `fields` nor `tags` are provided, the method will fail. Fields are updated first and are not rolled back if updating tags fails. Tags are not updated if updating fields fails.

  *Warning: You must not be viewing the note that you are updating on your Anki browser, otherwise the fields will not update. See [this issue](https://github.com/FooSoft/anki-connect/issues/82) for further details.*

  ### Sample param:
  ```
  %{
    note: {
      id: 1514547547030,
      fields: {
        Front: "new front content",
        Back: "new back content"
      },
      tags: ["new", "tags"]
    }
  }
  ```

  ### Sample result:
  ```
  {:ok, nil}
  ```
  """
  @spec update_note(%{note: NoteSpec.t()}) :: {:ok, nil} | {:error, any()}
  def update_note(%{note: note}) do
    api("updateNote", %{note: note})
  end

  @doc """
  Set a note’s tags by note ID.

  Old tags will be removed.

  ### Sample param:
  ```
  %{
    note: 1483959289817,
    tags: ["european-languages"]
  }
  ```

  ### Sample result:
  ```
  {:ok, nil}
  ```
  """
  @spec update_note_tags(%{note: integer(), tags: [String.t()]}) :: {:ok, nil} | {:error, any()}
  def update_note_tags(%{note: note, tags: tags}) do
    api("updateNoteTags", %{note: note, tags: tags})
  end

  @doc """
  Get a note’s tags by note ID.

  ### Sample param:
  ```
  %{
    note: 1483959289817
  }
  ```

  ### Sample result:
  ```
  {:ok, ["european-languages"]}
  ```
  """
  @spec get_note_tags(%{note: integer()}) :: {:ok, [String.t()]} | {:error, any()}
  def get_note_tags(%{note: note}) do
    api("getNoteTags", %{note: note})
  end

  @doc """
  Adds tags to notes by note ID.

  ### Sample param:
  ```
  %{
    notes: [1483959289817, 1483959291695],
    tags: "european-languages"
  }
  ```

  ### Sample result:
  ```
  {:ok, nil}
  ```
  """
  @spec add_tags(%{notes: [integer()], tags: String.t()}) :: {:ok, nil} | {:error, any()}
  def add_tags(%{notes: notes, tags: tags}) do
    api("addTags", %{notes: notes, tags: tags})
  end

  @doc """
  Remove tags from notes by note ID.

  ### Sample param:
  ```
  %{
    notes: [1483959289817, 1483959291695],
    tags: "european-languages"
  }
  ```

  ### Sample result:
  ```
  {:ok, nil}
  ```
  """
  @spec remove_tags(%{notes: [integer()], tags: String.t()}) :: {:ok, nil} | {:error, any()}
  def remove_tags(%{notes: notes, tags: tags}) do
    api("removeTags", %{notes: notes, tags: tags})
  end

  @doc """
  Gets the complete list of tags for the current user.

  ### Sample result:
  ```
  {:ok, ["european-languages", "idioms"]}
  ```
  """
  @spec get_tags() :: {:ok, [String.t()]} | {:error, any()}
  def get_tags do
    api("getTags")
  end

  @doc """
  Clears all the unused tags in the notes for the current user.
  """
  @spec clear_unused_tags() :: {:ok, nil} | {:error, any()}
  def clear_unused_tags do
    api("clearUnusedTags")
  end

  @doc """
  Replace tags in notes by note ID.

  ### Sample param:
  ```
  %{
    notes: [1483959289817, 1483959291695],
    tag_to_replace: "european-languages",
    replace_with_tag: "french-languages"
  }
  ```
  """
  @spec replace_tags(%{
          notes: [integer()],
          tag_to_replace: String.t(),
          replace_with_tag: String.t()
        }) :: {:ok, nil} | {:error, any()}
  def replace_tags(%{
        notes: notes,
        tag_to_replace: tag_to_replace,
        replace_with_tag: replace_with_tag
      }) do
    api("replaceTags", %{
      notes: notes,
      tag_to_replace: tag_to_replace,
      replace_with_tag: replace_with_tag
    })
  end

  @doc """
  Replace tags in all the notes for the current user.

  ### Sample param:
  ```
  %{
    tag_to_replace: "european-languages",
    replace_with_tag: "french-languages"
  }
  ```
  """
  @spec replace_tags_in_all_notes(%{tag_to_replace: String.t(), replace_with_tag: String.t()}) ::
          {:ok, nil} | {:error, any()}
  def replace_tags_in_all_notes(%{
        tag_to_replace: tag_to_replace,
        replace_with_tag: replace_with_tag
      }) do
    api("replaceTagsInAllNotes", %{
      tag_to_replace: tag_to_replace,
      replace_with_tag: replace_with_tag
    })
  end

  @doc """
  Returns an array of note IDs for a given query.

  Query syntax is [documented here](https://docs.ankiweb.net/searching.html).

  ### Sample param:
  ```
  %{
    query: "deck:current"
  }
  ```

  ### Sample result:
  ```
  {:ok, [1494723142483, 1494703460437, 1494703479525]}
  ```
  """
  @spec find_notes(%{query: String.t()}) :: {:ok, [integer()]} | {:error, any()}
  def find_notes(%{query: query}) do
    api("findNotes", %{query: query})
  end

  @doc """
  Returns a list of objects containing for each note ID the note fields, tags, note type and the cards belonging to the note.

  ### Sample param:
  ```
  %{
    notes: [1502298033753]
  }
  ```

  ### Sample result:
  ```
  [
    {
      "noteId": 1502298033753,
      "modelName": "Basic",
      "tags": ["tag","another_tag"],
      "fields": {
        "Front": {"value": "front content", "order": 0},
        "Back": {"value": "back content", "order": 1}
      }
    }
  ]
  ```
  """
  @spec notes_info(%{notes: [integer()]}) :: {:ok, [map()]} | {:error, any()}
  def notes_info(%{notes: notes}) do
    api("notesInfo", %{notes: notes})
  end

  @doc """
  Deletes notes with the given ids.

  If a note has several cards associated with it, all associated cards will be deleted.

  ### Sample param:
  ```
  %{
    notes: [1502298033753]
  }
  ```
  """
  @spec delete_notes(%{notes: [integer()]}) :: {:ok, nil} | {:error, any()}
  def delete_notes(%{notes: notes}) do
    api("deleteNotes", %{notes: notes})
  end

  @doc """
  Removes all the empty notes for the current user.
  """
  @spec remove_empty_notes(%{notes: [integer()]}) :: {:ok, nil} | {:error, any()}
  def remove_empty_notes(%{notes: notes}) do
    api("removeEmptyNotes", %{notes: notes})
  end
end
