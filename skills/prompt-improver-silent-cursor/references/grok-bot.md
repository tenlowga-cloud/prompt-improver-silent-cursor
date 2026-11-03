# Running the gate from Grok Bot

Grok Bot has no prompt hook. The gate runs on every message because the Bot's **description** says so (paste from `grok-bot-description.md`), and the full method lives in the private skill `prompt-improver-silent-cursor` (paste from `grok-bot-skill.md`).

## What the Bot does with each message

1. Reads the skill to the end (it is short on purpose; the deep references live in the repo).
2. Turns the message into the finished result, splits it into sections, asks only what is truly unclear, one question at a time.
3. Sorts each section:
   - **Code, UI, repo work** goes to Cursor as a **Cloud Agent** on the right repo. The Cloud Agent loads this plugin from the repo's `.cursor/` folder, so it runs the same gate, writes the project map, and builds its own subagent team with the right models.
   - **Inbox, docs, research packs, schedules, follow-ups** the Bot does itself, or in a routine.
4. Writes one brief per Cloud Agent (template in `team-playbook.md`). Names the model in the brief when it matters ("plan with Claude Opus 5.5, build with Grok 4.7"); the agent's own gate picks the rest.
5. Watches each Cloud Agent until it opens a PR, then checks it (Bugbot review, the PR diff, the proof in the PR body) before telling the user it is done.
6. Reports in the style saved in `conductor-config`.

## Limits to respect

- Cloud Agents need Premium or higher and Cloud Agent spawning on (setup step 6).
- Bot memory is a cache. The repo and the project map are the truth.
- Routines: at least five minutes apart, 50 per Bot.
- Passwords and 2FA go through Agent Computer takeover, never chat.
- Gates stay with the user: spending past the budget, sending to a person, deleting earlier work, production or main-branch changes, private customer data leaving its place.
