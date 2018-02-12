defmodule MemoryWeb.GameChannel do
  use MemoryWeb, :channel
  alias Memory.Game
  alias Memory.GameAgent

  def join("game:" <> name, _payload, socket) do
    if authorized?(socket, name) do
      game = GameAgent.get(name) || Game.new()
      GameAgent.put(name, game)
      socket = socket
      |> assign(:name, name)
      {:ok, Game.client_view(game), socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("toggle", %{"id" => id}, socket) do
    name = socket.assigns[:name]
    game = name
    |> GameAgent.get()
    |> Game.toggle(id)
    GameAgent.put(name, game)
    {:reply, {:ok, Game.client_view(game)}, socket}
  end

  def handle_in("reset", %{}, socket) do
    name = socket.assigns[:name]
    game = Game.new()
    GameAgent.put(name, game)
    {:reply, {:ok, Game.client_view(game)}, socket}
  end

  def handle_in("check", %{}, socket) do
    name = socket.assigns[:name]
    game = name
    |> GameAgent.get()
    |> Game.check
    GameAgent.put(name, game)
    {:reply, {:ok, Game.client_view(game)}, socket}
  end

  defp authorized?(socket, name) do
    true
  end

end
