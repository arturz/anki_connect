defmodule AnkiConnect.Services.AddNotesFromFileTest do
  use AnkiConnect.Case

  @test_file_path Path.join([:code.priv_dir(:anki_connect), "test_file.txt"])

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

      delete_test_file()
    end)

    {:ok, [model_name | _]} = model_names()
    %{deck: deck_params.deck, model: model_name}
  end

  describe "add_notes_from_file/1" do
    test "successfully adds notes from file with no duplicates", %{deck: deck, model: model} do
      file_content = """
      - subsidiary - filia
      - freeze-frame - stopklatka
      - pageant - widowisko
      - indispensable - niezbędny
      - in the seclusion of one’s own home - w zaciszu własnego domu
      - courtesy - uprzejmość
      - shrine - sanktuarium
      - be on payroll - być zatrudnionym
      - tie-in - powiązanie
      - out-of-the-way - na uboczu
      """

      assert {:ok, file_path} = create_test_file(file_content)

      assert {:ok, note_ids} =
               add_notes_from_file(%{
                 file: file_path,
                 deck: deck,
                 model: model,
                 options: %{
                   allow_duplicate: true
                 }
               })

      assert length(note_ids) == 10
      assert Enum.all?(note_ids, &is_integer/1)

      assert {:ok, ^note_ids} =
               find_notes(%{
                 query: "deck:#{deck}"
               })
    end

    test "returns error when duplicated notes are found", %{deck: deck, model: model} do
      file_content = """
      - indispensable - niezbędny
      - out-of-the-way - na uboczu (duplicated)
      - pageant - widowisko
      - indispensable - niezbędny (duplicated)
      - in the seclusion of one’s own home - w zaciszu własnego domu (duplicated)
      - shrine - sanktuarium
      - be on payroll - być zatrudnionym
      - tie-in - powiązanie
      - out-of-the-way - na uboczu
      - in the seclusion of one’s own home - w zaciszu własnego domu
      """

      assert {:ok, file_path} = create_test_file(file_content)

      assert {:error, "Duplicated notes found"} =
               add_notes_from_file(%{
                 file: file_path,
                 deck: deck,
                 model: model,
                 options: %{
                   allow_duplicate: true
                 }
               })
    end
  end

  defp create_test_file(content) do
    File.write(@test_file_path, content)
    {:ok, @test_file_path}
  end

  defp delete_test_file do
    File.rm(@test_file_path)
  end
end
