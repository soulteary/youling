# 幽灵（Ghost）

> 既然官方不喜欢非英文用户，那么就不提PR了，顺便换个非英文名字好啦。

Ghost CJK Version, IME BUGFIX.

## 使用方法

执行 `./sync-assets.sh`，项目目录中将自动构建出程序补丁，并放置于 `docker-assets` 目录中。

接着使用文件挂载的方式将构建出的内容挂载到官方容器镜像中即可，为了简单，这里使用 `docker-compose` 作为示例，可参考 `docker-compose.yml` / `docker-compose.local.yml`。

## 相关文档

- [修理 Ghost 中文输入法的 BUG](https://soulteary.com/2020/01/19/bugfix-for-ghost-editor-cjk-input.html)
