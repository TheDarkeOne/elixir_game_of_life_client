defmodule GameOfLifeClient do
  @moduledoc """
  Start your game of life server by running the following command:

  docker pull snowcollege/gameoflife-server
  docker run -it --rm -p 0.0.0.0:80:80 snowcollege/gameoflife-server

  """
  alias HTTPoison

  def start do
    {:ok, guid} = register("http://localhost", "test")
    guid
  end

  def register(endpoint, name) do
    HTTPoison.start
    body = Poison.encode!(%{name: name})
    headers = [{"Content-type", "application/json"}]
    case HTTPoison.post!(endpoint<>"/register", body, headers) do
      %HTTPoison.Response{status_code: 500} ->
        register(endpoint, name <> "_1")
      %HTTPoison.Response{status_code: 200, body: body} ->
        body
        |> Poison.decode
        |> case do
          {:ok, %{"token" => token}} -> {:ok, token}
          _ -> {:error, "Unable to identify token in 200 response"}
        end
      _ ->
        {:error, "Unable to parse response"}
    end
  end
end
