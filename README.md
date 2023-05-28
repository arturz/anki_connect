# AnkiConnect

Elixir-AnkiConnect is a powerful Elixir library that provides a convenient and elegant way to interact with the AnkiConnect extension for Anki, a popular spaced repetition flashcard application. This library encapsulates the complexities of communicating with AnkiConnect, allowing developers to effortlessly create functions for various Anki operations within their Elixir applications.

# Features

- **Simplified AnkiConnect Interaction**: Elixir-AnkiConnect abstracts away the intricacies of working with the AnkiConnect API, providing a clean and intuitive interface for invoking Anki operations.
- **CLI Tasks**: In addition to the Elixir function generation, Elixir-AnkiConnect provides command-line interface (CLI) tasks that allow you to interact with AnkiConnect directly from the command line.
- **Error Handling**: The library handles errors gracefully, providing meaningful error messages and ensuring a robust and reliable integration with AnkiConnect.

# Installation

**Note**: Before using Elixir-AnkiConnect, ensure that you have the AnkiConnect extension installed and activated in your Anki application. AnkiConnect provides the necessary API for communication with Anki. Instructions on how to install and activate the AnkiConnect extension can be found in the [Anki documentation](https://ankiweb.net/shared/info/2055492159) or on the official [AnkiConnect website](https://foosoft.net/projects/anki-connect/).

## Elixir library

To use AnkiConnect in your Elixir project, simply add it as a dependency in your `mix.exs` file:

```elixir
defp deps do
  [
    {:anki_connect, "~> 0.1.1"}
  ]
end
```

After updating your `mix.exs` file, run `mix deps.get` to fetch the library.

## Command-line Interface (CLI)

To use Elixir-AnkiConnect as a standalone CLI tool, you can install it globally using mix archive. Ensure you have Elixir and Mix installed on your system, and then run the following command:

```shell
mix archive.install hex anki_connect
```

This command will download and install the Elixir-AnkiConnect archive globally on your system.

Once installed, you can execute the CLI tasks using the `mix anki_connect ...` command. For example:

```shell
mix anki_connect add_notes_from_file --file="words.md" --deck="TEST DECK"
```

# Contributions and Support

Contributions, bug reports, and feature requests are welcome! If you encounter any issues or have any questions about using AnkiConnect, please feel free to [open an issue](https://github.com/arturz/anki_connect/issues/new/choose) on the GitHub repository.

# License

Elixir AnkiConnect is licensed under the MIT License. See the [LICENSE](https://github.com/arturz/anki_connect/blob/main/LICENSE) file for more details.
