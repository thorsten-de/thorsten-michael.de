defmodule Tmde.Repo do
  use Ecto.Repo,
    otp_app: :tmde,
    adapter: Ecto.Adapters.Postgres
end
