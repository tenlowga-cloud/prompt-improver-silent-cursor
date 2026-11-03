---
family: Grok (xAI / SpaceXAI, trained with Cursor)
verified: 2026-11-03
---
# Prompting card — Grok

Sources: docs.x.ai (Grok model pages, Grok Bot docs, skills and routines page), cursor.com/docs (models and pricing, Grok Bot for teams), first checked 2026-09-03, roster rechecked 2026-11-03. xAI publishes no general text prompting guide; the rules below come from their API docs, their voice-agent guide and the Bot and CLI docs.

**1. Models and surfaces**
- **Grok 4.7** (Cursor id `grok-4.7`): the default Cursor-built model for code. Jointly trained by Cursor and SpaceXAI for Cursor's tools. $2 / $6, 256k context; a 500k variant bills at 2x. Fast variants cost 2x. Comes out of the plan's included pool.
- **Grok 4.6 / 4.5**: older, same price. Use only if 4.7 is unavailable.
- **Grok Bot**: named cloud Bots with their own computer, apps (connectors), memory, skills and routines. Signs in through a Cursor account. Can launch **Cursor Cloud Agents** for code work.
- **Grok CLI ("Grok Build")**: terminal coding agent with AGENTS.md rules, skills, subagents and workflows.

**2. What is different about Grok**
- Reasoning cannot be turned off on Grok 4.5 and newer, only its depth: `reasoning_effort` low / medium / high (default) / xhigh.
- `presencePenalty`, `frequencyPenalty` and `stop` are rejected on reasoning models.
- Prompt caching is automatic but breaks if any earlier message is edited or reordered. Only append.
- Built-in tools (web_search, x_search, code_execution) run on the server. Do not hand-loop them.

**3. Prompt shape that works**
- Fixed sections: `## Role & Objective`, `## Instructions`, `## Output Format`. Short role, the task in the user turn.
- In Cursor, give Grok 4.7 a tight work order: the outcome, the exact files it owns, done-means, the test to run. It is fast and literal; it does well with clear file scope and badly with "look around and improve things".
- Grok Bot has two layers: the Bot **description** is the standing prompt (name, one job, boundaries); each chat message is the task. Memory is a cache, not the truth.

**4. Controls**
- `reasoning_effort` low / medium / high / xhigh. In a Cursor subagent use the bracket form if your plan allows it, for example `grok-4.7[effort=high]`; otherwise Cursor picks.
- `tool_choice` auto / required / none; `parallel_tool_calls: false` to run tools one at a time.

**5. Do / Don't**
- Do give each Bot one named job. Don't run one catch-all Bot.
- Do put standing rules in the Bot description. Don't rely on one chat message for a standing rule.
- Do give Grok 4.7 file ownership and a test. Don't hand it a whole vague feature with no done-means.
- Don't port OpenAI or Anthropic sampling settings onto a Grok reasoning model; they error.

**6. Pitfalls**
- Bot memory is not a source of truth per xAI's own docs.
- Auto Review "Require Approval" always beats "Always Allow".
- Running on the user's own computer is a separate permission from the Bot's cloud computer, default "ask every time".
- Passwords, 2FA and CAPTCHA go through the human "Agent Computer" takeover, never in chat.
- Cloud Agents launched by Grok Bot are hidden in Cursor's agent list until the user turns on Source > Grok Bot in the filter menu.

**7. Grok Bot specifics**
- Skills: one shared private library for all your Bots. Add one by asking the Bot to save a process as a named skill, by "Teach a task" (screen demo, ten minutes or less), or from **Connect apps**. If a Bot cannot find a skill, enable it for that Bot under Connect apps > Private skills.
- Routines: schedule or event triggers, run in the cloud while the laptop is closed. Up to 50 per Bot, at least five minutes apart, 300 runs an hour across all routines.
- Group chats of 2 to 6 Bots with @mention handoffs.
- Cloud Agent spawning: a switch on the Grok Bot page of the Cursor dashboard, on by default. Cloud Agents need a Premium plan or higher (not Free or Plus). Privacy Mode (Legacy) blocks Grok Bot.
