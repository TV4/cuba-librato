defmodule CubaLibrato.DataHelper do
  alias CubaLibrato.{Credentials, LibratoClient}

  def metrics_needed_name_list(charts) do
    charts
    |> Enum.map(&filter_only_metrics/1)
    |> List.flatten()
    |> remove_duplicates()
  end

  def fill_metrics_with_data(metric_names, metrics_data, %Credentials{} = credentials_src) do
    fill_metrics_with_existing_data(metric_names, metrics_data)
    |> fill_missing_metrics_data(credentials_src)
  end

  def remove_unnecessary_data(metrics) do
    metrics
    |> only_user_made_metrics()
    |> remove_created_by_field()
  end

  def remove_chart_ids(charts) do
    charts
    |> Enum.map(&Map.delete(&1, "id"))
    |> Enum.map(&remove_chart_streams_id/1)
  end

  defp fill_metrics_with_existing_data(metric_names, metrics_data) do
    all_metrics =
      metrics_data
      |> Enum.reduce(%{}, fn
        metric, map -> Map.put(map, metric["name"], metric)
      end)

    Enum.reduce(metric_names, [], fn metric, list ->
      [{metric, Map.get(all_metrics, metric)} | list]
    end)
  end

  # This function is needed because not all metrics are retrieved when calling get_metrics_data/1
  # This function looks for what metrics are missing it's data and calls librato to get them
  defp fill_missing_metrics_data(metrics_to_upload, %Credentials{} = credentials) do
    Enum.reduce(metrics_to_upload, [], fn
      {metric_name, nil}, list ->
        {200, downloaded_metric} = LibratoClient.get_metric(metric_name, credentials)
        [{metric_name, downloaded_metric} | list]

      {metric_name, metric}, list ->
        [{metric_name, metric} | list]
    end)
  end

  defp only_user_made_metrics(metrics) do
    Enum.filter(metrics, fn {_metric_name, metric} ->
      metric["attributes"]["created_by_ua"] != "Librato Heroku Integration"
    end)
  end

  defp remove_created_by_field(metrics) do
    Enum.map(metrics, fn {metric_name, metric} ->
      {metric_name, Map.update!(metric, "attributes", &Map.delete(&1, "created_by_ua"))}
    end)
  end

  defp remove_chart_streams_id(chart) do
    Map.update!(chart, "streams", fn streams ->
      Enum.map(streams, &Map.delete(&1, "id"))
    end)
  end

  defp filter_only_metrics(chart) do
    chart
    |> Map.get("streams")
    |> Enum.reduce([], fn
      %{"metric" => metric, "type" => type}, metrics when type != "annotation" ->
        [metric | metrics]

      _, metrics ->
        metrics
    end)
  end

  defp remove_duplicates(list) do
    list
    |> MapSet.new()
    |> MapSet.to_list()
  end
end
