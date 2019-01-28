defmodule CubaLibrato.LibratoClient do
  alias CubaLibrato.{Credentials, HTTPClient}

  def list_spaces(%Credentials{} = credentials) do
    HTTPClient.get("/v1/spaces", credentials)
    |> elem(1)
    |> Map.get("spaces")
  end

  def list_charts(space_id, %Credentials{} = credentials) do
    HTTPClient.get("/v1/spaces/#{space_id}/charts", credentials)
  end

  def get_chart(space_id, chart_id, %Credentials{} = credentials) do
    HTTPClient.get("/v1/spaces/#{space_id}/charts/#{chart_id}", credentials)
  end

  def list_metrics(%Credentials{} = credentials) do
    HTTPClient.get("/v1/metrics", credentials)
  end

  def get_metric(metric_name, %Credentials{} = credentials) do
    HTTPClient.get("/v1/metrics/#{metric_name}", credentials)
  end

  def create_metric(metric_name, body, %Credentials{} = credentials) do
    HTTPClient.put("/v1/metrics/#{metric_name}", body, credentials)
  end

  def create_chart(space_id, chart, %Credentials{} = credentials) do
    HTTPClient.post("/v1/spaces/#{space_id}/charts", chart, credentials)
  end

  def get_space_id(space_name, %Credentials{} = credentials) do
    case list_spaces(credentials)
         |> Enum.find(
           :no_such_space,
           fn space -> space["name"] == space_name end
         ) do
      :no_such_space -> exit("No space found with name: #{space_name}")
      space -> Map.get(space, "id")
    end
  end
end
