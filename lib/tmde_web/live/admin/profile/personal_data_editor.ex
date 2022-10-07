defmodule TmdeWeb.Admin.Profile.Editors do
  use TmdeWeb, :component
  use Bulma
  alias TmdeWeb.Components.Forms.EditorCard
  alias Tmde.Contacts.Link, as: ContactLink

  def personal_data_editor(assigns) do
    ~H"""
      <div class="personal-data-editor">
      <.form let={f} for={@changeset} phx-submit="update_personal_data" >
        <.live_component module={EditorCard} header={gettext("Personal information")} id="personal_data_editor">
          <p class="my-1"><%= gettext("Born %{date} in %{place}", date: Calendar.strftime(@job_seeker.dob, "%d.%0m.%Y"), place: @job_seeker.place_of_birth) %></p>
          <p class="my-1"><%= gettext("Citizenship: %{citizenship}", citizenship: @job_seeker.citizenship) %></p>
          <:editor>
            <.field form={f} name={:dob} label={gettext("day of birth")} input={:date_input} />
            <.field form={f} name={:place_of_birth} label={gettext("place of birth")} input={:text_input} />
            <.field form={f} name={:citizenship} label={gettext("citizenship")} input={:text_input} />
          </:editor>
        </.live_component>
      </.form>
    </div>
    """
  end

  def links_editor(assigns) do
    ~H"""
      <div class="links-editor">
      <.form let={f} for={@changeset} phx-submit="update_links" >
        <.live_component module={EditorCard} header={gettext("Links")} id="links_editor">
          <:editor>
            <.inputs form={f} field={:links} let={lf}>
              <.field form={lf} name={:type} input={:select} options={ContactLink.all_types} />
              <.field form={lf} name={:target} input={:text_input} />
            </.inputs>
          </:editor>
          <%= for l <- @job_seeker.links do %>
            <%= link ContactLink.build_link_options(l) |> Keyword.merge(class: "is-block my-1") do %>
              <.label {ContactLink.type_to_icon(l)} label={l} />
            <% end %>
          <% end %>
        </.live_component>
      </.form>
    </div>
    """
  end
end
