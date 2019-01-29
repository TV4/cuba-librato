defmodule CubaLibrato.CredentialsStoreTest do
  use ExUnit.Case

  alias CubaLibrato.{Credentials, CredentialsStore}

  test "Store credentials" do
    CredentialsStore.start_link()

    assert CredentialsStore.src() == nil
    assert CredentialsStore.dest() == nil

    CredentialsStore.set_src(Credentials.new("username_src", "token_src"))
    CredentialsStore.set_dest(Credentials.new("username_dest", "token_dest"))

    credentials_src = CredentialsStore.src()
    credentials_dest = CredentialsStore.dest()

    assert credentials_src.username == "username_src"
    assert credentials_src.token == "token_src"
    assert credentials_dest.username == "username_dest"
    assert credentials_dest.token == "token_dest"
  end
end
