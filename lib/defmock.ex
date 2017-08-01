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
        @default_calls %{num_calls: 0, args: []}

        def start_link do
          Agent.start_link(fn -> %{} end, name: __MODULE__)
        end

        def unquote(:"$handle_undefined_function")(function, args) do
          # IO.inspect args
          {:ok, value} = unquote(returns)
          |> Keyword.fetch(function)

          Agent.get_and_update(__MODULE__, fn(calls) ->
            {nil, update_function_calls(calls, function, args)}
          end)

          value
        end

        def called?(function) do
          %{num_calls: num_calls} = get_function_calls(function)
          num_calls > 0
        end

        def called_with?(function, called_args) do
          %{args: args} = get_function_calls(function)

          args
          |> Enum.member?(called_args)
        end

        defp update_function_calls(calls, function, args) do
          %{num_calls: num_calls, args: prev_args} = calls
          |> Map.get(function, @default_calls)

          Map.put(calls, function, %{num_calls: num_calls + 1, args: [args|prev_args]})
        end

        defp get_function_calls(function) do
          Agent.get(__MODULE__, &Map.get(&1, function, @default_calls))
        end
      end

      name.start_link
      name
    end
  end
end
