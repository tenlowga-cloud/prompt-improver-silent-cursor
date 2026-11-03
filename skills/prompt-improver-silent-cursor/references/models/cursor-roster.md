---
verified: 2026-11-03
source: https://cursor.com/docs/models-and-pricing (fetched 2026-11-03)
---
# Cursor model roster

Which model in Cursor runs which slice. Prices are per million tokens, input / output, from Cursor's page on 2026-11-03.

## Two billing buckets

- **Cursor models** (Grok 4.7 / 4.6 / 4.5, Composer 2.5) come out of the plan's weekly included pool. Use them first when they can do the slice well.
- **Third-party models** (Claude, Gemini, GPT, others) bill at the API list price from prepaid credit, on Premium plans and up. Many are **hidden by default**: turn them on in Cursor Settings > Models (setup does this with the user).

## The picks

| Job | First pick | Backup | Price | Notes |
|---|---|---|---|---|
| Plan, project map, architecture, hard calls | Claude Opus 5.5, effort high | Claude Fable 5.1 | $4 / $20 | Thinking always on. Effort default is medium; set high for planning |
| Normal code build, multi-file change | Grok 4.7 | Claude Sonnet 5.5 | $2 / $6 (pool) | Trained with Cursor for its tools. 256k context, 500k variant at 2x |
| Fast small edit | Composer 2.5 | Grok 4.7 (Fast) | $0.5 / $2.5 (pool) | Cursor's own fast model |
| Hardest bug, beat one try | Claude Fable 5.1, effort high | Claude Opus 5.5 at xhigh | $10 / $50 | Expensive. Bounded brief only. Some security requests route to Opus |
| Code review (independent) | Claude Sonnet 5.5 | Gemini 4 Argon | $2 / $10 | Must be a different vendor than the builder |
| UI build and visual check | Claude Opus 5.5 | Claude Sonnet 5.5 | $4 / $20 | Give it the browser tool and a design spec |
| Research, long documents | Gemini 4 Argon | Gemini 3.1 Pro | $2 / $10 | Leave temperature at default |
| Wide search, file sweep | Gemini 3.8 Flash | Composer 2.5 | $0.75 / $3.75 | Read-only subagent |
| Writing people read | Claude Opus 5.5 | Claude Sonnet 5.5 | $4 / $20 | |
| Bulk classify, extract, route | Claude Haiku 5.5 | Gemini 3.8 Flash | $0.1 / $0.5 | 5x price over 100k input tokens |
| Very long context (over 500k) | Claude Opus 5.5 or Sonnet 5.5 (1M) | Gemini 4 Argon | | Long context often bills 2x |

## Model ids for subagent files

Cursor's subagent `model` field takes a model id, with optional settings in brackets, for example `claude-opus-5-5[effort=high]`. The ids used in `agents/` are below. If an id is not on the user's plan or is blocked, Cursor falls back to a compatible model on its own. Setup checks these against the user's picker and fixes any that differ.

| Model | id used |
|---|---|
| Claude Opus 5.5 | `claude-opus-5-5` |
| Claude Sonnet 5.5 | `claude-sonnet-5-5` |
| Claude Haiku 5.5 | `claude-haiku-5-5` |
| Claude Fable 5.1 | `claude-fable-5-1` |
| Grok 4.7 | `grok-4.7` |
| Composer 2.5 | `composer-2.5` |
| Gemini 4 Argon | `gemini-4-argon` |
| Gemini 3.8 Flash | `gemini-3.8-flash` |
| GPT-5.6 Sol | `gpt-5.6-sol` |

## Auto mode

- Individual plans get Auto in **Cost** mode only (bills as a Cursor model from the pool).
- Teams and Enterprise get **Balance** and **Intelligence** through Cursor Router.
- Known issue (forum, 2026): with the main chat on Auto or an old Composer, always-apply rules and subagent calls sometimes did not fire. If the gate does not seem to run on Auto, pick a named model for the main chat (Grok 4.7 or Claude Opus 5.5).

## Legacy plans

On legacy request-based plans without Max Mode, subagents run on Composer whatever the `model` field says. Setup asks about the plan and notes it.

## Watch list

- **GPT in Cursor.** OpenAI proposed ending Cursor's access on 2026-11-12. Not confirmed on Cursor's page as of 2026-11-03. GPT-5.6 Sol, Terra and Luna stay as backups only.
- **Also in the picker, not in the main picks:** Grok 4.6 / 4.5, Claude Opus 5 / 4.8 / Sonnet 5, Gemini 3.x Flash family, DeepSeek V4.1 Flash, GLM 5.3, Kimi K3, Meta Muse Wonder / Spark. Use one only if the user asks or the picks are unavailable.
