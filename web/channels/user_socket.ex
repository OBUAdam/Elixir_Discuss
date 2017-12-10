defmodule Discuss.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel "comments:*", Discuss.CommentsChannel

  transport :websocket, Phoenix.Transports.WebSocket

  def connect(%{"token" => token}, socket) do
    case Phoenix.Token.verify(socket, "key", token) do
      {:ok, userId} ->
        {:ok, assign(socket, :userId, userId)}
      {:error, _error} ->
        :error
    end
  end

  def id(_socket), do: nil
end