defmodule Ecom.Token do
  alias Ecom.Accounts
  # one day - 86400
  @token_duration 86400
  @token_namespace "account_confirmation"

  def generate_account_confirmation_token(user_id, signed_at \\ System.system_time(:second)) do
    Phoenix.Token.sign(jwt(), @token_namespace, user_id, signed_at: signed_at)
  end

  def verify_account_confirmation_token(token) do
    with {:verify_token, {:ok, user_id}} <-
           {:verify_token,
            Phoenix.Token.verify(jwt(), @token_namespace, token, max_age: @token_duration)},
         {:fetch_user, user} <- {:fetch_user, Accounts.get_user(user_id)} do
      {:ok, user}
    else
      {:verify_token, verify_token_tuple} -> verify_token_tuple
      {:fetch_user, _data} -> {:error, :no_user_bound_to_token}
    end
  end

  defp jwt(), do: Ecom.Guardian.get_jwt_secret()
end
