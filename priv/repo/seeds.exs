# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Tmde.Repo.insert!(%Tmde.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Tmde.Repo
alias Tmde.Jobs

translation_mapper = fn {lang, text} -> %{lang: lang, content: text} end

skill_mapper = fn
  {type, name, translations} ->
    %{
      type: type,
      name: name,
      label: Enum.map(translations, translation_mapper)
    }

  {name, translations} ->
    %{
      name: name,
      label: Enum.map(translations, translation_mapper)
    }

  name ->
    %{name: name}
end

skills = [
  "C#",
  "SQL",
  "Elixir",
  "Phoenix",
  "GraphQL",
  "Ruby",
  "Rails",
  "REST",
  "JS",
  "HTML",
  "CSS",
  "Elm",
  "PHP",
  "Shopware",
  "Vue",
  "Docker",
  "Linux",
  "Nginx",
  {:language, "Deutsch", de: "Deutsch", en: "German"},
  {:language, "English", de: "Englisch", en: "English"}
]

skills
|> Enum.map(skill_mapper)
|> Enum.map(&Jobs.create_skill/1)
