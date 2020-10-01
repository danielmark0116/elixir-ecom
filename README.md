# Elixir, Phoenix and Docker starter 🐳 🧪

## ▶️ Before you start

☝🏽 Make sure that you have **docker**, **docker-compose**, **Erlang VM**, **Elixir**, **Node JS** and other optional packages installed on your system. Here are the links to get you starter with all of them:

- [Get Docker 🐳](https://docs.docker.com/get-docker/)
- [Get Docker Compose 🐳](https://docs.docker.com/compose/install/)
- [Phoenix installation guide 🧪](https://hexdocs.pm/phoenix/installation.html)

## ▶️ How to run it

1. Clone the repo ➡️ `git@github.com:TheWidlarzGroup/elixir-phoenix-docker-starter.git`
2. Generate a new 🧪 **Phoenix** 🧪 app inside the cloned repo (e.g. as in this guide with `Starter` as our base module name and `server` as the name of the application. Further occurencies of these values just exchange with the ones of your choice) with this command:

   ```jsx
   mix phx.new . --module Starter --app server
   ```

   <sub>\* ❗️ replace `Starter` and `server` with your own names</sub>

   <sub>\*\* 👉🏽 [more on mix tasks](https://hexdocs.pm/phoenix/Mix.Tasks.Phx.New.html)</sub>

3. Append newly created `.gitignore` file with:

   - `.env`
   - `/db` and `/pgadmin` -> mapped volumes from our docker setup

4. Create `.env` file and add all the neccessary environment variabless to it, like so:

   ```
   MIX_ENV=dev // or prod depending whether you want to run the app in development or production mode

   APP_PORT=4000
   APP_HOSTNAME=localhost // in production change it to e.g. myapp.com

   SECRET_KEY_BASE=X // you can easily generate it with mix

   POSTGRES_PORT=5433
   PGPORT=5433
   POSTGRES_USER=db_user
   POSTGRES_PASSWORD=qwerty
   POSTGRES_DB=db
   PGHOST=db
   PGDATA=/var/lib/postgresql/data/pgdata
   ```

   All the variables are pretty much self-explanatory, we define _user name_ and _password_ for our database, _databse port_, app _hostname_ and app _port_, ➕ 🔑 _secret key base_ 🔑 for our app (you can generate it with `mix phx.gen.secret`).

   _MIX_ENV_ is responsible for picking up an appropriate config file from config folder (that is `config.ex` will be appended by say `dev.ex` when we provide `dev` as an _MIX_ENV_ variable)

4b. Don't forget about secreet key base, just a reminder 😀

5. Update the project's config 🔧:

   - create new file `releases.exs` in `config`. Add following to it:

     ```jsx
     import Config

     secret_key_base = System.fetch_env!("SECRET_KEY_BASE")
     app_port = System.fetch_env!("APP_PORT")
     app_hostname = System.fetch_env!("APP_HOSTNAME")
     db_user = System.fetch_env!("POSTGRES_USER")
     db_password = System.fetch_env!("POSTGRES_PASSWORD")
     db_host = System.fetch_env!("PGHOST")
     db_name = System.fetch_env!("POSTGRES_DB")

     config :server, StarterWeb.Endpoint,
        http: [:inet6, port: String.to_integer(app_port)],
        secret_key_base: secret_key_base

     config :server,
        app_port: app_port

     config :server,
        app_hostname: app_hostname

     config :server, Starter.Repo,
         username: db_user,
         password: db_password,
         database: db_name,
         hostname: db_host,
         pool_size: 10

     ```

     You can also config the `Repo` by overwriting the `init` method in your `Repo` module (`lib/server/repo.ex`). We provide the valid connection data this way for the dev config:

     ```jsx
      defmodule Starter.Repo do
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

     ```

   - in `config/dev.ex` update the `Repo` config:

     ```jsx
     config :server, Starter.Repo,
        username: System.get_env("POSTGRES_USER"),
        password: System.get_env("POSTGRES_PASSWORD"),
        database: System.get_env("POSTGRES_DB"),
        hostname: System.get_env("PGHOST"),
        show_sensitive_data_on_connection_error: true,
        pool_size: 10
     ```

   - in `config/prod.ex` update the `Endpoint` config (_host_ and _port_ values):

     ```jsx
      config :server, StarterWeb.Endpoint,
         url: [host: Application.get_env(:server, :app_hostname), port: Application.get_env(:server, :app_port)],
         cache_static_manifest: "priv/static/cache_manifest.json"
     ```

     <sub>\* remember to exchange `:server` atom with your application name</sub>

   - append the `Endpoint` settings in `config/prod.ex` with this:

     ```jsx
        config :server, StarterWeb.Endpoint, server: true
     ```

   - delete 🗑 the `import_config "prod.secret.exs"` line from `config/prod.ex`

6. Add `Starter.Release` module in e.g. `release.ex` file in `lib/server/release.ex`

   ```jsx
   defmodule Chatly.Release do
      @app :server

      def migrate do
         for repo <- repos() do
            {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
         end
      end

      def rollback(repo, version) do
         {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
      end

      defp repos do
         Application.load(@app)
         Application.fetch_env!(@app, :ecto_repos)
      end
   end
   ```

   <sub>\* Don't forget to exchange the `:server` atom with your application name</sub>

7. Edit `entrypoint-prod.sh` - script needed for our production setup:

   - change these lines:

     ```jsx
     ./prod/rel/APPNAME/bin/APPNAME eval AppName.Release.migrate

     ./prod/rel/APPNAME/bin/APPNAME start
     ```

   - with appropriate app and module names, e.g. when you create an app with `mix phx.new . --module Starter --app server` it should look like this:

     ```jsx
     ./prod/rel/server/bin/server eval Starter.Release.migrate

     ./prod/rel/server/bin/server start
     ```

8. Give executable rights for `dev.sh`, `entrypoint.sh` and `entrypoint-prod.sh` scripts (you need to do it on your machine, while copying the files, _docker_ will copy everything along with the permissions):

   - `chmod 777 dev.sh` etc

9. Before running your app, you can run the code formatter with `mix format`.

10. Run the server

    - **development** ➡️ `./dev.sh` (or run `docker-compose -f docker-compose.yml -f docker-compose.dev.yml up` manually with options of your choice)
    - **production** ➡️ simply `docker-compose up`

---

## ▶️ Useful docker commands:

- `docker-compose down` - stops containers and removes containers, networks, volumes, and images created by up [more here](https://docs.docker.com/compose/reference/down/).
- `docker-compose up -d` - run containers in the background in detached mode [more here](https://docs.docker.com/compose/reference/up/)
- `docker-compose up --build` - build images before starting containers [more here](https://docs.docker.com/compose/reference/up/)
- `docker-compose up --force-recreate` - Recreate containers even if their configuration and image haven't changed [more here](https://docs.docker.com/compose/reference/up/)
