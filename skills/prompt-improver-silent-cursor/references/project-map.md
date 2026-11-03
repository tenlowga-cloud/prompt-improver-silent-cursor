# Project map template

Write it at `.cursor/conductor/PROJECT-MAP.md` for every job bigger than quick. Update the existing one instead of writing a second. Keep it short; it is a work order, not a report.

Also write `.cursor/conductor/state.json`:

```json
{ "job": "<one line>", "status": "working", "slices_open": 3, "updated": "<ISO time>" }
```

Set `status` to `done` when every slice is done and checked, or `waiting` when a gate needs the user. The `stop` hook keeps the chat going while `status` is `working`.

---

```markdown
# Project map: <job in a few words>

Updated: <date time>   Status: working | waiting on user | done

## Goal
<the finished result, in the user's words>

## Done means
- <what exists, where, what it shows, which state: committed / PR / merged / deployed>

## Sections of the prompt
1. <outcome> (kind, size)
2. ...

## Answers from the user
- <question>: <answer>   (or "none needed")

## Slices
| # | Outcome | Owner (agent) | Model | Files owned | Waits on | Done means | Status |
|---|---|---|---|---|---|---|---|
| 1 | | scout | gemini-3.8-flash | read-only | - | file list in map | open |
| 2 | | builder | grok-4.7 | src/... | 1 | tests pass | open |
| 3 | | reviewer | claude-sonnet-5-5 | read-only | 2 | review notes, no blockers | open |

## Gates
- <anything that needs the user before it happens>

## Proof
- <commands, screenshots, PR links, filled in as they land>

## Decisions made without asking
- <one line each, so the user can overrule>
```
