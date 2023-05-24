defmodule AnkiConnect.Actions.Model do
  @moduledoc """
  Model actions.

  All functions are delegated inside `AnkiConnect` module, so you should import them from there.
  """

  import AnkiConnect.Client
  import AnkiConnect.Utils.MapUtils

  @doc """
  Gets the complete list of model names for the current user.

  ### Sample result:
  ```
  {:ok, ["Basic", "Basic (and reversed card)", "Cloze"]}
  ```
  """
  @spec model_names() :: {:ok, [String.t()]} | {:error, any()}
  def model_names do
    api("modelNames")
  end

  @doc """
  Gets the complete list of model names and their corresponding IDs for the current user.

  ### Sample result:
  ```
  %{
    "Basic" => 1483883011648,
    "Basic (and reversed card)" => 1483883011644,
    "Basic (optional reversed card)" => 1483883011631,
    "Cloze" => 1483883011630
  }
  ```
  """
  @spec model_names_and_ids() :: {:ok, map()} | {:error, any()}
  def model_names_and_ids do
    api("modelNamesAndIds")
  end

  @doc """
  Gets the complete list of field names for the provided model name.

  ### Sample param:
  ```
  %{
    model_name: "Basic"
  }
  ```

  ### Sample result:
  ```
  {:ok, ["Front", "Back"]}
  ```
  """
  @spec model_field_names(%{model_name: String.t()}) ::
          {:ok, [String.t()]} | {:error, any()}
  def model_field_names(%{model_name: model_name}) do
    api("modelFieldNames", %{model_name: model_name})
  end

  @doc """
  Gets the complete list of field descriptions (the text seen in the gui editor when a field is empty) for the provided model name.

  ### Sample param:
  ```
  %{
    model_name: "Basic"
  }
  ```

  ### Sample result:
  ```
  {:ok, ["", ""]}
  ```
  """
  @spec model_field_descriptions(%{model_name: String.t()}) ::
          {:ok, [String.t()]} | {:error, any()}
  def model_field_descriptions(%{model_name: model_name}) do
    api("modelFieldDescriptions", %{model_name: model_name})
  end

  @doc """
  Gets the complete list of fonts along with their font sizes.

  ### Sample param:
  ```
  %{
    model_name: "Basic"
  }
  ```

  ### Sample result:
  ```
  %{
    "Front" => {
      "font" => "Arial",
      "size" => 20
    },
    "Back" => {
      "font" => "Arial",
      "size" => 20
    }
  }
  ```
  """
  @spec model_field_fonts(%{model_name: String.t()}) ::
          {:ok, map()} | {:error, any()}
  def model_field_fonts(%{model_name: model_name}) do
    api("modelFieldFonts", %{model_name: model_name})
  end

  @doc """
  Returns an object indicating the fields on the question and answer side of each card template for the given model name.

  The question side is given first in each array.

  ### Sample param:
  ```
  %{
    model_name: "Basic (and reversed card)"
  }
  ```

  ### Sample result:
  ```
  %{
    "Card 1" => [["Front"], ["Back"]],
    "Card 2" => [["Back"], ["Front"]]
  }
  ```
  """
  @spec model_fields_on_templates(%{model_name: String.t()}) ::
          {:ok, map()} | {:error, any()}
  def model_fields_on_templates(%{model_name: model_name}) do
    api("modelFieldsOnTemplates", %{model_name: model_name})
  end

  @doc """
  Creates a new model to be used in Anki.

  User must provide the `model_name`, `in_order_fields` and `card_templates` to be used in the model.

  There are optional fields `ccs` and `is_cloze`. If not specified, `css` will use the default Anki css and `is_cloze` will be equal to `false`. If `is_cloze` is `true` then model will be created as Cloze.

  Optionally the `Name` field can be provided for each entry of `card_templates`. By default the card names will be Card 1, Card 2, and so on.

  ### Sample param:
  ```
  %{
    model_name: "newModelName",
    in_order_fields: ["Field1", "Field2", "Field3"],
    css: "Optional CSS with default to builtin css",
    is_cloze: false,
    card_templates: [
      {
        Name: "My Card 1",
        Front: "Front html {{Field1}}",
        Back: "Back html  {{Field2}}"
      }
    ]
  }
  ```

  ### Sample result:
  ```
  %{
    "sortf" => 0,
    "did" => 1,
    "latexPre" => "\\documentclass[12pt]{article}\n\\special{papersize=3in,5in}\n\\usepackage[utf8]{inputenc}\n\\usepackage{amssymb,amsmath}\n\\pagestyle{empty}\n\\setlength{\\parindent}{0in}\n\\begin{document}\n",
    "latexPost" => "\\end{document}",
    "mod" => 1551462107,
    "usn" => -1,
    "vers" => [],
    "type" => 0,
    "css" => ".card {\n font-family: arial;\n font-size: 20px;\n text-align: center;\n color: black;\n background-color: white;\n}\n",
    "name" => "TestApiModel",
    "flds" => [
      %{
        "name" => "Field1",
        "ord" => 0,
        "sticky" => false,
        "rtl" => false,
        "font" => "Arial",
        "size" => 20,
        "media" => []
      },
      %{
        "name" => "Field2",
        "ord" => 1,
        "sticky" => false,
        "rtl" => false,
        "font" => "Arial",
        "size" => 20,
        "media" => []
      }
    ],
    "tmpls" => [
      %{
        "name" => "My Card 1",
        "ord" => 0,
        "qfmt" => "",
        "afmt" => "This is the back of the card {{Field2}}",
        "did" => null,
        "bqfmt" => "",
        "bafmt" => ""
      }
    ],
    "tags" => [],
    "id" => 1551462107104,
    "req" => [
      [
        0,
        "none",
        []
      ]
    ]
  }
  ```
  """
  @spec create_model(%{
          model_name: String.t(),
          in_order_fields: [String.t()],
          card_templates: [map()],
          css: String.t() | nil,
          is_cloze: boolean() | nil
        }) :: {:ok, map()} | {:error, any()}
  def create_model(
        %{
          model_name: model_name,
          in_order_fields: in_order_fields,
          card_templates: card_templates
        } = param
      ) do
    css = Map.get(param, :css)
    is_cloze = Map.get(param, :is_cloze)

    api(
      "createModel",
      %{
        model_name: model_name,
        in_order_fields: in_order_fields,
        card_templates: card_templates
      }
      |> maybe_add_field(:css, css)
      |> maybe_add_field(:is_cloze, is_cloze)
    )
  end

  @doc """
  Returns an object indicating the template content for each card connected to the provided model by name.

  #### Sample param:
  ```
  %{
    model_name: "Basic (and reversed card)"
  }
  ```

  #### Sample result:
  ```
  %{
    "Card 1" => {
      "Front" => "{{Front}}",
      "Back" => "{{FrontSide}}\n\n<hr id=answer>\n\n{{Back}}"
    },
    "Card 2" => {
      "Front" => "{{Back}}",
      "Back" => "{{FrontSide}}\n\n<hr id=answer>\n\n{{Front}}"
    }
  },
  ```
  """
  @spec model_templates(%{model_name: String.t()}) ::
          {:ok, map()} | {:error, any()}
  def model_templates(%{model_name: model_name}) do
    api("modelTemplates", %{model_name: model_name})
  end

  @doc """
  Gets the CSS styling for the provided model by name.

  #### Sample param:
  ```
  %{
    model_name: "Basic (and reversed card)"
  }
  ```

  ### Sample result:
  ```
  %{
     "css" => ".card {\n font-family: arial;\n font-size: 20px;\n text-align: center;\n color: black;\n background-color: white;\n}\n"
  }
  ```
  """
  @spec model_styling(%{model_name: String.t()}) ::
          {:ok, map()} | {:error, any()}
  def model_styling(%{model_name: model_name}) do
    api("modelStyling", %{model_name: model_name})
  end

  @doc """
  Modify the templates of an existing model by name.

  Only specifies cards and specified sides will be modified. If an existing card or side is not included in the request, it will be left unchanged.

  ### Sample param:
  ```
  %{
    model: {
      name: "Custom",
      templates: {
        "Card 1" => {
          Front: "{{Question}}?",
          Back: "{{Answer}}!"
        }
      }
    }
  }
  ```

  ### Sample result:
  ```
  {:ok, nil}
  ```
  """
  @spec update_model_templates(%{model: %{name: String.t(), templates: map()}}) ::
          {:ok, nil} | {:error, any()}
  def update_model_templates(%{model: %{name: name, templates: templates}}) do
    api("updateModelTemplates", %{model: %{name: name, templates: templates}})
  end

  @doc """
  Modify the CSS styling of an existing model by name.

  ### Sample param:
  ```
  %{
    model: {
      name: "Custom",
      css: "p { color: blue; }"
    }
  }
  ```

  ### Sample result:
  ```
  {:ok, nil}
  ```
  """
  @spec update_model_styling(%{model: %{name: String.t(), css: String.t()}}) ::
          {:ok, nil} | {:error, any()}
  def update_model_styling(%{model: %{name: name, css: css}}) do
    api("updateModelStyling", %{model: %{name: name, css: css}})
  end

  @doc """
  Find and replace string in existing model by model name.

  Customise to replace in front, back or css by setting to true/false.

  ### Sample param:
  ```
  %{
    model: {
      model_name: "Custom",
      find_text: "find",
      replace_text: "replace",
      Front: true,
      Back: true,
      css: true
    }
  }
  ```

  ### Sample result:
  ```
  {:ok, 1}
  ```
  """
  @spec find_and_replace_in_models(%{
          model: %{
            model_name: String.t(),
            find_text: String.t(),
            replace_text: String.t(),
            Front: boolean() | nil,
            Back: boolean() | nil,
            css: boolean() | nil
          }
        }) :: {:ok, integer()} | {:error, any()}
  def find_and_replace_in_models(
        %{model: %{model_name: model_name, find_text: find_text, replace_text: replace_text}} =
          param
      ) do
    front = Map.get(param, :Front, false)
    back = Map.get(param, :Back, false)
    css = Map.get(param, :css, false)

    api("updateModelStyling", %{
      model_name: model_name,
      find_text: find_text,
      replace_text: replace_text,
      Front: front,
      Back: back,
      css: css
    })
  end

  @doc """
  Renames a template in an existing model.

  ### Sample param:
  ```
  %{
    model_name: "Basic",
    old_template_name: "Card 1",
    new_template_name: "Card 1 renamed"
  }
  ```

  ### Sample result:
  ```
  {:ok, nil}
  ```
  """
  @spec model_template_rename(%{
          model_name: String.t(),
          old_template_name: String.t(),
          new_template_name: String.t()
        }) :: {:ok, nil} | {:error, any()}
  def model_template_rename(%{
        model_name: model_name,
        old_template_name: old_template_name,
        new_template_name: new_template_name
      }) do
    api("modelTemplateRename", %{
      model_name: model_name,
      old_template_name: old_template_name,
      new_template_name: new_template_name
    })
  end

  @doc """
  Repositions a template in an existing model.

  The value of `index` starts at 0. For example, an index of `0` puts the template in the first position, and an index of `2` puts the template in the third position.

  ### Sample param:
  ```
  %{
    model_name: "Basic",
    template_name: "Card 1",
    index: 1
  }
  ```

  ### Sample result:
  ```
  {:ok, nil}
  ```
  """
  @spec model_template_reposition(%{
          model_name: String.t(),
          template_name: String.t(),
          index: integer()
        }) :: {:ok, nil} | {:error, any()}
  def model_template_reposition(%{
        model_name: model_name,
        template_name: template_name,
        index: index
      }) do
    api("modelTemplateReposition", %{
      model_name: model_name,
      template_name: template_name,
      index: index
    })
  end

  @doc """
  Adds a template to an existing model by name.

  If you want to update an existing template, use updateModelTemplates.

  ### Sample param:
  ```
  %{
    model_name: "Basic",
    template: {
      Name: "Card 3",
      Front: "Front html {{Field1}}",
      Back: "Back html {{Field2}}"
    }
  }
  ```

  ### Sample result:
  ```
  {:ok, nil}
  ```
  """
  @spec model_template_add(%{
          model_name: String.t(),
          template: %{name: String.t(), Front: String.t(), Back: String.t()}
        }) :: {:ok, nil} | {:error, any()}
  def model_template_add(%{
        model_name: model_name,
        template: %{name: name, Front: front, Back: back}
      }) do
    api("modelTemplateAdd", %{
      model: %{
        model_name: model_name,
        template: %{
          Name: name,
          Front: front,
          Back: back
        }
      }
    })
  end

  @doc """
  Removes a template from an existing model.
  """
  @spec model_template_remove(%{
          model_name: String.t(),
          template_name: String.t()
        }) :: {:ok, nil} | {:error, any()}
  def model_template_remove(%{
        model_name: model_name,
        template_name: template_name
      }) do
    api("modelTemplateRemove", %{
      model_name: model_name,
      template_name: template_name
    })
  end

  @doc """
  Rename the field name of a given model.
  """
  @spec model_field_rename(%{
          model_name: String.t(),
          old_field_name: String.t(),
          new_field_name: String.t()
        }) :: {:ok, nil} | {:error, any()}
  def model_field_rename(%{
        model_name: model_name,
        old_field_name: old_field_name,
        new_field_name: new_field_name
      }) do
    api("modelFieldRename", %{
      model_name: model_name,
      old_field_name: old_field_name,
      new_field_name: new_field_name
    })
  end

  @doc """
  Reposition the field within the field list of a given model.

  The value of index starts at `0`. For example, an index of `0` puts the field in the first position, and an index of `2` puts the field in the third position.
  """
  @spec model_field_reposition(%{
          model_name: String.t(),
          field_name: String.t(),
          index: integer()
        }) :: {:ok, nil} | {:error, any()}
  def model_field_reposition(%{
        model_name: model_name,
        field_name: field_name,
        index: index
      }) do
    api("modelFieldReposition", %{
      model_name: model_name,
      field_name: field_name,
      index: index
    })
  end

  @doc """
  Creates a new field within a given model.

  Optionally, the `index` value can be provided, which works exactly the same as the index in `model_field_reposition`. By default, the field is added to the end of the field list.
  """
  @spec model_field_add(%{
          model_name: String.t(),
          field_name: String.t(),
          index: integer() | nil
        }) :: {:ok, nil} | {:error, any()}
  def model_field_add(%{
        model_name: model_name,
        field_name: field_name,
        index: index
      }) do
    api("modelFieldAdd", %{
      model: %{model_name: model_name, field_name: field_name, index: index}
    })
  end

  @doc """
  Deletes a field within a given model.
  """
  @spec model_field_remove(%{
          model_name: String.t(),
          field_name: String.t()
        }) :: {:ok, nil} | {:error, any()}
  def model_field_remove(%{
        model_name: model_name,
        field_name: field_name
      }) do
    api("modelFieldRemove", %{
      model_name: model_name,
      field_name: field_name
    })
  end

  @doc """
  Sets the font for a field within a given model.
  """
  @spec model_field_set_font(%{
          model_name: String.t(),
          field_name: String.t(),
          font: String.t()
        }) :: {:ok, nil} | {:error, any()}
  def model_field_set_font(%{
        model_name: model_name,
        field_name: field_name,
        font: font
      }) do
    api("modelFieldSetFont", %{
      model_name: model_name,
      field_name: field_name,
      font: font
    })
  end

  @doc """
  Sets the font size for a field within a given model.
  """
  @spec model_field_set_font_size(%{
          model_name: String.t(),
          field_name: String.t(),
          font_size: integer()
        }) :: {:ok, nil} | {:error, any()}
  def model_field_set_font_size(%{
        model_name: model_name,
        field_name: field_name,
        font_size: font_size
      }) do
    api("modelFieldSetFontSize", %{
      model_name: model_name,
      field_name: field_name,
      font_size: font_size
    })
  end

  @doc """
  Sets the description (the text seen in the gui editor when a field is empty) for a field within a given model.
  """
  @spec model_field_set_description(%{
          model_name: String.t(),
          field_name: String.t(),
          description: String.t()
        }) :: {:ok, nil} | {:error, any()}
  def model_field_set_description(%{
        model_name: model_name,
        field_name: field_name,
        description: description
      }) do
    case api("modelFieldSetDescription", %{
           model_name: model_name,
           field_name: field_name,
           description: description
         }) do
      {:ok, false} ->
        {:error,
         "Cannot set the description. One possible reason is that older versions of Anki (2.1.49 and below) do not have field descriptions."}

      {:ok, _} ->
        {:ok, nil}

      {:error, error} ->
        {:error, error}
    end
  end
end
