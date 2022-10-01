defmodule TmdeWeb.Components.Forms do
  use TmdeWeb, :component
  use TmdeWeb, :colocate_templates
  use Bulma
  alias Tmde.Contacts.{Contact, Country}
  alias Tmde.Content.Translation

  def address_form(assigns) do
    countries =
      Country.all()
      |> Enum.map(&{&1.iso, &1.title})

    render("address_form.html", form: assigns.form, countries: countries)
  end

  def contact_form(assigns) do
    render("contact_form.html", assigns)
  end

  def translation_form(assigns) do
    assigns =
      assign(assigns,
        types: Translation.all_content_types(),
        languages: Gettext.known_locales(TmdeWeb.Gettext)
      )

    render("translation_form.html", assigns)
  end
end
