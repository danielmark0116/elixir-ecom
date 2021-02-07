defmodule Ecom.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @user_roles [:superuser, :admin, :user]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :email, :string
    field :name, :string
    field :password_hash, :string
    field :role, Ecto.Enum, values: @user_roles, default: :user

    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password, :password_confirmation])
    |> validate_required([:name, :email, :password, :password_confirmation])
    |> validate_password()
    |> validate_email()
    |> validate_inclusion(:role, @user_roles)
    |> hash_pass()
    |> validate_required(:password_hash)
  end

  def update_changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
    |> validate_email()
  end

  @doc false
  defp hash_pass(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    changeset
    |> change(Argon2.add_hash(password))
  end

  defp hash_pass(changeset), do: changeset

  defp validate_password(changeset) do
    changeset
    |> validate_length(:password, min: 8, max: 255)
    |> validate_confirmation(:password)
  end

  defp validate_email(changeset) do
    changeset
    |> validate_format(:email, ~r/^\S+@\S+\.\S+$/)
    |> update_change(:email, &String.downcase/1)
    |> unique_constraint(:email)
  end
end
