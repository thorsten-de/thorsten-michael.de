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
alias Tmde.Content.Translation

translation_mapper = fn obj, field ->
  Map.update(
    obj,
    field,
    [],
    Translation.translations(&1)
  )
end

skill_mapper = fn
  %{} = skill ->
    translation_mapper.(skill, :label)

  {name, translations} ->
    %{
      name: name,
      label: Enum.map(translations, translation_mapper)
    }

  name ->
    %{name: name}
end

my_skillset =
  [
    {"C#", %{rating: 1}},
    {"SQL", %{rating: 1}},
    {"Elixir", %{rating: 1}},
    {"Phoenix", %{rating: 2}},
    {"GraphQL", %{rating: 2}},
    {"Ruby", %{rating: 2}},
    {"Rails", %{rating: 2}},
    {"REST", %{rating: 3}},
    {"JS", %{rating: 2}},
    {"HTML", %{rating: 2}},
    {"CSS", %{rating: 2}},
    {"Elm", %{rating: 3}},
    {"PHP", %{rating: 3}},
    {"Shopware", %{rating: 3}},
    {"Vue", %{rating: 3}},
    {"Docker", %{rating: 3}},
    {"Linux", %{rating: 2}},
    {%{type: :language, name: "Deutsch", label: [de: "Deutsch", en: "German"]},
     %{rating: 1, rating_text: [de: "Muttersprache", en: "native speaker"]}},
    {%{type: :language, name: "English", label: [de: "Englisch", en: "English"]},
     %{rating: 3, rating_text: [de: "B2", en: "B2 (upper-intermediate)"]}}
  ]
  |> Enum.map(fn {skill, rating} ->
    {:ok, skill} =
      skill
      |> skill_mapper.()
      |> Jobs.create_skill()

    {skill, rating}
  end)

{:ok, myself} =
  Jobs.create_job_seeker(%{
    contact: %{
      title: "Dipl.-Inf.",
      first_name: "Thorsten-Michael",
      last_name: "Deinert",
      gender: :male,
      email: "postmaster@thorsten-michael.de",
      address: %{street: "Mustergasse 1", zip: "55555", city: "Hauptstadt"}
    },
    links: [
      %{type: :phone, target: "+49 0001 0002 0003"},
      %{type: :mobile, target: "+49 0001 0002 0003"},
      %{type: :whatsapp, target: "+49 0001 0002 0003"},
      %{type: :website, target: "thorsten-michael.de"},
      %{type: :email, target: "postmaster@thorsten-michael.de"}
    ],
    skills:
      my_skillset
      |> Enum.map(fn {skill, rating} ->
        rating
        |> translation_mapper.(:rating_text)
        |> Map.merge(%{skill_id: skill.id})
      end)
      |> IO.inspect(label: "Skillset")
  })
