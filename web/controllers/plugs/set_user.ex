defmodule Discuss.Plugs.SetUser do
    import Plug.Conn
    import Phoenix.Controller

    alias Discuss.Repo
    alias Discuss.User

    def init(_params) do
    end

    def call(conn, _params) do
        userId = get_session(conn, :userId)

        cond do
            user = userId && Repo.get(User, userId) ->
                assign(conn, :user, user)
            true ->
                assign(conn, :user, nil) 
        end
    end
end