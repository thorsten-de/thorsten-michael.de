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
alias Jobs.Skill
alias Jobs.PersonalSkill, as: MySkill

alias Tmde.Jobs.{JobSeeker, Application, CV}
alias Tmde.Contacts.{Contact, Link, Address}
alias Tmde.Accounts

import Tmde.Content.Translation, only: [translations: 1]
t = &translations/1

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
    ],
    prog_langs: [
      %{
        skill: %{
          name: "C#"
        },
        is_featured: true,
        rating: 85
      },
      %{
        skill: %{
          name: "Elixir"
        },
        is_featured: true,
        rating: 85
      },
      %{
        skill: %{
          name: "Ruby"
        },
        is_featured: true,
        rating: 80
      },
      %{
        skill: %{
          name: "JavaScript",
          icon: "brands/js"
        },
        rating: 70
      },
      %{
        skill: %{
          name: "PHP",
          icon: "brands/php"
        },
        rating: 70
      },
      %{
        skill: %{
          name: "Elm"
        },
        rating: 55
      },
      %{
        skill: %{
          name: "F#"
        },
        rating: 50
      },
      %{
        skill: %{
          name: "java",
          icon: "brands/java"
        },
        rating: 40
      },
      %{
        skill: %{
          name: "Python",
          icon: "brands/python"
        },
        rating: 40
      },
      %{
        skill: %{
          name: "Rust",
          icon: "brands/rust"
        },
        rating: 35
      },
      %{
        skill: %{
          name: "Haskell"
        },
        rating: 25
      },
      %{
        skill: %{
          name: "Delphi"
        },
        rating: 25
      }
    ],
    techs: [
      %{
        skill: %{
          name: ".NET"
        },
        rating: 75
      },
      %{
        skill: %{
          name: "WinForms"
        },
        rating: 75
      },
      %{
        skill: %{
          name: "WPF/XAML"
        },
        rating: 75
      },
      %{
        skill: %{
          name: "HTML",
          icon: "brands/html5"
        },
        rating: 78
      },
      %{
        skill: %{
          name: "CSS",
          icon: "brands/css3"
        },
        rating: 75
      },
      %{
        skill: %{
          name: "SCSS",
          icon: "brands/sass"
        },
        rating: 75
      },
      %{
        skill: %{
          name: "GraphQL"
        },
        rating: 70
      },
      %{
        skill: %{
          name: "Phoenix",
          icon: "brands/phoenix-framework"
        },
        rating: 82
      },
      %{
        skill: %{
          name: "Rails",
          icon: "gem"
        },
        rating: 75
      },
      %{
        skill: %{
          name: "Padrino",
          icon: "gem"
        },
        rating: 70
      },
      %{
        skill: %{
          name: "Git",
          icon: "brands/github"
        },
        rating: 75
      },
      %{
        skill: %{
          name: "Docker",
          icon: "brands/docker"
        },
        rating: 60
      },
      %{
        skill: %{
          name: "Shopware",
          icon: "brands/shopware"
        },
        rating: 60
      },
      %{
        skill: %{
          name: "Vue.js",
          icon: "brands/vuejs"
        },
        rating: 55
      },
      %{
        skill: %{
          name: "React",
          icon: "brands/react"
        },
        rating: 45
      },
      %{
        skill: %{
          name: "MySQL"
        },
        rating: 80
      },
      %{
        skill: %{
          name: "PostreSQL"
        },
        rating: 75
      },
      %{
        skill: %{
          name: "Linux",
          icon: "brands/linux"
        },
        rating: 75
      },
      %{
        skill: %{
          name: "Nginx"
        },
        rating: 70
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

myself =
  case Accounts.create_user(%{
         contact: %{
           title: "Dipl.-Inf.",
           first_name: "Thorsten-Michael",
           last_name: "Deinert",
           gender: :male,
           email: "postmaster@thorsten-michael.de",
           address: %{street: "Mustergasse 1", zip: "55555", city: "Hauptstadt"}
         },
         slogan:
           t.(
             de:
               "Software-Entwickler aus Leidenschaft, Diplom-Informatiker und immer neugierig auf Programmiersprachen",
             en:
               "Passionate about software development, computer science and programming languages"
           ),
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
      changeset
  end

default_application = %Application{
  job_seeker: myself,
  subject: "Bewerbung als Software-Entwickler bei...",
  contact: %Contact{
    gender: :female,
    email: "thorsten.deinert@udo.edu",
    first_name: "Marianne",
    last_name: "Mustermann",
    address: %{street: "Hauptstraße 2", zip: "49999", city: "Musterhausen"}
  },
  cv_entries: [
    %CV.Entry{
      type: :job,
      from: ~D[2006-09-26],
      sort_order: 1,
      icon: "/images/Barbara_Reisen_Logo.svg",
      role:
        translations(
          de: "Full-Stack Software-Entwickler",
          en: "Full-Stack Software Developer"
        ),
      description:
        translations([
          {:de, :markdown,
           """
           Als Student habe ich die **interne Buchungssoftware** geschrieben und die IT mitgestaltet. Seit Abschluss des
           Studiums bin ich als Allrounder verantwortlich für die **Software-Entwicklung**, die **Webseite**, den
           **täglichen IT-Betrieb** und die **Netzwerkinfrastruktur**. Die Schwerpunkte im Detail:
           """}
        ]),
      focuses: [
        %CV.Focus{
          sort_order: 1,
          abstract:
            translations(
              de: """
                <p>Planung, Design, Implementierung und kontinuierliche Weiterentwicklung des internen
                Buchungssystems als <strong>Client/Server-Anwendung für Windows mit C#/.NET</strong>.
                <br><small>(im Betrieb seit 06/2007)</small>
              """
            )
        },
        %CV.Focus{
          sort_order: 2,
          abstract:
            translations(
              de: """
              <p>Anpassen und Umgestalten der Webseite (PHP), ab 2011 als Online-Buchungsseite mit
              Authoring/CMS-System in <strong>Ruby/Rails</strong> neu gestaltet, implementiert und via
              REST-Schnitstelle ans Buchungssystem angebunden.
              <br><small>(<a href="https://www.barbara-reisen.de">barbara-reisen.de</a>, online seit 2014)</small>
              """
            )
        },
        %CV.Focus{
          sort_order: 3,
          abstract:
            translations(
              de:
                Earmark.as_html!("""
                  Ab 2016: Neues **Elixir/Phoenix/GraphQL-Backend** mit **LiveView-Frontend**,
                  um Webseite und Buchungsystem langfristig zu integrieren.
                """)
            )
        },
        %CV.Focus{
          sort_order: 4,
          abstract:
            translations(
              de:
                Earmark.as_html!("""
                  Konzeption, Administration und Betrieb des Firmennetzwerks, der Domains, Web/Mailserver
                  und weiterer Seiten, z.B. des [Gesundheitsblogs](https://www.barbara-reisen.de/blog).
                """)
            )
        }
      ],
      company: %{
        name: "Barbara Reisen",
        location: "Reiseveranstalter in Selm, NRW",
        sector:
          translations(
            de: "Reiseveranstalter / Kuren und Wellness",
            en: "Tour operator / cures and wellness"
          )
      }
    },
    %CV.Entry{
      type: :job,
      from: ~D[2016-06-01],
      sort_order: 2,
      icon: "/images/T-Cosmetic_Logo.svg",
      role:
        translations(
          de: "Full-Stack Software-Entwickler (Nebenjob)",
          en: "Full-Stack Software Developer"
        ),
      description:
        translations(
          de:
            Earmark.as_html!("""
            Bei T-Cosmetic wird Standardsoftware an den Direktvertrieb mit **Multi-Level-Marketing (MLM)**
            angepasst oder speziell dafür entwickelt.  Neben der **Beratung** beinhaltet meine Arbeit:
            """)
        ),
      focuses: [
        %CV.Focus{
          sort_order: 1,
          abstract:
            translations(
              de: """
              Entwurf und Entwicklung des Systems zur <strong>strukturellen Abrechnung von MLM-Provisionen/Boni</strong>
              auf Daten einer Legacy-Software. Implementiert in <strong>Elixir/Phoenix/GraphQL</strong>.
              <br><small>(im Produktivbetrieb seit 01/2017)</small>
              """
            )
        },
        %CV.Focus{
          sort_order: 2,
          abstract:
            translations(
              de:
                Earmark.as_html!("""
                  Entwicklung von **Plugins für Shopware 5/6** in **PHP** für MLM im Webshop. Erweiterung des Datenmodells
                  und Backends (**Vue.js**) von Shopware 6, um die Legacy-Software abzulösen.
                """)
            )
        },
        %CV.Focus{
          sort_order: 3,
          abstract:
            translations(
              de:
                Earmark.as_html!("""
                  Darstellung der aktuellen Struktur-Umsätze und Historie, im Web als **Elm-Frontend** in
                  der Storefront eingebettet. Datenaustausch mit dem internen Bonussystem über **GraphQL** Schnitstelle.
                """)
            )
        }
      ],
      company: %{
        name: "T-Cosmetic International",
        location: "Hamm, NRW",
        sector:
          translations(
            de: "Parfüm, Kosmetik und Nahrungsergänzung",
            en: "perfumes, cosmetics and nutritional supplements"
          )
      }
    },
    %CV.Entry{
      type: :education,
      from: ~D[2002-10-01],
      until: ~D[2010-10-19],
      sort_order: 1,
      icon: "/images/TU_Dortmund_Logo_small.svg",
      role:
        translations(
          de: "Diplom im Studiengang Informatik",
          en: "Computer Science (Diploma)"
        ),
      focuses: [
        %CV.Focus{
          sort_order: 1,
          abstract:
            translations(
              de: """
                Schwerpunktgebiet: <strong class="has-text-primary">Intelligente Systeme</strong>
              """
            )
        },
        %CV.Focus{
          sort_order: 2,
          abstract:
            translations(
              de:
                Earmark.as_html!("""
                  Nebenfach: Betriebswirtschaftslehre
                """)
            )
        },
        %CV.Focus{
          sort_order: 3,
          abstract:
            translations(
              de: """
              Diplomarbeit <span class="tag">sehr gut (1,1)</span>
              <br><a class="is-block py-2" href="https://thorsten-michael.de/documents/Deinert_T---Tempoerkennung---[Masterthesis]---2010.pdf">
                <span class="icon">
                  <i class="fa-solid fa-file-pdf"></i>
                </span>
                <span>Tempoerkennung aus Audiosignalen langsamer Musikstücke</span>
              </a>

                <ul class="mt-0 mb-3">
                  <li>Signalverarbeitung, Merkmalsextraktion, Klassifikation in <strong>F#/.NET</strong></li>
                  <li><strong>C#/WPF-Anwendung</strong> zur Steuerung und Visualierung</li>
                </ul>
                <p>Auszugsweise in Englisch als Paper bei der AES:
                  <a href="http://www.aes.org/e-lib/browse.cfm?elib=1596">Regression-Based Tempo Recognition from Chroma and Energy Accents for Slow Audio Recordings</a>.
                </p>
              """
            )
        }
      ],
      company: %{
        name: "Technische Universität Dortmund",
        location: "NRW",
        sector:
          translations(
            de: "Universität",
            en: "University"
          )
      }
    },
    %CV.Entry{
      type: :education,
      from: ~D[2001-09-03],
      until: ~D[2002-06-30],
      sort_order: 2,
      role: translations(de: "Zivildienst"),
      focuses: [],
      company: %{
        name: "Arbeiter-Samariter-Bund",
        location: "Hamm, NRW",
        sector:
          translations(
            de: "",
            en: ""
          )
      }
    },
    %CV.Entry{
      type: :education,
      from: ~D[1998-08-01],
      until: ~D[2001-06-30],
      sort_order: 2,
      role:
        translations(
          de: "Abitur (mit Leistungskurs Informatik)",
          en: "Abitur (high school graduation)"
        ),
      focuses: [],
      company: %{
        name: "Friedrich-List-Berufskolleg",
        location: "Hamm, NRW",
        sector:
          translations(
            de: "Sekundarstufe 2",
            en: "Höhere Handelsschule"
          )
      }
    }
  ]
}

Repo.insert!(default_application)
