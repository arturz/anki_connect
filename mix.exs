defmodule AnkiConnect.MixProject do
  use Mix.Project

  def project do
    [
      app: :anki_connect,
      version: "0.1.0",
      elixir: "~> 1.13",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Hex
      package: package(),
      description: """
      Seamlessly interact via code or CLI with AnkiConnect, a plugin for the Anki flashcard application.
      """,
      source_url: "https://github.com/arturz/anki_connect",

      # Dialyzer
      dialyzer: [plt_add_apps: [:mix]]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support", "test/factories"]

  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:tesla, "~> 1.4"},
      {:hackney, "~> 1.17"},
      {:jason, ">= 1.0.0"},
      {:ex_doc, "~> 0.27", only: :dev, runtime: false},
      {
        :dialyxir,
        "~> 1.3",
        only: [:dev], runtime: false
      },
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:ex_machina, "~> 2.7.0"}
    ]
  end

  defp package do
    [
      maintainers: ["Artur Ziętkiewicz"],
      licenses: ["MIT"],
      files: ~w(lib mix.exs README.md LICENSE),
      links: %{
        GitHub: "https://github.com/arturz/anki_connect"
      }
    ]
  end
end
