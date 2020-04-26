moja-nvim
=========

どこでも自分のカスタムnvimが使えるようにするための設定ファイル及びコンテナイメージ

イメージ内に存在するWakaTimeの設定ファイルがダミーなので、ホスト側にWakaTimeの設定を用意してマウントしないと定期的にエラーが起こる

## alias

macでは `-u $(id -u):$(id -g)` は不要

```shell
$ alias vim='docker run --rm -it -u $(id -u):$(id -g) -e HOME=/root -v $HOME:$HOME:cached --workdir=$(pwd) s10akir/moja-nvim'
```

## wakatime
wakatimeを利用している場合、

* `~/wakatime.cfg` => `/root/wakatime.cfg`
* `~/wakatime.db` => `/root/wakatime.db`
* `~/wakatime.data` => `/root/wakatime.data`
* `~/wakatime.log` => `/root/wakatime.log`

をマウントすればwakatimeが機能する。  
存在しない場合はプラグインをロードしない。

## function
### fish

```fish
function vim --description 's10akir/moja-nvim'
  if type "docker" > /dev/null 2>&1
    docker run --rm -it \
    -e HOME=/root \
    -v $HOME:$HOME:cached \
    -v $HOME/.wakatime.cfg:/root/.wakatime.cfg \
    -v $HOME/.wakatime.db:/root/.wakatime.db \
    -v $HOME/.wakatime.data:/root/.wakatime.data \
    -v $HOME/.wakatime.log:/root/.wakatime.log \
    --workdir=(pwd) \
    s10akir/moja-nvim $argv;
  else
    eval (which vim) $argv;
  end
end
```
