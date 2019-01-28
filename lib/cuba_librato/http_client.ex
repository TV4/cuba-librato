defmodule CubaLibrato.HTTPClient do
  alias CubaLibrato.Credentials

  def get(path, %Credentials{} = credentials) do
    response =
      HTTPoison.get!(base_url() <> path, [],
        hackney: [basic_auth: {credentials.username, credentials.token}]
      )

    {response.status_code, Jason.decode!(response.body)}
  end

  def put(path, body, %Credentials{} = credentials) do
    response =
      HTTPoison.put!(
        base_url() <> path,
        body |> Jason.encode!(),
        [{"Content-Type", "application/json"}],
        hackney: [basic_auth: {credentials.username, credentials.token}]
      )

    response.status_code
  end

  def post(path, body, %Credentials{} = credentials) do
    response =
      HTTPoison.post!(
        base_url() <> path,
        body |> Jason.encode!(),
        [{"Content-Type", "application/json"}],
        hackney: [basic_auth: {credentials.username, credentials.token}]
      )

    response.status_code
  end

  def base_url() do
    Application.get_env(:cuba_librato, :librato_base_url)
  end
end
