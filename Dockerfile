FROM ubuntu:18.04

LABEL maintainer "Akira Shinohara <k017c1067@it-neec.jp>"

# nvimのリポジトリ追加のために必要
RUN apt-get update && apt-get install -y software-properties-common 

# 最低限必要なパッケージ
RUN add-apt-repository ppa:neovim-ppa/stable -y && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    build-essential \
    curl \
    gcc \
    git \
    liblzma-dev \
    libxml2-dev \
    libxslt1-dev \
    locales \
    neovim \
    nodejs \
    npm \
    patch \
    python3 \
    python3-pip \
    ruby \
    ruby-dev \
    zlib1g-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# aptのnodejsは古いのでnで入れ直す
RUN npm i -g n && \
    n latest && \
    apt-get purge nodejs npm -y

# マルチバイト文字をまともに扱うための設定
RUN locale-gen en_US.UTF-8
ENV LANG="en_US.UTF-8" LANGUAGE="en_US:ja" LC_ALL="en_US.UTF-8"

RUN pip3 install --upgrade \
    pip \
    pyls-black \
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

# wakatimeのダミー設定 プラグインインストール時にAPI KEYを聞かれないために必須
RUN echo '[settings] \napi_key = DUMMY' > /root/.wakatime.cfg

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
