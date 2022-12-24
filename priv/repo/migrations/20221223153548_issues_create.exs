defmodule Kanban.Data.Repo.Migrations.IssuesCreate do
  use Ecto.Migration

  def change do
    create table(:issues) do
      add :project_id, references(:projects)

      add :title, :string, null: false
      add :description, :string, null: false
    end
  end
end
