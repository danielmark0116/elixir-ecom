defmodule EcomWeb.Mutations.UserMutations do
  use Absinthe.Schema.Notation
  alias EcomWeb.Resolvers.UserResolvers

  object :user_mutations do
    @desc "User SIGN UP"
    field :create_user, :user do
      arg(:email, non_null(:string))
      arg(:name, non_null(:string))
      arg(:password, non_null(:string))
      arg(:password_confirmation, non_null(:string))

      resolve(&UserResolvers.create_user/3)
    end
  end
end
