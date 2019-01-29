defmodule CubaLibrato.EnvFetcher do
  alias CubaLibrato.Credentials

  def credentials_src(), do: Credentials.new(username_src(), token_src())
  def space_src(), do: System.get_env("LIBRATO_SPACE_SRC")
  def credentials_dest(), do: Credentials.new(username_dest(), token_dest())
  def space_dest(), do: System.get_env("LIBRATO_SPACE_DEST")

  def librato_base_url(),
    do: System.get_env("LIBRATO_BASE_URL") || "https://metrics-api.librato.com"

  defp username_src(), do: System.get_env("LIBRATO_USERNAME_SRC")
  defp token_src(), do: System.get_env("LIBRATO_TOKEN_SRC")
  defp username_dest(), do: System.get_env("LIBRATO_USERNAME_DEST")
  defp token_dest(), do: System.get_env("LIBRATO_TOKEN_DEST")
end
