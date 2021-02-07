defmodule EcomWeb.Queries.UserQueries do
  use Absinthe.Schema.Notation

  object :user_queries do
    field :user, :user do
      resolve(fn _, _ -> {:ok, %{email: "mail@asdasdsd.as asdad", name: "asd asd asd asd"}} end)
    end
  end
end
