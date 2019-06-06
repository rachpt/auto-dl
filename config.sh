#!/bin/bash
# FileName: qbittorrent.sh
#
# Author: rachpt@126.com
# Version: 0.1v
# Date: 2019-06-05
#
#--------------------------------------#
#---authoriz for qbittorrent---#
qb_HOST='http://127.0.0.1'
qb_PORT='8080'
qb_USER='admin'
qb_PASSWORD='adminadmin'
qb_Cookie="$(cat "$ROOT_PATH/qb.cookie" 2>/dev/null)"
#--------------------------------------#
# examples
trorrent='Chernobyl.S01E01.1.23.45.1080p.AMZN.WEB-DL.DDP5.1.H.264-NTb.mkv'
tracker='tracker.totheglory.im'
tr_file_path="$ROOT_PATH/add.torrent"
null_path="/dev/qb/$torrent"
#--------------------------------------#
# null file
[[ -c "$null_path" ]] || {
    debug_func "需要输入密码创建特殊文件！！！"
    [[ -d /dev/qb ]] || sudo mkdir /dev/qb
    echo '请输入当前用户密码！'
    sudo mknod "$null_path" -c 1 3
    sudo chmod 777 "$null_path"
}
#--------------------------------------#

