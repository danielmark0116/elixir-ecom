defmodule Ecom.AccountsTest do
  use Ecom.DataCase
  import Ecom.Factory

  alias Ecom.Accounts
  alias Accounts.User

  setup _context do
    user = insert(:user)
    admin = insert(:admin)
    _superuser = insert(:superuser)

    {:ok, user: user, admin: admin}
  end

  describe "users" do
    test "list_users/0 returns all users", _context do
      all_users = Accounts.list_users()

      assert Enum.count(all_users) == 3
    end

    test "get_user!/1 returns a user by id", %{user: u} do
      user = Accounts.get_user!(u.id)

      assert user !== nil
      assert user.id == u.id
    end

    test "get_user/1 returns nil when no usre found", _context do
      user = Accounts.get_user(Ecto.UUID.autogenerate())

      assert user == nil
    end

    test "get_user!/1 raises not found exception when user does not exist", _context do
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(Ecto.UUID.autogenerate()) end
    end

    test "create_user/1 creates user of default role :user when provided with a valid changeset",
         _context do
      changeset = %{
        email: "john_doe2@mail.com",
        password: "pass12345678",
        password_confirmation: "pass12345678",
        name: "John Doe"
      }

      new_user_tuple = Accounts.create_user(changeset)

      assert {:ok, %User{email: new_user_email, role: default_role}} = new_user_tuple
      assert new_user_email == changeset.email
      assert default_role == :user
    end

    test "create_user/1 does not create user when provided with invalid email",
         _context do
      changeset = %{
        email: "john_domail.com",
        password: "pass12345678",
        password_confirmation: "pass12345678",
        name: "John Doe"
      }

      new_user_tuple = Accounts.create_user(changeset)

      assert {:error, _data} = new_user_tuple
    end

    test "create_user/1 does not create user when provided with invalid password format",
         _context do
      changeset = %{
        email: "john_doe@mail.com",
        password: "pass",
        password_confirmation: "pass",
        name: "John Doe"
      }

      new_user_tuple = Accounts.create_user(changeset)

      assert {:error, _data} = new_user_tuple
    end

    test "update_user/2 updates user when provided with valid changeset",
         %{user: user} do
      changeset = %{
        email: "new_email@mail.com",
        name: "Updated Name"
      }

      updated_user_tuple = Accounts.update_user(user, changeset)

      assert {:ok, updated_user} = updated_user_tuple
      assert updated_user.name == "Updated Name"
      assert updated_user.email == "new_email@mail.com"
    end

    test "update_user/2 DOES NOT update user when provided with existing email",
         %{user: user, admin: admin} do
      changeset = %{
        email: admin.email,
        name: "Updated Name"
      }

      updated_user_tuple = Accounts.update_user(user, changeset)

      assert {:error, updated_user} = updated_user_tuple
    end

    test "update_user/2 DOES NOT update user when provided with invalid email",
         %{user: user} do
      changeset = %{
        email: "invalid email",
        name: "Updated Name"
      }

      updated_user_tuple = Accounts.update_user(user, changeset)

      assert {:error, _updated_user} = updated_user_tuple
    end

    test "delete_user/1 deletes the user",
         %{user: user} do
      user_id = user.id

      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user_id) end
    end
  end
end
