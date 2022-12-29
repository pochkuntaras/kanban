defmodule IssueFSM do
  use KanbanWeb.ConnCase

  doctest Kanban.IssueFSM

  alias Kanban.IssueFSM
  alias Kanban.Data.Issue

  setup do
    {:ok, pid} =
      IssueFSM.start_link(%Issue{state: "opened", title: "issue1", description: "issue1"})

    %{pid: pid}
  end

  test "open", %{pid: pid} do
    state = GenServer.call(pid, :state)

    assert "opened" = state
  end

  test "close", %{pid: pid} do
    GenServer.call(pid, {:transition, :close})

    state = GenServer.call(pid, :state)

    assert "closed" = state
  end

  # test "archive" do
  # TODO: Add the test code.
  # end
end
