defmodule AnkiConnect.Client do
  @moduledoc false

  import AnkiConnect.Tesla

  alias AnkiConnect.Utils.MapUtils

  @version 6

  def api(action, params \\ %{}) do
    data = %{
      action: action,
      version: @version,
      params: MapUtils.convert_keys_to_camel_case_strings(params)
    }

    case post("/", data) do
      {:ok, %Tesla.Env{body: %{"error" => nil, "result" => result}}} ->
        {:ok, result}

      {:ok, %Tesla.Env{body: %{"error" => error}}} ->
        {:error, error}

      {:error, error} ->
        {:error, error}
    end
  end
end
