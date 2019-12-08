FROM crystallang/crystal:0.31.1 as crystalbuilder

WORKDIR /src

ADD dec.cr shard.lock shard.yml /src/

RUN shards
RUN crystal build dec.cr --release --static -o dec

FROM debian:buster
RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get install -y xvfb wine

WORKDIR /app
COPY --from=crystalbuilder /src/dec /app/dec
RUN mkdir /app/dectalk
ADD ./dectalk/ /app/dectalk/
ADD ./dec.sh /app/dec.sh
ADD ./start_xvfb.sh /app/start_xvfb.sh
RUN mkdir /app/out

CMD ["./dec"]
