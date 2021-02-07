defmodule EcomWeb.Plugs.UserContextPlug do
  @behaviour Plug
  import Plug.Conn
  alias Ecom.Guardian

  def init(opts), do: opts

  def call(conn, _opts) do
    context = build_user_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  defp build_user_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, claims} <- Guardian.decode_and_verify(token),
         {:ok, user} <- Guardian.resource_from_claims(claims) do
      IO.inspect(%{current_user: user})
      %{current_user: user}
    else
      _ ->
        IO.puts("Could not build user context from token")
        %{}
    end
  end
end
