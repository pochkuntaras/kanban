defmodule KanbanTest do
  use KanbanWeb.ConnCase

  doctest Kanban

  test "greets the world" do
    assert Kanban.hello() == :world
  end
end
