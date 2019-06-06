#!/bin/bash
# FileName: qbittorrent.sh
#
# Author: rachpt@126.com
# Version: 0.1v
# Date: 2019-06-06
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
trorrent='your torrent`s name'
tracker='tracker.totheglory.im'
tr_file_path="$ROOT_PATH/add.torrent"
null_path="/dev/qb/"
#--------------------------------------#
# null file
[[ -c "${null_path%/}/$torrent" ]] || {
    debug_func "需要输入密码创建特殊文件！！！"
    [[ -d $null_path ]] || sudo mkdir "$null_path"
    echo '请输入当前用户密码！'
    sudo mknod "${null_path%/}/$torrent" c 1 3
    sudo chmod 777 "${null_path%/}/$torrent"
}
#--------------------------------------#

