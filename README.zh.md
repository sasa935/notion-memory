# notion-memory(中文说明)

> 一份跨所有 AI 助手、所有电脑共享的**长期记忆** —— 存在**你自己的 Notion** 里。
> English version: [README.md](README.md)

## 解决什么痛点
你在多台电脑、多个 AI 工具(Claude Code / Claude Desktop / Cowork / Codex)之间来回干活。那些你以后还想再翻到的东西——项目文档与架构决策、辛苦攒下的部署/运维经验(端口、配置、记不住的命令行参数)、甚至非工作的事(规划的一趟旅行、买过的东西)——全散落、过时,换工具换电脑就找不着。

这**不是**工具自带的"会话临时记忆"。**notion-memory 是你自己的长期知识库**——一个跨工具、跨电脑的第二大脑,存在你自己的 Notion 里,让所有 AI 助手读写**同一份**记忆。规则写在一个 skill 里,改一次、处处生效。

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
任何对话里产生了你以后还想要的东西——一个项目决策、一段部署步骤、一份旅行计划,什么都行——就说一句"**存到 Notion**"或敲 **/sync-memory**。它按"领域 → 子主题"整理后写进你的 Notion。**绝不自动写,你始终掌控。**

## 能往里存什么
- **项目**:概览、技术栈、链接、状态、**文档、架构设计、决策**(轻量项目管理台,每个项目一块地方)。
- **技术 / 运维**:部署、端口、配置、**精确命令行参数**、踩过的坑(阿里云、Cloudflare…)。
- **生活**:旅行、购物、计划、偏好——任何值得记的。

## 跨电脑共享
另一台电脑同样 `clone + ./install.sh + 连 Notion`,共享同一份记忆。改了 skill 就 `git push`,各机器开工时自动 `git pull`。详见 [docs/second-machine.md](docs/second-machine.md)。

## 它怎么工作 / 触发设计
见 [docs/triggers.md](docs/triggers.md)。一句话:记忆写入是**手动触发**(可靠、不依赖你关不关对话);skill 更新走 git 自动拉取。

## 想要全自动(可选,实验性)
`./enable-autosync.sh` 开"对话结束自动同步";`./disable-autosync.sh` 关。建议先连好 Notion、测过再开。

## 卸载
`./uninstall.sh` —— 移除本机软链与 hook,**不动**仓库和你的 Notion 数据。

## 隐私与安全
- 除了写进**你自己的** Notion,数据**不发去任何其它地方**。
- 系统**不会自动写入**,全部由你触发。
- **别在记忆里存明文密钥/密码**,只记"在哪取"。

## 许可证
[MIT](LICENSE)。
