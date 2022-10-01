defmodule Tmde do
  @moduledoc """
  Tmde keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def schema do
    quote do
      use Ecto.Schema
      import Ecto.Query
      import Ecto, only: [assoc: 2]
      import Ecto.Changeset

      alias Tmde.Content.Translation
      require Tmde.Content.Translation
      import Tmde.Content.Translation, only: [translation_field: 1]

      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
