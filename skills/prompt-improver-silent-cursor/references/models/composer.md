---
family: Composer (Cursor)
verified: 2026-11-03
---
# Prompting card — Composer

Source: cursor.com/docs/models-and-pricing, 2026-11-03.

**1. Models**
- **Composer 2.5** (`composer-2.5`): Cursor's own fast coding model. $0.5 / $2.5 from the included pool. The cheapest way to make a small, clear change.
- **Composer 2.5 (Fast)**: $3 / $15. Only when speed matters more than cost.

**2. Use it for**
- One-file edits, renames, boilerplate, simple tests, applying a change a planner already spelled out.
- Read-only sweeps when Gemini Flash is not enabled.

**3. Do not use it for**
- Planning, architecture, a bug that already beat one try, or a review of another model's work.
- The main chat model for this skill: a 2026 forum report says always-apply rules and subagent calls sometimes did not fire with the chat on Composer or Auto. Use it inside subagents instead.

**4. Brief shape**
Exact file paths, the exact change, the check to run. No open-ended "improve this". If the change needs a judgment call, give that call to a stronger model and hand Composer the result.

**5. Legacy plans**
On legacy request-based plans without Max Mode, every subagent runs on Composer whatever its `model` field says. Plan briefs for that: smaller slices, more exact instructions.
