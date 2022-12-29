defmodule Kanban.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Kanban.Worker.start_link(arg)
      # {Kanban.Worker, arg}
      {Registry, keys: :unique, name: Kanban.ProjectRegistry},
      Kanban.Main,
      Kanban.Data.Repo
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Kanban.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
