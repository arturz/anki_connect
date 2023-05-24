defmodule AnkiConnect.Validators.FileValidator do
  @moduledoc false

  alias AnkiConnect.Specs.FileSpec

  @spec check_for_file_data(FileSpec.t()) :: {:ok, FileSpec.t()} | {:error, any()}
  def check_for_file_data(%{filename: _} = data) do
    content =
      cond do
        Map.has_key?(data, :data) -> true
        Map.has_key?(data, :path) -> true
        Map.has_key?(data, :url) -> true
        true -> nil
      end

    if is_nil(content) do
      {:error, "No data, path or url key found"}
    else
      {:ok, data}
    end
  end

  def check_for_file_data(data) when is_map(data) do
    {:error, "No filename found"}
  end

  def check_for_file_data(_) do
    {:error, "File data must be a map"}
  end
end
