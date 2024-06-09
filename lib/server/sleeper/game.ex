defmodule Server.Sleeper.Game do
  use GenServer

  @refresh_time 60

  def start(args = %{}) do
    GenServer.start(__MODULE__, args)
  end

  def init(%{sport: sport, season: season, season_type: season_type, week: week} = args) do
    {:ok, http_response} = External.Sleeper.get(sport, season, season_type, week, "scores")
    body = Jason.decode!(http_response.body)
    new_state = args |> Map.put(:scores, body)
    {:ok, new_state}
  end

  def handle_cast(:refresh_scores, state) do
    {:ok, http_response} = External.Sleeper.get(state.sport, state.season, state.season_type, state.week, "scores")
    new_state = Jason.decode!(http_response.body)
    updated_state = state |> Map.put(:scores, new_state)
    {:noreply, updated_state}
  end

  def handle_call(:get_scores, _, state) do
    {:reply, state, state}
  end
end
