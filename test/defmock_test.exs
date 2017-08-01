defmodule Defmock.Test do
  use ExUnit.Case
  import Defmock

  doctest Defmock

  setup do
    Application.ensure_all_started(:defmock)
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

  test "can define functions with arguments" do
    module = defmock(mocked_function: 2)

    assert module.mocked_function(2, 4, 6) == 2
  end

  test "can check that the functions were called" do
    module = defmock(mocked_function: 2)
    module.mocked_function()

    assert module.called?(:mocked_function) == true
  end

  test "can check that functions were NOT called" do
    module = defmock(mocked_function: 2)

    assert module.called?(:mocked_function) == false
  end

  test "can check that a function was called with certain arguments" do
    module = defmock(mocked_function: 2)
    module.mocked_function(:arg1, :arg2)

    assert module.called_with?(:mocked_function, :arg1, :arg2)
  end

  test "can check that a function was called with named arguments" do
    module = defmock(mocked_function: 2)
    module.mocked_function(arg1: 4, arg2: 2)

    assert module.called_with?(:mocked_function, arg1: 4, arg2: 2)
  end

  test "can check that a function was called with a mixture of normal and named arguments" do
    module = defmock(mocked_function: 2)
    module.mocked_function(4, arg2: 2)

    assert module.called_with?(:mocked_function, 4, arg2: 2)
  end

  test "can check that a function was called with named arguments without order" do
    module = defmock(mocked_function: 2)
    module.mocked_function(4, arg1: 4, arg2: 2)

    assert module.called_with?(:mocked_function, 4, arg2: 2, arg1: 4)
  end
end
