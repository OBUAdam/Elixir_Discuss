defmodule Discuss.CommentsChannel do
    use Discuss.Web, :channel
    
    alias Discuss.{Topic, Comment}

    def join("comments:" <> topicId, _params, socket) do
        topicId = String.to_integer(topicId)

        topic = Topic
            |> Repo.get(topicId)
            |> Repo.preload(comments: [:user])
        
        {:ok, %{comments: topic.comments}, assign(socket, :topic, topic)}
    end

    def handle_in(name, %{"content" => content}, socket) do
        topic = socket.assigns.topic
        userId = socket.assigns.userId

        changeset = topic
            |> build_assoc(:comments, userId: userId)
            |> Comment.changeset(%{content: content})

        case Repo.insert(changeset) do
            {:ok, comment} ->
                comment = Repo.preload(comment, :user)
                broadcast!(socket, "comments:#{socket.assigns.topic.id}:new", %{comment: comment})
                {:reply, :ok, socket}
            {:error, _reason} ->
                {:reply, {:error, %{errors: changeset}}, socket}
        end
    end
end