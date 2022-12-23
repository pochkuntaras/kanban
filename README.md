# Kanban

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `kanban` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:kanban, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/kanban>.

## Start
```bash
iex -S mix
```

## Work with Ecto
```bash
mix ecto.gen.repo -r Data.Repo # create repo

mix ecto.create # create database

mix ecto.gen.migration create_projects # create migration
mix ecto.gen.migration issues_create

mix ecto.migrate # run migrations
```

## Usage
```bash
iex(1)> Kanban.KeyValueStore.start_link(%{a: 'a'})
{:ok, #PID<0.227.0>}
iex(2)> GenServer.call(Kanban.KeyValueStore, {:put, :b, 'first'})
%{a: 'a', b: ['first']}
iex(3)> GenServer.call(Kanban.KeyValueStore, {:put, :b, 'second'})
%{a: 'a', b: ['second', 'first']}
iex(4)> GenServer.call(Kanban.KeyValueStore, {:get, :b})
['second', 'first']
```

## Usage #2
```bash
iex|💧|1 ▶ {:ok, pid} = Kanban.TaskFSM.start_link(%Task{state: "idle", title: "title"})
{:ok, #PID<0.246.0>}
iex|💧|2 ▶ {:ok, pid} = v()
{:ok, #PID<0.246.0>}
iex|💧|3 ▶ GenServer.call(pid, :state)
"idle"
iex|💧|4 ▶ GenServer.call(pid, {:transition, :start})
:ok
iex|💧|5 ▶ GenServer.call(pid, :state)               
"doing"
iex|💧|6 ▶ GenServer.call(pid, {:transition, :finish})
** (exit) exited in: GenServer.call(#PID<0.246.0>, {:transition, :finish}, 5000)
    ** (EXIT) normal
    (elixir 1.14.0) lib/gen_server.ex:1038: GenServer.call/3
```

## Usage #3
```bash
iex|💧|1 ▶ {:ok, pid} = Projects.start_link
{:ok, #PID<0.295.0>}
iex|💧|2 ▶ GenServer.cast(pid, {:post, %Project{title: "project1", description: "project1"}})
:ok
iex|💧|3 ▶ 
16:37:08.115 [debug] QUERY OK db=2.2ms decode=1.0ms queue=0.7ms idle=1909.3ms
INSERT INTO "projects" ("description","title") VALUES ($1,$2) RETURNING "id" ["project1", "project1"]
 
nil
iex|💧|4 ▶ GenServer.cast(pid, {:put, %{description: "test1"}})
:ok
iex|💧|5 ▶ 
16:37:14.055 [debug] QUERY OK db=3.2ms queue=0.9ms idle=1850.4ms
UPDATE "projects" SET "description" = $1 WHERE "id" = $2 ["test1", 6]
 
nil
iex|💧|6 ▶ GenServer.call(pid, {:get})
GET: {%Kanban.Data.Project{
   __meta__: #Ecto.Schema.Metadata<:loaded, "projects">,
   id: 6,
   title: "project1",
   description: "test1"
 }}
:ok
iex|💧|7 ▶ GenServer.cast(pid, {:del}) 
:ok
iex|💧|8 ▶ 
16:37:24.206 [debug] QUERY OK db=0.9ms queue=0.3ms idle=1005.2ms
DELETE FROM "projects" WHERE "id" = $1 [6]
 
nil
```

## Usage #4
```bash
iex|💧|1 ▶ {:ok, pid} = Issues.start_link
{:ok, #PID<0.295.0>}
iex|💧|2 ▶ GenServer.cast(pid, {:post, %Issue{title: "issue1", description: "issue1", project: %Project{title: "project1"}}})
:ok
iex|💧|3 ▶ 
18:03:54.966 [debug] QUERY OK db=1.4ms idle=849.9ms
begin []
 
18:03:54.982 [debug] QUERY OK db=0.6ms
INSERT INTO "projects" ("title") VALUES ($1) RETURNING "id" ["project1"]
 
18:03:54.985 [debug] QUERY OK db=0.9ms
INSERT INTO "issues" ("description","project_id","title") VALUES ($1,$2,$3) RETURNING "id" ["issue1", 11, "issue1"]
 
18:03:54.987 [debug] QUERY OK db=2.4ms
commit []
 
nil
iex|💧|4 ▶ GenServer.cast(pid, {:put, %{description: "test1"}})
:ok
iex|💧|5 ▶ 
18:04:00.217 [debug] QUERY OK db=2.7ms queue=1.0ms idle=100.7ms
UPDATE "issues" SET "description" = $1 WHERE "id" = $2 ["test1", 4]
 
nil
iex|💧|6 ▶ GenServer.call(pid, {:get})
GET: {%Kanban.Data.Issue{
   __meta__: #Ecto.Schema.Metadata<:loaded, "issues">,
   id: 4,
   project_id: 11,
   project: %Kanban.Data.Project{
     __meta__: #Ecto.Schema.Metadata<:loaded, "projects">,
     id: 11,
     title: "project1",
     description: nil
   },
   title: "issue1",
   description: "test1"
 }}
:ok
iex|💧|7 ▶ GenServer.cast(pid, {:del})
:ok
iex|💧|8 ▶ 
18:04:10.151 [debug] QUERY OK db=3.5ms queue=1.0ms idle=33.3ms
DELETE FROM "issues" WHERE "id" = $1 [4]
 
nil
```
