# defmock [![Build Status](https://travis-ci.org/Thau/defmock.svg?branch=master)](https://travis-ci.org/Thau/defmock)

Easy mock generation for Elixir.

## Installation

Add `defmock` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:defmock, github: "thau/defmock", tag: "v0.1.1"}
  ]
end
```

Then ensure that the application is running in your `test_helper.exs`

```elixir
Application.ensure_all_started(:defmock)
ExUnit.start()
```

## Usage

```elixir
defmodule TestedModule do
    def function_with_external_api(external_api) do
      case external_api.call_me() do
        %{status_code: 200} -> :ok
        %{status_code: 404} -> :not_found
      end
    end
end

defmodule Test do
  use ExUnit.Case
  import Defmock

  test "returns :ok if the external API returns status_code 200" do
    external_api = defmock(call_me: %{status_code: 200})
    assert TestedModule.function_with_external_api(external_api) == :ok
  end

  test "returns :not_found if the external API returns status_code 404" do
    external_api = defmock(call_me: %{status_code: 404})
    assert TestedModule.function_with_external_api(external_api) == :not_found
  end

  test "ensure that external API is being called" do
    external_api = defmock(call_me: %{status_code: 200})
    TestedModule.function_with_external_api(external_api)
    assert external_api.called?(:call_me)
  end
end
```
