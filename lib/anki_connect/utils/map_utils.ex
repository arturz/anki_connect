defmodule AnkiConnect.Utils.MapUtils do
  @moduledoc false

  @doc """
  Converts a map with snake_case keys to camelCase keys.
  """
  def convert_keys_to_camel_case_strings(map) when is_map(map) do
    Enum.reduce(map, %{}, fn {key, value}, acc ->
      new_key = snake_to_camel_case_string(key)

      new_value =
        case value do
          map when is_map(map) -> convert_keys_to_camel_case_strings(map)
          list when is_list(list) -> Enum.map(list, &convert_keys_to_camel_case_strings/1)
          _ -> value
        end

      Map.put(acc, new_key, new_value)
    end)
  end

  def convert_keys_to_camel_case_strings(arg), do: arg

  defp snake_to_camel_case_string(name) when is_atom(name) do
    name
    |> Atom.to_string()
    |> snake_to_camel_case_string()
  end

  defp snake_to_camel_case_string(name) when is_bitstring(name) do
    name
    |> String.replace("_", " ")
    |> String.split(" ")
    |> Enum.with_index()
    |> Enum.map_join("", fn
      {word, index} ->
        if index == 0 do
          word
        else
          String.capitalize(word)
        end
    end)
    |> then(fn
      "startId" -> "startID"
      otherwise -> otherwise
    end)
  end

  @doc """
  Puts a value into a map if the value is not nil.
  """
  @spec maybe_add_field(map(), atom(), any()) :: map()
  def maybe_add_field(map, _key, nil), do: map

  def maybe_add_field(map, key, value) do
    Map.put(map, key, value)
  end

  @doc """
  Converts a camelCase string/atom to snake_case atom, except the first letter.
  """
  @spec camel_to_snake_case_atom(binary()) :: atom()
  def camel_to_snake_case_atom(name) when is_bitstring(name) do
    name = name |> String.replace(~r/(?<!^)([a-z\d])([A-Z])/, "\\1_\\2")

    <<first_char::utf8, rest_chars::binary>> = name
    downcased_rest_chars = String.downcase(rest_chars)

    <<first_char::utf8, downcased_rest_chars::binary>>
    |> String.to_atom()
  end

  @spec camel_to_snake_case_atom(atom()) :: atom()
  def camel_to_snake_case_atom(name) when is_atom(name) do
    name
    |> Atom.to_string()
    |> camel_to_snake_case_atom()
  end
end
