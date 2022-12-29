defmodule Kanban.ProjectManager do
  @moduledoc """
  The supervisor for all the task processes/FSMs.
  """

  use DynamicSupervisor

  alias Kanban.Data.Project

  def start_link(init_arg \\ []),
    do: DynamicSupervisor.start_link(__MODULE__, init_arg, name: Kanban.ProjectManager)

  @impl true
  def init(_init_arg),
    do: DynamicSupervisor.init(strategy: :one_for_one)

  @doc """
  Starts the task process under this module supervision.
  """

  # @spec start_project(Project.t() :: pid())
  def start_project(%Project{} = project) do
    Kanban.ProjectManager
    |> DynamicSupervisor.start_child({Kanban.ProjectFSM, project})
    |> case do
      {:ok, pid} ->
        Kanban.State.put(project.title, project.state)
        pid
      {:error, {:already_started, pid}} -> pid
    end
  end

  # @spec start_task(String.t(), pos_integer(), String.t()) :: pid()
  def start_project(title) do
    %Project{title: title, state: "presale"} |> start_project()
  end
end
