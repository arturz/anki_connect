defmodule AnkiConnect.Utils.MapUtilsTest do
  use AnkiConnect.Case

  alias AnkiConnect.Utils.MapUtils

  describe "convert_keys_to_camel_case_strings/1" do
    test "converts map with snake_case keys to camelCase keys" do
      map = %{
        first_name: "John",
        last_name: "Doe",
        address: %{
          street_name: "123 Main St",
          postal_code: "12345"
        },
        id: "1",
        start_id: "1",
        Back: "Back",
        Front: "Front"
      }

      expected = %{
        "firstName" => "John",
        "lastName" => "Doe",
        "address" => %{
          "streetName" => "123 Main St",
          "postalCode" => "12345"
        },
        "id" => "1",
        "startID" => "1",
        "Back" => "Back",
        "Front" => "Front"
      }

      assert MapUtils.convert_keys_to_camel_case_strings(map) == expected
    end

    test "converts nested maps with snake_case keys to camelCase keys" do
      map = %{
        person: %{
          first_name: "John",
          last_name: "Doe",
          address: %{
            street_name: "123 Main St",
            postal_code: "12345"
          }
        }
      }

      expected = %{
        "person" => %{
          "firstName" => "John",
          "lastName" => "Doe",
          "address" => %{
            "streetName" => "123 Main St",
            "postalCode" => "12345"
          }
        }
      }

      assert MapUtils.convert_keys_to_camel_case_strings(map) == expected
    end

    test "converts lists of maps with snake_case keys to camelCase keys" do
      map = %{
        users: [
          %{
            first_name: "John",
            last_name: "Doe"
          },
          %{
            first_name: "Jane",
            last_name: "Smith"
          }
        ]
      }

      expected = %{
        "users" => [
          %{
            "firstName" => "John",
            "lastName" => "Doe"
          },
          %{
            "firstName" => "Jane",
            "lastName" => "Smith"
          }
        ]
      }

      assert MapUtils.convert_keys_to_camel_case_strings(map) == expected
    end

    test "ignores list of numbers" do
      assert MapUtils.convert_keys_to_camel_case_strings(%{
               numbers: [1, 2, 3]
             }) == %{
               "numbers" => [1, 2, 3]
             }
    end
  end

  describe "maybe_add_field/3" do
    test "puts a value into a map if the value is not nil" do
      map = %{a: 1}
      key = :b
      value = 2

      result = MapUtils.maybe_add_field(map, key, value)

      # Original map remains unchanged
      assert map == %{a: 1}
      # New map includes the key-value pair
      assert result == %{a: 1, b: 2}
    end

    test "returns the map as is if the value is nil" do
      map = %{a: 1}
      key = :b
      value = nil

      result = MapUtils.maybe_add_field(map, key, value)

      # Original map remains unchanged
      assert map == %{a: 1}
      # New map is the same as the original map
      assert result == %{a: 1}
    end
  end

  describe "camel_to_snake_case_atom/1" do
    test "converts camelCase string to snake_case atom and ignores the first letter" do
      assert MapUtils.camel_to_snake_case_atom("myVariableName") == :my_variable_name
      assert MapUtils.camel_to_snake_case_atom("MyVariableName") == :My_variable_name
    end

    test "converts camelCase atom to snake_case atom and ignores the first letter" do
      assert MapUtils.camel_to_snake_case_atom(:myVariableName) == :my_variable_name
      assert MapUtils.camel_to_snake_case_atom(:MyVariableName) == :My_variable_name
    end
  end
end
