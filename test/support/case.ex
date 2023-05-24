defmodule AnkiConnect.Case do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      use ExUnit.Case

      import AnkiConnect
      import AnkiConnect.Factory
    end
  end
end
