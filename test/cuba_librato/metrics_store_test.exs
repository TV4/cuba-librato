defmodule CubaLibrato.MetricsStoreTest do
  use ExUnit.Case

  alias CubaLibrato.MetricsStore

  test "store and get" do
    metrics = [
      {"metric1",
       %{
         "attributes" => %{
           "created_by_ua" => "testsson",
           "display_min" => 0.0,
           "display_units_long" => "",
           "l2met_type" => "counter",
           "summarize_function" => "sum"
         },
         "description" => nil,
         "display_name" => nil,
         "name" => "metric1",
         "period" => 60,
         "source_lag" => nil,
         "type" => "gauge"
       }},
      {"metric2",
       %{
         "attributes" => %{
           "created_by_ua" => "testsson",
           "display_min" => 0.0,
           "display_units_long" => "",
           "l2met_type" => "counter",
           "summarize_function" => "sum"
         },
         "description" => nil,
         "display_name" => nil,
         "name" => "metric2",
         "period" => 60,
         "source_lag" => nil,
         "type" => "gauge"
       }}
    ]

    MetricsStore.start_link()
    MetricsStore.store(metrics)
    assert MetricsStore.get() == metrics
  end
end
