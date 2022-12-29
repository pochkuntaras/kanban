defmodule Kanban.ProjectFSM do
  @moduledoc """
  The FSM for projects.
  """

  import Ecto.Changeset

  alias Kanban.State
  alias Kanban.Data.{Repo, Project}

  use GenServer, restart: :transient

  require Logger

  def start_link(%Project{title: title} = project)
  when not is_nil(title) do
    {:ok, project} = case Repo.get_by(Project, title: title) do
      %Project{} = project -> {:ok, project}
      nil -> project |> Repo.insert
    end

    GenServer.start_link(__MODULE__, project,
     name: {:via, Registry, {Kanban.ProjectRegistry, title}})
  end

  @impl GenServer
  @spec init(any) :: {:ok, any}
  def init(state), do: {:ok, state}

  def start(pid),
   do: GenServer.call(pid, {:transition, :start})

  def complete(pid),
    do: GenServer.call(pid, {:transition, :complete})

  def state(pid),
   do: GenServer.call(pid, :state)

  @impl GenServer
  def terminate(:normal, project),
    do: State.del(project.title)

  @impl GenServer
  def handle_call({:transition, :start}, _from, %Project{id: _id, state: "presale"} = project) do
    project = change(project, %{state: "developing"})

    case Repo.update(project) do
      {:ok, struct} ->
        State.put(struct.title, struct.state)
        IO.inspect({struct.title, struct.state}, label: "START")
        {:reply, :ok, struct}
      {:error, _}   -> {:reply, project}
    end
  end

  @impl GenServer
  def handle_call({:transition, :complete}, _from, %Project{id: _id, state: "developing"} = project) do
    project = change(project, %{state: "support"})

    case Repo.update(project) do
      {:ok, struct} ->
        State.put(struct.title, struct.state)
        {:stop, :normal, struct}
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
