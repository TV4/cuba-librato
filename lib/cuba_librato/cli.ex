defmodule CubaLibrato.CLI do
  alias CubaLibrato.{Credentials, EnvFetcher}

  def start() do
    IO.puts("""
    Welcome to CubaLibrato.
    """)

    %{
      source: %{
        credentials: source_credentials,
        space: source_space
      },
      destination: %{
        credentials: destination_credentials,
        space: destination_space
      }
    } = get_config()

    download(source_space, source_credentials)

    if confirm(destination_space, destination_credentials.username) do
      upload(destination_space, destination_credentials)
    end
  end

  defp get_config() do
    IO.puts("")

    src = EnvFetcher.credentials_src()
    username_src = src.username || ask("Librato source username")
    token_src = src.token || ask("Librato source token")
    space_src = EnvFetcher.space_src() || ask("Librato source space")

    IO.puts("")

    dest = EnvFetcher.credentials_dest()
    username_dest = dest.username || ask("Librato destination username")
    token_dest = dest.token || ask("Librato destination token")
    space_dest = EnvFetcher.space_dest() || ask("Librato destination space")

    %{
      source: %{
        credentials: Credentials.new(username_src, token_src),
        space: space_src
      },
      destination: %{
        credentials: Credentials.new(username_dest, token_dest),
        space: space_dest
      }
    }
  end

  defp download(space, credentials) do
    CubaLibrato.download(space, credentials)

    IO.puts("""

    Finished downloading charts and metrics from
    Librato account: #{credentials.username}
    Librato space: #{space}
    """)
  end

  defp upload(space, credentials) do
    CubaLibrato.upload(space, credentials)

    IO.puts("""

    Upload completed
    """)
  end

  defp confirm(space_name_dest, username_dest) do
    IO.puts("""

    #{CubaLibrato.nr_of_charts()} charts and #{CubaLibrato.nr_of_metrics()} metrics will be uploaded to
    Librato account #{username_dest}
    Librato space: #{space_name_dest}
    """)

    ask("'yes' to continue") == "yes"
  end

  defp ask(question) do
    IO.gets("#{question}: ")
    |> String.trim()
  end
end
