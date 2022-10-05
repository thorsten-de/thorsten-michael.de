defmodule TmdeWeb.Admin.Profile.PersonalDataEditor do
  use TmdeWeb, :component
  use Bulma
  alias TmdeWeb.Components.Forms.EditorCard

  def personal_data_editor(assigns) do
    ~H"""
      <div class="personal-data-editor">
      <.form let={f} for={@changeset} phx-submit="update_user" >
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
end
