defmodule Kanban.State do
  @moduledoc """
  The State Module.
  """

  use GenServer

  @spec start_link(keyword) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(opts \\ []) do
    opts = Keyword.put_new(opts, :name, __MODULE__)
    GenServer.start_link(__MODULE__, %{}, opts)
  end

  @impl GenServer
  def init(state), do: {:ok, state}

  def get(name \\ __MODULE__, k),
    do: GenServer.call(name, {:get, k})

  def put(name \\ __MODULE__, k, v) do
    IO.inspect({name, k, v}, label: "PUT")
    GenServer.cast(name, {:put, k, v})
  end

  def del(name \\ __MODULE__, k) do
    IO.inspect({name, k}, label: "DEL")
    GenServer.cast(name, {:del, k})
  end

  @spec state(atom | pid | {atom, any} | {:via, atom, any}) :: any
  def state(name \\ __MODULE__),
    do: GenServer.call(name, :state)

  @impl GenServer
  def handle_cast({:put, k, v}, state),
    do: {:noreply, Map.put(state, k, v)}

  @impl GenServer
  def handle_cast({:del, k}, state),
    do: {:noreply, Map.delete(state, k)}

  @impl GenServer
  def handle_call({:get, k}, _from, state),
    do: {:reply, Map.get(state, k), state}

  @impl GenServer
  def handle_call(:state, _from, state),
    do: {:reply, state, state}
end
