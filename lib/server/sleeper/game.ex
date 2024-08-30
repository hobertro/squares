defmodule Server.Sleeper.Game do
  use GenServer

  # https://docs.sleeper.com/

  @refresh_time_scores 5_000
  @refresh_time_state 5_000

  def start(sport) do
    GenServer.start(Server.Sleeper.Game, sport, name: __MODULE__)
  end

  @spec get_state(atom() | pid() | {atom(), any()} | {:via, atom(), any()}) :: any()
  def get_state(pid) do
    GenServer.call(pid, :get_state)
  end

  def get_scores(pid) do
    GenServer.call(pid, :get_scores)
  end

  def stop_server() do
    GenServer.call(__MODULE__, :stop_server)
  end

  def refresh_scores(pid) do
    GenServer.cast(pid, :refresh_scores)
  end

  def refresh_state(pid) do
    GenServer.cast(pid, :refresh_state)
  end

  def init(sport) do
    new_state = set_initial_state(sport)

    :timer.send_interval(@refresh_time_scores, :refresh_scores)
    :timer.send_interval(@refresh_time_state, :refresh_state)

    {:ok, new_state}
  end

  def set_initial_state(sport) do
    with {:ok, http_response_state} <- External.Sleeper.get(sport, "state"),
         state <- Jason.decode!(http_response_state.body),
         {:ok, http_response_scores} <-
           External.Sleeper.get(
             sport,
             state["season"],
             state["season_type"],
             state["week"],
             "scores"
           ),
         scores <- Jason.decode!(http_response_scores.body) do

      %{
        "scores" => scores,
        "state" => state,
        "sport" => sport
      }
    end
  end

  def handle_info(:refresh_state, state) do
    IO.puts("Refreshing state...")
    {:ok, http_response} = External.Sleeper.get(state["sport"], "state")
    new_state = Jason.decode!(http_response.body)
    updated_state = state |> Map.put("state", new_state)

    # Process.send_after(__MODULE__, :refresh_state, @refresh_time_state)
    {:noreply, updated_state}
  end

  def handle_info(:refresh_scores, state) do
    IO.puts("Refreshing scores...")
    {:ok, http_response} =
      External.Sleeper.get(
        state["sport"],
        state["state"]["season"],
        state["state"]["season_type"],
        state["state"]["week"],
        "scores"
      )

    new_state = Jason.decode!(http_response.body)
    updated_state = state |> Map.put("scores", new_state)

    # Process.send_after(__MODULE__, :refresh_scores, @refresh_time_scores)
    {:noreply, updated_state}
  end

  def handle_call(:get_scores, _, state) do
    {:reply, state["scores"], state}
  end

  def handle_call(:get_state, _, state) do
    {:reply, state["state"], state}
  end

  def handle_call(:stop_server  , _, state) do
    {:stop, "Forced stop", state}
  end
end
