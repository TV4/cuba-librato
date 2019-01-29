defmodule CubaLibrato.CredentialsStore do
  use Agent

  alias CubaLibrato.Credentials

  def start_link() do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def set_src(%Credentials{} = credentials, space) do
    set(:credentials_src, credentials)
    set(:space_src, space)
  end

  def set_dest(%Credentials{} = credentials, space) do
    set(:credentials_dest, credentials)
    set(:space_dest, space)
  end

  def credentials_src() do
    get(:credentials_src)
  end

  def credentials_dest() do
    get(:credentials_dest)
  end

  def space_src(), do: get(:space_src)
  def space_dest(), do: get(:space_dest)

  defp set(key, value) do
    Agent.update(
      __MODULE__,
      &Map.put(&1, key, value)
    )
  end

  defp get(key) do
    Agent.get(__MODULE__, &Map.get(&1, key))
  end
end
