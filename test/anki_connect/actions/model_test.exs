defmodule AnkiConnect.Actions.ModelTest do
  use AnkiConnect.Case

  import AnkiConnect.Client
  import AnkiConnect

  describe "model_names/0" do
    test "returns the list of model names" do
      {:ok, expected_result} = api("modelNames")
      assert {:ok, result} = model_names()
      assert expected_result == result
    end
  end

  describe "model_names_and_ids/0" do
    test "returns the list of model names and IDs" do
      {:ok, expected_result} = api("modelNamesAndIds")
      assert {:ok, result} = model_names_and_ids()
      assert expected_result == result
    end
  end

  describe "model_field_names/1" do
    test "returns the list of field names for a model" do
      model_name = "Basic"
      params = %{model_name: model_name}
      {:ok, expected_result} = api("modelFieldNames", params)
      assert {:ok, result} = model_field_names(params)
      assert expected_result == result
    end
  end
end
