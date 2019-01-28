defmodule CubaLibrato.Uploader do
  alias CubaLibrato.{Credentials, LibratoClient}

  def upload_all_metrics(metrics_to_upload, %Credentials{} = credentials_dest) do
    metrics_to_upload
    |> Enum.each(fn
      {metric_name, metric} ->
        LibratoClient.create_metric(metric_name, metric, credentials_dest)
    end)
  end

  def upload_charts(charts, space_id, %Credentials{} = credentials_dest) do
    charts
    |> Enum.each(fn chart ->
      LibratoClient.create_chart(space_id, chart, credentials_dest)
    end)
  end
end
