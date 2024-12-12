defmodule ElixirGist.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :markup_text, :text
      add :user_id, references(:users, on_delete: :delete_all)
      add :gist_id, references(:gists, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:comments, [:user_id])
    create index(:comments, [:gist_id])
  end
end
