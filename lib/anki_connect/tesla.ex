defmodule AnkiConnect.Tesla do
  @moduledoc false

  use Tesla

  plug(Tesla.Middleware.BaseUrl, "http://localhost:8765")
  plug(Tesla.Middleware.JSON, decode_content_types: ["text/json"])
end
