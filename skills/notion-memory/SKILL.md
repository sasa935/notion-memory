---
name: notion-memory
description: Your long-term personal memory / second brain, backed by Notion and shared across all your AI tools (Claude Code, Claude Desktop, Cowork, Codex) and computers. Use it to SAVE anything worth remembering long-term — project info, docs, architecture & design, decisions, technical/ops know-how (deploy steps, ports, configs, exact CLI flags, pitfalls), and non-technical life things (travel, purchases, plans, preferences) — and to RECALL it before related work. This is NOT the tool's short-term session memory; it is the user's durable knowledge base. Organize by area/topic → sub-topic, never by date. Trigger when the user asks to save/remember/sync (e.g. "存到 Notion", "记一下", "更新记忆", "/sync-memory"), or when starting something that may already be in memory.
---

# notion-memory — 你的长期个人记忆 / 第二大脑

把**任何你想长期留存的东西**统一存进 **Notion**(云端,天然跨机器),让你所有 AI 工具(Claude Code / Claude Desktop / Cowork / Codex)、所有电脑读写**同一份**记忆。

> 这不是工具自带的"会话临时记忆",而是**你自己的长期知识库**——像一个跟着你走的项目管理台 + 第二大脑。

## 一、什么时候用
- **保存(SAVE)**:用户说"存到 Notion / 记一下 / 更新记忆 / /sync-memory",或一段对话产生了**值得长期留存**的内容。
- **召回(RECALL)**:开始相关工作前,先搜一下 Notion,看是否已有记录。

## 二、存什么(范围很广,不止技术)
**核心判断:"以后我、或换台电脑/换个工具,会不会想再翻到它?"** —— 会就存。涵盖但不限于:

- **项目信息**:项目是什么、技术栈、链接、状态;**文档、架构设计、关键决策**(像个轻量项目管理台,每个项目一块地方)。
- **技术 / 运维**:部署步骤、端口、配置、**精确的命令行参数(哪些必填可选,逐字保留)**、踩过的坑(如阿里云、Cloudflare 这类)。
- **生活 / 非技术**:旅行计划与记录、AI 帮你买的东西、个人偏好、待办、想法……生活里的也行。
- **任何用户明确说"记一下"的东西。**

**不存** ❌:闲聊、一次性临时调试、模型本来就会的通用常识、明文密钥/密码(只记"在哪取")。

## 三、怎么组织:按"领域 → 子主题",绝不按时间
建议的顶层结构(灵活、可生长,别硬套):
```
AI Memory(根)
├── Projects / 项目
│   └── <项目名>
│       ├── 概览(是什么、技术栈、链接、状态)
│       ├── 架构与设计
│       ├── 运维与部署(端口、配置、命令、坑)
│       └── 决策与笔记
├── Tech / 运维(跨项目:阿里云、Cloudflare、工具…)
├── Life / 生活(旅行、购物、计划、偏好…)
└── …任何你需要的板块
```
- **绝不按日期建条目**(同一件事跨天会碎掉);同一主题永远**更新同一处**。

## 四、写入算法(UPSERT:先搜 → 改 或 建)
1. **搜** Notion 里的目标 `领域/子主题`(用稳定标题/slug 匹配)。
2. **命中** → 取出该页 → **就地合并更新**(并入新信息、保留原有有用内容、去重),不要新建重复页。
3. **未命中** → 在正确板块下**新建**,标题用稳定的 `领域:子主题` 形式。
4. 命令/配置/精确事实**逐字**保留(代码块);叙述简洁。
5. 每次写入更新**溯源**:`Last-updated`、`Updated-by`(工具+机器)、`Last-verified`(可选)。

## 五、多端并发安全(必守)
- **稳定 key**:固定标题/slug 做匹配,杜绝重复主题。
- **细粒度**:一个子主题 = 一页(或数据库一行)。因 hosted Notion MCP **无 block 级编辑、整页重写**,粒度越细越不会多端互相盖。
- **更新前先取最新** → 合并 → 写回(别凭记忆覆盖)。

## 六、记忆存到哪
- 读 `~/.config/ai-memory/config` 的 `NOTION_MEMORY_ROOT`(根页面/数据库名或 ID)。
- 没配置:搜名为 **"AI Memory"** 的根;找不到就**先问用户**根放哪,别乱建。

## 七、被 /sync-memory 或自然语言触发时
- **静默判断**第二节:没值得存的就**什么都不做、不打扰用户**;有就按 UPSERT 存,并用一两句简短说存到了哪个领域/主题。
- **绝不自动写**——只在用户触发时执行。

