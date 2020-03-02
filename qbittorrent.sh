#!/bin/bash
# FileName: qbittorrent.sh
#
# Author: rachpt@126.com
# Version: 0.2v
# Date: 2020-03-02
#
#--------------------------------------#
qb_login="${qb_HOST%/}:$qb_PORT/api/v2/auth/login"  # 登录
qb_add="${qb_HOST%/}:$qb_PORT/api/v2/torrents/add"  # 添加
qb_delete="${qb_HOST%/}:$qb_PORT/api/v2/torrents/delete"  # 删除
qb_info="${qb_HOST%/}:$qb_PORT/api/v2/torrents/info"  # 信息
qb_pause="${qb_HOST%/}:$qb_PORT/api/v2/torrents/pause"  # 暂停
qb_reans="${qb_HOST%/}:$qb_PORT/api/v2/torrents/reannounce"  # 汇报
qb_resume="${qb_HOST%/}:$qb_PORT/api/v2/torrents/resume"  # 开始
qb_recheck="${qb_HOST%/}:$qb_PORT/api/v2/torrents/recheck"  # 重新校验
#--------------------------------------#
[[ $ROOT_PATH ]] && {
  qb_Cookie="$(cat "${ROOT_PATH%/}/qb.cookie" 2>/dev/null)"
} || {
  ROOT_PATH="$(pwd)"
  qb_Cookie="cookie: example"
}
debug_Log="${ROOT_PATH%/}/debug.log"
#--------------------------------------#
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
    sleep 1
    if [[ "$1" ]]; then
        http --ignore-stdin -f POST "$qb_reans" hashes="$1" "$qb_Cookie"
    else
        http --ignore-stdin -f POST "$qb_reans" hashes=all "$qb_Cookie"
    fi
}
#--------------------------------------#
qb_resume_torrent() {
    [[ "$1" ]] && {
      qbit_webui_cookie
      sleep 1
      http --ignore-stdin -f POST "$qb_resume" hashes="$1" "$qb_Cookie"
    }
}
#--------------------------------------#
qb_pause_torrent() {
    [[ "$1" ]] && {
      qbit_webui_cookie
      sleep 1
      http --ignore-stdin -f POST "$qb_pause" hashes="$1" "$qb_Cookie"
    }
}
#--------------------------------------#
qb_recheck_torrent() {
    [[ "$1" ]] && {
      qbit_webui_cookie
      sleep 1
      http --ignore-stdin -f POST "$qb_recheck" hashes="$1" "$qb_Cookie"
    }
}
#--------------------------------------#
qb_delete_torrent() {
    [[ "$1" ]] && {
      qbit_webui_cookie
      sleep 1
      http --ignore-stdin -f POST "$qb_delete" hashes="$1" \
          deleteFiles=false "$qb_Cookie"
      debug_func "qb:del:[$1]"  #----debug---
    }
}

#---------------------------------------#
qb_get_hash() {
  # $1 name; $2 tracker; return hash(echo)
  local _data _hash _one _pos
  qbit_webui_cookie
  sleep 1
  _data="$(http --ignore-stdin --pretty=format -bf POST "$qb_info" sort=added_on reverse=true \
    "$qb_Cookie"|sed -E '/^[ ]*[},]+$/d;s/^[ ]+//;s/[ ]+[{]+//;s/[},]+//g'| \
    grep -B18 -A19 'name":'|sed -E \
    '/"hash":/{s/"//g};/"name":/{s/"//g};/"tracker":/{s/"//g};'|sed '/"/d')" 

  echo "$_data"|sed -n "/name.*$1/="|while read _pos; do
    _hash="$(echo "$_data"|head -n $(($_pos - 1))|tail -1|sed -E 's/hash:[ ]*//')"
    _one="$(echo "$_data"|head -n $(($_pos + 1))|tail -1|sed -E 's/tracker:[ ]*//;s/passkey=.*//')"
    [[ "$(echo "$_one"|grep "$2")" ]] && echo "$_hash" && break
  done
}

#---------------------------------------#
qb_add_torrent_url() {
  # add url
  qbit_webui_cookie
  sleep 1
  debug_func 'qb:add-from-url'  #----debug---
  http --ignore-stdin -f POST "$qb_add" urls="$1" root_folder=false \
    savepath="$2" skip_checking=false "$qb_Cookie"
}
#---------------------------------------#
qb_add_torrent_file() {
  # add file
  qbit_webui_cookie
  sleep 1
  debug_func 'qb:add-from-file'  #----debug---
  http --ignore-stdin -f POST "$qb_add" root_folder=false \
      name@"$1" savepath="$2" "$qb_Cookie"
}

#---------------------------------------#
