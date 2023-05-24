defmodule AnkiConnect.Actions.MiscellaneousTest do
  use AnkiConnect.Case

  import AnkiConnect

  describe "request_permission/0" do
    test "user is able to request permission to use the API exposed by AnkiConnect" do
      {:ok, result} = request_permission()
      assert Map.has_key?(result, "permission")
      assert Enum.member?(["granted", "denied"], result["permission"])
    end
  end

  describe "version/0" do
    test "user is able to check version of the API exposed by AnkiConnect plugin" do
      {:ok, version} = version()
      assert is_integer(version)
    end
  end

  describe "api_reflect/1" do
    test "user is able to get information about the AnkiConnect APIs available" do
      param = %{scopes: ["actions"], actions: ["apiReflect"]}
      {:ok, result} = api_reflect(param)
      assert Map.has_key?(result, "scopes")
      assert Map.has_key?(result, "actions")
      assert is_list(result["scopes"])
      assert is_list(result["actions"])
    end
  end

  describe "sync/0" do
    test "user is able to sync" do
      {:ok, nil} = sync()
    end
  end

  describe "get_profiles/0" do
    test "user is able to list profiles" do
      {:ok, profiles} = get_profiles()
      assert is_list(profiles)
      assert length(profiles) > 0
    end
  end

  describe "multi/1" do
    test "user is able to run multiple actions at once" do
      param = %{
        actions: [
          %{
            action: "deckNames",
            version: 6
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

      {:ok, result} = multi(param)
      assert is_list(result)
      assert length(result) == 2

      assert Enum.all?(result, fn response ->
               Map.has_key?(response, "result") or Map.has_key?(response, "error")
             end)
    end
  end
end
