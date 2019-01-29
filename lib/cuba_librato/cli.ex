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

    IO.puts("")

    download(source_space, source_credentials)

    IO.puts("")

    if confirm() do
      upload(destination_space, destination_credentials)
    end
  end

  def get_config() do
    src = EnvFetcher.credentials_src()
    username_src = src.username || ask("Librato source username")
    token_src = src.token || ask("Librato source token")
    space_src = EnvFetcher.space_src() || ask("Librato source space")

    IO.puts("")

    dest = EnvFetcher.credentials_dest()
    username_dest = dest.username || ask("Librato destination username")
    token_dest = dest.token || ask("Librato destination token")
    space_dest = EnvFetcher.space_dest() || ask("Librato destination space")

    IO.puts("")
    IO.puts("Download from Librato account: #{username_src}, space: #{space_src}")
    IO.puts("Upload to Librato account: #{username_dest}, space: #{space_dest}")

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

  def download(space, credentials) do
    CubaLibrato.download(space, credentials)
    IO.puts("Download completed")
  end

  def upload(space, credentials) do
    CubaLibrato.upload(space, credentials)
    IO.puts("")
    IO.puts("Upload completed")
  end

  defp confirm() do
    CubaLibrato.print_pre_upload_info()
    IO.puts("")
    ask("'yes' to continue") == "yes"
  end

  defp ask(question) do
    IO.gets("#{question}: ")
    |> String.trim()
  end
end
