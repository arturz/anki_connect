defmodule AnkiConnectTest do
  use AnkiConnect.Case

  test "delegates actions functions" do
    assert length(AnkiConnect.__info__(:functions)) > 0
  end
end
