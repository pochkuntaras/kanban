defmodule Kanban.Data.Repo.Migrations.AddStatusToIssues do
  use Ecto.Migration

  def change do
    alter table(:issues) do
      add :state, :string, default: "opened"
    end
  end
end
