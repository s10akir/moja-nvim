FROM alpine:latest

LABEL maintainer "Akira Shinohara <k017c1067@it-neec.jp>"

# マルチバイト文字をまともに扱うための設定
ENV LANG="en_US.UTF-8" LANGUAGE="en_US:ja" LC_ALL="en_US.UTF-8"

# 最低限必要なパッケージ
RUN apk update && \
    apk upgrade && \
    apk add --no-cache \
    curl \
    gcc \
    git \
    linux-headers \
    musl-dev\
    neovim \
    python-dev \
    py-pip \
    python3-dev \
    py3-pip && \
    rm -rf /var/cache/apk/*

RUN pip3 install --upgrade pip pynvim

WORKDIR /workdir

ENTRYPOINT ["nvim"]
