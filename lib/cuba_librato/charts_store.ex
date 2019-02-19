defmodule CubaLibrato.ChartsStore do
  use Agent

  def start_link() do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def store(charts) do
    Agent.update(__MODULE__, fn _ -> charts end)
  end

  def get() do
    Agent.get(__MODULE__, fn charts -> charts end)
  end

  def size() do
    length(get())
  end
end
