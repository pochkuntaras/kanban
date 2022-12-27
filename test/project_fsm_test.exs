defmodule ProjectFSM do
  use ExUnit.Case

  doctest Kanban.ProjectFSM

  alias Kanban.ProjectFSM
  alias Kanban.Data.Project

  setup do
    {:ok, pid} = ProjectFSM.start_link(%Project{state: "presale", title: "title"})

    %{pid: pid}
  end

  test "init", %{pid: pid} do
    state = GenServer.call(pid, :state)

    assert "presale" = state
  end

  test "start", %{pid: pid} do
    GenServer.call(pid, {:transition, :start})

    state = GenServer.call(pid, :state)

    assert "developing" = state
  end

  # test "complete" do
  # TODO: Add the test code.
  # end
end
