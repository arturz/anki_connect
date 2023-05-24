defmodule AnkiConnect.Actions.Miscellaneous do
  @moduledoc """
  Miscellaneous actions.

  All functions are delegated inside `AnkiConnect` module, so you should import them from there.
  """

  import AnkiConnect.Client
  import AnkiConnect.Utils.MapUtils

  @doc """
  Requests permission to use the API exposed by AnkiConnect.

  This method does not require the API key, and is the only one that accepts requests from any origin; the other methods only accept requests from trusted origins, which are listed under `webCorsOriginList` in the add-on config. `localhost` is trusted by default.

  Calling this method from an untrusted origin will display a popup in Anki asking the user whether they want to allow your origin to use the API; calls from trusted origins will return the result without displaying the popup. When denying permission, the user may also choose to ignore further permission requests from that origin. These origins end up in the `ignoreOriginList`, editable via the add-on config.

  The result always contains the `permission` field, which in turn contains either the string `granted` or `denied`, corresponding to whether your origin is trusted. If your origin is trusted, the fields `requireApiKey` (`true` if required) and `version` will also be returned.

  This should be the first call you make to make sure that your application and Anki-Connect are able to communicate properly with each other. New versions of Anki-Connect are backwards compatible; as long as you are using actions which are available in the reported Anki-Connect version or earlier, everything should work fine.

  ### Sample results:
  ```
  {:ok, %{
    "permission" => "granted",
    "requireApiKey" => false,
    "version" => 6
  }}
  ```

  ```
  {:ok, %{
    "permission" => "denied"
  }}
  ```
  """
  @spec request_permission() :: {:ok, map()} | {:error, any()}
  def request_permission do
    api("requestPermission")
  end

  @doc """
  Gets the version of the API exposed by AnkiConnect.

  Currently versions 1 through 6 are defined.

  ### Sample result:
  ```
  {:ok, 6}
  ```
  """
  @spec version() :: {:ok, integer()} | {:error, any()}
  def version do
    api("version")
  end

  @doc """
  Gets information about the AnkiConnect APIs available.

  The request supports the following params:
  - `scopes` - An array of scopes to get reflection information about. The only currently supported value is `"actions"`.
  - `actions` - Either `nil` or an array of API method names to check for. If the value is `nil`, the result will list all of the available API actions. If the value is an array of strings, the result will only contain actions which were in this array.

  The result will contain a list of which scopes were used and a value for each scope. For example, the `"actions"` scope will contain a `"actions"` property which contains a list of supported action names.

  ### Sample param:
  ```
  %{
    scopes: ["actions", "invalidType"],
    actions: ["apiReflect", "invalidMethod"]
  }
  ```

  ### Sample result:
  ```
  {:ok, %{
    "scopes" => ["actions"],
    "actions" => ["apiReflect"]
  }}
  ```
  """
  @spec api_reflect(%{scopes: [String.t()], actions: [String.t()] | nil}) ::
          {:ok, %{scopes: [String.t()], actions: [String.t()]}} | {:error, any()}
  def api_reflect(%{scopes: scopes} = param) do
    actions = Map.get(param, :actions, nil)

    api("apiReflect", %{scopes: scopes} |> maybe_add_field(:actions, actions))
  end

  @doc """
  Synchronizes the local Anki collections with AnkiWeb.
  """
  @spec sync() :: {:ok, nil} | {:error, any()}
  def sync do
    api("sync")
  end

  @doc """
  Retrieve the list of profiles.

  ### Sample result:
  ```
  {:ok, ["Default"]}
  ```
  """
  @spec get_profiles() :: {:ok, [String.t()]} | {:error, any()}
  def get_profiles do
    api("getProfiles")
  end

  @doc """
  Selects the profile specified in request.

  ### Sample param:
  ```
  %{
    name: "user1"
  }
  ```

  ### Sample result:
  ```
  {:ok, nil}
  ```
  """
  @spec load_profile(%{name: String.t()}) :: {:ok, nil} | {:error, any()}
  def load_profile(%{name: name}) do
    api("loadProfile", %{name: name})
  end

  @doc """
  Performs multiple actions in one request, returning an array with the response of each action (in the given order).

  Warning: returned values will vary from returned values of the same actions called separately.
  That's becasue Elixir-AnkiConnect maps returned value to `{:ok, result}` or `{:error, reason}` and is more strict when checking for errors.
  If you wish to get the same result as calling actions separately, you have to investigate the sources of distinct functions manually.
  Also, the default `version` is `6` for all actions.

  ### Sample param:
  ```
  %{
    actions: [
      %{
        action: "deckNames"
      },
      %{
        action: "deckNames",
        version: 6
      },
      %{
        action: "invalidAction",
        params: %{
          useless: "param"
        }
      },
      %{
        action: "invalidAction",
        params: %{
          useless: "param"
        },
        version: 6
      }
    ]
  }
  ```

  ### Sample result:
  ```
  {:ok, [
    ["Default"],
    %{"result" => ["Default"], "error" => nil},
    %{"result" => nil, "error" => "unsupported action"},
    %{"result" => nil, "error" => "unsupported action"}
  ]}
  ```
  """
  @spec multi(%{actions: [map()]}) :: {:ok, [any()]} | {:error, any()}
  def multi(%{actions: actions}) do
    api("multi", %{actions: actions})
  end

  @doc """
  Exports a given deck in `.apkg` format.

  The optional property includeSched (default is false) can be specified to include the cards’ scheduling data.

  ### Sample param:
  ```
  %{
    deck: "Default",
    path: "/data/Deck.apkg",
    include_sched: true
  }
  ```

  ### Sample result:
  ```
  {:ok, nil}
  ```
  """
  @spec export_package(%{deck: String.t(), path: String.t(), include_sched: boolean() | nil}) ::
          {:ok, nil} | {:error, any()}
  def export_package(%{deck: deck, path: path} = param) do
    include_sched = Map.get(param, :include_sched, false)

    case api("exportPackage", %{deck: deck, path: path, include_sched: include_sched}) do
      {:ok, true} -> {:ok, nil}
      {:ok, false} -> {:error, "Export package failed"}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Imports a file in `.apkg` format into the collection.

  Note that the file path is relative to Anki’s `collection.media` folder, not to the client.

  ### Sample param:
  ```
  %{
    path: "/data/Deck.apkg"
  }
  ```

  ### Sample result:
  ```
  {:ok, nil}
  ```
  """
  @spec import_package(%{path: String.t()}) :: {:ok, nil} | {:error, any()}
  def import_package(%{path: path}) do
    case api("importPackage", %{path: path}) do
      {:ok, true} -> {:ok, nil}
      {:ok, false} -> {:error, "Import package failed"}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Tells anki to reload all data from the database.
  """
  @spec reload_collection() :: {:ok, nil} | {:error, any()}
  def reload_collection do
    api("reloadCollection")
  end
end
