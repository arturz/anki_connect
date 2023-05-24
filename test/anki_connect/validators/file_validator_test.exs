defmodule AnkiConnect.Actions.FileValidatorTest do
  use AnkiConnect.Case

  import AnkiConnect.Validators.FileValidator

  describe "check_for_file_data/1" do
    test "returns ok with valid data" do
      assert {:ok, _} =
               check_for_file_data(%{
                 filename: "test",
                 data: "test"
               })

      assert {:ok, _} =
               check_for_file_data(%{
                 filename: "test",
                 path: "test"
               })

      assert {:ok, _} =
               check_for_file_data(%{
                 filename: "test",
                 url: "test"
               })
    end

    test "returns error about missing content" do
      assert {:error, "No data, path or url key found"} =
               check_for_file_data(%{
                 filename: "test"
               })
    end

    test "returns error about missing filename" do
      assert {:error, "No filename found"} =
               check_for_file_data(%{
                 data: "test"
               })
    end

    test "returns error about wrong argument's type" do
      assert {:error, "File data must be a map"} = check_for_file_data(123)
    end
  end
end
