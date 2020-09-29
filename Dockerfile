
FROM elixir:latest

RUN apt-get update && \
    apt-get install -y postgresql-client && \
    apt-get install -y build-essential && \
    apt-get install -y inotify-tools && \
    apt-get install -y nodejs && \
    curl -L https://npmjs.org/install.sh | sh && \
    mix local.hex --force && \
    mix archive.install hex phx_new 1.5.3 --force && \
    mix local.rebar --force

RUN mkdir /app
COPY . /app
WORKDIR /app

RUN cd assets && npm install && cd ..
RUN mix deps.clean --all
RUN mix deps.get
RUN mix do compile

RUN chmod a+x /app/entrypoint.sh

CMD ["/app/entrypoint.sh"]