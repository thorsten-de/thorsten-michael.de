a = %{
  recipient: "postmaster@thorsten-michael.de",
  sender: "postmaster@thorsten-michael.de",
  subject: "Application for my new job",
  locale: "de"
}

apply_for = fn a ->
  a
  |> TmdeWeb.ApplicationMailer.send_application()
  |> Tmde.Mailer.deliver!()
end
