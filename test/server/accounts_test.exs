defmodule Ecom.AccountsTest do
  use Ecom.DataCase

  alias Ecom.Accounts

  describe "users" do
    alias Ecom.Accounts.User

    @create_attrs %{email: "mail@mail.com", name: "some name", password: "pass", password_confirmation: "pass"}
    @valid_attrs %{email: "mail@mail.com", name: "some name"}
    @update_attrs %{email: "updated@mail.com", name: "some updated name"}
    @invalid_attrs %{email: "invalid", name: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@create_attrs)
        |> Accounts.create_user()


      Accounts.get_user!(user.id)
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@create_attrs)
      assert user.email == "mail@mail.com"
      assert user.name == "some name"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "create_user/1 puts USER as default role" do
      assert {:ok, %User{role: role}} = Accounts.create_user(@create_attrs)
      assert role == :user
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.email == "updated@mail.com"
      assert user.name == "some updated name"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

  end
end
