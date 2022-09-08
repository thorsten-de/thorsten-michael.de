defmodule Tmde.Jobs.Delivery do
  @moduledoc """
  When a Mail is sent, a delivery is created to track success
  """
  use Tmde, :schema
  alias Tmde.Jobs.{Application, DeliveryTracking}

  schema "deliveries" do
    field :email, :string
    field :subject, :string
    belongs_to :application, Application

    has_many :trackings, DeliveryTracking
    timestamps()
  end

  def create_changeset(application, attrs \\ %{}) do
    application_id = if application, do: application.id

    %__MODULE__{}
    |> cast(attrs, [:email, :subject])
    |> put_change(:application_id, application_id)
  end

  # Email delivery tokens may be tracked for 90 days
  @max_token_age 86400 * 90
  def sign_token(%__MODULE__{id: id}) do
    Phoenix.Token.sign(TmdeWeb.Endpoint, "mail_delivery", id, max_age: @max_token_age)
  end

  def token_to_id(delivery_token) do
    Phoenix.Token.verify(TmdeWeb.Endpoint, "mail_delivery", delivery_token)
  end
end
