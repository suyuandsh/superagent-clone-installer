# DSH Go 分身 SuperAgent 安装包

在 DSH Go 分身里执行：

```sh
git clone https://github.com/suyuandsh/superagent-clone-installer.git /tmp/superagent-clone
sh /tmp/superagent-clone/install.sh
```

安装完成后打开 `http://127.0.0.1:3083`。

然后在分身里登录 GitHub：

```sh
gh auth login
```

面板里配置：

- 仓库：`suyuandsh/superagent-test`
- CLI：`gh`
- 模式：observe

端口 3083，避免和主 DSH 的 3080、主 SuperAgent 的 3082 冲突。
