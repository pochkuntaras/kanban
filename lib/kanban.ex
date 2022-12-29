defmodule Kanban do
  @moduledoc """
  Documentation for `Kanban`.
  """

  alias Kanban.ProjectFSM

  @doc """
  Hello world.

  ## Examples

      iex> Kanban.hello()
      :world

  """
  def hello do
    :world
  end

  def start_project(project_id),
    do: ProjectFSM.start({:via, Registry, {Kanban.ProjectRegistry, project_id}})

  def state_project(project_id),
    do: ProjectFSM.state({:via, Registry, {Kanban.ProjectRegistry, project_id}})

  def complete_state(project_id),
    do: ProjectFSM.complete({:via, Registry, {Kanban.ProjectRegistry, project_id}})
end
