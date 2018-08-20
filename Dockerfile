FROM rust:1.28-jessie

RUN apt-get install libssl-dev

WORKDIR /usr/src/app
COPY wait-for-it.sh wait-for-it.sh
RUN touch dummy.rs # To allow caching the dependencies

COPY Cargo.toml Cargo.toml
COPY Cargo.lock Cargo.lock

RUN cargo build --release || true # To allow caching the dependencies

COPY src src

RUN cargo build --release
RUN cargo install --bin rust_captcha

CMD ["sh", "-c", "./wait-for-it.sh -t 0 -h ${REDIS_HOST} -p 6379 -- rust_captcha"]