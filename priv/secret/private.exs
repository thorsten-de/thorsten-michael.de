defmodule Private do
  alias Tmde.Contacts.{Contact, Link, Address}

  def sender, do: %Contact{
    title: "Diplom-Informatiker",
    first_name: "Thorsten-Michael",
    last_name: "Deinert",
    gender: :male,

    email: "jobs@thorsten-michael.de",
    address: %Address{street: "Geschwister-Scholl-Str. 13", zip: "59348", city:  "Lüdinghausen"},
    links: [
      %Link{type: :phone, target: "+49 2591 2 598 598"},
      %Link{type: :mobile, target: "+49 1575 901 3374"},
      %Link{type: :whatsapp, target: "+49 1575 901 3374"},
      %Link{type: :website, target: "thorsten-michael.de"},
      %Link{type: :email, target: "jobs@thorsten-michael.de"}
    ],
  }

  def application, do: %{
    code: "X12111",
    me: %{dob: ~D[1982-02-17],
    born_in: "Hamm, Westf.",
    citizenship: "Deutsch",
    },
    contact: %Contact{
      gender: :male,
      email: "postmaster@thorsten-michael.de",
      first_name: "Marianne",
      last_name: "Mustermann"
    },
    sender: sender(),
    subject: "Application for my new job",
    locale: "de",
    email:
      Earmark.as_html!("""
      ich habe mit Interesse Ihre Stellenanzeige *RN-1210* gelesen. Im Anhang dieser Email erhalten sie meine
      Bewerbungsmappe.

      Bei Rückfragen stehe ich Ihnen gerne persönlich zur Verfügung und freue mich schon darauf, Sie in einem
      persönlichen Gespräch kennenlernen zu können.
      """)
  }

  def apply do
    application()
    |> TmdeWeb.ApplicationMailer.send_application()
    |> Tmde.Mailer.deliver!()
  end
end
