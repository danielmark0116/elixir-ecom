defmodule EcomWeb.Middlewares.Authorize do
  @behaviour Absinthe.Middleware
  alias Ecom.Accounts
  alias Accounts.User

  def call(%Absinthe.Resolution{context: context} = resolution, role) do
    with %{current_user: current_user} <- context, true <- check_role(current_user, role) do
      resolution
    else
      _ ->
        resolution
        |> Absinthe.Resolution.put_result({:error, "Unauthorized"})
    end
  end

  defp check_role(%User{} = _current_user, :any), do: true

  defp check_role(%User{role: :user}, :user), do: true
  defp check_role(%User{role: :admin}, :user), do: true
  defp check_role(%User{role: :superuser}, :user), do: true

  defp check_role(%User{role: :admin}, :admin), do: true
  defp check_role(%User{role: :superuser}, :admin), do: true

  defp check_role(%User{role: :superuser}, :superuser), do: true

  defp check_role(_, _), do: false
end
