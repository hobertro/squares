defmodule External.Sleeper do
  @base_url "https://api.sleeper.app/v1"

  def get(sport, "state") do
    url = "#{@base_url}/state/#{sport}"
    HTTPoison.get(url)
  end

  def get(sport, season, season_type, week, "scores") do
    url = "#{@base_url}/scores/#{sport}/#{season_type}/#{season}/#{week}"
    HTTPoison.get(url)
  end
end
