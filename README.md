# Prompt Improver (silent) for Cursor

A Cursor plugin that runs on **every prompt**, with no slash command. You type something short. It works out what you actually meant, asks only what is truly unclear (one question at a time), writes a project map, picks the best model in Cursor for each part of the job, runs a team of subagents and Cloud Agents, checks the work, and tells you in a few lines what got done.

It works from **Grok Bot** too: the Bot hands code work to Cursor Cloud Agents, and those agents run the same gate from your repo.

Models checked against Cursor's list on **2026-11-03**: Grok 4.7, Composer 2.5, Claude Opus 5.5, Sonnet 5.5, Haiku 5.5, Fable 5.1, Gemini 4 Argon, Gemini 3.8 Flash (GPT-5.6 as backup only).

## What it uses in Cursor

| Cursor feature | What it does here |
|---|---|
| Always-apply rule | Fires the gate on every prompt |
| `sessionStart` hook | Adds the gate, your config and any open project map to every chat |
| `stop` hook | Sends the agent back if the project map still has open slices |
| `subagentStop` hook | Logs each finished slice |
| Skill | The full method, model guides, setup and team playbook |
| 9 subagents, each with its own model | planner, scout, builder, quick-edit, debugger, reviewer, ui-checker, researcher, writer |
| Plan mode, worktrees, background subagents, Cloud Agents, Bugbot, browser | Used by the team playbook when the job calls for them |

## Install

You need Cursor and `python3` (already on macOS and most Linux).

```bash
git clone https://github.com/tenlowga-cloud/prompt-improver-silent-cursor
cd prompt-improver-silent-cursor

# Cursor desktop, every project on this computer (recommended):
./scripts/install.sh --plugin        # then in Cursor: Developer: Reload Window

# Each repo you want Cloud Agents and Grok Bot to use (needed for Grok Bot):
./scripts/install.sh --project ~/code/my-repo
cd ~/code/my-repo && git add .cursor && git commit -m "Add silent prompt gate" && git push
```

No plugin folder? `./scripts/install.sh --user` puts the skill, subagents and hooks in `~/.cursor` and prints a User Rule to paste in Cursor Settings > Rules.

Teams: add this repo as a team marketplace (Dashboard > Plugins & MCPs > Add Marketplace > Import from Repo).

## First run

Send any prompt. With no config, it walks you through setup one question at a time:

1. Where you work (Grok Bot, Cursor, both)
2. Your Cursor plan
3. Turning on the models (many are hidden by default)
4. Your spending limit per job
5. GitHub to Cursor, plus Bugbot
6. **Grok Bot to Cursor**: Privacy Mode (Legacy) off, Cloud Agent spawning on, the Grok Bot filter on in Cursor's agents list, the plugin in your repo, the Bot description and private skill pasted in, and a test agent that opens a PR to prove it
7. Optional: Slack, Google Docs, MCP servers
8. How much you want to read when a job finishes

Answers are saved to `~/.cursor/conductor/config.json` (and a `conductor-config` note in Grok Bot). Say "redo setup" any time.

## Grok Bot

Two paste-ins, both in `skills/prompt-improver-silent-cursor/references/`:

- `grok-bot-description.md` goes in the Bot's Description field. It tells the Bot to run the gate on every message.
- `grok-bot-skill.md` gets saved as a private skill in chat.

Cloud Agents need a Cursor Premium plan or higher.

## What it will never do without asking

Spend past your budget, send anything to another person, delete your earlier work, change production or the main branch, or move private customer data.

## Keeping it current

Model lists change monthly. The roster is `skills/prompt-improver-silent-cursor/references/models/cursor-roster.md`, with a `verified` date. If a model id is missing on your plan, Cursor falls back to a compatible model, and setup fixes the id.

## License

MIT
