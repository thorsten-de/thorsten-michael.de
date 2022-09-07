a = %{
  recipient: "postmaster@thorsten-michael.de",
  contact: %{
    gender: "w",
    name: "Mustermann"
  },
  sender: %{
    name: "Thorsten-Michael Deinert",
    email: "postmaster@thorsten-michael.de"
  },
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

apply_for = fn a ->
  a
  |> TmdeWeb.ApplicationMailer.send_application()
  |> Tmde.Mailer.deliver!()
end

alias Tmde.Repo
alias Tmde.Jobs
