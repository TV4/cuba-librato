defmodule CubaLibrato.CredentialsStore do
  use Agent

  alias CubaLibrato.Credentials

  def start_link() do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def set_src(%Credentials{} = credentials) do
    set(:src, credentials)
  end

  def set_dest(%Credentials{} = credentials) do
    set(:dest, credentials)
  end

  def src() do
    get(:src)
  end

  def dest() do
    get(:dest)
  end

  defp set(key, %Credentials{} = credentials) do
    Agent.update(
      __MODULE__,
      &Map.put(&1, key, credentials)
    )
  end

  defp get(key) do
    Agent.get(__MODULE__, &Map.get(&1, key))
  end
end
