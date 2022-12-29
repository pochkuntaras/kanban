defmodule Kanban.Repo.Migrations.AddStatusToProjects do
  use Ecto.Migration

  def change do
    alter table(:projects) do
      add :state, :string, default: "presale"
    end
  end
end
