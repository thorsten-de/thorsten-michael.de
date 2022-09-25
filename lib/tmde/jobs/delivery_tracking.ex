defmodule Tmde.Jobs.DeliveryTracking do
  @moduledoc """
  tracks request to a delivered email via the logo image
  """
  use Tmde, :schema
  alias Tmde.Jobs.Delivery

  schema "delivery_trackings" do
    field :payload, :map
    belongs_to :delivery, Delivery
    timestamps()
  end
end
