defmodule Defmock.Test do
  use ExUnit.Case
  import Defmock

  doctest Defmock

  setup_all do
    {:ok, _} = Defmock.Namer.start_link
    :ok
  end

  test "creates a module" do
    module = defmock()
    assert module == module.__info__(:module)
  end

  test "two modules created with defmock don't share the name" do
    module_1 = defmock()
    module_2 = defmock()

    refute module_1 == module_2.__info__(:module)
  end

  test "defined function runs the code" do
    module = defmock(mocked_function: 2)
    assert module.mocked_function() == 2
  end

  test "multiple defined functions work" do
    module = defmock(mocked_function_1: 2, mocked_function_2: "It's alive!")
    assert module.mocked_function_1() == 2
    assert module.mocked_function_2() == "It's alive!"
  end
end