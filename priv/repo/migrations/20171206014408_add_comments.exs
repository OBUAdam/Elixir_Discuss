defmodule Discuss.Repo.Migrations.AddComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :content, :string
      add :userId, references(:users)
      add :topicId, references(:topics)

      timestamps()
    end
  end
end