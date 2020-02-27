moja-nvim
=========

どこでも自分のカスタムnvimが使えるようにするための設定ファイル及びコンテナイメージ


## alias
`$ alias vim='docker run --rm -it -u $(id -u):$(id -g) -e HOME=/root -v $HOME:$HOME --workdir=$(pwd) s10akir/moja-nvim'`

