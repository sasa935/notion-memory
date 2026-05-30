---
name: notion-memory
description: Shared cross-tool, cross-machine memory backed by Notion. Use this skill to SAVE hard-won operational knowledge (deployment steps, ports, server configs, exact CLI flags with required/optional args, pitfalls and workarounds — especially for less-mature products like Alibaba Cloud / 阿里云) and to RECALL it before related work. Always organize by task/topic and sub-topic, never by date. Trigger when the user asks to sync/save/update memory (e.g. "同步到 Notion", "存一下", "/sync-memory"), when a session produced reusable operational knowledge worth keeping, or when starting a task that may already be documented in memory.
---

# Notion 记忆中枢(notion-memory)

跨工具(Claude Code / Cowork / Claude Desktop / Codex)、跨电脑共享的记忆系统。所有记忆存在 **Notion**(单一真相源,天然跨机器同步),通过 **Notion MCP** 读写。本 skill 不管"怎么连 Notion"(那是 MCP 的事),只管 **"该不该写、写什么、写到哪、怎么不写乱"**。

## 一、什么时候用
- **保存(SAVE)**:用户说"同步/保存/更新记忆""存一下""/sync-memory",或一段对话产生了**值得复用的运维知识**。
- **召回(RECALL)**:开始新任务前,**先搜一下** Notion,看这个主题是否已有记录,避免重复踩坑、重复问。

## 二、只存"值得复用的运维知识",不存废话(最关键)
**要存** ✅
- 部署步骤、端口、域名、环境变量、服务器/网络配置
- **精确命令行**:命令 + 参数,**哪些必填、哪些可选**(逐字保留,不要改写)
- 踩过的坑 + 解决办法;某产品的怪异行为(尤其阿里云这类不够成熟的产品)
- 凭证的**位置/获取方式**(不要存明文密钥本身)

**不存** ❌:闲聊、临时调试、模型本来就会的通用知识、一次性的东西。

> 判断标准:**"下次我、或另一台电脑/另一个工具再做这件事,会不会想直接查到它?"** —— 会就存,不会就跳过。这条让**自动触发也不会写乱**。

## 三、按"任务→子主题"组织,绝不按时间
- 结构 = `任务/主题` → `子主题`。例:`部署:阿里云 ECS` → `安全组端口` / `aliyun CLI 常用命令` / `踩过的坑`。
- **绝不按日期建条目**(同一件事今天做一点、明天做一点,按时间会碎成一地)。
- 同一主题永远**更新同一处**,不新开。

## 四、写入算法(UPSERT:先搜 → 改 或 建)
1. **搜**:用 Notion MCP 搜目标 `任务/子主题`(用稳定标题/slug 匹配,别用模糊措辞)。
2. **命中** → 取出该页 → **就地合并更新**(新信息并进去、保留原有有用内容、去重),不要新建重复页。
3. **未命中** → 在正确父级下**新建**,标题用稳定的 `任务:子主题` 形式。
4. 命令/配置**逐字**写进代码块;说明力求简洁。
5. 每次写入更新**溯源字段**:`Last-updated`(日期)、`Updated-by`(工具+机器,如 `Claude Code @ MacBook`)、`Last-verified`(可选)。

## 五、多端并发安全(必须遵守,否则会互相覆盖)
- **稳定 key**:用 `任务:子主题` 的固定标题/slug 做匹配键,杜绝重复主题。
- **细粒度**:一个子主题 = 一页(或数据库里一行)。**因为 hosted Notion MCP 不支持 block 级编辑、`update-page` 往往是整页重写**——粒度越细,不同电脑/工具同时更新时越不会互相盖。
- **更新前先取最新**:fetch 当前内容 → 在其基础上合并 → 写回(别凭记忆覆盖)。
- 页面保持小而专,缩小整页重写的冲突面。

## 六、记忆存到 Notion 哪里(配置)
- 优先读 `~/.config/ai-memory/config` 里的 `NOTION_MEMORY_ROOT`(记忆根页面/数据库的名字或 ID)。
- 若无配置:搜索用户 Notion 里名为 **"AI Memory"**(或用户指定)的记忆笔记本作为根;**找不到就先问用户**根放哪,别乱建。

## 七、召回示例
开始"在阿里云上部署 X"前:先用 Notion MCP 搜 `部署:阿里云`,把命中的端口/命令/坑读进上下文,再动手。

## 八、被 hook 自动调用时的约定
- **静默执行**第二节的判断:没有值得存的就**什么都不做、不打扰用户**;有就按 UPSERT 存,并用一两句简短告知存了哪几条(到哪个主题)。
