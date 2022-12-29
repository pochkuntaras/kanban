defmodule KanbanWeb.ProjectsView do
  use KanbanWeb, :view

  def render("start_test_projects.json", %{projects_count: projects_count}) do
    %{status: "ok", projects_count: projects_count}
  end

  def render("start.json", %{start: start}) do
    %{status: "ok", start: start}
  end

  def render("state.json", %{state: state}) do
    %{status: "ok", state: state}
  end
end
