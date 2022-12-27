defmodule Kanban.ProjectFSM do
  @moduledoc """
  The FSM for projects.
  """

  import Ecto.Changeset

  alias Kanban.Data.{Repo, Project}

  use GenServer, restart: :transient

  require Logger

  def start_link(%Project{title: title} = project)
  when not is_nil(title) do
    {:ok, project} = project |> Repo.insert
    GenServer.start_link(__MODULE__, project, name: __MODULE__)
  end

  @impl GenServer
  def init(state), do: {:ok, state}

  @impl GenServer
  def handle_call({:transition, :start}, _from, %Project{id: _id, state: "presale"} = project) do
    project = change(project, %{state: "developing"})

    case Repo.update(project) do
      {:ok, struct} -> {:reply, :ok, struct}
      {:error, _}   -> {:reply, project}
    end
  end

  @impl GenServer
  def handle_call({:transition, :complete}, _from, %Project{id: _id, state: "developing"} = project) do
    project = change(project, %{state: "support"})

    case Repo.update(project) do
      {:ok, struct} -> {:stop, :normal, struct}
      {:error, _}   -> {:stop, project}
    end
  end

  @impl GenServer
  def handle_call(:state, _from, %Project{state: state} = project) do
    {:reply, state, project}
  end

  @impl GenServer
  def handle_call({:transition, transition}, _from, %Project{id: _id, state: state} = project) do
    Logger.warn(inspect({:error, {:not_allowed, transition, state}}))
    {:noreply, project}
  end
end
