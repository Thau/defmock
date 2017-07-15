defmodule Defmock.Supervisor do
  @moduledoc """
  Supervisor to keep the application working.
  """
  use Supervisor

  @name Defmock.Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: @name)
  end

  def init(:ok) do
    children = [
      worker(Defmock.Namer, [])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
