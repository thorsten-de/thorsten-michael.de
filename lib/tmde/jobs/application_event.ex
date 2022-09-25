defmodule Tmde.Jobs.ApplicationEvent do
  use Tmde, :schema
  alias Tmde.Jobs.Application

  schema "job_application_events" do
    belongs_to :application, Application
    field :type, :string
    field :payload, :map

    timestamps()
  end
end
