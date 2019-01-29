defmodule CubaLibrato.CredentialsStoreTest do
  use ExUnit.Case

  alias CubaLibrato.{Credentials, CredentialsStore}

  test "Store credentials" do
    CredentialsStore.start_link()

    assert CredentialsStore.credentials_src() == nil
    assert CredentialsStore.credentials_dest() == nil
    assert CredentialsStore.space_src() == nil
    assert CredentialsStore.space_dest() == nil

    CredentialsStore.set_src(Credentials.new("username_src", "token_src"), "rymden")
    CredentialsStore.set_dest(Credentials.new("username_dest", "token_dest"), "spejs")

    credentials_src = CredentialsStore.credentials_src()
    credentials_dest = CredentialsStore.credentials_dest()

    assert credentials_src.username == "username_src"
    assert credentials_src.token == "token_src"
    assert CredentialsStore.space_src() == "rymden"
    assert credentials_dest.username == "username_dest"
    assert credentials_dest.token == "token_dest"
    assert CredentialsStore.space_dest() == "spejs"
  end
end
