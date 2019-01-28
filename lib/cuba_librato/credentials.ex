defmodule CubaLibrato.Credentials do
  defstruct username: "", token: ""

  def new(username, token) do
    %__MODULE__{username: username, token: token}
  end
end
