defmodule EcomWeb.Resolvers.UserResolvers do
  alias Ecom.Accounts

  def create_user(_, args, _) do
    Accounts.create_user(args)
  end
end
