defmodule CubaLibrato.Downloader do
  alias CubaLibrato.{Credentials, DataHelper, LibratoClient}

  def download_charts(space_name, %Credentials{} = credentials_src) do
    LibratoClient.get_space_id(space_name, credentials_src)
    |> get_all_charts(credentials_src)
    |> DataHelper.remove_chart_ids()
  end

  def download_metrics_needed(charts, %Credentials{} = credentials_src) do
    metrics_data = get_metrics_data(credentials_src)

    metrics_needed_name = DataHelper.metrics_needed_name_list(charts)

    DataHelper.fill_metrics_with_data(
      metrics_needed_name,
      metrics_data,
      credentials_src
    )
    |> DataHelper.remove_unnecessary_data()
  end

  def get_metrics_data(%Credentials{} = credentials) do
    {200, body} = LibratoClient.list_metrics(credentials)
    body["metrics"]
  end

  def get_all_charts(space_id, %Credentials{} = credentials) do
    {200, body} = LibratoClient.list_charts(space_id, credentials)
    body
  end
end
