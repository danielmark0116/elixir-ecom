defmodule EcomWeb.Schema do
  use Absinthe.Schema

  import_types(EcomWeb.Types.User)
  import_types(EcomWeb.Queries.UserQueries)
  import_types(EcomWeb.Mutations.UserMutations)

  query do
    import_fields(:user_queries)
  end

  mutation do
    import_fields(:user_mutations)
  end

  # add this to your schema module
  def middleware(middleware, _field, %{identifier: :mutation}) do
    middleware ++ [EcomWeb.Middlewares.HandleChangesetErrors]
  end

  # if it's any other object keep things as is
  def middleware(middleware, _field, _object), do: middleware
end
