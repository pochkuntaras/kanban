defmodule Users.Repo do
  use Ecto.Repo,
    otp_app: :kanban,
    adapter: Ecto.Adapters.Postgres
end
