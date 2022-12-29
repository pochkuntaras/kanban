defmodule KanbanWeb.ProjectsController do
  use KanbanWeb, :controller

  alias Kanban.{ProjectManager}

  def start_test_projects(conn, _params) do
    (1..5) |> Enum.map(&"p#{&1}") |> Enum.map(&ProjectManager.start_project(&1))

    projects_count = DynamicSupervisor.which_children(ProjectManager) |> Enum.count()

    render(conn, "start_test_projects.json", projects_count: projects_count)
  end

  def start_project(conn, %{"project_id" => project_id}) do
    start = Kanban.start_project(project_id)

    render(conn, "start.json", start: start)
  end

  def state_project(conn, %{"project_id" => project_id}) do
    state = Kanban.state_project(project_id)
    render(conn, "state.json", state: state)
  end
end
