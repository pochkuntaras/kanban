defmodule Kanban.Process do
  @moduledoc """
  Process to be run
  """

  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl GenServer
  def init(state), do: {:ok, state}

  @impl GenServer
  def handle_call({:+, value}, _from, state) do
    # IO.inspect({msg, from, state}, label: "CALL")
    state = state + value
    {:reply, state, state}
  end
end
