# First-run setup

Run this once, the first time the skill sees no config. Ask **one question at a time**, with your pick first and marked "(Recommended)". Check what you can yourself before asking. When a step needs a click only the user can make, give them the exact path, wait for "done", then check it.

Keep each message to three short lines or fewer. Use plain words.

## Step 1. Where are you working?

Ask: "Where will you use this most?"
- Grok Bot, with Cursor doing the code (Recommended)
- Cursor desktop
- Both the same amount

Save as `home`.

## Step 2. Your Cursor plan

Ask: "Which Cursor plan are you on?" Options: Ultra / Premium / Pro or Plus / Teams or Enterprise / Not sure.

If "Not sure": tell them to open cursor.com/dashboard, the plan name is at the top. What it changes:
- **Free or Plus**: no Cloud Agents and no third-party models. The skill runs local subagents on Cursor models only. Say so plainly and offer the upgrade path once; do not push.
- **Legacy request-based plan**: subagents run on Composer whatever their model says. Note it.
- **Teams / Enterprise**: Auto has Balance and Intelligence modes; team rules and team marketplaces exist.

Save as `plan`.

## Step 3. Turn on the models

Many third-party models are hidden by default. Walk them through:
1. Cursor > Settings > Models.
2. Turn on: Claude Opus 5.5, Claude Sonnet 5.5, Claude Haiku 5.5, Claude Fable 5.1, Gemini 4 Argon, Gemini 3.8 Flash. Grok 4.7 and Composer 2.5 are on already.
3. Reply "done".

Then check: open the model picker yourself if you can, or ask them to paste the list they see. Compare to the ids in `references/models/cursor-roster.md`. If an id differs, fix the `model:` line in that agent file (`.cursor/agents/` or the plugin's `agents/`) and say which you changed.

Save the list as `models_enabled`.

## Step 4. Spending limit

Ask: "How much can the AI spend per job before it asks you?" Options: $5 (Recommended) / $20 / $1 / No limit.

Also tell them Cursor asks for an on-demand spend limit the first time Cloud Agents run; set it at cursor.com/dashboard > Usage. Save as `budget_per_job_usd`.

## Step 5. GitHub to Cursor

Cloud Agents work on a GitHub repo and open pull requests.
1. Check: does this folder have a GitHub remote? (`git remote -v`). If not, ask which repo to use, or offer to create one.
2. Walk them through: cursor.com/dashboard > Integrations > GitHub > Connect. Install the Cursor GitHub App on the repos they want agents to use.
3. Bugbot: same page, turn on Bugbot for those repos so every PR gets a review.

Save `repos`.

## Step 6. Link Grok Bot to Cursor (the important one)

Skip if `home` is Cursor only and they do not use Grok Bot.

1. **Grok Bot is on.** Open the Grok Bot app (download from cursor.com/dashboard/bot if needed) and sign in with the same Cursor account.
2. **Privacy Mode (Legacy) is off.** It blocks Grok Bot. Teams: Team Settings. Individuals: Cursor Settings > Privacy.
3. **Cloud Agent spawning is on.** cursor.com/dashboard > Grok Bot page > Cloud Agents switch. It is on by default; check it.
4. **See the agents it starts.** In Cursor's Agents list, open the filter menu and turn on Source > Grok Bot. Bot-launched agents are hidden until you do.
5. **Put this plugin in the repo.** Cloud Agents read the repo's `.cursor/` folder, not your laptop. From the plugin's repo, run `scripts/install.sh --project <repo path>`, commit `.cursor/`, push. Now every Cloud Agent the Bot launches loads the same gate.
6. **Give the Bot the gate.** Paste `references/grok-bot-description.md` into the Bot's description (Bot settings > Description). Then in chat, say: "Save the following as a private skill named prompt-improver-silent-cursor" and paste `references/grok-bot-skill.md`. If the Bot cannot find it later: Connect apps > connected count > Private skills > enable it.
7. **Prove it.** Ask the Bot: "Start a Cursor cloud agent on <repo> that adds one line to README saying 'conductor link test' and opens a PR." Wait for the PR link. Check the agent shows in Cursor's list. Close the PR without merging.

Save `grok_bot_linked: true` with the PR link as proof.

## Step 7. Optional links

Ask once, as a multi-select: "Want any of these hooked up too?"
- Slack (Grok Bot routines can be triggered from Slack; Slack must be connected on the Cursor account that owns the Bot)
- Google Docs / Sheets / Slides (Grok Bot Connect apps)
- An MCP server the team uses (Cursor > Settings > MCP; Cloud Agents use the team MCP list at cursor.com/agents, not local servers)
- None for now (Recommended)

Walk through only what they pick.

## Step 8. How you want to hear back

Ask: "When I finish a job, how much do you want to read?" Options: 3 lines and the link (Recommended) / A short list of what changed / Full detail.

Save as `report_style`.

## Step 9. Save and confirm

Write `~/.cursor/conductor/config.json` (and `.cursor/conductor/config.json` in the repo, minus anything private) from `config.example.json`. In Grok Bot, save the same answers as a private skill note named `conductor-config`.

Tell the user in one line: setup is done, then start the job they first asked for.

## Re-running setup

Run a step again when its link breaks (a model id falls back, Cloud Agents fail to start, the Bot cannot see the skill). Fix that one step; do not redo the rest. The user can also say "redo setup".
