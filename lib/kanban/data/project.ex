defmodule Kanban.Data.Project do
  use Ecto.Schema

  import Ecto.Changeset

  # alias Kanban.Data.{Project}

  schema "projects" do
    field :title, :string
    field :description, :string
    field :state, :string
    # has_many :tasks, Task
  end

  def changeset(project, params \\ %{}) do
    project
    |> cast(params, ~w[title description]a)
    # |> cast_assoc(:tasks, with: &Task.changeset/2)
    |> validate_required(~w[title]a)
  end
end
