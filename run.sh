#!/bin/bash
# FileName: qbittorrent.sh
#
# Author: rachpt@126.com
# Version: 0.1v
# Date: 2019-06-05
#
#--------------------------------------#

#----------import settings-------------#
ROOT_PATH="$(dirname "$(readlink -f "$ 0")")"
# use source command run
[[ $ROOT_PATH == /*bin* ]] && \
ROOT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$ROOT_PATH/config.sh" # must before qbittorrent.sh
source "$ROOT_PATH/qbittorrent.sh"

#--------------------------------------#
qb_reannounce
#--------------------------------------#
if [[ "$1" = "$trorrent" ]]; then
  qbit_webui_cookie
  local data
  data="$(http --ignore-stdin --pretty=format -bf POST "$qb_lists" sort=added_on reverse=true \
   "$qb_Cookie"|sed -E '/^[ ]*[},]+$/d;s/^[ ]+//;s/[ ]+[{]+//;s/[},]+//g'| \
   grep -B18 -A19 'name":'|sed -E \
   '/"hash":/{s/"//g};/"name":/{s/"//g};/"tracker":/{s/"//g};'|sed '/"/d')" 

  tr_hash="$(qb_get_hash "$torrent" "$tracker" "$data")"
  [ "${#tr_hash}" -eq 40 ] && {
    qb_reannounce "$tr_hash"  
    sleep 10
    qb_pause_torrent "$tr_hash"
    sleep 10
    qb_reannounce "$tr_hash"  
    sleep 8
    qb_delete_torrent "$tr_hash"
    sleep 8
    qb_add_torrent_file "$tr_file_path" "$null_path"
  }
fi
#--------------------------------------#

