defmodule Kanban.Projects do
  @moduledoc """
  The process of projects.
  """

  import Ecto.Changeset

  alias Kanban.{Repo}
  alias Kanban.Data.{Project}

  use GenServer, restart: :transient

  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl GenServer
  def init(state), do: {:ok, state}

  @impl GenServer
  def handle_call({:get}, _from, state) do
    {:reply, :ok, state}
  end

  @impl GenServer
  def handle_cast({:post, %Project{title: title} = project}, _state)
  when not is_nil(title) do
    {:ok, state} = project |> Repo.insert
    {:noreply, state}
  end

  @impl GenServer
  def handle_cast({:put, %{} = params}, %Project{id: _id} = state) do
    project = change(state, params)

    case Repo.update(project) do
      {:ok, struct} -> {:noreply, struct}
      {:error, _}   -> {:noreply, state}
    end
  end

  @impl GenServer
  def handle_cast({:del}, state) do
    case Repo.delete(state) do
      {:ok, _}    -> {:noreply, nil}
      {:error, _} -> {:noreply, state}
    end
  end
end
