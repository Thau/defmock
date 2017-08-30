defmodule Defmock do
  @moduledoc """
  Module to house our defmock macro.
  """

  @ets_opts [:public, :bag, write_concurrency: false, read_concurrency: true]

  def table!(name), do: :ets.new(:defmock, @ets_opts)

  def name(%Macro.Env{function: {function, _}}), do: :"Defmock#{function}#{:erlang.unique_integer([:positive])}"
  def name(%Macro.Env{function: nil}), do: :"Defmock#{:erlang.unique_integer([:positive])}"

  defmacro defmock(returns \\ []) do
    quote do
      name = name(__ENV__)
      table_id = table!(name)

      defmodule name do
        @moduledoc false
        @table_id table_id

        def unquote(:"$handle_undefined_function")(function, args) do
          {:ok, value} = unquote(returns) |> Keyword.fetch(function)

          :ets.insert @table_id, {function, args, __MODULE__}

          value
        end

        def called?(function) when is_atom(function), do: calls_of(function) |> called?
        def called?([_|_]), do: true
        def called?(_), do: false

        def called_with?(function, args) when is_atom(function), do: function |> calls_of |> called_with?(args)
        def called_with?([_|_] = calls, args), do: calls |> Enum.map(&elem(&1, 1)) |> Enum.any?(&(&1 == args))
        def called_with?([], _args), do: false

        def called_with_match?(function, pattern), do: called_with_match?(matches_of(function, pattern))
        def called_with_match?([_|_]), do: true
        def called_with_match?(_), do: false

        defp calls_of(function), do: :ets.lookup(@table_id, function)
        defp matches_of(function, pattern), do: :ets.match_object(@table_id, {function, pattern, :'_'})
      end

      name
    end
  end
end