## 八、Notion 结构与格式标准(人 AI 都好读)
记忆根 **AI Memory** 下用 **PARA + 数据库驱动**:
- 📋 **Projects（数据库）** —— 每个项目一行;**元数据进属性**(AI 可直接筛/查),**细节进页面正文**(统一模板)。
- 🔧 **Tech & Ops** —— 跨项目的技术/运维(云、CI/CD、部署 SOP、通用踩坑)。
- 🌱 **Life** —— 生活/非技术(旅行/购物/计划/偏好)。
- 🗄️ **Archive** —— 做完/不活跃/旧备份。

### Projects 数据库属性
| 属性 | 类型 | 说明 |
|---|---|---|
| Name | 标题 | 项目名 |
| Status | 单选 | 在用 / 已上线 / 暂停 / 归档 |
| Type | 多选 | Agent / Web工具 / 平台 / 桌面工具 / 库·SDK |
| Stack | 文本 | 技术栈一行 |
| Cloud | 多选 | 阿里云 / Cloudflare / 腾讯云 / 本地 / Vercel |
| Ports | 文本 | 端口(本地/线上) |
| Repo | URL | 仓库地址 |
| Last updated | 日期 | 最后更新 |
| Updated by | 文本 | 工具+机器 |

### 项目页正文模板(固定章节顺序)
1. **概览** —— 是什么、给谁、解决什么
2. **架构与设计** —— 核心架构、关键决策(可带子标题)
3. **运维与部署** —— 本地启停、端口、配置、线上地址、部署步骤(命令逐字)
4. **踩坑** —— 每条「现象 → 原因 → 解法」,命令/报错逐字
5. **决策与笔记** —— 重要取舍(可选)
6. **更新记录** —— 反向时间,每条一句「本次改了啥」

### 写入时
- **元数据**(状态/云/端口/栈/更新)→ 数据库属性;**细节** → 页面对应章节。
- 跨项目通用的(某云 SOP、CI/CD、通用踩坑)→ 进 **Tech & Ops**,不塞进单个项目。
- 命令、配置、ID、URL、报错**逐字保留**(代码块)。
- 同一项目永远更新**同一行**;新踩坑并进「踩坑」、新进展并进「更新记录」,**不新开页、不按日期堆**。

## 九、用 Notion MCP 整理/写入时的实操注意(血泪经验)
真整理过一遍才知道的坑,照做能避开:
- **长内容 / 新页一律用 `create-pages`**(它正确处理 `\n`、表格、代码块)。**别用 `update-page` 的 `insert_content`/`replace_content` 写多行**——它会把 `\n` 吃成字面 "n"、把表格 `|` 转义,整段挤成一坨。
- **改已有页**:用 `update-page` 的 `update_content` 做定点 search-replace(`old_str` 和现有内容**精确匹配**,`new_str` 尽量单行)——这条稳。
- **⚠️ `allow_deleting_content: true` 会把不在 `new_str` 里的子页删进回收站!** 用之前务必:要么父页没有活子页,要么把全部子页用 `<page url="...">标题</page>`(**闭合标签**,非自闭合)列进 `new_str`。且**引用回收站里的页会报 `Failed to create block`**。
- **大块知识做成子页**(在某 section 下 `create-pages` 建子页),别全塞进一个超长 inline 正文——好读,也避开长内容写入失败。
- **属性值格式**:多选(Type/Cloud)传 JSON 数组字符串(如 `["Agent"]`);日期用展开键 `date:<列名>:start`;名为 `id`/`url` 的属性加 `userDefined:` 前缀。
- **删除/归档**:Notion MCP 没有干净的删除工具;`move-pages` 能搬,但**回收站里的页搬不动**。要删让用户在 Notion UI 里点删,或谨慎用 `allow_deleting`。
- **活项目放 Projects 数据库,Archive 只放真正不用的**;迁移完的旧自由页是冗余,清掉别留着,免得造成「我项目被归档了?」的错觉。

## 十、凭证 / 账号密码
- 默认**不存明文密钥/密码**,只记「在哪取」(`.env` / Keychain / 密码管理器)。
- 用户明确要汇总账号密码时:单独建一页、置顶安全提醒(建议迁 1Password/Bitwarden、别分享此页),且**绝不**让明文进入会被分享的页面或开源仓库。发现散落的明文密钥,提醒用户**轮换**。
