defmodule Ecom.Factory do
  use ExMachina.Ecto, repo: Ecom.Repo

  alias Ecom.Accounts
  alias Accounts.User

  @user_password "Password"

  def user_factory do
    %User{
      name: "Jane Smith",
      password_hash: Argon2.hash_pwd_salt(@user_password),
      email: sequence(:email, &"user#{&1}@mail.com"),
      role: :user
    }
  end

  def admin_factory(), do: struct!(user_factory(), %{role: :admin})
  def superuser_factory(), do: struct!(user_factory(), %{role: :superuser})
end
