# Team playbook: running the job inside Cursor

Use every part of Cursor that helps the job. This file says which part does what.

## The parts

| Cursor part | What it gives the team | When this skill uses it |
|---|---|---|
| **Always-apply rule** (`rules/prompt-conductor.mdc`) | Loads the gate on every prompt | Always. This is the trigger |
| **Hooks** (`hooks/hooks.json`) | `sessionStart` adds the gate and config to context; `stop` keeps the job going until the project map says done; `subagentStop` logs each slice | Always, installed by the plugin |
| **Skill** (this folder) | The full method and references | Read in full on every job that is not a pure chat reply |
| **Plan mode** | A written plan before any edit, with clickable questions | Big or unclear jobs. The plan is the project map |
| **Subagents** (`agents/`) | Parallel workers, each with its own model, context and permissions | Two or more independent slices |
| **Worktree isolation** | Each subagent on its own branch and folder | Any time two subagents might edit the same checkout |
| **Background subagents** (`is_background: true`) | Work that does not block the chat | Wide searches, research packs |
| **Cloud Agents** | A VM per agent, its own branch, opens a PR, keeps going when the laptop closes | Big slices, long runs, anything launched from Grok Bot |
| **Bugbot** | Automatic PR review | Every PR; its findings feed the reviewer slice |
| **Browser tool** | Drive the app, take screenshots | Proof for any UI change |
| **Codebase search, `@` mentions, git** | Find where things live | Step 2 of the skill, before asking anything |
| **MCP servers** | Outside tools (databases, docs, deploy) | When a slice needs one; cloud subagents use the team MCP list |
| **Commands** (`commands/`) | Shortcuts the user may type | Optional only. Nothing requires a command |
| **Checkpoints / restore** | Undo an agent's edits | Before a risky refactor, note the checkpoint |

## Cutting slices

- One owner per slice. No two workers edit the same file.
- Each slice has: outcome, files owned, model, done-means, proof, gates.
- Order: what waits on what. Run everything that does not wait at once, in one message (several Task calls in one message run at the same time).
- Start with two or three subagents. More costs more tokens and rarely finishes faster.
- A subagent launched by another subagent cannot launch more. Keep the tree flat: you launch everyone.

## The standard teams

**Quick fix (solo).** You do it on the chat model. Prove it. Done.

**Normal build.**
1. `scout` (read-only, background) maps the files.
2. `builder` on Grok 4.7 makes the change in a worktree.
3. `reviewer` (different vendor) checks the diff and runs the tests.
4. You merge the worktree, re-run proof, report.

**Big build.**
1. Plan mode. `planner` on Opus 5.5 writes the project map with you.
2. Questions to the user, one at a time, before anything starts.
3. Two or three `builder` slices in parallel, each in its own worktree, or as Cloud Agents if long.
4. `ui-checker` drives the browser on any screen that changed.
5. `reviewer` on each PR plus Bugbot.
6. You integrate, run the full proof, update the map, report.

**Stuck bug.** `debugger` on Fable 5.1 with a bounded brief: the symptom, what was tried, the files, the repro. One try only, then you decide.

**Research or writing.** `researcher` on Gemini 4 Argon collects sources in the background while `writer` on Opus 5.5 drafts from the project map. You check facts against the sources.

## Writing a brief

```
Outcome: <one line>
You own: <files or questions; touch nothing else>
Read first: .cursor/conductor/PROJECT-MAP.md, <other links>
Done means: <what exists, where, what it shows>
Proof: <test, build, screenshot>
Gates: do not merge, deploy, send to a person, spend past $<budget>, or delete earlier work.
When done: write your status line in PROJECT-MAP.md and return the proof.
```

Add the model card notes for the model running it (for example, Grok 4.7: exact files and a test; Opus 5.5: effort high for planning; Sonnet 5.5: run a real check before saying done).

## Checking work

- A slice counts when its output exists (commit, PR, file) and passes your check.
- The checker is never the builder, and never the same vendor when you can help it.
- A failed or silent lane: take the slice back, do it, say so in one line.
- Never retry a gate.

## Cost

- Cursor models (Grok, Composer) come from the included pool; third-party models bill at list price.
- Each subagent uses its own tokens. Parallel is faster, not cheaper.
- Keep the job under `budget_per_job_usd` from the config. If the plan would go over, ask before starting, with a cheaper plan as the first option.
