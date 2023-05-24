defmodule AnkiConnect.Specs.FileSpec do
  @moduledoc false

  @type t() ::
          %{
            filename: String.t(),
            data: String.t()
          }
          | %{
              filename: String.t(),
              path: String.t()
            }
          | %{
              filename: String.t(),
              url: String.t()
            }
end
