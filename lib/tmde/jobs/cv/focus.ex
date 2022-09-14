defmodule Tmde.Jobs.CV.Focus do
  @moduledoc """
  CV.Focus shows a singular experience in CV.Entry
  """
  use Tmde, :schema
  alias Tmde.Jobs.CV

  schema "cv_focuses" do
    field :url, :string
    field :sort_order, :integer

    belongs_to :entry, CV.Entry
    embeds_many :abstract, Translation
    timestamps()
  end
end
