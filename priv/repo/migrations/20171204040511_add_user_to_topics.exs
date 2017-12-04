defmodule Discuss.Repo.Migrations.AddUserToTopics do
  use Ecto.Migration

  def change do
    alter table(:topics) do
      add :UserId, references(:users)
    end
  end
end