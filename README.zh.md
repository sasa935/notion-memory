# notion-memory(中文说明)

> 一份**所有 AI 工具、所有电脑共享**的记忆 —— 存在**你自己的 Notion** 里。
> English version: [README.md](README.md)

## 解决什么痛点
你在多台电脑、多个 AI 工具(Claude Code / Claude Desktop / Cowork / Codex)之间来回干活:踩过的坑、部署步骤、端口、那些记不住的命令行参数,全散落、对不齐,换台电脑就找不着。

notion-memory 把这些**可复用的运维知识**统一沉淀进你的 **Notion**(云端,天然跨机器),让每个 AI 工具都读写**同一份**记忆。规则写在一个 skill 里,改一次、处处生效。

## 🪄 一键安装(不会编程也行)
打开 **Claude Code / Claude Desktop / Codex**,把这句话发给它:

> 请按 https://github.com/sasa935/notion-memory 的 AI-INSTALL.md 帮我安装 notion-memory,
> 每一步用大白话解释,需要我亲自点的地方(比如登录 Notion)再叫我。

它会自动帮你 clone、装好、配好 hook,并带你连 Notion。详见 [AI-INSTALL.md](AI-INSTALL.md)。

## 手动安装(会一点命令行的话)
```bash
git clone https://github.com/sasa935/notion-memory ~/notion-memory
cd ~/notion-memory && ./install.sh
```
然后两步:
1. **连 Notion**:Claude 设置 → Connectors 连 Notion;Codex 开 notion 插件。没账号就去 https://www.notion.so 免费注册。
2. **设记忆笔记本**:编辑 `~/.config/ai-memory/config` 的 `NOTION_MEMORY_ROOT`。

## 怎么用
任何对话里搞定一件值得记的事,就说一句"**存到 Notion**"或敲 **/sync-memory**。它按"任务 → 子主题"整理后写进你的 Notion。**绝不自动写,你始终掌控。**

## 跨电脑共享
另一台电脑同样 `clone + ./install.sh + 连 Notion`,大家共享同一份记忆。改了 skill 就 `git push`,各机器开工时自动 `git pull`。详见 [docs/second-machine.md](docs/second-machine.md)。

## 它怎么工作 / 触发设计
见 [docs/triggers.md](docs/triggers.md)。一句话:记忆写入是**手动触发**(可靠、不依赖你关不关对话);skill 更新走 git 自动拉取。

## 想要全自动(可选,实验性)
`./enable-autosync.sh` 开启"对话结束自动同步";`./disable-autosync.sh` 关闭。建议先连好 Notion、测过再开。

## 卸载
`./uninstall.sh` —— 移除本机软链与 hook,**不动**仓库和你的 Notion 数据。

## 隐私与安全
- 除了写进**你自己的** Notion,数据**不发去任何其它地方**。
- 系统**不会自动写入**,全部由你触发。
- **别在记忆里存明文密钥/密码**,只记"在哪取"。

## 许可证
[MIT](LICENSE)。
