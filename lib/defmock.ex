defmodule Defmock do
  @moduledoc """
  Module to house our defmock macro.
  """
  use Application
  alias Defmock.Namer

  def start(_type, _args) do
    Defmock.Supervisor.start_link
  end

  defmacro defmock(returns \\ []) do
    quote do
      name = Namer.name()
      |> String.to_atom

      defmodule name do
        def start_link do
          Agent.start_link(fn -> %{} end, name: __MODULE__)
        end

        def unquote(:"$handle_undefined_function")(function, args) do
          {:ok, value} = unquote(returns)
          |> Keyword.fetch(function)

          Agent.get_and_update(__MODULE__, fn(calls) ->
            {nil, update_function_calls(calls, function)}
          end)

          value
        end

        def called?(function) do
          Agent.get(__MODULE__, &Map.get(&1, function, 0)) > 0
        end

        defp update_function_calls(calls, function) do
          num_calls = calls
          |> Map.get(function, 0)

          Map.put(calls, function, num_calls + 1)
        end
      end

      name.start_link
      name
    end
  end
end
