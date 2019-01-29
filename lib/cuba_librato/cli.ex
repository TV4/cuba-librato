defmodule CubaLibrato.CLI do
  alias CubaLibrato.{Credentials, EnvFetcher, CredentialsStore}

  def main(_args) do
    CredentialsStore.start_link()

    IO.puts("""
    Welcome to CubaLibrato.
    Type `h` for help
    """)

    check_environment_variables()
    download()

    if confirm() do
      upload()
    end
  end

  def check_environment_variables() do
    src = EnvFetcher.credentials_src()
    username_src = src.username || receive_username("Source")
    token_src = src.token || receive_token("Source")
    space_src = EnvFetcher.space_src() || receive_space("Source")
    CredentialsStore.set_src(Credentials.new(username_src, token_src), space_src)

    IO.inspect({username_src, space_src}, label: "source")

    dest = EnvFetcher.credentials_dest()
    username_dest = dest.username || receive_username("Destination")
    token_dest = dest.token || receive_token("Destination")
    space_dest = EnvFetcher.space_dest() || receive_space("Destination")
    CredentialsStore.set_dest(Credentials.new(username_dest, token_dest), space_dest)
    IO.inspect({username_dest, space_dest}, label: "destination")
  end

  def execute_command(["h" | _rest]) do
    print_help()
    receive_command()
  end

  # def execute_command(["set", account | _]) when account == "src" or account == "dest" do
  #   username = receive_username()
  #   token = receive_token()

  #   credential = Credentials.new(username, token)

  #   if(account == "src") do
  #     CredentialsStore.set_src(credential)
  #   else
  #     CredentialsStore.set_dest(credential)
  #   end

  #   receive_command()
  # end

  def download() do
    credentials = CredentialsStore.credentials_src()
    space = CredentialsStore.space_src()
    CubaLibrato.download(space, credentials)
  end

  def upload() do
    credentials = CredentialsStore.credentials_dest()
    space = CredentialsStore.space_dest()
    CubaLibrato.upload(space, credentials)
  end

  def execute_command(command) do
    IO.puts("No such command: #{Enum.join(command, " ")}")
    receive_command()
  end

  def print_help() do
    IO.puts("""
    This tool copies all charts and metrics in a space between two
    Librato accounts.

    You'll need to set your source and destination Librato credentials.
    You can do so by either using the commands `set src` and `set dest`
    or by setting the following environment variables
    `LIBRATO_USERNAME_SRC`, `LIBRATO_TOKEN_SRC`, `LIBRATO_USERNAME_DEST`,
    `LIBRATO_TOKEN_DEST`.

    Use the command `download` to download all metrics and charts for a space
    from the source to memory.

    Use the command `show charts` and `show metrics` to show the downloaded data

    Use the command `upload` to upload all metrics and charts.
    You will need to confirm with `yes` before the upload starts
    """)
  end

  defp confirm() do
    yes =
      IO.gets("'yes' to continue: ")
      |> String.trim()

    yes == "yes"
  end

  defp receive_username(account) do
    IO.gets("Librato #{account} username: ")
    |> String.trim()
  end

  defp receive_token(account) do
    IO.gets("Librato #{account} token: ")
    |> String.trim()
  end

  defp receive_space(account) do
    IO.gets("Librato #{account} space: ")
    |> String.trim()
  end

  defp receive_command() do
    IO.gets("> ")
    |> case do
      :eof ->
        IO.puts("Thanks, goodbye!")

      something ->
        something
        |> String.trim()
        |> String.downcase()
        |> String.split(" ")
        |> execute_command()
    end
  end
end
