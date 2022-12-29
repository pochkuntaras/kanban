defmodule KeyValueStoreTest do
  use KanbanWeb.ConnCase

  doctest Kanban.KeyValueStore

  test "put" do
    {:ok, _pid} = Kanban.KeyValueStore.start_link(%{a: 'a'})

    values = GenServer.call(Kanban.KeyValueStore, {:put, :b, 'first'})

    assert %{a: 'a', b: ['first']} = values

    values = GenServer.call(Kanban.KeyValueStore, {:put, :b, 'second'})

    assert %{a: 'a', b: ['second', 'first']} = values
  end

  test "get" do
    {:ok, _pid} = Kanban.KeyValueStore.start_link(%{a: 'a'})

    value = GenServer.call(Kanban.KeyValueStore, {:get, :a})

    assert 'a' = value
  end
end
