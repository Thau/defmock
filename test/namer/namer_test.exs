defmodule Defmock.Test.Namer do
  use ExUnit.Case

  alias Defmock.Namer

  setup do
    Namer.start_link
    :ok
  end

  test "generates a name" do
    assert Namer.name() != ""
  end

  test "names start with Defmock" do
    Namer.name()
    |> String.starts_with?("Defmock")
    |> assert
  end

  test "creates multiple names without repetition" do
    set = for _ <- 1..100 do Namer.name() end
    |> MapSet.new()

    assert Enum.count(set) == 100
  end
end
