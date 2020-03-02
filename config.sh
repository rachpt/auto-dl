#!/bin/bash
# FileName: config.sh
#
# Author: rachpt@126.com
# Version: 0.2v
# Date: 2020-03-02
#
#--------------------------------------#
#--------------------------------------#
# 登录 qbittorrent webui
qb_HOST='http://127.0.0.1'
qb_PORT='8080'
qb_USER='admin'
qb_PASSWORD='adminadmin'
# 用于添加的种子文件信息
torrent_file="add.torrent"
# 种子 name-------------#
trorrent_name=""
# 种子部分 tracker------#
trorrent_tracker=""
COUNT=10       # 重复次数
#--------------------------------------#
#--------------------------------------#
trs='transmission-show'
make_null_files() {
    local null_path file_lists one_file
    null_path="${ROOT_PATH%/}/null"
    echo "字符文件路径是：${null_path}"
    [[ -f $torrent_file ]] && torrent_path="$torrent_file" || \
        torrent_path="${ROOT_PATH%/}/$torrent_file"
    file_lists="$($trs "$torrent_path"|sed '1,/^FILES$/ d;s/^ *//;s/ ([0-9\. kMGB]*)//i;/^$/d')"
    # make null files
    if [[ $file_lists ]]; then
        cd "$null_path"
        echo "$file_lists"|while read -r one_file; do
            [[ -c "$one_file" ]] && continue
            if [[ ${one_file%/*} ]]; then
                [[ -d ${one_file%/*} ]] || mkdir -p "${one_file%/*}"
            fi
            mknod "$one_file" c 1 3
        done
        chmod -R 777 "$null_path"  # 修改权限
    fi
}
#--------------------------------------#
TR_HASH=""
# 直接运行该脚本运行
[[ $ROOT_PATH ]] || {
    ROOT_PATH="$(dirname "$(readlink -f "$0")")"
    # use source command run
    [[ $ROOT_PATH == */bin* ]] && \
    ROOT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    if [[ $UID -ne 0 ]]; then
        ehco "请使用 root 运行该脚本！创建字符文件"
    else
        make_null_files
    fi
    sed -i "s/^TR_HASH=.*/TR_HASH=\"\"/" "$ROOT_PATH/config.sh"
}
# 如果有torrent文件，则自动设置需要的参数
if [[ $torrent_file && ! $trorrent_name && ! $trorrent_tracker ]]; then
    [[ -f $torrent_file ]] && torrent_path="$torrent_file" || \
        torrent_path="${ROOT_PATH%/}/$torrent_file"
    tr_name="$($trs "$torrent_path"|grep -m1 Name:|sed 's/Name: *//')"
    tr_tracker"$($trs "$torrent_path"|sed '1, /TRACKERS/d;\@.*//.*@!d;s/^ *//;{s/\([:/\.a-z0-9]*\).*/\1/i;q}')"
    sed -i "s/^trorrent_name=.*/trorrent_name=\"$tr_name\"/" "$ROOT_PATH/config.sh"
    sed -i "s/^trorrent_tracker=.*/trorrent_tracker=\"$tr_tracker\"/" "$ROOT_PATH/config.sh"
fi
