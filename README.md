# auto-download

`qBittorrent` 自动刷下载量，并且数据 **不写入硬盘**。

据测试，用于刷下载量的种子大小与机器内存没有依赖关系。

需要安装 [httpie](https://httpie.org/)。改成 curl 也可以，懒……


## 使用

1. 配置好 `config.sh` 前面8行后，第一次需要使用`root`账户运行该文件，以便创建`字符设备文件`。

如果有必要，刷完后记得删掉创建的字符设备文件(即该目录下的null文件夹)。

torrent 内容建议是少文件种子。

2. 添加命令`/home/<user>/auto-dl/run.sh "%N" "%I" "%T"`到qbittorrent `Torrent 完成时运行外部程序`处。

3. 可以添加`crontab`任务，以便及时将下载量汇报给tracker计入统计。比如：
```sh
# 不建议使用，更不建议太快
*/6 *  * * * /home/<user>/auto-dl/run.sh >/dev/null 2>&1
```
## 其他

1. 推荐使用非免费的大体积的 原盘 ISO 文件刷，

2. 关闭 `qBittorrent` 的 `为不完整的文件添加扩展名 .!qB` 与 `为所有文件预分配磁盘空间`，

3. 因为不用预先分配磁盘，以及写入硬盘，下载速度几乎只与网络情况有关，如果有必要，注意在开始任务后限速。

4. 刷得量通过`config.sh`中的`COUNT`和用于任务的种子体积的乘积决定，

5. 刷完后，需要自己手动在`qBittorrent`中删掉任务，使用root账户删掉 `null` 目录下的文件(夹)，

6. 使用本脚本所造成的一切后果与本人无关。

## License

GPL-3
