defmodule Discuss.TopicController do
    use Discuss.Web, :controller

    alias Discuss.Topic

    def index(conn, _params) do
        topics = Repo.all(Topic)

        IO.inspect("---CONN!------------------------------------------------")
        IO.inspect(conn.assigns)
        IO.inspect("---CONN!------------------------------------------------")

        render conn, "index.html", topics: topics
    end

    def new(conn, _params) do
        changeset = Topic.changeset(%Topic{}, %{})

        render conn, "new.html", changeset: changeset
    end

    def create(conn, %{"topic" => topic}) do
        changeset = Topic.changeset(%Topic{}, topic)

        case Repo.insert(changeset) do
            {:ok, _topic} ->
                conn
                |> put_flash(:info, "Topic Created")
                |> redirect(to: topic_path(conn, :index))
            {:error, bad} -> render conn, "new.html", changeset: bad
        end
    end

    def edit(conn, %{"id" => topicId}) do
        topic = Repo.get(Topic, topicId)

        changeset = Topic.changeset(topic)

        render conn, "edit.html", changeset: changeset, topic: topic
    end

    def update(conn, %{"topic" => topic, "id" => topicId}) do
        oldTopic = Topic |> Repo.get(topicId)

        changeset = Topic.changeset(oldTopic, topic)

        case Repo.update(changeset) do
            {:ok, _topic} ->
                conn
                |> put_flash(:info, "Topic Updated")
                |> redirect(to: topic_path(conn, :index))
            {:error, bad} -> render conn, "edit.html", changeset: bad, topic: oldTopic
        end
    end

    def delete(conn, %{"id" => topicId}) do
        Topic
            |> Repo.get!(topicId)
            |> Repo.delete!

        conn
            |> put_flash(:info, "Topic Deleted")
            |> redirect(to: topic_path(conn, :index))
    end
end