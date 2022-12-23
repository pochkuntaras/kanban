defmodule Kanban.TaskFSM do
  @moduledoc """
  Process to be run
  """

  alias Kanban.Data.Task

  use GenServer, restart: :transient

  require Logger

  def start_link(%Task{state: "idle", title: title} = task)
      when not is_nil(title) do
    GenServer.start_link(__MODULE__, task, name: __MODULE__)
  end

  def start(pid) do
    GenServer.call(pid, {:transition, :start})
  end

  def finish(pid) do
    GenServer.call(pid, {:transition, :finish})
  end

  def state(pid) do
    GenServer.call(pid, :state)
  end

  @impl GenServer
  def init(state), do: {:ok, state}

  @impl GenServer
  def handle_call({:transition, :start}, _from, %Task{state: "idle"} = task) do
    # case Task.update(task) do
    #   :ok -> %Task{task | state: :doing}
    #   :error -> task
    # end
    # new_task = {:noreply, new_task}
    {:reply, :ok, %Task{task | state: "doing"}}
  end

  @impl GenServer
  def handle_call({:transition, :finish}, _from, %Task{state: "doing"} = task) do
    # Save to external storage
    {:stop, :normal, %Task{task | state: "done"}}
  end

  @impl GenServer
  def handle_call({:transition, transition}, _from, %Task{state: state} = task) do
    Logger.warn(inspect({:error, {:not_allowed, transition, state}}))
    {:noreply, task}
  end

  @impl GenServer
  def handle_call(:state, _from, %Task{state: state} = task) do
    {:reply, state, task}
  end
end
