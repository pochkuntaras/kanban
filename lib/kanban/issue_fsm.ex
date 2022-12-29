defmodule Kanban.IssueFSM do
  @moduledoc """
  The FSM for projects.
  """

  import Ecto.Changeset

  alias Kanban.{Repo}
  alias Kanban.Data.{Issue}

  use GenServer, restart: :transient

  require Logger

  def start_link(%Issue{title: title} = issue)
  when not is_nil(title) do
    {:ok, issue} = issue |> Repo.insert
    GenServer.start_link(__MODULE__, issue, name: __MODULE__)
  end

  @impl GenServer
  def init(state), do: {:ok, state}

  @impl GenServer
  def handle_call({:transition, :close}, _from, %Issue{id: _id, state: "opened"} = issue) do
    issue = change(issue, %{state: "closed"})

    case Repo.update(issue) do
      {:ok, struct} -> {:reply, :ok, struct}
      {:error, _}   -> {:reply, issue}
    end
  end

  @impl GenServer
  def handle_call({:transition, :archive}, _from, %Issue{id: _id, state: "closed"} = issue) do
    issue = change(issue, %{state: "archived"})

    case Repo.update(issue) do
      {:ok, struct} -> {:stop, :normal, struct}
      {:error, _}   -> {:stop, issue}
    end
  end

  @impl GenServer
  def handle_call(:state, _from, %Issue{state: state} = issue) do
    {:reply, state, issue}
  end

  @impl GenServer
  def handle_call({:transition, transition}, _from, %Issue{id: _id, state: state} = issue) do
    Logger.warn(inspect({:error, {:not_allowed, transition, state}}))
    {:noreply, issue}
  end
end
