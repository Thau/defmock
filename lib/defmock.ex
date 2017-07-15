defmodule Defmock do
  use Application

  def start(_type, _args) do
    Defmock.Supervisor.start_link
  end

  defmacro defmock(returns \\ []) do
    quote do
      name = Defmock.Namer.name()
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
