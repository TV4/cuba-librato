defmodule CubaLibrato.DataHelperTest do
  use ExUnit.Case

  alias CubaLibrato.DataHelper

  test "metrics needed from chart" do
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
            "summary_function" => "sum",
            "type" => "gauge"
          },
          %{
            "group_function" => "sum",
            "id" => 345,
            "metric" => "metric2",
            "position" => 1,
            "source" => "*",
            "split_axis" => false,
            "summary_function" => "sum",
            "type" => "gauge"
          },
          %{
            "id" => 456,
            "metric" => "not_needed_is_annotation",
            "position" => 2,
            "source" => "*",
            "split_axis" => false,
            "type" => "annotation"
          }
        ],
        "type" => "line"
      }
    ]

    metrics_needed = DataHelper.metrics_needed_name_list(charts)

    assert Enum.member?(metrics_needed, "metric1") == true
    assert Enum.member?(metrics_needed, "metric2") == true
    assert Enum.member?(metrics_needed, "not_needed_is_annotation") == false
  end

  test "fill metrics with data and clean it" do
    metrics_data = [
      %{
        "attributes" => %{
          "created_by_ua" => "Librato Heroku Integration",
          "display_min" => 0,
          "display_units_long" => "Errors",
          "summarize_function" => "sum"
        },
        "description" => nil,
        "display_name" => nil,
        "name" => "heroku.metric1",
        "period" => 60,
        "source_lag" => nil,
        "type" => "gauge"
      },
      %{
        "attributes" => %{
          "created_by_ua" => "Librato Heroku Integration",
          "display_min" => 0,
          "display_units_long" => "Errors",
          "summarize_function" => "sum"
        },
        "description" => nil,
        "display_name" => nil,
        "name" => "heroku.metric2",
        "period" => 60,
        "source_lag" => nil,
        "type" => "gauge"
      },
      %{
        "attributes" => %{
          "created_by_ua" => "Testsson",
          "display_min" => 0,
          "display_units_long" => "Hit Rate",
          "display_units_short" => "rate",
          "summarize_function" => "max"
        },
        "description" => nil,
        "display_name" => nil,
        "name" => "test.metric.success",
        "period" => 60,
        "source_lag" => nil,
        "type" => "gauge"
      },
      %{
        "attributes" => %{
          "created_by_ua" => "Testsson",
          "display_min" => 0,
          "display_units_long" => "Errors",
          "summarize_function" => "sum"
        },
        "description" => nil,
        "display_name" => nil,
        "name" => "test.metric.fail",
        "period" => 60,
        "source_lag" => nil,
        "type" => "gauge"
      }
    ]

    expected_filled =
      metrics_filled_data = [
        {"test.metric.fail",
         %{
           "attributes" => %{
             "created_by_ua" => "Testsson",
             "display_min" => 0,
             "display_units_long" => "Errors",
             "summarize_function" => "sum"
           },
           "description" => nil,
           "display_name" => nil,
           "name" => "test.metric.fail",
           "period" => 60,
           "source_lag" => nil,
           "type" => "gauge"
         }},
        {"test.metric.success",
         %{
           "attributes" => %{
             "created_by_ua" => "Testsson",
             "display_min" => 0,
             "display_units_long" => "Hit Rate",
             "display_units_short" => "rate",
             "summarize_function" => "max"
           },
           "description" => nil,
           "display_name" => nil,
           "name" => "test.metric.success",
           "period" => 60,
           "source_lag" => nil,
           "type" => "gauge"
         }},
        {"heroku.metric1",
         %{
           "attributes" => %{
             "created_by_ua" => "Librato Heroku Integration",
             "display_min" => 0,
             "display_units_long" => "Errors",
             "summarize_function" => "sum"
           },
           "description" => nil,
           "display_name" => nil,
           "name" => "heroku.metric1",
           "period" => 60,
           "source_lag" => nil,
           "type" => "gauge"
         }}
      ]

    metrics_needed = ["test.metric.fail", "test.metric.success", "heroku.metric1"]

    credentials = CubaLibrato.Credentials.new("username", "token")

    assert DataHelper.fill_metrics_with_data(
             metrics_needed,
             metrics_data,
             credentials
           ) ==
             expected_filled

    expected_cleaned = [
      {"test.metric.fail",
       %{
         "attributes" => %{
           "display_min" => 0,
           "display_units_long" => "Errors",
           "summarize_function" => "sum"
         },
         "description" => nil,
         "display_name" => nil,
         "name" => "test.metric.fail",
         "period" => 60,
         "source_lag" => nil,
         "type" => "gauge"
       }},
      {"test.metric.success",
       %{
         "attributes" => %{
           "display_min" => 0,
           "display_units_long" => "Hit Rate",
           "display_units_short" => "rate",
           "summarize_function" => "max"
         },
         "description" => nil,
         "display_name" => nil,
         "name" => "test.metric.success",
         "period" => 60,
         "source_lag" => nil,
         "type" => "gauge"
       }}
    ]

    assert DataHelper.remove_unnecessary_data(metrics_filled_data) == expected_cleaned
  end

  test "remove_chart_ids" do
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
            "summary_function" => "sum",
            "type" => "gauge"
          },
          %{
            "group_function" => "sum",
            "id" => 345,
            "metric" => "metric2",
            "position" => 1,
            "source" => "*",
            "split_axis" => false,
            "summary_function" => "sum",
            "type" => "gauge"
          },
          %{
            "id" => 456,
            "metric" => "annotation1",
            "position" => 2,
            "source" => "*",
            "split_axis" => false,
            "type" => "annotation"
          }
        ],
        "type" => "line"
      }
    ]

    expected = [
      %{
        "name" => "Chart1",
        "streams" => [
          %{
            "group_function" => "sum",
            "metric" => "metric1",
            "position" => 0,
            "source" => "*",
            "split_axis" => false,
            "summary_function" => "sum",
            "type" => "gauge"
          },
          %{
            "group_function" => "sum",
            "metric" => "metric2",
            "position" => 1,
            "source" => "*",
            "split_axis" => false,
            "summary_function" => "sum",
            "type" => "gauge"
          },
          %{
            "metric" => "annotation1",
            "position" => 2,
            "source" => "*",
            "split_axis" => false,
            "type" => "annotation"
          }
        ],
        "type" => "line"
      }
    ]

    assert DataHelper.remove_chart_ids(charts) == expected
  end
end
