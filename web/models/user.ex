defmodule BlackSwan.User do
  use BlackSwan.Web, :model

  schema "users" do
    field :name, :string
    field :username, :string
    field :password, :string
    field :password_hash, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :username, :password, :password_hash])
    |> validate_required([:name, :username, :password, :password_hash])
  end
end
