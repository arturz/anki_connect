defmodule AnkiConnect.Actions.NoteTest do
  use AnkiConnect.Case

  setup do
    deck_params = get_deck_params()

    create_deck(deck_params)

    assert {:ok, decks} = deck_names()

    assert deck_params.deck in decks

    on_exit(fn ->
      delete_decks(%{
        decks: [deck_params.deck]
      })

      assert {:ok, decks} = deck_names()

      refute deck_params.deck in decks
    end)

    {:ok, [model_name | _]} = model_names()

    %{deck: deck_params.deck, model_name: model_name}
  end

  describe "add_note/1" do
    test "user is able to create note", %{deck: deck, model_name: model_name} do
      note_params = get_note_params(deck_name: deck, model_name: model_name)

      assert {:ok, note_id} = add_note(%{note: note_params})

      assert note_id != nil

      assert {:ok, [^note_id]} =
               find_notes(%{
                 query: "deck:#{deck}"
               })
    end

    test "user is not able to create note with wrong params" do
      assert {:error, _reason} =
               add_note(%{note: %{deck_name: nil, model_name: nil, fields: nil}})
    end
  end

  describe "add_notes/1" do
    test "user is able to create notes", %{deck: deck, model_name: model_name} do
      note_params =
        1..3
        |> Enum.map(fn _ ->
          get_note_params(deck_name: deck, model_name: model_name)
        end)

      assert {:ok, note_ids} = add_notes(%{notes: note_params})

      assert length(note_ids) == 3
      assert Enum.all?(note_ids, &is_integer/1)

      assert {:ok, ^note_ids} =
               find_notes(%{
                 query: "deck:#{deck}"
               })
    end

    test "user is not able to create notes with wrong params" do
      assert {:ok, [nil, nil, nil]} = add_notes(%{notes: [%{}, %{}, %{}]})
    end
  end

  describe "update_note/1" do
    test "user is able to update note", %{deck: deck, model_name: model_name} do
      note_params = get_note_params(deck_name: deck, model_name: model_name)

      assert {:ok, note_id} = add_note(%{note: note_params})

      assert note_id != nil

      assert {:ok, [^note_id]} =
               find_notes(%{
                 query: "deck:#{deck}"
               })

      assert {:ok, _} =
               update_note(%{
                 note: %{
                   id: note_id,
                   fields: %{
                     Front: "test",
                     Back: "test"
                   }
                 }
               })

      assert {:ok, [^note_id]} =
               find_notes(%{
                 query: "deck:#{deck} Front:test Back:test"
               })
    end

    test "user is not able to update note with wrong params" do
      assert {:error, _reason} = update_note(%{note: %{id: nil, fields: nil}})
    end
  end

  describe "can_add_notes/1" do
    test "returns true or false whether notes can be added", %{deck: deck, model_name: model_name} do
      note_params = get_note_params(deck_name: deck, model_name: model_name)

      assert {:ok, [false, true, false]} =
               can_add_notes(%{
                 notes: [%{deck_name: deck}, note_params, %{model_name: model_name}]
               })
    end
  end
end
