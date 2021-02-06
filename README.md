# Ecom

To start your Phoenix server:

```bash
chmod 777 ./entrypoint.sh
chmod 777 ./entrypoint-prod.sh
chmod 777 ./dev.sh

./dev.sh
```

To start `prod` locally:

```bash
docker-compose -f docker-compose.yml up [options of your liking]
```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Connecting do DB with postico

Remember to have the ports exposed for `db` service in `docker-compose.yml`. Then inspect docker container and connect to a proper host and port with a correct user name, password and db name

## Learn more

- Official website: https://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Forum: https://elixirforum.com/c/phoenix-forum
- Source: https://github.com/phoenixframework/phoenix
