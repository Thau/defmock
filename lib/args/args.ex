defmodule Defmock.Args do
  @moduledoc """
  Module to work on function arguments
  """

  @doc """
  Splits an args list in a tuple of normal and named args
  """
  def split_args(args) do
    contains_named_args = contains_named_args?(args)

    case Enum.reverse(args) do
      [named_args|normal_args] when contains_named_args ->
        {Enum.reverse(normal_args), Enum.sort(named_args)}
      _ ->
        {args, []}
    end
  end

  defp contains_named_args?([]), do: false
  defp contains_named_args?(args) do
    args |> Enum.reverse() |> hd() |> Keyword.keyword?()
  end
end