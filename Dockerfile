FROM crystallang/crystal:0.31.1 as crystalbuilder

WORKDIR /src

RUN mkdir /src/views
COPY views/ /src/views
COPY dec.cr shard.lock shard.yml /src/

RUN shards
RUN crystal build dec.cr --release --static -o dec

FROM debian:buster
RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get install -y xvfb wine

WORKDIR /app
COPY --from=crystalbuilder /src/dec /app/dec
COPY ./dectalk/ /app/dectalk/
COPY ./views /app/views/
COPY ./dec.sh /app/dec.sh
COPY ./start_xvfb.sh /app/start_xvfb.sh
RUN mkdir /app/out

ENV KEMAL_ENV "production"

CMD ["./dec"]
