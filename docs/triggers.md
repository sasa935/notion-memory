# 触发设计:什么时候同步

核心原则一句话:**只在"你在用电脑"的会话事件上触发,永远别用挂钟定时(cron)。**

## 为什么不用定时(cron)
"每天晚上定时把记忆同步到 Notion"听起来合理,但有两个硬伤:
1. **电脑可能没开** —— 定时点到了你机器是关的,根本不触发。
2. **和知识产生的时刻脱节** —— 记忆应该在"你刚搞定一件事、知识新鲜"的时候沉淀,而不是几小时后由一个闹钟来收尾。

会话事件(SessionStart / SessionEnd / Stop)只在你**真的在用电脑**时才发生,天然绕开这两个问题。

## 两个不同的东西,两个不同的触发
| 同步什么 | 触发时机 | 机制 | 为什么 |
|---|---|---|---|
| **拉最新 skill**(GitHub→本地) | 开始工作时 | `SessionStart` → `git pull` | 每次开工都用最新规则;电脑没开就不需要拉 |
| **写记忆到 Notion**(本地→云) | 一段对话结束时 | `/sync-memory`(可靠)或 `SessionEnd`(自动) | 一次对话沉淀一次,不是每轮 |

## 频率:不要每轮、不要定时,而是"每段对话一次 + 内容自筛"
- **每轮(Stop 每次)太频繁** —— 否决。
- **每段对话一次(SessionEnd / 一键)** —— 正解。
- **内容自筛** —— skill 第二节写死"只存值得复用的运维知识,闲聊不存"。所以随手一问的对话**自动什么都不写**,频率由"有没有干货"自己调节,而不是由一个固定节奏决定。

## 各工具的 hook 支持(2026-05 查实)
| 面 | 连 Notion(MCP) | skill | 自动触发(hook) | 结论 |
|---|---|---|---|---|
| Claude Code | ✅ | ✅ | ✅ SessionStart/SessionEnd/Stop(15 事件) | 全自动可行 |
| Cowork | ✅ | ✅ | ✅ 经 plugin 的 agent 生命周期 hook | 自动可行 |
| Codex | ✅ | ✅ | ✅ hooks.json:Stop 等,官方明示可"自动生成持久记忆" | 自动可行 |
| Desktop Chat | ✅ | ✅(skill 跨面通用) | ❌ 无 hook(非 agentic 循环) | 半自动:靠 skill 自动调用 + 常驻指令,或手动一键 |

来源:[Cowork extensions](https://claude.com/docs/cowork/3p/extensions) · [Codex hooks](https://developers.openai.com/codex/hooks) · [Claude Code hooks](https://code.claude.com/docs/en/hooks)

## 机制细节
hook **本身不直接调工具**。它要么(a)运行一个脚本(可无人值守地跑一次 headless 同步),要么(b)注入一句指令让**模型用你的 skill + Notion MCP** 去写。本仓库默认用最可靠的 `/sync-memory` 一键(模型 + skill),`SessionEnd`/`Stop` 自动同步作为可选项(`enable-autosync.sh`),建议连好 Notion、测过之后再开。
