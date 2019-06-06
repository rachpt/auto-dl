# auto-download

qbittorrent 自动刷下载量，并且数据不真实写入硬盘。

效果待测试...

使用 添加命令`/home/raxhpt/Documents/auto-dl/run.sh  "%N"`到qbittorrent `Torrent 完成时运行外部程序`处。

需要安装 httpie。

配置好 `config.sh` 后，第一次需要手动运行以便创建`空设备`。

torrent内容必须是当个文件！

可以添加`crontab`任务，以便及时将下载量汇报给tracker计入统计。

