# syntax = docker/dockerfile:1.3-labs

##################
### base image ###
##################
FROM debian:buster-slim as base

# install apt dependencies package
RUN <<EOF

  apt-get update
  apt-get upgrade -y

  apt-get install -y curl
  apt-get install -y git
  apt-get install -y language-pack-en
  apt-get install -y locales
  apt-get install -y python3
  apt-get install -y python3-pip

  apt-get clean
  rm -rf /var/lib/apt/lists/*
EOF

# create locale
RUN locale-gen en_US.UTF-8

# install node.js 16.x and yarn
RUN <<EOF
  curl -fsSL https://deb.nodesource.com/setup_16.x | bash -

  apt-get install -y nodejs

  apt-get clean
  rm -rf /var/lib/apt/lists/*

  npm i -g yarn
EOF

# install neovim python3 provider
RUN pip3 install neovim

########################
### fetch nvim stage ###
########################
FROM debian:buster-slim as nvim-fetcher

WORKDIR /tmp

RUN <<EOF
  apt-get update
  apt-get upgrade -y

  apt-get install -y curl

  apt-get clean
  rm -rf /var/lib/apt/lists/*
EOF

RUN curl -L https://github.com/neovim/neovim/releases/download/v0.6.0/nvim.appimage -o nvim.appimage

RUN chmod a+x /tmp/nvim.appimage
RUN /tmp/nvim.appimage --appimage-extract

###########################
### fetch plugins stage ###
###########################

FROM debian:buster-slim as plugins-fetcher

RUN mkdir /tmp/plugins
RUN mkdir /tmp/plugins/start
RUN mkdir /tmp/plugins/opt

RUN <<EOF
  apt-get update
  apt-get upgrade -y

  apt-get install -y git

  apt-get clean
  rm -rf /var/lib/apt/lists/*
EOF

# fetch start plugins
WORKDIR /tmp/plugins/start
RUN <<EOF
  git clone https://github.com/airblade/vim-gitgutter.git
  git clone https://github.com/markvincze/panda-vim.git
  git clone https://github.com/neoclide/coc.nvim.git -b release
  git clone https://github.com/scrooloose/nerdtree.git
  git clone https://github.com/tpope/vim-surround.git
  git clone https://github.com/vim-airline/vim-airline.git
  git clone https://github.com/vim-airline/vim-airline-themes.git
EOF

# fetch opt plugins
WORKDIR /tmp/plugins/opt
RUN <<EOF
  git clone https://github.com/prettier/vim-prettier.git
EOF

#####################
### release image ###
#####################
FROM base as nvim

ENV LANG='en_US.UTF-8'
ENV LC_ALL='en_US.UTF-8'
ENV LANGUAGE='en_US:ja'

RUN mkdir /home/working
WORKDIR /home/working

COPY --from=nvim-fetcher /tmp/squashfs-root/usr /usr/local/nvim
RUN ln -s /usr/local/nvim/bin/nvim /usr/local/bin/nvim

COPY nvim /root/.config/nvim

RUN mkdir /root/.config/nvim/pack/
RUN mkdir /root/.config/coc/
COPY --from=plugins-fetcher /tmp/plugins /root/.config/nvim/pack/plugins

# install coc-plugins
RUN nvim +'CocInstall -sync \
  coc-ansible \
  coc-css \
  coc-eslint \
  coc-json \
  coc-prettier \
  coc-tsserver' \
  +qall

ENTRYPOINT [ "nvim" ]
