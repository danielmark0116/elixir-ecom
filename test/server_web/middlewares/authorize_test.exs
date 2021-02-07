defmodule EcomWeb.Middlewares.AuthorizeTest do
  use EcomWeb.ConnCase
  import Ecom.Factory

  alias Absinthe.Resolution
  alias Ecom.Accounts
  alias EcomWeb.Middlewares.Authorize

  @expected_errors ["Unauthorized"]

  setup %{conn: conn} do
    user = insert(:user)
    admin = insert(:admin)
    superuser = insert(:superuser)

    r = %Resolution{context: %{}}
    ur = %Resolution{context: %{current_user: user}}
    ar = %Resolution{context: %{current_user: admin}}
    sr = %Resolution{context: %{current_user: superuser}}

    {:ok,
     user: user, admin: admin, superuser: superuser, conn: conn, r: r, ur: ur, ar: ar, sr: sr}
  end

  describe "authorize middleware" do
    test "access for :any", %{r: r, ur: ur, ar: ar, sr: sr} do
      %{errors: no_user_errors} = Authorize.call(r, :any)
      %{errors: user_errors} = Authorize.call(ur, :any)
      %{errors: admin_errors} = Authorize.call(ar, :any)
      %{errors: superuser_errors} = Authorize.call(sr, :any)

      assert no_user_errors == @expected_errors
      assert Enum.count(no_user_errors) == 1

      assert user_errors == []
      assert Enum.count(user_errors) == 0

      assert admin_errors == []
      assert Enum.count(admin_errors) == 0

      assert superuser_errors == []
      assert Enum.count(superuser_errors) == 0
    end

    test "access for :user", %{r: r, ur: ur, ar: ar, sr: sr} do
      %{errors: no_user_errors} = Authorize.call(r, :user)
      %{errors: user_errors} = Authorize.call(ur, :user)
      %{errors: admin_errors} = Authorize.call(ar, :user)
      %{errors: superuser_errors} = Authorize.call(sr, :user)

      assert no_user_errors == @expected_errors
      assert Enum.count(no_user_errors) == 1

      assert user_errors == []
      assert Enum.count(user_errors) == 0

      assert admin_errors == []
      assert Enum.count(admin_errors) == 0

      assert superuser_errors == []
      assert Enum.count(superuser_errors) == 0
    end

    test "access for :admin", %{r: r, ur: ur, ar: ar, sr: sr} do
      %{errors: no_user_errors} = Authorize.call(r, :admin)
      %{errors: user_errors} = Authorize.call(ur, :admin)
      %{errors: admin_errors} = Authorize.call(ar, :admin)
      %{errors: superuser_errors} = Authorize.call(sr, :admin)

      assert no_user_errors == @expected_errors
      assert Enum.count(no_user_errors) == 1

      assert user_errors == @expected_errors
      assert Enum.count(user_errors) == 1

      assert admin_errors == []
      assert Enum.count(admin_errors) == 0

      assert superuser_errors == []
      assert Enum.count(superuser_errors) == 0
    end

    test "access for :superuser", %{r: r, ur: ur, ar: ar, sr: sr} do
      %{errors: no_user_errors} = Authorize.call(r, :superuser)
      %{errors: user_errors} = Authorize.call(ur, :superuser)
      %{errors: admin_errors} = Authorize.call(ar, :superuser)
      %{errors: superuser_errors} = Authorize.call(sr, :superuser)

      assert no_user_errors == @expected_errors
      assert Enum.count(no_user_errors) == 1

      assert user_errors == @expected_errors
      assert Enum.count(user_errors) == 1

      assert admin_errors == @expected_errors
      assert Enum.count(admin_errors) == 1

      assert superuser_errors == []
      assert Enum.count(superuser_errors) == 0
    end

    test "access for NO-MATCH", %{ur: ur} do
      %{errors: errors} = Authorize.call(ur, :some_value)

      assert errors == @expected_errors
      assert Enum.count(errors) == 1
    end
  end
end
