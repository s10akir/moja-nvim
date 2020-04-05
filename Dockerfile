FROM alpine:latest

LABEL maintainer "Akira Shinohara <k017c1067@it-neec.jp>"


# マルチバイト文字をまともに扱うための設定
ENV LANG="en_US.UTF-8" LANGUAGE="en_US:ja" LC_ALL="en_US.UTF-8"

# 最低限必要なパッケージ
RUN apk update && \
    apk upgrade && \
    apk add --no-cache \
    build-base \
    curl \
    gcc \
    git \
    libxml2-dev \
    libxslt-dev \
    linux-headers \
    musl-dev\
    neovim \
    nodejs \
    npm \
    python-dev \
    py-pip \
    python3-dev \
    py3-pip \
    ruby \
    ruby-dev \
    && \
    rm -rf /var/cache/apk/*

RUN pip3 install --upgrade \
    pip \
    python-language-server \
    pynvim
RUN gem install -N \
    etc \
    json \
    rubocop \
    rubocop-performance \
    rubocop-rails \
    rubocop-rspec \
    solargraph
RUN npm install -g prettier eslint

# install dein.vim
RUN curl -sf https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh \
    | sh -s /root/.cache/dein

COPY nvim /root/.config/nvim

RUN nvim +:UpdateRemotePlugins +qa

# Linuxでのroot:root問題対策
RUN chmod 777 /root

RUN chmod 777 /root/.cache
RUN chmod -R 777 /root/.cache/dein

RUN chmod 777 /root/.config
RUN chmod -R 777 /root/.config/nvim

RUN chmod 777 /root/.local/
RUN chmod 777 /root/.local/share
RUN chmod -R 777 /root/.local/share/nvim

ENTRYPOINT ["nvim"]
