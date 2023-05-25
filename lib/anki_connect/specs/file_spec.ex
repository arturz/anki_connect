defmodule AnkiConnect.Specs.FileSpec do
  @doc """
  Includes type specs for file.
  """

  @typedoc """
  Represents a file to be downloaded by Anki to media folder.

  You can specify a base64-encoded string with `data` param, an absolute file path with `path`, or a url with `url` param from where the file shell be downloaded.
  If more than one of `data`, `path` and `url` are provided, the `data` field will be used first, then `path`, and finally `url`.

  To prevent Anki from removing files not used by any cards (e.g. for configuration files), prefix the filename with an underscore. These files are still synchronized to AnkiWeb.

  Any existing file with the same name is deleted by default. Set *deleteExisting* to false to prevent that by [letting Anki give the new file a non-conflicting name](https://github.com/ankitects/anki/blob/aeba725d3ea9628c73300648f748140db3fdd5ed/rslib/src/media/files.rs#L194).

  ### Example (base64 encoded):
  ```
  %{
    filename: "_hello.txt",
    data: "SGVsbG8sIHdvcmxkIQ=="
  }
  ```

  ### Example (absolute path):
  ```
  %{
    filename: "_hello.txt",
    path: "/path/to/file"
  }
  ```

  ### Example (URL):
  ```
  %{
    filename: "_hello.txt",
    url: "https://url.to.file"
  }
  ```

  The optional `skip_hash` field can be optionally provided to skip the inclusion of files with an MD5 hash that matches the provided value.
  This is useful for avoiding the saving of error pages and stub files.

  The optional `fields` member is a list of fields that should play audio or video, or show a picture when the card is displayed in Anki.

  ### Example:
  ```
  %{
    url: "https://assets.languagepod101.com/dictionary/japanese/audiomp3.php?kanji=猫&kana=ねこ",
    filename: "yomichan_ねこ_猫.mp3",
    skip_hash: "7e2c2f954ef6051373ba916f000168dc",
    fields: ["Front"]
  }
  ```
  """
  @type t() ::
          %{
            data: String.t(),
            filename: String.t(),
            skip_hash: String.t() | nil,
            fields: [String.t()] | nil
          }
          | %{
              path: String.t(),
              filename: String.t(),
              skip_hash: String.t() | nil,
              fields: [String.t()] | nil
            }
          | %{
              url: String.t(),
              filename: String.t(),
              skip_hash: String.t() | nil,
              fields: [String.t()] | nil
            }
end
