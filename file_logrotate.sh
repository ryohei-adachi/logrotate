#!/bin/bash
#
# ログローテションと世代数を管理するシェル
#
# 引数1: ログローテート対象のログのディレクトリパス
# 引数2: ログローテート対象のログファイル名
# 引数3: 世代数
#
####################################################

shell_name=`basename $0`

#当シェルのログ設定
shell_log=${shell_name}.log
shell_error_log=${shell_name}.err

echo "${shell_name}:  START" > ${shell_name}.log

####################################################
#
# 1. 引数の設定
#
####################################################


#シェルの引数をチェック
if [ "$#" -ne 3 ]; then
  echo "エラー: 引数が正しくありません。" >&2
  echo "使用法: $0 <ログディレクトリ> <ログファイル名> <世代数>" >&2
  echo "Erro: argument check error" >> ${shell_error_log}
  exit 1
fi

#引数を取得
log_dir=$1
log_name=$2
generation_number=$3

####################################################
#
# 2. ログローテート処理
#
####################################################

# 現在のログファイルの個数を取得する
logfile_count=$(ls -1 ${log_dir}/${log_name}* 2>/dev/null | wc -l)

# 古いログを新しい番号にリネーム(N ⇒ N+1)
for count in $(seq $((generation_number - 1)) -1 1); do
  if [ -f "${log_dir}/${log_name}.${count}" ]; then
    mv "${log_dir}/${log_name}.${count}" "${log_dir}/${log_name}.$((count + 1))"
  fi
done

# 最新のログファイルを.1にリネーム
if [ -f "${log_dir}/${log_name}" ]; then
  mv "${log_dir}/${log_name}" "${log_dir}/${log_name}.1"
fi


# 新規ログファイルを作成
touch "${log_dir}/${log_name}"

####################################################
#
# 3. 世代数の管理
#
####################################################

# 現在のログファイルの個数を取得する
logfile_count=$(ls -1 ${log_dir}/${log_name}* 2>/dev/null | wc -l)

# 世代数を超えていたら、古いファイルを削除
if [ ${logfile_count} -gt ${generation_number} ]; then
  diff_count=$(( ${logfile_count} - ${generation_number} ))
  ls -1tr "${log_dir}/${log_name}"* | head -n ${diff_count} | xargs -r rm -f
fi

echo "${shell_name}:  END" >> ${shell_name}.log

exit 0
