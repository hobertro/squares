defmodule Server.Sleeper.State do
  use GenServer

  def init(sport) do
    External.Sleeper.get(sport, "state")
    |> case do
      {:ok, http_response} ->
        json = Jason.decode!(http_response.body)
        {:ok, json}
      {:ok, error} ->
        error
    end
  end

  # Need the genserver to get the scores

  def handle_call{:get_state, _, state} do
    {:reply, state, state}
  end
end
