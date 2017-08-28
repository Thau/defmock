defmodule Defmock.Test do
  use ExUnit.Case
  import Defmock

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
    module.mocked_function(2)
    assert module.mocked_function(3) == 2
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

    assert module.called_with?(:mocked_function, [:arg1, :arg2])
  end

  test "can check that a function was called with named arguments" do
    module = defmock(mocked_function: 2)
    module.mocked_function(arg1: 4, arg2: 2)

    assert module.called_with?(:mocked_function, [[arg1: 4, arg2: 2]])
  end

  test "can check that a function was called with a mixture of normal and named arguments" do
    module = defmock(mocked_function: 2)
    module.mocked_function(4, arg2: 2)

    assert module.called_with?(:mocked_function, [4, [arg2: 2]])
  end

  describe "called_with_match?/2" do
    setup do
      module = defmock(mocked_function: 2)
      subject = fn -> module.mocked_function(42, %{we_need: %{to: %{go: :deeper}}}) end

      %{mock: module, subject: subject}
    end

    test "returns true with a matching match_spec on a map", %{mock: mock, subject: subject} do
      subject.()

      assert mock.called_with_match?(:mocked_function, [:'_', %{we_need: %{to: :'_'}}])
    end

    test "returns true with an empty map as part of a matching match_spec on a map",
         %{mock: mock, subject: subject} do
      subject.()

      assert mock.called_with_match?(:mocked_function, [:'_', %{}])
    end

    test "returns false with a non-matching and a matching argument",
         %{mock: mock, subject: subject} do
      subject.()

      refute mock.called_with_match?(:mocked_function, [43, %{we_need: %{to: :'_'}}])
    end

    test "returns false with an ignored argument and one which does not match",
         %{mock: mock, subject: subject} do
      subject.()

      refute mock.called_with_match?(:mocked_function, [:'_', %{we_need: %{to: "go shallower"}}])
    end

    test "readme" do
      mock = defmock(call_me: %{status_code: 200})
      mock.call_me(:foo, :bar, baz: 2, qux: 4)
      assert mock.called_with_match?(:call_me, [:foo, :'_', [baz: :'_', qux: 4]])
    end
  end
end
