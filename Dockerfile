FROM elixir:alpine AS build

# install build dependencies
RUN apk add --no-cache --update build-base git python3 curl

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && mix local.rebar --force

ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get --only $MIX_ENV

RUN mkdir config
COPY config/config.exs config/$MIX_ENV.exs config/
RUN mix deps.compile

COPY priv priv
COPY assets assets
RUN mix assets.deploy

# compile and build release
COPY lib lib
RUN mix compile

COPY config/runtime.exs config/
RUN mix release

# prepare release image
FROM alpine AS app
RUN apk add --no-cache openssl libgcc libstdc++ ncurses-libs

WORKDIR /app

RUN chown nobody:nobody /app

USER nobody:nobody

COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/surface_docker ./
ENV HOME=/app

CMD ["bin/surface_docker", "start"]
