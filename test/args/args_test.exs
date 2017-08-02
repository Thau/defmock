defmodule Defmock.Test.Args do
  @moduledoc"""
  Tests for Defmock.Args
  """
  use ExUnit.Case
  alias Defmock.Args

  test "returns {normal_args, []} when an args list only contains normal args" do
    assert Args.split_args([:foo, :bar]) == {[:foo, :bar], []}
  end

  test "returns named args sorted by key" do
    assert Args.split_args([[foo: 1, bar: 2]]) == {[], [bar: 2, foo: 1]}
  end

  test "returns {[], named_args} when an args list only contains named args" do
    assert Args.split_args([[foo: 1, bar: 2]]) == {[], [bar: 2, foo: 1]}
  end

  test "returns {normal_args, named_args} when an args list contains both types" do
    assert Args.split_args([:foo, :bar, [foo: 1, bar: 2]]) == {[:foo, :bar], [bar: 2, foo: 1]}
  end
end