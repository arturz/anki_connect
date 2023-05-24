defmodule AnkiConnect.Actions.Media do
  @moduledoc """
  Media actions.

  All functions are delegated inside `AnkiConnect` module, so you should import them from there.
  """

  import AnkiConnect.Client
  import AnkiConnect.Validators.FileValidator

  @doc """
  Stores a file with the specified base64-encoded contents inside the media folder.

  Alternatively you can specify a absolute file path, or a url from where the file shell be downloaded. If more than one of `data`, `path` and `url` are provided, the `data` field will be used first, then `path`, and finally `url`.

  To prevent Anki from removing files not used by any cards (e.g. for configuration files), prefix the filename with an underscore. These files are still synchronized to AnkiWeb.

  Any existing file with the same name is deleted by default. Set *deleteExisting* to false to prevent that by [letting Anki give the new file a non-conflicting name](https://github.com/ankitects/anki/blob/aeba725d3ea9628c73300648f748140db3fdd5ed/rslib/src/media/files.rs#L194).

  ### Sample param (base64 encoded):
  ```
  %{
    filename: "_hello.txt",
    data: "SGVsbG8sIHdvcmxkIQ=="
  }
  ```

  ### Sample param (absolute path):
  ```
  %{
    filename: "_hello.txt",
    path: "/path/to/file"
  }
  ```

  ### Sample param (URL):
  ```
  %{
    filename: "_hello.txt",
    url: "https://url.to.file"
  }
  ```

  ### Sample result:
  ```
  {:ok, "_hello.txt"}
  ```
  """
  @spec store_media_file(map()) :: {:ok, String.t()} | {:error, any()}
  def store_media_file(data) do
    with {:ok, _} <- check_for_file_data(data) do
      api("storeMediaFile", data)
    end
  end

  @doc """
  Retrieves the base64-encoded contents of the specified file, returning error if the file does not exist.

  ### Sample param:
  ```
  %{
    filename: "_hello.txt"
  }
  ```

  ### Sample result:
  ```
  {:ok, "SGVsbG8sIHdvcmxkIQ=="}
  ```
  """
  @spec retrieve_media_file(%{filename: String.t()}) :: {:ok, String.t()} | {:error, any()}
  def retrieve_media_file(%{filename: filename}) do
    case api("retrieveMediaFile", %{filename: filename}) do
      {:ok, false} -> {:error, "File not found"}
      {:ok, data} -> {:ok, data}
    end
  end

  @doc """
  Gets the names of media files matched the pattern. Returning all names by default.

  ### Sample param:
  ```
  %{
    pattern: "_hell*.txt"
  }
  ```

  ### Sample result:
  ```
  {:ok, ["_hello.txt"]}
  ```
  """
  @spec get_media_files_names(%{pattern: String.t()}) :: {:ok, [String.t()]} | {:error, any()}
  def get_media_files_names(%{pattern: pattern}) do
    api("getMediaFilesNames", %{pattern: pattern})
  end

  @doc """
  Gets the full path to the `collection.media` folder of the currently opened profile.

  ### Sample result:
  ```
  {:ok, "/home/user/.local/share/Anki2/Main/collection.media"}
  ```
  """
  @spec get_media_dir_path() :: {:ok, String.t()} | {:error, any()}
  def get_media_dir_path do
    api("getMediaDirPath")
  end

  @doc """
  Deletes the specified file inside the media folder.

  ### Sample param:
  ```
  %{
    filename: "_hello.txt"
  }
  ```

  ### Sample result:
  ```
  {:ok, nil}
  ```
  """
  @spec delete_media_file(%{filename: String.t()}) :: {:ok, nil} | {:error, any()}
  def delete_media_file(%{filename: filename}) do
    api("deleteMediaFile", %{filename: filename})
  end
end
