defmodule EcomWeb.Types.User do
  use Absinthe.Schema.Notation

  object :user do
    field :id, :id
    field :email, :string
  end
end
