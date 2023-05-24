defmodule AnkiConnect do
  @moduledoc """
  This module delegates all functions to `AnkiConnect.Actions.*` and `AnkiConnect.Services.*` modules.

  Functions can be called from your Elixir application as follows:

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

  or from the command line using `mix anki_connect` task:

  ```bash
  > mix anki_connect add_note --note='{"deck_name": "TEST DECK", "model_name": "Basic", "fields": {"Front": "front content", "Back": "back content"}}'
  1684946786121
  ```

  another example:

  ```bash
  > mix anki_connect add_notes_from_file --file="words.md" --deck="TEST DECK"
  [1684955655336, 1684955655337, ...]
  ```
  """

  alias AnkiConnect.Actions.{Deck, Graphical, Media, Miscellaneous, Model, Note, Statistic}
  alias AnkiConnect.Services.AddNotesFromFile

  defdelegate deck_names, to: Deck
  defdelegate deck_names_and_ids, to: Deck
  defdelegate get_decks(param), to: Deck
  defdelegate create_deck(param), to: Deck
  defdelegate change_deck(param), to: Deck
  defdelegate delete_decks(param), to: Deck
  defdelegate get_deck_config(param), to: Deck
  defdelegate save_deck_config(param), to: Deck
  defdelegate set_deck_config_id(param), to: Deck
  defdelegate clone_deck_config_id(param), to: Deck
  defdelegate remove_deck_config_id(param), to: Deck
  defdelegate get_deck_stats(param), to: Deck

  defdelegate gui_browse(param), to: Graphical
  defdelegate gui_selected_notes, to: Graphical
  defdelegate gui_add_cards(param), to: Graphical
  defdelegate gui_edit_note(param), to: Graphical
  defdelegate gui_current_card, to: Graphical
  defdelegate gui_start_card_timer, to: Graphical
  defdelegate gui_show_question, to: Graphical
  defdelegate gui_show_answer, to: Graphical
  defdelegate gui_answer_card(param), to: Graphical
  defdelegate gui_deck_overview(param), to: Graphical
  defdelegate gui_deck_browser, to: Graphical
  defdelegate gui_deck_review(param), to: Graphical
  defdelegate gui_exit_anki, to: Graphical
  defdelegate gui_check_database, to: Graphical

  defdelegate store_media_file(param), to: Media
  defdelegate retrieve_media_file(param), to: Media
  defdelegate get_media_files_names(param), to: Media
  defdelegate get_media_dir_path, to: Media
  defdelegate delete_media_file(param), to: Media

  defdelegate request_permission, to: Miscellaneous
  defdelegate version, to: Miscellaneous
  defdelegate api_reflect(param), to: Miscellaneous
  defdelegate sync, to: Miscellaneous
  defdelegate get_profiles, to: Miscellaneous
  defdelegate load_profile(param), to: Miscellaneous
  defdelegate multi(param), to: Miscellaneous
  defdelegate import_package(param), to: Miscellaneous
  defdelegate export_package(param), to: Miscellaneous
  defdelegate reload_collection, to: Miscellaneous

  defdelegate model_names, to: Model
  defdelegate model_names_and_ids, to: Model
  defdelegate model_field_names(param), to: Model
  defdelegate model_field_descriptions(param), to: Model
  defdelegate model_field_fonts(param), to: Model
  defdelegate model_fields_on_templates(param), to: Model
  defdelegate create_model(param), to: Model
  defdelegate model_templates(param), to: Model
  defdelegate model_styling(param), to: Model
  defdelegate update_model_templates(param), to: Model
  defdelegate update_model_styling(param), to: Model
  defdelegate find_and_replace_in_models(param), to: Model
  defdelegate model_template_rename(param), to: Model
  defdelegate model_template_reposition(param), to: Model
  defdelegate model_template_add(param), to: Model

  defdelegate add_note(param), to: Note
  defdelegate add_notes(param), to: Note
  defdelegate can_add_notes(param), to: Note
  defdelegate update_note_fields(param), to: Note
  defdelegate update_note(param), to: Note
  defdelegate update_note_tags(param), to: Note
  defdelegate get_note_tags(param), to: Note
  defdelegate add_tags(param), to: Note
  defdelegate remove_tags(param), to: Note
  defdelegate get_tags, to: Note
  defdelegate clear_unused_tags, to: Note
  defdelegate replace_tags(param), to: Note
  defdelegate replace_tags_in_all_notes(param), to: Note
  defdelegate find_notes(param), to: Note
  defdelegate notes_info(param), to: Note
  defdelegate delete_notes(param), to: Note
  defdelegate remove_empty_notes(param), to: Note

  defdelegate get_num_cards_reviewed_today, to: Statistic
  defdelegate get_num_cards_reviewed_by_day, to: Statistic
  defdelegate get_collection_stats_html(param), to: Statistic
  defdelegate card_reviews(param), to: Statistic
  defdelegate get_reviews_of_cards(param), to: Statistic
  defdelegate get_latest_review_id(param), to: Statistic
  defdelegate insert_reviews(param), to: Statistic

  defdelegate add_notes_from_file(param), to: AddNotesFromFile
end
