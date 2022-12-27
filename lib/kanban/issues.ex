defmodule Kanban.Issues do
  @moduledoc """
  The process of Issues.
  """

  import Ecto.Changeset

  alias Kanban.Data.{Repo, Issue}

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
  def handle_cast({:post, %Issue{} = issue}, _state) do
    {:ok, state} = issue |> Repo.insert
    {:noreply, state}
  end

  @impl GenServer
  def handle_cast({:put, %{} = params}, %Issue{id: _id} = state) do
    issue = change(state, params)

    case Repo.update(issue) do
      {:ok, struct}  -> {:noreply, struct}
      {:error, _}    -> {:noreply, state}
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
