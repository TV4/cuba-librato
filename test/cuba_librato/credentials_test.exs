defmodule CubaLibrato.CredentialsTest do
  use ExUnit.Case

  alias CubaLibrato.Credentials

  test "create credentials" do
    credentials = Credentials.new("username", "token")

    assert credentials.username == "username"
    assert credentials.token == "token"
  end
end
