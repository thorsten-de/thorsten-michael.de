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
alias Tmde.Jobs
alias Jobs.Skill
alias Jobs.PersonalSkill, as: MySkill

t = fn list -> list |> Tmde.Content.Translation.translations() end

my_skillsets =
  [
    languages: [
      %{
        skill: %{
          type: :language,
          name: "Deutsch",
          label: t.(de: "Deutsch", en: "German")
        },
        rating: 100,
        rating_text: t.(de: "Muttersprache", en: "native speaker")
      },
      %{
        skill: %{
          type: :language,
          name: "English",
          label: t.(de: "Englisch", en: "English")
        },
        rating: 70,
        rating_text: t.(de: "B2", en: "B2")
      }
    ],
    featured: [
      %{
        skill: %{
          name: "C# Application Development",
          icon: "brands/windows",
          label:
            t.(
              de: "C#/.NET Anwendungen",
              en: "C#/.NET Applications"
            )
        },
        rating: 84
      },
      %{
        skill: %{
          name: "SQL Databases",
          icon: "database",
          label:
            t.(
              de: "SQL / Datenbanken",
              en: "SQL / Databases"
            )
        },
        rating: 87
      },
      %{
        skill: %{
          name: "Elixir/Phoenix",
          icon: "brands/phoenix-framework",
          label: t.(de: "Elixir / Phoenix")
        },
        rating: 80
      },
      %{
        skill: %{
          name: "Ruby on Rails",
          icon: "gem",
          label:
            t.(
              de: "Ruby / Rails",
              en: "Ruby on Rails"
            )
        },
        rating: 75
      },
      %{
        skill: %{
          name: "PHP/Shopware",
          icon: "brands/shopware",
          label:
            t.(
              de: "PHP / Shopware",
              en: "PHP / Shopware"
            )
        },
        rating: 55
      }
    ]
  ]
  |> Enum.flat_map(fn {category, skills} ->
    skills
    |> Enum.with_index()
    |> Enum.map(fn {item, idx} ->
      Map.merge(item, %{category: category, sort_order: 1000 + idx * 100})
    end)
  end)
  |> Enum.map(fn %{skill: skill} = my_skill ->
    {:ok, skill} = Jobs.create_skill(skill)
    Map.put(my_skill, :skill_id, skill.id)
  end)

case Jobs.create_job_seeker(%{
       contact: %{
         title: "Dipl.-Inf.",
         first_name: "Thorsten-Michael",
         last_name: "Deinert",
         gender: :male,
         email: "postmaster@thorsten-michael.de",
         address: %{street: "Mustergasse 1", zip: "55555", city: "Hauptstadt"}
       },
       dob: ~D[2000-02-29],
       place_of_birth: "Irgendwo",
       marital_status: :married,
       citizenship: "Europe",
       links: [
         %{type: :phone, target: "+49 0001 0002 0003"},
         %{type: :mobile, target: "+49 0001 0002 0003"},
         %{type: :whatsapp, target: "+49 0001 0002 0003"},
         %{type: :website, target: "thorsten-michael.de"},
         %{type: :email, target: "postmaster@thorsten-michael.de"}
       ],
       skills: my_skillsets
     }) do
  {:ok, myself} ->
    IO.inspect(myself)

  {:error, changeset} ->
    IO.inspect(Ecto.Changeset.traverse_errors(changeset, fn {msg, _} -> msg end))
end
