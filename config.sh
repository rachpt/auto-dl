#!/bin/bash
# FileName: qbittorrent.sh
#
# Author: rachpt@126.com
# Version: 0.1v
# Date: 2019-06-14
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
trorrent='your torrent`s name' # use transmission-show get it
tracker='tracker.totheglory.im' # 限定站点
tr_file_path="$ROOT_PATH/add.torrent" # 用于反复添加的种子文件
null_path="/dev/qb/"
#--------------------------------------#
# null file
[[ -c "${null_path%/}/$torrent" ]] || {
    [[ -d $null_path ]] || sudo mkdir "$null_path"
    echo '请输入当前用户密码！'
    sudo mknod "${null_path%/}/$torrent" c 1 3 # 创建空设备文件，和/dev/null作用一样
    sudo chmod 777 "${null_path%/}/$torrent" # 修改权限
}
#--------------------------------------#

