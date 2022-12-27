defmodule ProjectsTest do
  use ExUnit.Case
  doctest Kanban.Projects

  alias Kanban.Data.Project

  setup do
    {:ok, pid} = Kanban.Projects.start_link()

    %{pid: pid}
  end

  test "get", %{pid: pid} do
    GenServer.cast(pid, {:post, %Project{title: "project1", description: "project1"}})

    assert :ok = GenServer.call(pid, {:get})
  end

  test "post", %{pid: pid} do
    value = GenServer.cast(pid, {:post, %Project{title: "project1", description: "project1"}})

    assert :ok = value
  end


  test "put", %{pid: pid} do
    value = GenServer.cast(pid, {:put, %{description: "test1"}})

    assert :ok = value
  end

  test "del", %{pid: pid} do
    value = GenServer.cast(pid, {:del})

    assert :ok = value
  end
end
