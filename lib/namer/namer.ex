defmodule Defmock.Namer do
  @moduledoc """
  Namer creates unique names for our mock modules.
  """
  @prefix "Defmock"

  def start_link do
    Agent.start_link(fn -> 0 end, name: __MODULE__)
  end

  @doc ~S"""
   Returns a unique name for a mock module.

  ## Examples

    iex> Defmock.Namer.name
    "Defmock0"
    iex> Defmock.Namer.name
    "Defmock1"

  """
  def name do
    Agent.get_and_update(__MODULE__, fn(n) ->
      {"#{@prefix}#{n}", n + 1}
    end)
  end
end
