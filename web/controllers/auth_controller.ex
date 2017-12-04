defmodule Discuss.AuthController do
    use Discuss.Web, :controller
    plug Ueberauth

    alias Discuss.User

    def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
        userParams = %{email: auth.info.email, provider: "github", token: auth.credentials.token}

        changeset = User.changeset(%User{}, userParams)

        signIn(conn, changeset)
    end

    defp signIn(conn, changeset) do
        case insertOrUpdateUser(changeset) do
            {:ok, user} ->
                conn
                |> put_flash(:info, "Welcome!")
                |> put_session(:userId, user.id)
                |> redirect(to: topic_path(conn, :index))
            {:error, _reason} ->
                conn
                |> put_flash(:info, "Error Signing In")
                |> redirect(to: topic_path(conn, :index))
        end
    end

    defp insertOrUpdateUser(changeset) do
        case Repo.get_by(User, email: changeset.changes.email) do
            nil -> Repo.insert(changeset)
            user -> {:ok, user}
        end
    end

    def signout(conn, _params) do
        conn
        |> configure_session(drop: true)
        |> put_flash(:info, "See you later!")
        |> redirect(to: topic_path(conn, :index))
    end
end