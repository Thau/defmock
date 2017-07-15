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
        def unquote(:"$handle_undefined_function")(function, args) do
          {:ok, value} = unquote(returns)
          |> Keyword.fetch(function)
          value
        end
      end

      name
    end
  end
end
