defmodule CubaLibrato.CredentialsEnvFetcher do
  alias CubaLibrato.Credentials

  def src() do
    Credentials.new(librato_username_src(), librato_token_src())
  end

  def dest() do
    Credentials.new(librato_username_dest(), librato_token_dest())
  end

  defp librato_username_src() do
    get_env(:librato_username_src)
  end

  defp librato_token_src() do
    get_env(:librato_token_src)
  end

  defp librato_username_dest() do
    get_env(:librato_username_dest)
  end

  defp librato_token_dest() do
    get_env(:librato_token_dest)
  end

  defp get_env(env) do
    Application.get_env(:cuba_librato, env)
  end
end
