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
