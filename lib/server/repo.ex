defmodule Ecom.Repo do
  use Ecto.Repo,
    otp_app: :server,
    adapter: Ecto.Adapters.Postgres

    def init(_, config) do
       config =
          config
          |> Keyword.put(:username, System.get_env("POSTGRES_USER"))
          |> Keyword.put(:password, System.get_env("POSTGRES_PASSWORD"))
          |> Keyword.put(:database, System.get_env("POSTGRES_DB"))
          |> Keyword.put(:hostname, System.get_env("PGHOST"))
          |> Keyword.put(:port, System.get_env("POSTGRES_PORT") |> String.to_integer())

       {:ok, config}
    end
end
