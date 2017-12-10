defmodule Discuss.Comment do
    use Discuss.Web, :model

    @derive {Poison.Encoder, only: [:content, :user]}

    schema "comments" do
        field :content, :string
        belongs_to :user, Discuss.User, foreign_key: :userId
        belongs_to :topic, Discuss.User, foreign_key: :topicId

        timestamps()
    end

    def changeset(struct, params \\ %{}) do
        struct
        |> cast(params, [:content])
        |> validate_required([:content])
    end
end