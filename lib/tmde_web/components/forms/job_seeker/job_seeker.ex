defmodule TmdeWeb.Components.Forms.JobSeeker do
  use TmdeWeb, :component
  use TmdeWeb, :colocate_templates
  use Bulma

  import TmdeWeb.Components.Forms,
    only: [address_form: 1, contact_form: 1]

  def job_seeker_form(assigns) do
    render("job_seeker_form.html", assigns)
  end

  def link_form(assigns) do
    render("link_form.html", assigns)
  end

  def private_form(assigns) do
    render("job_seeker_private_form.html", assigns)
  end
end
