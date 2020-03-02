#!/bin/bash
# FileName: run.sh
#
# Author: rachpt@126.com
# Version: 0.2v
# Date: 2020-03-02
#
#----------import settings-------------#
ROOT_PATH="$(dirname "$(readlink -f "$0")")"
# if use source command run
[[ $ROOT_PATH == */bin* ]] && \
ROOT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
#--------------------------------------#
source "$ROOT_PATH/config.sh" # must before qbittorrent.sh
source "$ROOT_PATH/qbittorrent.sh"
#--------------------------------------#
[[ $COUNT -le 0 ]] && exit 0  # 到次数退出
[[ ${#2} -eq 40 && $2 == $TR_HASH ]] && {
  tr_hash="$2"
} || {
  qb_reannounce "$2"
  if [[ "$1" == "$trorrent_name" && "$3" =~ .*${trorrent_tracker}.* ]]; then
    [[ ${#2} -eq 40 ]] && {
      tr_hash="$2"
      sed -i "s/^TR_HASH=.*/TR_HASH=\"$tr_hash\"/" "$ROOT_PATH/config.sh"
    }
  fi
}
[[ $tr_hash ]] && {
  qb_reannounce "$tr_hash"
  sleep 8
  qb_pause_torrent "$tr_hash"
  sleep 4
  qb_reannounce "$tr_hash"
  qb_recheck_torrent "$tr_hash"
  sleep 8
  qb_resume_torrent "$tr_hash"
  sleep 12
  qb_reannounce "$tr_hash"
  ((COUNT--))
  sed -i "s/^COUNT=[0-9]*/COUNT=$COUNT/" "$ROOT_PATH/config.sh"
}
#--------------------------------------#
