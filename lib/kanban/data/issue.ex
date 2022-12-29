defmodule Kanban.Data.Issue do
  use Ecto.Schema

  import Ecto.Changeset

  alias Kanban.Data.{Project}

  schema "issues" do
    belongs_to :project, Project

    field :title, :string
    field :description, :string
    field :state, :string
  end

  def changeset(issue, params \\ %{}) do
    issue
    |> cast(params, ~w[title description]a)
    |> cast_assoc(:issue, with: &Project.changeset/2)
    |> validate_required(~w[title description]a)
  end
end
