import Config

secret_key_base = System.fetch_env!("SECRET_KEY_BASE")
app_port = System.fetch_env!("APP_PORT")
app_hostname = System.fetch_env!("APP_HOSTNAME")
db_user = System.fetch_env!("POSTGRES_USER")
db_password = System.fetch_env!("POSTGRES_PASSWORD")
db_host = System.fetch_env!("PGHOST")
db_name = System.fetch_env!("POSTGRES_DB")

config :server, EcomWeb.Endpoint,
   http: [:inet6, port: String.to_integer(app_port)],
   secret_key_base: secret_key_base

config :server,
   app_port: app_port

config :server,
   app_hostname: app_hostname

config :server, Ecom.Repo,
    username: db_user,
    password: db_password,
    database: db_name,
    hostname: db_host,
    pool_size: 10
