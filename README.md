# 使い方

```
sh file_logrotate.sh <ログディレクトリ> <ログファイル名> <世代数>
```

(例)nginxのアクセスログをローテションする場合(世代数5)

```
sh  file_logrotate.sh /var/log/nginx access.log 5
```

コンテナ内のログをローテートしたい場合は、
当シェルファイルをコンテナ内にコピー下さい。

(例) nginxコンテナ内にシェルをコピー

```
docker cp /root/file_logrotate.sh nginx:/(シェルを配置するパス)
```

ホストからは上記のコマンドを実行すると、コンテナ内でシェルを実行することができます。
(cronに仕掛けることで、定期実行が可能。)

```
docker-compose exec -T nginx bash -c 'sh /(シェルを配置したパス)/file_logrotate.sh /var/log/nginx access.log 5'
```
