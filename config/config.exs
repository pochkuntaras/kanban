import Config

config :kanban, Kanban.Data.Repo,
  database: "kanban_repo",
  username: "postgres",
  password: "",
  hostname: "localhost"

config :kanban, ecto_repos: [Kanban.Data.Repo]
