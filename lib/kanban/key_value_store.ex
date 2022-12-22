defmodule Kanban.KeyValueStore do
  @moduledoc """
  The KV-Store KeyValueStore
  """

  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl GenServer
  def init(state), do: {:ok, state}

  @impl GenServer
  def handle_call({:put, key, value}, _from, state) do
    state = Map.update(
      state,
      key,
      [value],
      fn values -> [value | values] end
    )

    {:reply, state, state}
  end

  @impl GenServer
  def handle_call({:get, key}, _, state) do
    {:reply, Map.get(state, key), state}
  end
end
