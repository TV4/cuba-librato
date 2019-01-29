defmodule Mix.Tasks.CopySpace do
  use Mix.Task

  @impl Mix.Task
  def run(_args) do
    Application.ensure_all_started(:cuba_librato)
    CubaLibrato.CLI.start()
  end
end
