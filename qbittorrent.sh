#!/bin/bash
# FileName: qbittorrent.sh
#
# Author: rachpt@126.com
# Version: 0.1v
# Date: 2019-06-05
#
#--------------------------------------#
qb_login="${qb_HOST}:$qb_PORT/api/v2/auth/login"
qb_add="${qb_HOST}:$qb_PORT/api/v2/torrents/add"
qb_delete="${qb_HOST}:$qb_PORT/api/v2/torrents/delete"
qb_lists="${qb_HOST}:$qb_PORT/api/v2/torrents/info"
qb_pause="${qb_HOST}:$qb_PORT/api/v2/torrents/pause"
qb_reans="${qb_HOST}:$qb_PORT/api/v2/torrents/reannounce"
#--------------------------------------#
debug_Log="$ROOT_PATH/debug.log"
debug_func() {
  # set true to debug, false to close
  if false; then
    echo "[$(date '+%m-%d %H:%M:%S')]：$*" >> "$debug_Log"
  fi
}
#--------------------------------------#
qbit_webui_cookie() {
  if [[ "$(http --ignore-stdin -b GET "${qb_HOST}:$qb_PORT" "$qb_Cookie"| \
    grep 'id="username"')" ]]; then
    qb_Cookie="cookie:$(http --ignore-stdin -hf POST "$qb_login" \
        username="$qb_USER" password="$qb_PASSWORD"| \
        sed -En '/set-cookie:/{s/.*(SID=[^;]+).*/\1/i;p;q}')"
    # 更新 qb cookie
    if [ "$qb_Cookie" ]; then
      echo "$qb_Cookie" > "$ROOT_PATH/qb.cookie" 
    else
      debug_func 'qb:failed-to-get-cookie'  #----debug---
    fi
    debug_func 'qb:update-cookie'  #----debug---
  fi
}

#--------------------------------------#
qb_reannounce() {
    qbit_webui_cookie
    if [[ "$1" ]]; then
        http --ignore-stdin -f POST "$qb_reans" hashes="$1" "$qb_Cookie"
    else
        http --ignore-stdin -f POST "$qb_reans" hashes=all "$qb_Cookie"
    fi
}
#--------------------------------------#
qb_pause_torrent() {
    qbit_webui_cookie
    [[ "$1" ]] && \
    http --ignore-stdin -f POST "$qb_reans" hashes="$1" "$qb_Cookie"
}
#--------------------------------------#
qb_delete_torrent() {
    qbit_webui_cookie
    # delete torrent, need a parameter; used in clean/qb.sh
    http --ignore-stdin -f POST "$qb_delete" hashes="$1" \
        deleteFiles=false "$qb_Cookie"
    debug_func "qb:del:[$1]"  #----debug---
}

#---------------------------------------#
qb_get_hash() {
  # $1 name; $2 tracker; $3 qb info lists; return hash(echo)
  local _hash _one _pos
  echo "$3"|sed -n "/name.*$1/="|while read _pos; do
    _hash="$(echo "$3"|head -n $(($_pos - 1))|tail -1|sed -E 's/hash:[ ]*//')"
    _one="$(echo "$3"|head -n $(($_pos + 1))|tail -1|sed -E 's/tracker:[ ]*//;s/passkey=.*//')"
    [[ "$(echo "$_one"|grep "$2")" ]] && echo "$_hash" && break
  done
}

#---------------------------------------#
qb_add_torrent_url() {
  sleep 3
  qbit_webui_cookie
  # add url
  debug_func 'qb:add-from-url'  #----debug---
  http --ignore-stdin -f POST "$qb_add" urls="$1" root_folder=false \
    savepath="$2" skip_checking=false "$qb_Cookie"
}
#---------------------------------------#
qb_add_torrent_file() {
  sleep 3
  qbit_webui_cookie
  # add file
  debug_func 'qb:add-from-file'  #----debug---
  http --ignore-stdin -f POST "$qb_add" root_folder=false \
      name@"$1" savepath="$2" "$qb_Cookie"
}

#---------------------------------------#

