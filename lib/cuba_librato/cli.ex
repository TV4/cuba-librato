defmodule CubaLibrato.CLI do
  alias CubaLibrato.{Credentials, CredentialsStore}

  def main(_args) do
    CredentialsStore.start_link()

    IO.puts("""
    Welcome to CubaLibrato.
    Type `h` for help
    """)

    receive_command()
  end

  def execute_command(["h" | _rest]) do
    print_help()
    receive_command()
  end

  def execute_command(["set", account | _]) when account == "src" or account == "dest" do
    username = receive_username()
    token = receive_token()

    credential = Credentials.new(username, token)

    if(account == "src") do
      CredentialsStore.set_src(credential)
    else
      CredentialsStore.set_dest(credential)
    end

    receive_command()
  end

  def execute_command(["download" | _]) do
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

  defp receive_username() do
    IO.gets("Librato username: ")
    |> String.trim()
  end

  defp receive_token() do
    IO.gets("Librato token: ")
    |> String.trim()
  end

  defp receive_command() do
    IO.gets("> ")
    |> String.trim()
    |> String.downcase()
    |> String.split(" ")
    |> execute_command()
  end
end
