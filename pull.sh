#!/bin/sh

# 丢弃本地修改，强制拉取最新代码
git checkout -- .
git pull

# 删除本地bak文件夹，防止服务器加载
rm -rf bak
