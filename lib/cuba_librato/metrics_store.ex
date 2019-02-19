defmodule CubaLibrato.MetricsStore do
  use Agent

  def start_link() do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def store(metrics) do
    Agent.update(__MODULE__, fn _ -> metrics end)
  end

  def get() do
    Agent.get(__MODULE__, fn metrics -> metrics end)
  end

  def size() do
    length(get())
  end
end
