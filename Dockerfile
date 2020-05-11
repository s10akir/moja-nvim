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
    pynvim

RUN gem install -N \
    etc \
    json \
    rubocop \
    rubocop-performance \
    rubocop-rails \
    rubocop-rspec \
    solargraph

RUN npm install -g \
    prettier \
    @prettier/plugin-ruby \
    @prettier/plugin-xml \
    prettier-plugin-toml \
    yarn

# install dein.vim
RUN curl -sf https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh \
    | sh -s /root/.cache/dein

# install vim plugins
COPY nvim /root/.config/nvim

# wakatimeのダミー設定 プラグインインストール時にAPI KEYを聞かれないために必須
RUN echo '[settings] \napi_key = DUMMY' > /root/.wakatime.cfg

RUN nvim -c "q"

# プラグインインストール後は不要
RUN rm /root/.wakatime.cfg

ENTRYPOINT ["nvim"]
