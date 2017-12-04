defmodule Discuss.User do
    use Discuss.Web, :model

    schema "users" do
        field :email, :string
        field :provider, :string
        field :token, :string
        has_many :topics, Discuss.Topic, foreign_key: :UserId

        timestamps()
    end

    def changeset(struct, params \\ %{}) do
        struct
        |> cast(params, [:email, :provider, :token])
        |> validate_required([:email, :provider, :token])
    end
end