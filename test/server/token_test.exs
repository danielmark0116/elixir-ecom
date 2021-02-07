defmodule Ecom.TokenTests do
  use Ecom.DataCase
  import Ecom.Factory

  alias Ecom.Accounts

  describe "Token - account confirmation" do
    test "generate_account_confirmation_token/1 should generate token and bound user to it" do
      user = insert(:user)

      token = Ecom.Token.generate_account_confirmation_token(user.id)

      {:ok, user_bound_to_token} = Ecom.Token.verify_account_confirmation_token(token)

      assert user_bound_to_token.id == user.id
    end

    @tag :only_this
    test "generate_account_confirmation_token/1 should generate token valid only for a day" do
      user = insert(:user)

      now = DateTime.utc_now()

      day_before = DateTime.add(now, -87400, :second) |> DateTime.to_unix()

      token = Ecom.Token.generate_account_confirmation_token(user.id, day_before)

      assert {:error, :expired} = Ecom.Token.verify_account_confirmation_token(token)
    end
  end
end
