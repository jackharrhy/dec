FROM crystallang/crystal:0.31.1 as crystalbuilder

WORKDIR /src

ADD dec.cr shard.lock shard.yml /src/

RUN shards
RUN crystal build dec.cr --release --static -o dec

FROM scottyhardy/docker-wine:stable-2.0.1

RUN apt update && apt install xvfb -y

WORKDIR /app
COPY --from=crystalbuilder /src/dec /app/dec
RUN mkdir /app/dectalk
ADD ./dectalk/ /app/dectalk/
ADD ./dec.sh /app/dec.sh
RUN mkdir /app/out

ENV DISPLAY :0

CMD ["./dec"]
