defmodule CubaLibrato.ChartsStoreTest do
  use ExUnit.Case

  alias CubaLibrato.ChartsStore

  test "Create store and get" do
    charts = [
      %{
        "id" => 123,
        "name" => "Chart1",
        "streams" => [
          %{
            "group_function" => "sum",
            "id" => 234,
            "metric" => "metric1",
            "position" => 0,
            "source" => "*",
            "split_axis" => false,
            "summary_function" => "count",
            "type" => "gauge"
          },
          %{
            "id" => 345,
            "metric" => "annotation1",
            "position" => 1,
            "source" => "*",
            "split_axis" => false,
            "type" => "annotation"
          }
        ],
        "type" => "line"
      },
      %{
        "id" => 456,
        "name" => "Chart2",
        "streams" => [
          %{
            "group_function" => "sum",
            "id" => 567,
            "metric" => "metric2",
            "position" => 0,
            "source" => "*",
            "split_axis" => false,
            "summary_function" => "sum",
            "type" => "gauge"
          }
        ],
        "type" => "line"
      }
    ]

    ChartsStore.start_link()
    ChartsStore.store(charts)
    assert ChartsStore.get() == charts
  end
end
