defmodule Tmde.Jobs.CV.Focus do
  @moduledoc """
  CV.Focus shows a singular experience in CV.Entry
  """
  use Tmde, :schema
  alias Tmde.Jobs.CV
  import Ecto.Changeset

  schema "cv_focuses" do
    field :url, :string
    field :sort_order, :integer

    belongs_to :entry, CV.Entry
    translation_field(:abstract)
    timestamps()
  end

  def changeset(focus, params \\ %{}) do
    focus
    |> cast(params, [:url])
  end
end
