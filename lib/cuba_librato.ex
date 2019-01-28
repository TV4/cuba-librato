defmodule CubaLibrato do
  alias CubaLibrato.{ChartsStore, Credentials, Downloader, MetricsStore, LibratoClient, Uploader}

  def upload(space_name, %Credentials{} = credentials_dest) do
    MetricsStore.get()
    |> Uploader.upload_all_metrics(credentials_dest)

    space_id = LibratoClient.get_space_id(space_name, credentials_dest)

    ChartsStore.get()
    |> Uploader.upload_charts(space_id, credentials_dest)

    IO.puts("Upload completed")
  end

  def download(space_name, %Credentials{} = credentials_src) do
    charts = Downloader.download_charts(space_name, credentials_src)
    ChartsStore.start_link()
    ChartsStore.store(charts)

    metrics_needed = Downloader.download_metrics_needed(charts, credentials_src)
    MetricsStore.start_link()
    MetricsStore.store(metrics_needed)

    print_pre_upload_info()
    IO.puts("Download completed")
  end

  def print_pre_upload_info() do
    IO.puts("#{length(ChartsStore.get())} charts to upload")
    IO.puts("#{length(MetricsStore.get())} metrics to upload")
  end
end
